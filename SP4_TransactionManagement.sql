---------------------------------------------------------------
Transaction Management (BEGIN , COMMIT , ROLLBACK)
---------------------------------------------------------------
create table accounts(
  account_id int , 
  name VARCHAR(50),
  balance DECIMAL(10,2) -- decimal cause balance = money and decimal is preffered for money
);

INSERT INTO accounts  VALUES
(1,'Alice Fernandes', 1000.00),
(2,'Viraj Gade', 500.00),
(3,'Harsh Gade',1500.00);


----------
Stored Procedure With Transaction Management : 
----------

-- Question 
-- Create an Stored Procedure which transfers funds between two accounts by checking the sender's balance, 
-- deducting the amount, crediting the receiver, and committing the transaction.

-- will transfer amount not > than balance cause here we are not using Exception block to handle this situatiion
create procedure transfer_funds(IN sender_id int , IN receiver_id int, IN transfer_amount decimal(10,2))
language plpgsql
as $$
begin  -- Start Transaction 

	 -- Check Senders Balance 
	 if(select balance from accounts where account_id = sender_id) < transfer_amount THEN
	    raise notice 'Insufficient Funds';
	end if;

	-- Deduct from sender 
	UPDATE accounts SET balance = balance - transfer_amount where account_id = sender_id;

	-- Add to receiver 
	UPDATE accounts SET balance = balance + transfer_amount where account_id = receiver_id;

	-- Commit transaction  (so the operation is saved in the table )
	COMMIT;
END;
$$;


-- Call the procedure 
call transfer_funds(1,3,300); -- when you see the table id 1 = 1000-300 = 7000 and id 3 = 1500+300 = 1800
select * from accounts;




---------------------------------------------------
Error handling using Exception Block
---------------------------------------------------

-- QUESTION : create an procedure such that if all is correct then COMMIT / save the changes or Else is 
-- any Exception occurs then ROLLBACK to reverts all changes made 
create procedure transfer_funds2(IN sender_id int , IN receiver_id int , IN transfer_amount DECIMAL(10,2))
language plpgsql
as $$ 
begin 
   -- deduct from sender 
   UPDATE accounts SET balance = balance - transfer_amount WHERE account_id = sender_id;
   
   -- add to receiver
   UPDATE accounts SET balance = balance + transfer_amount WHERE account_id = receiver_id;


   EXCEPTION WHEN others THEN -- usued to handle all the exceptions than may occur 
       ROLLBACK;
	   raise notice 'Transaction Failed Rolling Back The Changes';

   COMMIT; -- save all the changes to the table at the end if nothing  exception occurs 
end;
$$;


-- call procedure tranfer_funds2 where the sender has less amount then it is trying to transfer Which causes the
-- raise notice inside the Excption block 
call transfer_funds2(1,2,100000.00)



-------------------------------------------------------------------------------------------------------------------
                                 QUESTIONS TO PRACTICE TRANSACTION MANAGEMENT 
-------------------------------------------------------------------------------------------------------------------

-- Table : account

CREATE TABLE account (
    account_id INT PRIMARY KEY,
    name VARCHAR(50),
    balance DECIMAL(10,2),
    email VARCHAR(100),
    status VARCHAR(10) -- 'active' or 'inactive'
);

INSERT INTO account VALUES
(1, 'Alice', 1000.00, 'alice@example.com', 'active'),
(2, 'Bob', 500.00, 'bob@example.com', 'active'),
(3, 'Charlie', 2000.00, 'charlie@example.com', 'active'),
(4, 'David', 3000.00, 'david@example.com', 'inactive'),
(5, 'Eve', 1500.00, 'eve@example.com', 'active'),
(6, 'Frank', 700.00, 'frank@example.com', 'inactive'),
(7, 'Grace', 2500.00, 'grace@example.com', 'active'),
(8, 'Hank', 800.00, 'hank@example.com', 'active'),
(9, 'Ivy', 1800.00, 'ivy@example.com', 'inactive'),
(10, 'Jack', 900.00, 'jack@example.com', 'active'),
(11, 'Kate', 2200.00, 'kate@example.com', 'inactive'),
(12, 'Leo', 1300.00, 'leo@example.com', 'active'),
(13, 'Mike', 600.00, 'mike@example.com', 'active'),
(14, 'Nancy', 2800.00, 'nancy@example.com', 'active'),
(15, 'Oscar', 100.00, 'oscar@example.com', 'inactive'),
(16, 'Paul', 4000.00, 'paul@example.com', 'active'),
(17, 'Quinn', 3500.00, 'quinn@example.com', 'inactive'),
(18, 'Rachel', 1200.00, 'rachel@example.com', 'active'),
(19, 'Steve', 500.00, 'steve@example.com', 'active'),
(20, 'Tom', 750.00, 'tom@example.com', 'inactive');



-- Question 1 : Stored procedure to deposit money into an Account 
-- check if account exists and is active , Ensure amount > 0 , Update the balance , Commit the transaction

create procedure deposit_money(IN receiver_id int,IN amount decimal)
language plpgsql
as $$
begin 
    -- Handle Condition : check if account exists and is active 
	IF NOT EXISTS (SELECT 1 FROM account WHERE account_id = receiver_id AND status = 'active') THEN
	     RAISE NOTICE 'Account doe not exits OR is inactive';
		 RETURN;  -- stops further ececution 
    END IF;

	-- Handle Contition : check if amount is > 0 / positive
	IF amount <= 0 THEN
	    RAISE NOTICE 'Deposit amount must be greater than zero ';
		RETURN; -- stops further execution
    END IF;

	-- Update the amount in receiver account 
	UPDATE account SET balance = balance + amount WHERE account_id = receiver_id;

	COMMIT; -- if all good then save the changes into the table
end;
$$;

-- deposit to account id 1 prev balance = 1000 , add 999 , now balance = 1999
call deposit_money(1,999)
select * from account where account_id = 1; -- check if amount added





-- Question 2 : Stored Procedure to withdraw money from an account
-- check if account exists and is active , ensure sufficient balance , Deduct the money , commit save the changes
create procedure withdraw_amount (IN withdraw_account_id int , IN withdraw_amount decimal)
language plpgsql
as $$
   DECLARE current_balance decimal; -- to store balance of user 
begin 
    -- store the balance of user from whom we will withdraw amount
    SELECT balance INTO current_balance FROM account WHERE account_id = withdraw_account_id;
	
    -- Handle Condition : chech if account exists and is active 
	IF NOT EXISTS (SELECT 1 FROM account WHERE account_id = withdraw_account_id AND status = 'active') THEN 
	   RAISE NOTICE 'Account does not exists or is Inactive';
	   RETURN; -- stops further execution 
	END IF;

	-- Handle Condition : check if amount is > 0
	IF withdraw_amount < 0 THEN
	  RAISE NOTICE 'Withdrawl Amount cant be less 0 ';
	  RETURN; -- stops further execution
	END IF;

	-- Handle Contion : ensure sufficient balance 
	IF current_balance < withdraw_amount THEN 
	   RAISE NOTICE 'Low funds then withdrawl amount ';
	   RETURN; 
   END IF;

   -- Deduct The Money from the account
   UPDATE account SET balance = balance - withdraw_amount WHERE account_id = withdraw_account_id;

   COMMIT; -- if all good save all the changes 
end;
$$;

-- Call Procedure to withdraw from account_id 2 current balance = 500 , deduct = 100 , remaing = 400
call withdraw_amount(2,100)
call withdraw_amount(2,10000000); -- To Check If It Handles Wrong Calls

select * from account where account_id = 2;  -- check if it executed correctly



-- Question 3 : Stored Procedure to Transfer Money Between Two Accounts
-- Check if both accounts exits and are active , transfer amount is > 0 , Sender has sufficient balance ,
-- Deduct from Sender Add to Receiver , Commit save the changes
create procedure transfer_money(IN sender_id int , IN receiver_id int , IN amount decimal)
language plpgsql
as $$
   DECLARE sender_balance decimal;
begin 
   -- Fetch sender balance to check if balance > amount
   SELECT balance INTO sender_balance FROM account WHERE account_id = sender_id;

   IF sender_balance < amount THEN
      RAISE NOTICE 'Insufficient / Low Funds ';
	  RETURN; -- stops furhter operations
   END IF;

   -- Handle Condition : amount > 0 / positive
   IF amount < 0 THEN
      RAISE NOTICE 'Amount cannot be negative / less than zero';
	  RETURN;
   END IF;

   -- Handle Contition : Check If Sender and Receiver accounts present & active
   IF NOT EXISTS (SELECT 1 FROM account WHERE account_id = sender_id and status = 'active') THEN
      RAISE NOTICE 'Senders account does not exists or is inactive';
	  RETURN;
   END IF;

   IF NOT EXISTS (SELECT 1 FROM account WHERE account_id = receiver_id and status = 'active') THEN
      RAISE NOTICE 'Receiver account does not exists or is inactive';
	  RETURN;
   END IF;

   -- Deduct from sender 
   UPDATE account SET balance = balance - amount WHERE account_id = sender_id;
   -- Add to receiver
   UPDATE account SET balance = balance + amount WHERE account_id = receiver_id;

   COMMIT;  -- if all good save the changes
end;
$$;


-- transfer from account 3 to 5 amount = 500, account 3 bal = 2000 - 500 = 1500 , account 5 bal = 1500 + 500 = 2000
call transfer_money(3,5,500)
select * from account where account_id in (3,5); -- check if money transfered 

call transfer_money(3,4,200) -- account id 4 status = inactive so notice will be raised that account is inactive




-- Question 4 : Stored Procedure to Check Account Balance 
-- check if account exits and is present , print the balance 
create procedure get_balance(IN customer_id int)
language plpgsql
as $$
   DECLARE customer_balance DECIMAL;
begin
   -- Handle Condition : if account is present and is active 
   IF NOT EXISTS (select 1 from account where account_id = customer_id and status = 'active') THEN
      RAISE NOTICE 'Account does not exits or is Inactive';
	  RETURN; -- stop further execution
   END IF;

   -- fetch the balance 
   SELECT balance INTO customer_balance FROM account WHERE account_id = customer_id;

   -- print the balance using Raise Notice
   RAISE NOTICE 'Account ID : %  Balance : %',customer_id,customer_balance;
end;
$$;


-- call procedure for 7 cause it is active 
call get_balance(7)
select balance from account where account_id = 7 -- check if it balance is correct

-- call for Wrong Calls example : for id 100 (should print does not exits or is inactive)
call get_balance(100)




-- Question 5 : Stored Procedure to Update Email of an account 
-- check if account exists and is active , update the email , save the changes 
create procedure update_email (IN customer_id int , IN new_email text)
language plpgsql
as $$ 
begin
   -- Handle Condition : if account exists and is active 
   IF NOT EXISTS (select 1 from account where account_id = customer_id and status = 'active') THEN
        RAISE NOTICE 'Account does not exists or is Inactive';
		RETURN; -- stops further execution
   END IF;

   -- Update the email
   UPDATE account SET email = new_email WHERE account_id = customer_id;

   COMMIT; -- if all good save those changes
end;
$$;


-- update email for id 1 and set to hahaha@example.com
call update_email(1,'hahaha@example.com')
select * from account where account_id = 1; -- check if email updated 
-- wrong calls example : mentiton id where status is inactive example id = 4
call update_email(4,'hahaha@example.com')



-- Question 6 : Stored Procedure to Deactivate an account 
-- check if account exists , make the status = 'inactive' , save tha changes 
create procedure deactivate_account(IN customer_id int)
language plpgsql
as $$
begin 
   -- Handle Condititon : check if account exits 
   IF NOT EXISTS (select 1 from account where account_id = customer_id ) THEN
      RAISE NOTICE 'Account does not exists';
	  RETURN; -- stops further execution 
   END IF;

   -- seting status to inactive
   UPDATE account SET status = 'inactive' WHERE account_id = customer_id;

   COMMIT; 
end;
$$;

-- will deactivate the account_id 7 
call deactivate_account(7)
select * from account where account_id = 7;  -- check if the account got inactive  

-- calling worong calls , example : for account_id 101 It will print 'Account does not exits'
call deactivate_account(101)




-- Question 7 : Stored Procedure to Delete an Account if balance = 0 
-- check if account exits , check if balance is 0 , delete the account , save the changes
create procedure delete_account(IN customer_id int)
language plpgsql
as $$ 
   DECLARE customer_balance DECIMAL;
begin 
  -- Fetch the balance of the customer 
  SELECT balance INTO customer_balance FROM account WHERE account_id = customer_id; 
  
  -- Hanle Condition : check if account exits 
  IF NOT EXISTS (select 1 from account where account_id = customer_id) THEN
      raise EXCEPTION 'Account does not exits'; -- raise excetion used cause then we do not need to use RETURN 
  END IF;   -- for stoping the further exectuion of procedure 

  -- Handle Condition : check if balance = 0
  IF customer_balance != 0 THEN
    raise EXCEPTION 'Cannot delete account with Non Zero Balance';
  END IF;

  -- Delete the account
  DELETE FROM account WHERE account_id = customer_id;

  COMMIT;  -- if all good save the changes
end;
$$;


-- We do not have any account where balance = 0 , So we will call procedure to check if it hadles wrong calls
call delete_account(11) -- will not get deleted cause balance is not = 0
-- Wrong Calls example : account_id = 101 'Account does not exists' 
call delete_account(101)  



-- Question 8 : Stored Procedure to Reactivate and Deactivate account (setting status = 'active')
-- check if account exits and is inactive , activate account if it is 'inactive' , save the changes 
create procedure activate_account(IN customer_id int)
language plpgsql
as $$ 
begin
   -- Handle Contition : check if account exits and is inactive
   IF NOT EXISTS (select 1 from account where customer_id = account_id and status = 'inactive') THEN 
       raise EXCEPTION 'Account does not exists /  is already Active';
   END IF;
       
   -- Reactivate the account
   UPDATE account SET status = 'active' WHERE account_id = customer_id;

   COMMIT; -- if all good saves the changes
end;
$$;


-- for account_id = 15 where status = inactive will call the procedure and make it 'active'
call activate_account(15)
select * from account where account_id = 15  -- check if the account got activated
-- Wrong call account_id = 5 status = 'active' Which will print 'Account does not exists /  is already Active'
call activate_account(5)








  
  


