#Q1. What is a Common Table Expression (CTE), and how does it improve SQL query readability?
#Ans: A Common Table Expression (CTE) is a temporary, named result set that you can reference within a single SELECT, INSERT, UPDATE, or DELETE statement. We define it using the WITH keyword at the beginning of your query.
#: It improve SQL query by using Top-to-Bottom Logic,Avoids Repetition: of subqueries,Naming Clarity by providing temperory name 

#Q2. Why are some views updatable while others are read-only? Explain with an example.
#Ans The difference between an updatable view and a read-only view depends on whether the database can trace a change in the view back to a single, specific row in the original table
#: Ex: Imagine you have a table called Sales and you create a view to see the total revenue per specialist:

CREATE VIEW Specialist_Revenue AS
SELECT Specialist, SUM(Price) as Total_Earned
FROM Appointments
GROUP BY Specialist;

# If you try to update the Total_Earned from 5000 to 6000, the database gets confused. It doesn't know which specific appointments to change to make that total happen.

#Q3. What advantages do stored procedures offer compared to writing raw SQL queries repeatedly?
# Ans: The main benefit identified for a Stored Procedure is that it provides reusable SQL logic. Instead of writing a complex query from scratch every time, you save it once in the database and call it whenever you need it

#Q4. What is the purpose of triggers in a database? Mention one use case where a trigger is essential.
# Ans: In a database, a Trigger is a specialized stored program that executes automatically in response to specific events on a table, such as an INSERT, UPDATE, or DELETE operation.
#Ex:  Imagine an employee's salary is updated. A trigger can be set to "fire" every time an UPDATE occurs on the Salary column. It can automatically take the previous salary (using the OLD.Salary keyword) and the new salary, 
# then write them into a separate Audit_Log table along with a timestamp. This ensures a permanent, tamper-proof record of all financial changes without the developer needing to write extra code in the main application.

#Q5. Explain the need for data modelling and normalization when designing a database.
# Ans: Data modeling and normalization are the architectural foundations of a database, ensuring that information is structured logically, efficiently, and accurately.
# Data modeling is the process of creating a visual representation or "blueprint" of the entire database before any code is written. It is essential because:
# Visualizes Relationships: It helps define how different entities (like Customers, Orders, and Products) connect to one another.
# Business Logic Alignment: It ensures the database structure matches the actual requirements of the business or application.
# Reduces Development Errors: By planning the structure first, developers avoid costly mistakes that are difficult to fix after the database is populated with data.

use company_db1;

CREATE TABLE Products (

ProductID INT PRIMARY KEY,
ProductName VARCHAR(100),
Category VARCHAR(50), 
Price DECIMAL(10,2));

INSERT INTO Products VALUES
(1, 'Keyboard', 'Electronics', 1200), (2, 'Mouse', 'Electronics', 800), (3, 'Chair', 'Furniture', 2500), (4, 'Desk', 'Furniture', 5500);

CREATE TABLE Sales (
SaleID INT PRIMARY KEY,
ProductID INT,
Quantity INT, 
SaleDate DATE, 
FOREIGN KEY (ProductID) REFERENCES Products (ProductID));

INSERT INTO Sales VALUES
(1, 1, 4, '2024-01-05'), 
(2, 2, 10, '2024-01-06'), 
(3,3, 2, '2024-01-10'), 
(4,4, 1, '2024-01-11');

Select * from Products;
Select * from Sales;

#Q6. Write a CTE to calculate the total revenue for each product (Revenues = Price × Quantity), and return only products where  revenue > 3000.
 
 WITH Total_Rev as (
	 Select ProductName,sum(Quantity * Price) as Total_revenue from Products p
	 join sales s
	 on p.ProductID =s.ProductID
	 group by ProductName
)
SELECT ProductName, Total_revenue 
FROM Total_Rev
WHERE Total_revenue > 3000
ORDER BY Total_revenue;

#Q7.Create a view named that shows:Category, TotalProducts, AveragePrice.

CREATE VIEW CategorySummary AS
SELECT 
    Category, 
    COUNT(ProductID) AS TotalProducts, 
    Round(AVG(Price)) AS AveragePrice
FROM Products
GROUP BY Category;

SELECT * FROM CategorySummary;

#Q8. Create an updatable view containing ProductID, ProductName, and Price. Then update the price of ProductID = 1 using the view.

CREATE VIEW ProductBasicInfo AS
SELECT ProductID, ProductName, Price
FROM Products;

UPDATE ProductBasicInfo 
SET Price = 1500 
WHERE ProductID = 1;

SELECT * FROM Products WHERE ProductID = 1;

#Q9. Create a stored procedure that accepts a category name and returns all products belonging to that category.

DELIMITER //

CREATE PROCEDURE GetProductsByCategory(IN cat_name VARCHAR(50))
BEGIN
    SELECT * FROM Products 
    WHERE Category = cat_name;
END //

DELIMITER ;

CALL GetProductsByCategory('Electronics');
CALL GetProductsByCategory('Furniture');

#Q10. Create an AFTER DELETE trigger on the Products table that archives deleted product rows into a new
#table ProductArchive. The archive should store ProductID, ProductName, Category, Price, and DeletedAt timestamp

CREATE TABLE ProductArchive (
    ArchiveID INT AUTO_INCREMENT PRIMARY KEY,
    ProductID INT,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    Price DECIMAL(10,2),
    DeletedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DELIMITER //

CREATE TRIGGER ArchiveDeletedProduct
AFTER DELETE ON Products
FOR EACH ROW
BEGIN
    INSERT INTO ProductArchive (ProductID, ProductName, Category, Price)
    VALUES (OLD.ProductID, OLD.ProductName, OLD.Category, OLD.Price);
END //

DELIMITER ;

DELETE FROM Sales WHERE ProductID = 3;
DELETE FROM Products WHERE ProductID = 3;

SELECT * FROM ProductArchive;