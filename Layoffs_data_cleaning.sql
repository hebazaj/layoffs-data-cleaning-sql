-- Data Cleaning

SELECT * 
FROM layoffs; 

CREATE TABLE layoffs_staging
LIKE layoffs; 

INSERT layoffs_staging 
SELECT* 
FROM layoffs;

SELECT * 
FROM layoffs_staging;

-- 1. Remove Dublicates

WITH dublicates_cte AS ( 
SELECT *,
ROW_NUMBER() OVER (
PARTITION BY company , location, industry, total_laid_off, percentage_laid_off,
`date`,stage,country,funds_raised_millions) AS  row_coulmn
FROM layoffs_staging
) 
SELECT*
FROM dublicates_cte 
where row_coulmn >1;

SELECT *
FROM layoffs_staging 
WHERE company='Casper';

CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO layoffs_staging2 
SELECT *,
ROW_NUMBER() OVER (
PARTITION BY company , location, industry, total_laid_off, percentage_laid_off,
`date`,stage,country,funds_raised_millions) AS  row_coulmn
FROM layoffs_staging;

SELECT *
FROM layoffs_staging2
WHERE row_num >1;

DELETE
FROM layoffs_staging2
WHERE row_num > 1;


select * 
FROM layoffs_staging2;

-- .2 Standardizing Data

SELECT  company , TRIM(company) 
from layoffs_staging2;

UPDATE layoffs_staging2
SET company = TRIM(company);

SELECT DISTINCT industry
FROM world_layof.layoffs_staging2
ORDER BY industry;

SELECT DISTINCT country 
FROM world_layof.layoffs_staging2
ORDER BY country; 

UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';


UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country);

SELECT  DISTINCT country 
FROM layoffs_staging2
ORDER BY country;

SELECT `date`
FROM layoffs_staging2;

SELECT `date`,
STR_TO_DATE(`date`, '%Y-%m-%d') AS updated_date
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%Y-%m-%d');

SELECT `date`
FROM layoffs_staging2;

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;









-- we should set the blanks to nulls since those are typically easier to work with
UPDATE layoffs_staging2
SET industry = NULL
WHERE industry = '';

-- now if we check those are all null

SELECT *
FROM layoffs_staging2
WHERE industry IS NULL 
OR industry = ''
ORDER BY industry;

-- now we need to populate those nulls if possible

UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;






-- 4. remove any columns and rows we need to

SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL;


SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

-- Delete Useless data we can't really use
DELETE FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

SELECT * 
FROM layoffs_staging2;

ALTER TABLE layoffs_staging2
DROP COLUMN row_num;


SELECT * 
FROM layoffs_staging2;






