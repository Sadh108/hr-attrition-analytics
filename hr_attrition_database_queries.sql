-- Overall attrition rate
SELECT 
    ROUND(SUM(CASE WHEN attrition='Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 1) AS attrition_rate_pct
FROM hr_attrition_clean;

-- Attrition rate by department
SELECT department,
    COUNT(*) AS total_employees,
    SUM(CASE WHEN attrition='Yes' THEN 1 ELSE 0 END) AS left_count,
    ROUND(SUM(CASE WHEN attrition='Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 1) AS attrition_pct
FROM hr_attrition_clean
GROUP BY department ORDER BY attrition_pct DESC;

-- Average tenure of employees who left vs stayed
SELECT attrition, ROUND(AVG(years_at_company), 1) AS avg_tenure
FROM hr_attrition_clean GROUP BY attrition;


-- Attrition by overtime status (tests the real-world pattern)
SELECT overtime,
    ROUND(SUM(CASE WHEN attrition='Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 1) AS attrition_pct
FROM hr_attrition_clean GROUP BY overtime;

-- Salary comparison: left vs stayed, by department
SELECT department, attrition, ROUND(AVG(monthly_salary), 0) AS avg_salary
FROM hr_attrition_clean GROUP BY department, attrition ORDER BY department;

-- Manager-level attrition (top 10 managers by attrition count)
SELECT manager_name, COUNT(*) AS team_size,
    SUM(CASE WHEN attrition='Yes' THEN 1 ELSE 0 END) AS attritions
FROM hr_attrition_clean GROUP BY manager_name
HAVING attritions > 0 ORDER BY attritions DESC LIMIT 10;
