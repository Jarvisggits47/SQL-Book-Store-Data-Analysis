# 📚 Bookstore Sales Analytics

## 📌 Project Overview
This project focuses on analyzing **bookstore sales data** using **advanced SQL techniques** to extract insights into revenue trends, customer behavior, and best-selling books. By leveraging structured queries, aggregations, and analytical functions, this analysis helps optimize **inventory management, marketing strategies, and overall sales performance**.

## 🎯 Objectives
- Identify **top-selling books** and sales trends over time.
- Analyze **revenue contributions** by genre and individual books.
- Understand **customer purchasing behavior** for strategic decision-making.
- Optimize **inventory management** based on sales insights.

## 🛠 Tech Stack
- **Database:** MySQL / PostgreSQL
- **Query Language:** SQL
- **Tools Used:** SQL Workbench / pgAdmin / Jupyter Notebook (for visualization if needed)

## 📊 Key SQL Concepts Used
### 🔹 Data Extraction & Cleaning
- `SELECT`, `WHERE`, `GROUP BY`, `HAVING`
- `ORDER BY` for ranking bestsellers

### 🔹 Advanced SQL Functions
- **Window Functions:** `RANK()`, `DENSE_RANK()`, `ROW_NUMBER()` for bestseller tracking
- **Aggregations:** `SUM() OVER()`, `COUNT() OVER()`, `CASE WHEN` for revenue trends
- **CTEs & Subqueries:** `WITH` statements for optimized query structuring

### 🔹 Data Relationships & Joins
- `INNER JOIN`, `LEFT JOIN` to connect sales, books, and customer data
- **Foreign Key Relationships:** Orders → Books, Orders → Customers

## 📁 Dataset Overview
### Tables Used:
1. **Orders**: Stores transaction details (Book_ID, Customer_ID, Quantity, Total_Amount, Order_Date)
2. **Books**: Contains book information (Book_ID, Title, Genre, Price)
3. **Customers**: Holds customer data (Customer_ID, Name, Location)

## 🔍 Key Insights
- **Top 10 Bestselling Books** ranked by total sales volume
- **Monthly Revenue Analysis** to identify peak sales periods
- **Genre-wise Sales Contribution** for targeted promotions
- **Customer Buying Patterns** to enhance personalized recommendations

## 🚀 How to Use
1. Clone this repository:
   ```bash
   git clone https://github.com/yourusername/bookstore-sales-analytics.git
   ```
2. Import the dataset into your **MySQL/PostgreSQL database**.
3. Run the provided SQL scripts to analyze bookstore sales.
4. Modify queries to extract **custom insights** based on business needs.

## 📖 Quote
*"The best analytics reveal not just numbers, but the stories hidden within them—just like books."*
