/**************************************************************
    Script Name         : fnComputeAge.sql
    Purpose             : Creating a UDF to calculate exact age of the customer based on their DOB;
						  Used in Analysis Procedure
    Created By          : Zeeshan Shaikh
    Created On          : 23/11/26
    Modified By         : Zeeshan Shaikh
    Modified On         : 23/11/26
    Modified            : Version 1
****************************************************************/

CREATE OR ALTER FUNCTION fnComputeAge(@DOB DATE)
RETURNS VARCHAR(35)
AS
BEGIN
DECLARE @tempdate DATE, @years INT, @months INT, @days INT
SELECT @tempdate = @DOB
SELECT @years = DATEDIFF(YEAR, @tempdate, GETDATE()) - CASE WHEN (MONTH(@DOB) > MONTH(GETDATE())) OR (MONTH(@DOB) = MONTH(GETDATE()) AND DAY(@DOB) > DAY(GETDATE())) THEN 1 ELSE 0 END
SELECT @tempdate = DATEADD(YEAR, @years, @tempdate)
SELECT @months = DATEDIFF(MONTH, @tempdate, GETDATE()) - CASE WHEN DAY(@DOB) > DAY(GETDATE()) THEN 1 ELSE 0 END
SELECT @tempdate = DATEADD(MONTH, @months, @tempdate)
SELECT @days = DATEDIFF(DAY, @tempdate, GETDATE())
DECLARE @Age VARCHAR(35)
SET @Age = Cast(@years AS  NVARCHAR(4)) + ' Years ' + Cast(@months AS  NVARCHAR(2))+ ' Months ' +  Cast(@days AS  NVARCHAR(2))+ ' Days Old'
RETURN @Age
End

Select dbo.fnComputeAge('2004/2/3') AS Age