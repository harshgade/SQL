---------------------------------------  RANK() with Questions -----------------------------------------------------

-- The RANK() function in SQL is used to assign a rank to each row in a result set based on a specific column values.
-- It assigns the same rank to rows with the same value and skips the next rank(s) accordingly.

CREATE TABLE Employees (
    EmpID INT PRIMARY KEY,
    Name VARCHAR(50),
    Department VARCHAR(50),
    Salary INT
);

insert into Employees values 
 (1, 'Alice', 'HR', 60000),
 (2, 'Bob', 'IT', 75000),
 (3, 'Charlie', 'IT', 75000),
 (4, 'David', 'HR', 58000),
 (5, 'Emma', 'Finance', 82000),
 (6, 'Frank', 'IT', 90000),
 (7, 'Grace', 'Finance', 82000),
 (8, 'Harry', 'HR', 70000),
 (9, 'Ivy', 'IT', 72000);


-- Q1) Rank employees based on salary (highest to lowest)
select name , department , salary,
    rank() over (order by salary desc) as EmployeeSalaryRank
from employees;


-- Q2) Rank employees within each department based on salary
select name , department , salary,
   rank() over (partition by department order by salary desc) as EmployeeSalaryRank
from employees;


-- Q3) Find the highest-paid employee(s) in each department.
-- here we will use Common table expression
with RankedEmployees as (
    select name , department , salary ,
	rank() over (partition by department order by salary desc) as departmentsalaryrank
	from employees
)

select name , department , salary 
from RankedEmployees -- common table name
where departmentsalaryrank = 1; -- col where we have filtered the data in common-table-expression


-- Q4) Find employees whose salary rank is exactly 3 in the company.
-- here also we will use common table expression 
with SalaryRanking as (
   select name , department , salary ,
   rank() over (partition by department order by salary desc) as departmentsalaryrank
   from employees
)

select name , department , salary 
from SalaryRanking 
where departmentsalaryrank = 3;


-- Q5) Find the employee details whose salary is highest in the employees table 
-- here we will use rank() with common table expression 
-- here if more employees have same salsry which is the highest one the all of those name will be displayed :
with SalaryRanking as (
   select name , department , salary , 
   rank() over (order by salary desc) as employeesalaryrank
   from employees
)

select name , department , salary 
from SalaryRanking 
where employeesalaryrank = 1;
-- where employeesalaryrank = 1  limit 1; -- if you want to show only 1 employee then here we used LIMIT 1



-- Q6)  Rank employees by salary and fetch only those ranked between 2 and 5.
with SalaryRanking as (
  select name , department , salary ,
      rank() over (order by salary desc) as employeesalaryrank
	  from employees
)

select name , department , salary
from SalaryRanking 
where employeesalaryrank <= 3;




---------------------------------------  DENSE_RANK() with Questions  -------------------------------------------

-- The DENSE_RANK() function is a window function that assigns a rank to each row within a partition of a 
-- result set. Unlike RANK(), DENSE_RANK() does not skip ranking numbers when there are duplicate values.

create table employees2 (
  id int primary key,
  name varchar(20),
  department varchar(20),
  salary int 
);


insert into employees2 values 
(1, 'Alice', 'HR', 60000),
(2, 'Bob', 'IT', 75000),
(3, 'Charlie', 'IT', 75000),
(4, 'David', 'HR', 60000),
(5, 'Eva', 'Sales', 80000),
(6, 'Frank', 'Sales', 72000),
(7, 'Grace', 'IT', 75000),
(8, 'Helen', 'HR', 60000),
(9, 'Ian', 'Sales', 80000),
(10, 'Jake', 'IT', 90000);


-- Q1)  Rank employees based on salary in descending order. using DENSE_RANK()
select name , department , salary,
   dense_rank() over (order by salary desc) as salaryrank
from employees2;

-- Q2) Rank employees based on salary within each department. using DENSE_RANK()
select name , department , salary , 
   dense_rank() over (partition by department order by salary desc) as departmentsalary
from employees2;
   
-- Q4) Find the top 3 highest-paid employees using DENSE_RANK()
-- here we will use CTE common table expression
with rankedEmployees as (
  select name , department , salary ,
     dense_rank() over (order by salary desc) as salaryrank
  from employees2
)

select name , department , salary 
from rankedEmployees
where salaryrank <= 3;


-- Q5) Find the second-highest salary in each department using DENSE_RANK()
with secondHighestSalary as (
   select department , salary,
     dense_rank() over (order by salary desc) as salaryrank
   from employees2
)

select department , salary 
from secondHighestSalary 
where salaryrank = 2;


-- Q6) Rank employees based on salary in descending order, but only for IT and Sales departments.
select * , 
    dense_rank() over (partition by department order by salary desc) as salaryrank
from employees2
where department in ('IT','Sales');
-- here used partition by department so all the data from IT comes bundled & data from Sales comes bundled


-- Q7)  List employees who have a DENSE_RANK() of 2 or higher in their department based on salary.
with employeerank as (
     select id , name , department , salary,
	    dense_rank() over (partition by department order by salary desc) as salaryrank
	from employees2
)

select id , name , department , salary 
from employeerank 
where salaryrank >=2;



-------------------------------------------- ROW_NUM() with Questions  -------------------------------------------

-- The ROW_NUMBER()  is a window function in SQL that assigns a unique row number to each row 
-- within a partition of a result set. The numbering starts at 1 for each partition and increments sequentially.

-- Do not give same number to duplicates gives unique no to all the rows 
-- Restarts the Numbering from 1 for Each Partition 

create table employees3 (
   id int primary key , 
   name varchar(20),
   department varchar(20),
   salary int , 
   joiningDate date 
);

insert into employees3 values 
 (1, 'Alice', 'HR', 60000, '2020-05-15'),
 (2, 'Bob', 'IT', 75000, '2019-08-23'),
 (3, 'Charlie', 'Finance', 80000, '2021-01-10'),
 (4, 'David', 'IT', 72000, '2018-11-30'),
 (5, 'Eva', 'HR', 65000, '2022-03-18'),
 (6, 'Frank', 'Finance', 85000, '2017-07-11'),
 (7, 'Grace', 'IT', 77000, '2020-09-25'),
 (8, 'Helen', 'Finance', 82000, '2019-06-12');



-- Q1) Assign a unique row number to all employees ordered by salary in descending order.
select id , name , department , salary,
  row_number() over (order by salary desc) as row_num 
from employees3;


-- Q2) Assign a row number to employees within each department, ordered by salary in descending order.
select id , name , department , salary ,
   row_number() over (partition by department order by salary desc) as row_num
from employees3;


-- Q3)  Retrieve the top 2 highest-paid employees in each department
-- here we will use CTE common table expression 
with rank as (
   select id , name , department , salary ,
      row_number() over (partition by department order by salary desc) as salaryrank
	from employees3
)

select name , department , salary 
from rank 
where salaryrank <=2;


-- Q4) Assign a row number to employees based on their joining date (earliest first).
select id , name , department , salary , joiningDate,
   row_number() over (order by joiningDate asc) as joiningrank
from employees3;


-- Q5) Find the employee who joined first in each department. (here will allot on basis of joiningDate)
with firstEmployee as (
   select id , name , department , salary , joiningDate , 
      row_number() over (partition by department order by joiningdate asc) as joiningrank
   from employees3
)

select id , name , department , salary ,  joiningDate 
from firstEmployee 
where joiningrank = 1;


-- Q6) Assign a row number to employees based on department and joining date (earliest first).
select id , name , department , salary , joiningDate ,
   row_number() over (partition by department order by joiningDate asc) as joiningrank
from employees3;


-- Q7) Find the third highest-paid employee overall.
-- here also we will use CTE : common table expression
with highestPaidEmployee as (
    select id , name , department , salary ,
	   row_number() over (order by salary desc) as salaryrank
	 from employees3
)

select id , name , department , salary 
from highestPaidEmployee 
where salaryrank = 3;


-- Q8) Get the second most recently joined employee in each department.
-- here also we will use CTE : common table expression
with recentJoining as (
   select id , name , department  , joiningDate , 
      row_number() over (partition by department order by joiningDate asc) as joiningrank
   from employees3
)

select id , name , department  
from recentJoining 
where joiningrank = 2;




-------------------------------------------- Agregate Window Function's -------------------------------------------

-- WE WILL BE USING THE SAME TABLE = employees3

-- SUM() 
-- SUM() function used to find Cumulative Sum of values based on Partition
-- Means if partition is Same : then it sums currentRow + previousRow based on value we mention we want sum of it 

-- SUM of salary : partition on department : Order the data bases on = id (by default if not mention ) it = ASC
select id , name , department , salary ,
   sum(salary) over (partition by department order by id asc) as salarysum
from employees3;


-- AVG() : function computes the average value of a column for a given window.
-- find the average salary per department 
select id , name , department , salary , 
   round(avg(salary) over (partition by department ),2) as avgsalary
from employees3;


-- MIN() : function returns the smallest value within the window.
-- find the minimum salary , per department 
select id , name , department , salary ,
   min(salary) over (partition by department ) as minsalary
from employees3;


-- MAX() : function returns the largest value within the window 
-- find the maximum salalry , per department 
select id , name , department , salary , 
  max(salary) over (partition by department ) as maxsalary
from employees3;



----------------------------------------------- VALUE Function's -------------------------------------------------

-- will be creating an new Table named => employees
create table employees4 (
  id int primary key ,
  name varchar(50),
  salary int 
);

insert into employees4 values 
 (1, 'Alice', 50000),
 (2, 'Bob', 60000),
 (3, 'Charlie', 70000),
 (4, 'David', 80000);


-- LEAD() function fetches the value from the next row in a specified order.
-- will fetch salary Order by id

select id , name , salary ,
  lead(salary) over (order by id asc) as nextsalary
from employees4;


-- LAG() : function fetches the value from the previous row in a specified order.
-- will fetch salary order by id 

select id , name , salary ,
  lag(salary) over (order by id asc) as previoussalary
from employees4;

-- FIRST_VALUE() : function returns the first value in an ordered set.
-- fetch salary order by id

select id , name , salary , 
   first_value(salary) over (order by id ) as firstsalary
from employees4;

-- LAST_VALUE : function returns the last value in an ordered set within a window
-- fetch salary order by id 
select id , name , salary , 
   last_value(salary) over (order by id rows between unbounded preceding and unbounded following) as lastsalary
from employees4;









