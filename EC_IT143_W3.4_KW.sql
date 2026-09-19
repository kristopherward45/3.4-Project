/*****************************************************************************************************************
NAME:Kristopher Ward
PURPOSE:AdventureWorks SQL queries for business and metadata questions.

MODIFICATION LOG:
Ver      Date        Author        Description
-----   ----------   -----------   -------------------------------------------------------------------------------
1.0     9/18/2026      KW            For 3.4 Project


RUNTIME: 
0m 2s

NOTES: 
SQL script answering 8 assignment questions from the AdventureWorks database
 
******************************************************************************************************************/

USE AdventureWorks2022;
GO

-- Q1 Business User question—Marginal complexity: Which ten products have highest list prices?
-- A1: Returns the 10 products with the highest list price in descending order.

SELECT TOP 10
    ProductID,
    Name,
    ListPrice
FROM Production.Product
ORDER BY ListPrice DESC;
GO


-- Q2 Business User question—Marginal complexity: Which products currently have lowest standard costs?
-- A2: Shows products sorted by lowest standard cost, excluding products priced at 0.

SELECT 
    ProductID,
    Name,
    StandardCost
FROM Production.Product
WHERE StandardCost > 0
ORDER BY StandardCost ASC;
GO


-- Q3 Business User question—Moderate complexity: Which five products have the highest total order quantities, and what are their product names?
-- A3: Joins SalesOrderDetail to Product to sum total quantities ordered per item.

SELECT TOP 5
    p.ProductID,
    p.Name,
    SUM(sod.OrderQty) AS TotalQuantity
FROM Sales.SalesOrderDetail sod
JOIN Production.Product p 
    ON sod.ProductID = p.ProductID
GROUP BY p.ProductID, p.Name
ORDER BY TotalQuantity DESC;
GO


-- Q4 Business User question—Moderate complexity: Which five customers have placed the greatest number of sales orders, and how many orders has each customer placed?
-- A4: Counts overall orders per customer ID from SalesOrderHeader.

SELECT TOP 5
    CustomerID,
    COUNT(SalesOrderID) AS TotalOrders
FROM Sales.SalesOrderHeader
GROUP BY CustomerID
ORDER BY TotalOrders DESC;
GO


-- Q5 Business User question—Increased complexity: Which product categories generated the most sales revenue during the year?
-- A5: Aggregates order line totals up to the category level.

SELECT 
    pc.Name AS CategoryName,
    SUM(sod.LineTotal) AS TotalRevenue
FROM Sales.SalesOrderDetail sod
JOIN Production.Product p 
    ON sod.ProductID = p.ProductID
JOIN Production.ProductSubcategory ps 
    ON p.ProductSubcategoryID = ps.ProductSubcategoryID
JOIN Production.ProductCategory pc 
    ON ps.ProductCategoryID = pc.ProductCategoryID
GROUP BY pc.Name
ORDER BY TotalRevenue DESC;
GO


-- Q6 Business User question—Increased complexity: Identify the five sales territories with the highest sales revenue and show the total revenue and number of orders associated with each territory.
-- A6: Joins SalesTerritory and SalesOrderHeader to calculate total revenue and order counts per territory.

SELECT TOP 5
    st.Name AS TerritoryName,
    SUM(soh.SubTotal) AS TotalRevenue,
    COUNT(soh.SalesOrderID) AS TotalOrders
FROM Sales.SalesOrderHeader soh
JOIN Sales.SalesTerritory st 
    ON soh.TerritoryID = st.TerritoryID
GROUP BY st.Name
ORDER BY TotalRevenue DESC;
GO


-- Q7 Metadata question: List all tables in the AdventureWorks database that contain a column named ProductID using the INFORMATION_SCHEMA.COLUMNS view?
-- A7: Lists tables containing a 'ProductID' column via INFORMATION_SCHEMA.COLUMNS.

SELECT 
    TABLE_SCHEMA,
    TABLE_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE COLUMN_NAME = 'ProductID'
ORDER BY TABLE_SCHEMA, TABLE_NAME;
GO


-- Q8 Metadata question: Identify all columns in the Sales schema and provide their table names, column names, and data types using one Information Schema view?
-- A8: Returns column details for all tables located in the Sales schema.

SELECT 
    TABLE_NAME,
    COLUMN_NAME,
    DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'Sales'
ORDER BY TABLE_NAME, ORDINAL_POSITION;
GO