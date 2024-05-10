/*Esponi l’anagrafica dei prodotti indicando per ciascun prodotto anche la sua sottocategoria (DimProduct, DimProductSubcategory)*/
SELECT
	prod.*,
    sub.EnglishProductSubcategoryName
FROM
	dimproduct AS prod
		LEFT JOIN
	dimproductsubcategory AS sub ON prod.productsubcategorykey = sub.productsubcategorykey;
        
/*Esponi l’anagrafica dei prodotti indicando per ciascun prodotto la sua sottocategoria e la sua categoria (DimProduct, DimProductSubcategory, DimProductCategory)*/
SELECT
	prod.*,
    sub.EnglishProductSubcategoryName,
    cat.EnglishProductCategoryName
FROM
	dimproduct AS prod
		LEFT JOIN
	dimproductsubcategory AS sub ON prod.productsubcategorykey = sub.productsubcategorykey
		LEFT JOIN
	dimproductcategory AS cat ON sub.ProductCategoryKey = cat.ProductCategoryKey;
                                
/*Esponi l’elenco dei soli prodotti venduti (DimProduct, FactResellerSales)*/
SELECT DISTINCT
	prod.*
FROM
	dimproduct AS prod
		JOIN
	FactResellerSales AS reselsales ON prod.productkey = reselsales.productkey;
                    
/*Esponi l’elenco dei prodotti non venduti (considera i soli prodotti finiti cioè quelli per i quali il campo FinishedGoodsFlag è uguale a 1).*/
SELECT 
    *
FROM
    dimproduct AS prod
WHERE
    prod.productkey NOT IN (SELECT DISTINCT
            prod.productkey
        FROM
            dimproduct AS prod
                JOIN
            FactResellerSales AS reselsales ON prod.productkey = reselsales.productkey)
        AND prod.FinishedGoodsFlag = 1;

/*Esponi l’elenco delle transazioni di vendita (FactResellerSales) indicando anche il nome del prodotto venduto (DimProduct)*/
SELECT
	reselsales.*,
    prod.EnglishProductName AS nome_prodotto
FROM
	FactResellerSales AS reselsales
		LEFT JOIN
	dimproduct AS prod ON reselsales.productkey = prod.productkey;
                    
/*Esponi l’elenco delle transazioni di vendita indicando la categoria di appartenenza di ciascun prodotto venduto*/
SELECT 
    reselsales.*, cat.EnglishProductCategoryName
FROM
    FactResellerSales AS reselsales
        LEFT JOIN
    dimproduct AS prod ON reselsales.productkey = prod.productkey
        LEFT JOIN
    dimproductsubcategory AS sub ON prod.productsubcategorykey = sub.productsubcategorykey
        LEFT JOIN
    dimproductcategory AS cat ON sub.ProductCategoryKey = cat.ProductCategoryKey;
    
/*Esplora la tabella DimReseller*/
SELECT
	*
FROM
	DimReseller;
    
/*Esponi in output l’elenco dei reseller indicando, per ciascun reseller, anche la sua area geografica*/
SELECT
	reseller.*,
    geo.city,
    geo.EnglishCountryRegionName AS country
FROM
	DimReseller AS reseller
		LEFT JOIN
    dimgeography AS geo ON reseller.GeographyKey = geo.GeographyKey;
    
/*Esponi l’elenco delle transazioni di vendita. Il result set deve esporre i campi: SalesOrderNumber, SalesOrderLineNumber, OrderDate, UnitPrice, Quantity, TotalProductCost.
Il result set deve anche indicare il nome del prodotto, il nome della categoria del prodotto, il nome del reseller e l’area geografica*/
/*SELECT
	reselsales.SalesOrderNumber,
    reselsales.SalesOrderLineNumber,
    reselsales.OrderDate,
    reselsales.UnitPrice,
    reselsales.OrderQuantity,
    reselsales.TotalProductCost,
    prod.EnglishProductName,
    cat.EnglishProductCategoryName,
    reseller.ResellerName,
    geo.City,
    geo.EnglishCountryRegionName
FROM
    dimgeography AS geo 
		RIGHT JOIN
    DimReseller AS reseller ON geo.GeographyKey = reseller.GeographyKey
		RIGHT JOIN
	FactResellerSales AS reselsales ON reseller.resellerkey = reselsales.resellerkey
        LEFT JOIN
    dimproduct AS prod ON reselsales.productkey = prod.productkey
        LEFT JOIN
    dimproductsubcategory AS sub ON prod.productsubcategorykey = sub.productsubcategorykey
        LEFT JOIN
    dimproductcategory AS cat ON sub.ProductCategoryKey = cat.ProductCategoryKey;*/
 
 SELECT
	reselsales.SalesOrderNumber,
    reselsales.SalesOrderLineNumber,
    reselsales.OrderDate,
    reselsales.UnitPrice,
    reselsales.OrderQuantity,
    reselsales.TotalProductCost,
    prod.EnglishProductName,
    cat.EnglishProductCategoryName,
    reseller.ResellerName,
    geo.City,
    geo.EnglishCountryRegionName
 FROM   
    FactResellerSales AS reselsales
		LEFT JOIN
	dimproduct AS prod ON reselsales.productkey = prod.productkey
        LEFT JOIN
    dimproductsubcategory AS sub ON prod.productsubcategorykey = sub.productsubcategorykey
        LEFT JOIN
    dimproductcategory AS cat ON sub.ProductCategoryKey = cat.ProductCategoryKey
		LEFT JOIN
	DimReseller AS reseller ON  reseller.resellerkey = reselsales.resellerkey
		LEFT JOIN
	dimgeography AS geo ON reseller.geographykey = geo.geographykey;