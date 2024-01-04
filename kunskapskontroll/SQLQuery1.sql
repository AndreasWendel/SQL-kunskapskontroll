USE AdventureWorks2022
Go


	SELECT A.name as ColumnName, ----a.name variable columnnamn "ColumnName"
		(SCHEMA_NAME(B.schema_id) + '.' + B.name) AS 'TableName'--schema_name returns sysname för (b.schema_id) + b.namn)) as columnamn, bygger string basicly
	FROM  sys.columns as A INNER JOIN sys.tables as B
		on A.object_id = B.object_id --- joinar tables som innehåller businessEntityID
	WHERE A.name LIKE '%PersonID%'
	ORDER BY TableName, ColumnName;

SELECT * FROM Sales.SalesOrderDetail
SELECT * FROM Sales.SalesOrderHeader
SELECT * FROM Sales.SalesOrderHeaderSalesReason
SELECT * FROM Person.BusinessEntityContact
--^ alla med order id
SELECT * FROM Sales.SalesReason

SELECT * FROM Sales.SalesOrderHeader
SELECT * FROM Sales.Customer
--customer id ^
SELECT * FROM Person.BusinessEntityContact
SELECT * FROM Sales.Customer --personID FK to Person.BusinessEntityID --StoreID FK to Store.BusinessEntityID
--personID^
SELECT * FROM Sales.Store

SELECT * FROM Person.Person --person.person BE-ID
SELECT * FROM Sales.Store --Sales.store BE-ID

SELECT * FROM Sales.Customer
SELECT CustomerID,
	COUNT(StoreID) as storeid,
	count(PersonID) as personid
	from sales.Customer
Group by CustomerID --alla har en enskild eller båda men inte mer än 1


SELECT * FROM Production.ProductReview 

-- person.person innehåller BEID som kan kopplas till CustomerID, i personType har vi förkortningen IN som är individual customer.
-- koppla seedan CuID till beställningar och sammansätt dem största spenderarna och ge deras information

SELECT * FROM Sales.SalesOrderDetail
SELECT * FROM Sales.SalesOrderHeader

SELECT 
	CustomerID,
	COUNT(SalesOrderID) as amountOfOrders
FROM Sales.SalesOrderHeader
Group BY CustomerID
Order by amountOfOrders DESC
-- top orders är 25-28 st

SELECT 
	CustomerID,
	sum(SubTotal) as total
FROM Sales.SalesOrderHeader
Group BY CustomerID
Order by total DESC
--- subtotal by cust

SELECT 
	ProductID
	,count(ProductID) as countprod
FROM Sales.SalesOrderDetail
Group BY ProductID
Order by countprod DESC
--- mest köpta produkten

SELECT 
	a.ProductID
	,count(a.ProductID) as countprod
	,b.Name
FROM Sales.SalesOrderDetail as a inner join Production.Product as b
	on a.ProductID = b.ProductID
Group BY a.ProductID ,b.Name
Order by countprod DESC

SELECT 
	CustomerID,
	sum(SubTotal) as total
FROM Sales.SalesOrderHeader
Group BY CustomerID
Order by total DESC
--top subtotal med vem

SELECT a.ProductID
	,a.UnitPrice
	,b.StandardCost
	,b.ListPrice
	,a.UnitPrice-b.StandardCost as diffA
	,a.UnitPrice-b.ListPrice as diffB
FROM Sales.SalesOrderDetail as a 
	INNER JOIN Production.Product as b
		on a.ProductID = b.ProductID

SELECT * FROM Sales.SalesOrderDetail
SELECT * FROM Sales.SalesOrderHeader

SELECT a.SalesOrderID
	,Sum(a.LineTotal) as totalPrice
	,b.CustomerID
	,b.SubTotal
	,b.TotalDue
	,CASE
		WHEN Sum(a.LineTotal) = b.SubTotal THEN 'TRUE'
		ELSE 'FALSE'
		end as [Check]
FROM Sales.SalesOrderDetail as a 
	INNER JOIN Sales.SalesOrderHeader as b
		on a.SalesOrderID = b.SalesOrderID
Group BY a.SalesOrderID, b.CustomerID, b.SubTotal,b.TotalDue
-- en kontroll

SELECT 
	CustomerID
	,sum(SubTotal) as total
	,count(SalesOrderID) AS [Amount of orders]
	,MAX(ModifiedDate) AS [Last Date]
	,MIN(ModifiedDate) AS [First Date]
	,datediff(DAY, MIN(ModifiedDate), MAX(ModifiedDate)) / COUNT(SalesOrderID) AS 'Days between orders'
	,datediff(DAY, MIN(ModifiedDate), MAX(ModifiedDate))
	,sum(SubTotal)/count(SalesOrderID) AS AVGsubtotaloforders
FROM Sales.SalesOrderHeader
Group BY CustomerID
HAVING sum(SubTotal)/count(SalesOrderID) > 68756
Order by total DESC

SELECT 
	CustomerID
	,sum(SubTotal) as total
	,count(SalesOrderID) AS [Amount of orders]
	,MAX(ModifiedDate) AS [Last Date]
	,MIN(ModifiedDate) AS [First Date]
	,datediff(DAY, MIN(ModifiedDate), MAX(ModifiedDate)) / COUNT(SalesOrderID) AS 'Days between orders'
	,datediff(DAY, MIN(ModifiedDate), MAX(ModifiedDate))
	,sum(SubTotal)/count(SalesOrderID) AS AVGsubtotaloforders
FROM Sales.SalesOrderHeader
Group BY CustomerID
Order by total DESC

-- custmer spent and amount of orders, and first and last order

SELECT 
	CustomerID
	,sum(SubTotal) as total
	,count(distinct SalesOrderID) AS [Amount of orders]
	,MAX(ModifiedDate) AS [Last Date]
	,MIN(ModifiedDate) AS [First Date]
	,datediff(DAY, MIN(ModifiedDate), MAX(ModifiedDate)) / COUNT(SalesOrderID) AS 'Days between orders'
	,datediff(DAY, MIN(ModifiedDate), MAX(ModifiedDate))
	,sum(SubTotal)/count(SalesOrderID) AS AVGsubtotaloforders
FROM Sales.SalesOrderHeader
Group BY CustomerID
Order by AVGsubtotaloforders DESC


SELECT 
	CustomerID
	,MAX(ModifiedDate) AS [Last Date]
	,MIN(ModifiedDate) AS [First Date]
	,datediff(DAY, MIN(ModifiedDate), MAX(ModifiedDate)) / COUNT(SalesOrderID)
FROM Sales.SalesOrderHeader AS avg_days
GROUP BY CustomerID

SELECT * FROM Production.Product
SELECT * FROM Production.ProductInventory
SELECT * FROM Purchasing.PurchaseOrderDetail
SELECT * FROM Production.ProductListPriceHistory
SELECT * FROM Production.ProductCostHistory
SELECT * FROM Production.Location

SELECT * FROM Sales.SalesOrderHeader
where CustomerID = 29641
ORDER BY SubTotal

SELECT * FROM Sales.Customer
SELECT * FROM Person.Person

SELECT a.FirstName 
	,a.LastName
	,a.PersonType
	,b.CustomerID
FROM Person.Person as a 
	INNER JOIN Sales.SalesOrderHeader AS B
		ON a.BusinessEntityID = b.CustomerID


--Gör en cte av person

SELECT FirstName 
	,LastName
	,PersonType
	,BusinessEntityID
FROM Person.Person as a 
order by BusinessEntityID

WITH CTE (FirstName 
		,LastName
		,PersonType
		,BusinessEntityID)
AS
(
	SELECT FirstName 
		,LastName
		,PersonType
		,BusinessEntityID
	FROM Person.Person
)

SELECT 
	a.CustomerID
	,sum(a.SubTotal) as total
	,count(a.SalesOrderID) AS [Amount of orders]
	,MAX(a.ModifiedDate) AS [Last Date]
	,MIN(a.ModifiedDate) AS [First Date]
	,datediff(DAY, MIN(a.ModifiedDate), MAX(a.ModifiedDate)) / COUNT(a.SalesOrderID) AS 'Days between orders'
	,datediff(DAY, MIN(a.ModifiedDate), MAX(a.ModifiedDate))
	,sum(a.SubTotal)/count(a.SalesOrderID) AS AVGsubtotaloforders
	,b.FirstName 
	,b.LastName
	,b.PersonType
FROM Sales.SalesOrderHeader as a
	LEFT JOIN CTE as b
		on a.CustomerID = b.BusinessEntityID
Group BY a.CustomerID, b.FirstName ,b.LastName ,b.PersonType
Order by AVGsubtotaloforders DESC

SELECT 
	a.CustomerID
	,sum(a.SubTotal) as total
	,count(a.SalesOrderID) AS [Amount of orders]
	,MAX(a.ModifiedDate) AS [Last Date]
	,MIN(a.ModifiedDate) AS [First Date]
	,datediff(DAY, MIN(a.ModifiedDate), MAX(a.ModifiedDate)) / COUNT(a.SalesOrderID) AS 'Days between orders'
	,datediff(DAY, MIN(a.ModifiedDate), MAX(a.ModifiedDate))
	,sum(a.SubTotal)/count(a.SalesOrderID) AS AVGsubtotaloforders
	,b.FirstName 
	,b.LastName
	,b.PersonType
	,c.PersonID
	,c.StoreID
	,d.Name
	,d.SalesPersonID
	,d.FirstName as [SP First name]
	,d.LastName as [SP Last name]
FROM Sales.SalesOrderHeader as a
	LEFT JOIN (
		SELECT CustomerID
				,PersonID
				,StoreID
	FROM Sales.Customer
	) as c 
		on a.CustomerID = c.CustomerID
	LEFT JOIN (
		SELECT 
		a.BusinessEntityID
		,a.Name
		,a.SalesPersonID
		,b.FirstName 
		,b.LastName
		,b.PersonType
	FROM Sales.store as a
		inner join Person.Person as b
			on a.SalesPersonID = b.BusinessEntityID
	) as d on c.StoreID = d.BusinessEntityID
		LEFT JOIN (
		SELECT FirstName 
		,LastName
		,PersonType
		,BusinessEntityID
	FROM Person.Person
	) as b
		on c.PersonID = b.BusinessEntityID
Group BY a.CustomerID ,b.FirstName ,b.LastName ,b.PersonType,c.PersonID,c.StoreID, d.Name, d.SalesPersonID, d.FirstName, d.LastName
Order by total DESC

SELECT * FROM Person.BusinessEntityContact



SELECT * FROM Person.Person
SELECT * FROM Person.BusinessEntity
SELECT * FROM Sales.Customer
SELECT * FROM Purchasing.Vendor
SELECT * FROM Sales.store
SELECT * FROM Sales.SalesPerson
SELECT * FROM Person.BusinessEntityContact

SELECT 
	BusinessEntityID
	,PersonType
FROM Person.Person



SELECT CustomerID
	,PersonID
	,StoreID
FROM Sales.Customer

SELECT 
	a.BusinessEntityID
	,a.Name
	,a.SalesPersonID
	,b.FirstName 
	,b.LastName
	,b.PersonType
FROM Sales.store as a
	inner join Person.Person as b
		on a.SalesPersonID = b.BusinessEntityID

-- slight problem vissa customerID finns inte i person tabellen, ej registrerade kunder?
-- kolla vem som sålde till dem
-- Om kunden inte har ett namn då har dem ett personID eller StoreID vilket betyder att det är en retail affär som har handlat
-- PersonID Foreign key to Person.BusinessEntityID
-- Store ID Foreign key to Store.BusinessEntityID Purchasing.Vendor
--sales store är affären och sales person är säljaren till affären'
-- visa är fortfarande inte indetifierade ex 13437
-- gör case statement när customer id inte leder direct till person gå via personID, persontype kommer vara store conact elr likandne
-- customer id och store id inte leder till något kolla då personID
-- största problemet är att customer id överlappar med personID så vad är vad, 

-- detta gör så att alla får ett namn, customerID kanske kan hanteras som någon som ??
-- customer hoppar från 701 till 11000 och runt 25000+ finns det inte fler BSID att koppla till customer ID
-- vid 701 cID så går det från store id till person id, antagligen för om det skulle komma fler butiks kunder så skall dem finnas vid index 702
SELECT * FROM sales.Customer

-- kolla nu hur försäljaren har jobbat



/*
ProductID	Production.Product
ProductID	Production.ProductCostHistory
ProductID	Production.ProductDocument
ProductID	Production.ProductInventory
ProductID	Production.ProductListPriceHistory
ProductID	Production.ProductProductPhoto
ProductID	Production.ProductReview
ProductID	Production.TransactionHistory
ProductID	Production.TransactionHistoryArchive
ProductID	Production.WorkOrder
ProductID	Production.WorkOrderRouting
ProductID	Purchasing.ProductVendor
ProductID	Purchasing.PurchaseOrderDetail
ProductID	Sales.SalesOrderDetail
ProductID	Sales.ShoppingCartItem
ProductID	Sales.SpecialOfferProduct*/
/*
BusinessEntityID	HumanResources.Employee
BusinessEntityID	HumanResources.EmployeeDepartmentHistory
BusinessEntityID	HumanResources.EmployeePayHistory
BusinessEntityID	HumanResources.JobCandidate
BusinessEntityID	Person.BusinessEntity
BusinessEntityID	Person.BusinessEntityAddress
BusinessEntityID	Person.BusinessEntityContact
BusinessEntityID	Person.EmailAddress
BusinessEntityID	Person.Password
BusinessEntityID	Person.Person
BusinessEntityID	Person.PersonPhone
BusinessEntityID	Purchasing.ProductVendor
BusinessEntityID	Purchasing.Vendor
BusinessEntityID	Sales.PersonCreditCard
BusinessEntityID	Sales.SalesPerson
BusinessEntityID	Sales.SalesPersonQuotaHistory
BusinessEntityID	Sales.SalesTerritoryHistory
BusinessEntityID	Sales.Store */


-- test
go

SELECT 
	a.CustomerID
	,sum(a.SubTotal) as total
	,count(a.SalesOrderID) AS [Amount of orders]
	,MAX(a.ModifiedDate) AS [Last Date]
	,MIN(a.ModifiedDate) AS [First Date]
	,datediff(DAY, MIN(a.ModifiedDate), MAX(a.ModifiedDate)) / COUNT(a.SalesOrderID) AS 'Days between orders'
	,datediff(DAY, MIN(a.ModifiedDate), MAX(a.ModifiedDate)) AS [Total days from F/L date]
	,sum(a.SubTotal)/count(a.SalesOrderID) AS AVGsubtotaloforders
	,b.FirstName 
	,b.LastName
	,b.PersonType
	,c.PersonID
	,c.StoreID
	,d.Name
	,d.SalesPersonID
	,d.FirstName as [SP First name]
	,d.LastName as [SP Last name]
FROM Sales.SalesOrderHeader as a
	LEFT JOIN (
		SELECT CustomerID
				,PersonID
				,StoreID
	FROM Sales.Customer
	) as c 
		on a.CustomerID = c.CustomerID
	LEFT JOIN (
		SELECT 
		a.BusinessEntityID
		,a.Name
		,a.SalesPersonID
		,b.FirstName 
		,b.LastName
		,b.PersonType
	FROM Sales.store as a
		inner join Person.Person as b
			on a.SalesPersonID = b.BusinessEntityID
	) as d on c.StoreID = d.BusinessEntityID
		LEFT JOIN (
		SELECT FirstName 
		,LastName
		,PersonType
		,BusinessEntityID
	FROM Person.Person
	) as b
		on c.PersonID = b.BusinessEntityID
Group BY a.CustomerID ,b.FirstName ,b.LastName ,b.PersonType,c.PersonID,c.StoreID, d.Name, d.SalesPersonID, d.FirstName, d.LastName


go

SELECT total
	,PersonType
	,AVGsubtotaloforders
FROM SALESDATA
WHERE PersonType like 'IN'

WITH CTE_salesdata AS (
SELECT 
	a.CustomerID
	,sum(a.SubTotal) as total
	,count(a.SalesOrderID) AS [Amount of orders]
	,MAX(a.ModifiedDate) AS [Last Date]
	,MIN(a.ModifiedDate) AS [First Date]
	,datediff(DAY, MIN(a.ModifiedDate), MAX(a.ModifiedDate)) / COUNT(a.SalesOrderID) AS 'Days between orders'
	,datediff(DAY, MIN(a.ModifiedDate), MAX(a.ModifiedDate)) AS [Total days from F/L date]
	,sum(a.SubTotal)/count(a.SalesOrderID) AS AVGsubtotaloforders
	,b.FirstName 
	,b.LastName
	,b.PersonType
	,c.PersonID
	,c.StoreID
	,d.Name
	,d.SalesPersonID
	,d.FirstName as [SP First name]
	,d.LastName as [SP Last name]
FROM Sales.SalesOrderHeader as a
	LEFT JOIN (
		SELECT CustomerID
				,PersonID
				,StoreID
	FROM Sales.Customer
	) as c 
		on a.CustomerID = c.CustomerID
	LEFT JOIN (
		SELECT 
		a.BusinessEntityID
		,a.Name
		,a.SalesPersonID
		,b.FirstName 
		,b.LastName
		,b.PersonType
	FROM Sales.store as a
		inner join Person.Person as b
			on a.SalesPersonID = b.BusinessEntityID
	) as d on c.StoreID = d.BusinessEntityID
		LEFT JOIN (
		SELECT FirstName 
		,LastName
		,PersonType
		,BusinessEntityID
	FROM Person.Person
	) as b
		on c.PersonID = b.BusinessEntityID
Group BY a.CustomerID ,b.FirstName ,b.LastName ,b.PersonType,c.PersonID,c.StoreID, d.Name, d.SalesPersonID, d.FirstName, d.LastName
)

SELECT *
FROM CTE_salesdata
WHERE PersonType like 'SC'
--SC
--29
--635
--in
--2029
--18484