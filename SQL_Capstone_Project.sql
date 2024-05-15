use h1b_visa;
select * from h1b_data limit 20;
select count(*) from h1b_data;

-- describe h1b data 
describe h1b_data;
select * from h1b_data;
update h1b_data set Wage_rate_of_pay_to = case 
when Wage_rate_of_pay_from = "" then Null else
cast(replace(replace(Wage_rate_of_pay_from, "$", ""), ",", "") as decimal(10,2))
end;
SET GLOBAL wait_timeout=3600;
SET GLOBAL interactive_timeout=3600;

UPDATE h1b_data
SET WAGE_RATE_OF_PAY_FROM=
CASE
WHEN WAGE_RATE_OF_PAY_FROM= '' THEN NULL -- Handle empty strings by setting to NULL
ELSE CAST(REPLACE(REPLACE(WAGE_RATE_OF_PAY_FROM, '$', ''), ',', '') AS DECIMAL(10,2))
END;

-- null value in table 
select count(*) as Total_count, count(case when wage_rate_of_pay_to is null then 1 end) as Count from h1b_data;

-- check duplicate
select case_number, count(case_number) from h1b_data group by case_number having count(case_number) >1;