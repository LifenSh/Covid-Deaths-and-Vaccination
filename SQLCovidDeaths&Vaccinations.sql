
select Location, Date, Total_cases, New_cases, Total_deaths, Population
from PortfolioProject..CovidDeaths
where Continent is not null
order by 1,2

select Location, Date, Total_cases, Total_deaths, (Total_deaths/Total_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths
where Continent is not null
where location like '%zealand%'
order by 1,2

select Location, Date, Total_cases, Total_deaths, (Total_deaths/Total_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths
where Continent is not null
where location like '%china%'
order by 1,2

select Location, Date, Population, Total_cases, (Total_cases/Population)*100 as CovidPercentage
from PortfolioProject..CovidDeaths
where Continent is not null
where location like '%china%'
order by 1,2

select Location, Date, Population, Total_cases, (Total_cases/Population)*100 as CovidPercentage
from PortfolioProject..CovidDeaths
where Continent is not null
where location like '%states%'
order by 1,2

select Location, Date, Population, Total_cases, (Total_cases/Population)*100 as CovidPercentage
from PortfolioProject..CovidDeaths
where Continent is not null
where location like '%zealand%'
order by 1,2

select Location, Population, max(total_cases) as HighestInfectionCount, max(total_cases/population)*100 as CovidPercentage
from PortfolioProject..CovidDeaths
where Continent is not null
group by location, population
order by CovidPercentage desc

select Location, max(cast(Total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
where Continent is not null
group by Location
order by TotalDeathCount desc


select Continent, max(cast(Total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
where Continent is not null
group by Continent
order by TotalDeathCount desc


select Date, sum(New_cases) as Total_cases, sum(cast(New_deaths as int)) as Total_deaths, sum(cast(New_deaths as int))/sum(New_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths
where continent is not null
group by Date
order by 1,2

select sum(New_cases) as Total_cases, sum(cast(New_deaths as int)) as Total_deaths, sum(cast(New_deaths as int))/sum(New_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths
where continent is not null
order by 1,2

select *
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
on dea.Location = vac.Location
and dea.Date = vac.Date


select dea.Continent, dea.Location, dea.Date, dea.Population, vac.New_vaccinations
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
on dea.Location = vac.Location
and dea.Date = vac.Date
where dea.Continent is not null
order by 2,3


with PopvsVac (Continent, Location, Date, Population, New_vaccinations, RollingPeopleVaccinated)
as
(select dea.Continent, dea.Location, dea.Date, dea.Population, vac.New_vaccinations,
sum(cast(vac.New_vaccinations as bigint)) OVER (Partition by dea.Location Order by dea.Date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
on dea.Location = vac.Location
and dea.Date = vac.Date
where dea.Continent is not null
)
select *, (RollingPeopleVaccinated/Population)*100 as RollingPeopleVaccinated_percentage
from PopvsVac


Drop Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinatons numeric,
RollingPeopleVaccinated numeric,
)

Insert into #PercentPopulationVaccinated
Select dea.Continent, dea.Location, dea.Date, dea.Population, vac.New_vaccinations,
sum(cast(vac.New_vaccinations as bigint)) OVER (Partition by dea.Location Order by dea.Date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
on dea.Location = vac.Location
and dea.Date = vac.Date
where dea.Continent is not null

select *, (RollingPeopleVaccinated/Population)*100
from #PercentPopulationVaccinated


