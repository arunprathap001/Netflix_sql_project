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

'''DROP TABLE IF EXISTS netflix;
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
'''
  

