/*1.Identificate tutti i clienti che non hanno effettuato nessun noleggio a gennaio 2006.*/ -- Febbraio 2006
SELECT DISTINCT
	c.first_name,
    c.last_name
FROM
	customer c
WHERE
	c.customer_id NOT IN
    (SELECT
		c.customer_id
	FROM
		rental r
			LEFT JOIN
		customer c ON r.customer_id = c.customer_id
	WHERE
		YEAR(r.rental_date) = 2006 AND MONTH(r.rental_date) = 2);

/*2.Elencate tutti i film che sono stati noleggiati più di 10 volte nell’ultimo quarto del 2005*/ -- penultimo

SELECT
	f.title titolo_film,
	count(r.rental_id) numero_noleggi
FROM
	rental r
		LEFT JOIN
	inventory i ON r.inventory_id = i.inventory_id
		LEFT JOIN
	film f ON i.film_id = f.film_id
WHERE
	YEAR(r.rental_date) = 2005 AND QUARTER(r.rental_date) = 3
GROUP BY f.title
HAVING count(*)>10
ORDER BY 2,1;

/*3.Trovate il numero totale di noleggi effettuati il giorno 1/1/2006.*/ -- 14-02-2006
SELECT
	count(r.rental_id) numero_totale_noleggi
FROM
	rental r
WHERE
	DATE(r.rental_date) = '2006-02-14';

/*4.Calcolate la somma degli incassi generati nei weekend (sabato e domenica).*/ -- nullo
SELECT
	SUM(p.amount) incassi_weekend
FROM
	payment p
WHERE
	DAYOFWEEK(p.payment_date) = 1 OR DAYOFWEEK(p.payment_date) = 7;

/*5.Individuate il cliente che ha speso di più in noleggi.*/
SELECT
	c.customer_id,
    c.first_name,
    c.last_name,
	SUM(p.amount) somma_noleggi
FROM
	payment p
		LEFT JOIN
	customer c ON p.customer_id = c.customer_id
GROUP BY c.customer_id
ORDER BY 4 DESC
LIMIT 1;

/*6.Elencate i 5 film con la maggior durata media di noleggio.*/
SELECT
	f.title titolo_film,
    AVG(DATEDIFF(r.return_date,r.rental_date)) durata_noleggio_media
FROM
	rental r
		LEFT JOIN
	inventory i ON r.inventory_id = i.inventory_id
		LEFT JOIN
	film f ON i.film_id = f.film_id
GROUP BY f.title
ORDER BY 2 DESC
LIMIT 5;

/*7.Calcolate il tempo medio tra due noleggi consecutivi da parte di un cliente.*/
SELECT 
    customer.first_name,
    customer.last_name,
    AVG(DATEDIFF(next_rental.rental_date, rental.rental_date)) AS Tempo_Medio_Due_Noleggi
FROM 
    sakila.customer
JOIN 
    sakila.rental ON customer.customer_id = rental.customer_id
LEFT JOIN 
    sakila.rental AS next_rental ON rental.customer_id = next_rental.customer_id 
                                    AND next_rental.rental_date = (
                                        SELECT MIN(nr.rental_date)
                                        FROM sakila.rental nr
                                        WHERE nr.customer_id = rental.customer_id 
                                          AND nr.rental_date > rental.rental_date
                                    )
GROUP BY 
    customer.customer_id, customer.first_name, customer.last_name
ORDER BY 
    Tempo_Medio_Due_Noleggi DESC;


/*8.Individuate il numero di noleggi per ogni mese del 2005.*/
SELECT
	MONTHNAME(r.rental_date) mese,
	COUNT(r.rental_id) numero_noleggi
FROM
	rental r
WHERE
	YEAR(r.rental_date) = 2005
GROUP BY MONTHNAME(r.rental_date);

/*9.Trovate i film che sono stati noleggiati almeno due volte lo stesso giorno.*/
SELECT
	f.title film,
    -- COUNT(r.rental_id) numero_noleggi,
    COUNT(DISTINCT DATE(r.rental_id)) numero_noleggi_distinti
FROM
	rental r
		LEFT JOIN
	inventory i ON r.inventory_id = i.inventory_id
		LEFT JOIN
	film f ON i.film_id = f.film_id
GROUP BY f.title
HAVING COUNT(DISTINCT DATE(r.rental_id)) >= 2
ORDER BY 2;

/*10.Calcolate il tempo medio di noleggio.*/
SELECT
	AVG(DATEDIFF(r.return_date,r.rental_date)) durata_noleggio_media
FROM
	rental r;