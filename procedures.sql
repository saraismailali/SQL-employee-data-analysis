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
    
