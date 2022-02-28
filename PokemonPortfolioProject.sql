SELECT *
FROM PortfolioProjects.dbo.PokemonType

SELECT *
FROM PortfolioProjects.dbo.PokemonAbility

----------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------
-- Starting with some data cleansing
-- Change data types of certain columns in order to do calculations

ALTER TABLE PortfolioProjects.dbo.PokemonType
ALTER COLUMN HP dec

ALTER TABLE PortfolioProjects.dbo.PokemonType
ALTER COLUMN Attack dec

ALTER TABLE PortfolioProjects.dbo.PokemonType
ALTER COLUMN Defense dec

ALTER TABLE PortfolioProjects.dbo.PokemonType
ALTER COLUMN Speed dec

----------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------
-- Delete Unused Columns

ALTER TABLE PortfolioProjects.dbo.PokemonType
DROP COLUMN Total, "Type 2", "Sp# Atk"

ALTER TABLE PortfolioProjects.dbo.PokemonAbility
DROP COLUMN genus, capture_rate, evolves_from, primary_color

ALTER TABLE PortfolioProjects.dbo.PokemonAbility
DROP COLUMN pokedex_number

----------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------
-- Join 2 tables

SELECT *
FROM PortfolioProjects.dbo.PokemonType a
JOIN PortfolioProjects.dbo.PokemonAbility b
ON a.name = b.name

----------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------
-- Let's split the abilities into their own columns

SELECT 
PARSENAME(REPLACE(abilities, '~' , '.') ,1),
PARSENAME(REPLACE(abilities, '~' , '.') ,2),
PARSENAME(REPLACE(abilities, '~' , '.') ,3)
FROM PortfolioProjects.dbo.PokemonAbility

-- After splitting the different abilities, we make 3 new columns
-- Drop abilities column afterward

ALTER TABLE PortfolioProjects.dbo.PokemonAbility
Add FirstAbility nvarchar(255)

UPDATE PortfolioProjects.dbo.PokemonAbility
SET FirstAbility = PARSENAME(REPLACE(abilities, '~' , '.') ,1)

ALTER TABLE PortfolioProjects.dbo.PokemonAbility
Add SecondAbility nvarchar(255)

UPDATE PortfolioProjects.dbo.PokemonAbility
SET SecondAbility = PARSENAME(REPLACE(abilities, '~' , '.') ,2)

ALTER TABLE PortfolioProjects.dbo.PokemonAbility
Add ThirdAbility nvarchar(255)

UPDATE PortfolioProjects.dbo.PokemonAbility
SET ThirdAbility = PARSENAME(REPLACE(abilities, '~' , '.') ,3)

ALTER TABLE PortfolioProjects.dbo.PokemonAbility
DROP COLUMN abilities

---------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------
-- Change Legendary column with CASE from 1 and 0 to true and false
-- Add new column LegendaryPokemon and assign CASE statement to the column
-- Drop old table; Select distinct to check for other values

SELECT name, Legendary, CASE 
WHEN Legendary = 1 THEN 'True'
WHEN Legendary = 0 THEN 'False'
ELSE NULL
END AS LegendaryPokemon
FROM PortfolioProjects.dbo.PokemonType

ALTER TABLE PortfolioProjects.dbo.PokemonType
Add LegendaryPokemon nvarchar(255)

UPDATE PortfolioProjects.dbo.PokemonType
SET LegendaryPokemon = CASE 
WHEN Legendary = 1 THEN 'True'
WHEN Legendary = 0 THEN 'False'
ELSE NULL
END

ALTER TABLE PortfolioProjects.dbo.PokemonType
DROP COLUMN Legendary

SELECT DISTINCT LegendaryPokemon
FROM PortfolioProjects.dbo.PokemonType

---------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------
-- Some general queries for exploration
-- Max HP and Max Attack for Generation 1

SELECT MAX(Attack) AS MaxAttack, MAX (HP) AS MaxHP
FROM PortfolioProjects.dbo.PokemonType
WHERE Generation = '1' 

SELECT name, [Type 1], Generation, Attack
FROM PortfolioProjects.dbo.PokemonType
WHERE Generation = '1' AND Attack = '190' 

SELECT name, [Type 1], Generation, HP
FROM PortfolioProjects.dbo.PokemonType
WHERE Generation = '1' AND HP = '250' 

---------------------------------------------------------------------------------------------------------------------------------------------------------
-- Legendary Pokemon per Generation and Max HP and Max Attack for Generation 1 Legendaries

SELECT name, [Type 1], Generation, Attack, HP
FROM PortfolioProjects.dbo.PokemonType
WHERE LegendaryPokemon = 'True'
ORDER BY Generation

SELECT MAX(Attack) AS MaxAttack, MAX (HP) AS MaxHP
FROM PortfolioProjects.dbo.PokemonType
WHERE Generation = '1' AND LegendaryPokemon = 'True'

SELECT name, [Type 1], Generation, Attack
FROM PortfolioProjects.dbo.PokemonType
WHERE Generation = '1' AND LegendaryPokemon = 'True' AND Attack = '190'

SELECT name, [Type 1], Generation, HP
FROM PortfolioProjects.dbo.PokemonType
WHERE Generation = '1' AND LegendaryPokemon = 'True' AND HP = '106'

--------------------------------------------------------------------------------------------------------------------------------------------------------
-- Count Pokemon Types per Generation

SELECT Generation, COUNT([Type 1]) AS fire_type
FROM PortfolioProjects.dbo.PokemonType
WHERE [Type 1] = 'Fire'
GROUP BY Generation 
ORDER BY Generation

SELECT Generation, COUNT([Type 1]) AS water_type
FROM PortfolioProjects.dbo.PokemonType
WHERE [Type 1] = 'Water'
GROUP BY Generation
ORDER BY Generation

SELECT Generation, COUNT([Type 1]) AS Grass_type
FROM PortfolioProjects.dbo.PokemonType
WHERE [Type 1] = 'Grass'
GROUP BY Generation
ORDER BY Generation

--------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------
-- Count Generation Populations and create new column for Population

SELECT Generation, COUNT(Generation) OVER (PARTITION BY Generation ORDER BY Generation) AS PopulationNumber
FROM PortfolioProjects.dbo.PokemonType

ALTER TABLE PortfolioProjects.dbo.PokemonType
Add PopulationNumber nvarchar(255)

UPDATE PortfolioProjects.dbo.PokemonType
SET PopulationNumber = COUNT(Generation) OVER (PARTITION BY Generation ORDER BY Generation)

--------------------------------------------------------------------------------------------------------------------------------------------------------
-- Somehow can't update column with the above statement. So we going to try a CASE WHEN statement.
-- First let's check the population amounts

SELECT Generation, COUNT(Generation)
FROM PortfolioProjects.dbo.PokemonType
GROUP BY Generation
ORDER BY Generation

SELECT Generation, CASE 
       WHEN Generation = 1 THEN '166'
	   WHEN Generation = 2 THEN '106'
	   WHEN Generation = 3 THEN '160'
	   WHEN Generation = 4 THEN '121'
	   WHEN Generation = 5 THEN '165'
	   WHEN Generation = 6 THEN '82'
	   ELSE 'NULL'
	   END AS PopulationNumber
FROM PortfolioProjects.dbo.PokemonType

UPDATE PortfolioProjects.dbo.PokemonType
SET PopulationNumber = CASE 
       WHEN Generation = 1 THEN '166'
	   WHEN Generation = 2 THEN '106'
	   WHEN Generation = 3 THEN '160'
	   WHEN Generation = 4 THEN '121'
	   WHEN Generation = 5 THEN '165'
	   WHEN Generation = 6 THEN '82'
	   ELSE 'NULL'
	   END 

-- Let's have a look

SELECT *
FROM PortfolioProjects.dbo.PokemonType a
JOIN PortfolioProjects.dbo.PokemonAbility b
ON a.name = b.name
ORDER BY a.Generation

--------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------

