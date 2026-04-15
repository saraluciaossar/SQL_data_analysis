# Overview

This project consists of building a relational database called world_transactions from CSV files and structuring it using a star schema.
The goal is to prepare the data for analysis and extract insights related to user activity, transactions, and product sales.

### Database Structure

The database follows a star schema design:
- transactions: fact table (core transactional data)
- users: customer information from EU and USA
- companies: merchant data
- credit_card: payment details
- products: product information

The transactions table connects all dimensions through foreign keys.
Relationships are defined through foreign keys between transactions and the other entities.


### What Was Done
- Designed and created the database from raw CSV files
- Built a star schema with fact and dimension tables
- Performed analytical queries using subqueries and joins
- Created a derived table to classify credit card status
- Integrated product data into the model

### Skills Applied
- SQL (subqueries, joins, aggregations, window functions)
- Star schema modeling
- Data integration from multiple sources
- Business logic implementation in SQL
