--Mesta
INSERT INTO "ST67009"."MESTA" ("NAZEV") VALUES ('Praha');
INSERT INTO "ST67009"."MESTA" ("NAZEV") VALUES ('Brno');
INSERT INTO "ST67009"."MESTA" ("NAZEV") VALUES ('Ostrava');
INSERT INTO "ST67009"."MESTA" ("NAZEV") VALUES ('Plzeň');
INSERT INTO "ST67009"."MESTA" ("NAZEV") VALUES ('Liberec');

--Ulice
INSERT INTO "ST67009"."ULICE" ("NAZEV") VALUES ('Václavské náměstí');
INSERT INTO "ST67009"."ULICE" ("NAZEV") VALUES ('Národní třída');
INSERT INTO "ST67009"."ULICE" ("NAZEV") VALUES ('Karlova');
INSERT INTO "ST67009"."ULICE" ("NAZEV") VALUES ('Dlouhá');
INSERT INTO "ST67009"."ULICE" ("NAZEV") VALUES ('Žitná');
INSERT INTO "ST67009"."ULICE" ("NAZEV") VALUES ('Masarykova');
INSERT INTO "ST67009"."ULICE" ("NAZEV") VALUES ('Husova');
INSERT INTO "ST67009"."ULICE" ("NAZEV") VALUES ('Pekařská');
INSERT INTO "ST67009"."ULICE" ("NAZEV") VALUES ('Štefánikova');
INSERT INTO "ST67009"."ULICE" ("NAZEV") VALUES ('Hradební');
INSERT INTO "ST67009"."ULICE" ("NAZEV") VALUES ('Jiráskova');
INSERT INTO "ST67009"."ULICE" ("NAZEV") VALUES ('Květná');
INSERT INTO "ST67009"."ULICE" ("NAZEV") VALUES ('Smetanova');
INSERT INTO "ST67009"."ULICE" ("NAZEV") VALUES ('Lesní');
INSERT INTO "ST67009"."ULICE" ("NAZEV") VALUES ('Palackého náměstí');

--PSC
INSERT INTO "ST67009"."PSC" ("PSC") VALUES ('10000');
INSERT INTO "ST67009"."PSC" ("PSC") VALUES ('60200');
INSERT INTO "ST67009"."PSC" ("PSC") VALUES ('70000');
INSERT INTO "ST67009"."PSC" ("PSC") VALUES ('30100');
INSERT INTO "ST67009"."PSC" ("PSC") VALUES ('46001');
INSERT INTO "ST67009"."PSC" ("PSC") VALUES ('50002');
INSERT INTO "ST67009"."PSC" ("PSC") VALUES ('37001');
INSERT INTO "ST67009"."PSC" ("PSC") VALUES ('77900');
INSERT INTO "ST67009"."PSC" ("PSC") VALUES ('58601');
INSERT INTO "ST67009"."PSC" ("PSC") VALUES ('40001');

--Adresy
INSERT INTO "ST67009"."ADRESY" ("CP", "MESTO_ID_MESTO", "ULICE_ID_ULICE", "PSC_ID_PSC")
VALUES (105, 3, 7, 1);
INSERT INTO "ST67009"."ADRESY" ("CP", "MESTO_ID_MESTO", "ULICE_ID_ULICE", "PSC_ID_PSC")
VALUES (24, 5, 12, 9);
INSERT INTO "ST67009"."ADRESY" ("CP", "MESTO_ID_MESTO", "ULICE_ID_ULICE", "PSC_ID_PSC")
VALUES (456, 1, 3, 2);
INSERT INTO "ST67009"."ADRESY" ("CP", "MESTO_ID_MESTO", "ULICE_ID_ULICE", "PSC_ID_PSC")
VALUES (99, 4, 15, 6);
INSERT INTO "ST67009"."ADRESY" ("CP", "MESTO_ID_MESTO", "ULICE_ID_ULICE", "PSC_ID_PSC")
VALUES (1234, 2, 1, 10);
INSERT INTO "ST67009"."ADRESY" ("CP", "MESTO_ID_MESTO", "ULICE_ID_ULICE", "PSC_ID_PSC")
VALUES (78, 1, 8, 3);
INSERT INTO "ST67009"."ADRESY" ("CP", "MESTO_ID_MESTO", "ULICE_ID_ULICE", "PSC_ID_PSC")
VALUES (501, 3, 2, 7);
INSERT INTO "ST67009"."ADRESY" ("CP", "MESTO_ID_MESTO", "ULICE_ID_ULICE", "PSC_ID_PSC")
VALUES (333, 5, 14, 5);
INSERT INTO "ST67009"."ADRESY" ("CP", "MESTO_ID_MESTO", "ULICE_ID_ULICE", "PSC_ID_PSC")
VALUES (11, 2, 6, 8);
INSERT INTO "ST67009"."ADRESY" ("CP", "MESTO_ID_MESTO", "ULICE_ID_ULICE", "PSC_ID_PSC")
VALUES (678, 4, 10, 4);

--Opravneni
INSERT INTO "ST67009"."OPRAVNENI" ("NAZEV", "UROVEN") VALUES ('Uživatel', 0);
INSERT INTO "ST67009"."OPRAVNENI" ("NAZEV", "UROVEN") VALUES ('Zaměstnanec', 1);
INSERT INTO "ST67009"."OPRAVNENI" ("NAZEV", "UROVEN") VALUES ('Administrátor', 2);

--Kategorie
INSERT INTO "ST67009"."KATEGORIE" ("NAZEV", "ID_NADRAZENE_KATEGORIE") VALUES ('Řezané květiny', NULL);
INSERT INTO "ST67009"."KATEGORIE" ("NAZEV", "ID_NADRAZENE_KATEGORIE") VALUES ('Pokojové rostliny', NULL);
INSERT INTO "ST67009"."KATEGORIE" ("NAZEV", "ID_NADRAZENE_KATEGORIE") VALUES ('Květinové dárky', NULL);
INSERT INTO "ST67009"."KATEGORIE" ("NAZEV", "ID_NADRAZENE_KATEGORIE") VALUES ('Růže', 1);

INSERT INTO "ST67009"."KATEGORIE" ("NAZEV", "ID_NADRAZENE_KATEGORIE") VALUES ('Tulipány', 1);
INSERT INTO "ST67009"."KATEGORIE" ("NAZEV", "ID_NADRAZENE_KATEGORIE") VALUES ('Sukulentní rostliny', 2);
INSERT INTO "ST67009"."KATEGORIE" ("NAZEV", "ID_NADRAZENE_KATEGORIE") VALUES ('Orchideje', 2);

INSERT INTO "ST67009"."KATEGORIE" ("NAZEV", "ID_NADRAZENE_KATEGORIE") VALUES ('Rudé Růže', 4);
INSERT INTO "ST67009"."KATEGORIE" ("NAZEV", "ID_NADRAZENE_KATEGORIE") VALUES ('Bílé Růže', 4);
INSERT INTO "ST67009"."KATEGORIE" ("NAZEV", "ID_NADRAZENE_KATEGORIE") VALUES ('Miniaturní sukulenty', 6);

--Kvetiny a Obrazky
DECLARE
    v_id_obrazek NUMBER(10, 0);
    v_id_kvetina NUMBER(10, 0);
BEGIN
    -- TRANSKACE 1: Rudá Růže (Kategorie ID 8)
    -- 1. Vložení záznamu do OBRAZKY a získání ID
    INSERT INTO "ST67009"."OBRAZKY" ("NAZEV_SOUBORU", "DATA")
    VALUES ('Rudá_Růže.png', EMPTY_BLOB())
    RETURNING ID_OBRAZEK INTO v_id_obrazek;

    -- 2. Vložení záznamu do KVETINY s novým ID_OBRAZEK
    INSERT INTO "ST67009"."KVETINY" ("NAZEV", "CENA", "ID_KATEGORIE", "ID_OBRAZEK")
    VALUES ('Rudá Růže Premium', 150.00, 8, v_id_obrazek)
    RETURNING ID_KVETINA INTO v_id_kvetina;

    -- TRANSKACE 2: Žlutá Růže (Kategorie ID 4 - Růže)
    -- 1. Vložení záznamu do OBRAZKY a získání ID
    INSERT INTO "ST67009"."OBRAZKY" ("NAZEV_SOUBORU", "DATA")
    VALUES ('Žlutá_Růže.png', EMPTY_BLOB())
    RETURNING ID_OBRAZEK INTO v_id_obrazek;

    -- 2. Vložení záznamu do KVETINY s novým ID_OBRAZEK
    INSERT INTO "ST67009"."KVETINY" ("NAZEV", "CENA", "ID_KATEGORIE", "ID_OBRAZEK")
    VALUES ('Žlutá Růže Standard', 120.00, 4, v_id_obrazek)
    RETURNING ID_KVETINA INTO v_id_kvetina;

    -- TRANSKACE 3: Aloe Vera (Kategorie ID 6 - Sukulentní rostliny)
    -- 1. Vložení záznamu do OBRAZKY a získání ID
    INSERT INTO "ST67009"."OBRAZKY" ("NAZEV_SOUBORU", "DATA")
    VALUES ('Aloe_Vera.png', EMPTY_BLOB())
    RETURNING ID_OBRAZEK INTO v_id_obrazek;

    -- 2. Vložení záznamu do KVETINY s novým ID_OBRAZEK
    INSERT INTO "ST67009"."KVETINY" ("NAZEV", "CENA", "ID_KATEGORIE", "ID_OBRAZEK")
    VALUES ('Aloe Vera Velká', 350.50, 6, v_id_obrazek)
    RETURNING ID_KVETINA INTO v_id_kvetina;

    -- TRANSKACE 4: Kytice 50 Tulipánů (Kategorie ID 1 - Řezané květiny)
    -- 1. Vložení záznamu do OBRAZKY a získání ID
    INSERT INTO "ST67009"."OBRAZKY" ("NAZEV_SOUBORU", "DATA")
    VALUES ('Kytice_Tulipánů.png', EMPTY_BLOB())
    RETURNING ID_OBRAZEK INTO v_id_obrazek;

    -- 2. Vložení záznamu do KVETINY s novým ID_OBRAZEK
    INSERT INTO "ST67009"."KVETINY" ("NAZEV", "CENA", "ID_KATEGORIE", "ID_OBRAZEK")
    VALUES ('Kytice 50 Tulipánů', 999.90, 1, v_id_obrazek)
    RETURNING ID_KVETINA INTO v_id_kvetina;

    -- TRANSKACE 5: Phalaenopsis Bílá (Kategorie ID 7 - Orchideje)
    -- 1. Vložení záznamu do OBRAZKY a získání ID
    INSERT INTO "ST67009"."OBRAZKY" ("NAZEV_SOUBORU", "DATA")
    VALUES ('Phalaenopsis_Bílá.png', EMPTY_BLOB())
    RETURNING ID_OBRAZEK INTO v_id_obrazek;

    -- 2. Vložení záznamu do KVETINY s novým ID_OBRAZEK
    INSERT INTO "ST67009"."KVETINY" ("NAZEV", "CENA", "ID_KATEGORIE", "ID_OBRAZEK")
    VALUES ('Phalaenopsis Bílá', 490.00, 7, v_id_obrazek)
    RETURNING ID_KVETINA INTO v_id_kvetina;

    -- Potvrzení všech transakcí
    COMMIT;
END;
/

INSERT INTO "ST67009"."OBRAZKY" ("NAZEV_SOUBORU", "DATA")
VALUES ('default_avatar.png', EMPTY_BLOB());

--Uzivatele

--Hesla:
--1. 
--Sul: pBzypGtYQZfeEvEUOjLFfhdJaQHecqiC
--Heslo: xHeslo123
--SHA256 Hash: 00bba328f1e34687d777c43b40efedfec76fc917f9f7073cc577b3bf7b2e7ca5
--2.
--Sul: FcfkLxKRavckyLs27K2eKRXOvWq1wn1q
--Heslo: xHeslo123
--SHA256 Hash: 2ec46958ce7d325fff21bff6ee287ed072a517ecd62fd20b27fb6ca84cfce7bf
--3.
--Sul: DBjTSOYNau5Zwlt7gBHxXRee1E07RWgS
--Heslo: xHeslo123
--SHA256 Hash: b9bd45a4437170b91b569fd2fef1137a30726c9db91772f6768e43b0c758b03a
--4.
--Sul: gjiO8jMSz6rR2akwX8iO0D6KVKTFdMEV
--Heslo: xHeslo123
--SHA256 Hash: a257c8a26a91ecd20eb7502ab1e8bff2f67b5940592e2425c47ae22499aa387b
--5.
--Sul: CtHUZxzHyJGunXgMrFX6vHvV0mZgAZKG
--Heslo: xHeslo123
--SHA256 Hash: e345b9f8bed84bdc0ad224d5eea4a9d139a9d3f3e27926408ce4cc4ce91a427a

-- ID_ADRESA: Unikátní hodnoty 1, 2, 3, 4, 5.
-- ID_OBRAZEK: 6 (default_avatar.png)
-- ID_OPRAVNENI: 1=Uživatel (3x), 2=Zaměstnanec (1x), 3=Administrátor (1x)

-- 1. Uživatel (ID_OPRAVNENI = 1)
INSERT INTO "ST67009"."UZIVATELE" ("EMAIL", "PW_HASH", "SALT", "ID_OPRAVNENI", "ID_OBRAZEK", "ID_ADRESA")
VALUES (
    'tomas.novak@example.cz',
    '00bba328f1e34687d777c43b40efedfec76fc917f9f7073cc577b3bf7b2e7ca5', -- Hash 1
    'pBzypGtYQZfeEvEUOjLFfhdJaQHecqiC', -- Sůl 1
    1, -- ID Oprávnění: Uživatel
    6, -- ID Obrázek: default_avatar.png
    1  -- ID Adresa: Unikátní hodnota 1
);

-- 2. Uživatel (ID_OPRAVNENI = 1)
INSERT INTO "ST67009"."UZIVATELE" ("EMAIL", "PW_HASH", "SALT", "ID_OPRAVNENI", "ID_OBRAZEK", "ID_ADRESA")
VALUES (
    'anna.svoboda@example.cz',
    '2ec46958ce7d325fff21bff6ee287ed072a517ecd62fd20b27fb6ca84cfce7bf', -- Hash 2
    'FcfkLxKRavckyLs27K2eKRXOvWq1wn1q', -- Sůl 2
    1, -- ID Oprávnění: Uživatel
    6, -- ID Obrázek: default_avatar.png
    2  -- ID Adresa: Unikátní hodnota 2
);

-- 3. Uživatel (ID_OPRAVNENI = 1)
INSERT INTO "ST67009"."UZIVATELE" ("EMAIL", "PW_HASH", "SALT", "ID_OPRAVNENI", "ID_OBRAZEK", "ID_ADRESA")
VALUES (
    'jan.kral@example.cz',
    'b9bd45a4437170b91b569fd2fef1137a30726c9db91772f6768e43b0c758b03a', -- Hash 3
    'DBjTSOYNau5Zwlt7gBHxXRee1E07RWgS', -- Sůl 3
    1, -- ID Oprávnění: Uživatel
    6, -- ID Obrázek: default_avatar.png
    3  -- ID Adresa: Unikátní hodnota 3
);

-- 4. Zaměstnanec (ID_OPRAVNENI = 2)
INSERT INTO "ST67009"."UZIVATELE" ("EMAIL", "PW_HASH", "SALT", "ID_OPRAVNENI", "ID_OBRAZEK", "ID_ADRESA")
VALUES (
    'petr.skoda@eshop.cz',
    'a257c8a26a91ecd20eb7502ab1e8bff2f67b5940592e2425c47ae22499aa387b', -- Hash 4
    'gjiO8jMSz6rR2akwX8iO0D6KVKTFdMEV', -- Sůl 4
    2, -- ID Oprávnění: Zaměstnanec
    6, -- ID Obrázek: default_avatar.png
    4  -- ID Adresa: Unikátní hodnota 4
);

-- 5. Administrátor (ID_OPRAVNENI = 3)
INSERT INTO "ST67009"."UZIVATELE" ("EMAIL", "PW_HASH", "SALT", "ID_OPRAVNENI", "ID_OBRAZEK", "ID_ADRESA")
VALUES (
    'admin@eshop.cz',
    'e345b9f8bed84bdc0ad224d5eea4a9d139a9d3f3e27926408ce4cc4ce91a427a', -- Hash 5
    'CtHUZxzHyJGunXgMrFX6vHvV0mZgAZKG', -- Sůl 5
    3, -- ID Oprávnění: Administrátor
    6, -- ID Obrázek: default_avatar.png
    5  -- ID Adresa: Unikátní hodnota 5
);

--StavyObjednavek
INSERT INTO "ST67009"."STAVYOBJEDNAVEK" ("NAZEV") VALUES ('Čeká na zaplacení');
INSERT INTO "ST67009"."STAVYOBJEDNAVEK" ("NAZEV") VALUES ('Vyřízena');
INSERT INTO "ST67009"."STAVYOBJEDNAVEK" ("NAZEV") VALUES ('Na cestě');
INSERT INTO "ST67009"."STAVYOBJEDNAVEK" ("NAZEV") VALUES ('Zrušena');

--ZpusobyPlateb
INSERT INTO "ST67009"."ZPUSOBYPLATEB" ("NAZEV") VALUES ('Kartou');
INSERT INTO "ST67009"."ZPUSOBYPLATEB" ("NAZEV") VALUES ('Převodem');
INSERT INTO "ST67009"."ZPUSOBYPLATEB" ("NAZEV") VALUES ('Google Pay');
INSERT INTO "ST67009"."ZPUSOBYPLATEB" ("NAZEV") VALUES ('Apple Pay');

--Kosiky
-- Aktualizované INSERTy do KOSIKY s různými ID_ZPUSOB_PLATBY (1, 2, 3, 4)

INSERT INTO "ST67009"."KOSIKY" ("DATUM_VYTVORENI", "CENA", "SLEVA", "ID_UZIVATEL", "ID_STAV_OBJEDNAVKY", "ID_ZPUSOB_PLATBY") VALUES (SYSTIMESTAMP - INTERVAL '15' DAY, 420.00, 0, 1, 1, 1);
INSERT INTO "ST67009"."KOSIKY" ("DATUM_VYTVORENI", "CENA", "SLEVA", "ID_UZIVATEL", "ID_STAV_OBJEDNAVKY", "ID_ZPUSOB_PLATBY") VALUES (SYSTIMESTAMP - INTERVAL '14' DAY, 600.00, 0, 2, 2, 2);
INSERT INTO "ST67009"."KOSIKY" ("DATUM_VYTVORENI", "CENA", "SLEVA", "ID_UZIVATEL", "ID_STAV_OBJEDNAVKY", "ID_ZPUSOB_PLATBY") VALUES (SYSTIMESTAMP - INTERVAL '13' DAY, 1119.90, 0, 3, 3, 3);
INSERT INTO "ST67009"."KOSIKY" ("DATUM_VYTVORENI", "CENA", "SLEVA", "ID_UZIVATEL", "ID_STAV_OBJEDNAVKY", "ID_ZPUSOB_PLATBY") VALUES (SYSTIMESTAMP - INTERVAL '12' DAY, 0.00, 0, 1, 4, 4);
INSERT INTO "ST67009"."KOSIKY" ("DATUM_VYTVORENI", "CENA", "SLEVA", "ID_UZIVATEL", "ID_STAV_OBJEDNAVKY", "ID_ZPUSOB_PLATBY") VALUES (SYSTIMESTAMP - INTERVAL '11' DAY, 1629.45, 10, 2, 1, 1);
INSERT INTO "ST67009"."KOSIKY" ("DATUM_VYTVORENI", "CENA", "SLEVA", "ID_UZIVATEL", "ID_STAV_OBJEDNAVKY", "ID_ZPUSOB_PLATBY") VALUES (SYSTIMESTAMP - INTERVAL '10' DAY, 300.00, 0, 3, 2, 2);
INSERT INTO "ST67009"."KOSIKY" ("DATUM_VYTVORENI", "CENA", "SLEVA", "ID_UZIVATEL", "ID_STAV_OBJEDNAVKY", "ID_ZPUSOB_PLATBY") VALUES (SYSTIMESTAMP - INTERVAL '9' DAY, 490.00, 0, 1, 3, 3);
INSERT INTO "ST67009"."KOSIKY" ("DATUM_VYTVORENI", "CENA", "SLEVA", "ID_UZIVATEL", "ID_STAV_OBJEDNAVKY", "ID_ZPUSOB_PLATBY") VALUES (SYSTIMESTAMP - INTERVAL '8' DAY, 0.00, 0, 2, 4, 4);
INSERT INTO "ST67009"."KOSIKY" ("DATUM_VYTVORENI", "CENA", "SLEVA", "ID_UZIVATEL", "ID_STAV_OBJEDNAVKY", "ID_ZPUSOB_PLATBY") VALUES (SYSTIMESTAMP - INTERVAL '7' DAY, 840.50, 0, 3, 1, 1);
INSERT INTO "ST67009"."KOSIKY" ("DATUM_VYTVORENI", "CENA", "SLEVA", "ID_UZIVATEL", "ID_STAV_OBJEDNAVKY", "ID_ZPUSOB_PLATBY") VALUES (SYSTIMESTAMP - INTERVAL '6' DAY, 1350.00, 10, 1, 2, 2);
INSERT INTO "ST67009"."KOSIKY" ("DATUM_VYTVORENI", "CENA", "SLEVA", "ID_UZIVATEL", "ID_STAV_OBJEDNAVKY", "ID_ZPUSOB_PLATBY") VALUES (SYSTIMESTAMP - INTERVAL '5' DAY, 150.00, 0, 2, 3, 3);
INSERT INTO "ST67009"."KOSIKY" ("DATUM_VYTVORENI", "CENA", "SLEVA", "ID_UZIVATEL", "ID_STAV_OBJEDNAVKY", "ID_ZPUSOB_PLATBY") VALUES (SYSTIMESTAMP - INTERVAL '4' DAY, 0.00, 0, 3, 4, 4);
INSERT INTO "ST67009"."KOSIKY" ("DATUM_VYTVORENI", "CENA", "SLEVA", "ID_UZIVATEL", "ID_STAV_OBJEDNAVKY", "ID_ZPUSOB_PLATBY") VALUES (SYSTIMESTAMP - INTERVAL '3' DAY, 480.00, 0, 1, 1, 1);
INSERT INTO "ST67009"."KOSIKY" ("DATUM_VYTVORENI", "CENA", "SLEVA", "ID_UZIVATEL", "ID_STAV_OBJEDNAVKY", "ID_ZPUSOB_PLATBY") VALUES (SYSTIMESTAMP - INTERVAL '2' DAY, 701.00, 0, 2, 2, 2);
INSERT INTO "ST67009"."KOSIKY" ("DATUM_VYTVORENI", "CENA", "SLEVA", "ID_UZIVATEL", "ID_STAV_OBJEDNAVKY", "ID_ZPUSOB_PLATBY") VALUES (SYSTIMESTAMP - INTERVAL '1' DAY, 1080.00, 10, 3, 3, 3);

--KvetinyKosiky
-- Košík 1
INSERT INTO "ST67009"."KVETINYKOSIKY" ("ID_KVETINA", "ID_KOSIK", "POCET") VALUES (1, 1, 2);
INSERT INTO "ST67009"."KVETINYKOSIKY" ("ID_KVETINA", "ID_KOSIK", "POCET") VALUES (2, 1, 1);
-- Košík 2
INSERT INTO "ST67009"."KVETINYKOSIKY" ("ID_KVETINA", "ID_KOSIK", "POCET") VALUES (1, 2, 4);
-- Košík 3
INSERT INTO "ST67009"."KVETINYKOSIKY" ("ID_KVETINA", "ID_KOSIK", "POCET") VALUES (4, 3, 1);
INSERT INTO "ST67009"."KVETINYKOSIKY" ("ID_KVETINA", "ID_KOSIK", "POCET") VALUES (2, 3, 1);
-- Košík 4
INSERT INTO "ST67009"."KVETINYKOSIKY" ("ID_KVETINA", "ID_KOSIK", "POCET") VALUES (1, 4, 1);
-- Košík 5
INSERT INTO "ST67009"."KVETINYKOSIKY" ("ID_KVETINA", "ID_KOSIK", "POCET") VALUES (3, 5, 4);
INSERT INTO "ST67009"."KVETINYKOSIKY" ("ID_KVETINA", "ID_KOSIK", "POCET") VALUES (1, 5, 2);
INSERT INTO "ST67009"."KVETINYKOSIKY" ("ID_KVETINA", "ID_KOSIK", "POCET") VALUES (2, 5, 1);
-- Košík 6
INSERT INTO "ST67009"."KVETINYKOSIKY" ("ID_KVETINA", "ID_KOSIK", "POCET") VALUES (1, 6, 2);
-- Košík 7
INSERT INTO "ST67009"."KVETINYKOSIKY" ("ID_KVETINA", "ID_KOSIK", "POCET") VALUES (5, 7, 1);
-- Košík 8
INSERT INTO "ST67009"."KVETINYKOSIKY" ("ID_KVETINA", "ID_KOSIK", "POCET") VALUES (5, 8, 1);
-- Košík 9
INSERT INTO "ST67009"."KVETINYKOSIKY" ("ID_KVETINA", "ID_KOSIK", "POCET") VALUES (3, 9, 1);
INSERT INTO "ST67009"."KVETINYKOSIKY" ("ID_KVETINA", "ID_KOSIK", "POCET") VALUES (5, 9, 1);
-- Košík 10
INSERT INTO "ST67009"."KVETINYKOSIKY" ("ID_KVETINA", "ID_KOSIK", "POCET") VALUES (1, 10, 10);
-- Košík 11
INSERT INTO "ST67009"."KVETINYKOSIKY" ("ID_KVETINA", "ID_KOSIK", "POCET") VALUES (1, 11, 1);
-- Košík 12
INSERT INTO "ST67009"."KVETINYKOSIKY" ("ID_KVETINA", "ID_KOSIK", "POCET") VALUES (2, 12, 1);
-- Košík 13
INSERT INTO "ST67009"."KVETINYKOSIKY" ("ID_KVETINA", "ID_KOSIK", "POCET") VALUES (2, 13, 4);
-- Košík 14
INSERT INTO "ST67009"."KVETINYKOSIKY" ("ID_KVETINA", "ID_KOSIK", "POCET") VALUES (3, 14, 2);
-- Košík 15
INSERT INTO "ST67009"."KVETINYKOSIKY" ("ID_KVETINA", "ID_KOSIK", "POCET") VALUES (2, 15, 10);

--Dotazy
-- 1. Zodpovězený dotaz - Veřejný (ID odpovídajícího: 4)
INSERT INTO "ST67009"."DOTAZY" ("DATUM_PODANI", "VEREJNY", "TEXT", "ODPOVED", "ID_ODPOVIDAJICI_UZIVATEL")
VALUES (
    SYSTIMESTAMP - INTERVAL '10' DAY,
    1,
    'Jak dlouho trvá doručení do Brna, pokud objednám dnes ráno? Potřebuji to nejpozději pozítří.',
    'Dobrý den, do Brna obvykle doručujeme do 48 hodin od potvrzení platby. Objednáte-li dopoledne, je vysoká šance, že Vám květiny stihneme doručit už zítra.',
    4 -- ID Zaměstnanec (Petr Skoda)
);

-- 2. Nezodpovězený dotaz - Veřejný (ID odpovídajícího: NULL)
INSERT INTO "ST67009"."DOTAZY" ("DATUM_PODANI", "VEREJNY", "TEXT", "ODPOVED", "ID_ODPOVIDAJICI_UZIVATEL")
VALUES (
    SYSTIMESTAMP - INTERVAL '9' DAY,
    1,
    'Lze vrátit pokojovou rostlinu, pokud ji rozbalím a zjistím, že je příliš velká?',
    NULL,
    NULL
);

-- 3. Zodpovězený dotaz - Soukromý (ID odpovídajícího: 5)
INSERT INTO "ST67009"."DOTAZY" ("DATUM_PODANI", "VEREJNY", "TEXT", "ODPOVED", "ID_ODPOVIDAJICI_UZIVATEL")
VALUES (
    SYSTIMESTAMP - INTERVAL '8' DAY,
    0,
    'Máte v plánu přidat platbu přes Bitcoin? Mám hodně BTC.',
    'V současné době Bitcoin nepodporujeme, ale pracujeme na implementaci dalších moderních platebních metod, včetně Apple a Google Pay.',
    5 -- ID Administrátor (Admin)
);

-- 4. Nezodpovězený dotaz - Soukromý (ID odpovídajícího: NULL)
INSERT INTO "ST67009"."DOTAZY" ("DATUM_PODANI", "VEREJNY", "TEXT", "ODPOVED", "ID_ODPOVIDAJICI_UZIVATEL")
VALUES (
    SYSTIMESTAMP - INTERVAL '7' DAY,
    0,
    'Zapomněl jsem přidat vzkaz ke kytici č. 10. Můžete ho přidat dodatečně? Text: Všechno nejlepší!',
    NULL,
    NULL
);

-- 5. Zodpovězený dotaz - Veřejný (ID odpovídajícího: 4)
INSERT INTO "ST67009"."DOTAZY" ("DATUM_PODANI", "VEREJNY", "TEXT", "ODPOVED", "ID_ODPOVIDAJICI_UZIVATEL")
VALUES (
    SYSTIMESTAMP - INTERVAL '6' DAY,
    1,
    'Jak nejlépe zalévat Phalaenopsis, aby mi vydržela co nejdéle?',
    'Phalaenopsis zalévejte ponořením květináče do vody na 10 minut, a to tehdy, až jsou kořeny světle šedé. Vždy nechte substrát mezi zálivkami proschnout.',
    4
);

-- 6. Zodpovězený dotaz - Veřejný (ID odpovídajícího: 5)
INSERT INTO "ST67009"."DOTAZY" ("DATUM_PODANI", "VEREJNY", "TEXT", "ODPOVED", "ID_ODPOVIDAJICI_UZIVATEL")
VALUES (
    SYSTIMESTAMP - INTERVAL '5' DAY,
    1,
    'Máte slevu na první objednávku?',
    'Ano, novým zákazníkům nabízíme slevu 10% na první nákup. Kód naleznete v registračním e-mailu.',
    5
);

-- 7. Nezodpovězený dotaz - Soukromý (ID odpovídajícího: NULL)
INSERT INTO "ST67009"."DOTAZY" ("DATUM_PODANI", "VEREJNY", "TEXT", "ODPOVED", "ID_ODPOVIDAJICI_UZIVATEL")
VALUES (
    SYSTIMESTAMP - INTERVAL '4' DAY,
    0,
    'Moje objednávka č. 12 byla zrušena, ale peníze se mi nevrátily. Kdy mohu očekávat vrácení platby?',
    NULL,
    NULL
);

-- 8. Zodpovězený dotaz - Veřejný (ID odpovídajícího: 4)
INSERT INTO "ST67009"."DOTAZY" ("DATUM_PODANI", "VEREJNY", "TEXT", "ODPOVED", "ID_ODPOVIDAJICI_UZIVATEL")
VALUES (
    SYSTIMESTAMP - INTERVAL '3' DAY,
    1,
    'Prodáváte i semena exotických květin?',
    'Zaměřujeme se primárně na živé rostliny a řezané květiny, semena momentálně v nabídce nemáme.',
    4
);

-- 9. Zodpovězený dotaz - Soukromý (ID odpovídajícího: 5)
INSERT INTO "ST67009"."DOTAZY" ("DATUM_PODANI", "VEREJNY", "TEXT", "ODPOVED", "ID_ODPOVIDAJICI_UZIVATEL")
VALUES (
    SYSTIMESTAMP - INTERVAL '2' DAY,
    0,
    'Potřeboval bych hromadnou objednávku 50 rudých růží na firemní akci. Lze domluvit lepší cenu?',
    'Ano, pro hromadné objednávky nás prosím kontaktujte přímo e-mailem, abychom pro Vás mohli připravit individuální cenovou nabídku.',
    5
);

-- 10. Nezodpovězený dotaz - Veřejný (ID odpovídajícího: NULL)
INSERT INTO "ST67009"."DOTAZY" ("DATUM_PODANI", "VEREJNY", "TEXT", "ODPOVED", "ID_ODPOVIDAJICI_UZIVATEL")
VALUES (
    SYSTIMESTAMP - INTERVAL '1' DAY,
    1,
    'Můžete mi doporučit nejlepší sukulent pro pěstování v tmavším interiéru?',
    NULL,
    NULL
);
