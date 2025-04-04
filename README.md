
![netflix](https://github.com/user-attachments/assets/3b5e2eba-2062-40a7-8c9a-7633ff4d58b9)

# Netflix movies and shows SQL data analysis 
## Overview
This project focuses on analyzing Netflix's dataset using SQL. The dataset includes information about movies, TV shows, release years, genres, and other relevant metadata. The objective is to derive valuable insights, such as trends in content production, most popular genres, and patterns in content ratings and answer some business questions. This resdme file contains the project's objectives ,solution to various business questions this analysis seeks to asnwer and some key takeaways.

## Dataset Description
The dataset used fro this analysis is provided and its also available for free in kaggle.com.

### The dataset contains key attributes such as:

- show_id: Unique identifier for each show

- type: Indicates whether the content is a movie or TV show

- title: Name of the content

- director: Director(s) of the content

- cast: Leading actors/actresses
  
- country: Country of origin

- date_added: Date when the content was added to Netflix

- release_year: Year of release

- rating: Content rating (e.g., PG, R, TV-MA)

- duration: Duration of movies or number of seasons for TV shows

- listed_in: Categories or genres of the content

## TOOLS
- Excel- Data preprocessing.
- SQL(SSMS)- Data Analysis.
- Power BI- Reporting and visualization.

## SQL Queries and Insights

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
Insight:This query helps in understanding the distribution of Movies vs. TV Shows on Netflix, which can be useful for analyzing content trends and platform focus.
### 2.Find the distribution of content by genre.
```sql
SELECT genre,
			COUNT(*) AS genre_count
		FROM netflix
		GROUP BY genre
		ORDER BY genre_count DESC;
		GO
  ```
Insight: This query helps in identifying the most frequently listed genres on Netflix, providing insights into the platform’s content focus. It can be useful for trend analysis, content strategy planning, and market research.
### 3.Find content Release Trends Over Time.
```sql
SELECT release_year,
			   COUNT(*) AS release_count
		FROM netflix
		GROUP BY release_year 
		ORDER BY release_year DESC;
		GO
```
Insight : 
- This query helps in understanding the trends in content production by showing how many movies and TV shows were released each year.

- It can help analyze whether Netflix has been adding more recent content or if older titles dominate its catalog.

- The results can be used for trend forecasting and content acquisition strategies.

### 4.Find the content Distribution by Country.
```sql
SELECT country,
			COUNT(*) AS content_count 
		FROM netflix
		GROUP BY country 
		ORDER BY content_count DESC; 
		GO
```
Insight: 
- This query helps analyze which countries contribute the most content to Netflix.

- It can highlight global content distribution trends and which markets dominate Netflix’s library.

- The results may reveal whether Netflix focuses more on specific countries or has a diverse international catalog.
  
### 5.find the Content Count by Rating.
```sql
SELECT rating,
			COUNT(*) AS content_count
		FROM netflix
		GROUP BY rating
		ORDER BY content_count DESC;
		 GO
```
Insight:
- This query helps understand the distribution of content ratings on Netflix.

- It shows whether Netflix has more content rated PG, TV-MA, R, or other categories.

- It can help parents or viewers filter content based on age appropriateness.

- This data may also reveal Netflix’s focus on certain audience demographics (e.g., family-friendly vs. mature content).
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
Insight:
- This query highlights the most prolific directors on Netflix.

- It provides insight into which directors contribute the most content, helping with trend analysis in content creation.

-  This information can be useful for viewers, industry analysts, and Netflix's content strategy team.

### 7.Find Content Categorization Based on Release Year and Genre.
```sql
SELECT release_year,genre,
			COUNT(*) AS content_count
		FROM netflix
		GROUP BY release_year, genre
		ORDER BY release_year DESC, content_count DESC;
		GO
```
Insight:
- This query helps identify which genres dominated Netflix's content releases in different years.

- It reveals trends in genre popularity over time (e.g., whether Sci-Fi content has increased in recent years).

- Useful for content creators, analysts, and streaming strategists to make data-driven decisions.

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
InsightP:
-This query helps identify which ratings are most common for Movies and TV Shows.

-It can show whether TV Shows tend to have higher or lower ratings compared to Movies.

-Useful for content regulators, marketers, and Netflix analysts to assess trends in content ratings.

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
Insight:
- This query reveals the most common rating for both Movies and TV Shows.

- It helps content analysts and regulators understand what type of content is most prevalent on Netflix in terms of rating.

- Can be useful for age restriction analysis or predicting audience preferences based on rating trends.

### 10. List all movies released in a specific year.
 ```sql
    SELECT title,
			   release_year--Specifies the year of release.
		FROM netflix
		WHERE type = 'Movie' 
			AND release_year = 2018; 
```
Insight:
- This query helps analyze the movies released in a specific year (2018 in this case).

- Useful for trend analysis, understanding Netflix’s content strategy, or viewing the number of movies released in a given year.

- The query can be modified for different years by changing release_year = 2018 to another year.

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
Insight:
- Helps understand which countries contribute the most content to Netflix.

- Useful for analyzing regional content trends, such as whether Hollywood (USA) dominates Netflix or if other countries have significant contributions.

- Can be adjusted to fetch more or fewer countries by changing the number in FETCH NEXT X ROWS ONLY.

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
Insight:
- This query identifies the single longest movie available on Netflix.

- Useful for analyzing content length distribution and identifying exceptionally long movies.

- Can be modified to retrieve the top N longest movies by changing TOP 1 to TOP N.

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
Insight:
- Helps in analyzing recent content additions on Netflix.

- Useful for tracking Netflix’s content acquisition trends over the past five years.

- Can be modified to adjust the time frame (e.g., last 3 years, last 10 years).

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
Insight
- Helps in identifying trends in Netflix’s content additions over the past five years.

- Can be used to determine if Netflix is increasing or decreasing its content acquisition year over year.

- Useful for content strategy planning, showing how frequently Netflix expands its library.

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
Insight:
- Helps in understanding Netflix’s content acquisition trends over the past five years.

- Reveals whether Netflix has been focusing more on movies or TV shows over time.

- Provides valuable insights for content strategy and platform growth analysis.

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
Insight:
- Helps identify all Movies or TV Shows directed by Matthew Ross on Netflix.

- Useful for genre-based or director-based analysis of Netflix content.

- Can be extended to find other directors' contributions by modifying the WHERE clause.

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
Insight:
- Helps identify long-running TV Shows on Netflix.

- Useful for analyzing content longevity and popular multi-season shows.

- Can be adjusted to filter for TV Shows with any specific number of seasons by modifying the > 2 condition.
### 18. Count the number of content items in each genre.

```sql
 SELECT genre,
			COUNT(*) 
		FROM netflix
		GROUP BY genre 
		ORDER BY genre_count DESC;
		GO 
```
Insight:
- Helps identify the most popular genres available on Netflix.

- Useful for content analysis, genre trends, and understanding user preferences.

- Can be modified to filter for specific years, countries, or content types (Movies vs. TV Shows).

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
Insight
- This query helps analyze how Netflix content from the U.S. has evolved over time.

- Identifies trends in content production, such as increasing or decreasing numbers of new titles.

- The average number of titles per year gives a benchmark to compare specific years.
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
Insight:
- This query helps in identifying all documentary films available on Netflix.

- It can be useful for analyzing trends in documentary production.

- Can be extended to count the number of documentaries or analyze their release years.
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
Insight:
- This query helps in identifying movies or TV shows that lack director information.

- Could indicate missing data, documentaries, or Netflix Originals where a director might not be explicitly credited.

- Useful for data cleaning—ensuring completeness and accuracy of the dataset.

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
Insight:
- Identifies actors who frequently appear in Netflix movies.

- Useful for understanding Netflix’s most featured stars.

- Can help in identifying patterns in casting (e.g., do certain actors collaborate frequently with Netflix?).

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
Insight:
- These queries help categorize Netflix content based on its themes using keyword-based text analysis. This could be valuable for:
-  Content moderation & parental control features
- Improving content recommendations based on user preferences
- Analyzing trends in violent vs. non-violent content

## Some of the key take aways

- Netflix hosts a significant number of movies compared to TV shows.

- Drama and Comedy are among the most dominant genres.

- The content library has been growing consistently over the years.

- The USA is a leading contributor of Netflix content.

- The majority of content falls within PG-13, TV-MA, and R ratings.

- Some directors and actors are highly prolific in Netflix productions.

  ### This analysis provides a comprehensive view of Netflix's content and can help inform content strategy and decision-making.

  ## Author - Elvis Mwangi 
