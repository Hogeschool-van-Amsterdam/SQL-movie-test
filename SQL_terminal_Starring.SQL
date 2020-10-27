
test=# ALTER TABLE movies ADD lexemesStarring tsvector;
ALTER TABLE
test=# UPDATE movies SET lexemesStarring = to_tsvector(Starring);
UPDATE 5229

test=# SELECT url FROM movies WHERE lexemesStarring @@ to_tsquery('Jonny');
        url        
-------------------
 project-almanac
 dracula-2000
 hackers
 hellion
 chasing-mavericks
(5 rows)

test=# SELECT url FROM movies WHERE lexemesStarring @@ to_tsquery('Johnny');
test=# ALTER TABLE movies ADD ranks float4;
ALTER TABLE
test=# UPDATE movies SET rank = ts_rank(lexemesStarring,plainto_tsquery( (

LINE 1: SELECT Starring FROM movies WHERE url='hackers')));
                                                       ^
test=# UPDATE movies SET rank = ts_rank(lexemesStarring,plainto_tsquery( (
test(# SELECT Starring FROM movies WHERE url='hackers')));
UPDATE 5229
test=# CREATE TABLE recommendationsBasedOnStarringField3 AS SELECT url, rank FROM movies WHERE rank > 0.01 ORDER BY rank DESC LIMIT 50;
SELECT 24
test=# \copy (SELECT * FROM recommendationsBasedOnStarringField3) to '/home/pi/RSL/top50recommendationsStarring.csv' WITH csv;
COPY 24
test=#  
