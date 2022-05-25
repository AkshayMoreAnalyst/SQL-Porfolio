CREATE TABLE EmployeeDemographics
(EmployeeID int,
FirstName varchar(50),
LastName varchar(50),
Age int,
Gender varchar(50)
);


CREATE TABLE EmployeeSalary
(EmployeeID int,
JobTitle varchar(50),
Salary int);

--Table 1 Insert:
Insert into EmployeeDemographics VALUES
(1001, 'Jim', 'Halpert', 30, 'Male'),
(1002, 'Pam', 'Beasley', 30, 'Female'),
(1003, 'Dwight', 'Schrute', 29, 'Male'),
(1004, 'Angela', 'Martin', 31, 'Female'),
(1005, 'Toby', 'Flenderson', 32, 'Male'),
(1006, 'Michael', 'Scott', 35, 'Male'),
(1007, 'Meredith', 'Palmer', 32, 'Female'),
(1008, 'Stanley', 'Hudson', 38, 'Male'),
(1009, 'Kevin', 'Malone', 31, 'Male');

SELECT * from EmployeeDemographics ed ;

--Table 2 Insert:
Insert Into EmployeeSalary VALUES
(1001, 'Salesman', 45000),
(1002, 'Receptionist', 36000),
(1003, 'Salesman', 63000),
(1004, 'Accountant', 47000),
(1005, 'HR', 50000),
(1006, 'Regional Manager', 65000),
(1007, 'Supplier Relations', 41000),
(1008, 'Salesman', 48000),
(1009, 'Accountant', 42000);

SELECT * FROM EmployeeSalary es ;

SELECT top 5 * 
from EmployeeDemographics;

SELECT COUNT(LastName) as LastNameCount from EmployeeDemographics ed ;

SELECT 
max(Salary) as MaxSalary,
JobTitle 
FROM EmployeeSalary es 
group by JobTitle ;

SELECT EmployeeID, FirstName, LastName, Age, Gender
FROM EmployeeDemographics;
------------------------------------------------------finding duplicates in the table

--first method using group by
SELECT FirstName,LastName, count(*) as Dupal
FROM EmployeeDemographics
group by FirstName,LastName
having count(*)>1;

--second method using CTE
With Emp_CTE as
(SELECT *,
ROW_NUMBER() over (partition by Firstname, LastName Order by EmployeeID) as RNum
FROM EmployeeDemographics)
select * from Emp_CTE where RNum>1

--same query we can use to delete the duplicate records using delete command
With Emp_CTE as
(SELECT *,
ROW_NUMBER() over (partition by Firstname, LastName Order by EmployeeID) as RNum
FROM EmployeeDemographics)
Delete from Emp_CTE where RNum>1
---------------------------------------------------------------------------------------------------------------
/*
 where clause
=, <>, <, >, And, Or, Like, Null, Not Null, In
 */

SELECT *
FROM EmployeeDemographics
--WHERE Age >= 30 AND Gender = 'Male';
--where LastName LIKE 'S%';
where FirstName IN ('PAM','Michael');	--the values inside are not case sensitive


SELECT Gender, Age, COUNT(Age) as AgeCount
FROM EmployeeDemographics ed 
WHERE Age > 30
group by Gender 
ORDER by AgeCount DESC ;


SELECT * FROM EmployeeSalary es 
order by 3 DESC  ;	--here 3 is refering to column number 
---------------------------------------------------------------------------------
Insert into EmployeeDemographics VALUES
--(1011, 'Ryan', 'Howard', 26, 'Male')
(1013, 'Jin', 'Phillips', 28, 'Female')

Insert into EmployeeDemographics VALUES
(NULL, 'Holy', 'Flax',NUll ,NUll )

Insert Into EmployeeSalary VALUES
(NULL, 'Salesman', 43000)

/* joins inner join and then left right or full outer join*/

select ed.EmployeeID, FirstName, LastName, Salary 
from SQLTutorial1.dbo.EmployeeDemographics ed
inner join SQLTutorial1.dbo.EmployeeSalary es
on ed.EmployeeID = es.EmployeeID;

--check highest paid employee details from DB
select ed.EmployeeID, FirstName, LastName, Salary 
from SQLTutorial1.dbo.EmployeeDemographics ed
inner join SQLTutorial1.dbo.EmployeeSalary es
on ed.EmployeeID = es.EmployeeID
where FirstName<>'Michael'
order by Salary Desc;

--check average salary of Salesman in company
select JobTitle, Avg(Salary) As AvgSal 
from SQLTutorial1.dbo.EmployeeDemographics ed
inner join SQLTutorial1.dbo.EmployeeSalary es
on ed.EmployeeID = es.EmployeeID
where JobTitle='Salesman'
group by JobTitle

------------------------------------------------------Union and Union All
--Table 3 Query:
Create Table WareHouseEmployeeDemographics 
(EmployeeID int, 
FirstName varchar(50), 
LastName varchar(50), 
Age int, 
Gender varchar(50)
)

--Table 3 Insert:
Insert into WareHouseEmployeeDemographics VALUES
(1013, 'Darryl', 'Philbin', NULL, 'Male'),
(1050, 'Roy', 'Anderson', 31, 'Male'),
(1051, 'Hidetoshi', 'Hasagawa', 40, 'Male'),
(1052, 'Val', 'Johnson', 31, 'Female')

select *
from SQLTutorial1.dbo.EmployeeDemographics ed
full outer join SQLTutorial1.dbo.WareHouseEmployeeDemographics wed
on ed.EmployeeID = wed.EmployeeID;

select * from SQLTutorial1.dbo.EmployeeDemographics
Union 
select * from SQLTutorial1.dbo.WareHouseEmployeeDemographics
--always make sure that columns and data types are same while doing Union

-------------------------------------------------------Case statement
select FirstName, LastName, Age, 
Case
	when Age <=28 then 'baby'
	When Age between 29 and 31 then 'Young'
	Else 'Old'
End as AgeGroup
from EmployeeDemographics
where Age is not null
order by Age

--calculate new salaries of all the employees based on the job title

select ed.EmployeeID, FirstName, LastName,JobTitle, Salary,
Case 
	when JobTitle='Salesman' then Salary+(Salary*0.10)
	when JobTitle='Accountant' then Salary+(Salary*0.05)
	When JobTitle='Regional Manager' then Salary+(Salary*0.03)
	Else Salary+(Salary*0.02)
End as NewSalary
from SQLTutorial1.dbo.EmployeeDemographics ed
inner join SQLTutorial1.dbo.EmployeeSalary es
on ed.EmployeeID = es.EmployeeID;

-------------------------------------------------using having clause (because we cant use Aggregation in where)
select JobTitle, Avg(Salary) As AvgSal
from SQLTutorial1.dbo.EmployeeDemographics ed
inner join SQLTutorial1.dbo.EmployeeSalary es
on ed.EmployeeID = es.EmployeeID
group by JobTitle
having Avg(Salary)>45000
Order by Avg(Salary)

------------------------------update table
select * from EmployeeDemographics;

update EmployeeDemographics
set EmployeeID=1012, Age=27, Gender='Female'
where FirstName='Holy'

----------------------partition by 
--when we need to aggregate on only some selected columns and display data together with other columns then we use

select FirstName, LastName, Gender, JobTitle, Salary,
Avg(Salary) over (partition by JobTitle) As AvgSal
from SQLTutorial1.dbo.EmployeeDemographics ed
inner join SQLTutorial1.dbo.EmployeeSalary es
on ed.EmployeeID = es.EmployeeID

------------------------------CTEs : common table expression - like subquery but the next query must be just after CTE
with CTE_Employee as
(select FirstName, LastName, Gender, JobTitle, Salary,
Avg(Salary) over (partition by JobTitle) As AvgSal
from SQLTutorial1.dbo.EmployeeDemographics ed
inner join SQLTutorial1.dbo.EmployeeSalary es
on ed.EmployeeID = es.EmployeeID
)
select FirstName,AvgSal from CTE_Employee
order by AvgSal

----------------------------------temp tables: temporary tables stored in memmory starting with #Name
DROP TABLE IF EXISTS #temp_employee2
Create table #temp_employee2 (
EmployeeID int,
JobTitle varchar(100),
Salary int
)

Select * From #temp_employee2

Insert into #temp_employee2 values (
'1001', 'HR', '45000'
)

Insert into #temp_employee2 
SELECT * From SQLTutorial1..EmployeeSalary

DROP TABLE IF EXISTS #temp_employee3
Create table #temp_employee3 (
JobTitle varchar(100),
EmployeesPerJob int ,
AvgAge int,
AvgSalary int
)


Insert into #temp_employee3
SELECT JobTitle, Count(JobTitle), Avg(Age), AVG(salary)
FROM SQLTutorial1.dbo.EmployeeDemographics emp
JOIN SQLTutorial1.dbo.EmployeeSalary sal
	ON emp.EmployeeID = sal.EmployeeID
group by JobTitle

Select * 
From #temp_employee3

SELECT AvgAge * AvgSalary
from #temp_employee3
-------------------------------------------------------------------------------------------------
/*
Today's Topic: String Functions - TRIM, LTRIM, RTRIM, Replace, Substring, Upper, Lower
*/

--Drop Table EmployeeErrors;

CREATE TABLE EmployeeErrors (
EmployeeID varchar(50)
,FirstName varchar(50)
,LastName varchar(50)
)

Insert into EmployeeErrors Values 
('1001  ', 'Jimbo', 'Halbert')
,('  1002', 'Pamela', 'Beasely')
,('1005', 'TOby', 'Flenderson - Fired')

Select *
From EmployeeErrors

-- Using Trim, LTRIM, RTRIM

Select EmployeeID, TRIM(employeeID) AS IDTRIM
FROM EmployeeErrors 

Select EmployeeID, RTRIM(employeeID) as IDRTRIM
FROM EmployeeErrors 

Select EmployeeID, LTRIM(employeeID) as IDLTRIM
FROM EmployeeErrors 

-- Using Replace

Select LastName, REPLACE(LastName, '- Fired', '') as LastNameFixed
FROM EmployeeErrors


-- Using Substring

Select Substring(err.FirstName,1,3), Substring(dem.FirstName,1,3), Substring(err.LastName,1,3), Substring(dem.LastName,1,3)
FROM EmployeeErrors err
JOIN SQLTutorial1.dbo.EmployeeDemographics dem
	on Substring(err.FirstName,1,3) = Substring(dem.FirstName,1,3)
	and Substring(err.LastName,1,3) = Substring(dem.LastName,1,3)

-- Using UPPER and lower

Select firstname, LOWER(firstname)
from EmployeeErrors

Select Firstname, UPPER(FirstName)
from EmployeeErrors

-- for capitalise
Select Firstname, Upper(LEFT(FirstName,1))+lower(substring(FirstName,2,len(FirstName)))
from EmployeeErrors

-----------------------------------------------------------------------------------------------------------
/*
Today's Topic: Stored Procedures
*/


CREATE PROCEDURE Temp_Employee
AS
DROP TABLE IF EXISTS #temp_employee
Create table #temp_employee (
JobTitle varchar(100),
EmployeesPerJob int ,
AvgAge int,
AvgSalary int
)


Insert into #temp_employee
SELECT JobTitle, Count(JobTitle), Avg(Age), AVG(salary)
FROM SQLTutorial1.dbo.EmployeeDemographics emp
JOIN SQLTutorial1.dbo.EmployeeSalary sal
	ON emp.EmployeeID = sal.EmployeeID
group by JobTitle

Select * 
From #temp_employee
GO;

EXEC Temp_Employee




CREATE PROCEDURE Temp_Employee2 
@JobTitle nvarchar(100)
AS
DROP TABLE IF EXISTS #temp_employee3
Create table #temp_employee3 (
JobTitle varchar(100),
EmployeesPerJob int ,
AvgAge int,
AvgSalary int
)


Insert into #temp_employee3
SELECT JobTitle, Count(JobTitle), Avg(Age), AVG(salary)
FROM SQLTutorial1.dbo.EmployeeDemographics emp
JOIN SQLTutorial1.dbo.EmployeeSalary sal
	ON emp.EmployeeID = sal.EmployeeID
where JobTitle = @JobTitle --- make sure to change this in this script from original above
group by JobTitle

Select * 
From #temp_employee3
GO;


exec Temp_Employee2 @jobtitle = 'Salesman'
exec Temp_Employee2 @jobtitle = 'Accountant'

-------------------------------------------------------------------------------------------------------------

/*
Today's Topic: Subqueries (in the Select, From, and Where Statement)
*/

Select EmployeeID, JobTitle, Salary
From EmployeeSalary

-- Subquery in Select
Select EmployeeID, Salary, (Select AVG(Salary) From EmployeeSalary) as AllAvgSalary
From EmployeeSalary

-- How to do it with Partition By
Select EmployeeID, Salary, AVG(Salary) over () as AllAvgSalary
From EmployeeSalary

-- Why Group By doesn't work
Select EmployeeID, Salary, AVG(Salary) as AllAvgSalary
From EmployeeSalary
Group By EmployeeID, Salary
order by EmployeeID


-- Subquery in From
Select a.EmployeeID, AllAvgSalary
From 
	(Select EmployeeID, Salary, AVG(Salary) over () as AllAvgSalary
	 From EmployeeSalary) a
Order by a.EmployeeID


-- Subquery in Where
Select EmployeeID, JobTitle, Salary
From EmployeeSalary
where EmployeeID in (
	Select EmployeeID 
	From EmployeeDemographics
	where Age > 30)

---------------------------------------------------------------------------------------------------------
--get maximum value from multiple columns
create table Sales
(Category varchar(50),
[2015] int,
[2016] int,
[2017] int,
[2018] int
)

insert into Sales Values
('Drinks',2000,2400,NUll,4000),
('Cakes',5000,2300,4000,1400)

select * from Sales

select Category,
(Select Max(Sales)
from (values ([2015]),([2016]),([2017]),([2018])) as SalesTbl(Sales)) as MaxSales
from dbo.Sales