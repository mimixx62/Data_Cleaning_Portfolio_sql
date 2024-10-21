
-- DATA CLEANING 

select*
from layoffs;

-- 1. remove duplicates (if there are any)
-- 2. standardize the data 
-- 3. Null values or blank values 
-- 4. remove any columns OR rows 
 
create table layoffs_staging
like layoffs;

select 
from layoffs_staging;

insert layoffs_staging
select*
from layoffs; 

-- 1. a. we identify any duplicates 

select*,
row_number() over (
partition by company, industry, total_laid_off, percentage_laid_off,`date`) as row_num
from layoffs_staging;

with duplicate_cte as 
(
select*,
row_number() over (
partition by company, location, industry, total_laid_off, percentage_laid_off,`date`, stage, country, funds_raised_millions) as row_num
from layoffs_staging
)
select* 
from duplicate_cte 
where row_num > 1;

SELECT*
FROM layoffs_staging
where company= 'oda';

SELECT*
FROM layoffs_staging
where company= 'casper';

with duplicate_cte as 
(
select*,
row_number() over (
partition by company, location, industry, total_laid_off, percentage_laid_off,`date`, stage, country, funds_raised_millions) as row_num
from layoffs_staging
)
delete *
FROM layoffs_staging
where company= 'oda';

CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` text,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` text,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

select* 
from layoffs_staging2;

insert into layoffs_staging2
select*,
row_number() over (
partition by company, location, industry, total_laid_off, percentage_laid_off,`date`, stage, country, funds_raised_millions) as row_num
from layoffs_staging;

-- now we need to filter 
select* 
from layoffs_staging2
where row_num > 1;

-- so now that we have done select and identified them we will delete 

delete 
from layoffs_staging2
where row_num > 1;

select* 
from layoffs_staging2;

-- standizing data 

select distinct company, (trim(company))
from layoffs_staging2;


UPDATE `layoffs_staging2` 
SET `company` = TRIM(`company`);

select distinct industry
from layoffs_staging2
order by 1;

select *
from layoffs_staging2
where industry like 'crypto%';

update layoffs_staging2
set industry = 'crypto'
where industry like'crypto%';

select distinct country
from layoffs_staging2
order by 1;

SELECT DISTINCT country, TRIM(TRAILING '.' FROM country) 
FROM layoffs_staging2 
ORDER BY 1;

update layoffs_staging2 
set country = TRIM(TRAILING '.' FROM country) 
where country like 'United States%';

select `date`
from layoffs_staging2 ;

select `date`,
str_to_date (`date`, '%m/%d/%y')
from layoffs_staging2 ;

UPDATE layoffs_staging2 
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

UPDATE layoffs_staging2
SET `date` = CASE 
               WHEN `date` IS NOT NULL AND `date` != '' AND `date` != 'NULL' 
                    AND `date` REGEXP '^[0-9]{2}/[0-9]{2}/[0-9]{2}$' 
               THEN STR_TO_DATE(`date`, '%m/%d/%Y') 
               ELSE `date` 
             END;
             
             
select `date`
from layoffs_staging2;

UPDATE layoffs_staging2 
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y') 
WHERE `date` LIKE '%/%/%';

UPDATE layoffs_staging2 
SET `date` = NULL 
WHERE `date` = 'NULL';

ALTER TABLE layoffs_staging2
modify column `date` date; 

SELECT * 
FROM layoffs_staging2 
WHERE date = 'NULL';


SELECT *
FROM layoffs_staging2
where total_laid_off is null
and percentage_laid_off is null;

SELECT *
FROM layoffs_staging2
where industry is null 
or industry = '';

SELECT *
FROM layoffs_staging2
where company = 'Airbnb';


SELECT t1.industry, t2.industry
FROM layoffs_staging2 AS t1
JOIN layoffs_staging2 AS t2
	ON t1.company = t2.company
where (t1.industry is null or t1.industry = '')
and t2.industry is not null; 

update layoffs_staging2
set industry = null
where industry = '';


update layoffs_staging2 t1 
join layoffs_staging2 t2 
	on t1.company = t2.company 
set t1.industry = t2.industry
where (t1.industry is null )
and t2.industry is not null; 


SELECT *
FROM layoffs_staging2
where industry is null 
or industry = '';

SELECT *
FROM layoffs_staging2
where total_laid_off is null 
and percentage_laid_off is null;


delete
FROM layoffs_staging2
where total_laid_off is null 
and percentage_laid_off is null;

select *
from layoffs_staging2;

alter table layoffs_staging2
drop column row_num; 

-- NOW WE HAVE THE CLEANED DATA 
-- NEXT PROJECT WILL BE EXPLOTORY WERE WE ARE GOING TO FIND TRENDS AND PATTERNS AND RUNING COMPLEX QUERIES 