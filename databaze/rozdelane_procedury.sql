CREATE OR REPLACE PACKAGE BODY PCK_HESLA 
AS
    FUNCTION FUNC_GENERUJ_SUL
    RETURN VARCHAR2
    IS
        C_SUL_LENGTH    NUMBER DEFAULT 32;
        
        O_SUL           VARCHAR2(32);
    BEGIN
        O_SUL := DBMS_RANDOM.STRING('X', C_SUL_LENGTH);
        RETURN O_SUL;
    END FUNC_GENERUJ_SUL;

    FUNCTION FUNC_GENERUJ_HESLO
    RETURN VARCHAR2
    IS
        c_znaky CONSTANT VARCHAR2(22) := '!@#$%^&*()_+{}:<>?/;][';

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
                WHEN v_vyber = 1 THEN
                    v_velke_pismeno := TRUNC(DBMS_RANDOM.VALUE(0, 2)) MOD 2 = 0;
                    IF v_velke_pismeno THEN
                        o_heslo := o_heslo || DBMS_RANDOM.STRING('U', 1);
                        v_alespon_jedno_velke := TRUE;
                    ELSE
                        o_heslo := o_heslo || DBMS_RANDOM.STRING('L', 1);
                    END IF;
                WHEN v_vyber = 2 THEN
                    o_heslo := o_heslo || TRUNC(DBMS_RANDOM.VALUE(0, 10));
                    v_pocet_cisel := v_pocet_cisel + 1;
                WHEN v_vyber = 3 THEN
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

        E_UZIVATEL_NENALEZEN EXCEPTION;
        PRAGMA EXCEPTION_INIT(E_UZIVATEL_NENALEZEN, -20001);
    BEGIN
        v_nova_sul := FUNC_GENERUJ_SUL();

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
    
    PROCEDURE PROC_REGISTRUJ_UZIVATELE(
        p_email IN VARCHAR2,
        p_heslo IN VARCHAR2,
        p_ulice IN VARCHAR2,
        p_cp    IN NUMBER,
        p_mesto IN VARCHAR2,
        p_psc   IN VARCHAR2,
        
        o_id_uzivatel    OUT NUMBER,
        o_status         OUT NUMBER,
        o_status_message OUT VARCHAR2
    )
    AS
        v_letters_ok BOOLEAN;
        v_length_ok BOOLEAN;
        v_symbol_ok BOOLEAN;
        v_capital_ok BOOLEAN;
        
        v_id_mesto NUMBER;
        v_id_ulice NUMBER;
        v_id_psc   NUMBER;
        v_id_adresa NUMBER;
        v_sul      VARCHAR2(32);
        v_pw_hash  VARCHAR2(64);
    BEGIN
        v_length_ok := (LENGTH(p_heslo) = 12);
        v_letters_ok := (REGEXP_COUNT(p_heslo, '[a-zA-Z]') >= 3);
        v_symbol_ok := (REGEXP_COUNT(p_heslo, '[^a-zA-Z0-9]') >= 1);
        v_capital_ok := (REGEXP_COUNT(p_heslo, '[A-Z]') >= 1);
        
        IF NOT (v_length_ok AND v_letters_ok AND v_symbol_ok AND v_capital_ok) THEN
            o_id_uzivatel := -1;
            o_status := -999;
            o_status_message := 'Chyba registrace: Neplatné heslo';
            RETURN;
        END IF;
        
        PCK_MESTA.PROC_INSERT_MESTO(p_mesto, v_id_mesto, o_status, o_status_message);
        PCK_ULICE.PROC_INSERT_ULICE(p_ulice, v_id_ulice, o_status, o_status_message);
        PCK_PSC.PROC_INSERT_PSC(p_psc, v_id_psc, o_status, o_status_message);
        PCK_ADRESY.PROC_INSERT_ADRESA(p_cp, v_id_mesto, v_id_ulice, v_id_psc, v_id_adresa, o_status, o_status_message); 
        
        v_sul := FUNC_GENERUJ_SUL();
        
        SELECT RAWTOHEX(STANDARD_HASH(p_heslo || v_sul, 'SHA256')) INTO v_pw_hash
        FROM dual;
        
        PCK_UZIVATELE.PROC_INSERT_UZIVATEL(p_email, v_pw_hash, v_sul, 1, 6, v_id_adresa, o_id_uzivatel, o_status, o_status_message);
    END PROC_REGISTRUJ_UZIVATELE;
    
    FUNCTION FUNC_OVER_HESLO(
        p_email IN VARCHAR2,
        p_heslo IN VARCHAR2
    )
    RETURN NUMBER
    IS
        v_incoming_pw_hash VARCHAR2(64);
    
        v_existujici_pw_hash VARCHAR2(64) DEFAULT NULL;
        v_sul     VARCHAR2(32) DEFAULT NULL;
    BEGIN
        SELECT pw_hash, salt
        INTO v_existujici_pw_hash, v_sul
        FROM uzivatele
        WHERE email = p_email;
        
        IF v_sul = NULL AND v_existujici_pw_hash = NULL THEN
            RETURN -1;
        END IF;
        
        SELECT RAWTOHEX(STANDARD_HASH(p_heslo || v_sul, 'SHA256'))
        INTO v_incoming_pw_hash
        FROM dual;
        
        IF v_incoming_pw_hash = v_existujici_pw_hash THEN
            RETURN 1;
        ELSE
            RETURN 0;
        END IF;
    END FUNC_OVER_HESLO;
    
    
END PCK_HESLA;
