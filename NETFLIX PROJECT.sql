-- Creating a database. 
	IF OBJECT_ID('Netflix') IS NOT NULL DROP DATABASE Netflix--Ensures theres is no database inthe same and if it exists it is dropped.
	CREATE DATABASE Netflix
	GO

-- Selecting database.
	USE Netflix
	GO

-- Creating table schemas.
      IF OBJECT_ID('netflix') IS NOT NULL DROP TABLE netflix --Ensures theres is no table with the same name inthe database inthe same and if it exists it is dropped.
      CREATE TABLE netflix(
		show_id	VARCHAR(max) NOT NULL,
		type    VARCHAR(max),
		title	VARCHAR(max),
		director VARCHAR(max),
		casts	VARCHAR(max),
		country	VARCHAR(max),
		date_added	date,
		release_year float,
		rating	VARCHAR(max),
		duration VARCHAR(max),
		genre	VARCHAR(max),
		description VARCHAR(max)
	    );
       GO


	SELECT * FROM netflix
	GO

-- Import csv data file.
		BULK INSERT netflix                                        -- Specific destination table in the database.
		FROM 'C:\Users\Administrator\Desktop\Practice\netflix.csv' -- Data file locatio path.
		WITH ( FORMAT='csv');                                      -- Specifying data file format.
		GO
		
		SELECT * FROM netflix
		GO

		--OBJECTIVE QUESTIONS AND SOLUTIONS 

-- 1.Count the number of Movies vs TV Shows

		SELECT type,      --Groups the data by type (either "Movie" or "TV Show").
		COUNT(*) AS count --Counts the number of rows for each type.
		FROM netflix      --Specific table.
		GROUP BY type;    --Ensures the count is calculated separately for each category.
		GO

--2.Find the distribution of content by genre.
		SELECT genre,
			COUNT(*) AS genre_count
		FROM netflix
		GROUP BY genre
		ORDER BY genre_count DESC;
		GO

--3.Find content Release Trends Over Time.
	
		SELECT release_year,
			   COUNT(*) AS release_count-- counts the number of content released.
		FROM netflix
		GROUP BY release_year 
		ORDER BY release_year DESC;
		GO

--4.Find the content Distribution by Country

		SELECT country,
			COUNT(*) AS content_count --- counts the number of content released.
		FROM netflix
		GROUP BY country --orders results by country of release.
		ORDER BY content_count DESC; -- orders the results by content count and displays it in a descending oder.
		GO
	
--5.find the Content Count by Rating.

		SELECT rating,
			COUNT(*) AS content_count
		FROM netflix
		GROUP BY rating
		ORDER BY content_count DESC;
		GO

--6.Find the top 10 Directors with the Most Content

		SELECT TOP 10
			director,
			COUNT(*) AS DIR_count
		FROM netflix
		WHERE director IS NOT NULL
		GROUP BY director
		ORDER BY DIR_count DESC;
		GO

--7.Find Content Categorization Based on Release Year and Genre

		SELECT release_year,genre,
			COUNT(*) AS content_count
		FROM netflix
		GROUP BY release_year, genre
		ORDER BY release_year DESC, content_count DESC;
		GO

-- 8.Find the most common rating for movies and TV shows.

		SELECT type,--Groups the results by Movie or TV Show.
			rating, --Groups the results by rating within each type.
			COUNT(*) AS rate_count --Counts how many times each rating appears for each type
		FROM netflix
		GROUP BY type, rating --Groups the results by type and rating columns.
		ORDER BY type, rate_count DESC; --Sorts results by type, and within each type, the ratings are sorted in descending order of their frequency.
		GO

-- 9.Find only the most common rating per type ( This applies a Common Table Expression (CTE) )

		WITH RankedRatings AS (
		SELECT type,rating,
		COUNT(*) AS count,
		RANK() OVER (PARTITION BY type ORDER BY COUNT(*) DESC) AS rank --Assigns a rank to each rating within its type based on the count, sorted in descending order.
		FROM netflix
		GROUP BY type, rating--Groups the results by rating column.
		)

		SELECT type,rating,
		count 
		FROM RankedRatings
		WHERE rank = 1; --Filters to show only the most common rating per type.
		GO

--10. List all movies released in a specific year.
		SELECT title,--Retrieves the name of the movies.
			   release_year--Specifies the year of release.
		FROM netflix
		WHERE type = 'Movie' --Filters for records where the type is Movie.
			AND release_year = 2018; --Filters for movies released in specified year.

--11. Find the top 5 countries with the most content on Netflix.

		SELECT country,
			COUNT(*) AS content_count --Counts the total number of content entries (Movies and TV Shows) for each country.
		FROM netflix
		GROUP BY country --Groups the data by the country column.
		ORDER BY content_count DESC-- Sorts the results in descending order of content count.
		OFFSET 0 ROWS FETCH NEXT 5 ROWS ONLY;--Sorts the results in descending order of content count.
		GO

--12. Identify the longest movie

		SELECT TOP 1 --Selects the top 1 title by duration.
			title,
			duration
		FROM netflix
		WHERE type = 'Movie'-- Filters the results to include only Movies.
		ORDER BY CAST(REPLACE(duration, ' min', '') AS INT) DESC; --Cast converts the duration to an integer.
																  --REPLACE(duration, ' min', '') removes the " min" text since  the duration column is stored as a string like 120 min.
		GO


--13.Find content added in the last 5 years.

		SELECT 
			title,--The name of the content.
			type,--Whether it's a Movie or TV Show.
			date_added --The date it was added to Netflix.
		FROM netflix --From table netflix.
		WHERE date_added >= DATEADD(YEAR, -5, GETDATE()); --GETDATE() gets the current date and time.
														  --DATEADD(YEAR, -5, GETDATE()) subtracts 5 years from the current date, giving the cutoff date.
		GO

--14.Find content added in the last 5 years by year. 

		SELECT 
			YEAR(date_added) AS year_added,--Extracts the year from the date_added column to group the content by year.
			COUNT(*) AS content_count -- Counts the number of content added in each year.
		FROM netflix
		WHERE date_added >= DATEADD(YEAR, -5, GETDATE())--Filters the content to include only records added in the last 5 years.
		GROUP BY YEAR(date_added)--Groups the results by the year the content was added.
		ORDER BY year_added ASC; --Ensures the results are displayed in ascending order by year.
		GO

--15.Find how many Movies vs TV Shows were added each year inthe last 5 years.

		SELECT YEAR(date_added) AS year_added,--Extracts the year from the date_added column to group the content by year.
			type,
			COUNT(*) AS content_count --Counts the number of content added in each year.
		FROM netflix
		WHERE date_added >= DATEADD(YEAR, -5, GETDATE()) --Filters the content to include only records added in the last 5 years.
		GROUP BY YEAR(date_added), type --Groups the results by the year the content was added.
		ORDER BY year_added ASC, type; --Ensures the results are displayed in ascending order by year.
		GO


--16. Find all the movies/TV shows by director Matthew Ross.

		SELECT 
			title,--he name of the Movie or TV Show.
			type, -- Specifies whether it is a Movie or TV Show.
			director-- Displays the director's name for clarity.
		FROM netflix
		WHERE director LIKE '%Matthew Ross%'; --Finds any row where specified director appears anywhere in the director column, even if there are multiple directors listed.
		GO
		
--17. List all TV shows with more than 5 seasons.

		SELECT 
			title,
			duration
		FROM netflix
		WHERE type = 'TV Show'
		AND CASE WHEN PATINDEX('% season%', duration) > 0 THEN --Finds the position of the word season in the duration column.
					CAST(SUBSTRING(duration, 1, PATINDEX('% season%', duration) - 1) AS INT)--Converts the extracted number into an integer for comparison.
					--Checks if PATINDEX finds the word seasons.
					--If found, it extracts the numeric part of the seasons column using SUBSTRING.
					--If not found, it returns 0 and skips rows without a valid season value.
				ELSE 0
		END > 2;--Filters the results to only include TV shows with more than 2 seasons.
		GO


--18. Count the number of content items in each genre.

		SELECT genre,--Retrieves the genre for each content item (Movie or TV Show).
			COUNT(*) AS genre_count--Counts the number of content in each genre.
		FROM netflix
		GROUP BY genre --Groups the results by genre.
		ORDER BY genre_count DESC;--Sorts the results by the count of content in descending order, so genres with more content appear first.
		GO

--19.Find each year and the average numbers of content release in USA on netflix. 
		SELECT release_year,
			COUNT(*) / COUNT(DISTINCT release_year) AS average_content_per_year-- This calculates the average number of content items released each year in USA
		FROM netflix
		WHERE country LIKE '%United States%' --  ensures it includes all rows where USA appears.
		GROUP BY release_year
		ORDER BY release_year;
		GO
	

--20.List all movies that are documentaries

		SELECT 
			title,
			type,
			genre
		FROM netflix
		WHERE type = 'Movie' AND genre LIKE '%Doc%';--Filters the results to include only Movies whose genre contains the word "Doc".
		GO


--21. Find all content without a director
		SELECT 
			title,
			type,
			director
		FROM netflix
		WHERE director IS NULL;
		GO

--22. Find the top 10 actors who have appeared in the highest number of movies produced.
		SELECT TOP 10
			casts,
			COUNT(*) AS movie_count--Counts the number of movies each actor has appeared in.
		FROM netflix
		WHERE type = 'Movie' AND casts IS NOT NULL -- Filters to include only Movies and ensures the casts is not null.
		GROUP BY casts
		ORDER BY movie_count DESC;
		GO

--23.Categorize the content based on the presence of the keywords 'kill' and 'violence' in  the description field. 

		SELECT CASE 
				WHEN LOWER(description) LIKE '%kill%' OR LOWER(description) LIKE '%violence%' THEN 'Bad'
				ELSE 'Good'
			END AS content_category,
			COUNT(*) AS content_count
		FROM netflix
		GROUP BY CASE 
				 WHEN LOWER(description) LIKE '%kill%' OR LOWER(description) LIKE '%violence%' THEN 'Bad' --Checks if the word "kill" or violence appears in the description
				 ELSE 'Good'
		END;

			SELECT title,
			CASE 
				WHEN LOWER(description) LIKE '%kill%' OR LOWER(description) LIKE '%violence%' THEN 'Bad' --Checks if the word "kill" or violence appears in the description
				ELSE 'Good'
			END AS content_category
		FROM netflix
		WHERE type = 'Movie' -- Filters to include only Movies
			AND description IS NOT NULL -- Ensures the query only looks at rows where the description is available.
		ORDER BY content_category, title;
		GO
	





--END--




