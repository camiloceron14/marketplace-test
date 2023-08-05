Use Sales
GO

CREATE OR ALTER PROCEDURE marketplace.ReadOrder
    @FilterXml xml,
    @DataTablesXml xml,
    @Language varchar(2) = 'EN'
AS

-- Validaciones

-- Lectura parametros

-- 'Order-Header'
IF EXISTS ( SELECT 1
            FROM   @TableData
            WHERE  TableName = 'Order-Header' )
BEGIN
    SELECT TableName = 'Order-Header';

    SELECT
               O.OrderId,
               O.CustomerId,
               C.CustomerName,
               O.OrderDate,
               O.Status
    FROM		...
	WHERE		...
    ORDER BY    ...;
END;

-- 'Order-Detail'
IF EXISTS ( SELECT 1
            FROM   @TableData
            WHERE  TableName = 'Order-Detail' )
BEGIN
    SELECT TableName = 'Order-Detail';
    SELECT
               OP.OrderId,
               OP.ProductId,
               OP.Qty,
               OP.UnitPrice,
               OP.TotalPrice
    FROM		...
	WHERE		...
    ORDER BY    ...;
END;

-- 'Order-History-Json'
IF EXISTS ( SELECT 1
            FROM   @TableData
            WHERE  TableName = 'Order-History-Json' )
BEGIN
    SELECT TableName = 'Order-History-Json';


END;
GO

/*
-------------------- By OrderId
DECLARE
    @FilterXml xml = '
	<ROOT>
		<Filter OrderId="1"/>
	</ROOT>',
    @DataTablesXml xml = '
	<ROOT>
		<DataTable TableName="Order-Header"/>
		<DataTable TableName="Order-Detail"/>
	</ROOT>';

EXEC marketplace.ReadOrder
    @FilterXml = @FilterXml,
    @DataTablesXml = @DataTablesXml;
GO

-------------------- By CustomerId and Order in OPEN Status
DECLARE
    @FilterXml xml = '
	<ROOT>
		<Filter CustomerId="1" Status="OPEN"/>
	</ROOT>',
    @DataTablesXml xml = '
	<ROOT>
		<DataTable TableName="Order-Header"/>
		<DataTable TableName="Order-Detail"/>
	</ROOT>';

EXEC marketplace.ReadOrder
    @FilterXml = @FilterXml,
    @DataTablesXml = @DataTablesXml;
*/

-------------------- Order-History by CustomerId 
DECLARE
    @FilterXml xml = '
	<ROOT>
		<!-- <Filter CustomerId="1"/> -->
		<Filter CustomerId="-1" />
	</ROOT>',
    @DataTablesXml xml = '
	<ROOT>
		<DataTable TableName="Order-History-Json"/>
	</ROOT>';

EXEC marketplace.ReadOrder
    @FilterXml = @FilterXml,
    @DataTablesXml = @DataTablesXml,
    @Language = 'DE';
