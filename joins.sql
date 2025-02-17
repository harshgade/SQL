-- Used to display all tha Tables we have in the Current Database that we are present 
select table_name 
from information_schema.tables
where table_schema = 'public';

create table Student (
  student_id int primary key ,
  name varchar(20)
);

create table Enrollment(
  enrollment_id int ,
  student_id int ,
  course_id int ,
  foreign key (student_id) references Student(student_id)
);

insert into Student values 
(1,'harsh gade'),
(2,'rajeshree gade'),
(3,'jay sinroja'),
(4,'maithili malbari');


insert into Enrollment values 
(1,1,101),
(2,2,102),
(3,4,102);

select * from Student;

-- Inner join (returns resultant table of common data from both the column) 
-- in Enrollment we have not mentioned data for student_id 3 so it will not be displayed in resultant table 
select  s.student_id , s.name , e.course_id
from Student as s
inner join Enrollment as e on s.student_id = e.student_id;


-- LEFT JOIN (mentioned column all from Student , matching data from Enrollment , NULL if not match from Enrollment)
-- Output we want : student_id , name , course_id
select s.student_id , s.name , e.course_id
from Student as s
left join Enrollment as e on s.student_id = e.student_id;


-- RIGHT JOIN (all data from mentioned col from right and matching data from Student if not match NULL  )
-- Output we want : student_id , name , course_id (will not get data of student_id 3 cause is not in Enrollment
select s.student_id , s.name , e.course_id
from Student as s
right join Enrollment as e on s.student_id = e.student_id;

-- FULL JOIN : Returns all the Rows from selected column we want And if no matched is found returns NULL  
-- (we want student_id , name , course_id ) 
select s.student_id , s.name , e.course_id 
from Student as s
FULL JOIN Enrollment as e ON s.student_id = e.student_id;


-- CROSS JOIN 
-- will create two table 1) Product 2) Categories and will apply cross join on those table 
-- Product Table (ProductName) CROSS JOIN Categories Table (CategoryName)

create table Product (
   productID int,
   productName varchar(20)
);

create table Categories (
 categoryID int , 
 categoryName varchar(20)
);

insert into Product values 
(1,'Laptop'),
(2,'Phone');

insert into Categories values 
(10,'Electronics'),
(20,'Accesories');


-- cross join implementation
select p.productName , c.categoryName 
from Product as p
cross join Categories as c;



-- SELF JOIN 
-- We can Perorm Self Join by using Inner or Left join 
-- Example we have an Employee table 1)empid 2)empname 3)managerid (if manager = empid (name) of an employee)
-- Question : Find the name of respective managers for each of the employees 

create table Employee (
   empid int primary key,
   empname varchar(20),
   managerid int
);

insert into Employee values 
 (1,'Agni',3),
 (2,'Akash',4),
 (3,'Dharti',2),
 (4,'Vayu',3);

-- we will make 2 alias for empname cause 1) Employee 2) Manager (which again is Employee name only)
select e.empname as Employee , m.empname as Manager
from Employee as e 
inner join Employee as m on e.managerid = m.empid;
-- if employee ki managerid = manager ki empid (then uss employe ka name mention karo manager wale col mai)




