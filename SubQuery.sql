-- Create table followed by FileName they belongs to such that we can know for which purpose the table was made for

-- Used to see All Tables present in selected Database
select table_name 
from information_schema.tables
where table_schema = 'public';


-- Topic : SELECT Clause with Subquey
-- Given : employees table (id,name,department,salary) 

create table subqueryEmployee (
   id int primary key,
   name varchar(20),
   department varchar(20),
   salary int
);

insert into subqueryEmployee values 
 (1,'John','HR',50000),
 (2,'Alice','IT',60000),
 (3,'Bob','HR',80000),
 (4,'Charlie','IT',70000);

-- Query : Calculate the average salary for all employees and display it along with the employee name 
SELECT name, -- select entire data from subqueryEmployee Table
-- cal average salary for each employee and display  it by creating an column named AverageSalary
(select avg(salary) from subqueryEmployee) as AverageSalary 
FROM subqueryEmployee;




-- UPDATE Clause With Subquery 
-- We want to update the salary of HR employees to the average salary of IT employees.
UPDATE subqueryEmployee
SET salary = (select avg(salary) from subqueryEmployee where department='IT')
WHERE department = 'HR';




-- DELETE Clause With Subquery 
-- We want to delete employees from the employees table who are listed in the terminated_employees table.
-- For this we will create subqueryTerminatedEmployees table

create table subqueryTerminatedEmployees (
   id int primary key , 
   name varchar(20)
);

insert into subqueryTerminatedEmployees values 
(2,'Alice');

DELETE FROM subqueryEmployee 
where id in (select id from subqueryTerminatedEmployees);

-- retrive all data to check if Alice ka data hat chuka hai ki nahi 
select * from subqueryEmployee;




-- WHERE Clause with Subquery 
-- We want to select of employees in the HR department who earn more than the average salary of employees 
-- in the  IT department.
SELECT name , salary 
FROM subqueryEmployee WHERE department = 'HR' 
AND salary > (SELECT avg(salary) from subqueryEmployee where department = 'IT');



 




