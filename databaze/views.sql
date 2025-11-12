CREATE OR REPLACE VIEW VIEW_HISTORIE_CEN_KVETIN
AS
SELECT
    l.datum,
    JSON_VALUE(novy_zaznam, '$.id_kvetina' RETURNING NUMBER) AS id_kvetina,
    JSON_VALUE(novy_zaznam, '$.cena' RETURNING NUMBER) AS cena
FROM
    LOGS l
WHERE
    UPPER(nazev_tabulky) = UPPER('Kvetiny')
ORDER BY
    id_kvetina ASC,
    l.datum DESC;
    
SELECT * FROM VIEW_HISTORIE_CEN_KVETIN;

SELECT * FROM VIEW_HISTORIE_CEN_KVETIN
WHERE
    id_kvetina = 1
    AND datum <= (SELECT datum_vytvoreni FROM kosiky WHERE id_kosik = 4);
