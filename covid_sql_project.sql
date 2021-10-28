-- this is an sql project on the microsoft SQL server management studio. The project uses the covid19 dataset gotten from  WHO in its analysis
-- the projects serves to demonstrate competence in the use and understanding of the SQL processes


--1. Load the data into MSSMS

--2. view the data

SELECT * FROM projects..coviddeaths
SELECT * FROM projects..covid_vaccinations

select * from projects..coviddeaths
where continent is not null
order by 2,3;

--3. create coviddeaths_1 table

SELECT	
	continent, 
		location, 
			date, 
				population, 
					total_cases,
						new_cases, 
							new_deaths
FROM 
	projects..coviddeaths
WHERE
	continent is not null
ORDER BY 1,2;

--  4. create survival and death rate column

SELECT 
	continent, 
	location, 
	date, 
	new_cases, 
	new_deaths, 
	round(isnull(cast(new_deaths as int)/ nullif(new_cases,0),0),2)  as death_rate, 
	round(1-isnull(cast(new_deaths as int)/ nullif(new_cases,0),0),2) as survival_rate
FROM
projects..coviddeaths
WHERE 
continent is not null
ORDER BY 1,2;

--5. table showing total survival and death rate by continent


SELECT 
	continent,
	max(population) as population, 
	max(total_cases) as total_cases, 
	max(cast(total_deaths as int)) as total_death, 
	round(sum(cast(total_deaths as int))/ sum((total_cases)),2) as total_death_rate, 
	round(1-sum(cast(total_deaths as int))/ sum((total_cases)),2) as total_survival_rate
FROM 
	projects..coviddeaths
WHERE 
	continent is not null
GROUP BY
	continent
ORDER BY 2 DESC;

--6 table showing total cases by continent

SELECT 
	location, 
	max(population) as population_country, 
	max(total_cases) as total_cases, max(cast(total_deaths as int)) as total_deaths 
FROM 
	projects..coviddeaths
WHERE 
	continent = 'Africa'
GROUP BY location
ORDER BY population_country DESC;


---7 viewing the covid vaccination table

SELECT * FROM projects..covid_vaccinations
WHERE continent is not null
ORDER BY 2,3;

SELECT
	continent, 
	location, 
	sum(cast(total_tests as int))
FROM 
	projects..covid_vaccinations
WHERE 
	continent is not null
GROUP BY location, continent
ORDER BY 2,3;


SELECT * FROM projects..covid_vaccinations
ORDER BY 2,3;


--8 filtering the covid_vaccination table

SELECT 
	continent, 
	location, date, 
	new_tests, 
	total_tests, 
	total_vaccinations, 
	new_vaccinations, 
	stringency_index, 
	population_density, 
	gdp_per_capita, 
	human_development_index
FROM
	projects..covid_vaccinations
WHERE 
	continent is not null
ORDER BY 1,2;


--9 filtering the covid_vaccination table  by location "Nigeria"

SELECT
	continent, 
	location, 
	max(cast(total_vaccinations as int)) as total_vaccinations, 
	max(cast(gdp_per_capita as int)) as gdp_per_capita
FROM 
	projects..covid_vaccinations
WHERE 
	continent is not null and LOCATION = 'Nigeria'
GROUP BY continent, location
ORDER BY 2

-- 10. filtering, grouping and aggregating some of the columns in the covid_death database 

SELECT 
	location, 
	max(population) as population,
	max(total_cases) as total_cases, 
	max(cast(total_deaths as int)) as total_death, 
	round(sum(cast(total_deaths as int))/ sum((total_cases)),2) as total_death_rate, 
	round(1-sum(cast(total_deaths as int))/ sum((total_cases)),2) as total_survival_rate
FROM 
	projects..coviddeaths
WHERE 
	continent is not null
GROUP BY location
ORDER BY total_death_rate desc;

--11. Joining the covid_deaths and covid_vaccinations table
SELECT 
	cd.location, 
	cd.population, 
	cd.date, 
	cd.total_cases, 
	cd.new_cases, 
	cd.new_deaths, 
	cd.total_deaths, 
	cv.total_vaccinations, 
	cv.stringency_index
FROM
	projects..coviddeaths cd
RIGHT JOIN 
	projects..covid_vaccinations cv
ON cd.location = cv.location and cd.date = cv.date
WHERE cd.continent is not null
ORDER BY 1,2;

---12. table showing country and percentage vaccinated
SELECT 
	cd.location, 
	max(cd.population) as population, 
	max(cd.total_cases) as total_cases, 
	max(cast(cd.total_deaths as int)) as total_deaths, 
	max(cast(cv.total_vaccinations as int)) as total_vaccinations, 
	round(max(cast(cv.total_vaccinations as int))/ max(cd.population), 2)as percentage_of_pop_vaccinated,
	max(cv.stringency_index) as stringency_index
FROM 
	projects..coviddeaths cd
JOIN 
	projects..covid_vaccinations cv
ON cd.location = cv.location
WHERE cd.continent is not null 
GROUP BY cd.location
ORDER BY 1,2;

--13. table showing indexes by continent
SELECT
	cd.continent,
	cd.location, 
	max(cd.population) as population, 
	max(cd.total_cases) as total_cases,
	max(cast(cd.total_deaths as int)) as total_deaths, 
	max(cast(cv.total_vaccinations as int)) as total_vaccinations, 
	round(max(cast(cv.total_vaccinations as int))/ max(cd.population), 2)as percentage_of_pop_vaccinated,
	max(cv.stringency_index) as stringency_index,
	max(cv.population_density) as population_density, 
	max(cv.human_development_index) as HDI
FROM 
	projects..coviddeaths cd
JOIN 
	projects..covid_vaccinations cv
on cd.location = cv.location
WHERE 
	cd.continent is not null 
GROUP BY cd.location, cd.continent
ORDER BY 1,2;

--14. tables by continent

SELECT 
	cd.continent, 
	max(cd.population) as population, 
	max(cd.total_cases) as total_cases, 
	max(cast(cd.total_deaths as int)) as total_deaths, 
	max(cast(cv.total_vaccinations as int)) as total_vaccinations, 
	round(max(cast(cv.total_vaccinations as int))/ max(cd.population), 2)as percentage_of_pop_vaccinated,
	round(avg(cv.stringency_index),2) as stringency_index, round(avg(cv.population_density),2) as population_density, 
	round(avg(cv.human_development_index),2) as HDI
FROM 
	projects..coviddeaths cd
JOIN 
	projects..covid_vaccinations cv
ON cd.location = cv.location
WHERE cd.continent is not null 
GROUP BY cd.continent
ORDER BY 1,2;

