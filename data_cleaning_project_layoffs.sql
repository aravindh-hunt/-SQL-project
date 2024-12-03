
-- Data Cleaning Project

-- Data Cleaning plays a vital role for Data Analysis 
-- because it helps to remove unnecessary rows values 
-- Also to modify or change the values necessary for Data Analysis



select * from layoffs;

select * ,                                -- Query to detect duplicate rows
row_number() over( partition by 
company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions
 ) as no_of_dup
from layoffs;



WITH dup_layoffs AS (          -- CTE created to know duplicate rows 
    SELECT *, 
           ROW_NUMBER() OVER(PARTITION BY 
               company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions
           ) AS no_of_dup
    FROM layoffs
)
SELECT *
FROM dup_layoffs
WHERE no_of_dup > 1;



-- Create Duplicate Table (Reason : we should not mess around with orginal table)


create table layoff1 as 
    SELECT *, 
           ROW_NUMBER() OVER(PARTITION BY 
               company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions
           ) AS no_of_dup
    FROM layoffs;



-- 1. DELETE THE DUPLICATE ROWS


select * from layoff1;

-- to check duplicate rows

select * from layoff1                           -- there are some dupicate rows
where no_of_dup>1;

select * from layoff1 where company='Casper';    -- cross checking by there values

-- to delete duplicate rows 

delete from layoff1            -- duplicate rows deleted
where no_of_dup>1;

select * from layoff1          -- cross check completed, no duplicate rows
where no_of_dup>1;



-- 2. STANDARDIZE THE DATA 


select * from layoff1;

select distinct country from layoff1     -- there are two united states, one with spelling mistake
order by country;

select distinct country from layoff1 
where country like 'United States%';

update layoff1 set                       -- now we gonna correct the mistakem spelling
country = 'United States'
where country like 'United States%';

select distinct country from layoff1 
where country like 'United States%';

-- 

select distinct industry from layoff1     -- yeah here also they messed with industry name called crypto 
order by industry;

select distinct industry from layoff1
where industry like 'Crypto%';

update layoff1 set                        -- now we've updated the messed value of industry
industry = 'Crypto' 
where industry like 'Crypto%';

select distinct industry from layoff1     -- cross checking
where industry like 'Crypto%';

--

select `date`,                                -- now we have issues with format and data type of date column
str_to_date(`date` , '%m/%d/%Y')
from layoff1;

update layoff1 set                            -- yeach, we did this 
`date` = str_to_date(`date` , '%m/%d/%Y');

select `date` from layoff1;                   -- cross check completed, now time to change the data type

alter table layoff1 modify                    -- Done 
`date` date;

desc layoff1;                                  -- cross check completed

-- WORKING WITH NULL VALUE OR BLANK VALUE


select * from layoff1;

select distinct industry from layoff1;          -- we got it there is null value in industry, but it should'nt Right

select company , industry from layoff1
where industry is null or industry = '';

select * from layoff1                           -- by cross checking it, we can verify that it belongs to Transportation industry
where company = 'Carvana' ;

update layoff1 set                              -- updateing blank value as null value 
industry = null where
industry = '';

select t1.industry , t2.industry  from          -- query to compare and find industry of null value 
layoff1 t1 join layoff1 t2
on t1.company = t2.company and t1.location=t2.location
where t1.industry is null and t2.industry is not null
;

update layoff1 t1 join layoff1 t2                       -- here we updated null value of industry related to their company and location
on t1.company = t2.company and t1.location=t2.location
set t1.industry = t2.industry
where t1.industry is null and t2.industry is not null
;

select t1.industry , t2.industry  from          -- cross check completed  
layoff1 t1 join layoff1 t2
on t1.company = t2.company and t1.location=t2.location
where t1.industry is null and t2.industry is not null
;



-- 4. DROP UNNECESSARY ROWS AND COLUMNS


select * from layoff1;          -- now we able to see many value of total_laid_off and percentage_laid_off is null 

select total_laid_off, percentage_laid_off    -- it gives many null values, which is unnecessary cause we cant use it
from layoff1
where total_laid_off is null and 
percentage_laid_off is null
;

delete from layoff1                           --  delete those unnecessary rows only if you are confident                   
where total_laid_off is null and 
percentage_laid_off is null;

select total_laid_off, percentage_laid_off    -- cross check completed
from layoff1
where total_laid_off is null and percentage_laid_off is null
;

--  delete the 'no_of_dup' column, which we created at begining to find duplicate

desc layoff1;   

alter table layoff1 drop                       -- now we deleted the unnecessary column
column no_of_dup;                              



-- Now we done with our data cleaning project
-- Thing to remember while Data Cleaning
--                                         * Remove Duplicate Rows
--                                         * Standardize the Data
--                                         * Delete the NULL and Blank values
--                                         * Remove unnecessary Rows and Columns
--
-- Also Remember to be Confident of what you are doing 
-- And whenever you are working with a dataset always work with Duplicate table 
--
--
--                                    Thank You *-*
