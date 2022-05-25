Select *
FROM PortfolioProject..CovidDeaths
order by 3,4;

--Select *
--FROM PortfolioProject..CovidVaccinations
--order by 3,4;

Select Location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject..CovidDeaths
order by 1,2;

-- checking total cases vs total death and ratio
-- shows likelihood of getting infected by covid
Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathRatio
FROM PortfolioProject..CovidDeaths
where location like '%ndia%'
order by 1,2;

-- total cases vr population
-- shows % of population caught covid

Select Location, date, Population, total_cases,  (total_cases/Population)*100 as InfectionRatio
FROM PortfolioProject..CovidDeaths
--where location like '%ndia%'
order by 1,2;

-- counties with highest infection rates
Select Location, Population, max(total_cases) as TotalCases, cast(max((total_cases/Population))*100 as float)as InfectionRatio
FROM PortfolioProject..CovidDeaths
Group by Location, Population
order by InfectionRatio Desc;

-- counties with highest death rates against population
Select Location, Population, max(cast(total_deaths as int)) as TotalDeaths
FROM PortfolioProject..CovidDeaths
where continent is not null
Group by Location, Population
order by TotalDeaths Desc;

-- same details by continent
-- showing continents with highest death rate per population

Select location, max(cast(total_deaths as int)) as TotalDeaths
FROM PortfolioProject..CovidDeaths
where continent is null
Group by location
order by TotalDeaths Desc;

Select continent, max(cast(total_deaths as int)) as TotalDeaths
FROM PortfolioProject..CovidDeaths
where continent is not null
Group by continent
order by TotalDeaths Desc;

-- total cases vr deaths across the world per day
Select date, SUM(new_cases) as NewCases, SUM(cast(new_deaths as int)) as TotalDeaths, 
(SUM(cast(new_deaths as int))/SUM(new_cases))*100 as DeathRatio
FROM PortfolioProject..CovidDeaths
where continent is not null
group by date
order by 1;


-- looking at total population vs vaccinations

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
Sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RollingVaccination
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3


-- using CTE
with PopvsVac (Continent, location, date, population, new_vaccinations, RollingVaccination)
as (
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
Sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RollingVaccination
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
select *, (RollingVaccination/population)*100 as VaccRatio
from PopvsVac;

-- using TEMP table

drop table if exists #PercentPeopleVaccinated
create table #PercentPeopleVaccinated
(
continent nvarchar(255),
location  nvarchar(255),
Date datetime,
Population numeric,
New_Vaccination numeric,
RollingVaccination numeric
)

insert into #PercentPeopleVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
Sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RollingVaccination
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3

select *, (RollingVaccination/Population)*100 as VaccRatio
from #PercentPeopleVaccinated

-- creating View to visualize the data later

Create view PercentPeopleVaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
Sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RollingVaccination
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null

select top 10 * from PercentPeopleVaccinated