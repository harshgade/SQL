-- To get all the tables in Selected Database 
select table_name 
from information_schema.tables
where table_schema = 'public';

-- Will be creating table followed by File Name = SQ (so that it is easy to understand Table belongs to which file)

-- Tables : 1) SQEmployee 2)SQDepartment 3)SQProject 4)SQEmployeeProject

create table SQEmployee (
   employeeID int primary key,
   firstName varchar(20),
   lastName varchar(20),
   departmentID int ,
   salary float
);

create table SQDepartment (
  departmentID int primary key ,
  departmentName varchar(20)
);

create table SQProject (
  projectID int primary key,
  projectName varchar(20),
  budjet float
);

-- EmployeeProject will have 2 foreign key columns first refering to Employee primary key 2) refer to Porject PK
create table SQEmployeeProject (
  employeeID int ,
  projectID int ,
  primary key (employeeID,projectID), -- this is syntax to follow When u want to mention multiple Primary Key's
  foreign key (employeeID) references SQEmployee(employeeID),
  foreign key (projectID) references SQProject(projectID)
);

-- Inserting Data into the tables 

insert into SQEmployee values 
 (1, 'John', 'Doe', 1, 60000),
 (2, 'Jane', 'Smith', 2, 75000),
 (3, 'Mike', 'Johnson', 1, 80000),
 (4, 'Emily', 'Davis', 3, 50000),
 (5, 'David', 'Wilson', 2, 90000);

insert into SQDepartment values 
 (1, 'IT'),
 (2, 'HR'),
 (3, 'Finance');

insert into SQProject values
 (101, 'Website Revamp', 200000),
 (102, 'Recruitment', 100000),
 (103, 'Audit', 150000);

insert into SQEmployeeProject values 
 (1,101),
 (2,102),
 (3,101),
 (4,103),
 (5,102),
 (5,103);




-- BEGINNER QUESTIONS 

-- Q1) Find the name of Employees working in IT department using ans Subquery
SELECT firstName , lastName
FROM SQEmployee 
WHERE departmentID = (select departmentID from SQDepartment where departmentName = 'IT');

-- Q2) List all employees whose salary is above the average salary of all employees
SELECT firstName , lastName , salary 
FROM SQEmployee 
WHERE salary > (select avg(salary) from SQEmployee);

-- Q3) Find name of Projects where the budget is higher than the average budget of all projects
SELECT projectName 
FROM SQProject
WHERE budjet > (select avg(budjet) from SQProject);


-- Q4) Display the names of employees who are not assigned to any project.
SELECT firstName , lastName 
FROM SQEmployee 
WHERE employeeID NOT IN (select employeeID from SQEmployeeProject);
-- here since all the employees have been assigned project : No names will be displayed 


-- Q5) Retrieve the names of departments with no employees using a subquery.
SELECT departmentName
FROM SQDepartment
WHERE  departmentID NOT IN (select departmentID from SQEmployee);
--since all the departments have employees so No departmentName will be displayed





-- INTERMEDIATE QUESTIONS  

-- Q6) Find the highest salary in each department using a subquery.
SELECT departmentName ,  -- made alias for departmentName as d for SQDepartment table
   (select max(salary) from SQEmployee where departmentID = SQDepartment.departmentID)
FROM SQDepartment;

-- using simple query (will join Employee & Department table where departmentID from both table should match) and 
-- use GROUP BY departmentName so that 
select departmentName , max(salary) as HighestSalary 
from SQEmployee as e
join SQDepartment as d on e.departmentID = d.departmentID
group by departmentName;


-- Q7) List employees who are working on at least one project.
-- will use DISTINCT so emp are not repeated if they are assigned more time : JOIN on SQEmployeeProject on cond
-- empID from both table should match 
SELECT distinct e.firstName , e.lastName
FROM SQEmployee as e
JOIN SQEmployeeProject as ep ON e.employeeID = ep.employeeID;
-- all the emp names will be displayed cause all of them are assigned an project 


-- Q8) Display the names of employees who are working on the 'Website Revamp' project.
SELECT e.firstName , e.lastName
FROM SQEmployee as e
JOIN SQEmployeeProject as ep on e.employeeId = ep.employeeID
JOIN SQProject as p on ep.projectId = p.projectID
WHERE projectName = 'Website Revamp';
-- Explanation : empid not in Project table : first join on EmployeeProject will see if employeeID is there if it 
-- is there then it means it will also have projectID assigned to it : next join on Project table where we will see
-- if projectID of EmployeeProject matched with projectId of ProjectTable : then we will mention the criteria check
-- where projectName is mentioned as 'Website Revamp' : by apllying all this logic we will get the employee names 
-- who are assigned to project = Website Revamp 



-- Q9) Find the total budget for projects handled by employees from the HR department.
SELECT sum(p.budjet) as TotalBudget
FROM SQProject as p
JOIN SQEmployeeProject as ep ON p.projectId = ep.projectID
JOIN SQEmployee as e ON ep.employeeID = e.employeeID
WHERE e.departmentID = (select departmentID from SQDepartment where departmentName = 'HR');


-- Q10) Retrieve the names of employees whose salary is greater than the salary of 'John Doe'
select firstName , lastName 
from SQEmployee 
where salary > (select salary from SQEmployee where firstName = 'John' and lastName = 'Doe');


-- Q11) Display the names of departments that have employees earning more than 80000.
SELECT DISTINCT departmentName 
FROM SQDepartment as d
JOIN SQEmployee as e ON d.departmentId = e.departmentID
WHERE e.salary > 80000;




-- ADVANCE QUESTIONS 

-- Q12) Display employees who work on projects with a budget greater than the budget of the 'Audit' project.
select distinct e.firstName , e.lastName 
from SQEmployee as e 
JOIN SQEmployeeProject as ep on e.employeeID = ep.employeeID
JOIN SQProject as p on ep.projectId = p.projectID
where p.budjet > (select budjet from SQProject where projectName = 'Audit');


-- Q13) Retrieve the name of the project with the highest budget using a subquery
select projectName 
from SQProject 
where budjet =  (select max(budjet) from SQProject);


-- Q14) Find employees who do not work on projects with budgets above 150000.
select firstName , lastName 
from SQEmployee 
WHERE employeeID not in (
           select distinct ep.employeeID
		   from SQEmployeeProject as ep
		   join SQProject as p on ep.projectID = p.projectID
		   where p.budjet > 150000
);


-- Q15) List employees who earn more than the average salary of their respective departments.
-- here we will make 2 aliases for Employee table so that we can compare their departmentID
select firstName , lastName 
from SQEmployee as e
where salary > (
    select avg(e2.salary) 
	from SQEmployee as e2
	where e2.departmentID = e.departmentID
);


-- Q16) Retrieve the names of employees who work on projects with budgets lower than the average budget 
-- of all projects.
select distinct firstName , lastName 
from SQEmployee as e
join SQEmployeeProject as ep on e.employeeID = ep.employeeID
join SQProject as p on ep.projectID = p.projectID
where budjet < (
     select avg(budjet) from SQProject
);








