
CREATE OR ALTER VIEW CustomerLookup AS
WITH XMLNAMESPACES (DEFAULT 'http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey')
SELECT 
	BusinessEntityID AS CustomerID,
	'BirthYear' = YEAR(Demographics.value('(/IndividualSurvey/BirthDate)[1]','date')),
	'MaritalStatus' =  Demographics.value('(/IndividualSurvey/MaritalStatus)[1]','VARCHAR(30)'),
	'Education' =  Demographics.value('(/IndividualSurvey/Education)[1]','VARCHAR(30)'),
	'YearlyIncome' = Demographics.value('(/IndividualSurvey/YearlyIncome)[1]','VARCHAR(30)'),
	'Gender' = Demographics.value('(/IndividualSurvey/Gender)[1]','VARCHAR(30)'),
	'TotalChildren' = Demographics.value('(/IndividualSurvey/TotalChildren)[1]','INT'),
	'Occupation' =  Demographics.value('(/IndividualSurvey/Occupation)[1]','VARCHAR(30)'),
	'CommuteDistance' = Demographics.value('(/IndividualSurvey/CommuteDistance)[1]','VARCHAR(30)'),
	'NumberCarsOwned' = Demographics.value('(/IndividualSurvey/NumberCarsOwned)[1]','INT'),
	'HomeOwnerFlag' = Demographics.value('(/IndividualSurvey/HomeOwnerFlag)[1]','VARCHAR(30)')
	FROM Person.Person
WHERE PersonType = 'IN';  -- only interested in "Individual" customers

Select * FROM CustomerLookup

CREATE OR ALTER VIEW SalesOrder AS
SELECT SalesOrderID AS OrderID,
		OrderDate,
		CustomerID,
		TerritoryID
FROM Sales.SalesOrderHeader


CREATE  OR ALTER VIEW SalesDetail AS
SELECT SalesOrderID AS OrderID,
		SalesOrderDetailID AS SubOrderID,
		OrderQty,
		ProductID,
		LineTotal AS Total_after_discount
FROM Sales.SalesOrderDetail


SELECT * FROM SalesDetail

Select * FROM SalesOrder

Select * FROM SalesDetail
ORDER BY ProductID

CREATE OR ALTER VIEW ProductLookup AS
SELECT 	ProductID,
		Name,
		ISNULL(Color,'NA') AS Color,
		StandardCost AS Cost,
		ListPrice,
		ISNULL(ProductLine,'NA') AS ProductLine,
		ISNULL(Class,'NA') as Class,
		ISNULL(ProductSubcategoryID, 0) AS SubcategoryID
FROM Production.Product
WHERE ListPrice > 0.00


CREATE OR ALTER VIEW ProductSubCatLookup AS
SELECT ProductSubcategoryID AS SubcategoryID,
		ProductCategoryID AS CategoryID,
		Name AS Subcategory
FROM Production.ProductSubcategory

CREATE OR ALTER VIEW ProductCatLookup AS
SELECT ProductCategoryID AS CategoryID,
		Name as Category
FROM Production.ProductCategory


