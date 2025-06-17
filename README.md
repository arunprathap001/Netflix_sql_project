# Netflix Movies and TV Shows: Data Analysis Using SQL

![Netflix logo](https://github.com/arunprathap001/Netflix_sql_project/blob/main/netflix.png)

##Overview

This project involves a comprehensive analysis of Netflix’s movies and TV shows data using SQL. The goal is to extract valuable insights and address various business questions based on the dataset. This README provides a detailed overview of the project’s objectives, business problems, solutions, key findings, and conclusions.

##Objectives

- Analyze the distribution of content types (Movies vs. TV Shows).
- Identify the most common ratings for both movies and TV shows.
- List and analyze content based on release years, countries, and durations.
- Explore and categorize content based on specific criteria and relevant keywords.

## Dataset

The data for this project is sourced from the Kaggle dataset:

- **Dataset Link:** [Movies Dataset](https://www.kaggle.com/datasets/shivamb/netflix-shows?resource=download)

##Schema

```sql
DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix
(
    show_id      VARCHAR(10),
    type         VARCHAR(10),
    title        VARCHAR(250),
    director     VARCHAR(550),
    casts        VARCHAR(1100),
    country      VARCHAR(550),
    date_added   VARCHAR(55),
    release_year INT,
    rating       VARCHAR(15),
    duration     VARCHAR(15),
    listed_in    VARCHAR(250),
    description  VARCHAR(550)
);
```
## 15 Business Problems & Solutions

### 1. Count the number of Movies vs TV Shows

```sql
select type,
count(*) from netflix
group by 1;
```

**Objective:** Determine the distribution of content types on Netflix.

### 2. Find the most common rating for movies and TV shows

```sql
SELECT
	TYPE,
	RATING
    FROM(SELECT
		TYPE,
		RATING,
		COUNT(*),
		RANK() OVER (PARTITION BY TYPE ORDER BY COUNT(*) DESC) AS RANKING
		FROM NETFLIX GROUP BY 1,2) AS TABLE1 WHERE RANKING = 1;
```

**Objective:** Identify the most frequently occurring rating for each type of content.

### 3. List all movies released in a specific year (e.g., 2020)

```sql
SELECT * 
FROM netflix
WHERE  type ='Movie' AND release_year = 2020;
```

**Objective:** Retrieve all movies released in a specific year.

### 4. Find the top 5 countries with the most content on Netflix

```sql
SELECT 
      unnest(string_to_array(country, ',')) as new_country,
	  count(show_id) as total_content
	  FROM netflix
	  GROUP BY 1
	  ORDER BY 2 DESC
	  LIMIT 5;

--unnest function in PostgreSQL is to expand the array into rows.
--string_to_array its takes two arguments one is column_name, second one delimeters.
```

**Objective:** Identify the top 5 countries with the highest number of content items.

### 5. Identify the longest movie

```sql
SELECT * FROM NETFLIX
WHERE TYPE='Movie' AND duration =(SELECT MAX(duration) FROM NETFLIX);
```

**Objective:** Find the movie with the longest duration.

### 6. Find content added in the last 5 years

```sql
SELECT *,
TO_DATE(date_added, 'MONTH DD, YYYY')
FROM NETFLIX;

SELECT * FROM NETFLIX
WHERE TO_DATE(date_added, 'MONTH DD, YYYY') >= CURRENT_DATE - INTERVAL '5 YEARS';

--TO_DATE() function converts a string literal to a date value.
```

**Objective:** Retrieve content added to Netflix in the last 5 years.


### 7. Find all the movies/TV shows by director 'Rajiv Chilaka'!

```sql
SELECT * FROM NETFLIX WHERE DIRECTOR ILIKE '%Rajiv Chilaka%';

-- ILIKE operator is used to query data based on pattern-matching techniques.
-- result includes strings that are case-insensitive.
```

**Objective:** List all content directed by 'Rajiv Chilaka'.


### 8. List all TV shows with more than 5 seasons

```sql
SELECT *,
       SPLIT_PART(duration, ' ',1) as session
	   From NETFLIX

--SPLIT_PART(duration, ' ',1)::numeric //split and converted datatype into the number.
--SPLIT_PART(string(column_name), delimiter, position)

SELECT 
       *
	   From NETFLIX
	   WHERE TYPE='TV Show'
	   AND
	    SPLIT_PART(duration, ' ',1)::numeric >5;

--::numeric //This is type casting: it converts the result of SPLIT_PART (which is a text) to a numeric value.
```

**Objective:** Identify TV shows with more than 5 seasons.


### 9. Count the number of content items in each genre

```sql
SELECT 
     UNNEST(STRING_TO_ARRAY(listed_in, ',')) as genre,
	 count(show_id) as total_content
	 FROM NETFLIX
	 GROUP BY 1;
```

**Objective:** Count the number of content items in each genre.

### 10.Find each year and the average numbers of content release in India on netflix. 
return top 5 year with highest avg content release!

```sql
select count(*) from netflix where country='India'; -- find the total number of content

SELECT 
      EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD, YYYY')) as year,
	  count(*),
	  round(count(*)::numeric/(select count(*) from netflix where country='India')::numeric * 100,2) as avg_content_release_per_year
      FROM netflix 
      WHERE country ='India'
	  GROUP by 1;
```

**Objective:** Calculate and rank years by the average number of content releases by India.


### 11. List all movies that are documentaries

```sql
SELECT * 
FROM netflix
WHERE listed_in ILIKE '%Documentaries';
```

**Objective:** Retrieve all movies classified as documentaries.


### 12. Find all content without a director

```sql
SELECT * 
FROM netflix
WHERE director IS NULL;
```

**Objective:** List content that does not have a director.


### 13. Find how many movies actor 'Salman Khan' appeared in last 10 years!

```sql
SELECT * 
FROM netflix
WHERE casts ILIKE '%Salman Khan%'
AND release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10;
```

**Objective:** Count the number of movies featuring 'Salman Khan' in the last 10 years.


### 14. Find the top 10 actors who have appeared in the highest number of movies produced in India.

```sql
SELECT 
UNNEST(STRING_TO_ARRAY(casts, ',')) AS actor,
COUNT(*)
FROM netflix
WHERE country = 'India'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;
```

**Objective:** Identify the top 10 actors with the most appearances in Indian-produced movies.

### 15. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords.

```sql
WITH new_table
AS (
SELECT 
        CASE 
            WHEN description ILIKE '%kill%' OR description ILIKE '%violence%' THEN 'Bad content'
            ELSE 'Good content'
        END AS category
    FROM netflix)
	SELECT
	category,
    COUNT(*) AS content_count
	FROM new_table
	GROUP BY 1;  
```

**Objective:** Categorize content as 'Bad' if it contains 'kill' or 'violence' and 'Good' otherwise. Count the number of items in each category.


## Findings and Conclusion

- **Content Distribution:** The dataset includes a diverse range of movies and TV shows, spanning various ratings and genres.

- **Common Ratings:** The analysis of the most frequent ratings offers insights into the target audience for Netflix content.

- **Geographical Insights:** The identification of top contributing countries—particularly India—highlights regional trends in content distribution.

- **Content Categorization:** Classifying content based on specific keywords provides a deeper understanding of the types of content available on Netflix.

This analysis offers a comprehensive overview of Netflix’s content library and can support data-driven content strategy and decision-making.

