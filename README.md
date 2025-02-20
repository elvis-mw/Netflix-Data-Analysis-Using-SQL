# Netflix movies and shows SQL data analysis 
## Overview
This project focuses on analyzing Netflix's dataset using SQL. The dataset includes information about movies, TV shows, release years, genres, and other relevant metadata. The objective is to derive valuable insights, such as trends in content production, most popular genres, and patterns in content ratings and answer some business questions. This resdme file contains the project's objectives ,solution to various business questions this analysis seeks to asnwer and some key takeaways.

## Dataset Description
The dataset used fro this analysis is provided and its also available for free in kaggle.com.

The dataset contains key attributes such as:

show_id: Unique identifier for each show

type: Indicates whether the content is a movie or TV show

title: Name of the content

director: Director(s) of the content

cast: Leading actors/actresses

country: Country of origin

date_added: Date when the content was added to Netflix

release_year: Year of release

rating: Content rating (e.g., PG, R, TV-MA)

duration: Duration of movies or number of seasons for TV shows

listed_in: Categories or genres of the content

## 🛠️ SQL Queries and Insights

## SCHEMAS
```sql
IF OBJECT_ID('netflix') IS NOT NULL DROP TABLE netflix
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
```

### 1.Count the number of Movies vs TV Shows.
```sql
SELECT type,      
		COUNT(*) AS count 
		FROM netflix     
		GROUP BY type;    
		GO
  ```
### 2.Find the distribution of content by genre.
```sql
SELECT genre,
			COUNT(*) AS genre_count
		FROM netflix
		GROUP BY genre
		ORDER BY genre_count DESC;
		GO
  ```
### 3.Find content Release Trends Over Time.
```sql
SELECT release_year,
			   COUNT(*) AS release_count
		FROM netflix
		GROUP BY release_year 
		ORDER BY release_year DESC;
		GO
```
### 4.Find the content Distribution by Country.
```sql
SELECT country,
			COUNT(*) AS content_count 
		FROM netflix
		GROUP BY country 
		ORDER BY content_count DESC; 
		GO
```
### 5.find the Content Count by Rating.
```sql
SELECT rating,
			COUNT(*) AS content_count
		FROM netflix
		GROUP BY rating
		ORDER BY content_count DESC;
		 GO
```
### 6.Find the top 10 Directors with the Most Content.
```sql
SELECT TOP 10
			director,
			COUNT(*) AS DIR_count
		FROM netflix
		WHERE director IS NOT NULL
		GROUP BY director
		ORDER BY DIR_count DESC;
		GO
```
### 7.Find Content Categorization Based on Release Year and Genre.
```sql
SELECT release_year,genre,
			COUNT(*) AS content_count
		FROM netflix
		GROUP BY release_year, genre
		ORDER BY release_year DESC, content_count DESC;
		GO
```
### 8.Find the most common rating for movies and TV shows.
```sql
SELECT type,
			rating, 
			COUNT(*) AS rate_count 
		FROM netflix
		GROUP BY type, rating 
		ORDER BY type, rate_count DESC;
		GO
```
### 9.Find only the most common rating per type ( This applies a Common Table Expression (CTE) ).
```sql
WITH RankedRatings AS (
		SELECT type,rating,
		COUNT(*) AS count,
		RANK() OVER (PARTITION BY type ORDER BY COUNT(*) DESC) AS rank 
		FROM netflix
		GROUP BY type, rating
		)
		SELECT type,rating,
		count 
		FROM RankedRatings
		WHERE rank = 1; 
		GO
```
### 10. List all movies released in a specific year.
 ```sql
    SELECT title,
			   release_year--Specifies the year of release.
		FROM netflix
		WHERE type = 'Movie' 
			AND release_year = 2018; 
```
### 11. Find the top 5 countries with the most content.
```sql
 SELECT country,
			COUNT(*) AS content_count 
		FROM netflix
		GROUP BY country 
		ORDER BY content_count DESC
		OFFSET 0 ROWS FETCH NEXT 5 ROWS ONLY;
		GO
```
### 12. Identify the longest movie on Net.
```sql
 SELECT TOP 1 --Selects the top 1 title by duration.
			title,
			duration
		FROM netflix
		WHERE type = 'Movie'
		ORDER BY CAST(REPLACE(duration, ' min', '') AS INT) DESC; 
GO
```
### 13.Find content added in the last 5 years.flix.
```sql
SELECT 
			title,
			type,
			date_added 
		FROM netflix 
		WHERE date_added >= DATEADD(YEAR, -5, GETDATE()); 
		GO
```
### 14.Find content added in the last 5 years by year.
```sql
SELECT 
			YEAR(date_added) AS year_added,
			COUNT(*) AS content_count 
		FROM netflix
		WHERE date_added >= DATEADD(YEAR, -5, GETDATE())
		GROUP BY YEAR(date_added)
		ORDER BY year_added ASC; 
		GO
```
### 15.Find how many Movies vs TV Shows were added each year inthe last 5 years.
```sql
SELECT YEAR(date_added) AS year_added,
			type,
			COUNT(*) AS content_count 
		FROM netflix
		WHERE date_added >= DATEADD(YEAR, -5, GETDATE()) 
		GROUP BY YEAR(date_added), type 
		ORDER BY year_added ASC, type; 
		GO
```
### 16. Find all the movies/TV shows by director Matthew Ross.
```sql
    SELECT 
			title,
			type, 
			director
		FROM netflix
		WHERE director LIKE '%Matthew Ross%'; 
		GO
```
### 17. List all TV shows with more than 5 seasons.
```sql
SELECT 
			title,
			duration
		FROM netflix
		WHERE type = 'TV Show'
		AND CASE WHEN PATINDEX('% season%', duration) > 0 THEN 
					CAST(SUBSTRING(duration, 1, PATINDEX('% season%', duration) - 1) AS INT)
				ELSE 0
		END > 2;
		GO
```

### 18. Count the number of content items in each genre.

```sql
 SELECT genre,
			COUNT(*) 
		FROM netflix
		GROUP BY genre 
		ORDER BY genre_count DESC;
		GO 
```

### 19.Find each year and the average numbers of content release in USA on netflix.
```sql
SELECT release_year,
			COUNT(*) / COUNT(DISTINCT release_year) AS average_content_per_year
		FROM netflix
		WHERE country LIKE '%United States%' 
		GROUP BY release_year
		ORDER BY release_year;
		GO
```
### 20.List all movies that are documentaries.
```sql
SELECT 
			title,
			type,
			genre
		FROM netflix
		WHERE type = 'Movie' AND genre LIKE '%Doc%';
		GO
```
### 21. Find all content without a director.
```sql
 SELECT 
			title,
			type,
			director
		FROM netflix
		WHERE director IS NULL;
		GO
```
### 23. Find the top 10 actors who have appeared in the highest number of movies produced.
```sql
    SELECT TOP 10
			casts,
			COUNT(*) AS movie_count
		FROM netflix
		WHERE type = 'Movie' AND casts IS NOT NULL 
		GROUP BY casts
		ORDER BY movie_count DESC;
		GO
```

### 23.Categorize the content based on the presence of the keywords 'kill' and 'violence' in  the description field.

```sql
SELECT CASE 
				WHEN LOWER(description) LIKE '%kill%' OR LOWER(description) LIKE '%violence%' THEN 'Bad'
				ELSE 'Good'
			END AS content_category,
			COUNT(*) AS content_count
		FROM netflix
		GROUP BY CASE 
				 WHEN LOWER(description) LIKE '%kill%' OR LOWER(description) LIKE '%violence%' THEN 'Bad' 
				 ELSE 'Good'
		END;

SELECT title,
			CASE 
				WHEN LOWER(description) LIKE '%kill%' OR LOWER(description) LIKE '%violence%' THEN 'Bad' 
				ELSE 'Good'
			END AS content_category
		FROM netflix
		WHERE type = 'Movie' 
			AND description IS NOT NULL 
		ORDER BY content_category, title;
		GO
```

