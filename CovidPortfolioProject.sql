SELECT *
FROM PortfolioProjectCovid.dbo.CovidDeaths
ORDER BY 3,4 

--SELECT *
--FROM PortfolioProjectCovid.dbo.CovidVaccinations
--ORDER BY 3,4 

-- Select data we are going to use
--

SELECT location, date, total_cases, new_cases, total_deaths, new_deaths, population
FROM PortfolioProjectCovid.dbo.CovidDeaths
ORDER BY 1, 2

-- Looking at total_cases vs total_deaths
--

SELECT location, date, total_cases, new_cases, total_deaths, new_deaths, population
FROM PortfolioProjectCovid.dbo.CovidDeaths
ORDER BY 1, 2

-- 
-- Change data types of columns in order to do calculations

ALTER TABLE PortfolioProjectCovid.dbo.CovidDeaths
ALTER COLUMN total_cases dec

ALTER TABLE PortfolioProjectCovid.dbo.CovidDeaths
ALTER COLUMN new_cases dec

ALTER TABLE PortfolioProjectCovid.dbo.CovidDeaths
ALTER COLUMN total_deaths dec

ALTER TABLE PortfolioProjectCovid.dbo.CovidDeaths
ALTER COLUMN new_deaths dec

ALTER TABLE PortfolioProjectCovid.dbo.CovidDeaths
ALTER COLUMN population dec

--
--
SELECT location, date, total_cases, total_deaths, population
FROM PortfolioProjectCovid.dbo.CovidDeaths
WHERE location = 'South Africa'
AND continent <> ' ' 
ORDER BY 1, 2

-- Calculate death percentage by dividing total_deaths by total_cases
-- Shows the likelihood of dying if you contract covid living in your country
-- Also create a view

SELECT location, date, total_cases, total_deaths, CASE 
WHEN total_deaths = 0 THEN NULL
WHEN total_cases = 0 THEN NULL
ELSE (total_deaths / total_cases)*100
END AS total_deaths_percentage
FROM PortfolioProjectCovid.dbo.CovidDeaths
WHERE location = 'South Africa'
AND continent <> ' ' 
ORDER BY 1, 2

CREATE VIEW TotalDeathPercentage AS
SELECT location, date, total_cases, total_deaths, CASE 
WHEN total_deaths = 0 THEN NULL
WHEN total_cases = 0 THEN NULL
ELSE (total_deaths / total_cases)*100
END AS total_deaths_percentage
FROM PortfolioProjectCovid.dbo.CovidDeaths
WHERE location = 'South Africa'
AND continent <> ' ' 
--ORDER BY 1, 2

-- Looking at total_cases vs population
-- Shows what percentage of the population has covid
-- Also create view

SELECT location, date, population, total_cases, CASE 
WHEN population = 0 THEN NULL
WHEN total_cases = 0 THEN NULL
ELSE (total_cases / population)*100
END AS percent_population_infected
FROM PortfolioProjectCovid.dbo.CovidDeaths
WHERE location = 'South Africa'
AND continent <> ' ' 
ORDER BY 1, 2

CREATE VIEW TotalInfectionPercentage AS
SELECT location, date, population, total_cases, CASE 
WHEN population = 0 THEN NULL
WHEN total_cases = 0 THEN NULL
ELSE (total_cases / population)*100
END AS percent_population_infected
FROM PortfolioProjectCovid.dbo.CovidDeaths
WHERE location = 'South Africa'
AND continent <> ' ' 
--ORDER BY 1, 2

-- Countries with highest infection rate compared to population
-- Also create view

SELECT location, population, MAX(total_cases) AS total_infection_count, CASE 
WHEN MAX(total_cases) = 0 THEN NULL
WHEN population = 0 THEN NULL
ELSE (MAX(total_cases) / population)*100
END AS total_infection_percentage
FROM PortfolioProjectCovid.dbo.CovidDeaths
WHERE continent <> ' ' 
GROUP BY location, population
ORDER BY total_infection_percentage DESC

CREATE VIEW HighestInfectionRateCountry AS
SELECT location, population, MAX(total_cases) AS total_infection_count, CASE 
WHEN MAX(total_cases) = 0 THEN NULL
WHEN population = 0 THEN NULL
ELSE (MAX(total_cases) / population)*100
END AS total_infection_percentage
FROM PortfolioProjectCovid.dbo.CovidDeaths
WHERE continent <> ' ' 
GROUP BY location, population
--ORDER BY total_infection_percentage DESC

-- Countries with highest death count per location
-- Also create view

SELECT location, MAX(total_deaths) AS total_death_count
FROM PortfolioProjectCovid.dbo.CovidDeaths
WHERE continent <> ' ' 
GROUP BY location
ORDER BY total_death_count DESC

CREATE VIEW HighestDeathCountLocation AS
SELECT location, MAX(total_deaths) AS total_death_count
FROM PortfolioProjectCovid.dbo.CovidDeaths
WHERE continent <> ' ' 
GROUP BY location
--ORDER BY total_death_count DESC

-- Countries with highest death count per continent
-- Note that continents are also found under location; only one of those columns should have the correct numbers
-- So when we get them from location, we say (where continent = ' ')
-- When we get them from continent we say (where continent <> ' ')

SELECT continent, MAX(total_deaths) AS total_death_count
FROM PortfolioProjectCovid.dbo.CovidDeaths
WHERE continent <> ' ' 
GROUP BY continent
ORDER BY total_death_count DESC

-- As we can see with this one, the numbers are much higher
-- Also create table

SELECT location, MAX(total_deaths) AS total_death_count
FROM PortfolioProjectCovid.dbo.CovidDeaths
WHERE continent = ' ' and
location <> 'World' and
location <> 'International' and
location <> 'European Union'
GROUP BY location
ORDER BY total_death_count DESC

CREATE VIEW TotalDeathCountContinent AS
SELECT location, MAX(total_deaths) AS total_death_count
FROM PortfolioProjectCovid.dbo.CovidDeaths
WHERE continent = ' ' and
location <> 'World' and
location <> 'International' and
location <> 'European Union'
GROUP BY location
--ORDER BY total_death_count DESC


-- Global Numbers
-- We're not specifying continents or locations because we're looking at global counts
-- We can't select total cases and total death and order by date, so we sum new cases and deaths which give us the totals anyway

SELECT date, SUM(new_cases) AS total_cases, SUM(new_deaths) AS total_deaths, CASE
WHEN SUM(new_cases) = 0 THEN NULL
WHEN SUM(new_deaths) = 0 THEN NULL
ELSE (SUM(new_deaths) / SUM(new_cases))*100
END AS percentage
FROM PortfolioProjectCovid.dbo.CovidDeaths
WHERE continent <> ' '
GROUP BY date
ORDER BY 1, 2

--
-- Let's remove date to see just the total cases and total deaths around the world

SELECT SUM(new_cases) AS total_cases, SUM(new_deaths) AS total_deaths, CASE
WHEN SUM(new_cases) = 0 THEN NULL
WHEN SUM(new_deaths) = 0 THEN NULL
ELSE (SUM(new_deaths) / SUM(new_cases))*100
END AS percentage
FROM PortfolioProjectCovid.dbo.CovidDeaths
WHERE continent <> ' '
ORDER BY 1, 2

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

SELECT *
FROM PortfolioProjectCovid.dbo.CovidVaccinations
ORDER BY 3,4 

-- 
-- Change data types of columns in order to do calculations

ALTER TABLE PortfolioProjectCovid.dbo.CovidVaccinations
ALTER COLUMN new_vaccinations dec

-- Join vaccination and death table
-- Total population vs vaccination

SELECT *
FROM PortfolioProjectCovid.dbo.CovidDeaths dea
JOIN PortfolioProjectCovid.dbo.CovidVaccinations vac
ON dea.location = vac.location
AND dea.date = vac.date
--
--
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
FROM PortfolioProjectCovid.dbo.CovidDeaths dea
JOIN PortfolioProjectCovid.dbo.CovidVaccinations vac
ON dea.location = vac.location
AND dea.date = vac.date
WHERE dea.continent <> ' '
ORDER BY 2, 3

-- SUM new_vaccinations, and partition by location so that SUM starts over at each location
-- Now we would divide rolling_people_vaccinated by population to get percentage of people vaccinated per location
-- But it won't work because we can't use rolling_people_vaccinated as it is a newly created column

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS rolling_people_vaccinated
-- , (RollingPeopleVaccinated/population)*100
FROM PortfolioProjectCovid.dbo.CovidDeaths dea
JOIN PortfolioProjectCovid.dbo.CovidVaccinations vac
ON dea.location = vac.location
AND dea.date = vac.date
WHERE dea.continent <> ' '
ORDER BY 2, 3

--
-- So we use a CTE to perform calculation on partition by in previous query

WITH POPvsVAC (continent, location, date, population, new_vaccinations, rolling_people_vaccinated)
AS
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS rolling_people_vaccinated
-- , (RollingPeopleVaccinated/population)*100
FROM PortfolioProjectCovid.dbo.CovidDeaths dea
JOIN PortfolioProjectCovid.dbo.CovidVaccinations vac
ON dea.location = vac.location
AND dea.date = vac.date
WHERE dea.continent <> ' '
--ORDER BY 2, 3
)

SELECT *, CASE 
WHEN population = 0 THEN NULL 
WHEN rolling_people_vaccinated = 0 THEN NULL
ELSE(rolling_people_vaccinated/population)*100
END as total_vaccinations_percentage
FROM POPvsVAC
WHERE location = 'South Africa'

-- Let's make a temp table
-- We'll call it "#PercentPopulationVaccinated"
-- If you want to change anything in your tempp table, use "drop table if exists #PercentPopulationVaccinated" function. Add this anyway if you're planning on making alterations

DROP TABLE IF EXISTS #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
continent nvarchar (255),
location nvarchar (255),
date datetime,
population numeric,
new_cavvinations numeric,
rolling_people_vaccinated numeric
)


INSERT INTO #PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS rolling_people_vaccinated
-- , (RollingPeopleVaccinated/population)*100
FROM PortfolioProjectCovid.dbo.CovidDeaths dea
JOIN PortfolioProjectCovid.dbo.CovidVaccinations vac
ON dea.location = vac.location
AND dea.date = vac.date
WHERE dea.continent <> ' '
--ORDER BY 2, 3

SELECT *, CASE 
WHEN population = 0 THEN NULL 
WHEN rolling_people_vaccinated = 0 THEN NULL
ELSE(rolling_people_vaccinated/population)*100
END as total_vaccinations_percentage
FROM #PercentPopulationVaccinated
WHERE location = 'South Africa'

--
-- Let's create a view to store data for later visualisations

CREATE VIEW PercentPopulationVaccinated AS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS rolling_people_vaccinated
-- , (RollingPeopleVaccinated/population)*100
FROM PortfolioProjectCovid.dbo.CovidDeaths dea
JOIN PortfolioProjectCovid.dbo.CovidVaccinations vac
ON dea.location = vac.location
AND dea.date = vac.date
WHERE dea.continent <> ' '
--ORDER BY 2, 3