﻿--upgrade scripts from nopCommerce 3.10 to 3.20

--new locale resources
declare @resources xml
--a resource will be delete if its value is empty
set @resources='
<Language>
  <LocaleResource Name="Admin.Orders.Shipments.List.Country">
    <Value>Country</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Orders.Shipments.List.Country.Hint">
    <Value>Search by a specific country.</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Orders.Shipments.List.StateProvince">
    <Value>State / province</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Orders.Shipments.List.StateProvince.Hint">
    <Value>Search by a specific state.</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Orders.Shipments.List.City">
    <Value>City</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Orders.Shipments.List.City.Hint">
    <Value>Search by a specific city.</Value>
  </LocaleResource>
  <LocaleResource Name="Media.Product.ImageLinkTitleFormat.Details">
    <Value>Picture of {0}</Value>
  </LocaleResource>
  <LocaleResource Name="Media.Product.ImageAlternateTextFormat.Details">
    <Value>Picture of {0}</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.SalesReport.Bestsellers.Category">
    <Value>Category</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.SalesReport.Bestsellers.Category.Hint">
    <Value>Search in a specific category.</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.SalesReport.Bestsellers.Manufacturer">
    <Value>Manufacturer</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.SalesReport.Bestsellers.Manufacturer.Hint">
    <Value>Search in a specific manufacturer.</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Catalog.Products.ProductVariantAttributes.Attributes.Values.Fields.Cost">
    <Value>Cost</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Catalog.Products.ProductVariantAttributes.Attributes.Values.Fields.Cost.Hint">
    <Value>The attribute value cost is the cost of all the different components which make up this value. This may either be the purchase price if the components are bought from outside suppliers, or the combined cost of materials and manufacturing processes if the component is made in-house.</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Orders.Fields.OrderStatus.Change">
    <Value>Change status</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Orders.Fields.OrderStatus.Change.ForAdvancedUsers">
    <Value>This option is only for advanced users (not recommended to change manually). All appropriate actions (such as invetory adjustment, sending notification emails, etc) should be also done manually in this case.</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Catalog.Products.Fields.PreOrderAvailabilityStartDateTimeUtc">
    <Value>Pre-order availability start date</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Catalog.Products.Fields.PreOrderAvailabilityStartDateTimeUtc.Hint">
    <Value>The availability start date of the product configured for pre-order in Coordinated Universal Time (UTC). ''Pre-order'' button will automatically be changed to ''Add to cart'' at the monent.</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Catalog.Products.PurchasedWithOrders">
    <Value>Purchased with orders</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Catalog.Products.PurchasedWithOrders.Hint">
    <Value>Here you can see a list of orders in which this product was purchased.</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Affiliates.Orders.Order">
    <Value>Order ID</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Catalog.Products.ProductVariantAttributes.AttributeCombinations.Fields.OverriddenPrice">
    <Value>Overridden price</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Catalog.Products.ProductVariantAttributes.AttributeCombinations.Fields.OverriddenPrice.Hint">
    <Value>Override price for this attribute combination. This way a store owner can override the default product price when this attribute combination is added to the cart. For example, you can give a discount this way. Leave empty to ignore field. All other applied discounts will be ignored when this field is specified.</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Configuration.Settings.ShoppingCart.AllowCartItemEditing">
    <Value>Allow cart item editing</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Configuration.Settings.ShoppingCart.AllowCartItemEditing.Hint">
    <Value>Check to allow customers to edit items already placed in the cart. It could be useful when your products have attributes or any other fields entered by a customer.</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Configuration.Settings.GeneralCommon.EnableJsBundling">
    <Value>JavaScript bundling and minification</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Configuration.Settings.GeneralCommon.EnableJsBundling.Hint">
    <Value>Enable to combine (bundle) multiple JavaScript files into a single file. Don''t do it if you''re running nopCommerce in web farms or Windows Azure.</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Configuration.Settings.GeneralCommon.EnableCssBundling">
    <Value>CSS bundling and minification</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Configuration.Settings.GeneralCommon.EnableCssBundling.Hint">
    <Value>Enable to combine (bundle) multiple CSS files into a single file. Don''t do it if you''re running nopCommerce in web farms or Windows Azure. It also doesn''t work in virtual IIS directories.</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Configuration.Shipping.DeliveryDates">
    <Value>Delivery dates</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Configuration.Shipping.DeliveryDates.AddNew">
    <Value>Add a new delivery date</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Configuration.Shipping.DeliveryDates.BackToList">
    <Value>back to delivery date list</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Configuration.Shipping.DeliveryDates.EditDeliveryDateDetails">
    <Value>Edit delivery date details</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Configuration.Shipping.DeliveryDates.Added">
    <Value>The new delivery date has been added successfully.</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Configuration.Shipping.DeliveryDates.Deleted">
    <Value>The delivery date has been deleted successfully.</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Configuration.Shipping.DeliveryDates.Updated">
    <Value>The delivery date has been updated successfully.</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Configuration.Shipping.DeliveryDates.Fields.Name">
    <Value>Name</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Configuration.Shipping.DeliveryDates.Fields.Name.Hint">
    <Value>Enter delivery date name.</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Configuration.Shipping.DeliveryDates.Fields.Name.Required">
    <Value>Please provide a name.</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Configuration.Shipping.DeliveryDates.Fields.DisplayOrder">
    <Value>Display order</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Configuration.Shipping.DeliveryDates.Fields.DisplayOrder.Hint">
    <Value>The display order of this delivery date. 1 represents the top of the list.</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Catalog.Products.Fields.DeliveryDate">
    <Value>Delivery date</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Catalog.Products.Fields.DeliveryDate.Hint">
    <Value>Choose a delivery date which will be displayed in the public store.</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Catalog.Products.Fields.DeliveryDate.None">
    <Value>None</Value>
  </LocaleResource>
  <LocaleResource Name="Products.DeliveryDate">
    <Value>Delivery date</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Orders.Report.Shipping">
    <Value>Shipping</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.System.ScheduleTasks.RunNow">
    <Value>Run now</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.System.ScheduleTasks.RunNow.Progress">
    <Value>Running the schedule task</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.System.ScheduleTasks.RunNow.Done">
    <Value>Schedule task was run</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Catalog.Products.ProductVariantAttributes.Attributes.Values.Fields.Quantity">
    <Value>Product quantity</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Catalog.Products.ProductVariantAttributes.Attributes.Values.Fields.Quantity.Hint">
    <Value>Specify quantity of the associated product which will be added. Minimum allowed value is 1.</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Catalog.Products.ProductVariantAttributes.Attributes.Values.Fields.Quantity.GreaterThanOrEqualTo1">
    <Value>Quantity should be greater than or equal to 1</Value>
  </LocaleResource>
  <LocaleResource Name="ShoppingCart.EstimateShipping.ShippingOptionWithRate">
    <Value>{0} ({1})</Value>
  </LocaleResource>
  <LocaleResource Name="ShoppingCart.Totals.Shipping.Method">
    <Value>({0})</Value>
  </LocaleResource>
  <LocaleResource Name="Checkout.SelectShippingMethod.MethodAndFee">
    <Value>{0} ({1})</Value>
  </LocaleResource>
  <LocaleResource Name="Categories.TotalProducts">
    <Value>({0})</Value>
  </LocaleResource>
  <LocaleResource Name="Checkout.SelectPaymentMethod.MethodAndFee">
    <Value>{0} ({1})</Value>
  </LocaleResource>
  <LocaleResource Name="Products.Tags.Count">
    <Value>({0})</Value>
  </LocaleResource>
  <LocaleResource Name="Plugins.Shipping.AustraliaPost.Fields.ShippedFromZipPostalCode">
    <Value></Value>
  </LocaleResource>
  <LocaleResource Name="Plugins.Shipping.AustraliaPost.Fields.ShippedFromZipPostalCode.Hint">
    <Value></Value>
  </LocaleResource>
  <LocaleResource Name="Plugins.Shipping.USPS.Fields.ZipPostalCodeFrom">
    <Value></Value>
  </LocaleResource>
  <LocaleResource Name="Plugins.Shipping.USPS.Fields.ZipPostalCodeFrom.Hint">
    <Value></Value>
  </LocaleResource>
  <LocaleResource Name="Plugins.Shipping.UPS.Fields.DefaultShippedFromCountry">
    <Value></Value>
  </LocaleResource>
  <LocaleResource Name="Plugins.Shipping.UPS.Fields.DefaultShippedFromCountry.Hint">
    <Value></Value>
  </LocaleResource>
  <LocaleResource Name="Plugins.Shipping.UPS.Fields.DefaultShippedFromZipPostalCode">
    <Value></Value>
  </LocaleResource>
  <LocaleResource Name="Plugins.Shipping.UPS.Fields.DefaultShippedFromZipPostalCode.Hint">
    <Value></Value>
  </LocaleResource>
  <LocaleResource Name="Plugins.Shipping.Fedex.Fields.Street">
    <Value></Value>
  </LocaleResource>
  <LocaleResource Name="Plugins.Shipping.Fedex.Fields.Street.Hint">
    <Value></Value>
  </LocaleResource>
  <LocaleResource Name="Plugins.Shipping.Fedex.Fields.City">
    <Value></Value>
  </LocaleResource>
  <LocaleResource Name="Plugins.Shipping.Fedex.Fields.City.Hint">
    <Value></Value>
  </LocaleResource>
  <LocaleResource Name="Plugins.Shipping.Fedex.Fields.StateOrProvinceCode">
    <Value></Value>
  </LocaleResource>
  <LocaleResource Name="Plugins.Shipping.Fedex.Fields.StateOrProvinceCode.Hint">
    <Value></Value>
  </LocaleResource>
  <LocaleResource Name="Plugins.Shipping.Fedex.Fields.PostalCode">
    <Value></Value>
  </LocaleResource>
  <LocaleResource Name="Plugins.Shipping.Fedex.Fields.PostalCode.Hint">
    <Value></Value>
  </LocaleResource>
  <LocaleResource Name="Plugins.Shipping.Fedex.Fields.CountryCode">
    <Value></Value>
  </LocaleResource>
  <LocaleResource Name="Plugins.Shipping.Fedex.Fields.CountryCode.Hint">
    <Value></Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Configuration.Shipping.Warehouses">
    <Value>Warehouses</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Configuration.Shipping.Warehouses.AddNew">
    <Value>Add a new warehouse</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Configuration.Shipping.Warehouses.BackToList">
    <Value>back to warehouse list</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Configuration.Shipping.Warehouses.EditWarehouseDetails">
    <Value>Edit warehouse details</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Configuration.Shipping.Warehouses.Added">
    <Value>The new warehouse has been added successfully.</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Configuration.Shipping.Warehouses.Deleted">
    <Value>The warehouse has been deleted successfully.</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Configuration.Shipping.Warehouses.Updated">
    <Value>The warehouse has been updated successfully.</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Configuration.Shipping.Warehouses.Fields.Name">
    <Value>Name</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Configuration.Shipping.Warehouses.Fields.Name.Hint">
    <Value>Enter a warehouse name.</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Configuration.Shipping.Warehouses.Fields.Name.Required">
    <Value>Please provide a name.</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Configuration.Shipping.Warehouses.Fields.Address">
    <Value>Address</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Catalog.Products.Fields.Warehouse">
    <Value>Warehouse</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Catalog.Products.Fields.Warehouse.Hint">
    <Value>Choose a warehouse which will be used when calculating shipping rates.</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Catalog.Products.Fields.Warehouse.None">
    <Value>None</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Configuration.Settings.Shipping.UseWarehouseLocation">
    <Value>Use warehouse location</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Configuration.Settings.Shipping.UseWarehouseLocation.Hint">
    <Value>Check to use warehouse location when requesting shipping rates. This is useful when you ship from multiple warehouses.</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Catalog.Products.List.SearchWarehouse">
    <Value>Warehouse</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Catalog.Products.List.SearchWarehouse.Hint">
    <Value>Search by a specific warehouse.</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Configuration.Settings.Tax.EuVatAssumeValid">
    <Value>Assume VAT always valid</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Configuration.Settings.Tax.EuVatAssumeValid.Hint">
    <Value>Check to skip VAT validation. Enter VAT nubmers will always be valid. It will be a client responsibility to provide the correct VAT nubmer.</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Configuration.Settings.GeneralCommon.LoadAllLocaleRecordsOnStartup">
    <Value>Load all locale resources on startup</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Configuration.Settings.GeneralCommon.LoadAllLocalizedPropertiesOnStartup.Hint">
    <Value>When enabled, all locale resources will be loaded on application startup. The application start will be slower, but then all pages could be opened much faster.</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Configuration.Settings.GeneralCommon.LoadAllLocalizedPropertiesOnStartup">
    <Value>Load all localized properties on startup</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Configuration.Settings.GeneralCommon.LoadAllLocalizedPropertiesOnStartup.Hint">
    <Value>When enabled, all localized properties (such as localized product properties) will be loaded on application startup. The application start will be slower, but then all pages could be opened much faster. It''s used only when you have two or more languages enabled. Not recommended to enable when you a large catalog (several thousand localized entities).</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Configuration.Settings.GeneralCommon.LoadAllUrlRecordsOnStartup">
    <Value>Load all search engine friendly names on startup</Value>
  </LocaleResource>
  <LocaleResource Name="Admin.Configuration.Settings.GeneralCommon.LoadAllUrlRecordsOnStartup.Hint">
    <Value>When enabled, all slugs (search engine friendly names) will be loaded on application startup. The application start will be slower, but then all pages could be opened much faster. Not recommended to enable when you a large catalog (several thousand entities).</Value>
  </LocaleResource>
</Language>
'

CREATE TABLE #LocaleStringResourceTmp
	(
		[ResourceName] [nvarchar](200) NOT NULL,
		[ResourceValue] [nvarchar](max) NOT NULL
	)

INSERT INTO #LocaleStringResourceTmp (ResourceName, ResourceValue)
SELECT	nref.value('@Name', 'nvarchar(200)'), nref.value('Value[1]', 'nvarchar(MAX)')
FROM	@resources.nodes('//Language/LocaleResource') AS R(nref)

--do it for each existing language
DECLARE @ExistingLanguageID int
DECLARE cur_existinglanguage CURSOR FOR
SELECT [ID]
FROM [Language]
OPEN cur_existinglanguage
FETCH NEXT FROM cur_existinglanguage INTO @ExistingLanguageID
WHILE @@FETCH_STATUS = 0
BEGIN
	DECLARE @ResourceName nvarchar(200)
	DECLARE @ResourceValue nvarchar(MAX)
	DECLARE cur_localeresource CURSOR FOR
	SELECT ResourceName, ResourceValue
	FROM #LocaleStringResourceTmp
	OPEN cur_localeresource
	FETCH NEXT FROM cur_localeresource INTO @ResourceName, @ResourceValue
	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF (EXISTS (SELECT 1 FROM [LocaleStringResource] WHERE LanguageID=@ExistingLanguageID AND ResourceName=@ResourceName))
		BEGIN
			UPDATE [LocaleStringResource]
			SET [ResourceValue]=@ResourceValue
			WHERE LanguageID=@ExistingLanguageID AND ResourceName=@ResourceName
		END
		ELSE 
		BEGIN
			INSERT INTO [LocaleStringResource]
			(
				[LanguageId],
				[ResourceName],
				[ResourceValue]
			)
			VALUES
			(
				@ExistingLanguageID,
				@ResourceName,
				@ResourceValue
			)
		END
		
		IF (@ResourceValue is null or @ResourceValue = '')
		BEGIN
			DELETE [LocaleStringResource]
			WHERE LanguageID=@ExistingLanguageID AND ResourceName=@ResourceName
		END
		
		FETCH NEXT FROM cur_localeresource INTO @ResourceName, @ResourceValue
	END
	CLOSE cur_localeresource
	DEALLOCATE cur_localeresource


	--fetch next language identifier
	FETCH NEXT FROM cur_existinglanguage INTO @ExistingLanguageID
END
CLOSE cur_existinglanguage
DEALLOCATE cur_existinglanguage

DROP TABLE #LocaleStringResourceTmp
GO


--Add a reference for [StoreMapping] table
--but first, delete abandoned records
DELETE FROM [StoreMapping]
WHERE [StoreId] NOT IN (SELECT [Id] FROM [Store])
GO

IF NOT EXISTS (SELECT 1
           FROM   sys.objects
           WHERE  name = 'StoreMapping_Store'
           AND parent_object_id = Object_id('StoreMapping')
           AND Objectproperty(object_id,N'IsForeignKey') = 1)
BEGIN
	ALTER TABLE [dbo].[StoreMapping]  WITH CHECK ADD  CONSTRAINT [StoreMapping_Store] FOREIGN KEY([StoreId])
	REFERENCES [dbo].[Store] ([Id])
	ON DELETE CASCADE
END
GO


--Add a reference for [AclRecord] table
--but first, delete abandoned records
DELETE FROM [AclRecord]
WHERE [CustomerRoleId] NOT IN (SELECT [Id] FROM [CustomerRole])
GO

IF NOT EXISTS (SELECT 1
           FROM   sys.objects
           WHERE  name = 'AclRecord_CustomerRole'
           AND parent_object_id = Object_id('AclRecord')
           AND Objectproperty(object_id,N'IsForeignKey') = 1)
BEGIN
	ALTER TABLE [dbo].[AclRecord]  WITH CHECK ADD  CONSTRAINT [AclRecord_CustomerRole] FOREIGN KEY([CustomerRoleId])
	REFERENCES [dbo].[CustomerRole] ([Id])
	ON DELETE CASCADE
END
GO

DELETE FROM [dbo].[PermissionRecord]
WHERE [SystemName] = N'ManageCustomerRoles'
GO


--add a new column
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id=object_id('[ProductVariantAttributeValue]') and NAME='Cost')
BEGIN
	ALTER TABLE [ProductVariantAttributeValue]
	ADD [Cost] [decimal](18, 4) NULL
END
GO

UPDATE [ProductVariantAttributeValue]
SET [Cost] = 0
WHERE [Cost] IS NULL
GO

ALTER TABLE [ProductVariantAttributeValue] ALTER COLUMN [Cost] [decimal](18, 4) NOT NULL
GO


--add a new column
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id=object_id('[Product]') and NAME='PreOrderAvailabilityStartDateTimeUtc')
BEGIN
	ALTER TABLE [Product]
	ADD [PreOrderAvailabilityStartDateTimeUtc] datetime NULL
END
GO


--add a new column
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id=object_id('[ProductVariantAttributeCombination]') and NAME='OverriddenPrice')
BEGIN
	ALTER TABLE [ProductVariantAttributeCombination]
	ADD [OverriddenPrice] decimal(18,4) NULL
END
GO

--a new setting
IF NOT EXISTS (SELECT 1 FROM [Setting] WHERE [name] = N'shoppingcartsettings.allowcartitemediting')
BEGIN
	INSERT [Setting] ([Name], [Value], [StoreId])
	VALUES (N'shoppingcartsettings.allowcartitemediting', N'true', 0)
END
GO

--a new setting
IF NOT EXISTS (SELECT 1 FROM [Setting] WHERE [name] = N'seosettings.enablecssbundling')
BEGIN
	INSERT [Setting] ([Name], [Value], [StoreId])
	VALUES (N'seosettings.enablecssbundling', N'false', 0)
END
GO


--delivery dates
IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[DeliveryDate]') and OBJECTPROPERTY(object_id, N'IsUserTable') = 1)
BEGIN
	CREATE TABLE [dbo].[DeliveryDate](
		[Id] [int] IDENTITY(1,1) NOT NULL,
		[Name] nvarchar(400) NOT NULL,
		[DisplayOrder] int NOT NULL,
	PRIMARY KEY CLUSTERED 
	(
		[Id] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON)
	)

	--create several sample options
	INSERT INTO [DeliveryDate] ([Name], [DisplayOrder])
	VALUES (N'1-2 days', 1)
	
	INSERT INTO [DeliveryDate] ([Name], [DisplayOrder])
	VALUES (N'3-5 days', 5)
	
	INSERT INTO [DeliveryDate] ([Name], [DisplayOrder])
	VALUES (N'1 week', 10)
END
GO


--add a new column
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id=object_id('[Product]') and NAME='DeliveryDateId')
BEGIN
	ALTER TABLE [Product]
	ADD [DeliveryDateId] int NULL
END
GO

UPDATE [Product]
SET [DeliveryDateId] = 0
WHERE [DeliveryDateId] IS NULL
GO

ALTER TABLE [Product] ALTER COLUMN [DeliveryDateId] int NOT NULL
GO




--add a new column
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id=object_id('[ProductVariantAttributeValue]') and NAME='Quantity')
BEGIN
	ALTER TABLE [ProductVariantAttributeValue]
	ADD [Quantity] int NULL
END
GO

UPDATE [ProductVariantAttributeValue]
SET [Quantity] = 1
WHERE [Quantity] IS NULL
GO

ALTER TABLE [ProductVariantAttributeValue] ALTER COLUMN [Quantity] int NOT NULL
GO
--a new setting
IF NOT EXISTS (SELECT 1 FROM [Setting] WHERE [name] = N'shoppingcartsettings.renderassociatedattributevaluequantity')
BEGIN
	INSERT [Setting] ([Name], [Value], [StoreId])
	VALUES (N'shoppingcartsettings.renderassociatedattributevaluequantity', N'false', 0)
END
GO

--obsolete settings
DELETE FROM [Setting] WHERE [Name] = N'AustraliaPostSettings.ShippedFromZipPostalCode'
GO

DELETE FROM [Setting] WHERE [Name] = N'USPSSettings.ZipPostalCodeFrom'
GO

DELETE FROM [Setting] WHERE [Name] = N'UPSSettings.DefaultShippedFromCountryId'
GO

DELETE FROM [Setting] WHERE [Name] = N'UPSSettings.DefaultShippedFromZipPostalCode'
GO

DELETE FROM [Setting] WHERE [Name] = N'FedexSettings.Street'
GO

DELETE FROM [Setting] WHERE [Name] = N'FedexSettings.City'
GO

DELETE FROM [Setting] WHERE [Name] = N'FedexSettings.StateOrProvinceCode'
GO

DELETE FROM [Setting] WHERE [Name] = N'FedexSettings.PostalCode'
GO

DELETE FROM [Setting] WHERE [Name] = N'FedexSettings.CountryCode'
GO


--warehouses
IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[Warehouse]') and OBJECTPROPERTY(object_id, N'IsUserTable') = 1)
BEGIN
	CREATE TABLE [dbo].[Warehouse](
		[Id] [int] IDENTITY(1,1) NOT NULL,
		[Name] nvarchar(400) NOT NULL,
		[AddressId] int NOT NULL,
	PRIMARY KEY CLUSTERED 
	(
		[Id] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON)
	)
END
GO

--add a new column
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id=object_id('[Product]') and NAME='WarehouseId')
BEGIN
	ALTER TABLE [Product]
	ADD [WarehouseId] int NULL
END
GO

UPDATE [Product]
SET [WarehouseId] = 0
WHERE [WarehouseId] IS NULL
GO

ALTER TABLE [Product] ALTER COLUMN [WarehouseId] int NOT NULL
GO

--a new setting
IF NOT EXISTS (SELECT 1 FROM [Setting] WHERE [name] = N'shippingsettings.usewarehouselocation')
BEGIN
	INSERT [Setting] ([Name], [Value], [StoreId])
	VALUES (N'shippingsettings.usewarehouselocation', N'false', 0)
END
GO

--search by warehouse
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[ProductLoadAllPaged]') AND OBJECTPROPERTY(object_id,N'IsProcedure') = 1)
DROP PROCEDURE [ProductLoadAllPaged]
GO
CREATE PROCEDURE [dbo].[ProductLoadAllPaged]
(
	@CategoryIds		nvarchar(MAX) = null,	--a list of category IDs (comma-separated list). e.g. 1,2,3
	@ManufacturerId		int = 0,
	@StoreId			int = 0,
	@VendorId			int = 0,
	@WarehouseId		int = 0,
	@ParentGroupedProductId	int = 0,
	@ProductTypeId		int = null, --product type identifier, null - load all products
	@VisibleIndividuallyOnly bit = 0, 	--0 - load all products , 1 - "visible indivially" only
	@ProductTagId		int = 0,
	@FeaturedProducts	bit = null,	--0 featured only , 1 not featured only, null - load all products
	@PriceMin			decimal(18, 4) = null,
	@PriceMax			decimal(18, 4) = null,
	@Keywords			nvarchar(4000) = null,
	@SearchDescriptions bit = 0, --a value indicating whether to search by a specified "keyword" in product descriptions
	@SearchSku			bit = 0, --a value indicating whether to search by a specified "keyword" in product SKU
	@SearchProductTags  bit = 0, --a value indicating whether to search by a specified "keyword" in product tags
	@UseFullTextSearch  bit = 0,
	@FullTextMode		int = 0, --0 - using CONTAINS with <prefix_term>, 5 - using CONTAINS and OR with <prefix_term>, 10 - using CONTAINS and AND with <prefix_term>
	@FilteredSpecs		nvarchar(MAX) = null,	--filter by attributes (comma-separated list). e.g. 14,15,16
	@LanguageId			int = 0,
	@OrderBy			int = 0, --0 - position, 5 - Name: A to Z, 6 - Name: Z to A, 10 - Price: Low to High, 11 - Price: High to Low, 15 - creation date
	@AllowedCustomerRoleIds	nvarchar(MAX) = null,	--a list of customer role IDs (comma-separated list) for which a product should be shown (if a subjet to ACL)
	@PageIndex			int = 0, 
	@PageSize			int = 2147483644,
	@ShowHidden			bit = 0,
	@LoadFilterableSpecificationAttributeOptionIds bit = 0, --a value indicating whether we should load the specification attribute option identifiers applied to loaded products (all pages)
	@FilterableSpecificationAttributeOptionIds nvarchar(MAX) = null OUTPUT, --the specification attribute option identifiers applied to loaded products (all pages). returned as a comma separated list of identifiers
	@TotalRecords		int = null OUTPUT
)
AS
BEGIN
	
	/* Products that filtered by keywords */
	CREATE TABLE #KeywordProducts
	(
		[ProductId] int NOT NULL
	)

	DECLARE
		@SearchKeywords bit,
		@sql nvarchar(max),
		@sql_orderby nvarchar(max)

	SET NOCOUNT ON
	
	--filter by keywords
	SET @Keywords = isnull(@Keywords, '')
	SET @Keywords = rtrim(ltrim(@Keywords))
	IF ISNULL(@Keywords, '') != ''
	BEGIN
		SET @SearchKeywords = 1
		
		IF @UseFullTextSearch = 1
		BEGIN
			--remove wrong chars (' ")
			SET @Keywords = REPLACE(@Keywords, '''', '')
			SET @Keywords = REPLACE(@Keywords, '"', '')
			
			--full-text search
			IF @FullTextMode = 0 
			BEGIN
				--0 - using CONTAINS with <prefix_term>
				SET @Keywords = ' "' + @Keywords + '*" '
			END
			ELSE
			BEGIN
				--5 - using CONTAINS and OR with <prefix_term>
				--10 - using CONTAINS and AND with <prefix_term>

				--clean multiple spaces
				WHILE CHARINDEX('  ', @Keywords) > 0 
					SET @Keywords = REPLACE(@Keywords, '  ', ' ')

				DECLARE @concat_term nvarchar(100)				
				IF @FullTextMode = 5 --5 - using CONTAINS and OR with <prefix_term>
				BEGIN
					SET @concat_term = 'OR'
				END 
				IF @FullTextMode = 10 --10 - using CONTAINS and AND with <prefix_term>
				BEGIN
					SET @concat_term = 'AND'
				END

				--now let's build search string
				declare @fulltext_keywords nvarchar(4000)
				set @fulltext_keywords = N''
				declare @index int		
		
				set @index = CHARINDEX(' ', @Keywords, 0)

				-- if index = 0, then only one field was passed
				IF(@index = 0)
					set @fulltext_keywords = ' "' + @Keywords + '*" '
				ELSE
				BEGIN		
					DECLARE @first BIT
					SET  @first = 1			
					WHILE @index > 0
					BEGIN
						IF (@first = 0)
							SET @fulltext_keywords = @fulltext_keywords + ' ' + @concat_term + ' '
						ELSE
							SET @first = 0

						SET @fulltext_keywords = @fulltext_keywords + '"' + SUBSTRING(@Keywords, 1, @index - 1) + '*"'					
						SET @Keywords = SUBSTRING(@Keywords, @index + 1, LEN(@Keywords) - @index)						
						SET @index = CHARINDEX(' ', @Keywords, 0)
					end
					
					-- add the last field
					IF LEN(@fulltext_keywords) > 0
						SET @fulltext_keywords = @fulltext_keywords + ' ' + @concat_term + ' ' + '"' + SUBSTRING(@Keywords, 1, LEN(@Keywords)) + '*"'	
				END
				SET @Keywords = @fulltext_keywords
			END
		END
		ELSE
		BEGIN
			--usual search by PATINDEX
			SET @Keywords = '%' + @Keywords + '%'
		END
		--PRINT @Keywords

		--product name
		SET @sql = '
		INSERT INTO #KeywordProducts ([ProductId])
		SELECT p.Id
		FROM Product p with (NOLOCK)
		WHERE '
		IF @UseFullTextSearch = 1
			SET @sql = @sql + 'CONTAINS(p.[Name], @Keywords) '
		ELSE
			SET @sql = @sql + 'PATINDEX(@Keywords, p.[Name]) > 0 '


		--localized product name
		SET @sql = @sql + '
		UNION
		SELECT lp.EntityId
		FROM LocalizedProperty lp with (NOLOCK)
		WHERE
			lp.LocaleKeyGroup = N''Product''
			AND lp.LanguageId = ' + ISNULL(CAST(@LanguageId AS nvarchar(max)), '0') + '
			AND lp.LocaleKey = N''Name'''
		IF @UseFullTextSearch = 1
			SET @sql = @sql + ' AND CONTAINS(lp.[LocaleValue], @Keywords) '
		ELSE
			SET @sql = @sql + ' AND PATINDEX(@Keywords, lp.[LocaleValue]) > 0 '
	

		IF @SearchDescriptions = 1
		BEGIN
			--product short description
			SET @sql = @sql + '
			UNION
			SELECT p.Id
			FROM Product p with (NOLOCK)
			WHERE '
			IF @UseFullTextSearch = 1
				SET @sql = @sql + 'CONTAINS(p.[ShortDescription], @Keywords) '
			ELSE
				SET @sql = @sql + 'PATINDEX(@Keywords, p.[ShortDescription]) > 0 '


			--product full description
			SET @sql = @sql + '
			UNION
			SELECT p.Id
			FROM Product p with (NOLOCK)
			WHERE '
			IF @UseFullTextSearch = 1
				SET @sql = @sql + 'CONTAINS(p.[FullDescription], @Keywords) '
			ELSE
				SET @sql = @sql + 'PATINDEX(@Keywords, p.[FullDescription]) > 0 '



			--localized product short description
			SET @sql = @sql + '
			UNION
			SELECT lp.EntityId
			FROM LocalizedProperty lp with (NOLOCK)
			WHERE
				lp.LocaleKeyGroup = N''Product''
				AND lp.LanguageId = ' + ISNULL(CAST(@LanguageId AS nvarchar(max)), '0') + '
				AND lp.LocaleKey = N''ShortDescription'''
			IF @UseFullTextSearch = 1
				SET @sql = @sql + ' AND CONTAINS(lp.[LocaleValue], @Keywords) '
			ELSE
				SET @sql = @sql + ' AND PATINDEX(@Keywords, lp.[LocaleValue]) > 0 '
				

			--localized product full description
			SET @sql = @sql + '
			UNION
			SELECT lp.EntityId
			FROM LocalizedProperty lp with (NOLOCK)
			WHERE
				lp.LocaleKeyGroup = N''Product''
				AND lp.LanguageId = ' + ISNULL(CAST(@LanguageId AS nvarchar(max)), '0') + '
				AND lp.LocaleKey = N''FullDescription'''
			IF @UseFullTextSearch = 1
				SET @sql = @sql + ' AND CONTAINS(lp.[LocaleValue], @Keywords) '
			ELSE
				SET @sql = @sql + ' AND PATINDEX(@Keywords, lp.[LocaleValue]) > 0 '
		END

		--SKU
		IF @SearchSku = 1
		BEGIN
			SET @sql = @sql + '
			UNION
			SELECT p.Id
			FROM Product p with (NOLOCK)
			WHERE '
			IF @UseFullTextSearch = 1
				SET @sql = @sql + 'CONTAINS(p.[Sku], @Keywords) '
			ELSE
				SET @sql = @sql + 'PATINDEX(@Keywords, p.[Sku]) > 0 '
		END

		IF @SearchProductTags = 1
		BEGIN
			--product tag
			SET @sql = @sql + '
			UNION
			SELECT pptm.Product_Id
			FROM Product_ProductTag_Mapping pptm with(NOLOCK) INNER JOIN ProductTag pt with(NOLOCK) ON pt.Id = pptm.ProductTag_Id
			WHERE '
			IF @UseFullTextSearch = 1
				SET @sql = @sql + 'CONTAINS(pt.[Name], @Keywords) '
			ELSE
				SET @sql = @sql + 'PATINDEX(@Keywords, pt.[Name]) > 0 '

			--localized product tag
			SET @sql = @sql + '
			UNION
			SELECT pptm.Product_Id
			FROM LocalizedProperty lp with (NOLOCK) INNER JOIN Product_ProductTag_Mapping pptm with(NOLOCK) ON lp.EntityId = pptm.ProductTag_Id
			WHERE
				lp.LocaleKeyGroup = N''ProductTag''
				AND lp.LanguageId = ' + ISNULL(CAST(@LanguageId AS nvarchar(max)), '0') + '
				AND lp.LocaleKey = N''Name'''
			IF @UseFullTextSearch = 1
				SET @sql = @sql + ' AND CONTAINS(lp.[LocaleValue], @Keywords) '
			ELSE
				SET @sql = @sql + ' AND PATINDEX(@Keywords, lp.[LocaleValue]) > 0 '
		END

		--PRINT (@sql)
		EXEC sp_executesql @sql, N'@Keywords nvarchar(4000)', @Keywords

	END
	ELSE
	BEGIN
		SET @SearchKeywords = 0
	END

	--filter by category IDs
	SET @CategoryIds = isnull(@CategoryIds, '')	
	CREATE TABLE #FilteredCategoryIds
	(
		CategoryId int not null
	)
	INSERT INTO #FilteredCategoryIds (CategoryId)
	SELECT CAST(data as int) FROM [nop_splitstring_to_table](@CategoryIds, ',')	
	DECLARE @CategoryIdsCount int	
	SET @CategoryIdsCount = (SELECT COUNT(1) FROM #FilteredCategoryIds)

	--filter by attributes
	SET @FilteredSpecs = isnull(@FilteredSpecs, '')	
	CREATE TABLE #FilteredSpecs
	(
		SpecificationAttributeOptionId int not null
	)
	INSERT INTO #FilteredSpecs (SpecificationAttributeOptionId)
	SELECT CAST(data as int) FROM [nop_splitstring_to_table](@FilteredSpecs, ',')
	DECLARE @SpecAttributesCount int	
	SET @SpecAttributesCount = (SELECT COUNT(1) FROM #FilteredSpecs)

	--filter by customer role IDs (access control list)
	SET @AllowedCustomerRoleIds = isnull(@AllowedCustomerRoleIds, '')	
	CREATE TABLE #FilteredCustomerRoleIds
	(
		CustomerRoleId int not null
	)
	INSERT INTO #FilteredCustomerRoleIds (CustomerRoleId)
	SELECT CAST(data as int) FROM [nop_splitstring_to_table](@AllowedCustomerRoleIds, ',')
	
	--paging
	DECLARE @PageLowerBound int
	DECLARE @PageUpperBound int
	DECLARE @RowsToReturn int
	SET @RowsToReturn = @PageSize * (@PageIndex + 1)	
	SET @PageLowerBound = @PageSize * @PageIndex
	SET @PageUpperBound = @PageLowerBound + @PageSize + 1
	
	CREATE TABLE #DisplayOrderTmp 
	(
		[Id] int IDENTITY (1, 1) NOT NULL,
		[ProductId] int NOT NULL
	)

	SET @sql = '
	INSERT INTO #DisplayOrderTmp ([ProductId])
	SELECT p.Id
	FROM
		Product p with (NOLOCK)'
	
	IF @CategoryIdsCount > 0
	BEGIN
		SET @sql = @sql + '
		LEFT JOIN Product_Category_Mapping pcm with (NOLOCK)
			ON p.Id = pcm.ProductId'
	END
	
	IF @ManufacturerId > 0
	BEGIN
		SET @sql = @sql + '
		LEFT JOIN Product_Manufacturer_Mapping pmm with (NOLOCK)
			ON p.Id = pmm.ProductId'
	END
	
	IF ISNULL(@ProductTagId, 0) != 0
	BEGIN
		SET @sql = @sql + '
		LEFT JOIN Product_ProductTag_Mapping pptm with (NOLOCK)
			ON p.Id = pptm.Product_Id'
	END
	
	--searching by keywords
	IF @SearchKeywords = 1
	BEGIN
		SET @sql = @sql + '
		JOIN #KeywordProducts kp
			ON  p.Id = kp.ProductId'
	END
	
	SET @sql = @sql + '
	WHERE
		p.Deleted = 0'
	
	--filter by category
	IF @CategoryIdsCount > 0
	BEGIN
		SET @sql = @sql + '
		AND pcm.CategoryId IN (SELECT CategoryId FROM #FilteredCategoryIds)'
		
		IF @FeaturedProducts IS NOT NULL
		BEGIN
			SET @sql = @sql + '
		AND pcm.IsFeaturedProduct = ' + CAST(@FeaturedProducts AS nvarchar(max))
		END
	END
	
	--filter by manufacturer
	IF @ManufacturerId > 0
	BEGIN
		SET @sql = @sql + '
		AND pmm.ManufacturerId = ' + CAST(@ManufacturerId AS nvarchar(max))
		
		IF @FeaturedProducts IS NOT NULL
		BEGIN
			SET @sql = @sql + '
		AND pmm.IsFeaturedProduct = ' + CAST(@FeaturedProducts AS nvarchar(max))
		END
	END
	
	--filter by vendor
	IF @VendorId > 0
	BEGIN
		SET @sql = @sql + '
		AND p.VendorId = ' + CAST(@VendorId AS nvarchar(max))
	END
	
	--filter by warehouse
	IF @WarehouseId > 0
	BEGIN
		SET @sql = @sql + '
		AND p.WarehouseId = ' + CAST(@WarehouseId AS nvarchar(max))
	END
	
	--filter by parent grouped product identifer
	IF @ParentGroupedProductId > 0
	BEGIN
		SET @sql = @sql + '
		AND p.ParentGroupedProductId = ' + CAST(@ParentGroupedProductId AS nvarchar(max))
	END
	
	--filter by product type
	IF @ProductTypeId is not null
	BEGIN
		SET @sql = @sql + '
		AND p.ProductTypeId = ' + CAST(@ProductTypeId AS nvarchar(max))
	END
	
	--filter by parent product identifer
	IF @VisibleIndividuallyOnly = 1
	BEGIN
		SET @sql = @sql + '
		AND p.VisibleIndividually = 1'
	END
	
	--filter by product tag
	IF ISNULL(@ProductTagId, 0) != 0
	BEGIN
		SET @sql = @sql + '
		AND pptm.ProductTag_Id = ' + CAST(@ProductTagId AS nvarchar(max))
	END
	
	--show hidden
	IF @ShowHidden = 0
	BEGIN
		SET @sql = @sql + '
		AND p.Published = 1
		AND p.Deleted = 0
		AND (getutcdate() BETWEEN ISNULL(p.AvailableStartDateTimeUtc, ''1/1/1900'') and ISNULL(p.AvailableEndDateTimeUtc, ''1/1/2999''))'
	END
	
	--min price
	IF @PriceMin > 0
	BEGIN
		SET @sql = @sql + '
		AND (
				(
					--special price (specified price and valid date range)
					(p.SpecialPrice IS NOT NULL AND (getutcdate() BETWEEN isnull(p.SpecialPriceStartDateTimeUtc, ''1/1/1900'') AND isnull(p.SpecialPriceEndDateTimeUtc, ''1/1/2999'')))
					AND
					(p.SpecialPrice >= ' + CAST(@PriceMin AS nvarchar(max)) + ')
				)
				OR 
				(
					--regular price (price isnt specified or date range isnt valid)
					(p.SpecialPrice IS NULL OR (getutcdate() NOT BETWEEN isnull(p.SpecialPriceStartDateTimeUtc, ''1/1/1900'') AND isnull(p.SpecialPriceEndDateTimeUtc, ''1/1/2999'')))
					AND
					(p.Price >= ' + CAST(@PriceMin AS nvarchar(max)) + ')
				)
			)'
	END
	
	--max price
	IF @PriceMax > 0
	BEGIN
		SET @sql = @sql + '
		AND (
				(
					--special price (specified price and valid date range)
					(p.SpecialPrice IS NOT NULL AND (getutcdate() BETWEEN isnull(p.SpecialPriceStartDateTimeUtc, ''1/1/1900'') AND isnull(p.SpecialPriceEndDateTimeUtc, ''1/1/2999'')))
					AND
					(p.SpecialPrice <= ' + CAST(@PriceMax AS nvarchar(max)) + ')
				)
				OR 
				(
					--regular price (price isnt specified or date range isnt valid)
					(p.SpecialPrice IS NULL OR (getutcdate() NOT BETWEEN isnull(p.SpecialPriceStartDateTimeUtc, ''1/1/1900'') AND isnull(p.SpecialPriceEndDateTimeUtc, ''1/1/2999'')))
					AND
					(p.Price <= ' + CAST(@PriceMax AS nvarchar(max)) + ')
				)
			)'
	END
	
	--show hidden and ACL
	IF @ShowHidden = 0
	BEGIN
		SET @sql = @sql + '
		AND (p.SubjectToAcl = 0 OR EXISTS (
			SELECT 1 FROM #FilteredCustomerRoleIds [fcr]
			WHERE
				[fcr].CustomerRoleId IN (
					SELECT [acl].CustomerRoleId
					FROM [AclRecord] acl with (NOLOCK)
					WHERE [acl].EntityId = p.Id AND [acl].EntityName = ''Product''
				)
			))'
	END
	
	--show hidden and filter by store
	IF @StoreId > 0
	BEGIN
		SET @sql = @sql + '
		AND (p.LimitedToStores = 0 OR EXISTS (
			SELECT 1 FROM [StoreMapping] sm with (NOLOCK)
			WHERE [sm].EntityId = p.Id AND [sm].EntityName = ''Product'' and [sm].StoreId=' + CAST(@StoreId AS nvarchar(max)) + '
			))'
	END
	
	--filter by specs
	IF @SpecAttributesCount > 0
	BEGIN
		SET @sql = @sql + '
		AND NOT EXISTS (
			SELECT 1 FROM #FilteredSpecs [fs]
			WHERE
				[fs].SpecificationAttributeOptionId NOT IN (
					SELECT psam.SpecificationAttributeOptionId
					FROM Product_SpecificationAttribute_Mapping psam with (NOLOCK)
					WHERE psam.AllowFiltering = 1 AND psam.ProductId = p.Id
				)
			)'
	END
	
	--sorting
	SET @sql_orderby = ''	
	IF @OrderBy = 5 /* Name: A to Z */
		SET @sql_orderby = ' p.[Name] ASC'
	ELSE IF @OrderBy = 6 /* Name: Z to A */
		SET @sql_orderby = ' p.[Name] DESC'
	ELSE IF @OrderBy = 10 /* Price: Low to High */
		SET @sql_orderby = ' p.[Price] ASC'
	ELSE IF @OrderBy = 11 /* Price: High to Low */
		SET @sql_orderby = ' p.[Price] DESC'
	ELSE IF @OrderBy = 15 /* creation date */
		SET @sql_orderby = ' p.[CreatedOnUtc] DESC'
	ELSE /* default sorting, 0 (position) */
	BEGIN
		--category position (display order)
		IF @CategoryIdsCount > 0 SET @sql_orderby = ' pcm.DisplayOrder ASC'
		
		--manufacturer position (display order)
		IF @ManufacturerId > 0
		BEGIN
			IF LEN(@sql_orderby) > 0 SET @sql_orderby = @sql_orderby + ', '
			SET @sql_orderby = @sql_orderby + ' pmm.DisplayOrder ASC'
		END
		
		--parent grouped product specified (sort associated products)
		IF @ParentGroupedProductId > 0
		BEGIN
			IF LEN(@sql_orderby) > 0 SET @sql_orderby = @sql_orderby + ', '
			SET @sql_orderby = @sql_orderby + ' p.[DisplayOrder] ASC'
		END
		
		--name
		IF LEN(@sql_orderby) > 0 SET @sql_orderby = @sql_orderby + ', '
		SET @sql_orderby = @sql_orderby + ' p.[Name] ASC'
	END
	
	SET @sql = @sql + '
	ORDER BY' + @sql_orderby
	
	--PRINT (@sql)
	EXEC sp_executesql @sql

	DROP TABLE #FilteredCategoryIds
	DROP TABLE #FilteredSpecs
	DROP TABLE #FilteredCustomerRoleIds
	DROP TABLE #KeywordProducts

	CREATE TABLE #PageIndex 
	(
		[IndexId] int IDENTITY (1, 1) NOT NULL,
		[ProductId] int NOT NULL
	)
	INSERT INTO #PageIndex ([ProductId])
	SELECT ProductId
	FROM #DisplayOrderTmp
	GROUP BY ProductId
	ORDER BY min([Id])

	--total records
	SET @TotalRecords = @@rowcount
	
	DROP TABLE #DisplayOrderTmp

	--prepare filterable specification attribute option identifier (if requested)
	IF @LoadFilterableSpecificationAttributeOptionIds = 1
	BEGIN		
		CREATE TABLE #FilterableSpecs 
		(
			[SpecificationAttributeOptionId] int NOT NULL
		)
		INSERT INTO #FilterableSpecs ([SpecificationAttributeOptionId])
		SELECT DISTINCT [psam].SpecificationAttributeOptionId
		FROM [Product_SpecificationAttribute_Mapping] [psam] with (NOLOCK)
		WHERE [psam].[AllowFiltering] = 1
		AND [psam].[ProductId] IN (SELECT [pi].ProductId FROM #PageIndex [pi])

		--build comma separated list of filterable identifiers
		SELECT @FilterableSpecificationAttributeOptionIds = COALESCE(@FilterableSpecificationAttributeOptionIds + ',' , '') + CAST(SpecificationAttributeOptionId as nvarchar(4000))
		FROM #FilterableSpecs

		DROP TABLE #FilterableSpecs
 	END

	--return products
	SELECT TOP (@RowsToReturn)
		p.*
	FROM
		#PageIndex [pi]
		INNER JOIN Product p with (NOLOCK) on p.Id = [pi].[ProductId]
	WHERE
		[pi].IndexId > @PageLowerBound AND 
		[pi].IndexId < @PageUpperBound
	ORDER BY
		[pi].IndexId
	
	DROP TABLE #PageIndex
END
GO
--a new setting
IF NOT EXISTS (SELECT 1 FROM [Setting] WHERE [name] = N'taxsettings.euvatassumevalid')
BEGIN
	INSERT [Setting] ([Name], [Value], [StoreId])
	VALUES (N'taxsettings.euvatassumevalid', N'false', 0)
END
GO


--a new setting
IF NOT EXISTS (SELECT 1 FROM [Setting] WHERE [name] = N'localizationsettings.loadalllocalizedpropertiesonstartup')
BEGIN
	INSERT [Setting] ([Name], [Value], [StoreId])
	VALUES (N'localizationsettings.loadalllocalizedpropertiesonstartup', N'false', 0)
END
GO
--a new setting
IF NOT EXISTS (SELECT 1 FROM [Setting] WHERE [name] = N'localizationsettings.loadallurlrecordsonstartup')
BEGIN
	INSERT [Setting] ([Name], [Value], [StoreId])
	VALUES (N'localizationsettings.loadallurlrecordsonstartup', N'false', 0)
END
GO