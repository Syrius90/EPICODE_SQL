/*1.Elencate il numero di tracce per ogni genere in ordine discendente, escludendo quei generi che hanno meno di 10 tracce*/
SELECT
	genre.name Genere,
    COUNT(DISTINCT track.name) Numero_Tracce
FROM
	track
		LEFT JOIN
	genre ON track.genreid = genre.genreid
GROUP BY genre.name
HAVING Numero_Tracce >= 10
ORDER BY 2 DESC;

/*2.Trovate le tre canzoni più costose*/ -- le canzoni hanno tutte lo stesso prezzo
SELECT
	track.unitprice,
	count(track.name)
FROM
	track
		LEFT JOIN
	mediatype ON track.mediatypeid = mediatype.mediatypeid
WHERE
	mediatype.mediatypeid <> 3
GROUP BY track.unitprice;

/*3.Elencate gli artisti che hanno canzoni più lunghe di 6 minuti*/
SELECT DISTINCT
	artist.name
FROM
	track
		LEFT JOIN
	album ON track.albumid = album.albumid
		LEFT JOIN
	artist ON album.artistid = artist.artistid
WHERE
	track.milliseconds > 360000;

/*4.Individuate la durata media delle tracce per ogni genere.*/
SELECT
	genre.name Genere,
    AVG(track.milliseconds)/1000 AS Durata_Media
FROM
	track
		LEFT JOIN
	genre ON track.genreid = genre.genreid
GROUP BY genre.name
ORDER BY genre.name;

SELECT 
    G.NAME Genre,
    M.NAME MediaType,
    CAST(AVG(MILLISECONDS) / 1000 AS DECIMAL(7,3)) AS AVG_DURATION_SEC,
    CAST(AVG(MILLISECONDS) / 60000 AS DECIMAL(5,3)) AS AVG_DURATION_MIN
FROM
    TRACK T
        LEFT JOIN
    GENRE G ON T.GENREID = G.GENREID
        LEFT JOIN
    MEDIATYPE M ON T.MEDIATYPEID = M.MEDIATYPEID
GROUP BY G.NAME,    M.NAME
ORDER BY 1;

/*5.Elencate tutte le canzoni con la parola “Love” nel titolo, ordinandole alfabeticamente prima per genere e poi per nome*/
SELECT
	genre.name Genere,
    track.name Titolo
FROM
	track
		LEFT JOIN
	genre ON track.genreid = genre.genreid
WHERE
	track.name LIKE "%love%"
    AND track.name NOT LIKE "%llove%"
ORDER BY 1,2;

/*6.Trovate il costo medio per ogni tipologia di media*/
SELECT
	mediatype.name MediaType,
    cast(AVG(track.unitprice) AS DECIMAL(10,2)) AS PrezzoMedio
FROM
	track
		LEFT JOIN
	mediatype ON track.mediatypeid = mediatype.mediatypeid
GROUP BY mediatype.name
ORDER BY 1;

/*7.Individuate il genere con più tracce.*/
SELECT
	genre.name Genere,
    count(DISTINCT track.name) Numero_Tracce
FROM
	track
		LEFT JOIN
	genre ON track.genreid = genre.genreid
GROUP BY genre.name
ORDER BY 2 DESC
LIMIT 1;

SELECT G.NAME AS GENRE_NAME
FROM TRACK T
LEFT JOIN GENRE G ON T.GENREID=G.GENREID
GROUP BY G.NAME
HAVING COUNT(DISTINCT T.NAME)=(SELECT MAX(NUM_TRACK)
                    FROM(SELECT G.NAME AS GENRE_NAME, COUNT(DISTINCT T.NAME) AS NUM_TRACK
                            FROM TRACK T
                            LEFT JOIN GENRE G ON T.GENREID=G.GENREID
                            GROUP BY G.NAME) A );

/*8.Trovate gli artisti che hanno lo stesso numero di album dei Rolling Stones*/
SELECT AR.NAME, COUNT(AL.TITLE) AS NUM_ALBUM
FROM ALBUM AL 
LEFT JOIN ARTIST  AR ON AL.ARTISTID=AR.ARTISTID
GROUP BY AR.NAME
HAVING NUM_ALBUM=(    SELECT COUNT(AL.TITLE) AS NUM_ALBUM
                    FROM ALBUM AL 
                    LEFT JOIN ARTIST  AR  ON AL.ARTISTID=AR.ARTISTID
                    WHERE AR.NAME = 'The Rolling Stones');

/*9.Trovate l’artista con l’album più costoso*/
SELECT
	artist.name Artista,
	album.title Album,
	sum(track.unitprice) Prezzo_totale
FROM
	track 
		LEFT JOIN
	album ON album.albumid = track.albumid
		LEFT JOIN
	artist ON artist.artistid = album.artistid
GROUP BY artist.name, album.title
ORDER BY sum(track.unitprice) DESC
	LIMIT 1;
    
SELECT AR.NAME ARTIST, AL.TITLE ALBUM -- , SUM(T.UNITPRICE) AS ALBUM_PRICE
FROM TRACK T
LEFT JOIN ALBUM AL ON T.ALBUMID=AL.ALBUMID
LEFT JOIN ARTIST AR ON AL.ARTISTID=AR.ARTISTID
GROUP BY AR.NAME, AL.TITLE
HAVING SUM(T.UNITPRICE)=(    SELECT MAX(ALBUM_PRICE)
                            FROM(
                            SELECT AR.NAME ARTIST, AL.TITLE ALBUM, SUM(T.UNITPRICE) AS ALBUM_PRICE
                            FROM TRACK T
                            LEFT JOIN ALBUM AL ON T.ALBUMID=AL.ALBUMID
                            LEFT JOIN ARTIST AR ON AL.ARTISTID=AR.ARTISTID
                            GROUP BY AR.NAME, AL.TITLE)A);