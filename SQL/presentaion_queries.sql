-------------------(A)-outliers---------------------------

--1- number of outliers
SELECT 
COUNT(*) as "number of outliers"
FROM Employee
WHERE Employee.Salary >= 289768.625;


--2- percent of outliers in the data
SELECT 
COUNT(CASE WHEN Employee.Salary >= 289768.625 THEN 1 END) * 100.0 / COUNT(*) AS "percent of outliers"
FROM Employee;


--3- what is jobRole for outliers
SELECT
JobRole, COUNT(*) AS "count"
FROM Employee
WHERE Salary > 289768.625  
GROUP BY JobRole; 



--4- manager salary in outliers
SELECT 
JobRole, COUNT(*) as "Count of JobRoles"
FROM Employee
WHERE Salary > 289768.625 AND JobRole LIKE '%Manager%'
GROUP BY JobRole;


--5- aother salary in outliers
SELECT 
JobRole, COUNT(*) as "Count of JobRoles"
FROM Employee
WHERE Salary > 289768.625 AND JobRole not LIKE '%Manager%'
GROUP BY JobRole;


--6- percnet of manager and others in outliers
SELECT 
    COUNT(CASE WHEN Employee.JobRole LIKE '%Manager%' AND Employee.Salary > 289768.625 THEN 1 END) * 100.0 / 
    COUNT(CASE WHEN Employee.Salary > 289768.625 THEN 1 END) AS "Percent of manager in outliers",
	-- 
	COUNT(CASE WHEN Employee.JobRole not LIKE '%Manager%' AND Employee.Salary > 289768.625 THEN 1 END) * 100.0 / 
    COUNT(CASE WHEN Employee.Salary > 289768.625 THEN 1 END) AS "Percent of not manager in outliers"
FROM 
    Employee;


--7- manager by Age, Education and YearsAtCompany
select
Distinct JobRole,Age,salary,Employee.Education,Employee.YearsAtCompany
from Employee join Performance
on Employee.EmployeeID = Performance.EmployeeID
where Salary > 289768.625 and Employee.JobRole  LIKE '%Manager%'
group by JobRole,Age,salary,Employee.Education,Employee.YearsAtCompany,YearsInMostRecentRole, Employee.YearsSinceLastPromotion
order by Age DESC



------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
-------------------B- Attrition-----------------
UPDATE Employee
SET Attrition = CASE 
    WHEN Attrition = 1 THEN 'Yes'
    WHEN Attrition = 0 THEN 'No'
END;

---1-relation between Attrition and Education field
SELECT 
    Employee.EducationField, 
    COUNT(CASE WHEN Employee.Attrition = 'yes' THEN 1 END) AS Attrition_Number,
    COUNT(CASE WHEN Employee.Attrition = 'no' THEN 1 END) AS Non_Attrition_Number,
    COUNT(*) AS Total_Employees,
    COUNT(CASE WHEN Employee.Attrition = 'yes' THEN 1 END) * 100.0 / NULLIF(COUNT(*), 0) AS Attrition_Percentage,
    COUNT(CASE WHEN Employee.Attrition = 'no' THEN 1 END) * 100.0 / NULLIF(COUNT(*), 0) AS Non_Attrition_Percentage
FROM 
    Employee
GROUP BY 
    Employee.EducationField
ORDER BY 
    Attrition_Number DESC;


---2-  relation between Attrition and Department

SELECT 
    Employee.Department, 
    COUNT(CASE WHEN Employee.Attrition = 'yes' THEN 1 END) AS "Attrition Number",
    COUNT(CASE WHEN Employee.Attrition = 'no' THEN 1 END) AS "Non-Attrition Number",
    COUNT(*) AS "Total Employees",
    COUNT(CASE WHEN Employee.Attrition = 'yes' THEN 1 END) * 100.0 / COUNT(*) AS "Attrition Percentage",
    COUNT(CASE WHEN Employee.Attrition = 'no' THEN 1 END) * 100.0 / COUNT(*) AS "Non-Attrition Percentage"
FROM 
    Employee
GROUP BY 
    Employee.Department
ORDER BY 
    Employee.Department;

------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------

--3- What is the relationship between 'Age' and 'Attrition'?
SELECT 
    CASE 
        WHEN Employee.Age BETWEEN 18 AND 25 THEN '18-25'
        WHEN Employee.Age BETWEEN 26 AND 30 THEN '26-30'
        WHEN Employee.Age BETWEEN 31 AND 35 THEN '31-35'
        WHEN Employee.Age BETWEEN 36 AND 40 THEN '36-40'
        WHEN Employee.Age BETWEEN 41 AND 45 THEN '41-45'
        WHEN Employee.Age BETWEEN 46 AND 50 THEN '46-50'
    END AS Age_Group,
    COUNT(Employee.Attrition) AS "Attrition Number"
FROM 
    Employee
WHERE 
    Employee.Attrition = 'yes'
GROUP BY 
    CASE 
        WHEN Employee.Age BETWEEN 18 AND 25 THEN '18-25'
        WHEN Employee.Age BETWEEN 26 AND 30 THEN '26-30'
        WHEN Employee.Age BETWEEN 31 AND 35 THEN '31-35'
        WHEN Employee.Age BETWEEN 36 AND 40 THEN '36-40'
        WHEN Employee.Age BETWEEN 41 AND 45 THEN '41-45'
        WHEN Employee.Age BETWEEN 46 AND 50 THEN '46-50'
    END
ORDER BY 
    "Attrition Number" DESC;

------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------

--4- What is the relationship between 'Salary' and 'Attrition'?
SELECT 
    CASE 
        WHEN Employee.Salary BETWEEN 20000 AND 50000 THEN '20,000-50,000'
        WHEN Employee.Salary BETWEEN 50001 AND 100000 THEN '50,001-100,000'
        WHEN Employee.Salary BETWEEN 100001 AND 150000 THEN '100,001-150,000'
        WHEN Employee.Salary BETWEEN 150001 AND 200000 THEN '150,001-200,000'
        WHEN Employee.Salary BETWEEN 200001 AND 250000 THEN '200,001-250,000'
        WHEN Employee.Salary BETWEEN 250001 AND 300000 THEN '250,001-300,000'
        ELSE 'Above 300,000'
    END AS Salary_Range,
    COUNT(Employee.Attrition) AS "Attrition Number"
FROM 
    Employee
WHERE 
    Employee.Attrition = 'yes'
GROUP BY 
    CASE 
        WHEN Employee.Salary BETWEEN 20000 AND 50000 THEN '20,000-50,000'
        WHEN Employee.Salary BETWEEN 50001 AND 100000 THEN '50,001-100,000'
        WHEN Employee.Salary BETWEEN 100001 AND 150000 THEN '100,001-150,000'
        WHEN Employee.Salary BETWEEN 150001 AND 200000 THEN '150,001-200,000'
        WHEN Employee.Salary BETWEEN 200001 AND 250000 THEN '200,001-250,000'
        WHEN Employee.Salary BETWEEN 250001 AND 300000 THEN '250,001-300,000'
        ELSE 'Above 300,000'
    END
ORDER BY 
    "Attrition Number" DESC;

------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------

--5- manager rating and Attrition (precentage)
SELECT 
    P.ManagerRating, 
    COUNT(CASE WHEN E.Attrition = 'yes' THEN 1 END) AS "Attrition Number", 
    COUNT(CASE WHEN E.Attrition = 'no' THEN 1 END) AS "Non-Attrition Number", 
    COUNT(*) AS "Total Employees",
    COUNT(CASE WHEN E.Attrition = 'yes' THEN 1 END) * 100.0 / COUNT(*) AS "Attrition Percentage", 
    COUNT(CASE WHEN E.Attrition = 'no' THEN 1 END) * 100.0 / COUNT(*) AS "Non-Attrition Percentage"
FROM 
    Employee E 
JOIN 
    Performance P ON E.EmployeeID = P.EmployeeID 
GROUP BY 
    P.ManagerRating
ORDER BY 
    P.ManagerRating;

-------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------

--6- 'Satisfaction-Level' and 'Attrition' (precentage)
SELECT 
    S.SatisfactionLevel, 
    P.JobSatisfaction,
    COUNT(CASE WHEN E.Attrition = 'yes' THEN 1 END) AS "Attrition Number", 
    COUNT(CASE WHEN E.Attrition = 'no' THEN 1 END) AS "Non-Attrition Number", 
    COUNT(*) AS "Total Employees",
    COUNT(CASE WHEN E.Attrition = 'yes' THEN 1 END) * 100.0 / COUNT(*) AS "Attrition Percentage",
    COUNT(CASE WHEN E.Attrition = 'no' THEN 1 END) * 100.0 / COUNT(*) AS "Non-Attrition Percentage" 
FROM 
    Employee E 
JOIN 
    Performance P ON E.EmployeeID = P.EmployeeID 
JOIN 
    Satisfaction S ON S.Satisfaction_ID = P.JobSatisfaction
GROUP BY 
    S.SatisfactionLevel, P.JobSatisfaction
ORDER BY 
    P.JobSatisfaction, S.SatisfactionLevel;


------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------

--7- Environment-Satisfaction and 'Attrition' ( percentage )
SELECT 
    P.EnvironmentSatisfaction, 
    COUNT(CASE WHEN E.Attrition = 'yes' THEN 1 END) AS "Attrition Number", 
    COUNT(CASE WHEN E.Attrition = 'no' THEN 1 END) AS "Non-Attrition Number", 
    COUNT(*) AS "Total Employees",
    COUNT(CASE WHEN E.Attrition = 'yes' THEN 1 END) * 100.0 / COUNT(*) AS "Attrition Percentage",  
    COUNT(CASE WHEN E.Attrition = 'no' THEN 1 END) * 100.0 / COUNT(*) AS "Non-Attrition Percentage"
FROM 
    Employee E
JOIN 
    Performance P ON E.EmployeeID = P.EmployeeID  
GROUP BY  
    P.EnvironmentSatisfaction
ORDER BY 
    P.EnvironmentSatisfaction ASC;


--
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------

--8-- Years At company and Attrition ( percentage )
 
 SELECT 
    E.YearsAtCompany, 
    COUNT(CASE WHEN E.Attrition = 'yes' THEN 1 END) AS "Attrition Number", 
    COUNT(CASE WHEN E.Attrition = 'no' THEN 1 END) AS "Non-Attrition Number", 
    COUNT(*) AS "Total Employees",
    COUNT(CASE WHEN E.Attrition = 'yes' THEN 1 END) * 100.0 / COUNT(*) AS "Attrition Percentage",  
    COUNT(CASE WHEN E.Attrition = 'no' THEN 1 END) * 100.0 / COUNT(*) AS "Non-Attrition Percentage"  
FROM 
    Employee E
GROUP BY  
    E.YearsAtCompany
ORDER BY 
    E.YearsAtCompany ASC;

------------------------------------------------------------------------------------------------------
======================================================================================================
--9- job role , 'attrition' ( percentage )
SELECT 
    Employee.JobRole, 
    COUNT(CASE WHEN Employee.Attrition = 'yes' THEN 1 END) AS "Attrition Number", 
    COUNT(CASE WHEN Employee.Attrition = 'No' THEN 1 END) AS " Non Attrition Number", 
    COUNT(*) AS "Total Employees",
    COUNT(CASE WHEN Employee.Attrition = 'yes' THEN 1 END) * 100.0 / COUNT(*) AS "Attrition Percentage"
    FROM 
    Employee
GROUP BY 
    Employee.JobRole
ORDER BY 
    "Attrition Percentage" DESC;
-------------------------------------------------------------------------------------------
===========================================================================================
--10-'state' , 'attrition' ( percentage )

SELECT 
    Employee.State, 
    COUNT(CASE WHEN Employee.Attrition = 'yes' THEN 1 END) AS Attrition_Number, 
    COUNT(CASE WHEN Employee.Attrition = 'No' THEN 1 END) AS Non_Attrition_Number, 
    COUNT(*) AS Total_Employees,
    COUNT(CASE WHEN Employee.Attrition = 'yes' THEN 1 END) * 100.0 / NULLIF(COUNT(*), 0) AS Attrition_Percentage
FROM 
    Employee
GROUP BY 
    Employee.State
ORDER BY 
    Attrition_Number DESC;








