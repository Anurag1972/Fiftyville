--GETTING THE DESCRIPTION OF CRIME SCENE 

SELECT description FROM crime_scene_reports 
 -- as crime took on 28/7/2020 at Chamberlin Street
WHERE street ="Chamberlin Street" AND day = 28 AND year = 2020 AND month =7; 


-- INVESTIGATING WITNESSES STATEMENTS's

SELECT transcript,name FROM interviews
 WHERE day = 28 AND year = 2020 AND month =7 

--RAYMOND STATEMENT -> Theif made a phone call and asked his accomplise to buy earliest flight tickets on 29/7/2020.
-- EUGENE STATEMENT -> He saw the theif earlier at the ATM on Fifer street and he was withdrawing some money. 
--RUTH STATEMENT->  he saw Theif at the parking lot after 10 minutes of theft.


--LETs   GET THE NAME OF THEIF 

SELECT name FROM people

   --- query security_logs
   
WHERE people.license_plate IN  (

    -- checking courthouse_secuirty_logs for license plate number 
	
    SELECT license_plate FROM courthouse_security_logs

   WHERE activity ="exit" 
   
    -- in ten minute time frame 
	
   AND day = 28 AND year = 2020 AND month =7 AND hour = 10 AND minute >15 AND minute<25
) 
   
   --query ATM transactions
 AND people.id IN (
 
   SELECT person_id FROM bank_accounts 
   
   JOIN atm_transactions ON 
   
   -- getiing account number through the deatils told by interveiwers
   
   bank_accounts.account_number=atm_transactions.account_number 
   
   WHERE atm_transactions.transaction_type = "withdraw" AND atm_transactions.atm_location ="Fifer Street"  AND atm_transactions.day = 28 AND atm_transactions.year = 2020 AND atm_transactions.month =7 
   )
   --query calls
   AND people.phone_number IN (
      --trying to find phone number through the phone_calls tables 
	 SELECT caller FROM phone_calls 
	  -- suspect was calling someone according to witness on the day of theft
	  
	 WHERE month=7 and year=2020 AND day=28 AND duration < 60
	 )
  AND people.passport_number IN (
  
    --getting passport number through flight record history 
  SELECT passport_number FROM 
    --
  passengers WHERE flight_id IN (
  
    SELECT id FROM flights 
     -- he told his accomplice to book first flight of tommorow ie: 29/7/2020
	 WHERE day = 29 AND month = 7 AND year = 2020  ORDER BY hour,minute ASC LIMIT 1
	 )
   );
   
   
 --FINDING THE CITY THEIF ESCAPED TO  
SELECT city FROM airports 

WHERE id IN (
   -- as he took the first flight of the day i.e 29/7/2020
SELECT destination_airport_id FROM flights WHERE day=29 AND YEAR =2020 AND month =7 ORDER BY hour,minute ASC LIMIT 1
);

--FINDING THE THEIF ACCOMPLISE

SELECT name FROM people 
  -- finding his name 
WHERE phone_number IN (
  -- as theif aka "Ernest" called his accomplise on the day of theft 
  SELECT receiver FROM phone_calls 
  -- getting "Ernest" phone number from people as he was the caller and receiver was his accomplise
  WHERE day=28 AND month =7 AND year =2020 AND duration <60 AND caller IN (SELECT phone_number FROM people WHERE name ="Ernest")
  )
