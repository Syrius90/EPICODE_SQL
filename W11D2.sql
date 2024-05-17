/*Scrivi una query per verificare che il campo ProductKey nella tabella DimProduct sia una chiave primaria.
Quali considerazioni/ragionamenti è necessario che tu faccia?*/
SELECT
	dimproduct.productkey,
    count(*)
FROM
	dimproduct
GROUP BY
	dimproduct.productkey
HAVING
	count(*) > 1;
    
/*alternativa*/
SELECT
	count(dimproduct.productkey),
    count(DISTINCT dimproduct.productkey)
FROM
	dimproduct;

/*Scrivi una query per verificare che la combinazione dei campi SalesOrderNumber e SalesOrderLineNumber sia una PK*/
SELECT
	reselsales.SalesOrderNumber,
    reselsales.SalesOrderLineNumber,
    count(*)
FROM
	factresellersales AS reselsales
GROUP BY
	reselsales.SalesOrderNumber,
    reselsales.SalesOrderLineNumber
HAVING
	count(*) > 1;

/*Conta il numero transazioni (SalesOrderLineNumber) realizzate ogni giorno a partire dal 1 Gennaio 2020*/
SELECT
	reselsales.OrderDate,
    count(DISTINCT reselsales.SalesOrderNumber)
FROM
	factresellersales AS reselsales
WHERE
	reselsales.OrderDate >= '2020-01-01'
    -- AND reselsales.OrderDate = '2020-01-10'
GROUP BY
	reselsales.OrderDate
ORDER BY
	reselsales.OrderDate;

/*Calcola il fatturato totale (FactResellerSales.SalesAmount),
la quantità totale venduta (FactResellerSales.OrderQuantity) e il prezzo medio di vendita (FactResellerSales.UnitPrice) per prodotto (DimProduct) a partire dal 1 Gennaio 2020.
Il result set deve esporre pertanto il nome del prodotto, il fatturato totale, la quantità totale venduta e il prezzo medio di vendita. I campi in output devono essere parlanti!*/
SELECT
	prod.EnglishProductName AS nome_prodotto,
	SUM(reselsales.SalesAmount) AS fatturato_totale,
    SUM(reselsales.OrderQuantity) AS quantita_totale_venduta,
    -- AVG(reselsales.UnitPrice) AS prezzo_medio_vendita
    SUM(reselsales.SalesAmount) / SUM(reselsales.OrderQuantity) AS prezzo_medio_vendita
FROM
	factresellersales AS reselsales
		LEFT JOIN
	dimproduct AS prod ON reselsales.productkey = prod.productkey
WHERE
	reselsales.OrderDate >= '2020-01-01'
GROUP BY
	prod.EnglishProductName
ORDER BY
	prod.EnglishProductName;

/*Calcola il fatturato totale (FactResellerSales.SalesAmount) e la quantità totale venduta (FactResellerSales.OrderQuantity) per Categoria prodotto (DimProductCategory).
Il result set deve esporre pertanto il nome della categoria prodotto, il fatturato totale e la quantità totale venduta. I campi in output devono essere parlanti! */
SELECT
	cat.EnglishProductCategoryName AS categoria_prodotto,
	SUM(reselsales.SalesAmount) AS fatturato_totale,
    SUM(reselsales.OrderQuantity) AS quantita_totale_venduta
FROM
	factresellersales AS reselsales
		LEFT JOIN
	dimproduct AS prod ON reselsales.productkey = prod.productkey
		LEFT JOIN
	dimproductsubcategory AS sub ON prod.ProductSubcategoryKey = sub.ProductSubcategoryKey
		LEFT JOIN
	dimproductcategory AS cat ON sub.ProductCategoryKey = cat.ProductCategoryKey
GROUP BY
	cat.EnglishProductCategoryName
ORDER BY
	cat.EnglishProductCategoryName;

/*Calcola il fatturato totale per area città (DimGeography.City) realizzato a partire dal 1 Gennaio 2020.
Il result set deve esporre l’elenco delle città con fatturato realizzato superiore a 60K*/
SELECT
	geo.City,
    SUM(reselsales.SalesAmount) AS fatturato_totale
FROM
	factresellersales AS reselsales
		LEFT JOIN
	dimreseller AS resel ON reselsales.resellerkey = resel.resellerkey
		LEFT JOIN
	dimgeography AS geo ON resel.geographykey = geo.geographykey
WHERE
	reselsales.OrderDate >= '2020-01-01'
GROUP BY
	geo.City
HAVING
	SUM(reselsales.SalesAmount) > 60000
ORDER BY
	geo.City;