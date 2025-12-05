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


CREATE OR REPLACE VIEW view_objednavky_uzivatelu 
AS
SELECT 
    c.id_kvetina as id_kvetina, c.id_kosik as id_kosik, c.cena_za_kus as cena_za_kus, c.pocet as pocet,
    k.nazev as nazev_kvetiny, k.id_obrazek as id_obrazek, k.id_kategorie as id_kategorie,
    o.nazev_souboru as nazev_souboru, o.data as data,
    kat.nazev as nazev_kategorie,
    ko.id_uzivatel as id_uzivatel
FROM
    view_historie_cen_kvetin c
JOIN
    kvetiny k ON k.id_kvetina = c.id_kvetina
JOIN
    kategorie kat ON kat.id_kategorie = k.id_kategorie
JOIN
    obrazky o ON o.id_obrazek = k.id_obrazek
JOIN
    kosiky ko ON ko.id_kosik = c.id_kosik;


CREATE OR REPLACE VIEW VIEW_KATEGORIE_PODSTROM_KVETIN AS
WITH RECURSIVE_CATEGORIES AS (
    SELECT 
        k.ID_KATEGORIE, 
        k.ID_NADRAZENE_KATEGORIE
    FROM 
        KATEGORIE k
    CONNECT BY PRIOR k.ID_KATEGORIE = k.ID_NADRAZENE_KATEGORIE
    START WITH k.ID_KATEGORIE IS NOT NULL
)
SELECT 
    rc.ID_KATEGORIE,
    kv.ID_KVETINA
FROM 
    RECURSIVE_CATEGORIES rc
JOIN 
    KVETINY kv ON rc.ID_KATEGORIE = kv.ID_KATEGORIE;


--pouziti
SELECT 
    id_kategorie, 
    id_kvetina
FROM 
    ST67009.VIEW_KATEGORIE_PODSTROM_KVETIN
WHERE 
    ID_KATEGORIE IN (
        SELECT 
            ID_KATEGORIE
        FROM 
            ST67009.KATEGORIE
        START WITH 
            ID_KATEGORIE = 3
        CONNECT BY 
            PRIOR ID_KATEGORIE = ID_NADRAZENE_KATEGORIE
    );


create or replace view view_logs
as
select id_log, nazev as akce, upper(nazev_tabulky) as nazev_tabulky, datum as datum_akce, novy_zaznam, stary_zaznam
from logs 
join logakce using (id_log_akce) 
order by nazev_tabulky, datum, nazev;

create or replace view view_sys_katalog
as
select table_name as tabulka, column_name as sloupec, data_type as datovy_typ
from user_tables
join user_tab_columns using (table_name)
order by table_name, column_name;
