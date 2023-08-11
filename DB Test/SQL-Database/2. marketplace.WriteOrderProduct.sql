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

BEGIN
   SET NOCOUNT ON;
   BEGIN TRY
      DECLARE @vMessage                NVARCHAR(MAX)
      
      SET @vMessage = ''

      IF NOT EXISTS(SELECT TOP 1 1 
                      FROM marketplace.[Order]
                     WHERE OrderId = @OrderId
                           AND Status = 'OPEN')
      BEGIN
         SET @vMessage = 'Error: Status Order debe estar en OPEN'
      END

      IF (ISNULL(@ProductId, 0) <= 0)
      BEGIN
         SET @vMessage = 'Error: @ProductId debe ser mayor a 0'
      END

      IF (ISNULL(@Qty, 0) <= 0)
      BEGIN
         SET @vMessage = 'Error: @Qty debe ser mayor a 0'
      END

      IF (ISNULL(@UnitPrice, 0) <= 0)
      BEGIN
         SET @vMessage = 'Error: @UnitPrice debe ser mayor a 0'
      END

      IF (ISNULL(@TotalPrice, 0) <= 0)
      BEGIN
         SET @vMessage = 'Error: @TotalPrice debe ser mayor a 0'
      END

      IF (@vMessage != '' AND @Delete = 0)
      BEGIN
         SELECT 'No fue posible realizar la acción. ' + @vMessage
      END
      ELSE IF (@Delete = 1 AND NOT EXISTS(SELECT TOP 1 1 
                                            FROM marketplace.[OrderProduct]
                                           WHERE OrderId = @OrderId
                                             AND ProductId = @ProductId))
      BEGIN
         SELECT 'No fue posible realizar la acción. Error: No existe el registro a eliminar'
      END
      ELSE
      BEGIN
         MERGE INTO marketplace.[orderProduct] AS TARGET
         USING (SELECT OrderId    = @OrderId,
                       ProductId  = @ProductId,
                       Qty        = @Qty,
                       UnitPrice  = @UnitPrice,
                       TotalPrice = @TotalPrice
               ) AS SOURCE
            ON TARGET.OrderId = SOURCE.OrderId 
           AND TARGET.ProductId = SOURCE.ProductId
          WHEN NOT MATCHED BY TARGET THEN
               INSERT (OrderId, ProductId, Qty, UnitPrice, TotalPrice)
               VALUES (SOURCE.OrderId, SOURCE.ProductId, SOURCE.Qty, SOURCE.UnitPrice, SOURCE.TotalPrice)
          WHEN MATCHED AND @Delete = 0 THEN
               UPDATE SET TARGET.Qty = SOURCE.Qty,
                          TARGET.UnitPrice = SOURCE.UnitPrice,
                          TARGET.TotalPrice = SOURCE.TotalPrice
          WHEN MATCHED AND @Delete = 1 THEN
               DELETE
        OUTPUT $action,
               DELETED.OrderId      AS TargetOrderId,
               DELETED.ProductId    AS TargetProductId,
               DELETED.Qty          AS TargetQty,
               DELETED.UnitPrice    AS TargetUnitPrice,
               DELETED.TotalPrice   AS TargetTotalPrice,
               INSERTED.OrderId     AS SourceOrderId,
               INSERTED.ProductId   AS SourceProductId,
               INSERTED.Qty         AS SourceQty,
               INSERTED.UnitPrice   AS SourceUnitPrice,
               INSERTED.TotalPrice  AS SourceTotalPrice;
      END
      
   END TRY
   BEGIN CATCH
      DECLARE @vError nvarchar(max)
      DECLARE @ErrorMessage NVARCHAR(max);
      DECLARE @ErrorSeverity INT;
      DECLARE @ErrorState INT;
      
      SELECT @ErrorMessage = UPPER(ERROR_MESSAGE()),
             @ErrorSeverity = ERROR_SEVERITY(), 
             @ErrorState = ERROR_STATE();
             RAISERROR(@ErrorMessage, -- Message text.
                       @ErrorSeverity, -- Severity.
                       @ErrorState -- State.
                      );
   END CATCH
END

GO

-- EXEC marketplace.WriteOrderProduct 4, 66, 0, 5, 10.00, 20.00