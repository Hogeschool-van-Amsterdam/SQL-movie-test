pi@raspberrypi:~ $ sudo su postgres
postgres@raspberrypi:/home/pi$ psql
psql (11.9 (Raspbian 11.9-0+deb10u1))
Type "help" for help.

postgres=# create database tsum;
CREATE DATABASE
postgres=# \q
postgres@raspberrypi:/home/pi$ exit
exit
pi@raspberrypi:~ $ psql tsum
psql (11.9 (Raspbian 11.9-0+deb10u1))
Type "help" for help.

tsum=# CREATE TABLE movies (
tsum(# url text,
tsum(# title text,
tsum(# ReleaseDate text,
tsum(# Distributor text,
tsum(# Starring text,
tsum(# Summary text,
tsum(# Director text,
tsum(# Genre text,
tsum(# Rating text,
tsum(# Runtime text,
tsum(# Userscore text,
tsum(# Metascore text,
tsum(# scoreCounts text);
CREATE TABLE
tsum=# \copy movies FROM '/home/pi/moviesFromMetacritic.csv' with (format csv,header true, delimiter';');
COPY 5229
tsum=# SELECT * FROM movies where url='pirates-of-the-caribbean-the-curse-of-the-black-pearl';
tsum=# ALTER TABLE movies ADD lexemesSummary tsvector;
ALTER TABLE
tsum=# UPDATE movies SET lexemesSummary = to_tsvector(Summary);
UPDATE 5229
tsum=# SELECT url FROM movies WHERE lexemesSummary @@ to_tsquery('pirate');
                          url                          
-------------------------------------------------------
 bukowski-born-into-this
 captain-phillips
 lucky-number-slevin
 pan
 the-pirates!-band-of-misfits
 pirates-of-the-caribbean-the-curse-of-the-black-pearl
 pirates-of-the-caribbean-at-worlds-end
 the-pirates-who-dont-do-anything-a-veggietales-movie
 pirates-of-the-caribbean-dead-men-tell-no-tales
 the-princess-bride
 stardust
(11 rows)

tsum=# ALTER TABLE movies ADD rank float4;
ALTER TABLE
tsum=# UPDATE movies SET rank = ts_rank(lexemesSummary,plainto_tsquery( (
tsum(# SELECT * FROM movies WHERE url='pirates-of-the-caribbean-the-curse-of-the-black-pearl')));
ERROR:  subquery must return only one column
LINE 1: ... movies SET rank = ts_rank(lexemesSummary,plainto_tsquery( (
                                                                      ^
tsum=# UPDATE movies SET rank = ts_rank(lexemesSummary,plainto_tsquery( (
tsum(#  SELECT Summary FROM movies WHERE url='pirates-of-the-caribbean-the-curse-of-the-black-pearl')));
UPDATE 5229
tsum=# CREATE TABLE recommendationsBasedOnSummaryFieldvONE AS SELECT url, rank FROM movies WHERE rank > 0.01 ORDER BY rank DESC LIMIT 50;
SELECT 50
tsum=# \copy (SELECT * FROM recommendationsBasedOnSummaryFieldvOne) to '/home/pi/RSL/top50recommendationsvONE.csv WITH csv;
COPY 50
tsum=# \copy (SELECT * FROM recommendationsBasedOnSummaryFieldvOne) to '/home/pi/RSL/top50recommendationsvONE.csv' WITH csv;
COPY 50
tsum=# 
