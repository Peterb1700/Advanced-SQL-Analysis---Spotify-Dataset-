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
**Retrieve the names of all tracks that have more than 1 billion streams** 
```sql
SELECT * from spotify 
WHERE stream > 1000000000;
```

**List all albums along with their respective artists.**
```sql
SELECT DISTINCT album, artist 
FROM spotify;
```
**Get the total number of comments for tracks where `licensed = TRUE`.**
```sql
SELECT SUM(comments) as total_comments
FROM spotify
WHERE licensed = "TRUE";
```

**Find all tracks that belong to the album type `single`.**
```sql
SELECT * FROM spotify 
WHERE album_type = 'single';
```

**Count the total number of tracks by each artist.**
```sql
SELECT artist, ---1 
COUNT(*) as total_no_songs ---2
FROM spotify 
GROUP BY 1
ORDER BY 2;
```

### Intermediate Level Queries
**Calculate the average danceability of tracks in each album.**
```sql
SELECT album,
AVG(danceability) as average_danceability
FROM spotify 
GROUP BY 1
ORDER BY 2 DESC;
```

**Find the top 5 tracks with the highest energy values.**
```sql
SELECT 
	track,
	MAX(energy)
FROM spotify 
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;
```

**List all tracks along with their views and likes where `official_video = TRUE`.**
```sql
SELECT 
track,
SUM(views) as total_views,
SUM(likes) as total_likes
FROM spotify 
WHERE official_video = 'TRUE'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;
```

**For each album, calculate the total views of all associated tracks.**
```sql
SELECT album, 
track,
SUM(views) as total_views
FROM spotify
GROUP BY 1, 2
ORDER BY 3 DESC;
```


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

```sql
SELECT 
	track,
	SUM(likes) OVER (ORDER BY views) AS cumulative_sum
FROM Spotify
	ORDER BY SUM(likes) OVER (ORDER BY views) DESC;
```
6. **Retrieve the track names that have been streamed on Spotify more than YouTube.**
```sql
SELECT * FROM 
(SELECT 
track,
COALESCE(SUM(CASE WHEN most_played_on = 'Youtube' THEN stream END), 0) as streamed_on_youtube,
COALESCE(SUM(CASE WHEN most_played_on = 'Spotify' THEN stream END), 0) as streamed_on_spotify
FROM spotify
GROUP BY 1
) as t1
WHERE 
	streamed_on_spotify > streamed_on_youtube
	AND 
	streamed_on_youtube  <> 0;
```
**Key Findings**

**Track and Streaming Insights**
385 tracks have over 1 billion streams; only Shape of You and Blinding Lights exceed 3 billion streams.
3,579 tracks are streamed more on YouTube, while 155 tracks are streamed more on Spotify.

**Top Tracks**
Tracks with the highest cumulative likes and views include Despacito, Shape of You, and See You Again.
The top five tracks by energy (1.0) are all by Rain Fruits Sounds.

**Artist and Album Highlights**
Most tracks by a single artist: 10 tracks, while many have just one.
Adele's top tracks: Rolling in the Deep, Someone Like You, and When We Were Young.
The album White Noise has the largest energy difference (0.9) between tracks.

**Cleaning and Quality Checks**
Two tracks with 0 duration were identified and removed for data accuracy.
Tracks with above-average liveness or high energy-to-liveness ratios stand out as unique in performance metrics.




