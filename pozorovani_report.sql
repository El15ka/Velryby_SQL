CREATE TABLE "pozorovani_report" AS 
SELECT "id" :: VARCHAR AS id
    ,"dataset_id" :: VARCHAR AS dataset_id
    ,"decimallongitude" :: FLOAT AS longitude
    ,"decimallatitude" :: FLOAT AS latitude
    ,"scientificname" :: VARCHAR AS latin_name
    ,"originalscientificname" :: VARCHAR AS latin_name2
    ,"infraorder" :: VARCHAR AS rod
    ,"individualcount" AS pocet --:: INT
    ,"country" :: VARCHAR AS zeme
    ,"date_year" AS rok --:: INT 
    ,"year" AS datum_rok --:: INT
    ,"month" AS datum_mesic --:: INT
    ,"day" AS datum_den --:: INT
FROM "obis"
WHERE "infraorder" = 'Cetacea';

UPDATE "pozorovani_report" SET rok = datum_rok WHERE rok = '';

CREATE TABLE tabjoin AS 
SELECT "latin_name" AS latin_name
      , "eng_name" AS eng_name
      , "cze_name" AS cze_name
      , "rod" AS rod
FROM "join-tab-list-1";

UPDATE "tabjoin" SET eng_name = 'Brydes whale' WHERE latin_name = 'Balaenoptera brydei';

CREATE OR REPLACE TABLE "pozorovani_report" AS
SELECT pr.*, j.eng_name, j.cze_name, j.rod AS cze_genus
FROM "pozorovani_report" AS pr
LEFT JOIN "tabjoin" AS j
ON pr.latin_name = j.latin_name;

UPDATE "pozorovani_report" SET eng_name = 'Cetacea' WHERE eng_name IS NULL;

UPDATE "pozorovani_report" SET cze_name = 'kytovci' WHERE cze_name IS NULL;

UPDATE "pozorovani_report" SET cze_genus = 'kytovci' WHERE cze_genus IS NULL;

CREATE OR REPLACE TABLE "pozorovani_report" AS
SELECT id, latin_name, latin_name2, rod AS latin_genus, eng_name, cze_name, cze_genus, longitude, latitude, rok AS year
FROM "pozorovani_report";

UPDATE "pozorovani_report" SET year = 'NA' WHERE year = '';