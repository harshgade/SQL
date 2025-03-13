------------------------------------------ WINDOW's FUNCTION QUESTIONS ----------------------------------------------
-- 25 question Begginer to Advance level All Windows Function covered 
create table employee (
  id int primary key ,
  name varchar(20),
  department varchar(20),
  salary int , 
  joiningDate  date
);

insert into employee values 
(1, 'Alice', 'HR', 50000, '2020-01-10'),
(2, 'Bob', 'IT', 60000, '2019-03-15'),
(3, 'Charlie', 'IT', 75000, '2018-07-24'),
(4, 'David', 'Finance', 80000, '2021-11-05'),
(5, 'Eve', 'HR', 65000, '2022-02-20'),
(6, 'Frank', 'IT', 90000, '2017-05-13'),
(7, 'Grace', 'Finance', 72000, '2020-08-30'),
(8, 'Hank', 'IT', 88000, '2016-12-11'),
(9, 'Ivy', 'HR', 57000, '2021-06-09'),
(10, 'Jack', 'Finance', 50000, '2019-09-17');


-- Q1) Assign a rank to employees based on their salary (highest first).
select id , name , department , salary , 
   rank() over (order by salary desc) as salaryrank
from employee;

-- Q2) Assign a dense rank to employees based on salary(highest first).
select id , name , department , salary , 
   dense_rank() over (order by salary desc) as salaryrank
from employee;


-- Q3) Assign a row number to employees ordered by salary.
select id , name , department , salary ,
   row_number() over (order by salary desc) as salaryrank
from employee;


-- Q4) Rank employees within each department based on salary.
select id , name ,  department , salary , 
   rank() over (partition by department order by salary desc) as salaryrank
from employee;


-- Q5) Dense rank employees within each department based on salary 
select id , name , department , salary , 
   dense_rank() over (partition by department order by salary desc) as salaryrank
from employee;


-- Q6) Row number employees within each department based on salary 
select id , name , department , salary , 
   row_number() over (partition by department order by salary desc) as salaryrank
from employee;


-- Q7) Find the highest salary per department using RANK.
-- here we will use CTE common table expression 

with rankemployees as (
   select id , name , department , salary , 
      rank() over (partition by department order by salary desc) as salaryrank
	from employee
)

select  department , salary 
from rankemployees 
where salaryrank = 1;


-- Q8) Find the second highest salary in the table
-- will use Dense_rank cause it does not skips value if duplicates / give same value if salary (value) is same
-- will also use here CTE common table expression 
with secondhighest as (
    select id , name , department , salary , 
	    dense_rank() over (order by salary desc) as salaryrank
	from employee
)

select id , name , department , salary 
from secondhighest
where salaryrank = 2;


-- Q9) Find the lowest-paid employee in each department using ROW_NUMBER.
-- here we will use CTE common table expression , will sort in ascending so that we can get the lowest to highest
with lowestpaid as (
   select id , name , department , salary , 
      row_number() over (partition by department order by salary asc) as salaryrank
	from employee
)

select id , name , department , salary 
from lowestpaid 
where salaryrank = 1;


-- Q10) Find the total/sum salary in each department. 
-- partion on department , order by id in ASC (so employees are order by id in each department)
select id , name , department , salary , 
   sum(salary) over (partition by department order by id asc) as salarysum
from employee;

-- If we want to show in one row itself the sum of the particular department 
select department , sum(salary) as department_sum from employee group by department


-- Q11) Find the average salary in each department.
-- partion by department 
-- will also Round it to 2 decimals
select id , name , department , salary , 
   round(avg(salary) over (partition by department),2) as avgsalary
from employee;


-- Q12) Find the highest salary in each department.
-- here we will use MAX() function 
select id , name , department , salary , 
    max(salary) over (partition by department) as maxsalary
from employee;


-- Q13)  Find the lowest salary in each department.
-- here will use MIN() function 
select id , name , department , salary , 
   min(salary) over (partition by department) as minsalary
from employee;


-- Q14) Find cumulative salary distribution across all employees.
-- Cumulative means Sum puchraha hai salary ka , Salary in descending order 
select id , name , department , salary , 
   sum(salary) over (order by salary desc) as salarysum
from employee;


-- Q15) Compare each employee’s salary with the next highest using LEAD.
select id , name , department , salary , 
   lead(salary) over (order by salary asc) as nextHighSalary
from employee;

-- Q16) Find the first employee who joined the company.
select id , name , 
   first_value(name) over (order by joiningDate) as firstEmployee
from employee;

-- Q17) Find the most recent employee who joined each department.
-- here we use LAST_VALUE() on joiningDate cause the last one to join is the most recent employee 
-- To get Correct Value will use : ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING 
select id , name , department ,
   last_value(name) over (partition by department order by joiningDate desc ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) as mostrecent
from employee;
