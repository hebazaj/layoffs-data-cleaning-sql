# 🧹 Data Cleaning Project – Layoffs Dataset (SQL)

This project focuses on cleaning and standardizing a dataset containing global company layoffs.
The dataset was imported into MySQL and cleaned step by step to prepare it for further analysis.

---

## 🗂️ Steps Performed

1. **Created a staging table** to work on data safely without touching the raw table.  
2. **Removed duplicates** using `ROW_NUMBER()` and filtered them out.  
3. **Standardized columns** (company names, country names, dates, etc.).  
4. **Fixed inconsistent formats** (for example: `United States.` → `United States`).  
5. **Converted data types** such as converting text dates to proper SQL `DATE` format.  
6. **Removed null or useless rows** where both `total_laid_off` and `percentage_laid_off` were empty.  

---

## 🛠️ Tools Used

- **MySQL**
- **SQL Window Functions**
- **Data Standardization Techniques**

---

## 📊 Example Queries

```sql
SELECT company, total_laid_off, percentage_laid_off
FROM layoffs_cleaned
ORDER BY total_laid_off DESC;
