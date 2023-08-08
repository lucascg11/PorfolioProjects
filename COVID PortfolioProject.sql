SELECT * 
FROM portfolioproject.. CovidDeaths$
Order by 3,4

--SELECT * 
--FROM portfolioproject.. CovidVaccinations$
--Order by 3,4

--Select Data that we will use

SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM portfolioproject..CovidDeaths$
Order by 1,2

--Look for total cases vs total deaths

SELECT Location, date, total_cases, total_deaths
FROM portfolioproject..CovidDeaths$
Order by 1,2

--Likelyhood of death if you get covid in US

Select location, date, total_cases, total_deaths,CONVERT(DECIMAL(18, 2), (Convert(DECIMAL(18, 2), total_deaths) / Convert(DECIMAL(18, 2), total_cases))) as [DeathsOverTotal]
FROM CovidDeaths$
WHERE location like '%states%'
Order By 1,2


--look for total cases vs population
--Show what percentage of population got covid

Select location,date,population, total_cases, CONVERT(DECIMAL(18, 2), (Convert(DECIMAL(18, 2), population) / Convert(DECIMAL(18, 2), total_cases))) as [DeathPercentage]
FROM portfolioproject..CovidDeaths$
WHERE location like '%states%'
Order By 1,2


--Looking at countries with highest infection rate compared to population

Select location,population, MAX(total_cases) as HighestInfectionCount, CONVERT(DECIMAL(18, 2), (Convert(DECIMAL(18, 2), population) / Convert(DECIMAL(18, 2), MAX(total_cases)))) as [PercentOfPopulationInfected]
FROM portfolioproject..CovidDeaths$
--WHERE location like '%states%'
Group By Location,Population
Order By PercentOfPopulationInfected desc

--Showing countries with highest death count per population
--Can also use Where continent is not null for cleaner query

Select location, MAX(cast(Total_deaths as int)) as TotalDeathCount
FROM portfolioproject..CovidDeaths$
--WHERE location like '%states%'
Group By Location
Order By TotalDeathCount desc





Select location, MAX(cast(Total_deaths as int)) as TotalDeathCount
FROM portfolioproject..CovidDeaths$
--WHERE location like '%states%'
Where continent is not null
Group By location
Order By TotalDeathCount desc


--Showing continents with highest death count

Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
FROM portfolioproject..CovidDeaths$
--WHERE location like '%states%'
Where continent is not null
Group By continent
Order By TotalDeathCount desc


--Global #s

Select date,SUM(new_cases),SUM(cast(new_deaths as int)), SUM(cast(new_deaths as int))/SUM(new_cases) *100 as DeathPercentage
FROM portfolioproject..CovidDeaths$
WHERE location like '%states%'
Group by date
Order By 1,2


--Looking at total population vs vaccinations

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.Date) 
as RollingPeopleVaccinated
FROM portfolioproject..CovidDeaths$ dea
Join portfolioproject..CovidVaccinations$ vac
	On dea.location = vac.location
	and dea.date = vac.date
	Where dea.continent is not null
Order by 2,3


--Use CTE

With PopvsVac (Continent, Location,Date, Population, New_Vaccinations, RollingPeopleVaccination)
as
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.Date) 
as RollingPeopleVaccinated
FROM portfolioproject..CovidDeaths$ dea
Join portfolioproject..CovidVaccinations$ vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
--Order by 2,3
 )
 SELECt *, (RollingPeopleVaccination/Population)*100
 From PopvsVac


 --TEMP TABLE

 Create Table #PercentPopulationVaccinated
 (
 Continent nvarchar(255),
 Location nvarchar(255),
 Date datetime,
 Population numeric,
 New_vaccinations numeric,
 RollinPeopleVaccinated numeric
 )


 Insert Into #PercentPopulationVaccinated
 SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.Date) 
as RollingPeopleVaccinated
FROM portfolioproject..CovidDeaths$ dea
Join portfolioproject..CovidVaccinations$ vac
	On dea.location = vac.location
	and dea.date = vac.date
--Where dea.continent is not null
--Order by 2,3

SELECt *, (RollingPeopleVaccination/Population)*100
 From #PercentPopulationVaccinated


 --Creating view to store data for later visualizations

 Create View PercentPopulationVaccinated as
 SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.Date) 
as RollingPeopleVaccinated
FROM portfolioproject..CovidDeaths$ dea
Join portfolioproject..CovidVaccinations$ vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
--Order by 2,3



Select*
From PercentPopulationVaccinated
