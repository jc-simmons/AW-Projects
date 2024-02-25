-- Want to extract individual customers demographics with their total purchase amount
-- Demographic info is stored in .XML format in the Person.Person Table, several ways to read
-- aggregate purchase info with a subquery first, then connect to demographic info using BusinessEntityID


WITH XMLNAMESPACES (DEFAULT 'http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey')

SELECT  -- see
	'BirthYear' = YEAR(Demographics.value('(/IndividualSurvey/BirthDate)[1]','date')),
	'MaritalStatus' =  Demographics.value('(/IndividualSurvey/MaritalStatus)[1]','VARCHAR(30)'),
	'Education' =  Demographics.value('(/IndividualSurvey/Education)[1]','VARCHAR(30)'),
	'YearlyIncome' = Demographics.value('(/IndividualSurvey/YearlyIncome)[1]','VARCHAR(30)'),
	'Gender' = Demographics.value('(/IndividualSurvey/Gender)[1]','VARCHAR(30)'),
	'TotalChildren' = Demographics.value('(/IndividualSurvey/TotalChildren)[1]','INT'),
	'Occupation' =  Demographics.value('(/IndividualSurvey/Occupation)[1]','VARCHAR(30)'),
	'CommuteDistance' = Demographics.value('(/IndividualSurvey/CommuteDistance)[1]','VARCHAR(30)'),
	'NumberCarsOwned' = Demographics.value('(/IndividualSurvey/NumberCarsOwned)[1]','INT'),
	'HomeOwnerFlag' = Demographics.value('(/IndividualSurvey/HomeOwnerFlag)[1]','VARCHAR(30)'),
	TerritoryID,
	Total_Purchases
	FROM Person.Person
	JOIN (
		SELECT BusinessEntityID,   
		MIN(Sales.Customer.TerritoryID) AS TerritoryID, -- territories are identical so arbitrarily aggregate
		SUM(TotalDue) as Total_Purchases
			FROM Person.Person
		LEFT JOIN 
			Sales.Customer
			ON Sales.Customer.PersonID = Person.Person.BusinessEntityID
		JOIN 
			Sales.SalesOrderHeader
			ON Sales.SalesOrderHeader.CustomerID = Sales.Customer.CustomerID
		WHERE PersonType = 'IN'  -- only interested in "Individual" customers
		GROUP BY BusinessEntityID) sub
		ON Person.Person.BusinessEntityID = sub.BusinessEntityID
