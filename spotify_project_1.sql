---Create table---
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

---EDA---

SELECT COUNT (*) FROM spotify;

SELECT COUNT(DISTINCT(artist)) FROM spotify;

SELECT COUNT(DISTINCT(album)) FROM spotify;

SELECT DISTINCT album_type FROM spotify;

SELECT MAX(duration_min) FROM spotify;

SELECT MIN(duration_min) FROM spotify;

SELECT * FROM spotify 
WHERE duration_min = 0;

DELETE FROM spotify 
WHERE duration_min = 0;

SELECT DISTINCT channel FROM spotify;

SELECT DISTINCT most_played_on FROM spotify;



---Data Analysis---

--Retrieve all tracks with more than 1 billion streams--
SELECT * from spotify 
WHERE stream > 1000000000;

--Retrieve all tracks with more than 3 billion streams--
SELECT * from spotify 
WHERE stream > 3000000000;

--Retrieve all albums with their respective artists--
SELECT DISTINCT album, artist 
FROM spotify;

--Retrieve total number of comments for tracks where licensed = TRUE--
SELECT SUM(comments) as total_comments
FROM spotify
WHERE licensed = "TRUE";

--Retrieve all tracks with the album type is single--

SELECT * FROM spotify 
WHERE album_type = 'single';

--Count the total number of tracks by each artist--
SELECT artist, ---1 
COUNT(*) as total_no_songs ---2
FROM spotify 
GROUP BY 1
ORDER BY 2;

--Average danceability of tracks in each album--
SELECT album,
AVG(danceability) as average_danceability
FROM spotify 
GROUP BY 1
ORDER BY 2 DESC;

--Top 5 tracks with the highest energy value--
SELECT 
	track,
	MAX(energy)
FROM spotify 
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

--List top tracks with associated views and likes where offical video is TRUE--
SELECT 
track,
SUM(views) as total_views,
SUM(likes) as total_likes
FROM spotify 
WHERE official_video = 'TRUE'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

---For each album, calculate the total views of all associated tracks--
SELECT album, 
track,
SUM(views) as total_views
FROM spotify
GROUP BY 1, 2
ORDER BY 3 DESC;

--Retrieve the track names that have been streamed on Spotify more than Youtube--
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


--Top 3 most viewed tracks for each artist--

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

--Find tracks where the liveness score is above the average--
SELECT
track,
artist,
liveness
FROM spotify
WHERE liveness > (SELECT AVG(liveness) FROM spotify);

SELECT AVG(liveness) FROM spotify --0.19;

--Calculate the difference between the highest and lowest energy values for tracks in each album--

WITH cte 
AS
(SELECT 
	album,
	MAX(energy) as highest_energy,
	MIN(energy) as lowest_energy
FROM spotify
GROUP BY 1
)
SELECT album,
highest_energy - lowest_energy as energy_difference
FROM cte
ORDER BY 2 DESC



--Find tracks where the energy to liveness ratio is greater than 1.2--
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

--Calculate the cumulative sum of likes for tracks ordered by the number of views, using window functions--

SELECT * FROM Spotify ;

SELECT 
	track,
	SUM(likes) OVER (ORDER BY views) AS cumulative_sum
FROM Spotify
	ORDER BY SUM(likes) OVER (ORDER BY views) DESC;

	--end project
