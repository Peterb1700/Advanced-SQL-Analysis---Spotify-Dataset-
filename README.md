# Spotify Advanced SQL Project 



**Technology Stack**
- **Database**: PostgreSQL
- **SQL Queries**: DDL, DML, Aggregations, Joins, Subqueries, Window Functions
- **Tools**: pgAdmin 4 (or any SQL editor), PostgreSQL


[Click Here to get Dataset](https://www.kaggle.com/datasets/sanjanchaudhari/spotify-dataset)

## Overview
This project focuses on analyzing a comprehensive Spotify dataset containing detailed information about tracks, albums, and artists using SQL. The process includes transforming a denormalized dataset into a fully normalized structure and executing SQL queries of varying complexity—ranging from basic to advanced. The primary objectives are to refine advanced SQL skills and uncover meaningful insights from the dataset.
```sql
-- create table
DROP TABLE IF EXISTS spotify;
CREATE TABLE spotify (
    artist VARCHAR(255),
    track VARCHAR(255),
    album VARCHAR(255),
    album_type VARCHAR(50),
    danceability FLOAT,
    energy FLOAT,
    loudness FLOAT,
    speechiness FLOAT,
    acousticness FLOAT,
    instrumentalness FLOAT,
    liveness FLOAT,
    valence FLOAT,
    tempo FLOAT,
    duration_min FLOAT,
    title VARCHAR(255),
    channel VARCHAR(255),
    views FLOAT,
    likes BIGINT,
    comments BIGINT,
    licensed BOOLEAN,
    official_video BOOLEAN,
    stream BIGINT,
    energy_liveness FLOAT,
    most_played_on VARCHAR(50)
);
```
## My Project Steps

### Exploratory Data Analysis
Summary
During the exploratory data analysis of the Spotify dataset, several key insights and issues were uncovered:

Dataset Size:
The dataset contains 20,594 records, with 2,074 unique artists and 11,854 unique albums. This highlights a rich dataset for analysis.

Album Types:
The dataset includes three distinct album types: Album, Compilation, and Single.

Duration Insights:
The maximum track duration is 77.93 minutes, while the minimum is 0 minutes, which flagged an inconsistency. Further investigation revealed two tracks with a duration of zero, which were removed to ensure data accuracy.

Key Actions
Data Cleaning:
Tracks with zero duration were identified and removed to maintain the dataset's integrity.
This initial exploration helped validate the dataset's structure, identify anomalies, and prepare it for more in-depth analysis.

### Querying the Data
After importing the data, I utilized a series of SQL queries to explore and analyze it comprehensively. These queries are thoughtfully categorized into beginner, intermediate, and advanced levels, showcasing my proficiency across the full spectrum of SQL expertise.

#### Beginner Queries
- Simple data retrieval, filtering, and basic aggregations.
  
#### Intermediate Queries
- More complex queries involving grouping, aggregation functions, and joins.
  
#### Advanced Queries
- Nested subqueries, window functions, CTEs, and performance optimization.
  
---

### Beginner Level Queries
1. Retrieve the names of all tracks that have more than 1 billion streams.
2. List all albums along with their respective artists.
3. Get the total number of comments for tracks where `licensed = TRUE`.
4. Find all tracks that belong to the album type `single`.
5. Count the total number of tracks by each artist.

### Intermediate Level Queries
1. Calculate the average danceability of tracks in each album.
2. Find the top 5 tracks with the highest energy values.
3. List all tracks along with their views and likes where `official_video = TRUE`.
4. For each album, calculate the total views of all associated tracks.
5. Retrieve the track names that have been streamed on Spotify more than YouTube.

### Advanced Level Queries
1. **Find the top 3 most-viewed tracks for each artist using window functions.**
```sql
WITH ranking_artist
AS
(SELECT 
	artist,
	track,
	SUM(views) as total_view,
	DENSE_RANK() OVER(PARTITION BY artist ORDER BY SUM(views) DESC) as rank 
FROM spotify 
GROUP BY 1, 2
ORDER BY 1, 3 DESC
)
SELECT * FROM ranking_artist 
WHERE rank <= 3;
```

2. **Write a query to find tracks where the liveness score is above the average.**
 ```sql
   SELECT
track,
artist,
liveness
FROM spotify
WHERE liveness > (SELECT AVG(liveness) FROM spotify);
```

3.  **Use a `WITH` clause to calculate the difference between the highest and lowest energy values for tracks in each album.**
```sql
WITH cte
AS
(SELECT 
	album,
	MAX(energy) as highest_energy,
	MIN(energy) as lowest_energery
FROM spotify
GROUP BY 1
)
SELECT 
	album,
	highest_energy - lowest_energery as energy_diff
FROM cte
ORDER BY 2 DESC
```
   
4. **Find tracks where the energy-to-liveness ratio is greater than 1.2.**
```sql
WITH cte2
AS
(
SELECT track, 
energy / liveness as energy_liveness_ratio
FROM spotify
ORDER BY 2
)
SELECT * FROM cte2
WHERE energy_liveness_ratio > 1.2
ORDER BY 2 DESC
```
5. **Calculate the cumulative sum of likes for tracks ordered by the number of views, using window functions.**
---sql
SELECT * FROM Spotify ;

SELECT 
	track,
	SUM(likes) OVER (ORDER BY views) AS cumulative_sum
FROM Spotify
	ORDER BY SUM(likes) OVER (ORDER BY views) DESC;
```



