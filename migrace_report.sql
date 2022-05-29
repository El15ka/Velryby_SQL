CREATE TABLE "migrace_report" AS
SELECT "individualtaxoncanonicalname" 
       ,"locationlong" 
       ,"locationlat" 
       ,"eventid" 
       ,"studyname" 
       ,"timestamp" 
FROM "azores-great-whales-satellite-telemetry-program"
UNION
SELECT "individualtaxoncanonicalname" 
       ,"locationlong" 
       ,"locationlat" 
       ,"eventid" 
       ,"studyname" 
       ,"timestamp" 
FROM "blue-and-fin-whales-southern-california-2014-2015"
UNION
SELECT "individualtaxoncanonicalname" 
       ,"locationlong" 
       ,"locationlat" 
       ,"eventid" 
       ,"studyname" 
       ,"timestamp" 
FROM "blue-whales-eastern-north-pacific-1993-2008"
UNION
SELECT "individualtaxoncanonicalname" 
       ,"locationlong" 
       ,"locationlat" 
       ,"eventid" 
       ,"studyname" 
       ,"timestamp" 
FROM "bowhead-whale-admiralty-inlet"
UNION
SELECT "individualtaxoncanonicalname" 
       ,"locationlong" 
       ,"locationlat" 
       ,"eventid" 
       ,"studyname" 
       ,"timestamp" 
FROM "bowhead-whale-cumberland-sound"
UNION
SELECT "individualtaxoncanonicalname" 
       ,"locationlong" 
       ,"locationlat" 
       ,"eventid" 
       ,"studyname" 
       ,"timestamp" 
FROM "bowhead-whale-foxe-basin"
UNION
SELECT "individualtaxoncanonicalname" 
       ,"locationlong" 
       ,"locationlat" 
       ,"eventid" 
       ,"studyname" 
       ,"timestamp" 
FROM "sperm-whales-gulf-of-mexico-2011-2013";

DELETE
FROM "migrace_report"
WHERE "locationlong" = '' OR "locationlat" = '';

CREATE OR REPLACE TABLE "migrace_report" AS
SELECT  "individualtaxoncanonicalname" :: VARCHAR AS latin_name
       ,"locationlong" :: FLOAT AS longitude
       ,"locationlat" :: FLOAT AS latitude
       ,"eventid" :: VARCHAR AS eventid
       ,"studyname" :: VARCHAR AS studyname
       ,"timestamp" :: DATE as timestamp
FROM "migrace_report";

CREATE TABLE "tabjoin" AS 
SELECT "latin_name" AS latin_name
      , "eng_name" AS eng_name
      , "cze_name" AS cze_name
      , "rod" AS rod
FROM "join-tab-list-1";

UPDATE "tabjoin" SET eng_name = 'Brydes whale' WHERE latin_name = 'Balaenoptera brydei';

CREATE OR REPLACE TABLE "migrace_report" AS
SELECT m.eventid, m.latin_name, j.eng_name, j.cze_name, j.rod, m.longitude, m.latitude, m.studyname,EXTRACT (YEAR FROM m.timestamp) as rok, m.timestamp
FROM "migrace_report" AS m
LEFT JOIN "tabjoin" AS j
ON m.latin_name = j.latin_name;

CREATE OR REPLACE TABLE "migrace_report" AS
SELECT CASE
    WHEN studyname ILIKE '%Azores%' THEN 'Azores'
    WHEN studyname ILIKE '%Southern California%' THEN 'Southern California'
    WHEN studyname ILIKE '%Eastern North Pacific%' THEN 'Eastern North Pacific'
    WHEN studyname ILIKE '%Admiralty Inlet%' THEN 'Admiralty Inlet'
    WHEN studyname ILIKE '%Cumberland Sound%' THEN 'Cumberland Sound'
    WHEN studyname ILIKE '%Foxe Basin%' THEN 'Foxe Basin'
    WHEN studyname ILIKE '%Gulf of Mexico%' THEN 'Gulf of Mexico'
    ELSE 'Unrecognized'
    END AS path
    , path || rok as path_id
    , *
FROM "migrace_report";

CREATE OR REPLACE TABLE "migrace_report" AS
SELECT eventid, path_id, latin_name, eng_name, cze_name, rod AS cze_genus, longitude, latitude, rok AS year, timestamp
FROM "migrace_report";

CREATE OR REPLACE TABLE "migrace_report" AS
SELECT 
    row_number () OVER (PARTITION BY path_id, latin_name ORDER BY timestamp) AS order_of_points
    , *
FROM "migrace_report"
;