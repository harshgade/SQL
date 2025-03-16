-------------------------------------------------------------------------------------
Control Flow Statement (If,ELSIF , Case, Loop, While, For, Exit WHEN ) conditions
-------------------------------------------------------------------------------------

-- Create table employee 
create table employee (
   id int primary key,
   name varchar(30),
   salary int
);


-- Create an Stored Procedure to insert data into table employee 
create procedure add_data (in emp_id int , in emp_name varchar , in emp_salary int )
language plpgsql 
as $$ 
begin 
   insert into employee (id,name,salary) values (emp_id , emp_name , emp_salary);
end;
$$;

-- Insert data using stored procedure we created 
call add_data(1,'harsh gade',300000);
call add_data(2,'harshal korathkar',40000);
call add_data(3,'jay sinroja',220000);
call add_data(4,'maithili malbari',340000);
call add_data(5,'sakshi sonawne',200000);
call add_data(6,'archita shigwan',300000);
call add_data(7,'jay jain',320000);



------------------------------
IF , ELSIF , ELSE  Statement 
------------------------------

-- Using IF-ELSE in Stored Procedure : assign an level to employee based on salary 
create procedure check_level(IN emp_id int,OUT salary_level TEXT) -- here we will show level in String so used TEXT 
language plpgsql 
as $$ 
DECLARE emp_salary int ; -- will be refering salary as emp_salary for logic in procedure only 
begin
    -- Get employee salary
	select salary into emp_salary from employee where id = emp_id;

	-- Assign / Check salary level 
	IF emp_salary > 250000 then salary_level := 'High';
	ELSIF emp_salary between 200000 and 250000 then salary_level := 'Medium';
	ELSE salary_level := 'Low';
	END IF;
end;
$$;

-- Check salary level for id 1,3,6
call check_level(1,null) -- null cause salary_level is output parameter 
call check_level(3,null)
call check_level(6,null)



------------------------
 CASE Statement 
------------------------

-- Using CASE in Procedure : Assign Department based on salary 
-- <40000 : Documentation
-- between 40000 to 300000 : Software Engineer
-- else : Artificail Intelligence

create procedure assign_department (in emp_id int , out department TEXT) -- department = string so used TEXT 
language plpgsql
as $$ 
DECLARE emp_salary int;
begin 
     -- fetch salary from employee 
	 select salary into emp_salary from employee where id = emp_id;

	 -- Assign department as CASE
	 department := CASE
	   when emp_salary < 40000 then  'Documentation'
	   when emp_salary between 40000 and 300000 then 'Software Engineer'
	   else  'Artificial Intelligence'
	 end;
end;
$$;


-- Check department where id = 6 , 7
call assign_department(6,null)
call assign_department(7,null)




---------------------------------
 LOOP , WHILE , FOR
---------------------------------

-- Create an Stored Procedure using WHILE loop : to increase the Salary of an Employee (on basis of id) Until 
-- reaches MaxSalary Limit , parameters : emp_id , increment , max_limit 
create procedure salary_increment(IN emp_id int , IN amount int , IN max_limit int)
language plpgsql
as $$
  DECLARE emp_salary int;
begin 
    -- fetch salary from the table for that particular id
	select salary into emp_salary from employee where id = emp_id;

	-- While loop , logic
	while emp_salary<max_limit loop 
	   emp_salary := emp_salary + amount;
	   update employee set salary = emp_salary where id = emp_id;
	end loop;
end; 
$$;


---------------------
FOR Loop 
---------------------

-- Create Stored Procedure using For loop : to print Employee id and Employee name between an range of employee ID

create procedure employee_info(IN start_id int , IN end_id int)
language plpgsql
as $$
   DECLARE emp_record RECORD; -- RECORD kyuki ye iterate hoga loop mai 
begin
   for emp_record in select id , name from employee where id between start_id and end_id loop
       raise notice 'Employee id : % , Name : %',emp_record.id , emp_record.name;
   end loop;
end;
$$;
-- emp_record is like 'i' which we use as an iterator in range in for loop
-- emp_record.id , emp_record.name (means jo employee iterate hora hai uski info print karni hai aur har bari 
-- employee change hoga iteration mai )

-- Call the Procedure to print the records for employe id from 1 to 6
call employee_info(1,6)
 


------------------------------------
EXIT WHEn condition in Procedures
------------------------------------

-- Will create an procedure which will print from 1 to 10 using RAISE NOTICE and will use Noremal LOOP 
-- which will stop when count <=10 using EXIT condition 

CREATE PROCEDURE one_to_ten()
LANGUAGE plpgsql
AS $$ 
   DECLARE current INT := 1;
BEGIN 
    RAISE NOTICE 'Prints from 1 to 10 :';

    LOOP 
        EXIT WHEN current > 10;  -- Exit when current exceeds 10 
        RAISE NOTICE '%', current;  -- print current no
        current := current + 1;  -- Increment current by 1 
    END LOOP;
END;
$$;

-- call the procedure to print from 1 to 10
call one_to_ten()


	   
   
