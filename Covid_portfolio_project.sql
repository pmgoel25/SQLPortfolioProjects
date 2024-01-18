select * from blackrainbow25.covid_deaths
order by 3,2;
select * from blackrainbow25.covid_vaccinations
order by 3,2;
select location, date, total_cases, new_cases, total_deaths, population 
from blackrainbow25.covid_deaths
order by 1,2;

-- looking at total cases vs total deaths

select location, date, total_cases, total_deaths, (total_deaths/total_cases*100) as death_percentage
from blackrainbow25.covid_deaths
-- where location like '%states%'
order by 1,2;

-- looking at countries with highest infection rate compared to population

select location, population, max(total_cases) as Highest_infection_count, max((total_cases/population))*100 as percent_population_infected
from blackrainbow25.covid_deaths
-- where location like '%states%'
group by location, population
order by 4 desc;

-- looking for total death count county wise

select location, max(total_deaths) as total_death_count
from blackrainbow25.covid_deaths
group by location
order by 2 desc;

-- breaking things down by continent

select continent, max(total_deaths) as total_death_count
from blackrainbow25.covid_deaths
group by continent
order by 2 desc;

-- Global Numbers

select date, sum(new_cases) as total_cases_daily
from blackrainbow25.covid_deaths
group by date
order by 1;

-- Joins

select * from blackrainbow25.covid_deaths cd
join blackrainbow25.covid_vaccinations cv
on cd.location= cv.location and
cd.date= cv.date
order by 3,4;

-- looking for total population vs new cases

select cd.continent, cd.location, cd.date, cv.population, cd.new_cases, 
sum(new_cases) over (partition by cd.location) as Total_cases from blackrainbow25.covid_deaths cd
join blackrainbow25.covid_vaccinations cv
on cd.location= cv.location and
cd.date= cv.date
order by 2,3;

-- CTE

with popvscovid (continent, location, date, population, new_cases, total_cases)
as 
(
select cd.continent, cd.location, cd.date, cv.population, cd.new_cases, 
sum(new_cases) over (partition by cd.location order by cd.location, cd.date) as Total_cases 
from blackrainbow25.covid_deaths cd
join blackrainbow25.covid_vaccinations cv
on cd.location= cv.location and
cd.date= cv.date)
select *, (total_cases/population)*100 as infection_ratio
from popvscovid;

-- create view to store data for later visualizations

create view per_pop_covid1 as
select cd.continent, cd.location, cd.date, cv.population, cd.new_cases, 
sum(new_cases) over (partition by cd.location order by cd.location, cd.date) as Total_cases 
from blackrainbow25.covid_deaths cd
join blackrainbow25.covid_vaccinations cv
on cd.location= cv.location and
cd.date= cv.date
