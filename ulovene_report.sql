CREATE TABLE "ulovene_report" AS
SELECT "Year" :: INT AS rok
       , "Season" :: VARCHAR AS sezona
       , "Type" :: VARCHAR AS typ_loveni
       , "Area" :: VARCHAR AS oblast
       , "Nation" :: VARCHAR AS zeme
       , "Fin" :: INT AS "Fin whale"
       , "Sperm" :: INT AS "Sperm whale"
       , "Humpback" :: INT AS "Humpback whale"
       , "Sei" :: INT AS "Sei whale"
       , "Brydes" :: INT AS "Brydes whale"
       , "Minke" :: INT AS "Minke whale"
       , "Gray" :: INT AS "Gray whale"
       , "Bowhead" :: INT AS "Bowhead whale"
       , "Total" :: INT AS total
       , "Notes" :: VARCHAR AS poznamky
FROM "total-catches-list1";

CREATE OR REPLACE TABLE "ulovene_report" AS
SELECT * FROM "ulovene_report"
    UNPIVOT (pocet_ulovenych FOR eng_name in ("Fin whale", "Sperm whale", "Humpback whale", "Sei whale"
                                              , "Brydes whale", "Minke whale", "Gray whale", "Bowhead whale"));

CREATE OR REPLACE TABLE "ulovene_report" AS
SELECT rok, sezona, typ_loveni, oblast, zeme, eng_name, pocet_ulovenych, poznamky
FROM "ulovene_report";

DELETE 
FROM "ulovene_report"
WHERE pocet_ulovenych < 0;

CREATE TABLE "tabjoin2" AS
SELECT eng_name, rod
FROM "TABJOIN"
GROUP BY eng_name, rod;

CREATE OR REPLACE TABLE "ulovene_report" AS
SELECT u.eng_name, j.rod, u.pocet_ulovenych, u.rok, u.sezona, u.zeme, u.oblast, u.typ_loveni, u.poznamky
FROM "ulovene_report" AS u
LEFT JOIN "tabjoin2" AS j
ON u.eng_name = j.eng_name;

CREATE OR REPLACE TABLE "ulovene_report" AS 
SELECT rok AS year, zeme AS country, eng_name, rod AS cze_genus, pocet_ulovenych AS number_of_caughts
FROM "ulovene_report"
WHERE pocet_ulovenych <> 0;

ALTER TABLE "ulovene_report" ADD CONSTRAINT PK_ulovene PRIMARY KEY (year, country, eng_name);