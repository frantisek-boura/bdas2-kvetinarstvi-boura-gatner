CREATE OR REPLACE TYPE T_KVETINA_KOSIK_REC AS OBJECT (
    id_kvetina  NUMBER,
    pocet       NUMBER
);
/

CREATE OR REPLACE TYPE T_KVETINA_KOSIK_LIST AS TABLE OF T_KVETINA_KOSIK_REC;
/

CREATE OR REPLACE PACKAGE PCK_ADMINISTRATIVA
AS  
    PROCEDURE PROC_SMAZ_STARE_DOTAZY(
        p_starsi_nez            IN DATE,
        
        o_pocet_smazanych       OUT NUMBER
    );
    
    PROCEDURE PROC_PODEJ_OBJEDNAVKU(
        p_id_uzivatel           IN UZIVATELE.id_uzivatel%TYPE,
        p_id_zpusob_platby      IN ZPUSOBYPLATEB.id_zpusob_platby%TYPE,
        p_objednane_kvetiny     IN T_KVETINA_KOSIK_LIST,
        
        o_novy_kosik_id         OUT KOSIKY.id_kosik%TYPE
    );
    
    FUNCTION FUNC_NAROK_NA_SLEVU(
        p_id_uzivatel           IN UZIVATELE.id_uzivatel%TYPE
    )
    RETURN NUMBER;

END PCK_ADMINISTRATIVA;
/

CREATE OR REPLACE PACKAGE BODY PCK_ADMINISTRATIVA
AS
    PROCEDURE PROC_SMAZ_STARE_DOTAZY(
        p_starsi_nez            IN DATE,
        
        o_pocet_smazanych       OUT NUMBER
    )
    AS
        CURSOR c_stare_dotazy IS
            SELECT *
            FROM DOTAZY
            WHERE CAST(datum_podani AS DATE) < p_starsi_nez AND odpoved IS NULL;
        r_dotazy                DOTAZY%ROWTYPE;
        v_pocet_smazanych       NUMBER DEFAULT 0;
    BEGIN
        OPEN c_stare_dotazy;
        LOOP
            FETCH c_stare_dotazy INTO r_dotazy;
            EXIT WHEN c_stare_dotazy%NOTFOUND;
            
            DELETE FROM DOTAZY
            WHERE id_dotaz = r_dotazy.id_dotaz;
            
            v_pocet_smazanych := v_pocet_smazanych + 1;
        END LOOP;
        CLOSE c_stare_dotazy;
        
        COMMIT;
        
        o_pocet_smazanych := v_pocet_smazanych;
    END PROC_SMAZ_STARE_DOTAZY;
    
    PROCEDURE PROC_PODEJ_OBJEDNAVKU(
        p_id_uzivatel           IN UZIVATELE.id_uzivatel%TYPE,
        p_id_zpusob_platby      IN ZPUSOBYPLATEB.id_zpusob_platby%TYPE,
        p_objednane_kvetiny     IN T_KVETINA_KOSIK_LIST,
        
        o_novy_kosik_id         OUT KOSIKY.id_kosik%TYPE
    )
    AS
        c_narok_na_slevu        CONSTANT NUMBER := 5;
        
        v_novy_kosik_id         KOSIKY.id_kosik%TYPE;
        v_kvetina_cena          KVETINY.cena%TYPE;
        v_celkova_cena          KOSIKY.cena%TYPE DEFAULT 0;
        v_pocet_predchozich_obj NUMBER DEFAULT 0;
        v_sleva                 NUMBER DEFAULT 0;
        v_narok_na_slevu        NUMBER DEFAULT 0;
    BEGIN
        
        SELECT FUNC_NAROK_NA_SLEVU(p_id_uzivatel)
        INTO v_narok_na_slevu
        FROM dual;
        
        IF v_narok_na_slevu = 1 THEN
            v_sleva := 10;
        ELSE
            v_sleva := 0;
        END IF;

        INSERT INTO KOSIKY (
            id_kosik,
            datum_vytvoreni, 
            cena,
            sleva,
            id_uzivatel, 
            id_stav_objednavky, 
            id_zpusob_platby
        )
        VALUES (
            s_Kosiky_id_kosik.NEXTVAL,
            SYSTIMESTAMP AT LOCAL,
            0,
            0,
            p_id_uzivatel,
            (SELECT id_stav_objednavky FROM STAVYOBJEDNAVEK WHERE nazev = 'Čeká na zaplacení'),
            p_id_zpusob_platby
        )
        RETURNING id_kosik INTO v_novy_kosik_id;
        
        FOR i IN 1..p_objednane_kvetiny.COUNT 
        LOOP
            
            BEGIN
                SELECT cena INTO v_kvetina_cena
                FROM KVETINY
                WHERE id_kvetina = p_objednane_kvetiny(i).id_kvetina;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    RAISE_APPLICATION_ERROR(-20002, 
                        'Kvetina s ID ' || p_objednane_kvetiny(i).id_kvetina || ' nebyla nalezena.'
                    );
            END;
            
            INSERT INTO KVETINYKOSIKY (
                id_kvetina,
                id_kosik,
                pocet
            )
            VALUES (
                p_objednane_kvetiny(i).id_kvetina, 
                v_novy_kosik_id,
                p_objednane_kvetiny(i).pocet
            );
            
            v_celkova_cena := v_celkova_cena + (v_kvetina_cena * p_objednane_kvetiny(i).pocet);
        END LOOP;
        
        UPDATE KOSIKY
        SET cena = v_celkova_cena
        WHERE id_kosik = v_novy_kosik_id;
        
        COMMIT;
        
        o_novy_kosik_id := v_novy_kosik_id;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
    END PROC_PODEJ_OBJEDNAVKU;
    
    FUNCTION FUNC_NAROK_NA_SLEVU(
        p_id_uzivatel           IN UZIVATELE.id_uzivatel%TYPE
    )
    RETURN NUMBER
    AS
        c_pocet_predchozich_obj CONSTANT NUMBER := 4;
        
        v_pocet_obj             NUMBER := 0;
    BEGIN
        FOR r_predchozi_obj IN (
            SELECT 
                l.*,
                (
                    SELECT 
                        CAST(
                            TO_TIMESTAMP_TZ(
                                JSON_VALUE(l2.novy_zaznam, '$.datum_vytvoreni'),
                                'YYYY-MM-DD HH24:MI:SS TZH:TZM'
                            ) AS TIMESTAMP WITH LOCAL TIME ZONE
                        ) 
                    FROM
                        LOGS l2
                    WHERE l2.id_log = l.id_log
                ) AS datum_vytvoreni
            FROM 
                LOGS l
            WHERE 
                UPPER(l.nazev_tabulky) = UPPER('Kosiky') 
                AND l.id_log_akce = (
                    SELECT id_log_akce 
                    FROM LOGAKCE 
                    WHERE nazev = 'Insert' 
                )
                AND JSON_VALUE(l.novy_zaznam, '$.id_uzivatel') = p_id_uzivatel
            ORDER BY 
                datum_vytvoreni DESC
            )
        LOOP
            EXIT WHEN JSON_VALUE(r_predchozi_obj.novy_zaznam, '$.sleva') = 10;
            
            v_pocet_obj := v_pocet_obj + 1;
        END LOOP;
        
        IF v_pocet_obj = c_pocet_predchozich_obj THEN
            RETURN 1;
        ELSE
            RETURN 0;
        END IF;
        
    END FUNC_NAROK_NA_SLEVU;

END PCK_ADMINISTRATIVA;
/

-- priklad volani PROC_PODEJ_OBJEDNAVKU
DECLARE
    v_objednane_kvetiny     T_KVETINA_KOSIK_LIST;
    v_novy_kosik_id         KOSIKY.id_kosik%TYPE;
    
    v_id_uzivatel           CONSTANT NUMBER := 1;
    v_id_zpusob_platby      CONSTANT NUMBER := 1;
BEGIN
    v_objednane_kvetiny := T_KVETINA_KOSIK_LIST();
    
    -- Kvetina ID 2, pocet 3
    v_objednane_kvetiny.EXTEND;
    v_objednane_kvetiny(v_objednane_kvetiny.LAST) := T_KVETINA_KOSIK_REC(2, 3); 
    
    -- Kvetina ID 4, pocet 1
    v_objednane_kvetiny.EXTEND;
    v_objednane_kvetiny(v_objednane_kvetiny.LAST) := T_KVETINA_KOSIK_REC(4, 1); 
    
    -- Podavani objednavky
    PCK_ADMINISTRATIVA.PROC_PODEJ_OBJEDNAVKU(
        p_id_uzivatel      => v_id_uzivatel,
        p_id_zpusob_platby => v_id_zpusob_platby,
        p_objednane_kvetiny=> v_objednane_kvetiny,
        
        o_novy_kosik_id     => v_novy_kosik_id
    );
    
    DBMS_OUTPUT.PUT_LINE('Uspesne podana objednavka s ID: ' || v_novy_kosik_id);
END;
/
