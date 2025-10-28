CREATE OR REPLACE PACKAGE PCK_HESLA 
AS
    FUNCTION FUNC_GENERUJ_HESLO
    RETURN VARCHAR2;
    
    PROCEDURE PROC_ZMEN_HESLO(
        p_id_uzivatele IN uzivatele.id_uzivatel%TYPE,
        p_nove_heslo IN VARCHAR2
    );
END PCK_HESLA;
/

CREATE OR REPLACE PACKAGE BODY PCK_HESLA 
AS
    FUNCTION FUNC_GENERUJ_HESLO
    RETURN VARCHAR2
    IS
        c_znaky VARCHAR2(22) := '!@#$%^&*()_+{}:<>?/;][';
    
        v_vyber NUMBER;
        v_velke_pismeno BOOLEAN;
        v_alespon_jedno_velke BOOLEAN DEFAULT FALSE;
        v_alespon_jeden_znak BOOLEAN DEFAULT FALSE;
        v_pocet_cisel NUMBER DEFAULT 0;
        
        o_heslo VARCHAR2(12) := '';
    BEGIN
        FOR i IN 1..12
        LOOP
            IF i BETWEEN 8 AND 10 AND v_pocet_cisel < 3 THEN
                o_heslo := o_heslo || TRUNC(DBMS_RANDOM.VALUE(0, 10));
                v_pocet_cisel := v_pocet_cisel + 1;
                CONTINUE;
            END IF;
        
            IF i = 11 AND NOT v_alespon_jedno_velke THEN
                o_heslo := o_heslo || DBMS_RANDOM.STRING('U', 1);
                CONTINUE;
            END IF;
            
            IF i = 12 AND NOT v_alespon_jeden_znak THEN
                o_heslo := o_heslo || SUBSTR(c_znaky, TRUNC(DBMS_RANDOM.VALUE(1, LENGTH(c_znaky) + 1)), 1);
                CONTINUE;
            END IF;
        
            v_vyber := TRUNC(DBMS_RANDOM.VALUE(1, 4));
            
            
            CASE
                WHEN v_vyber = 1 THEN  -- pismena
                    v_velke_pismeno := TRUNC(DBMS_RANDOM.VALUE(0, 2)) MOD 2 = 0;
                    IF v_velke_pismeno THEN
                        o_heslo := o_heslo || DBMS_RANDOM.STRING('U', 1);
                        v_alespon_jedno_velke := TRUE;
                    ELSE
                        o_heslo := o_heslo || DBMS_RANDOM.STRING('L', 1);
                    END IF;
                WHEN v_vyber = 2 THEN -- cisla
                    o_heslo := o_heslo || TRUNC(DBMS_RANDOM.VALUE(0, 10));
                    v_pocet_cisel := v_pocet_cisel + 1;
                WHEN v_vyber = 3 THEN -- symboly
                    o_heslo := o_heslo || SUBSTR(c_znaky, TRUNC(DBMS_RANDOM.VALUE(1, LENGTH(c_znaky) + 1)), 1);
                    v_alespon_jeden_znak := TRUE;
            END CASE;
        END LOOP;
        
        RETURN o_heslo;
    END FUNC_GENERUJ_HESLO;
    
    PROCEDURE PROC_ZMEN_HESLO (
        p_id_uzivatele IN UZIVATELE.ID_UZIVATEL%TYPE,
        p_nove_heslo  IN VARCHAR2
    )
    AS
        v_nova_sul UZIVATELE.SALT%TYPE;
        v_novy_hash UZIVATELE.PW_HASH%TYPE;
    
        C_SUL_LENGTH CONSTANT NUMBER := 32;
    
        E_UZIVATEL_NENALEZEN EXCEPTION;
        PRAGMA EXCEPTION_INIT(E_UZIVATEL_NENALEZEN, -20001);
    BEGIN
        v_nova_sul := DBMS_RANDOM.STRING('X', C_SUL_LENGTH);
    
        SELECT RAWTOHEX(STANDARD_HASH(p_nove_heslo || v_nova_sul, 'SHA256')) INTO v_novy_hash
        FROM dual;
    
        UPDATE UZIVATELE
        SET
            PW_HASH = v_novy_hash,
            SALT = v_nova_sul
        WHERE
            ID_UZIVATEL = p_id_uzivatele;
    
        IF SQL%ROWCOUNT = 0 THEN
            RAISE_APPLICATION_ERROR(-20001, 'Uživatel s ID ' || p_id_uzivatele || ' nebyl nalezen.');
        END IF;
    
        COMMIT;
    EXCEPTION
        WHEN E_UZIVATEL_NENALEZEN THEN
            ROLLBACK;
            RAISE;
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE_APPLICATION_ERROR(-20002, 'Chyba při změně hesla: ' || SQLERRM);
    END PROC_ZMEN_HESLO;
END PCK_HESLA;
/

