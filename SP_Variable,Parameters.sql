------------------------------------
VARIABLE & PARAMETERS
------------------------------------

-- Creating an employee table 
create table employee (
   id int , 
   name varchar(50),
   salary int
);


-- Create an Stored Procedure to insert data into the table employee 
create procedure insert_data(IN emp_id int , IN emp_name varchar , IN emp_salary int)
language plpgsql 
as $$
begin 
     insert into employee(id,name,salary) values (emp_id,emp_name,emp_salary);
end;
$$;

-- Used the insert_data procedure to insert records in table employee
call insert_data(1,'harsh gade',20000);
call insert_data(2,'jay sinroja',12000);
call insert_data(3,'mohit sorathiya',20000);
call insert_data(4,'rajeshree gade',100000);
call insert_data(5,'rahul anarase',1000);
call insert_data(6,'mahesh joshi',19000);

select * from employee -- check if data is inserted ?


---------------------------------------------------------------
Declaring and Using an Variable inside an Stored Procedure 
---------------------------------------------------------------

-- Create an Stored Procedure to give Bonus of 10% (salary*0.10) to the mentioned emp_id (the procedure must retunrn
-- the emp_id and bonus )
create procedure bonus(IN emp_id int)
language plpgsql
as $$
declare
    emp_salary decimal;
    bonus decimal;
begin
     -- retrieve salary for that employee_id
	 select salary into emp_salary from employee where id = emp_id;
         -- print salary befor giving bonus 
         raise notice 'employee id % before bonus ',emp_id;
	 -- calculate bonus 
	 bonus := emp_salary * 0.10;
	 -- using raise notise display the emp_id and their bonus
	 raise notice 'employee id : % and bonus : %',emp_id,bonus;
end ;
$$;


-- Call the procedure , Give bonus to id = 1
call bonus(1)


------------------------------------------------
Using DEFAULT Values for Parameters --(if parameters are not mentioned while call procedure default is considered)
------------------------------------------------

-- Create proceude to Insert Data , Use Default Values in Procedures if paramenters are not mentioned when the 
-- procedure is being called 

-- default values will be : id = 100 , name = dala , salary = -100
create procedure insert_data2(
       IN emp_id int DEFAULT 100,	
	   IN emp_name text DEFAULT 'dalla',
	   IN emp_salary int DEFAULT -100
)
language plpgsql
as $$ 
begin 
    insert into employee(id,name,salary) values (emp_id,emp_name,emp_salary);
end;
$$;

-- Inserting Data into Table employee using insert_data2 procedure 
call insert_data2();  -- uses all default values 
call insert_data2(10); -- uses name , salary default values
call insert_data2(11,'archita_shigwan',100000); -- no default value will be used 

select * from employee; -- to verify the data is inserted 



-----------------------------------------
USING RAISE NOTICE FOR DEBBUGING 
-----------------------------------------

-- Create an procedure which inerts data into the table emeployee And Raises an Notice at every step 
-- 1) Mention the data which is going to be insert 2) After insertion of data Raise Notice mentioned data inserted
create procedure insert_data3(IN emp_id int , IN emp_name text , IN emp_salary int)
language plpgsql
as $$
begin 
   -- raise notice show what data is being inserted 
   raise notice 'id % name % salary %  is being inseted into table employee',emp_id , emp_name , emp_salary;
   -- insert the data 
   insert into employee (id,name,salary) values (emp_id,emp_name,emp_salary);
   -- raise notice saying data insertion done
   raise notice 'Employee % inserted successfuly ',emp_name;
end;
$$;


-- Insert data using the insert_data3 procedure 
call insert_data3(101,'iman gadzi',10000000); 
