----------------------------------------------------
CREATING AND EXECUTING STORED PROCEDURES
----------------------------------------------------

-- Create table employees  
create table employee (
   id int primary key,
   name varchar(50),
   salary int
);


-- Create a Procedure to Insert the data 
CREATE PROCEDURE add_employee (in emp_id int , in emp_name varchar , in emp_salary int) -- these are parameters 
LANGUAGE plpgsql
AS $$
BEGIN 
    insert into employee (id , name , salary) values (emp_id,emp_name,emp_salary);
END;
$$;

-- Insert data using the stored procedure usin CALL 
CALL add_employee(1,'harsh sunil gade',100000);
CALL add_employee(2,'harshal arjun korathkar',20000);
CALL add_employee(3,'jay uday sinroja',200000);
CALL add_employee(4,'vraj sheth',200000);
CALL add_employee(5,'clive amral',20000);

-- Verify if  data is inserted or not 
select * from employee;




-- Creating Stored Procedure : 
-- will be retrieving salary on basis of id (will take from user)
CREATE PROCEDURE get_salary(IN emp_id int , OUT emp_salary int) 
LANGUAGE plpgsql
AS $$ 
BEGIN  -- logic
      select salary INTO emp_salary from employee where id = emp_id;
END;
$$;

-- Get salary based on employee id using the stored procedure we created 
select * from employee; -- shows the entire table and we can select whatever id we want and will get salary of it 

CALL get_salary(1,null) -- mention null cause OUTparameter cannot accept input values , passing NULL ensures 
-- the value is Uninitialized before the procedure assigns a result.




-- Create Stored Procedure to update New salary based on id
--  (new_salary : INOUT cause we want to mention new_salary  update it for that id & we also want to retrieve updated new_salary )

CREATE PROCEDURE update_salary (IN emp_id int,INOUT new_salary int)
LANGUAGE plpgsql
AS $$ 
BEGIN 
     update employee set salary = new_salary where id = emp_id;
END;
$$;

-- CALL the update_salary procedure and give new salary for an employee based on id 
select * from employee -- to get previous salary 

CALL update_salary(1,100000000);
CALL get_salary(1,null); -- check if salary is updated using get_salary Stored Procedure
select * from employee where id = 1;  -- displays entire infor for id = 1





-- Create Stored Procedure : to delete Employee based on id
CREATE PROCEDURE delete_employee(IN emp_id int)
LANGUAGE plpgsql 
AS $$
BEGIN 
     delete from employee where id = emp_id;
END;
$$;

-- CALL procedure to delete an employee and pass the id 
select * from employee order by id; -- to select an particular id 
CALL delete_employee(1) -- will delete employee where id=1

select * from employee where id = 1; -- check if data got deleted (is should not display any info)


	 




