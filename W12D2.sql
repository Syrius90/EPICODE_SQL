/*1.Effettuate un’esplorazione preliminare del database. Di cosa si tratta? Quante e quali tabelle contiene? 
Fate in modo di avere un’idea abbastanza chiara riguardo a con cosa state lavorando.*/
USE sakila;

/*2.Scoprite quanti clienti si sono registrati nel 2006.*/ -- tutti
SELECT
	count(customer_id) numero_clienti_registrati
FROM
	customer c
WHERE
    YEAR(c.create_date) = '2006';
    
/*3.Trovate il numero totale di noleggi effettuati il giorno 1/1/2006*/
SELECT
    count(*) numero_noleggi
FROM
	rental r
WHERE
	-- DATE_FORMAT(DATE(r.rental_date), '%d/%m/%Y') = '10/01/2006';
	DATE(r.rental_date) = '2006-02-14';

/*4.Elencate tutti i film noleggiati nell’ultima settimana e tutte le informazioni legate al cliente che li ha noleggiati.*/
SELECT
	f.title titolo_film,
    c.*
FROM
	film f
		LEFT JOIN
	inventory i ON f.film_id = i.film_id
		LEFT JOIN
	rental r ON i.inventory_id = r.inventory_id
		LEFT JOIN
	customer c ON r.customer_id = c.customer_id
WHERE
	DATEDIFF('2006-02-14',DATE(r.rental_date)) < 7;

/*5.Calcolate la durata media del noleggio per ogni categoria di film.*/
SELECT
	cat.name categoria,
    CAST(AVG(DATEDIFF(r.return_date,r.rental_date)) AS DECIMAL(3,2)) AS durata_noleggio
FROM
	rental r
		LEFT JOIN
	inventory i ON r.inventory_id = i.inventory_id
		LEFT JOIN
	film f ON i.film_id = f.film_id
		LEFT JOIN
	film_category fc ON f.film_id = fc.film_id
		LEFT JOIN
	category cat ON fc.category_id = cat.category_id
GROUP BY categoria
ORDER BY 2 DESC;

/*6.Trovate la data del noleggio più lungo.*/
SELECT
	r.rental_date data_noleggio
FROM
	rental AS r
WHERE
	DATEDIFF(DATE(r.return_date),DATE(r.rental_date)) =
(SELECT
	MAX(DATEDIFF(DATE(r.return_date),DATE(r.rental_date)))
FROM
	rental AS r);
    
    
    
/*SELECT
	r.rental_date,
	MAX(DATEDIFF(DATE(r.return_date),DATE(r.rental_date)))
FROM
	rental AS r
GROUP BY r.rental_date
ORDER BY 2 DESC;*/