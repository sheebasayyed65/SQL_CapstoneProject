use h1b_visa;

--  CHEKCING THE COUNT OF ROWS 
select count(*) from h1b_data;
--  CHECK DATA VALUES 
select * from h1b_data limit 20;
--   CHECK DATA TYPE describe h1b data 
describe h1b_data;
select * from h1b_data;
-- removing comma and $ symbols from column prexvailing wage
/* UPDATE h1b_data 
SET 
    Wage_rate_of_pay_to = CASE
        WHEN Wage_rate_of_pay_from = '' THEN NULL
        ELSE CAST(REPLACE(REPLACE(Wage_rate_of_pay_from, '$', ''),   -- $75,000.000 replace , and $
                ',',
                '')
            AS DECIMAL (10 , 2 ))
    END;
SET GLOBAL wait_timeout=3600;
SET GLOBAL interactive_timeout=3600; */

--  CONVERT THE DATA TYPE AND VALUE OF WAGE COLUMN WAGE_RATE_OF_PAY_To
update h1b_data
set WAGE_RATE_OF_PAY_To = 
case 
	when WAGE_RATE_OF_PAY_To = '' then Null 
else cast(replace(replace(WAGE_RATE_OF_PAY_To, '$', ''), ',', '') as decimal(10,2))
end;

--  CONVERT THE DATA TYPE AND VALUE OF WAGE COLUMN WAGE_RATE_OF_PAY_FROM
UPDATE h1b_data
SET WAGE_RATE_OF_PAY_FROM=
CASE
WHEN WAGE_RATE_OF_PAY_FROM= '' THEN NULL -- Handle empty strings by setting to NULL
ELSE CAST(REPLACE(REPLACE(WAGE_RATE_OF_PAY_FROM, '$', ''), ',', '') AS DECIMAL(10,2))
END;

select * from h1b_data limit 5;
-- CONVERTING DATA VALUES AND DATA TYPES IN CORRECT FORMAT 
update h1b_data set received_date = str_to_date(received_date,'%m/%d/%Y');
update h1b_data set decision_date = str_to_date(decision_date, '%m/%d/%Y');
update h1b_data set begin_date = str_to_date(begin_date, '%m/%d/%Y');
update h1b_data set end_date = str_to_date(end_date, '%m/%d/%Y');

--  CHECKING FOR MISSING VALUES
select count(*) as Total_count, count(case when wage_rate_of_pay_to is null then 1 end) as Count from h1b_data;

-- CHECKING FOR DUPLICATED VALUES
select case_number, count(case_number) from h1b_data group by case_number having count(case_number) >1;

-- Question 1) Which are the top employers in a certain state in a certain industry?
select * from h1b_data limit 5;
select employer_name, count(*) as TotalCases from h1b_data
where employer_state = "CA" and SOC_Title = "Computer Programmers"
group by employer_name order by TotalCases desc;

-- : Which functions seem to pay the most? Are there outliers in the salary data?
SELECT JOB_TITLE, MAX(WAGE_RATE_OF_PAY_FROM) AS MaxWage 
FROM h1b_data 
GROUP BY JOB_TITLE 
ORDER BY MaxWage DESC; 

SELECT JOB_TITLE, WAGE_RATE_OF_PAY_FROM 
FROM h1b_data 
WHERE WAGE_RATE_OF_PAY_FROM > ( 
SELECT AVG(WAGE_RATE_OF_PAY_FROM) + 3 * 
STDDEV(WAGE_RATE_OF_PAY_FROM) 
FROM h1b_data 
) order by WAGE_RATE_OF_PAY_FROM desc limit 10;

-- Are there certain types of jobs concentrated in certain geographical areas? 
SELECT WORKSITE_STATE, JOB_TITLE, COUNT(*) AS JobCount 
FROM h1b_data 
GROUP BY WORKSITE_STATE, JOB_TITLE 
ORDER BY JobCount DESC; 

/*Types of Jobs which have the highest chance of H1B 
From this we can see top 3 SOC codes are 15, 17 , 13 which referes to 
15-0000: Computer and Mathematical Occupations 
13-0000: Business and Financial Operations Occupations 
17-0000: Architecture and Engineering Occupations 
Whereas the least chances are for 37, 47 , 49 
37-0000: Building and Grounds Cleaning and Maintenance Occupations 
47-0000: Construction and Extraction Occupations 
49-0000: Installation, Maintenance, and Repair Occupations 
Here also we can analysis denied rate in 49 is also higher. Agent represent employer */

select AGENT_REPRESENTING_EMPLOYER , case_status , count(case_number) from 
h1b_data group by 1,2; 
-- Solution : From the above table we can say with the help of agent to apply for H1B-visa chance of approval increases 3 times 


