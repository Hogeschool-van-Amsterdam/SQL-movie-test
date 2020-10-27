pi@raspberrypi:~ $ psql test
psql (11.9 (Raspbian 11.9-0+deb10u1))
Type "help" for help.

test=#  ALTER TABLE movies ADD lexemestitle tsvector;
ALTER TABLE
test=# UPDATE movies SET lexemestitle = to_tsvector(title);
UPDATE 5229
test=# SELECT url FROM movies WHERE lexemestitle @@ to_tsquery('pirate');
                          url                          
-------------------------------------------------------
 the-pirates-who-dont-do-anything-a-veggietales-movie
 the-pirates!-band-of-misfits
 pirates-of-the-caribbean-the-curse-of-the-black-pearl
 pirates-of-the-caribbean-dead-mans-chest
 pirates-of-the-caribbean-at-worlds-end
 pirates-of-the-caribbean-dead-men-tell-no-tales
(6 rows)

test=# ALTER TABLE movies ADD ranking float4;
ALTER TABLE
test=# UPDATE movies SET rank = ts_rank(lexemestitle,plainto_tsquery( (
test(# SELECT title FROM movies WHERE url='pirates-of-the-caribbean-the-curse-of-the-black-pearl')));
UPDATE 5229
test=# CREATE TABLE recommendationsBasedOntitleField AS SELECT url, rank FROM movies WHERE rank >0.01 ORDER BY rank DESC LIMIT 50;
SELECT 4
test=# \copy (SELECT * FROM recommendationsBasedOntitleField) to '/home/pi/RSL/top50recommendationstitle.csv' WITH csv;
COPY 4
