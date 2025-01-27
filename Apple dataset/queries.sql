\\ query optimization\\
select * from category;
select count(category_id) from category;
select distinct repair_status from warranty;
select count(sale_id) from sales;
select * from sales;
explain analyze 
select * from sales where product_id='P-64';
create index sales_product_id on sales(product_id);
create index sales_store_id on sales(store_id);
create index sales_sale_date on sales(sale_id);
select * from stores;
-- find the number of stores in each country -- 
select country, count(store_id) from stores group by country;
-- no of units sold by each store --
select * from sales;
select store_id,sum(quantity) as total_sales from sales group by store_id;
SELECT 
    s.store_id,
    st.store_name,
    st.country,
    SUM(s.quantity) AS total_units_sold
FROM
    sales AS s
        JOIN
    stores AS st ON st.store_id = s.store_id
GROUP BY s.store_id , st.store_name
ORDER BY total_units_sold DESC;

-- sales in december 2023 --
select count(quantity) as sales from sales where year(sale_date)=2023 and month(sale_date)=12;
-- store which never had warranty claim --
SELECT 
    count(*)
FROM
    stores
WHERE
    store_id NOT IN (SELECT DISTINCT
            store_id
        FROM
            sales AS s
                RIGHT JOIN
            warranty AS w ON s.sale_id = w.sale_id);
-- warranty claim as void --
select * from warranty;
select 
	count(claim_id)/
					(select count(*) from warranty) *100 as percentage_warranty_void 
from warranty 
where repair_status= "warranty void";
SELECT 
    store_id, SUM(quantity) AS total_sales
FROM
    sales
WHERE
    YEAR(sale_date) >= YEAR(CURDATE()) - 1
GROUP BY store_id
ORDER BY total_sales DESC limit 1;
-- unique product sold last year --
SELECT 
    COUNT(DISTINCT product_id)
FROM
    sales
WHERE
    sale_date >= CURDATE()- interval 1 year;
-- find average price of each category --
select p.category_id,c.category_name, avg(p.price) as avg_price from products as p join category as c on p.category_id=c.category_id group by category_id,category_name order by avg_price desc;
-- warranty claims filed in 2020
select count(claim_id) from warranty where year(claim_date)=2020;
-- for each store identify best selling day based on highest quantity sold
SELECT *
FROM (
    SELECT 
        store_id,
        DAYNAME(sale_date) AS day_name,
        SUM(quantity) AS total_sales,
        RANK() OVER (PARTITION BY store_id ORDER BY SUM(quantity) DESC) AS rank_
    FROM sales
    GROUP BY store_id, day_name
) AS t1
WHERE rank_ = 1;
-- least selling product in each country for each year based on units sold --
with product_rank as 
(
SELECT 
    st.country, p.product_name, SUM(s.quantity) AS total_qty,
    rank() over(partition by st.country order by sum(s.quantity)) as rank_
FROM
    sales AS s
        JOIN
    stores AS st ON s.store_id = st.store_id
        JOIN
    products AS p ON s.product_id = p.product_id
GROUP BY st.country , p.product_name
) 
select * from product_rank where rank_=1;
-- warranty claim within 180 days of product sale --



select w.*,s.sale_date,w.claim_date-s.sale_date from warranty as w left join sales as s on s.sale_id=w.sale_id where w.claim_date-s.sale_date<=180;

select count(*) from warranty as w left join sales as s on s.sale_id=w.sale_id where w.claim_date-s.sale_date<=180;
-- how many warranty claims were filed for products launched in last two years --
 SELECT 
    p.product_name,
    COUNT(w.claim_id) AS no_claims,
    COUNT(s.sale_id)
FROM
    warranty AS w
        RIGHT JOIN
    sales AS s ON s.sale_id = w.sale_id
        JOIN
    products AS p ON p.product_id = s.product_id
WHERE
    p.launch_date >= CURRENT_DATE() - INTERVAL 2 YEAR
GROUP BY p.product_name
HAVING COUNT(w.claim_id) > 0;
-- list the month in the last 3 years where sales exceeded 5000 units in usa --
SELECT 
    date_format(s.sale_date, '%m-%y') as month_year,sum(quantity) as total_unit_sold
FROM
    sales AS s
        JOIN
    stores AS st ON s.store_id = st.store_id
WHERE
    st.country = 'USA' and s.sale_date>=current_date()-interval 3 year
    group by month_year
    having total_unit_sold>5000;
-- product category with most warranty claims in last 2 years
select * from warranty;
SELECT 
    c.category_name,
    count(w.claim_id) as total_claims
FROM
    warranty AS w
        LEFT JOIN
    sales AS s ON w.sale_id = s.sale_id
        JOIN
    products AS p ON p.product_id = s.product_id
        JOIN
    category AS c ON c.category_id = p.category_id
    where w.claim_date>=current_date()-interval 2 year
    group by c.category_name;
    -- % chance of receiving warranty claims after each percentage for each country--
  SELECT 
    country,
    total_unit_sold, 
    total_claim,
    COALESCE(( NULLIF(total_claim, 0)/total_unit_sold ) * 100, 0) AS risk
FROM
    (SELECT 
        st.country,
        SUM(s.quantity) AS total_unit_sold,
        COUNT(w.claim_id) AS total_claim
    FROM
        sales AS s
    JOIN stores AS st ON s.store_id = st.store_id
    LEFT JOIN warranty AS w ON w.sale_id = s.sale_id
    GROUP BY st.country) AS T1
ORDER BY risk desc;
-- Analyze each stores year by year growth ratio(YOY)--
with Yearly_sales as(
SELECT 
    s.store_id AS id,
    st.store_name AS name,
    EXTRACT(YEAR FROM sale_date) AS year,
    SUM(s.quantity * p.price) AS total_sale
FROM
    sales AS s
        JOIN
    products AS p ON s.product_id = p.product_id
        JOIN
    stores AS st ON st.store_id = s.store_id
GROUP BY id , year , name order by name,year),
growth_ratio as (
select 
name,
year, 
lag(total_sale,1)over(partition by name order by year asc) as last_year_sale,
total_sale as current_year_sale
from yearly_sales
)
 SELECT 
    name,
    year,
    last_year_sale,
    current_year_sale,
    (current_year_sale - last_year_sale) / last_year_sale * 100 AS YOY
FROM
    growth_ratio
WHERE
    last_year_sale IS NOT NULL
        AND year <> EXTRACT(YEAR FROM CURRENT_DATE());

-- correlation between price and warranty claim in last 5 years--
SELECT 
    
    case 
    when p.price<500 then 'less_expensive'
    when p.price between 500 and 1000 then 'mid_range'
    else 'expensive'
    end as price_segment,
    count(w.claim_id) as total_claim
FROM
    warranty AS w
        LEFT JOIN
    sales AS s ON w.sale_id = s.sale_id
        JOIN
    products AS p ON p.product_id = s.product_id
WHERE
    Claim_date >= CURRENT_DATE() - INTERVAL 5 YEAR 
    group by price_segment;
    
    -- store with highest paid_repair claims related to total_claims filed
with paid_repair as(
SELECT 
    s.store_id, COUNT(w.claim_id) AS paid_repaired
FROM
    sales AS s
        RIGHT JOIN
    warranty AS w ON w.sale_id = s.sale_id
WHERE
    w.repair_status = 'Paid repaired'
GROUP BY store_id),

total_repaired as
(SELECT 
    s.store_id, COUNT(w.claim_id) AS total_repaired
FROM
    sales AS s
        RIGHT JOIN
    warranty AS w ON w.sale_id = s.sale_id
GROUP BY store_id)
select 
tr.store_id,
pr.paid_repaired,
tr.total_repaired,
pr.paid_repaired/tr.total_repaired * 100 as paid_repair_percentage
from paid_repair as pr 
join total_repaired tr on pr.store_id=tr.store_id;

-- monthly running total of sales for each store over past 4 years and trend comparison --
with monthly_sale as 
(SELECT 
    store_id,
    extract(month from sale_date) AS month,
    EXTRACT(YEAR FROM sale_date) AS year,
    SUM(p.price * s.quantity) AS total_sales
FROM
    sales AS s
        JOIN
    products AS p ON s.product_id = p.product_id
GROUP BY store_id , month , year
order by store_id,year,month
)
select store_id, month, year, total_sales, sum(total_sales) over(partition by store_id order by year,month) as running_total from monthly_sale;



