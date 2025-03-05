SELECT 
    *
FROM
    manufacture;
SELECT 
    *
FROM
    manufacture
WHERE
    `cust name` = 'shakthi knitting limited';
SELECT 
    SUM(`manufactured qty`)
FROM
    manufacture;-- KPI total manufactured qty --
SELECT 
    SUM(`rejected qty`)
FROM
    manufacture;-- KPI total rejected qty --
SELECT 
    SUM(`processed qty`)
FROM
    manufacture; -- KPI total processed qty --
ALTER TABLE manufacture
MODIFY COLUMN `scrap rate` decimal(10,6);
SELECT 
    AVG(`scrap rate`)
FROM
    manufacture;
SELECT 
    AVG((`rejected qty`) / (`manufactured qty`)) AS scrap_rate
FROM
    manufacture;-- KPI scrap rate
SELECT 
    buyer, SUM(`manufactured qty`) AS total_manufactured
FROM
    manufacture
GROUP BY buyer
ORDER BY total_manufactured DESC
LIMIT 10;-- manufactured qty by buyer--
SELECT 
    `Cust Name`, SUM(`manufactured qty`) AS total_manufactured
FROM
    manufacture
GROUP BY `cust name`
ORDER BY total_manufactured DESC
LIMIT 10;-- manufactured qty by cust name--
SELECT 
    `emp name`, SUM(`manufactured qty`) AS total_manufactured
FROM
    manufacture
GROUP BY `emp name`
ORDER BY total_manufactured DESC
LIMIT 10;-- manufactured qty by employee --
SELECT 
    `Machine Code`,
    SUM(`manufactured qty`) AS total_manufactured
FROM
    manufacture
GROUP BY `machine code`
ORDER BY total_manufactured DESC
LIMIT 10;-- manufactured qty by machine
SELECT 
    buyer, SUM(`Rejected Qty`) AS total_rejected
FROM
    manufacture
GROUP BY buyer
ORDER BY total_rejected DESC
LIMIT 10;-- rejected qty by buyer--
SELECT 
    `cust name`, SUM(`rejected qty`) AS total_rejected
FROM
    manufacture
GROUP BY `cust name`
ORDER BY total_rejected DESC
LIMIT 10; -- rejected qty by cust name --
SELECT 
    `Emp Name`, SUM(`rejected qty`) AS total_rejected
FROM
    manufacture
GROUP BY `emp name`
ORDER BY total_rejected DESC
LIMIT 10; -- rejected qty by emp name

SELECT 
    `machine code`, SUM(`rejected qty`) AS total_rejected
FROM
    manufacture
GROUP BY `machine code`
ORDER BY total_rejected DESC
LIMIT 10; -- rejected qty by machine code

SELECT 
    `department name`,
    SUM(`manufactured qty`) AS total_manufactured,
    SUM(`rejected qty`) AS total_rejected
FROM
    manufacture
GROUP BY `department name`; -- manufactured vs rejected qty by department --

SELECT 
    `buyer`, COUNT(`wo number`) AS order_volume
FROM
    manufacture
GROUP BY Buyer
ORDER BY order_volume DESC; -- order volume by buyer

SELECT 
    `cust name`, 
    (`rejected qty`) / (`manufactured qty`) AS scrap_rate
FROM
    manufacture
ORDER BY scrap_rate DESC
LIMIT 10; -- scrap rate by cust name

select `fiscal date` from manufacture;
ALTER TABLE manufacture
MODIFY COLUMN `wo date` date;
ALTER TABLE manufacture
MODIFY COLUMN `So Posting Date` date;
