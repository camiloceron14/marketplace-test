Use Sales
GO

CREATE OR ALTER PROCEDURE marketplace.WriteOrderProduct
    @OrderId int,
    @ProductId int = NULL,
    @Delete bit = 0,
    @Qty int = NULL,
    @UnitPrice money = NULL,
    @TotalPrice money = NULL
AS

-- Validaciones

-- CUD using MERGE statement

GO
