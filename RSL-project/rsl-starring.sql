drop table movies;
--Since the code has run multiple times before the final dataset was complete, The full code starts with drop table movies. This prevents an error in the terminal which states that the table already excists.  

--create the table structure in which all the data of the file -
--'moviesFromMetacritic' can be stored

CREATE TABLE movies (
url text,
title text,
ReleaseDate text,
Distributor text,
Starring text,
Summary text,
Director text,
Genre text,
Rating text,
Runtime text,
Userscore text,
Metascore text,
scoreCounts text
);
--every variable is created as text, so there won't be any difficulties with copying and pasting the data in the table. 

--The next step is to Copy the data from the file
copy movies
from '/tmp/moviesFromMetacritic.csv'
delimiter ';' csv header
;

--Represent the text in the starring field in a new column called lexemeSStarring
ALTER TABLE movies
ADD lexemesStarring tsvector;
UPDATE movies
SET lexemesStarring = to_tsvector(Starring);

--Select all the movies that are similar to Despicable Me.:
SELECT url FROM movies
WHERE lexemesStarring @@ to_tsquery('Despicable-Me');

--The following lines of code make it possible to select movies that are recommended
--based on the movie that is chosen as example, which is in this case despicable me. 
ALTER TABLE movies
ADD rank float4; 
Drop table RecommandationsBasedOnStarring;
-- The line above is excecuted for the same reason as line 2 "drop movies"
update movies 
	set rank = ts_rank(lexemesStarring,plainto_tsquery( (select Starring from movies where url = 'despicable-me')));

create table RecommandationsBasedOnStarring as 
	SELECT url, rank from movies where rank > 0.10 order by rank desc limit 50;
 

\copy (select * from RecommandationsBasedOnStarring) to /Users/jobschoonderbeek/Downloads/top50recommendationsStarring.csv with csv;

-- the ouput of this file is a table with 50 rows and two columns. the first is the name of the movie and the other is the rank which is close to 1 at the top and les close to 1 at the end. this is the result of the order by rank desc function in the command. This indicates that the code is interpreted by the system. 