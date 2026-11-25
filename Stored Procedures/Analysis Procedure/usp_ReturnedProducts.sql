/**************************************************************
    Script Name         : usp_ReturnedProducts.sql
    Purpose             : Showing the Returned Products ranked by the number
                          of Units Returned OR the products only belonging to the category is shown
    Created By          : Zeeshan Shaikh
    Created On          : 24/11/26
    Modified By         : Zeeshan Shaikh
    Modified On         : 24/11/26
    Modified            : Version 1
    Note                : Only Products with at least one Return are shown.
                          Ranked by Units Returned.
****************************************************************/

CREATE OR ALTER PROC
usp_ReturnedProducts
@CategoryID VARCHAR(10)  = NULL
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @Category_Id_To_Process INT;
	BEGIN TRY
		SET @Category_Id_To_Process = TRY_CONVERT(INT, NULLIF(@CategoryID,''));

		IF (@CategoryID IS NOT NULL) AND (@Category_Id_To_Process IS NULL)
			BEGIN
				SELECT  'Invalid Category Id' AS [Message]
			END
		ELSE IF (@Category_Id_To_Process IS NOT NULL)
				AND NOT EXISTS (SELECT 1 FROM dbo.ProductCategory WHERE ProductCategoryId = @Category_Id_To_Process)
			BEGIN
				Select 'Category ' + QUOTENAME(@CategoryID,'''') + ' does not exist' AS [Message]
			END
		ELSE IF NOT EXISTS (SELECT 1 FROM dbo.ReturnProduct)
			BEGIN
				Select 'No Returns found' AS [Message]
			END
		ELSE
			BEGIN
				WITH ProductReturn(ReturnRank,ProductName,ProductCategoryName,Units_Returned)
				AS
				(
					SELECT
						DENSE_RANK() OVER (ORDER BY SUM(RP.ProductReturnCount) DESC) AS ReturnRank,
						P.ProductName,
						PC.ProductCategoryName,
						SUM(RP.ProductReturnCount) AS Units_Returned
					FROM 
					dbo.ReturnProduct RP
					INNER JOIN 
					dbo.[Product] P ON P.ProductID = RP.ProductID
					INNER JOIN 
					dbo.ProductCategory PC ON PC.ProductCategoryID = P.ProductCategoryID
					WHERE (@CategoryID IS NULL) OR (PC.ProductCategoryId = @CategoryID)
					GROUP BY  P.ProductName, PC.ProductCategoryName
				)
				SELECT 
				ReturnRank,
				ProductName,
				ProductCategoryName,
				Units_Returned
				FROM
				ProductReturn
				ORDER BY ReturnRank
			END;
		END TRY
	BEGIN CATCH
		SELECT 'An Unexpected Error Occured. Contact Administrator if the problem persists.' AS [Message]
		SELECT 'Error ' + CAST(ERROR_NUMBER() AS VARCHAR(10)) + ' : ' + ERROR_MESSAGE() AS [Message]
	END CATCH;
END;
GO

------------------------------------------------------------------------------------
--		TEST CASES
------------------------------------------------------------------------------------

EXEC usp_ReturnedProducts

-- All Returned Products ranked by Units Returned

------------------------------------------------------------------------------------

EXEC usp_ReturnedProducts @CategoryID = 2  

-- Only Products Belonging to Category 1 will be displayed by Return Rank, never Returned Products won't be displayed

-- RESULT : PASS

--------------------------------------------------------------------------------------


EXEC usp_ReturnedProducts @CategoryID =  '999'

-- Category which does not exist
-- RESULT : TEST CASE 3 PASS

------------------------------------------------------------------------------------


EXEC usp_ReturnedProducts @CategoryID =  'ABC123'

-- Characters in Category parameter which is Invalid
-- RESULT : TEST CASE 3 PASS

------------------------------------------------------------------------------------

EXEC usp_ReturnedProducts @CategoryID =  ''

-- Empty String in the Parameter
-- RESULT : TEST CASE 4 PASS

