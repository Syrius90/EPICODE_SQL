/*Esplora la tabella dei prodotti (DimProduct)*/
SELECT
	*
FROM
	adv.dimproduct;

/*Interroga la tabella dei prodotti (DimProduct) ed esponi in output i campi ProductKey, ProductAlternateKey, EnglishProductName, Color, StandardCost, FinishedGoodsFlag.
Il result set deve essere parlante per cui assegna un alias se lo ritieni opportuno*/
SELECT 
    dimproduct.ProductKey AS CodProdotto,
    dimproduct.ProductAlternateKey AS CodProdotto_Alt,
    dimproduct.EnglishProductName AS CodProdotto,
    dimproduct.Color AS Colore,
    dimproduct.StandardCost AS Costo_Standard,
    dimproduct.FinishedGoodsFlag AS Finito
FROM
    adv.dimproduct;
   
/*Partendo dalla query scrita nel passaggio precedente, esponi in output i soli prodotti finiti cioè quelli per cui il campo FinishedGoodsFlag è uguale a 1*/
SELECT 
	dimproduct.ProductKey AS CodProdotto,
    dimproduct.ProductAlternateKey AS CodProdotto_Alt,
    dimproduct.EnglishProductName AS CodProdotto,
    dimproduct.Color AS Colore,
    dimproduct.StandardCost AS Costo_Standard,
    dimproduct.FinishedGoodsFlag AS Finito
    -- COUNT(*)
FROM
    adv.dimproduct
WHERE
	adv.dimproduct.FinishedGoodsFlag = 1;
		
/*Scrivi una nuova query al fine di esporre in output i prodotti il cui codice modello (ProductAlternateKey) comincia con FR oppure BK. 
Il result set deve contenere il codice prodoto (ProductKey), il modello, il nome del prodoto, il costo standard (StandardCost) e il prezzo di lis􀆟no (ListPrice)*/
SELECT
	-- dimproduct.ProductAlternateKey,
    dimproduct.ProductKey AS CodProdotto,
    dimproduct.ModelName AS Modello,
    dimproduct.EnglishProductName AS Nome_Prodotto,
	dimproduct.StandardCost AS Costo_Standard,
    dimproduct.ListPrice AS Prezzo_Listino
FROM
	adv.dimproduct
WHERE
	dimproduct.ProductAlternateKey LIKE "FR%" OR dimproduct.ProductAlternateKey LIKE "BK%";
    
/*Arricchisci il risultato della query scrita nel passaggio precedente del Markup applicato dall’azienda (ListPrice - StandardCost)*/
SELECT
	-- dimproduct.ProductAlternateKey,
    prod.ProductKey AS CodProdotto,
    prod.ModelName AS Modello,
    prod.EnglishProductName AS Nome_Prodotto,
	prod.StandardCost AS Costo_Standard,
    prod.ListPrice AS Prezzo_Listino,
    prod.ListPrice - prod.StandardCost AS MarkUp
FROM
	adv.dimproduct AS prod
WHERE
	prod.ProductAlternateKey LIKE "FR%" OR prod.ProductAlternateKey LIKE "BK%";
    
/*Scrivi un’altra query al fine di esporre l’elenco dei prodotti finiti il cui prezzo di listino è compreso tra 1000 e 2000.*/
SELECT
	prod.ProductKey AS CodProdotto,
    prod.ListPrice AS Prezzo_Listino
FROM
	adv.dimproduct AS prod
WHERE
	prod.FinishedGoodsFlag = 1
    AND prod.ListPrice BETWEEN 1000 AND 2000
ORDER BY
	prod.ListPrice;
    
/*Esplora la tabella degli impiegati aziendali (DimEmployee)*/
SELECT
	*
FROM
	adv.DimEmployee;

/*Esponi, interrogando la tabella degli impiegati aziendali, l’elenco dei soli agenti. Gli agenti sono i dipendenti per i quali il campo SalespersonFlag è uguale a 1*/
SELECT
	-- emp.salespersonflag,
    emp.firstname AS nome,
    emp.lastname AS cognome,
    emp.title AS titolo,
    emp.departmentname AS dipartimento,
    emp.position AS Posizione
FROM
	adv.DimEmployee AS Emp
WHERE
	emp.salespersonflag = 1
ORDER BY
	emp.lastname;
    
/*Interroga la tabella delle vendite (FactResellerSales). 
Esponi in output l’elenco delle transazioni registrate a partire dal 1° gennaio 2020 dei soli codici prodoto: 597, 598, 477, 214. 
Calcola per ciascuna transazione il profito (SalesAmount - TotalProductCost)*/
SELECT
	*
FROM
	adv.FactResellerSales;
    
SELECT
	reseller.salesordernumber AS cod_ordine,
    reseller.orderdate AS data_ordine,
    reseller.productkey AS cod_prodotto,
    reseller.SalesAmount - reseller.TotalProductCost AS profitto
FROM
	adv.FactResellerSales AS reseller
WHERE
	reseller.orderdate >= "2020-01-01"
    AND
		reseller.productkey IN (597,598,477,214);
		-- (reseller.productkey = 597 OR reseller.productkey = 598 OR reseller.productkey = 477 OR reseller.productkey = 214)