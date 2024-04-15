#STORED PROCEDURES
USE employees;
DELIMITER $$
create procedure select_employees()
BEGIN 

     Select	* FROM EMPLOYEES
     LIMIT 1000;

END $$

DELIMITER ;

Call employees.select_employees();


#Create a procedure that will provide the average salary of all employees.

DELIMITER $$
cREATE PROCEDURE average_salary()
BEGIN
   SELECT 
      AVG(salary) 
	FROM  
       salaries;
END$$
DELIMITER ;

CALL average_salary();

#Create a procedure called ‘emp_info’ that uses as 
#parameters the first and the last name of an individual, and returns their employee number.

DELIMITER $$
CREATE PROCEDURE emp_info( IN p_last_name varchar(255), IN p_first_name varchar(255), OUT p_emp_no Integer)
BEGIN
    SELECT 
    e.emp_no
    INTO p_emp_no
    from employees e
    where e.first_name= p_first_name
    AND e.last_name= p_last_name;
END$$
DELIMITER ;
    
#input= argument , output= variable

#Create a variable, called ‘v_emp_no’, where you will store the output of the procedure you created in the last exercise.

SET @v_emp_no =0;
CALL emp_info('Aruna', 'Journel', @v_emp_no);
SELECT @v_emp_no;

#Create a function called ‘emp_info’ that takes for parameters 
#the first and last name of an employee, and returns the salary from 
#the newest contract of that employee.

DELIMITER $$
CREATE FUNCTION emp_info( p_first_name varchar(255) , p_last_name varchar(255) ) returns decimal(10,2)
BEGIN
     Declare v_max_from_date date;
declare v_salary decimal (10,2);
SELECT max(from_date) into v_max_from_date from employees e
join 
salaries s ON s.emp_no = e.emp_no
WHERE  e.last_name =p_last_name AND e.first_name = p_first_name ;
SELECT s.salary into v_salary from employees e join salaries s ON e.emp_no = s.emp_no
WHERE

    e.first_name = p_first_name

        AND e.last_name = p_last_name

        AND s.from_date = v_max_from_date;
        
        RETURN v_salary;
        END $$
        DELIMITER ;
SELECT EMP_INFO('Aruna', 'Journel');

#Obtain a result set containing the employee number, first name, and last name of all employees with a number higher than 109990. 
#Create a fourth column in the query, indicating whether this employee is also a manager, 
#according to the data provided in the dept_manager table, or a regular employee. 

SELECT 
    e.emp_no,
    e.first_name,
    e.last_name,
    CASE
        WHEN dm.emp_no IS NOT NULL THEN 'manager'
        ELSE 'Employee'
    END AS is_manager
FROM
    employees e
        LEFT JOIN
    dept_manager dm ON dm.emp_no = e.emp_no
WHERE
    e.emp_no > 109990;


#Extract a dataset containing the following information about 
#the managers: employee number, first name, and last name. 
#Add two columns at the end – one showing the difference between 
#the maximum and minimum salary of that employee, and another one saying 
#whether this salary raise was higher than $30,000 or NOT.


SELECT 
    dm.emp_no,
    e.last_name,
    e.first_name,
    MAX(s.salary)-MIN(s.salary) AS salary_difference,
    CASE
        WHEN MAX(s.salary)-MIN(s.salary) > 30000 THEN 'salary raise was higher than 30000'
        ELSE 'Salary raise is less than 30000'
    END AS increased_salary
FROM
    dept_manager dm
		JOIN
    employees e ON dm.emp_no = e.emp_no
    JOIN 
    salaries s ON dm.emp_no= s.emp_no
    GROUP BY s.emp_no;  

#Extract the employee number, first name, and last name of the first 100 employees, 
#and add a fourth column, called “current_employee” saying “Is still employed” 
#if the employee is still working in the company, or “Not an employee anymore” 
#if they aren’t.

SELECT 
    e.emp_no,
    e.first_name,
    e.last_name,
    CASE
        WHEN MAX(dm.to_date) > SYSDATE() THEN 'Is still employed'
        ELSE 'Not an employee anymore'
    END AS current_employee
FROM
    employees e
        JOIN
    dept_emp dm ON dm.emp_no = e.emp_no
GROUP BY dm.emp_no
LIMIT 100;


#Write a query that upon execution, assigns a row number to all managers we have
# information for in the "employees" database (regardless of their department).


SELECT
    emp_no,
    dept_no,
    ROW_NUMBER() OVER (ORDER BY emp_no) AS row_num
FROM
dept_manager;

#Write a query that upon execution, assigns a sequential number for each 
#employee number registered in the "employees" table. Partition the data by
# the employee's first name and order it by their last name in ascending order 
#(for each partition).

SELECT emp_no, 
    first_name,
    last_name,
    ROW_NUMBER() OVER (PARTITION BY first_name ORDER by last_name ASC) as row_num
FROM 
employees ;

#Obtain a result set containing the salary values each manager has signed a contract for. 
#To obtain the data, refer to the "employees" database.
#Use window functions to add the following two columns to the final output:
# a column containing the row number of each row from the obtained dataset, starting from 1.
#a column containing the sequential row numbers associated to the rows for each manager, 
#where their highest salary has been given a number equal to the number
# of rows in the given partition
#, and their lowest - the number 1.
#Finally, while presenting the output, make sure that the data has been
# ordered by the values in the first of the row number columns, 
#and then by the salary values for each partition in ascending order.

SELECT 
s.salary,
dm.emp_no, 
ROW_NUMBER() OVER (PARTITION BY emp_no ORDER BY salary ASC) AS row_num1,
ROW_NUMBER() OVER (PARTITION BY emp_no ORDER BY salary DESC) AS row_num2  
FROM 
dept_manager dm 
JOIN 
salaries s ON dm.emp_no =s.emp_no;


#Obtain a result set containing the salary values
# each manager has signed a contract for. To obtain the data, refer to the
# "employees" database.

#Use window functions to add the following two columns to the final output:

# a column containing the row numbers associated to each manager,
# where their highest salary has been given a number equal to the number 
#of rows in the given partition, and their lowest - the number 1.

#a column containing the row numbers associated to each manager, 
#where their highest salary has been given the number of 1, 
#and the lowest - a value equal to the number of rows in the given partition.

#Let your output be ordered by 
#the salary values associated to each manager in descending order.

SELECT s.salary, dm.emp_no, 
ROW_NUMBER() OVER () as row_num1,
ROW_NUMBER() OVER (partition by emp_no order by salary desc) as row_num2
from salaries s join dept_manager dm on s.emp_no = dm.emp_no 
ORDER BY salary asc, row_num1, emp_no;

#Write a query that provides row numbers for all workers from the "employees" table,
# partitioning the data by their first names and ordering each partition by their 
#employee number in ascending order.

SELECT 
e.emp_no , 
e.first_name , 
row_number() OVER w AS row_num1
FROM employees e
WINDOW w AS ( PARTITION BY e.first_name ORDER BY e.emp_no asc );


#Find out the lowest salary value each employee has ever signed a contract for.
# To obtain the desired output, use a subquery containing a window function, 
#as well as a window specification introduced with the help of the WINDOW keyword.

SELECT a.emp_no,
       MIN(salary) AS min_salary FROM (
SELECT
emp_no, salary, ROW_NUMBER() OVER w AS row_num
FROM
salaries
WINDOW w AS (PARTITION BY emp_no ORDER BY salary)) a
GROUP BY emp_no;

#Again, find out the lowest salary value each employee has ever signed a contract for. 
#Once again, to obtain the desired output, use a subquery containing a window function. 
#This time, however, introduce the window specification in the field list of the given 
#subquery.

SELECT a.emp_no,
       MIN(salary) AS min_salary FROM (
SELECT
emp_no, salary, ROW_NUMBER() OVER (PARTITION BY emp_no ORDER BY salary) AS row_num
FROM
salaries) a
GROUP BY emp_no;

#Once again, find out the lowest salary value each employee has ever signed a contract for. 
#This time, to obtain the desired output, avoid using a window function. Just use an aggregate 

SELECT 
    a.emp_no, MIN(salary) AS min_salary
FROM
    (SELECT 
        emp_no, salary
    FROM
        salaries) a
GROUP BY emp_no;

#Once more, find out the lowest salary value each employee has ever signed a contract for.
# To obtain the desired output, use a subquery containing a window function, as well as 
#a window specification introduced with the help of the WINDOW keyword. 
#Moreover, obtain the output without using a GROUP BY clause in the outer query.

SELECT a.emp_no,
       MIN(salary) AS min_salary FROM (
SELECT
emp_no, salary, ROW_NUMBER() OVER w AS row_num
FROM
salaries
WINDOW w AS (PARTITION BY emp_no ORDER BY salary)
) a
WHERE a.row_num=1;

#Find out the second-lowest salary value each employee has ever signed a contract for. 
#To obtain the desired output, use a subquery containing a window function, as well as
# a window specification introduced with the help of the WINDOW keyword. 
#Moreover, obtain the desired result set without using a GROUP BY clause in the outer query.

SELECT a.emp_no,
a.salary as min_salary FROM (
SELECT
emp_no, salary, ROW_NUMBER() OVER w AS row_num
FROM
salaries
WINDOW w AS (PARTITION BY emp_no ORDER BY salary)) a
WHERE a.row_num=2;

#Write a query containing a window function to obtain all salary values that 
#employee number 10560 has ever signed a contract for.Order and display the obtained
# salary values from highest to lowest.



Select emp_no, salary, row_number() over w as row_number1 
from salaries
WHERE emp_no = 10560
WINDOW w AS (PARTITION BY emp_no ORDER BY salary DESC);

#Write a query that upon execution, displays the number of salary contracts 
#that each manager has ever signed while working in the company.

SELECT
    dm.emp_no, (COUNT(salary)) AS no_of_salary_contracts
FROM
    dept_manager dm
        JOIN
    salaries s ON dm.emp_no = s.emp_no
GROUP BY emp_no
ORDER BY emp_no;

#Write a query that upon execution retrieves a result set containing all salary values 
#that employee 10560 has ever signed a contract for. Use a window function to rank all
# salary values from highest to lowest in a way that equal salary values bear the same 
#rank and that gaps in the obtained ranks for subsequent rows are allowed.

SELECT
emp_no,
salary,
RANK() OVER w AS rank_num
FROM
salaries
WHERE emp_no = 10560
WINDOW w AS (PARTITION BY emp_no ORDER BY salary DESC);

#Write a query that upon execution retrieves a result set containing all salary 
#values that employee 10560 has ever signed a contract for. Use a window function 
#to rank all salary values from highest to lowest in a way that equal salary values
# bear the same rank and that gaps in the obtained ranks for subsequent rows are not allowed.

SELECT
emp_no,
salary,
DENSE_RANK() OVER w AS rank_num
  FROM
salaries
   WHERE emp_no = 10560
WINDOW w AS (PARTITION BY emp_no ORDER BY salary DESC);

#Write a query that ranks the salary values in descending order 
#of all contracts signed by employees numbered between 10500 and 10600 inclusive. 
#Let equal salary values for one and the same employee bear the same rank. 
#Also, allow gaps in the ranks obtained for their subsequent rows.

Select s.salary, e.emp_no , RANK() over w as rank_num
from salaries s 
join employees e on s.emp_no = e.emp_no
where e.emp_no  BETWEEN 10500 AND 10600
WINDOW w as (PARTITION BY e.emp_no ORDER BY s.salary DESC);

#Write a query that ranks the salary values in descending order of the following contracts from the "employees" database:
#contracts that have been signed by employees numbered between 10500 and 10600 inclusive.
#contracts that have been signed at least 4 full-years after the date when the given employee was hired in the company for the first time.
#In addition, let equal salary values of a certain employee bear the same rank. Do not allow gaps in the ranks obtained for their subsequent rows.
SELECT
    e.emp_no,
    DENSE_RANK() OVER w as employee_salary_ranking,
    s.salary,
    e.hire_date,
    s.from_date,
    (YEAR(s.from_date) - YEAR(e.hire_date)) AS years_from_start
FROM
employees e
JOIN
    salaries s ON s.emp_no = e.emp_no
    AND YEAR(s.from_date) - YEAR(e.hire_date) >= 5
WHERE e.emp_no BETWEEN 10500 AND 10600
WINDOW w as (PARTITION BY e.emp_no ORDER BY s.salary DESC);



#Write a query that can extract the following information from the "employees" database:
#the salary values (in ascending order) of the contracts signed by all employees 
#numbered between 10500 and 10600 inclusive
#a column showing the previous salary from the given ordered list
#a column showing the subsequent salary from the given ordered list
#a column displaying the difference between the current salary of a certain employee and their previous salary
#a column displaying the difference between the next salary of a certain employee and their current salary
#Limit the output to salary values higher than $80,000 only.
#Also, to obtain a meaningful result, partition the data by employee number.

Select 
	emp_no,
    
	salary,
    LAG(salary) OVER w AS previous_salary,

    LEAD(salary) OVER w AS next_salary,

    salary - LAG(salary) OVER w AS diff_salary_current_previous,

LEAD(salary) OVER w - salary AS diff_salary_next_current

FROM

salaries

    WHERE salary > 80000 AND emp_no BETWEEN 10500 AND 10600

WINDOW w AS (PARTITION BY emp_no ORDER BY salary);

#The MySQL LAG() and LEAD() value window functions can have a second argument, designating how many rows/steps back (for LAG()) or 
#forth (for LEAD()) we'd like to refer to with respect to a given record.
#With that in mind, create a query whose result set contains data arranged by 
#the salary values associated to each employee number (in ascending order). Let the output contain the following six columns:
#the employee number
#the salary value of an employee's contract (i.e. which we’ll consider as the employee's current salary)
#the employee's previous salary
#the employee's contract salary value preceding their previous salary
#the employee's next salary
#the employee's contract salary value subsequent to their next salary
#Restrict the output to the first 1000 records you can obtain.
SELECT

emp_no,

    salary,

    LAG(salary) OVER w AS previous_salary,

LAG(salary, 2) OVER w AS 1_before_previous_salary,

LEAD(salary) OVER w AS next_salary,

    LEAD(salary, 2) OVER w AS 1_after_next_salary

FROM

salaries

WINDOW w AS (PARTITION BY emp_no ORDER BY salary)

LIMIT 1000;

#Create a query that upon execution returns a result set containing the employee numbers, 
#contract salary values, start, and end dates of the first ever contracts that each employee
#signed for the company.

SELECT 
    s1.emp_no, s.salary, s.from_date, s.to_date
FROM
    salaries s
        JOIN
    (SELECT 
        emp_no, MIN(from_date) AS from_date
    FROM
        salaries
    GROUP BY emp_no) s1 ON s.emp_no = s1.emp_no
WHERE
    s.from_date = s1.from_date;
    
#Consider the employees' contracts that have been signed after the 1st of January 2000 
#and terminated before the 1st of January 2002 (as registered in the "dept_emp" table).
#Their employee number
#The salary values of the latest contracts they have signed during the suggested time period
#The department they have been working in (as specified in the latest contract they've signed during the suggested time period)
#Use a window function to create a fourth field containing the average salary paid in the department the employee was last working in during the suggested time period. Name that field "average_salary_per_department".


SELECT   
de2.emp_no, 
d.dept_name, 
s2.salary, 
AVG(s2.salary) OVER w AS average_salary_per_department
FROM

    (SELECT

    de.emp_no, de.dept_no, de.from_date, de.to_date

FROM

    dept_emp de

        JOIN

(SELECT

emp_no, MAX(from_date) AS from_date

FROM

dept_emp

GROUP BY emp_no) de1 ON de1.emp_no = de.emp_no

WHERE

    de.to_date < '2002-01-01'

AND de.from_date > '2000-01-01'

AND de.from_date = de1.from_date) de2

JOIN

    (SELECT

    s1.emp_no, s.salary, s.from_date, s.to_date

FROM

    salaries s

    JOIN

    (SELECT

emp_no, MAX(from_date) AS from_date

FROM

salaries

    GROUP BY emp_no) s1 ON s.emp_no = s1.emp_no

WHERE

    s.to_date < '2002-01-01'

AND s.from_date > '2000-01-01'

AND s.from_date = s1.from_date) s2 ON s2.emp_no = de2.emp_no

JOIN

    departments d ON d.dept_no = de2.dept_no

GROUP BY de2.emp_no, d.dept_name

WINDOW w AS (PARTITION BY de2.dept_no)

ORDER BY de2.emp_no, salary;


#Use a CTE (a Common Table Expression) and a SUM() function in the SELECT statement
# in a query to find out how many male employees have never signed a contract with a 
#salary value higher than or equal to the all-time company salary average.


WITH cte AS( SELECT AVG(s.salary) as avg_salary FROM salaries s) 
SELECT
SUM(CASE WHEN s.salary < c.avg_salary THEN 1 ELSE 0 END) AS no_salaries_below_avg,

COUNT(s.salary) AS no_of_salary_contracts

FROM salaries s JOIN employees e ON s.emp_no = e.emp_no AND e.gender = 'M' JOIN cte c;

#Use a CTE (a Common Table Expression) and (at least one) COUNT() function in the SELECT statement o
#f a query to find out how many male employees have never signed a contract with a salary value higher
# than or equal to the all-time company salary average.
 
 WITH cte AS (SELECT avg(salary) as avg_salary from salaries) 
 SELECT 
 count( CASE WHEN s.salary< avg_salary THEN s.salary ELSE NULL END) AS no_salaries_above_avg ,
count(s.salary) AS no_of_salary_contracts
 from salaries s
 join 
 employees e on s.emp_no = e.emp_no AND e.gender ='M' join cte c;


#Use MySQL joins (and don’t use a Common Table Expression) in a query to find out how many male 
#employees have never signed a contract with a salary value higher than or equal to the all-time 
#company salary average (i.e. to obtain the same result as in the previous exercise).

SELECT
    SUM(CASE
        WHEN s.salary < a.avg_salary THEN 1
        ELSE 0
    END) AS no_salaries_below_avg,
    COUNT(s.salary) AS no_of_salary_contracts
FROM
    (SELECT
        AVG(salary) AS avg_salary
    FROM
        salaries s) a
        JOIN
    salaries s
        JOIN
    employees e ON e.emp_no = s.emp_no AND e.gender = 'M';
    
    #Store the highest contract salary values of all male employees in a temporary table called male_max_salaries.
CREATE TEMPORARY TABLE male_max_salaries
SELECT 
     MAX(s.SALARY) AS highest_salary, e.emp_no 
FROM 
    salaries s
JOIN 
    employees e where e.emp_no = s.emp_no AND gender = 'M'
GROUP BY 
    s.emp_no;

#Write a query that, upon execution, allows you to check the result set contained in the 
#male_max_salaries temporary table you created in the previous exercise.

SELECT 
    *
FROM
    male_max_salaries;

#Create a temporary table called dates containing the following three columns:
# one displaying the current date and time,
# another one displaying two months earlier than the current date and time, and a
#third column displaying two years later than the current date and time.
CREATE temporary TABLE date
SELECT now(), date_sub(NOW(), INTERVAL 2 MONTH) AS two_months_earlier,
    DATE_SUB(NOW(), INTERVAL -2 YEAR) AS two_years_later;


#Write a query that, upon execution, allows you to check the result set contained 
#in the dates temporary table you created in the previous exercise.

SELECT

    *

FROM

    date dates;
#Create a query joining the result sets from the dates temporary table you created during the previous lecture with a new Common Table Expression (CTE) containing the same columns. Let all columns in the result set appear on the same row.

WITH cte AS (SELECT

    NOW(),

    DATE_SUB(NOW(), INTERVAL 2 MONTH) AS cte_a_month_earlier,

    DATE_SUB(NOW(), INTERVAL -2 YEAR) AS cte_a_year_later)

SELECT * FROM date d1 JOIN cte c;

#This time, combine the two sets vertically

WITH cte AS (SELECT

    NOW(),

    DATE_SUB(NOW(), INTERVAL 1 MONTH) AS cte_a_month_earlier,

    DATE_SUB(NOW(), INTERVAL -1 YEAR) AS cte_a_year_later)

SELECT * FROM date UNION SELECT * FROM cte;

#Drop the male_max_salaries and dates temporary tables you recently created.

DROP TABLE IF EXISTS male_max_salaries;
DROP TABLE IF EXISTS dates;
