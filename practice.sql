#Select the information from the “dept_no” column of the “departments” table.
Use employees;
SELECT 
    dept_no
FROM
    departments;

#Select all people from the “employees” table whose first name is “Elvis”. 
SELECT 
    *
FROM
    employees
WHERE
    first_name = 'Elvis' ;
 #Retrieve a list with all female employees whose first name is Kellie. 
 
SELECT 
    *
FROM
    employees
WHERE
    first_name = 'Kellie' AND gender = 'F';
    
 #Retrieve a list with all employees whose first name is either Kellie or Aruna.
   
SELECT 
    *
FROM
    employees
WHERE
    first_name = 'Kellie' OR first_name = 'Auna';
    
#Retrieve a list with all female employees whose first name is either Kellie or Aruna.

    SELECT 
    *
FROM
    employees
WHERE
	gender = 'F'  AND (first_name = 'Kellie' OR first_name = 'Auna') ;

#Use the IN operator to select all individuals from the “employees” table, whose first name is either “Denis”, or “Elvis”.
    
     SELECT 
    *
FROM
    employees
WHERE 
    first_name IN ('Denis', 'Elvis');
    
#Extract all records from the ‘employees’ table, aside from those with employees named John, Mark, or Jacob.
SELECT 
    *
FROM
    employees
WHERE 
    first_name NOT IN ('John', 'Mark' , 'Jacob');
    
#Working with the “employees” table, 
#use the LIKE operator to select the data about all individuals, whose first name starts with “Mark”; 
#specify that the name can be succeeded by any sequence of characters.

SELECT 
    *
FROM
    employees
WHERE 
    first_name LIKE ('Mark%');
    
#Retrieve a list with all employees who have been hired in the year 2000.
SELECT 
    *
FROM
    employees
WHERE 
    hire_date LIKE ('%2000%');
 
#Retrieve a list with all employees whose employee number is written with 5 characters, and starts with “1000”. 
    SELECT 
    *
FROM
    employees
WHERE 
    emp_no LIKE ('1000_');
    
#Extract all individuals from the ‘employees’ table whose first name contains “Jack”.

    SELECT 
    *
FROM
    employees
WHERE 
    first_name LIKE ('%Jack%');
#Once you have done that, extract another list containing the names of employees that do not contain “Jack”.
SELECT 
    *
FROM
    employees
WHERE 
    first_name NOT LIKE ('%Jack%');
    
#Select all the information from the “salaries” table regarding contracts from 66,000 to 70,000 dollars per year.
    
SELECT 
    *
FROM
    salaries
WHERE 
    salary BETWEEN 66000 AND 70000;
    
#Retrieve a list with all individuals whose employee number is not between ‘10004’ and ‘10012’.

SELECT 
    *
FROM
    employees
WHERE
    emp_no NOT BETWEEN '10004' AND '10012';
    
#Select the names of all departments with numbers between ‘d003’ and ‘d006’.
SELECT 
    dept_name
FROM
    departments
WHERE
    dept_no BETWEEN 'd003' AND 'd006';
    
#Select the names of all departments whose department number value is not null.
SELECT 
    dept_name
FROM
    departments
WHERE
    dept_no IS NOT NULL;

#Retrieve a list with data about all female employees who were hired in the year 2000 or after.

SELECT 
    *
FROM
    employees
WHERE
    hire_date >= '2000-01-01' AND gender = 'F';
    
#Extract a list with all employees’ salaries higher than $150,000 per annum.

SELECT 
    *
FROM
    salaries
WHERE
    salary > '150000';

#Obtain a list with all different “hire dates” from the “employees” table.
SELECT DISTINCT
    hire_date
FROM
    employees;
    
    
#How many annual contracts with a value higher than or equal to $100,000 have been registered in the salaries table?

SELECT 
    COUNT(*)
FROM
    salaries
WHERE
    salary >= 100000;
    
 #How many managers do we have in the “employees” database? Use the star symbol (*) in your code to solve this exercise.
SELECT 
    COUNT(*)
FROM
    dept_manager;   
    
#Select all data from the “employees” table, ordering it by “hire date” in descending order.

SELECT 
    *
FROM
    employees
ORDER BY hire_date DESC;

#Write a query that obtains an output whose first column must contain 
#annual salaries higher than 80,000 dollars. 
#The second column, renamed to “emps_with_same_salary”,
# must show the number of employee contracts signed with this salary.

SELECT 
    salary, COUNT(emp_no) AS 'emps_with_same_salary'
FROM
    salaries
WHERE
    salary > 80000
GROUP BY salary
ORDER BY salary;

#Select all employees whose average salary is higher than $120,000 per annum.

SELECT 
   emp_no, AVG(salary) AS 'average salary'
FROM
    salaries
GROUP BY emp_no
HAVING AVG(salary) > 120000
ORDER BY emp_no;

#Select the employee numbers of all individuals who have signed more than 1 contract after the 1st of January 2000.
SELECT 
    emp_no
FROM
    dept_emp
WHERE
    from_date > 2000 - 01 - 01
GROUP BY emp_no
HAVING COUNT(from_date) > 1
ORDER BY emp_no;

#Select the first 100 rows from the ‘dept_emp’ table. 
 
SELECT 
    *
FROM
    dept_emp
LIMIT 100;

#How many departments are there in the “employees” database? 

SELECT 
    COUNT( DISTINCT dept_no)
FROM
    dept_emp;
    
#What is the total amount of money spent on salaries for all contracts starting after the 1st of January 1997?

SELECT 
    SUM(salary)
FROM
    salaries
WHERE
    from_date > '1997-01-01';
    
#Which is the lowest employee number in the database?
SELECT
    MIN(emp_no)
FROM
    employees;
#Which is the highest employee number in the database?
SELECT
    MAX(emp_no)
FROM
    employees;
    
#What is the average annual salary paid to employees who started after the 1st of January 1997?
SELECT 
    AVG(salary)
FROM
    salaries
WHERE
    from_date > '1997-01-01';

#Round the average amount of money spent on salaries for all contracts that started after the 1st of January 1997 to a precision of cents.

SELECT 
    ROUND(AVG(salary), 2)
FROM
    salaries
WHERE
    from_date > '1997-01-01';
    
    
#duplicate tables
DROP TABLE IF EXISTS departments_dup;

CREATE TABLE departments_dup (
    dept_no CHAR(4) NULL,
    dept_name VARCHAR(40) NULL
);

 

INSERT INTO departments_dup

(

    dept_no,

    dept_name

)SELECT

                *

FROM

                departments;

 

INSERT INTO departments_dup (dept_name)

VALUES                ('Public Relations');

 

DELETE FROM departments_dup 
WHERE
    dept_no = 'd002'; 


INSERT INTO departments_dup(dept_no) VALUES ('d010'), ('d011');

DROP TABLE IF EXISTS dept_manager_dup;

CREATE TABLE dept_manager_dup (

  emp_no int(11) NOT NULL,

  dept_no char(4) NULL,

  from_date date NOT NULL,

  to_date date NULL

  );

 

INSERT INTO dept_manager_dup

select * from dept_manager;

 

INSERT INTO dept_manager_dup (emp_no, from_date)

VALUES                (999904, '2017-01-01'),

                                (999905, '2017-01-01'),

                               (999906, '2017-01-01'),

                               (999907, '2017-01-01');

 

DELETE FROM dept_manager_dup

WHERE

    dept_no = 'd001';


SELECT 
    m.dept_no, m.emp_no, d.dept_name
FROM
    dept_manager_dup m
        INNER JOIN
    departments_dup d ON m.dept_no = d.dept_no
ORDER BY m.dept_no;

#Extract a list containing information about all managers’ employee number, 
#first and last name, department number, and hire date. 

SELECT 
    d.emp_no, d.dept_no, e.first_name, e.last_name, e.hire_date
FROM
    employees e
        INNER JOIN
    dept_manager d ON d.emp_no = e.emp_no;
    
#Join the 'employees' and the 'dept_manager' tables to return a subset of all 
#the employees whose last name is Markovitch. See if the output contains a manager with that name.  

SELECT 
    e.emp_no,
    e.last_name,
    e.last_name,
    e.first_name,
    d.dept_no,
    d.from_date
FROM
    employees e
        LEFT JOIN
    dept_manager d ON d.emp_no = e.emp_no
WHERE
    e.last_name = 'Markovitch'
ORDER BY d.dept_no DESC , d.emp_no;



