# SQL Project: Apple Retail and Product Analysis

This project demonstrates the analysis of Apple retail and product-related data using SQL. By exploring five interconnected tables, insights into sales, warranty claims, and product performance are generated. The analysis showcases data retrieval and processing techniques applied to real-world scenarios.

---

## Table of Contents
1. [Project Description](#project-description)
2. [Data Source](#data-source)
3. [Database Schema](#database-schema)
4. [Key Insights](#key-insights)
5. [Queries and Analysis](#queries-and-analysis)
6. [Conclusions](#conclusions)

---

## Project Description
This project focuses on extracting valuable insights from Apple retail data. It involves querying and analyzing sales performance, warranty claim trends, and product details to support business decisions. The SQL queries used are categorized into basic, medium-to-hard, and complex levels of difficulty.

---

## Data Source
The dataset comprises information about Apple retail stores, product categories, sales transactions, and warranty claims. It includes the following tables:

1. **Stores**: Details about Apple retail stores.
2. **Category**: Product categories.
3. **Products**: Information about Apple products.
4. **Sales**: Sales transaction data.
5. **Warranty**: Warranty claim details.

---

## Database Schema

1. **Stores**:
   - `store_id`: Unique identifier for each store.
   - `store_name`: Name of the store.
   - `city`: City where the store is located.
   - `country`: Country of the store.

2. **Category**:
   - `category_id`: Unique identifier for each product category.
   - `category_name`: Name of the category.

3. **Products**:
   - `product_id`: Unique identifier for each product.
   - `product_name`: Name of the product.
   - `category_id`: References the category table.
   - `launch_date`: Date when the product was launched.
   - `price`: Price of the product.

4. **Sales**:
   - `sale_id`: Unique identifier for each sale.
   - `sale_date`: Date of the sale.
   - `store_id`: References the store table.
   - `product_id`: References the product table.
   - `quantity`: Number of units sold.

5. **Warranty**:
   - `claim_id`: Unique identifier for each warranty claim.
   - `claim_date`: Date the claim was made.
   - `sale_id`: References the sales table.
   - `repair_status`: Status of the warranty claim (e.g., Paid Repaired, Warranty Void).

---

## Key Insights

### Warranty Claim Analysis
1. Determine how many stores have never had a warranty claim filed.
2. Calculate the percentage of warranty claims marked as "Warranty Void".
3. Calculate how many warranty claims were filed within 180 days of a product sale.
4. Determine how many warranty claims were filed for products launched in the last two years.
5. Identify the product category with the most warranty claims filed in the last two years.

### Sales Performance Analysis
1. Calculate the total number of units sold by each store.
2. Identify which store had the highest total units sold in the last year.
3. Count the number of unique products sold in the last year.
4. Find the months in the last three years where sales exceeded 5,000 units in the USA.
5. Identify the least-selling product in each country for each year based on total units sold.

---

## Queries and Analysis

1. Find the number of stores in each country.
2. Identify how many sales occurred in December 2023.
3. Calculate the average price of products in each category.
4. Count the number of warranty claims filed in 2020.
5. For each store, identify the best-selling day based on the highest quantity sold.
1. Determine how many warranty claims were filed for products launched in the last two years.
2. Identify the product category with the most warranty claims filed in the last two years.
3. Calculate how many warranty claims were filed within 180 days of a product sale.
4. Identify the least-selling product in each country for each year based on total units sold.
5. List the months in the last three years where sales exceeded 5,000 units in the USA.
1. Determine the percentage chance of receiving warranty claims after each purchase for each country.

---

## Conclusions
This project successfully utilized SQL to explore and analyze various aspects of Apple retail and product data. Key takeaways include insights into sales trends, warranty claim patterns, and product category performance. Such analyses can drive better decision-making for retail strategies and product launches.

---


