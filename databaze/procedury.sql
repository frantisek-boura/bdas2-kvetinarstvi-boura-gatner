--1. PREDELANO
--	Pro konkretni uzivatel id a poskytnute heslo vygeneruje novou sul a sha256 hash
--	aktualizuje zaznam uzivatele v tabulce
CREATE OR REPLACE PROCEDURE PROC_ZMEN_HESLO_UZIVATELI (
    p_id_uzivatel IN UZIVATELE.ID_UZIVATEL%TYPE,
    p_nove_heslo  IN VARCHAR2
)
AS
    -- Deklarace proměnných pro novou sůl a hash
    v_nova_sul UZIVATELE.SALT%TYPE;
    v_novy_hash UZIVATELE.PW_HASH%TYPE;

    -- Definice velikosti solí (32 znaků, jak je ve vaší DDL)
    C_SUL_LENGTH CONSTANT NUMBER := 32;

    -- Vlastní výjimka pro neexistujícího uživatele
    E_UZIVATEL_NENALEZEN EXCEPTION;
    PRAGMA EXCEPTION_INIT(E_UZIVATEL_NENALEZEN, -20001);
BEGIN
    -- 1. Generování nové náhodné soli (32 znaků, hexadecimálně)
    v_nova_sul := DBMS_RANDOM.STRING('X', C_SUL_LENGTH);

    -- 2. Výpočet nového hashe (SHA-256) pomocí STANDARD_HASH
    -- Hashování zřetězení nového hesla a nově vygenerované soli
    SELECT RAWTOHEX(STANDARD_HASH(p_nove_heslo || v_nova_sul, 'SHA256')) INTO v_novy_hash
    FROM dual;

    -- 3. Aktualizace záznamu uživatele
    UPDATE UZIVATELE
    SET
        PW_HASH = v_novy_hash,
        SALT = v_nova_sul
    WHERE
        ID_UZIVATEL = p_id_uzivatel;

    -- 4. Kontrola, zda byl záznam aktualizován
    IF SQL%ROWCOUNT = 0 THEN
        -- Pokud nebyl aktualizován žádný řádek, uživatel neexistuje
        RAISE_APPLICATION_ERROR(-20001, 'Uživatel s ID ' || p_id_uzivatel || ' nebyl nalezen.');
    END IF;

    -- 5. Potvrzení transakce
    COMMIT;

EXCEPTION
    WHEN E_UZIVATEL_NENALEZEN THEN
        ROLLBACK;
        RAISE;
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20002, 'Chyba při změně hesla: ' || SQLERRM);
END;
/
--Priklad pouziti
DECLARE
    -- Zde zadejte ID existujícího uživatele a nové heslo
    v_target_user_id UZIVATELE.ID_UZIVATEL%TYPE := 1;
    v_new_password   VARCHAR2(256) := 'SuperTajneHeslo2025';
BEGIN
    -- Volání procedury pro změnu hesla a regeneraci hashe a soli
    PROC_ZMEN_HESLO_UZIVATELI(
        p_id_uzivatel => v_target_user_id,
        p_nove_heslo  => v_new_password
    );

    DBMS_OUTPUT.PUT_LINE('----------------------------------------------------');
    DBMS_OUTPUT.PUT_LINE('ÚSPĚCH: Heslo uživatele ID ' || v_target_user_id || ' bylo úspěšně změněno.');
    DBMS_OUTPUT.PUT_LINE('Nový hash a sůl byly vygenerovány a uloženy.');
    DBMS_OUTPUT.PUT_LINE('----------------------------------------------------');

EXCEPTION
    -- Vlastní ošetření chyb definovaných v proceduře
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('CHYBA PŘI ZMĚNĚ HESLA:');
        DBMS_OUTPUT.PUT_LINE('Kód chyby: ' || SQLCODE);
        DBMS_OUTPUT.PUT_LINE('Popis: ' || SQLERRM);
END;
/

--3. PREDELANO
--	Najde vsechny kvetiny ve vsech podkategoriich podle id kategorie (vcetne hledane
--	kategorie)
CREATE OR REPLACE PROCEDURE PROC_ZISKEJ_KVETINY_V_HIERARCHII (
    p_id_nadrazena_kat IN KATEGORIE.ID_KATEGORIE%TYPE,
    p_kvetiny_cursor OUT SYS_REFCURSOR
)
AS
BEGIN
    -- Otevření kurzoru, který vrací květiny
    OPEN p_kvetiny_cursor FOR
        SELECT
            k.ID_KVETINA,
            k.NAZEV AS nazev_kvetiny,
            k.CENA,
            k.ID_KATEGORIE,
            kat.NAZEV AS nazev_kategorie
        FROM
            KVETINY k
        JOIN 
            KATEGORIE kat ON k.ID_KATEGORIE = kat.ID_KATEGORIE
        WHERE
            -- Klíčová část: Získání ID kategorií v hierarchii a použití IN
            k.ID_KATEGORIE IN (
                SELECT
                    ID_KATEGORIE
                FROM
                    KATEGORIE
                START WITH
                    ID_KATEGORIE = p_id_nadrazena_kat -- Začíná od kořenové kategorie
                CONNECT BY NOCYCLE
                    PRIOR ID_KATEGORIE = ID_NADRAZENE_KATEGORIE
            );
END;

-- Priklad pouziti
DECLARE
    -- Deklarace proměnné pro uložení kurzoru (výstup z procedury)
    v_kvetiny_cursor SYS_REFCURSOR;

    -- Deklarace typu RECORD, který přesně odpovídá SELECTu v proceduře
    TYPE T_KVETINA_RECORD IS RECORD (
        id_kvetina       KVETINY.ID_KVETINA%TYPE,
        nazev_kvetiny    KVETINY.NAZEV%TYPE,
        cena             KVETINY.CENA%TYPE,
        id_kategorie     KVETINY.ID_KATEGORIE%TYPE,
        nazev_kategorie  KATEGORIE.NAZEV%TYPE
    );
    
    -- Deklarace proměnné záznamu
    r_kvetina_data   T_KVETINA_RECORD;

    -- Nastavení ID kategorie, pro kterou hledáme květiny v celé hierarchii
    v_nadrazena_kat_id CONSTANT NUMBER := 1; 
BEGIN
    -- Informační výpis pro SQL Developer/SQL*Plus
    DBMS_OUTPUT.PUT_LINE('--- Hledání květin pod kategorií ID: ' || v_nadrazena_kat_id || ' (včetně podkategorií) ---');

    -- 1. Volání procedury a předání vstupního a výstupního parametru
    PROC_ZISKEJ_KVETINY_V_HIERARCHII(
        p_id_nadrazena_kat => v_nadrazena_kat_id,
        p_kvetiny_cursor => v_kvetiny_cursor
    );

    -- 2. Zpracování výsledků z kurzoru (iterace přes všechny řádky)
    LOOP
        -- Načtení dat z kurzoru do záznamu
        FETCH v_kvetiny_cursor
        INTO r_kvetina_data;

        -- Ukončení cyklu, pokud už nejsou další řádky
        EXIT WHEN v_kvetiny_cursor%NOTFOUND;

        -- Výpis nalezených květin
        DBMS_OUTPUT.PUT_LINE(
            '[' || r_kvetina_data.nazev_kategorie || 
            ' (ID: ' || r_kvetina_data.id_kategorie || ')] ' ||
            r_kvetina_data.nazev_kvetiny || 
            ' - Cena: ' || TO_CHAR(r_kvetina_data.cena, 'FM9990.00') || ' Kč'
        );
    END LOOP;

    -- 3. Zavření kurzoru pro uvolnění zdrojů
    CLOSE v_kvetiny_cursor;

EXCEPTION
    WHEN OTHERS THEN
        -- Ošetření chyb a zajištění zavření kurzoru
        IF v_kvetiny_cursor%ISOPEN THEN
            CLOSE v_kvetiny_cursor;
        END IF;
        DBMS_OUTPUT.PUT_LINE('CHYBA: ' || SQLERRM);
        RAISE;
END;
/
