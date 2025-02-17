-- UNION 
-- We have two table , we want all data excluding repetetion ) we will implement UNION 

create table Student2 (
  student_id int primary key ,
  student_name varchar(20),
  student_marks int
);


create table Graduates (
  graduate_id int primary key , 
  graduate_name varchar(20),
  graduate_marks int
);


insert into Student2 values 
(1,'Harsh Gade',90),
(2,'Jay Sinroja',85),
(3,'Kirti Naik',100);

insert into Graduates values 
(1,'Harsh Gade',99),
(2,'Jay Sinroja',85),
(3,'Rajeshree Gade',100);

select * from Student2;
select * from Graduates;



-- Harsh Gade marks are different in Both tables so its both entries will be displayed cause its not duplicates
-- Output : we want Name , Marks from both the tables using UNION (no duplicate data will be displayed)
select student_name , student_marks from Student2 
UNION 
select graduate_name , graduate_marks from Graduates;


-- UNION ALL 
-- know Duplicates will also be displayed Example : Jay Sinroja , 85 
select student_name , student_marks from Student2
UNION ALL 
select graduate_name , graduate_marks from Graduates;



