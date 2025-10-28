-- Funkce na vygenerovani silneho hesla
CREATE OR REPLACE FUNCTION FUNC_GENERUJ_HESLO
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
/
