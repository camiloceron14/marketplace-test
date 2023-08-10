USE [master]
GO

IF EXISTS(SELECT 1 FROM sys.sysdatabases D WHERE D.name = 'Sales')
BEGIN
	ALTER DATABASE [Sales] SET  SINGLE_USER WITH ROLLBACK IMMEDIATE;
END
GO

DROP DATABASE IF EXISTS [Sales];
GO

CREATE DATABASE [Sales]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Sales', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS03\MSSQL\DATA\Sales.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'Sales_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS03\MSSQL\DATA\Sales_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO

Use [Sales]
go

DROP PROCEDURE IF EXISTS marketplace.WriteOrder;
DROP PROCEDURE IF EXISTS marketplace.WriteOrderProduct;
DROP PROCEDURE IF EXISTS marketplace.ReadOrder;
-- 
DROP TABLE IF EXISTS marketplace.[OrderProduct];
DROP TABLE IF EXISTS marketplace.[Order];
DROP TABLE IF EXISTS marketplace.Customer;
DROP TABLE IF EXISTS marketplace.LocationDescription;
DROP TABLE IF EXISTS marketplace.Location;
DROP SEQUENCE IF EXISTS marketplace.seqOrder;
DROP SCHEMA IF EXISTS marketplace;
GO

CREATE SCHEMA [marketplace] AUTHORIZATION [dbo];
GO

CREATE SEQUENCE marketplace.seqOrder
AS int
START WITH 8
INCREMENT BY 1;
GO

CREATE TABLE marketplace.Location
    ( [LocationId] [int] NOT NULL,
      [LocationType] [nvarchar](20) NOT NULL,
      [LocationName] [nvarchar](50) NOT NULL,
      [ParentLocationId] [int] NULL,
      CONSTRAINT [PK_marketplace_Location]
          PRIMARY KEY CLUSTERED ( [LocationId] ASC )
          WITH ( PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF ) ON [PRIMARY] ) ON [PRIMARY];
GO

ALTER TABLE marketplace.Location
ADD CONSTRAINT [FK_Location_Location_ParentLocationId]
    FOREIGN KEY ( [ParentLocationId] )
    REFERENCES marketplace.Location ( [LocationId] );
GO

CREATE TABLE marketplace.LocationDescription
    ( [LocationId] [int] NOT NULL,
      [Language] [nvarchar](2) NOT NULL,
      [Description] [nvarchar](500) NOT NULL,
      CONSTRAINT [PK_marketplace_LocationDescription]
          PRIMARY KEY CLUSTERED ( [LocationId] ASC, [Language] ASC )
          WITH ( PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF ) ON [PRIMARY] ) ON [PRIMARY];
GO

ALTER TABLE marketplace.LocationDescription
ADD CONSTRAINT [FK_LocationDescription_Location_LocationId]
    FOREIGN KEY ( LocationId )
    REFERENCES marketplace.Location ( [LocationId] );
GO

CREATE TABLE marketplace.Customer
    ( [CustomerId] [int] NOT NULL,
      [CustomerName] [nvarchar](500) NOT NULL,
      [LocationId] [int] NOT NULL,
      [Address] [nvarchar](100) NOT NULL,
      CONSTRAINT [PK_marketplace_Customer]
          PRIMARY KEY CLUSTERED ( [CustomerId] ASC )
          WITH ( PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF ) ON [PRIMARY] ) ON [PRIMARY];
GO

ALTER TABLE marketplace.Customer
ADD CONSTRAINT [FK_Customer_Location_LocationId]
    FOREIGN KEY ( LocationId )
    REFERENCES marketplace.Location ( [LocationId] );
GO

CREATE TABLE marketplace.[Order]
    ( [OrderId] [int] NOT NULL,
      [CustomerId] [int] NOT NULL,
      [OrderDate] [datetime] NOT NULL,
      [Status] [nvarchar](20) NOT NULL,
      CONSTRAINT [PK_marketplace_Order]
          PRIMARY KEY CLUSTERED ( [OrderId] ASC )
          WITH ( PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF ) ON [PRIMARY] ) ON [PRIMARY];
GO

CREATE UNIQUE INDEX UKF_Order_CustomerId_Status
ON marketplace.[Order] ( [CustomerId], [Status] )
WHERE [Status] = 'OPEN';

ALTER TABLE marketplace.[Order]
ADD CONSTRAINT [FK_Order_Customer_CustomerId]
    FOREIGN KEY ( [CustomerId] )
    REFERENCES marketplace.Customer ( [CustomerId] );
GO

ALTER TABLE marketplace.[Order]
ADD CONSTRAINT [DF_marketplace_Order_OrderDate]
    DEFAULT ( GETUTCDATE()) FOR [OrderDate];
GO

ALTER TABLE marketplace.[Order]
ADD CONSTRAINT [CHK_marketplace_Order_Status] CHECK ( [Status] IN ('OPEN', 'CLOSE'));
GO

CREATE TABLE marketplace.OrderProduct
    ( [OrderId] [int] NOT NULL,
      [ProductId] [int] NOT NULL,
      [Qty] [int] NOT NULL,
      [UnitPrice] [money] NOT NULL,
      [TotalPrice] [money] NOT NULL,
      CONSTRAINT [PK_marketplace_OrderProduct]
          PRIMARY KEY CLUSTERED ( [OrderId] ASC, [ProductId] ASC )
          WITH ( PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF ) ON [PRIMARY] ) ON [PRIMARY];
GO

ALTER TABLE marketplace.[OrderProduct]
ADD CONSTRAINT [FK_OrderProduct_Order_OrderId]
    FOREIGN KEY ( [OrderId] )
    REFERENCES marketplace.[Order] ( [OrderId] );
GO

ALTER TABLE marketplace.[OrderProduct]
ADD CONSTRAINT [CHK_marketplace_OrderProduct_Qty] CHECK ( Qty > 0 );
GO

ALTER TABLE marketplace.[OrderProduct]
ADD CONSTRAINT [CHK_marketplace_OrderProduct_UnitPrice] CHECK ( UnitPrice > 0 );
GO

ALTER TABLE marketplace.[OrderProduct]
ADD CONSTRAINT [CHK_marketplace_OrderProduct_TotalPrice] CHECK ( TotalPrice > 0 );
GO

------------------------------------------------------------------------

DELETE marketplace.[OrderProduct];
DELETE marketplace.[Order];
DELETE marketplace.Customer;
DELETE marketplace.LocationDescription;
DELETE marketplace.Location;
GO

INSERT INTO marketplace.Location
    ( LocationId,
      LocationType,
      LocationName,
      ParentLocationId )
VALUES ( 1, N'Continent', N'America', NULL ),
       ( 2, N'Continent', N'Europe', NULL ),
       ( 3, N'Continent', N'Asia', NULL ),
       ( 4, N'Continent', N'Africa', NULL ),
       ( 5, N'Continent', N'Oceania', NULL ),
       ( 101, N'Country', N'United States', 1 ),
       ( 102, N'Country', N'Canada', 1 ),
       ( 103, N'Country', N'Mexico', 1 ),
       ( 104, N'Country', N'Colombia', 1 ),
       ( 201, N'Country', N'France', 2 ),
       ( 202, N'Country', N'Germany', 2 ),
       ( 203, N'Country', N'Spain', 2 ),
       ( 101001, N'City', N'Washington', 101 ),
       ( 101002, N'City', N'New York', 101 ),
       ( 102001, N'City', N'Ottawa', 102 ),
       ( 102002, N'City', N'Vancouver', 102 ),
       ( 103001, N'City', N'Mexico DF', 103 ),
       ( 104001, N'City', N'Bogota', 104 ),
       ( 202005, N'City', N'Cologne', 202 ),
       ( 201001, N'City', N'Paris', 201 ),
       ( 301001, N'City', N'Madrid', 203 ),
       ( 301002, N'City', N'Barcelona', 203 );

INSERT INTO marketplace.LocationDescription
    ( LocationId,
      Language,
      Description )
VALUES ( 2, N'ES', N'Europa' ),
       ( 101, N'ES', N'Estados Unidos' ),
       ( 201, N'ES', N'Francia' ),
       ( 202, N'ES', N'Alemania' ),
       ( 202, N'DE', N'Deutschland' ),
       ( 203, N'ES', N'España' ),
       ( 101002, N'ES', N'Nueva York' ),
       ( 104001, N'ES', N'Bogotá DC' ),
       ( 202005, N'DE', N'Köln' ),
       ( 202005, N'es', N'Colonia' );

INSERT INTO marketplace.Customer
    ( CustomerId,
      CustomerName,
      LocationId,
      Address )
VALUES ( 1, N'Tom Cruise', 101002, '1100 Main Street 248 PH98, Manhattan, NYC' ),
       ( 2, N'Kylian Mbappé', 201001, 'PL. Charles de Gaulle, 75008' ),
       ( 3, N'Shakira Mebarak', 301002, 'Ciudad Diagonal, Esplugas de Llobregat' ),
       ( 4, N'Maria', 104001, 'Av Trancón 123' ),
       ( 5, N'Thomas Müller', 202005, 'Domkloster 4, 50667 Köln' );

INSERT INTO marketplace.[Order]
    ( OrderId,
      CustomerId,
      OrderDate,
      Status )
VALUES ( 1, 1, '2023-01-15', N'CLOSE' ),
       ( 2, 3, '2023-01-20', N'CLOSE' ),
       ( 3, 1, '2023-01-30', N'CLOSE' ),
       ( 4, 1, DEFAULT, N'OPEN' ),
       ( 5, 2, DEFAULT, N'OPEN' ),
       ( 6, 5, DEFAULT, N'OPEN' ),
       ( 7, 4, DEFAULT, N'OPEN' );

INSERT INTO marketplace.[OrderProduct]
    ( [OrderId],
      [ProductId],
      [Qty],
      [UnitPrice],
      [TotalPrice] )
VALUES ( 1, 100, 3, 10, 30 ),
       ( 1, 66, 8, 10, 80 ),
       ( 1, 117, 7, 5, 35 ),
       ( 2, 132, 1, 14, 14 ),
       ( 3, 114, 4, 20, 80 ),
       ( 3, 66, 1, 10, 10 ),
       ( 4, 66, 2, 10, 20 ),
       ( 4, 132, 2, 14, 28 ),
       ( 5, 132, 5, 14, 70 ),
       ( 6, 132, 3, 14, 42 );
