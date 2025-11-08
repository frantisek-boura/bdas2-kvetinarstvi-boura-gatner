CREATE OR REPLACE PACKAGE PCK_MESTA
AS
    PROCEDURE PROC_INSERT_MESTO(
        p_nazev     IN VARCHAR2,
        
        o_id_mesto  OUT NUMBER
    );
    
    PROCEDURE PROC_UPDATE_MESTO(
        p_id_mesto  IN NUMBER,
        p_nazev     IN VARCHAR2,
        
        o_id_mesto  OUT NUMBER
    );
    
    PROCEDURE PROC_DELETE_MESTO(
        p_id_mesto  IN NUMBER,
        
        o_status    OUT NUMBER
    );
END PCK_MESTA;
/

CREATE OR REPLACE PACKAGE BODY PCK_MESTA
AS
    PROCEDURE PROC_INSERT_MESTO(
        p_nazev     IN VARCHAR2,
        
        o_id_mesto  OUT NUMBER
    )
    AS
        v_id_mesto      mesta.id_mesto%TYPE;
        v_nazev_clean   mesta.nazev%TYPE := TRIM(p_nazev);
    BEGIN
        SELECT id_mesto
        INTO v_id_mesto
        FROM mesta
        WHERE v_nazev_clean = nazev;
        
        o_id_mesto := v_id_mesto;
    EXCEPTION
        -- osetreni kdyby se vkladal zaznam ktery jeste neexistuje
        -- procedura nejprve kontroluje, jestli novy vkladany zaznam existuje
        -- pokud ne, je vyvolana no data found exception
        -- a je novy zaznam vlozeny az tady
        WHEN NO_DATA_FOUND THEN
            INSERT INTO mesta(nazev) 
            VALUES(v_nazev_clean)
            RETURNING id_mesto INTO o_id_mesto;
    END;
    
    PROCEDURE PROC_UPDATE_MESTO(
        p_id_mesto  IN NUMBER,
        p_nazev     IN VARCHAR2,
        
        o_id_mesto    OUT NUMBER
    )
    AS
        v_nazev_clean   mesta.nazev%TYPE := TRIM(p_nazev);
    BEGIN
        UPDATE mesta
        SET nazev = v_nazev_clean
        WHERE id_mesto = p_id_mesto;
        
        -- osetreni kdyby se editoval zaznam s id ktery v tabulce neni
        IF SQL%ROWCOUNT = 0 THEN
            PROC_INSERT_MESTO(v_nazev_clean, o_id_mesto);
        ELSE
            o_id_mesto := p_id_mesto;
        END IF;
    END;
    
    PROCEDURE PROC_DELETE_MESTO(
        p_id_mesto  IN NUMBER,
        
        o_status    OUT NUMBER
    )
    AS
    BEGIN
        DELETE FROM mesta
        WHERE id_mesto = p_id_mesto;
        o_status := 1;
        
        IF SQL%ROWCOUNT = 1 THEN
            o_status := 1;
        ELSE
            RAISE NO_DATA_FOUND;
        END IF;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN 
            o_status := 0;
        WHEN OTHERS THEN
            o_status := -1;
    END;
    
END PCK_MESTA;
/

CREATE OR REPLACE PACKAGE PCK_ULICE
AS
    PROCEDURE PROC_INSERT_ULICE(
        p_nazev     IN VARCHAR2,
        
        o_id_ulice  OUT NUMBER
    );
    
    PROCEDURE PROC_UPDATE_ULICE(
        p_id_ulice  IN NUMBER,
        p_nazev     IN VARCHAR2,
        
        o_id_ulice  OUT NUMBER
    );
    
    PROCEDURE PROC_DELETE_ULICE(
        p_id_ulice  IN NUMBER,
        
        o_status    OUT NUMBER
    );
END PCK_ULICE;
/

CREATE OR REPLACE PACKAGE BODY PCK_ULICE
AS
    PROCEDURE PROC_INSERT_ULICE(
        p_nazev     IN VARCHAR2,
        
        o_id_ulice  OUT NUMBER
    )
    AS
        v_id_ulice      ulice.id_ulice%TYPE;
        v_nazev_clean   ulice.nazev%TYPE := TRIM(p_nazev);
    BEGIN
        SELECT id_ulice
        INTO v_id_ulice
        FROM ulice
        WHERE v_nazev_clean = nazev;
        
        o_id_ulice := v_id_ulice;
    EXCEPTION
        -- osetreni kdyby se vkladal zaznam ktery jeste neexistuje
        -- procedura nejprve kontroluje, jestli novy vkladany zaznam existuje
        -- pokud ne, je vyvolana no data found exception
        -- a je novy zaznam vlozeny az tady
        WHEN NO_DATA_FOUND THEN
            INSERT INTO ulice(nazev) 
            VALUES(v_nazev_clean)
            RETURNING id_ulice INTO o_id_ulice;
    END;
    
    PROCEDURE PROC_UPDATE_ULICE(
        p_id_ulice  IN NUMBER,
        p_nazev     IN VARCHAR2,
        
        o_id_ulice    OUT NUMBER
    )
    AS
        v_nazev_clean   ulice.nazev%TYPE := TRIM(p_nazev);
    BEGIN
        UPDATE ulice
        SET nazev = v_nazev_clean
        WHERE id_ulice = p_id_ulice;
        
        -- osetreni kdyby se editoval zaznam s id ktery v tabulce neni
        IF SQL%ROWCOUNT = 0 THEN
            PROC_INSERT_ULICE(v_nazev_clean, o_id_ulice);
        ELSE
            o_id_ulice := p_id_ulice;
        END IF;
    END;
    
    PROCEDURE PROC_DELETE_ULICE(
        p_id_ulice  IN NUMBER,
        
        o_status    OUT NUMBER
    )
    AS
    BEGIN
        DELETE FROM ulice
        WHERE id_ulice = p_id_ulice;
        o_status := 1;
        
        IF SQL%ROWCOUNT = 1 THEN
            o_status := 1;
        ELSE
            RAISE NO_DATA_FOUND;
        END IF;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN 
            o_status := 0;
        WHEN OTHERS THEN
            o_status := -1;
    END;
    
END PCK_ULICE;
/

CREATE OR REPLACE PACKAGE PCK_PSC
AS
    PROCEDURE PROC_INSERT_PSC(
        p_psc     IN VARCHAR2,
        
        o_id_psc  OUT NUMBER
    );
    
    PROCEDURE PROC_UPDATE_PSC(
        p_id_psc  IN NUMBER,
        p_psc     IN VARCHAR2,
        
        o_id_psc  OUT NUMBER
    );
    
    PROCEDURE PROC_DELETE_PSC(
        p_id_psc  IN NUMBER,
        
        o_status  OUT NUMBER
    );
END PCK_PSC;
/

CREATE OR REPLACE PACKAGE BODY PCK_PSC
AS
    PROCEDURE PROC_INSERT_PSC(
        p_psc     IN VARCHAR2,
        
        o_id_psc  OUT NUMBER
    )
    AS
        v_id_psc      psc.id_psc%TYPE;
        v_psc_clean   psc.psc%TYPE := TRIM(p_psc);
    BEGIN
        SELECT id_psc
        INTO v_id_psc
        FROM psc
        WHERE v_psc_clean = psc;
        
        o_id_psc := v_id_psc;
    EXCEPTION
        -- osetreni kdyby se vkladal zaznam ktery jeste neexistuje
        -- procedura nejprve kontroluje, jestli novy vkladany zaznam existuje
        -- pokud ne, je vyvolana no data found exception
        -- a je novy zaznam vlozeny az tady
        WHEN NO_DATA_FOUND THEN
            INSERT INTO psc(psc) 
            VALUES(v_psc_clean)
            RETURNING id_psc INTO o_id_psc;
    END;
    
    PROCEDURE PROC_UPDATE_PSC(
        p_id_psc  IN NUMBER,
        p_psc     IN VARCHAR2,
        
        o_id_psc    OUT NUMBER
    )
    AS
        v_psc_clean   psc.psc%TYPE := TRIM(p_psc);
    BEGIN
        UPDATE psc
        SET psc = v_psc_clean
        WHERE id_psc = p_id_psc;
        
        -- osetreni kdyby se editoval zaznam s id ktery v tabulce neni
        IF SQL%ROWCOUNT = 0 THEN
            PROC_INSERT_PSC(v_psc_clean, o_id_psc);
        ELSE
            o_id_psc := p_id_psc;
        END IF;
    END;
    
    PROCEDURE PROC_DELETE_PSC(
        p_id_psc  IN NUMBER,
        
        o_status    OUT NUMBER
    )
    AS
    BEGIN
        DELETE FROM psc
        WHERE id_psc = p_id_psc;
        o_status := 1;
        
        IF SQL%ROWCOUNT = 1 THEN
            o_status := 1;
        ELSE
            RAISE NO_DATA_FOUND;
        END IF;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN 
            o_status := 0;
        WHEN OTHERS THEN
            o_status := -1;
    END;
    
END PCK_PSC;
/

CREATE OR REPLACE PACKAGE PCK_ADRESY
AS

    PROCEDURE PROC_INSERT_ADRESA(
        p_cp          IN NUMBER,
        p_nazev_mesta IN VARCHAR2,
        p_nazev_ulice IN VARCHAR2,
        p_psc         IN VARCHAR2,
        
        o_id_adresa   OUT NUMBER
    );
    
    PROCEDURE PROC_UPDATE_ADRESA(
        p_id_adresa   IN NUMBER,
        p_cp          IN NUMBER,
        p_nazev_mesta IN VARCHAR2,
        p_nazev_ulice IN VARCHAR2,
        p_psc         IN VARCHAR2,
        
        o_id_adresa   OUT NUMBER
    );
    
    PROCEDURE PROC_DELETE_ADRESA(
        p_id_adresa   IN NUMBER,
        
        o_status      OUT NUMBER
    );
    
END PCK_ADRESY;
/

CREATE OR REPLACE PACKAGE BODY PCK_ADRESY
AS

    PROCEDURE PROC_INSERT_ADRESA(
        p_cp          IN NUMBER,
        p_nazev_mesta IN VARCHAR2,
        p_nazev_ulice IN VARCHAR2,
        p_psc         IN VARCHAR2,
        
        o_id_adresa   OUT NUMBER
    ) 
    AS
        v_id_mesto              mesta.id_mesto%TYPE;
        v_id_ulice              ulice.id_ulice%TYPE;
        v_id_psc                psc.id_psc%TYPE;
        v_id_adresa             adresy.id_adresa%TYPE;
    BEGIN
        pck_mesta.proc_insert_mesto(p_nazev_mesta, v_id_mesto);
        pck_ulice.proc_insert_ulice(p_nazev_ulice, v_id_ulice);
        pck_psc.proc_insert_psc(p_psc, v_id_psc);
        
        SELECT id_adresa
        INTO v_id_adresa
        FROM adresy
        WHERE cp = p_cp AND id_mesto = v_id_mesto AND id_ulice = v_id_ulice AND id_psc = v_id_psc;
        
        o_id_adresa := v_id_adresa;
    EXCEPTION
        -- osetreni kdyby se vkladal zaznam ktery jeste neexistuje
        -- procedura nejprve kontroluje, jestli novy vkladany zaznam existuje
        -- pokud ne, je vyvolana no data found exception
        -- a je novy zaznam vlozeny az tady
        WHEN NO_DATA_FOUND THEN
            INSERT INTO adresy(cp, id_mesto, id_ulice, id_psc)
            VALUES(p_cp, v_id_mesto, v_id_ulice, v_id_psc)
            RETURNING id_adresa INTO o_id_adresa;
    END;
    
    PROCEDURE PROC_UPDATE_ADRESA(
        p_id_adresa   IN NUMBER,
        p_cp          IN NUMBER,
        p_nazev_mesta IN VARCHAR2,
        p_nazev_ulice IN VARCHAR2,
        p_psc         IN VARCHAR2,
        
        o_id_adresa   OUT NUMBER
    )
    AS
        v_id_mesto      mesta.id_mesto%TYPE;
        v_id_ulice      ulice.id_ulice%TYPE;
        v_id_psc        psc.id_psc%TYPE;
    BEGIN
        pck_mesta.proc_insert_mesto(p_nazev_mesta, v_id_mesto);
        pck_ulice.proc_insert_ulice(p_nazev_ulice, v_id_ulice);
        pck_psc.proc_insert_psc(p_psc, v_id_psc);
        
        UPDATE adresy
        SET
            cp = p_cp,
            id_mesto = v_id_mesto,
            id_ulice = v_id_ulice,
            id_psc = v_id_psc
        WHERE
            id_adresa = p_id_adresa;
        
        IF SQL%ROWCOUNT = 0 THEN
            PROC_INSERT_ADRESA(p_cp, p_nazev_mesta, p_nazev_ulice, p_psc, o_id_adresa);
        ELSE
            o_id_adresa := p_id_adresa;
        END IF;
    END;
    
    PROCEDURE PROC_DELETE_ADRESA(
        p_id_adresa   IN NUMBER,
        
        o_status      OUT NUMBER
    )
    AS
    BEGIN
        DELETE FROM adresy
        WHERE id_adresa = p_id_adresa;
        
        IF SQL%ROWCOUNT = 1 THEN
            o_status := 1;
        ELSE
            RAISE NO_DATA_FOUND;
        END IF;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN 
            o_status := 0;
        WHEN OTHERS THEN
            o_status := -1;
    END;
    
END PCK_ADRESY;
/

declare
    v_id_adresa NUMBER;
    v_status    NUMBER;
begin
    --pck_adresy.proc_insert_adresa(456, 'Liberec', 'Karlova', '40001', v_id_adresa);
    --dbms_output.put_line('id adresy: ' || v_id_adresa);
    
    --pck_adresy.proc_update_adresa(22, 654, 'Plzeň', 'Karlova', '40001', v_id_adresa);
    --dbms_output.put_line('id adresy: ' || v_id_adresa);
    
    --pck_adresy.proc_delete_adresa(10, v_status);
    --dbms_output.put_line('status: ' || v_status);
end;
/


