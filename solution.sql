--Netflix project

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

select * from netflix;

-- 15 Business Problems & Solutions

--1. Count the number of Movies vs TV Shows

select type, count(*) from netflix group by 1;

2. Find the most common rating for movies and TV shows

SELECT
	TYPE,
	RATING
    FROM(SELECT
		TYPE,
		RATING,
		COUNT(*),
		RANK() OVER (PARTITION BY TYPE ORDER BY COUNT(*) DESC) AS RANKING
		FROM NETFLIX GROUP BY 1,2) AS TABLE1 WHERE RANKING = 1;

3. List all movies released in a specific year (e.g., 2020)

SELECT * 
FROM netflix
WHERE  type ='Movie' AND release_year = 2020;

4. Find the top 5 countries with the most content on Netflix

SELECT 
      unnest(string_to_array(country, ',')) as new_country,
	  count(show_id) as total_content
	  FROM netflix
	  GROUP BY 1
	  ORDER BY 2 DESC
	  LIMIT 5;

--unnest function in PostgreSQL is to expand the array into rows.
--string_to_array its takes two arguments one is column_name, second one delimeters.


5. Identify the longest movie

SELECT * FROM NETFLIX
WHERE TYPE='Movie' AND duration =(SELECT MAX(duration) FROM NETFLIX);

6. Find content added in the last 5 years

SELECT *,TO_DATE(date_added, 'MONTH DD, YYYY')
FROM NETFLIX;

SELECT * FROM NETFLIX
WHERE TO_DATE(date_added, 'MONTH DD, YYYY') >= CURRENT_DATE - INTERVAL '5 YEARS';

--TO_DATE() function converts a string literal to a date value.

7. Find all the movies/TV shows by director 'Rajiv Chilaka'!

SELECT * FROM NETFLIX WHERE DIRECTOR ILIKE '%Rajiv Chilaka%';

-- ILIKE operator is used to query data based on pattern-matching techniques.
-- result includes strings that are case-insensitive.

8. List all TV shows with more than 5 seasons

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

9. Count the number of content items in each genre

SELECT 
     UNNEST(STRING_TO_ARRAY(listed_in, ',')) as genre,
	 count(show_id) as total_content
	 FROM NETFLIX
	 GROUP BY 1;

10.Find each year and the average numbers of content release in India on netflix. 
return top 5 year with highest avg content release!

select count(*) from netflix where country='India'; -- find the total number of content

SELECT 
      EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD, YYYY')) as year,
	  count(*),
	  round(count(*)::numeric/(select count(*) from netflix where country='India')::numeric * 100,2) as avg_content_release_per_year
      FROM netflix 
      WHERE country ='India'
	  GROUP by 1;

11. List all movies that are documentaries

SELECT * 
FROM netflix
WHERE listed_in ILIKE '%Documentaries';


12. Find all content without a director

SELECT * 
FROM netflix
WHERE director IS NULL;


13. Find how many movies actor 'Salman Khan' appeared in last 10 years!

SELECT * 
FROM netflix
WHERE casts ILIKE '%Salman Khan%'
AND release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10;

14. Find the top 10 actors who have appeared in the highest number of movies produced in India.

SELECT 
UNNEST(STRING_TO_ARRAY(casts, ',')) AS actor,
COUNT(*)
FROM netflix
WHERE country = 'India'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;


15. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords.

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




