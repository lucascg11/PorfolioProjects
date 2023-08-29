SELECT * 
FROM portfolioproject.. CovidDeaths
Order by 3,4

--SELECT * 
--FROM portfolioproject.. CovidVaccinations
--Order by 3,4

--Select Data that we will use

SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM portfolioproject..CovidDeaths
where total_cases is not null
	and total_deaths is not null
Order by 1,2

--Look for total cases vs total deaths

SELECT Location, date, total_cases, total_deaths
FROM portfolioproject..CovidDeaths
where total_cases is not null
	and total_deaths is not null
Order by 1,2

--Likelyhood of death if you get covid in US
--Got a cant divide by zero error as well as nvarchar data type error
--removed cells with null

Select Location, date, CAST(total_cases AS float) AS total_cases_numeric,CAST(total_deaths AS float) AS total_deaths_numeric, (CAST(total_deaths AS float) /NULLIF(CAST(total_cases AS float), 0)) *100 as DeathPercentage
From PortfolioProject..CovidDeaths
Where location like '%states%'
and continent is not null 
and total_deaths is not null
and total_cases is not null
order by 1,2


--look for total cases vs population
--Show what percentage of population got covid

Select Location, date, Population, total_cases,  (total_cases/population)*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
Where location like '%states%'
and total_cases is not null
order by 1,2


--Looking at countries with highest infection rate compared to population

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
--Where location like '%states%'
Group by Location, Population
order by PercentPopulationInfected desc

--Showing countries with highest death count per population
--Can also use Where continent is not null for cleaner query

Select location, MAX(cast(Total_deaths as int)) as TotalDeathCount
FROM portfolioproject..CovidDeaths
--WHERE location like '%states%'
Group By Location
Order By TotalDeathCount desc





Select location, MAX(cast(Total_deaths as int)) as TotalDeathCount
FROM portfolioproject..CovidDeaths
--WHERE location like '%states%'
Where continent is not null
Group By location
Order By TotalDeathCount desc


--Showing continents with highest death count

Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
FROM portfolioproject..CovidDeaths
--WHERE location like '%states%'
Where continent is not null
Group By continent
Order By TotalDeathCount desc


--Global #s

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
--Where location like '%states%'
where continent is not null 
--Group By date
order by 1,2


--Looking at total population vs vaccinations

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.Date) 
as RollingPeopleVaccinated
FROM portfolioproject..CovidDeaths dea
Join portfolioproject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
	Where dea.continent is not null
	and new_vaccinations is not null
Order by 2,3


--Use CTE

With PopvsVac (Continent, Location,Date, Population, New_Vaccinations, RollingPeopleVaccination)
as
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.Date) 
as RollingPeopleVaccinated
FROM portfolioproject..CovidDeaths dea
Join portfolioproject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
	and New_Vaccinations is not null
--Order by 2,3
 )
 SELECt *, (RollingPeopleVaccination/Population)*100
 From PopvsVac


 --TEMP TABLE

DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_Vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null 
--order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated



 --Creating view to store data for later visualizations

 Create View PercentPopulationVaccinated as
 SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.Date) 
as RollingPeopleVaccinated
FROM portfolioproject..CovidDeaths dea
Join portfolioproject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
--Order by 2,3



Select*
From PercentPopulationVaccinated
