--SELECT *
--FROM PortfolioProject.dbo.CovidDeaths
--WHERE continent IS NOT NULL
--order by 3,4 

--SELECT *
--From PortfolioProject.dbo.CovidVaccinations
--order by 3,4 

--SELECT Location, date, total_cases_per_million, new_cases, total_deaths, population 
--From PortfolioProject.dbo.CovidDeaths

-- looking at total cases vs total deaths
--SELECT Location, date, total_cases_per_million, total_deaths, (total_deaths/total_cases_per_million)*100
--From PortfolioProject.dbo.CovidDeaths

--DELETE FROM PortfolioProject.dbo.CovidDeaths
--WHERE [date] BETWEEN '2020-01-03' AND '2020-02-24'

--SELECT *
--From PortfolioProject.dbo.CovidDeaths
--order by 3,4 

-- looking at total cases vs total deaths
--SELECT Location, date, total_cases_per_million, total_deaths_per_million, (total_deaths_per_million/total_cases_per_million)*100 as DeathPercentage_per_million
--From PortfolioProject.dbo.CovidDeaths
--WHERE [location] LIKE '%Kingdom'

-- Looking at total cases vs Population 
--SELECT Location, date, total_cases_per_million, population, (total_cases_per_million/population)*100 as PercentPopulationInfected
--FROM PortfolioProject.dbo.CovidDeaths
--WHERE location LIKE '%Kingdom'

-- looking at countries with highest infection rate compared to Population 
--SELECT Location, MAX(total_cases_per_million) AS HighestInfectionCount, population, (MAX(total_cases_per_million)/population)*100 AS PercentPopulationInfected 
--FROM PortfolioProject.dbo.CovidDeaths
--GROUP BY [location], population
--ORDER BY PercentPopulationInfected DESC

-- showing country with highest death count per population 

--SELECT location, MAX(total_deaths) as TotalDeathcount, population
--FROM PortfolioProject.DBO.CovidDeaths
--WHERE continent IS NOT NULL
--GROUP BY [location], population
--ORDER BY TotalDeathcount DESC

-- lets see by continent (does not show accurate info as doesn't include some locations)
--SELECT location, MAX(total_deaths) as TotalDeathcount
--FROM PortfolioProject.DBO.CovidDeaths
--WHERE continent IS NULL
--GROUP BY [continent], [location]
--ORDER BY TotalDeathcount DESC


-- GLOBAL NUMBERS
--SELECT date, SUM(new_cases) as TotalNewCases, SUM(total_deaths) as TotalDeaths, SUM(total_deaths_per_million)/SUM(total_cases_per_million)*100 as DeathPercentage_per_million
--From PortfolioProject.dbo.CovidDeaths
--WHERE [location] LIKE '%Kingdom'
--WHERE continent IS NULL
--GROUP BY [date]
--ORDER BY 1,2 


-- Looking at Total Population vs Vaccinations
--SELECT dea.continent, dea.[location], dea.date, dea.population, vac.new_vaccinations
--FROM PortfolioProject.dbo.CovidDeaths dea
--JOIN PortfolioProject.dbo.CovidVaccinations vac--ON dea.[location] = vac.[location]
--AND dea.[date] = vac.[date]
--WHERE dea.continent IS NOT NULL
--ORDER BY 2,3


--SELECT dea.continent, dea.[location], dea.date, dea.population, vac.new_vaccinations,
--SUM(vac.new_vaccinations) OVER (Partition by dea.location ORDER BY dea.location, dea.date) as RollingNewVaccinations
-- (RollingNewVaccinations/population)*100 
--FROM PortfolioProject.dbo.CovidDeaths dea
--JOIN PortfolioProject.dbo.CovidVaccinations vac
--ON dea.[location] = vac.[location]
--AND dea.[date] = vac.[date]
--WHERE dea.continent IS NOT NULL
--ORDER BY 2,3


-- USE CTE 
--With PopvsVac (continent, Location, date, Population, new_vaccinations, RollingNewVaccinations)
--AS (
--SELECT dea.continent, dea.[location], dea.date, dea.population, vac.new_vaccinations,
--SUM(vac.new_vaccinations) OVER (Partition by dea.location ORDER BY dea.location, dea.date) as RollingNewVaccinations
-- (RollingNewVaccinations/population)*100 
--FROM PortfolioProject.dbo.CovidDeaths dea
--JOIN PortfolioProject.dbo.CovidVaccinations vac
--ON dea.[location] = vac.[location]
--AND dea.[date] = vac.[date]
--WHERE dea.continent IS NOT NULL)
--SELECT *, (RollingNewVaccinations/Population)*100
--FROM PopvsVac

-- TEMP TABLE 
--DROP TABLE IF EXISTS #PercentPopulationVaccinated
--CREATE TABLE #PercentPopulationVaccinated
--(
--    Continent nvarchar(255),
--    Location nvarchar(255),
--    Date date,
--    Population numeric,
--    new_vaccinations numeric,
--    RollingNewVaccinations numeric,
--)

--INSERT INTO #PercentPopulationVaccinated
--SELECT dea.continent, dea.[location], dea.date, dea.population, vac.new_vaccinations,
--    SUM(vac.new_vaccinations) OVER (Partition by dea.location ORDER BY dea.location, dea.date) as RollingNewVaccinations
-- (RollingNewVaccinations/population)*100 
--FROM PortfolioProject.dbo.CovidDeaths dea
 --   JOIN PortfolioProject.dbo.CovidVaccinations vac
--    ON dea.[location] = vac.[location]
--        AND dea.[date] = vac.[date]
--WHERE dea.continent IS NOT NULL
--ORDER BY 2,3
--SELECT *, (RollingNewVaccinations/Population)*100
--FROM #PercentPopulationVaccinated
--ORDER by 2, 3


-- creating view to store later for visualisations

--CREATE VIEW PercentPopulationVaccinated as
--SELECT dea.continent, dea.[location], dea.date, dea.population, vac.new_vaccinations,
--SUM(vac.new_vaccinations) OVER (Partition by dea.location ORDER BY dea.location, dea.date) as RollingNewVaccinations
-- (RollingNewVaccinations/population)*100 
--FROM PortfolioProject.dbo.CovidDeaths dea
--JOIN PortfolioProject.dbo.CovidVaccinations vac
--ON dea.[location] = vac.[location]
--AND dea.[date] = vac.[date]
--WHERE dea.continent IS NOT NULL
--ORDER BY 2,3


SELECT *
FROM PercentPopulationVaccinated
