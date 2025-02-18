-- CASE Statement Questions 

CREATE TABLE orders (
    order_id INT,
    customer_id INT,
    amount DECIMAL(10, 2)
);

INSERT INTO orders (order_id, customer_id, amount) VALUES
(1, 101, 50),
(2, 102, 150),
(3, 103, 600),
(4, 104, 30),
(5, 105, 450);

-- Given the orders table, write an SQL query to categorize each order based on its amount.
--Small: Amount < 100
-- Medium: Amount between 100 and 500
-- Large: Amount > 500

-- Query : 
SELECT order_id, amount, 
       CASE 
           WHEN amount < 100 THEN 'Small' 
           WHEN amount BETWEEN 100 AND 500 THEN 'Medium' 
           ELSE 'Large' 
       END AS category -- above all logic will be executed and output will be diaplayed in new column category
FROM orders;



------------------------------

CREATE TABLE people (
    person_id INT,
    name VARCHAR(100),
    age INT
);

INSERT INTO people (person_id, name, age) VALUES
(1, 'Alice', 10),
(2, 'Bob', 16),
(3, 'Charlie', 30),
(4, 'Dave', 70);

-- Question : Write an SQL query to assign an age group (Child, Teen, Adult, Senior) based on the age column.
-- Query : 
SELECT person_id, name, age,
       CASE 
           WHEN age < 13 THEN 'Child'
           WHEN age BETWEEN 13 AND 19 THEN 'Teen'
           WHEN age BETWEEN 20 AND 64 THEN 'Adult'
           ELSE 'Senior'
       END AS age_group -- above all logic will be executed and output will be diaplayed in new column age_group
FROM people;


----------------------------------

create table purchase (
    purchase_id int ,
	customer_id int ,
	purchase_amount int
);

insert into purchase values 
 (1,101,50),
 (2,102,200),
 (3,103,600),
 (4,104,30);

-- Question : Write a SQL query that uses a CASE statement to calculate a discount based on the purchase_amount. 
-- 5% discount for purchases < 100 , 10%  for purchases between 100 and 500 , 20% for purchases above 500

select purchase_amount,
   case 
       when purchase_amount < 100 then '5%'
	   when purchase_amount between 100 and 500 then '10%'
	   when purchase_amount > 500 then '20%'
	   else '0%'
   end as discount -- above all logic will be executed and output will be diaplayed in new column named discount
from purchase;


------------------------------

create table employees (
  employee_id int ,
  name varchar(20),
  years_of_experience int
);

insert into employees values 
 (1,'Alice',1),
 (2,'Bob',4),
 (3,'Charlie',7),
 (4,'Dave',2);

-- Question : Write a SQL query that uses a CASE statement to categorize employees based on  years_of_experience.
-- Junior: 0-2 years  , Mid-level: 3-5 years , Senior: 6+ years

select employee_id , name , years_of_experience , 
    case 
	    when years_of_experience between 0 and 2 then 'Junior'
		when years_of_experience between 3 and 5 then 'Mid-Level'
		when years_of_experience >= 6 then 'Senior'
		else ''
	end as Position -- above all logic will be executed and output will be diaplayed in new column named Position
from employees;


----------------------------

create table sales (
   salesperson_id int ,
   city varchar(20),
   total_sales int
);

insert into sales values 
 (1,'New York',5000),
 (2,'Los Angeles',12000),
 (3,'Chicago',3000),
 (4,'Houstan',15000);

 
--Question : Write a SQL query using a CASE statement to calculate bonus eligibility based on total_sales.
-- Bonus eligibility: Sales > 10,000 , No bonus: Sales <= 10,000
select city , total_sales ,
    CASE 
	    when total_sales > 10000 then 'Eligible'
		when total_sales <=10000 then 'No Bonus'
	    else ''
	end as BonusEligibility -- above all logic will be executed & output willbe diaplayed in column BonusEligibity
from sales;

-------------------------------------

create table students (
   student_id int ,
   name varchar(20),
   marks int
);

insert into students values 
  (1,'Alice',45),
  (2,'Bob',85),
  (3,'Charlie',70),
  (4,'Dave',92);

-- Question : Write a SQL query that categorizes students based on their marks using a CASE statement.
-- Fail: Marks < 50 , Pass: Marks between 50 and 75 , Distinction: Marks > 75

select student_id , name , marks ,
   CASE 
      when marks < 50 then 'Fail'
	  when marks between 50 and 75 then 'Pass'
	  when marks > 75 then 'Distinction'
	  else ''
   end as Remark -- above all logic will be executed and output will be diaplayed in new column named Remark
from students;


------------------------------------------

create table salespeople (
   salesperson_id int ,
   name varchar(20),
   city varchar(20)
);

insert into salespeople values 
 (1,'Alice','New York'),
 (2,'Bob','Los Angeles'),
 (3,'Charlie','Chicago'),
 (4,'Dave','Miami');

-- Question : Write a SQL query using a CASE statement to assign a region to salespeople based on the city.
-- New York and Los Angeles: North Region , Chicago and Houston: South Region
-- Miami: East Region , All others: West Region 

select salesperson_id , name , city , 
    CASE 
	    when city in ('New York','Los Angeles') then 'Nort Region'
		when city in ('Chicago','Houston') then 'South Region'
		when city in ('Miami') then 'East Region'
	    else 'West Region'
	end as Region -- above all logic will be executed and output will be diaplayed in new column named Region
from salespeople;









