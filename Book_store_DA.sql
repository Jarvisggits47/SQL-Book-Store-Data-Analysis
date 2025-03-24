USE project;
SHOW TABLES;
SHOW COLUMNS FROM books;
SELECT *FROM books;
SELECT *FROM orders;
SELECT *FROM Customers;
-- Basic SQL Questions (10 Questions)
-- Retrieve all books' details from the books table.
SELECT *FROM books;
-- Find books published after the year 2015.
SELECT *FROM books
WHERE Published_Year>2015;
-- Get all books that belong to a specific genre.
SELECT *FROM books;
-- List books priced between $10 and $50.
SELECT Title ,Price FROM  books WHERE 
Price BETWEEN 10 AND 50;
-- Retrieve the most expensive book available.
SELECT *FROM books
ORDER BY Price DESC LIMIT 1;
-- Find the total number of books available in stock.
SELECT Title ,SUM(Stock) AS stocks FROM books
GROUP BY Title;
-- Get a list of all unique book genres.
SELECT Genre FROM books 
GROUP BY Genre;
-- Retrieve all customers from a specific city.
SELECT *FROM customers WHERE City ='Lake Paul';
SELECT *FROM customers
GROUP BY City HAVING COUNT(*)=1;
-- Fetch all orders placed on a specific date.
SELECT *FROM Orders WHERE Order_Date='2023-03-20';

-- Find the total revenue generated from book sales.
SELECT *FROM Books;

-- Intermediate SQL Questions (30 Questions)
-- Joins & Subqueries (10 Questions)
-- Retrieve all orders along with customer names using JOIN.
SELECT o.Order_ID,c.Name,c.Customer_ID,o.Order_Date,o.Quantity,o.Total_Amount
FROM Orders o
JOIN Customers c ON c.Customer_ID=o.Customer_ID;
-- Find customers who have never placed an order.
SELECT Customer_ID FROM Customers 
WHERE Customer_ID NOT IN
					(SELECT Customer_ID FROM  Orders);
-- Identify books that have been ordered by more than one customer.
WITH CTE AS 
(SELECT b.Book_ID ,o.Customer_ID,b.Title, o.Order_ID  FROM books b
JOIN Orders o ON b.Book_ID=o.Book_ID)
SELECT Book_ID, Title,COUNT(DISTINCT Customer_ID) AS total_cnt FROM CTE 
GROUP BY Title;
-- Retrieve books along with the number of times they have been ordered, including books that have never been ordered.
-- Find the top 3 cities that have generated the most revenue.

SELECT c.City,ROUND(SUM(o.Total_Amount),2) AS revenue
FROm Orders o JOIN Customers c 
ON o.Customer_ID=c.Customer_ID
GROUP BY City ORDER BY revenue DESC LIMIT 3;
-- Identify books that are out of stock but have been ordered in the past.

SELECT b.Book_ID,b.Title,b.Stock,o.Order_ID
FROM Books b JOIN Orders o ON b.Book_ID=o.Book_ID
WHERE b.Stock=0;
-- Retrieve orders where more than 3 books were purchased in a single transaction.
SELECT *FROM Orders WHERE Quantity >=3;
-- Find customers who placed their largest order (by quantity) on their first purchase.

WITH First_purchase AS 
(
SELECT Customer_ID ,Order_Date,
RANK()OVER(PARTITION BY Customer_ID ORDER BY Order_Date ASC)AS rnk
FROM Orders ),
largest AS (
SELECT Customer_ID,Order_Date,Quantity,
RANK()OVER(PARTITION BY Customer_ID ORDER BY Quantity DESC )AS rnk
FROM Orders
)
SELECT fp.Customer_ID,c.Name,fp.Order_Date,l.Quantity
FROM First_purchase fp
JOIN largest l ON fp.Customer_ID=l.Customer_ID AND fp.Order_Date=l.Order_Date
JOIN Customers c ON c.Customer_ID=fp.Customer_ID
WHERE fp.rnk=1 AND l.rnk=1
ORDER BY l.Quantity DESC;
-- List customers who ordered books from multiple genres.

SELECT Customer_ID,Name,COUNT(DISTINCT genre) AS genre_cnt FROM (
SELECT o.Customer_ID,o.Book_ID,b.genre,c.Name
FROM Orders o JOIN Books b ON o.Book_ID=b.Book_ID
JOIN Customers c ON o.Customer_ID=c.Customer_ID) AS subquery
GROUP BY Customer_ID HAVING COUNT(DISTINCT genre)>1;
-- Retrieve the first and last book each customer ever purchased.

SELECT Customer_ID ,MIN(Order_Date) AS frist_purchase,
MAX(Order_Date) AS last_purchase
FROM Orders
GROUP BY Customer_ID;

-- Aggregations & Analytics (10 Questions)
-- Find the best-selling book based on total quantity sold.TOP 5

SELECT b.Title,o.Book_ID,SUM(o.Quantity)AS total_sold 
FROM Orders o JOIN Books b ON o.Book_ID=b.Book_ID
GROUP BY o.Book_ID ORDER BY total_sold DESC LIMIT 5;

-- Identify the total number of orders placed in the last 6 months.
SELECT COUNT(*) tottalorders FROM Orders
WHERE Order_Date>=DATE_SUB(CURRENT_DATE(),INTERVAL 6 MONTH);

-- Calculate the percentage of total revenue each genre contributes.

SELECT b.Genre,SUM(o.Quantity) AS total_sold_Quantity,
ROUND(SUM(b.Price* o.Quantity ),2)AS total_revenue,
CONCAT(ROUND(SUM(b.Price* o.Quantity)/(SELECT SUM(Total_Amount)FROm Orders) *100,2),'%') As rev_per
FROM Books b JOIN Orders o ON b.Book_ID=o.Book_ID
GROUP BY b.Genre;
-- Retrieve the most popular author based on total revenue generated.

SELECT b.Author,SUM(o.Quantity) AS total_sold_Quantity,
ROUND(SUM(b.Price* o.Quantity ),2)AS total_revenue,
CONCAT(ROUND(SUM(b.Price* o.Quantity)/(SELECT SUM(Total_Amount)FROm Orders) *100,2),'%') As rev_per
FROM Books b JOIN Orders o ON b.Book_ID=o.Book_ID
GROUP BY b.Author ORDER BY total_revenue DESC ,Author ASC;
-- Get the customer who has placed the highest number of orders.
SELECT *FROM Customers ;
SELECT *FROM Orders WHERE Customer_ID=107;

SELECT c.Name,c.Customer_ID,COUNT(o.Order_ID)AS total_orders,SUM(o.Quantity)AS total_quantity
FROM Customers c JOIN Orders o ON c.Customer_ID=o.Customer_ID
GROUP BY c.Customer_ID ORDER BY total_orders DESC LIMIT 1;
-- Retrieve the top 5 most expensive books in the store.
SELECT Title ,Price FROM Books ORDER BY Price DESC LIMIT 5  ;
SELECT Title,Price FROM (SELECT Title,Price ,RANK()OVER(ORDER BY Price DESC) AS rnk 
FROM books )subquery WHERE rnk<=5;
-- Find the book that has generated the highest revenue.
SELECT b.Title,b.Genre,b.Book_ID,SUM(o.Total_Amount )AS total_revenue
FROM Orders o JOIN Books b ON o.Book_ID=b.Book_ID
GROUP BY o.Book_ID ORDER BY total_revenue DESC LIMIT 5;
-- Calculate the average price of books in each genre.
SELECT Genre,ROUND(AVG(Price),2)AS avg_price
FROM Books GROUP BY Genre ORDER BY avg_price DESC;

-- Identify the top 3 best-selling book genres.

SELECT b.Genre,SUM(o.Quantity)AS total_quantity
FROM Orders o 
JOIN books b ON o.Book_ID=b.Book_ID
GROUP BY b.Genre ORDER BY total_quantity DESC;

-- Find the total revenue per month for the last year.
SELECT EXTRACT(MONTH FROM Order_Date)AS Month ,ROUND(SUM(Total_Amount),2) AS Total_rev_generated
FROM Orders 
WHERE EXTRACT(YEAR FROM Order_Date)=YEAR(CURDATE()) - 1
GROUP BY Month;

-- ---------------------------------Window Functions & Ranking (10 Questions)----------------------------

-- Rank all books by total sales using RANK().
SELECT *FROM Books;
WITH CTE AS 
(SELECT b.Title,SUM(b.Price*o.Quantity)AS total_sales 
FROM Books b JOIN Orders o ON b.Book_ID=o.Book_ID
GROUP BY b.Book_ID)
SELECT Title,ROUND(total_sales,2)AS Total_sales,
RANK()OVER(ORDER BY Total_sales DESC)AS rnk
FROM CTE ;
-- Retrieve each customer’s total spending along with the average spending across all customers using AVG() OVER().
SELECT *FROM Orders;
SELECT c.Name,o.Customer_ID,ROUND(SUM(Total_Amount),2)AS Total_spend,
    ROUND(AVG(SUM(o.Total_Amount)) OVER () ,2)AS Avg_spend
FROM Orders o JOIN Customers c ON c.Customer_ID=o.Customer_ID
GROUP BY c.Customer_ID;
-- Calculate the cumulative revenue of orders using SUM() OVER().
SELECT *FROM Orders;
SELECT Order_ID,Total_amount,
SUM(Total_amount)OVER(ORDER BY Order_ID ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING)AS Cumm_sum
FROM Orders ;
SELECT 
    Order_ID, 
    Total_Amount, 
    ROUND(SUM(Total_Amount) OVER (ORDER BY Order_ID),2) AS Cumulative_Revenue
FROM Orders;

-- Find the top 3 best-selling books in each genre using DENSE_RANK().
SELECT *FROM Orders;
WITH ranked AS (
SELECT o.Book_ID,b.Title,b.Genre,SUM(o.Quantity) AS total_quantity,
        DENSE_RANK() OVER (PARTITION BY b.Genre ORDER BY SUM(o.Quantity) DESC) AS rnk 
        FROM Orders o JOIN Books b ON o.Book_ID=b.Book_ID
        GROUP BY b.Genre,b.Title )
SELECT Genre,Title,total_quantity
FROM ranked  WHERE rnk<=2;

SELECT *FROM Books;

-- Retrieve the 3rd most sold book in each genre.
WITH ranked AS (
SELECT o.Book_ID,b.Title,b.Genre,SUM(o.Quantity) AS total_quantity,
        DENSE_RANK() OVER (PARTITION BY b.Genre ORDER BY SUM(o.Quantity) DESC) AS rnk 
        FROM Orders o JOIN Books b ON o.Book_ID=b.Book_ID
        GROUP BY b.Genre,b.Title )
SELECT Genre,Title,total_quantity
FROM ranked  WHERE rnk=3 ORDER BY Genre;
-- Calculate the time gap between consecutive orders for each customer using LAG().
SELECT *FROM Orders;
SELECT Customer_ID,Order_Date,
LAG(Order_Date)OVER(PARTITION BY Customer_ID ORDER BY Order_Date)As prev_date,
DATEDIFF(Order_Date,LAG(Order_Date)OVER(PARTITION BY Customer_ID ORDER BY Order_Date)
)As dd
FROM Orders
 ORDER BY Customer_ID;
-- Find the order with the highest total amount for each month in the last year.
SElect*from Orders;

-- Retrieve the most recent book sold for each customer using ROW_NUMBER().
SElect*from Orders;
WITH ranked_book AS 
(SELECT o.Customer_ID ,b.Title AS Book_Name,o.Order_Date,
ROW_NUMBER()OVER(PARTITION BY o.Customer_ID ORDER BY o.Order_Date DESC)AS rnk
FROM Orders o JOIN Books  b ON b.Book_ID=o.Book_ID)
SELECT Customer_ID , Book_Name ,Order_Date 
FROM ranked_book
WHERE rnk=1;

-- Calculate the moving average of monthly sales revenue over the last 6 months.
SElect*from Orders;
WITH sales_reve AS(
SELECT EXTRACT(MONTH FROM Order_Date)As month,SUM(Total_Amount)As total_sales
FROM Orders 
WHERE  Order_Date>=DATE_SUB(CURRENT_DATE ,INTERVAL 8 MONTH)
GROUP BY MONTH)
SELECT month ,ROUND(total_sales,2)As total_Sales,
AVG(total_sales)OVER(ORDER BY month ROWS BETWEEN 7 PRECEDING AND CURRENT ROW)AS moving_avg
FROM sales_reve;

-- Retrieve orders where the total amount is above the 75th percentile of all orders.
SELECT *FROM Books;


-- Advanced SQL Questions (30 Questions)
-- Advanced Analytics & Business Intelligence (10 Questions)
-- Identify books that had a significant drop in sales in the last 3 months.
SELECT*FROM Orders;
-- Find customers who increased their spending by at least 50% compared to the previous year.
SELECT*FROM Customers;
SELECT *FROM Orders;

-- Retrieve books that consistently appear in the top 10 best-selling list each month.
SELECT *FROM Orders;
WITH CTE AS (
SELECT Book_ID,MONTH(Order_Date)AS mnth ,Quantity,
RANK()OVER(PARTITION BY MONTH(Order_Date) ORDER BY Quantity DESC)AS rnk
FROM Orders)
SELECT Book_ID, COUNT(Book_ID)As cnt
FROM CTE
GROUP BY Book_ID;


-- Use a WITH clause to get the top 5 highest-selling books and then retrieve customers who bought them.
SELECT *FROM Orders;
SELECT Book_ID,SUM(Quantity) AS Total_quantity,RANK()OVER( ORDER BY SUM(Quantity) DESC)AS rnk
FROM Orders
group by Book_ID
ORDER BY rnk;


-- Retrieve the last 5 orders for each customer using ROW_NUMBER().

WITH CTE AS 
(SELECT Customer_ID,Book_ID,Order_Date,
ROW_NUMBER()OVER(PARTITION BY Customer_ID ORDER BY Order_Date DESC )AS rnk
FROM Orders )
SELECT c.Customer_ID,c.Book_ID ,cc.Name As Customer_Name,b.Title,c.Order_date 
FROM CTE c 
JOIN Customers  cc ON c.Customer_ID=cc.Customer_ID
JOIN Books b ON c.Book_ID=b.Book_ID
WHERE rnk<=5 ORDER BY c.Customer_ID;

-- Find customers who have only ever bought books from one author.
SELECT *FROM Orders;

;SELECT*FROM Books;
SELECT*FROM Orders ORDER BY Order_Date DESC;
-- Detect books that have been in stock for more than a year without any orders.

-- Retrieve a list of authors ranked by total revenue generated from their books.
SELECT  b.Author,ROUND(SUM(o.Total_Amount),2)As total_amount,
RANK()OVER(ORDER BY total_amount DESC )AS rnk
FROM Orders o JOIN 
Books b ON o.Book_ID=b.Book_ID
GROUP BY b.Author ORDER BY rnk
;
-- Find the percentage of revenue each book contributes to its respective genre.
WITH grp_books AS ( SELECT b.Genre,o.Quantity,SUM(o.Total_Amount )AS total_amount
FROM Orders o 
JOIN Books b ON b.Book_ID=o.Book_ID
GROUP BY b.Genre
)
SELECT b.Title,ROUND(SUM(o.Total_Amount),2)As t_amount ,c.Genre,
    ROUND(c.total_amount,2)AS Total_Grp_amount,
    CONCAT(ROUND((SUM(o.Total_Amount) * 100.0 / c.total_amount),2),"%") AS percentage_contributio
FROM Orders o 
JOIN Books b ON b.Book_ID = o.Book_ID
JOIN grp_books c ON c.Genre = b.Genre
GROUP BY b.Title, c.Genre
ORDER BY c.Genre;

-- Simulate a recommendation system by finding books that were frequently bought together.
