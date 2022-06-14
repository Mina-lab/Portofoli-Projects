-- Corona Data Set
SELECT location, date,total_cases, new_cases,total_deaths, population_density
FROM corona

--Total Cases VS Total Death in United States
SELECT location, date,total_cases, total_deaths, (total_deaths/total_cases)*100 AS death_percentage
FROM corona
WHERE location LIKE '%states%'
--Removing Null
AND total_deaths IS NOT NULL
AND total_cases  IS NOT NULL
ORDER BY 1,2

--Total Cases VS Total Death
-- Total Cases VS Population
SELECT location, date,total_cases, total_deaths, (total_cases/population_density)*100 AS infection_percentage
FROM corona
ORDER BY 1,2

--Showing Countries with the highest infection rate compared to population
SELECT location, population_density, MAX(total_cases) AS highest_infection_count, MAX(total_cases/population_density) AS percentage_population_infected
FROM corona
-- Removing Null Values
WHERE total_cases IS NOT NULL AND  population_density IS NOT NULL 
GROUP BY location,population_density
ORDER BY highest_infection_count DESC

--Showing Countries with the highest infection rate compared to population
SELECT location, population_density, MAX(total_cases) AS highest_infection_count, MAX(total_cases/population_density)*100 AS percentage_population_infected
FROM corona
-- Removing Null Values and Locating
WHERE total_cases IS NOT NULL AND  population_density IS NOT NULL AND location LIKE '%Egypt%'
GROUP BY location,population_density
ORDER BY highest_infection_count DESC


--Shows countries with the highest death rate
SELECT location, MAX(cast(total_deaths AS INT)) AS total_death
from corona
WHERE total_deaths IS NOT NULL
GROUP BY location
ORDER BY 2 DESC

--Shows continent  death rates
SELECT continent, MAX(cast(total_deaths AS INT)) AS total_death
from corona
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY 2 DESC


SELECT date, SUM(new_cases) AS total_cases, SUM(cast(new_deaths AS INT)) AS total_deaths
		, SUM(cast(new_deaths AS INT))/SUM(new_cases)*100 AS death_percentage
FROM corona
WHERE continent IS NOT NULL AND new_cases IS NOT NULL AND new_deaths IS NOT NULL
GROUP BY date
ORDER BY 1,2 DESC

SELECT co.continent, co.date, co.location, co.population_density, va.new_vaccinations,
SUM(CONVERT(INT, va.new_vaccinations)) OVER (PARTITION BY co.location ORDER BY co.location, co.date) AS people_vaccinated
FROM corona co
JOIN vaccine va
ON co.date = va.date
AND co.location = va.location
WHERE co.continent IS NOT NULL
AND va.new_vaccinations IS NOT NULL
AND co.population_density IS NOT NULL
ORDER BY 1,2,3


--Create view to store date for Visualiztion

CREATE VIEW people_vaccined_percentage  AS
SELECT co.continent, co.date, co.location, co.population_density, va.new_vaccinations,
SUM(CONVERT(INT, va.new_vaccinations)) OVER (PARTITION BY co.location ORDER BY co.location, co.date) AS people_vaccinated
FROM corona co
JOIN vaccine va
ON co.date = va.date
AND co.location = va.location
WHERE co.continent IS NOT NULL
AND va.new_vaccinations IS NOT NULL
AND co.population_density IS NOT NULL


SELECT *
FROM people_vaccined_percentage