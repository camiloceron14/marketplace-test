Use Sales
GO

CREATE OR ALTER PROCEDURE marketplace.WriteOrder
    @OrderId int = NULL OUTPUT,
    @Delete bit = 0,
    @CustomerId int = NULL,
    @OrderDate datetime = NULL,
    @Status varchar(20) = NULL
AS

-- Validaciones

-- CUD using MERGE statement

GO

