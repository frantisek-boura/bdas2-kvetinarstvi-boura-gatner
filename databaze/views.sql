CREATE OR REPLACE VIEW VIEW_CENY_KVETIN_PRI_OBJEDNANI
AS
SELECT
    kk.id_kosik,
    kk.id_kvetina,
    h.cena AS cena_za_kus,
    kk.pocet
FROM
    kvetinykosiky kk
JOIN
    (
        SELECT
            l.datum,
            JSON_VALUE(novy_zaznam, '$.id_kvetina' RETURNING NUMBER) AS id_kvetina,
            JSON_VALUE(novy_zaznam, '$.cena' RETURNING NUMBER) AS cena,
            ROW_NUMBER() OVER (
                PARTITION BY JSON_VALUE(novy_zaznam, '$.id_kvetina')
                ORDER BY l.datum DESC
            ) AS rn,
            ko.datum_vytvoreni
        FROM
            LOGS l
        CROSS JOIN
            kosiky ko
        WHERE
            UPPER(nazev_tabulky) = UPPER('Kvetiny')
            AND l.datum <= ko.datum_vytvoreni
    ) h ON h.id_kvetina = kk.id_kvetina AND h.rn = 1;
