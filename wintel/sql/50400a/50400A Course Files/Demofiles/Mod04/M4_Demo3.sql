/* Retrieve product id, product description, and product model id from the Production.ProductModel table */

USE QuantamCorp
GO
SELECT CatalogDescription.query('
declare namespace PD="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelDescription";
<Product ProductModelID="{ /PD:ProductDescription[1]/@ProductModelID }" />
') as Result
FROM Production.ProductModel
where CatalogDescription.exist('
declare namespace PD="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelDescription";
declare namespace wm="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelWarrAndMain";
     /PD:ProductDescription/PD:Features/wm:Warranty ') = 1

--------------------------------------------------------------------------------------------------------------------------------------------

/* Create a primary XML index */

USE QuantamCorp
GO
DROP INDEX PXML_ProductModel_CatalogDescription ON Production.ProductModel
GO
CREATE PRIMARY XML INDEX PXML_ProductModel_CatalogDescription
    ON Production.ProductModel (CatalogDescription);
GO

--------------------------------------------------------------------------------------------------------------------------------------------

/* Create a secondary XML index */

USE QuantamCorp
GO
CREATE XML INDEX IXML_ProductModel_CatalogDescription_Path 
    ON Production.ProductModel (CatalogDescription)
    USING XML INDEX PXML_ProductModel_CatalogDescription FOR PATH ;
GO
CREATE XML INDEX IXML_ProductModel_CatalogDescription_Value
    ON Production.ProductModel (CatalogDescription)
    USING XML INDEX PXML_ProductModel_CatalogDescription FOR VALUE ;
GO

CREATE XML INDEX IXML_ProductModel_CatalogDescription_Property
    ON Production.ProductModel (CatalogDescription)
    USING XML INDEX PXML_ProductModel_CatalogDescription FOR PROPERTY ;
GO

--------------------------------------------------------------------------------------------------------------------------------------------

