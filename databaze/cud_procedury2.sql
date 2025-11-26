CREATE OR REPLACE PACKAGE PCK_GLOBAL_EXCEPTIONS
AS
    
    E_INVALID_PSC_FORMAT EXCEPTION;
    PRAGMA EXCEPTION_INIT(E_INVALID_PSC_FORMAT, -20001);

    
    E_FK_MESTO_NEEXISTUJE EXCEPTION;
    PRAGMA EXCEPTION_INIT(E_FK_MESTO_NEEXISTUJE, -20401);
    
    E_FK_ULICE_NEEXISTUJE EXCEPTION;
    PRAGMA EXCEPTION_INIT(E_FK_ULICE_NEEXISTUJE, -20402);
    
    E_FK_PSC_NEEXISTUJE EXCEPTION;
    PRAGMA EXCEPTION_INIT(E_FK_PSC_NEEXISTUJE, -20403);
    
    E_FK_ADRESA_NEEXISTUJE EXCEPTION;
    PRAGMA EXCEPTION_INIT(E_FK_ADRESA_NEEXISTUJE, -20422); 

    
    E_FK_KATEGORIE_NEEXISTUJE EXCEPTION;
    PRAGMA EXCEPTION_INIT(E_FK_KATEGORIE_NEEXISTUJE, -20404); 
    
    E_CANNOT_DELETE_PARENT EXCEPTION;
    PRAGMA EXCEPTION_INIT(E_CANNOT_DELETE_PARENT, -20405); 

    
    E_FK_OBRAZEK_NEEXISTUJE EXCEPTION;
    PRAGMA EXCEPTION_INIT(E_FK_OBRAZEK_NEEXISTUJE, -20407); 

    
    E_INVALID_UROVEN EXCEPTION;
    PRAGMA EXCEPTION_INIT(E_INVALID_UROVEN, -20410); 
    
    E_FK_OPRAVNENI_NEEXISTUJE EXCEPTION;
    PRAGMA EXCEPTION_INIT(E_FK_OPRAVNENI_NEEXISTUJE, -20420); 

    
    E_FK_UZIVATEL_NEEXISTUJE EXCEPTION;
    PRAGMA EXCEPTION_INIT(E_FK_UZIVATEL_NEEXISTUJE, -20411); 
    
    E_FK_STAV_OBJEDNAVKY_NEEXISTUJE EXCEPTION;
    PRAGMA EXCEPTION_INIT(E_FK_STAV_OBJEDNAVKY_NEEXISTUJE, -20412); 
    
    E_FK_ZPUSOB_PLATBY_NEEXISTUJE EXCEPTION;
    PRAGMA EXCEPTION_INIT(E_FK_ZPUSOB_PLATBY_NEEXISTUJE, -20413); 

    
    E_NEPLATNY_FORMAT_EMAILU EXCEPTION;
    PRAGMA EXCEPTION_INIT(E_NEPLATNY_FORMAT_EMAILU, -20423);

    
    E_FK_KVETINA_NEEXISTUJE EXCEPTION;
    PRAGMA EXCEPTION_INIT(E_FK_KVETINA_NEEXISTUJE, -20430);
    
    E_FK_KOSIK_NEEXISTUJE EXCEPTION;
    PRAGMA EXCEPTION_INIT(E_FK_KOSIK_NEEXISTUJE, -20431);
    
    E_NEPLATNY_POCET EXCEPTION;
    PRAGMA EXCEPTION_INIT(E_NEPLATNY_POCET, -20432);

    
    E_NEKONZISTENTNI_ODPOVED EXCEPTION;
    PRAGMA EXCEPTION_INIT(E_NEKONZISTENTNI_ODPOVED, -20440);

END PCK_GLOBAL_EXCEPTIONS;
/

CREATE OR REPLACE PACKAGE PCK_MESTA
AS  
    PROCEDURE PROC_INSERT_MESTO(
        p_nazev           IN VARCHAR2,
        
        o_id_mesto        OUT NUMBER,
        o_status_code     OUT NUMBER,
        o_status_message  OUT VARCHAR2
    );
    
    PROCEDURE PROC_UPDATE_MESTO(
        p_id_mesto        IN NUMBER,
        p_nazev           IN VARCHAR2,
        
        o_id_mesto        OUT NUMBER,
        o_status_code     OUT NUMBER,
        o_status_message  OUT VARCHAR2
    );
    
    PROCEDURE PROC_DELETE_MESTO(
        p_id_mesto        IN NUMBER,
        
        o_status_code     OUT NUMBER,
        o_status_message  OUT VARCHAR2
    );
END PCK_MESTA;
/

CREATE OR REPLACE PACKAGE BODY PCK_MESTA
AS
    PROCEDURE PROC_INSERT_MESTO(
        p_nazev           IN VARCHAR2,
        
        o_id_mesto        OUT NUMBER,
        o_status_code     OUT NUMBER,
        o_status_message  OUT VARCHAR2
    )
    AS
        v_id_mesto      mesta.id_mesto%TYPE DEFAULT NULL;
        v_nazev_clean   mesta.nazev%TYPE := TRIM(p_nazev);
    BEGIN
        SELECT id_mesto
        INTO v_id_mesto
        FROM mesta
        WHERE UPPER(nazev) = UPPER(v_nazev_clean);
        
        o_id_mesto := v_id_mesto;
        o_status_code := 1; -- ZMĚNA: Vrátit 1 (Úspěch) a ID
        o_status_message := 'Úspěch: Záznam již existuje a bylo vráceno jeho ID.';
        
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            INSERT INTO mesta(nazev) 
            VALUES(v_nazev_clean)
            RETURNING id_mesto INTO o_id_mesto;
            
            o_status_code := 1;
            o_status_message := 'Úspěch: Operace proběhla úspěšně.';
        
        WHEN OTHERS THEN
            o_id_mesto := NULL;
            o_status_code := -999; 
            o_status_message := 'Kritická chyba: Neočekávaná chyba: ' || SQLERRM;
    END PROC_INSERT_MESTO;
    
    PROCEDURE PROC_UPDATE_MESTO(
        p_id_mesto        IN NUMBER,
        p_nazev           IN VARCHAR2,
        
        o_id_mesto        OUT NUMBER,
        o_status_code     OUT NUMBER,
        o_status_message  OUT VARCHAR2
    )
    AS
        v_nazev_clean   mesta.nazev%TYPE := TRIM(p_nazev);
    BEGIN
        UPDATE mesta
        SET nazev = v_nazev_clean
        WHERE id_mesto = p_id_mesto;
        
        IF SQL%ROWCOUNT = 0 THEN
            PROC_INSERT_MESTO(v_nazev_clean, o_id_mesto, o_status_code, o_status_message);
            IF o_status_code = 1 THEN
                o_status_message := 'Úspěch: Záznam nebyl nalezen, byl místo toho vytvořen nový záznam.';
            END IF;
        ELSE
            o_id_mesto := p_id_mesto;
            o_status_code := 1;
            o_status_message := 'Úspěch: Operace proběhla úspěšně.';
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            o_id_mesto := p_id_mesto;
            o_status_code := -999; 
            o_status_message := 'Kritická chyba: Neočekávaná chyba: ' || SQLERRM;
    END PROC_UPDATE_MESTO;
    
    PROCEDURE PROC_DELETE_MESTO(
        p_id_mesto        IN NUMBER,
        
        o_status_code     OUT NUMBER,
        o_status_message  OUT VARCHAR2
    )
    AS
    BEGIN
        DELETE FROM mesta
        WHERE id_mesto = p_id_mesto;
        
        IF SQL%ROWCOUNT = 1 THEN
            o_status_code := 1;
            o_status_message := 'Úspěch: Operace proběhla úspěšně.';
        ELSE
            RAISE NO_DATA_FOUND;
        END IF;
        
    EXCEPTION
        WHEN NO_DATA_FOUND THEN    
            o_status_code := 0; 
            o_status_message := 'Selhání odstranění: Záznam nebyl nalezen.';
            
        WHEN OTHERS THEN
            o_status_code := -999; 
            o_status_message := 'Kritická chyba: Neočekávaná chyba: ' || SQLERRM;
    END PROC_DELETE_MESTO;
    
END PCK_MESTA;
/

CREATE OR REPLACE PACKAGE PCK_ULICE
AS
    PROCEDURE PROC_INSERT_ULICE(
        p_nazev           IN VARCHAR2,
        
        o_id_ulice        OUT NUMBER,
        o_status_code     OUT NUMBER,
        o_status_message  OUT VARCHAR2
    );
    
    PROCEDURE PROC_UPDATE_ULICE(
        p_id_ulice        IN NUMBER,
        p_nazev           IN VARCHAR2,
        
        o_id_ulice        OUT NUMBER,
        o_status_code     OUT NUMBER,
        o_status_message  OUT VARCHAR2
    );
    
    PROCEDURE PROC_DELETE_ULICE(
        p_id_ulice        IN NUMBER,
        
        o_status_code     OUT NUMBER,
        o_status_message  OUT VARCHAR2
    );
END PCK_ULICE;
/

CREATE OR REPLACE PACKAGE BODY PCK_ULICE
AS
    PROCEDURE PROC_INSERT_ULICE(
        p_nazev           IN VARCHAR2,
        
        o_id_ulice        OUT NUMBER,
        o_status_code     OUT NUMBER,
        o_status_message  OUT VARCHAR2
    )
    AS
        v_id_ulice      ulice.id_ulice%TYPE DEFAULT NULL;
        v_nazev_clean   ulice.nazev%TYPE := TRIM(p_nazev);
    BEGIN
        SELECT id_ulice
        INTO v_id_ulice
        FROM ulice
        WHERE UPPER(nazev) = UPPER(v_nazev_clean);
        
        o_id_ulice := v_id_ulice;
        o_status_code := 1; -- ZMĚNA: Vrátit 1 (Úspěch) a ID
        o_status_message := 'Úspěch: Záznam již existuje a bylo vráceno jeho ID.';
        
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            INSERT INTO ulice(nazev) 
            VALUES(v_nazev_clean)
            RETURNING id_ulice INTO o_id_ulice;
            
            o_status_code := 1;
            o_status_message := 'Úspěch: Operace proběhla úspěšně.';
        
        WHEN OTHERS THEN
            o_id_ulice := NULL;
            o_status_code := -999; 
            o_status_message := 'Kritická chyba: Neočekávaná chyba: ' || SQLERRM;
    END PROC_INSERT_ULICE;
    
    PROCEDURE PROC_UPDATE_ULICE(
        p_id_ulice        IN NUMBER,
        p_nazev           IN VARCHAR2,
        
        o_id_ulice        OUT NUMBER,
        o_status_code     OUT NUMBER,
        o_status_message  OUT VARCHAR2
    )
    AS
        v_nazev_clean   ulice.nazev%TYPE := TRIM(p_nazev);
    BEGIN
        UPDATE ulice
        SET nazev = v_nazev_clean
        WHERE id_ulice = p_id_ulice;
        
        IF SQL%ROWCOUNT = 0 THEN
            PROC_INSERT_ULICE(v_nazev_clean, o_id_ulice, o_status_code, o_status_message);
            IF o_status_code = 1 THEN
                o_status_message := 'Úspěch: Záznam nebyl nalezen, byl místo toho vytvořen nový záznam.';
            END IF;
        ELSE
            o_id_ulice := p_id_ulice;
            o_status_code := 1;
            o_status_message := 'Úspěch: Operace proběhla úspěšně.';
        END IF;
        
    EXCEPTION
        WHEN OTHERS THEN
            o_id_ulice := p_id_ulice;
            o_status_code := -999; 
            o_status_message := 'Kritická chyba: Neočekávaná chyba: ' || SQLERRM;
    END PROC_UPDATE_ULICE;
    
    PROCEDURE PROC_DELETE_ULICE(
        p_id_ulice        IN NUMBER,
        
        o_status_code     OUT NUMBER,
        o_status_message  OUT VARCHAR2
    )
    AS
    BEGIN
        DELETE FROM ulice
        WHERE id_ulice = p_id_ulice;
        
        IF SQL%ROWCOUNT = 1 THEN
            o_status_code := 1;
            o_status_message := 'Úspěch: Operace proběhla úspěšně.';
        ELSE
            RAISE NO_DATA_FOUND;
        END IF;
        
    EXCEPTION
        WHEN NO_DATA_FOUND THEN    
            o_status_code := 0; 
            o_status_message := 'Selhání odstranění: Záznam nebyl nalezen.';
            
        WHEN OTHERS THEN
            o_status_code := -999; 
            o_status_message := 'Kritická chyba: Neočekávaná chyba: ' || SQLERRM;
    END PROC_DELETE_ULICE;
    
END PCK_ULICE;
/

CREATE OR REPLACE PACKAGE PCK_PSC
AS
    PROCEDURE PROC_INSERT_PSC(
        p_psc             IN VARCHAR2,
        
        o_id_psc          OUT NUMBER,
        o_status_code     OUT NUMBER,
        o_status_message  OUT VARCHAR2
    );
    
    PROCEDURE PROC_UPDATE_PSC(
        p_id_psc          IN NUMBER,
        p_psc             IN VARCHAR2,
        
        o_id_psc          OUT NUMBER,
        o_status_code     OUT NUMBER,
        o_status_message  OUT VARCHAR2
    );
    
    PROCEDURE PROC_DELETE_PSC(
        p_id_psc          IN NUMBER,
        
        o_status_code     OUT NUMBER,
        o_status_message  OUT VARCHAR2
    );
END PCK_PSC;
/

CREATE OR REPLACE PACKAGE BODY PCK_PSC
AS
    

    PROCEDURE PROC_INSERT_PSC(
        p_psc             IN VARCHAR2,
        
        o_id_psc          OUT NUMBER,
        o_status_code     OUT NUMBER,
        o_status_message  OUT VARCHAR2
    )
    AS
        v_id_psc      psc.id_psc%TYPE DEFAULT NULL;
        v_psc_clean   psc.psc%TYPE := TRIM(p_psc); 
    BEGIN
        IF LENGTH(v_psc_clean) != 5 OR NOT REGEXP_LIKE(v_psc_clean, '^[0-9]{5}$') THEN
            RAISE PCK_GLOBAL_EXCEPTIONS.E_INVALID_PSC_FORMAT;
        END IF;

        SELECT id_psc
        INTO v_id_psc
        FROM psc
        WHERE UPPER(psc) = UPPER(v_psc_clean); 
        
        o_id_psc := v_id_psc;
        o_status_code := 1; -- ZMĚNA: Vrátit 1 (Úspěch) a ID
        o_status_message := 'Úspěch: Záznam již existuje a bylo vráceno jeho ID.';
        
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            INSERT INTO psc(psc) 
            VALUES(v_psc_clean)
            RETURNING id_psc INTO o_id_psc;
            
            o_status_code := 1;
            o_status_message := 'Úspěch: Operace proběhla úspěšně.';
        
        WHEN PCK_GLOBAL_EXCEPTIONS.E_INVALID_PSC_FORMAT THEN
            o_id_psc := NULL;
            o_status_code := -20; 
            o_status_message := 'Selhání validace: PSČ musí být přesně 5 číslic.';
        
        WHEN OTHERS THEN
            o_id_psc := NULL;
            o_status_code := -999; 
            o_status_message := 'Kritická chyba: Neočekávaná chyba: ' || SQLERRM;
    END PROC_INSERT_PSC;
    
    PROCEDURE PROC_UPDATE_PSC(
        p_id_psc          IN NUMBER,
        p_psc             IN VARCHAR2,
        
        o_id_psc          OUT NUMBER,
        o_status_code     OUT NUMBER,
        o_status_message  OUT VARCHAR2
    )
    AS
        v_psc_clean   psc.psc%TYPE := TRIM(p_psc);
    BEGIN
        UPDATE psc
        SET psc = v_psc_clean
        WHERE id_psc = p_id_psc;
        
        IF SQL%ROWCOUNT = 0 THEN
            PROC_INSERT_PSC(v_psc_clean, o_id_psc, o_status_code, o_status_message);
            IF o_status_code = 1 THEN
                o_status_message := 'Úspěch: Záznam nebyl nalezen, byl místo toho vytvořen nový záznam.';
            END IF;
        ELSE
            o_id_psc := p_id_psc;
            o_status_code := 1;
            o_status_message := 'Úspěch: Operace proběhla úspěšně.';
        END IF;
        
    EXCEPTION
        WHEN OTHERS THEN
            o_id_psc := p_id_psc;
            o_status_code := -999; 
            o_status_message := 'Kritická chyba: Neočekávaná chyba: ' || SQLERRM;
    END PROC_UPDATE_PSC;
    
    PROCEDURE PROC_DELETE_PSC(
        p_id_psc          IN NUMBER,
        
        o_status_code     OUT NUMBER,
        o_status_message  OUT VARCHAR2
    )
    AS
    BEGIN
        DELETE FROM psc
        WHERE id_psc = p_id_psc;
        
        IF SQL%ROWCOUNT = 1 THEN
            o_status_code := 1;
            o_status_message := 'Úspěch: Operace proběhla úspěšně.';
        ELSE
            RAISE NO_DATA_FOUND; 
        END IF;
        
    EXCEPTION
        WHEN NO_DATA_FOUND THEN    
            o_status_code := 0; 
            o_status_message := 'Selhání odstranění: Záznam nebyl nalezen.';
            
        WHEN OTHERS THEN
            o_status_code := -999; 
            o_status_message := 'Kritická chyba: Neočekávaná chyba: ' || SQLERRM;
    END PROC_DELETE_PSC;
    
END PCK_PSC;
/

CREATE OR REPLACE PACKAGE PCK_ADRESY
AS
    
    PROCEDURE PROC_INSERT_ADRESA(
        p_cp              IN NUMBER,
        p_id_mesto        IN NUMBER,
        p_id_ulice        IN NUMBER,
        p_id_psc          IN NUMBER,
        
        o_id_adresa       OUT NUMBER,
        o_status_code     OUT NUMBER,
        o_status_message  OUT VARCHAR2
    );
    
    PROCEDURE PROC_UPDATE_ADRESA(
        p_id_adresa       IN NUMBER,
        p_cp              IN NUMBER,
        p_id_mesto        IN NUMBER,
        p_id_ulice        IN NUMBER,
        p_id_psc          IN NUMBER,
        
        o_id_adresa       OUT NUMBER,
        o_status_code     OUT NUMBER,
        o_status_message  OUT VARCHAR2
    );
    
    PROCEDURE PROC_DELETE_ADRESA(
        p_id_adresa       IN NUMBER,
        
        o_status_code     OUT NUMBER,
        o_status_message  OUT VARCHAR2
    );
END PCK_ADRESY;
/


CREATE OR REPLACE PACKAGE BODY PCK_ADRESY
AS
    

    v_existuje NUMBER;
    
    PROCEDURE CHECK_FOREIGN_KEYS(
        p_id_mesto IN NUMBER,
        p_id_ulice IN NUMBER,
        p_id_psc   IN NUMBER
    )
    AS
    BEGIN
        BEGIN
            SELECT 1 INTO v_existuje FROM mesta WHERE id_mesto = p_id_mesto;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN RAISE PCK_GLOBAL_EXCEPTIONS.E_FK_MESTO_NEEXISTUJE;
        END;

        BEGIN
            SELECT 1 INTO v_existuje FROM ulice WHERE id_ulice = p_id_ulice;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN RAISE PCK_GLOBAL_EXCEPTIONS.E_FK_ULICE_NEEXISTUJE;
        END;

        BEGIN
            SELECT 1 INTO v_existuje FROM psc WHERE id_psc = p_id_psc;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN RAISE PCK_GLOBAL_EXCEPTIONS.E_FK_PSC_NEEXISTUJE;
        END;
    END CHECK_FOREIGN_KEYS;
    
    PROCEDURE PROC_INSERT_ADRESA(
        p_cp              IN NUMBER,
        p_id_mesto        IN NUMBER,
        p_id_ulice        IN NUMBER,
        p_id_psc          IN NUMBER,
        
        o_id_adresa       OUT NUMBER,
        o_status_code     OUT NUMBER,
        o_status_message  OUT VARCHAR2
    )
    AS
        v_id_adresa adresy.id_adresa%TYPE;
    BEGIN
        CHECK_FOREIGN_KEYS(p_id_mesto, p_id_ulice, p_id_psc);

        SELECT id_adresa
        INTO v_id_adresa
        FROM adresy
        WHERE cp = p_cp 
          AND id_mesto = p_id_mesto 
          AND id_ulice = p_id_ulice 
          AND id_psc = p_id_psc;
        
        o_id_adresa := v_id_adresa;
        o_status_code := 1; -- ZMĚNA: Vrátit 1 (Úspěch) a ID
        o_status_message := 'Úspěch: Záznam již existuje a bylo vráceno jeho ID.';
        
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            INSERT INTO adresy(cp, id_mesto, id_ulice, id_psc)
            VALUES(p_cp, p_id_mesto, p_id_ulice, p_id_psc)
            RETURNING id_adresa INTO o_id_adresa;
            
            o_status_code := 1;
            o_status_message := 'Úspěch: Operace proběhla úspěšně.';
            
        WHEN PCK_GLOBAL_EXCEPTIONS.E_FK_MESTO_NEEXISTUJE THEN
            o_id_adresa := NULL; 
            o_status_code := -401;
            o_status_message := 'Selhání cizího klíče: Zadané město neexistuje.';
        
        WHEN PCK_GLOBAL_EXCEPTIONS.E_FK_ULICE_NEEXISTUJE THEN
            o_id_adresa := NULL; 
            o_status_code := -402;
            o_status_message := 'Selhání cizího klíče: Zadaná ulice neexistuje.';

        WHEN PCK_GLOBAL_EXCEPTIONS.E_FK_PSC_NEEXISTUJE THEN
            o_id_adresa := NULL; 
            o_status_code := -403;
            o_status_message := 'Selhání cizího klíče: Zadané PSČ neexistuje.';
            
        WHEN OTHERS THEN
            o_id_adresa := NULL;
            o_status_code := -999; 
            o_status_message := 'Kritická chyba: Neočekávaná chyba: ' || SQLERRM;
    END PROC_INSERT_ADRESA;
    
    PROCEDURE PROC_UPDATE_ADRESA(
        p_id_adresa       IN NUMBER,
        p_cp              IN NUMBER,
        p_id_mesto        IN NUMBER,
        p_id_ulice        IN NUMBER,
        p_id_psc          IN NUMBER,
        
        o_id_adresa       OUT NUMBER,
        o_status_code     OUT NUMBER,
        o_status_message  OUT VARCHAR2
    )
    AS
    BEGIN
        CHECK_FOREIGN_KEYS(p_id_mesto, p_id_ulice, p_id_psc);

        UPDATE adresy
        SET
            cp = p_cp,
            id_mesto = p_id_mesto,
            id_ulice = p_id_ulice,
            id_psc = p_id_psc
        WHERE
            id_adresa = p_id_adresa;
        
        IF SQL%ROWCOUNT = 0 THEN
            PROC_INSERT_ADRESA(p_cp, p_id_mesto, p_id_ulice, p_id_psc, o_id_adresa, o_status_code, o_status_message);
            IF o_status_code = 1 THEN
                o_status_message := 'Úspěch: Záznam nebyl nalezen, byl místo toho vytvořen nový záznam.';
            END IF;
        ELSE
            o_id_adresa := p_id_adresa;
            o_status_code := 1;
            o_status_message := 'Úspěch: Operace proběhla úspěšně.';
        END IF;
        
    EXCEPTION
        WHEN PCK_GLOBAL_EXCEPTIONS.E_FK_MESTO_NEEXISTUJE THEN
            o_id_adresa := p_id_adresa; 
            o_status_code := -401;
            o_status_message := 'Selhání cizího klíče: Zadané město neexistuje.';
        
        WHEN PCK_GLOBAL_EXCEPTIONS.E_FK_ULICE_NEEXISTUJE THEN
            o_id_adresa := p_id_adresa; 
            o_status_code := -402;
            o_status_message := 'Selhání cizího klíče: Zadaná ulice neexistuje.';

        WHEN PCK_GLOBAL_EXCEPTIONS.E_FK_PSC_NEEXISTUJE THEN
            o_id_adresa := p_id_adresa; 
            o_status_code := -403;
            o_status_message := 'Selhání cizího klíče: Zadané PSČ neexistuje.';
            
        WHEN OTHERS THEN
            o_id_adresa := p_id_adresa;
            o_status_code := -999; 
            o_status_message := 'Kritická chyba: Neočekávaná chyba: ' || SQLERRM;
    END PROC_UPDATE_ADRESA;
    
    PROCEDURE PROC_DELETE_ADRESA(
        p_id_adresa       IN NUMBER,
        
        o_status_code     OUT NUMBER,
        o_status_message  OUT VARCHAR2
    )
    AS
    BEGIN
        DELETE FROM adresy
        WHERE id_adresa = p_id_adresa;
        
        IF SQL%ROWCOUNT = 1 THEN
            o_status_code := 1;
            o_status_message := 'Úspěch: Operace proběhla úspěšně.';
        ELSE
            RAISE NO_DATA_FOUND;
        END IF;
        
    EXCEPTION
        WHEN NO_DATA_FOUND THEN    
            o_status_code := 0; 
            o_status_message := 'Selhání odstranění: Záznam nebyl nalezen.';
            
        WHEN OTHERS THEN
            o_status_code := -999; 
            o_status_message := 'Kritická chyba: Neočekávaná chyba: ' || SQLERRM;
    END PROC_DELETE_ADRESA;
    
END PCK_ADRESY;
/

CREATE OR REPLACE PACKAGE PCK_KATEGORIE
AS
    FUNCTION FUNC_IS_CYCLIC_HIERARCHY(
        p_id_kategorie IN NUMBER,
        p_id_nadrazene IN NUMBER 
    )
    RETURN BOOLEAN;

    PROCEDURE PROC_INSERT_KATEGORIE(
        p_nazev           IN VARCHAR2,
        p_id_nadrazene    IN NUMBER,
        
        o_id_kategorie    OUT NUMBER,
        o_status_code     OUT NUMBER,
        o_status_message  OUT VARCHAR2
    );

    PROCEDURE PROC_UPDATE_KATEGORIE(
        p_id_kategorie    IN NUMBER,
        p_nazev           IN VARCHAR2,
        p_id_nadrazene    IN NUMBER,
        
        o_id_kategorie    OUT NUMBER,
        o_status_code     OUT NUMBER,
        o_status_message  OUT VARCHAR2
    );

    PROCEDURE PROC_DELETE_KATEGORIE(
        p_id_kategorie    IN NUMBER,
        
        o_status_code     OUT NUMBER,
        o_status_message  OUT VARCHAR2
    );
END PCK_KATEGORIE;
/

CREATE OR REPLACE PACKAGE BODY PCK_KATEGORIE
AS
    
    
    FUNCTION FUNC_IS_CYCLIC_HIERARCHY(
        p_id_kategorie IN NUMBER,
        p_id_nadrazene IN NUMBER
    )
    RETURN BOOLEAN
    AS
        v_is_cyclic NUMBER := 0;
    BEGIN
        IF p_id_nadrazene IS NULL THEN
            RETURN FALSE;
        END IF;
        
        SELECT 1
        INTO v_is_cyclic
        FROM DUAL
        WHERE EXISTS (
            SELECT 1
            FROM KATEGORIE
            START WITH id_kategorie = p_id_kategorie
            CONNECT BY PRIOR id_kategorie = id_nadrazene_kategorie
               AND id_kategorie = p_id_nadrazene
        );

        RETURN v_is_cyclic = 1;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN FALSE;
        WHEN OTHERS THEN
            RETURN TRUE;
    END FUNC_IS_CYCLIC_HIERARCHY;

    
    PROCEDURE PROC_INSERT_KATEGORIE(
        p_nazev           IN VARCHAR2,
        p_id_nadrazene    IN NUMBER,
        
        o_id_kategorie    OUT NUMBER,
        o_status_code     OUT NUMBER,
        o_status_message  OUT VARCHAR2
    )
    AS
        v_id_kategorie KATEGORIE.ID_KATEGORIE%TYPE DEFAULT NULL;
        v_nazev_clean  KATEGORIE.NAZEV%TYPE := TRIM(p_nazev);
        v_existuje     NUMBER;
    BEGIN
        IF p_id_nadrazene IS NOT NULL THEN
            BEGIN
                SELECT 1 INTO v_existuje FROM KATEGORIE WHERE id_kategorie = p_id_nadrazene;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN RAISE PCK_GLOBAL_EXCEPTIONS.E_FK_KATEGORIE_NEEXISTUJE;
            END;
        END IF;
    
        SELECT id_kategorie
        INTO v_id_kategorie
        FROM KATEGORIE
        WHERE UPPER(nazev) = UPPER(v_nazev_clean)
          AND NVL(id_nadrazene_kategorie,-1) = NVL(p_id_nadrazene,-1);

        o_id_kategorie := v_id_kategorie;
        o_status_code := 1; -- ZMĚNA: Vrátit 1 (Úspěch) a ID
        o_status_message := 'Úspěch: Záznam již existuje a bylo vráceno jeho ID.';

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            INSERT INTO KATEGORIE(nazev, id_nadrazene_kategorie)
            VALUES (v_nazev_clean, p_id_nadrazene)
            RETURNING id_kategorie INTO o_id_kategorie;
            
            o_status_code := 1;
            o_status_message := 'Úspěch: Operace proběhla úspěšně.';
        
        WHEN PCK_GLOBAL_EXCEPTIONS.E_FK_KATEGORIE_NEEXISTUJE THEN
            o_id_kategorie := NULL; o_status_code := -404;
            o_status_message := 'Selhání cizího klíče: Zadaná nadřazená kategorie neexistuje.';

        WHEN OTHERS THEN
            o_id_kategorie := NULL;
            o_status_code := -999; 
            o_status_message := 'Kritická chyba: Neočekávaná chyba: ' || SQLERRM;
    END PROC_INSERT_KATEGORIE;

    
    PROCEDURE PROC_UPDATE_KATEGORIE(
        p_id_kategorie    IN NUMBER,
        p_nazev           IN VARCHAR2,
        p_id_nadrazene    IN NUMBER,
        
        o_id_kategorie    OUT NUMBER,
        o_status_code     OUT NUMBER,
        o_status_message  OUT VARCHAR2
    )
    AS
        v_nazev_clean  KATEGORIE.NAZEV%TYPE := TRIM(p_nazev);
        v_existuje     NUMBER;
    BEGIN
        IF FUNC_IS_CYCLIC_HIERARCHY(p_id_kategorie, p_id_nadrazene) THEN
            o_id_kategorie := p_id_kategorie;
            o_status_code := -20; 
            o_status_message := 'Selhání validace: Vzniká cyklická hierarchie.';
            RETURN;
        END IF;
        
        IF p_id_nadrazene IS NOT NULL THEN
            BEGIN
                SELECT 1 INTO v_existuje FROM KATEGORIE WHERE id_kategorie = p_id_nadrazene;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN RAISE PCK_GLOBAL_EXCEPTIONS.E_FK_KATEGORIE_NEEXISTUJE;
            END;
        END IF;

        UPDATE KATEGORIE
        SET nazev = v_nazev_clean,
            id_nadrazene_kategorie = p_id_nadrazene
        WHERE id_kategorie = p_id_kategorie;

        IF SQL%ROWCOUNT = 0 THEN
            PROC_INSERT_KATEGORIE(p_nazev, p_id_nadrazene, o_id_kategorie, o_status_code, o_status_message);
            IF o_status_code = 1 THEN
                o_status_message := 'Úspěch: Záznam nebyl nalezen, byl místo toho vytvořen nový záznam.';
            END IF;
        ELSE
            o_id_kategorie := p_id_kategorie;
            o_status_code := 1;
            o_status_message := 'Úspěch: Operace proběhla úspěšně.';
        END IF;

    EXCEPTION
        WHEN PCK_GLOBAL_EXCEPTIONS.E_FK_KATEGORIE_NEEXISTUJE THEN
            o_id_kategorie := p_id_kategorie; o_status_code := -404;
            o_status_message := 'Selhání cizího klíče: Zadaná nadřazená kategorie neexistuje.';

        WHEN OTHERS THEN
            o_id_kategorie := p_id_kategorie;
            o_status_code := -999; 
            o_status_message := 'Kritická chyba: Neočekávaná chyba: ' || SQLERRM;
    END PROC_UPDATE_KATEGORIE;

    
    PROCEDURE PROC_DELETE_KATEGORIE(
        p_id_kategorie    IN NUMBER,
        
        o_status_code     OUT NUMBER,
        o_status_message  OUT VARCHAR2
    )
    AS
        v_count NUMBER;
    BEGIN
        SELECT COUNT(*)
        INTO v_count
        FROM KATEGORIE
        WHERE id_nadrazene_kategorie = p_id_kategorie;

        IF v_count > 0 THEN
            RAISE PCK_GLOBAL_EXCEPTIONS.E_CANNOT_DELETE_PARENT;
        END IF;
    
        DELETE FROM KATEGORIE WHERE id_kategorie = p_id_kategorie;
        
        IF SQL%ROWCOUNT = 1 THEN
            o_status_code := 1;
            o_status_message := 'Úspěch: Operace proběhla úspěšně.';
        ELSE
            RAISE NO_DATA_FOUND;
        END IF;
        
    EXCEPTION
        WHEN NO_DATA_FOUND THEN 
            o_status_code := 0; 
            o_status_message := 'Selhání odstranění: Záznam nebyl nalezen.';
            
        WHEN PCK_GLOBAL_EXCEPTIONS.E_CANNOT_DELETE_PARENT THEN
            o_status_code := -30; 
            o_status_message := 'Selhání odstranění: Záznam nelze smazat, protože má podřízené prvky.';

        WHEN OTHERS THEN
            o_status_code := -999; 
            o_status_message := 'Kritická chyba: Neočekávaná chyba: ' || SQLERRM;
    END PROC_DELETE_KATEGORIE;
END PCK_KATEGORIE;
/

CREATE OR REPLACE PACKAGE PCK_OBRAZKY AS
    
    PROCEDURE PROC_INSERT_OBRAZEK(
        p_nazev_souboru  IN VARCHAR2,
        p_data           IN BLOB,
        
        o_id_obrazek     OUT NUMBER,
        o_status_code    OUT NUMBER,
        o_status_message OUT VARCHAR2
    );
    
    PROCEDURE PROC_UPDATE_OBRAZEK(
        p_id_obrazek     IN NUMBER,
        p_nazev_souboru  IN VARCHAR2,
        p_data           IN BLOB,
        
        o_id_obrazek     OUT NUMBER,
        o_status_code    OUT NUMBER,
        o_status_message OUT VARCHAR2
    );
    
    PROCEDURE PROC_DELETE_OBRAZEK(
        p_id_obrazek     IN NUMBER,
        
        o_status_code    OUT NUMBER,
        o_status_message OUT VARCHAR2
    );
END PCK_OBRAZKY;
/

CREATE OR REPLACE PACKAGE BODY PCK_OBRAZKY AS
    
    PROCEDURE PROC_INSERT_OBRAZEK(
        p_nazev_souboru  IN VARCHAR2,
        p_data           IN BLOB,
        
        o_id_obrazek     OUT NUMBER,
        o_status_code    OUT NUMBER,
        o_status_message OUT VARCHAR2
    )
    AS
        v_id_obrazek OBRAZKY.ID_OBRAZEK%TYPE;
        v_name_clean OBRAZKY.NAZEV_SOUBORU%TYPE := TRIM(p_nazev_souboru);
    BEGIN
        SELECT id_obrazek
        INTO v_id_obrazek
        FROM OBRAZKY
        WHERE UPPER(nazev_souboru) = UPPER(v_name_clean);
        
        o_id_obrazek := v_id_obrazek;
        o_status_code := 1; -- ZMĚNA: Vrátit 1 (Úspěch) a ID
        o_status_message := 'Úspěch: Záznam již existuje a bylo vráceno jeho ID.';

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            INSERT INTO OBRAZKY(nazev_souboru, data)
            VALUES (v_name_clean, p_data)
            RETURNING id_obrazek INTO o_id_obrazek;
            
            o_status_code := 1;
            o_status_message := 'Úspěch: Operace proběhla úspěšně.';
        
        WHEN OTHERS THEN
            o_id_obrazek := NULL;
            o_status_code := -999; 
            o_status_message := 'Kritická chyba: Neočekávaná chyba: ' || SQLERRM;
    END PROC_INSERT_OBRAZEK;

    PROCEDURE PROC_UPDATE_OBRAZEK(
        p_id_obrazek     IN NUMBER,
        p_nazev_souboru  IN VARCHAR2,
        p_data           IN BLOB,
        
        o_id_obrazek     OUT NUMBER,
        o_status_code    OUT NUMBER,
        o_status_message OUT VARCHAR2
    )
    AS
        v_name_clean OBRAZKY.NAZEV_SOUBORU%TYPE := TRIM(p_nazev_souboru);
    BEGIN
        UPDATE OBRAZKY
        SET nazev_souboru = v_name_clean,
            data = p_data
        WHERE id_obrazek = p_id_obrazek;
        
        IF SQL%ROWCOUNT = 0 THEN
            PROC_INSERT_OBRAZEK(v_name_clean, p_data, o_id_obrazek, o_status_code, o_status_message);
            IF o_status_code = 1 THEN
                o_status_message := 'Úspěch: Záznam nebyl nalezen, byl místo toho vytvořen nový záznam.';
            END IF;
        ELSE
            o_id_obrazek := p_id_obrazek;
            o_status_code := 1;
            o_status_message := 'Úspěch: Operace proběhla úspěšně.';
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            o_id_obrazek := p_id_obrazek;
            o_status_code := -999; 
            o_status_message := 'Kritická chyba: Neočekávaná chyba: ' || SQLERRM;
    END PROC_UPDATE_OBRAZEK;
    
    PROCEDURE PROC_DELETE_OBRAZEK(
        p_id_obrazek     IN NUMBER,
        
        o_status_code    OUT NUMBER,
        o_status_message OUT VARCHAR2
    )
    AS
    BEGIN
        DELETE FROM OBRAZKY
        WHERE id_obrazek = p_id_obrazek;
        
        IF SQL%ROWCOUNT = 1 THEN
            o_status_code := 1;
            o_status_message := 'Úspěch: Operace proběhla úspěšně.';
        ELSE
            RAISE NO_DATA_FOUND;
        END IF;
        
    EXCEPTION
        WHEN NO_DATA_FOUND THEN    
            o_status_code := 0; 
            o_status_message := 'Selhání odstranění: Záznam nebyl nalezen.';
            
        WHEN OTHERS THEN
            o_status_code := -999; 
            o_status_message := 'Kritická chyba: Neočekávaná chyba: ' || SQLERRM;
    END PROC_DELETE_OBRAZEK;
END PCK_OBRAZKY;
/

CREATE OR REPLACE PACKAGE PCK_OPRAVNENI AS
    PROCEDURE PROC_INSERT_OPRAVNENI(
        p_nazev IN VARCHAR2,
        p_uroven IN NUMBER,
        
        o_id_opravneni OUT NUMBER,
        o_status_code OUT NUMBER,
        o_status_message OUT VARCHAR2
    );
    
    PROCEDURE PROC_UPDATE_OPRAVNENI(
        p_id_opravneni IN NUMBER,
        p_nazev IN VARCHAR2,
        p_uroven IN NUMBER,
        
        o_id_opravneni OUT NUMBER,
        o_status_code OUT NUMBER,
        o_status_message OUT VARCHAR2
    );
    
    PROCEDURE PROC_DELETE_OPRAVNENI(
        p_id_opravneni IN NUMBER,
        
        o_status_code OUT NUMBER,
        o_status_message OUT VARCHAR2
    );
END PCK_OPRAVNENI;
/

CREATE OR REPLACE PACKAGE BODY PCK_OPRAVNENI AS
    PROCEDURE PROC_INSERT_OPRAVNENI(
        p_nazev IN VARCHAR2,
        p_uroven IN NUMBER,
        
        o_id_opravneni OUT NUMBER,
        o_status_code OUT NUMBER,
        o_status_message OUT VARCHAR2
    )
    AS
        v_id_opravneni OPRAVNENI.ID_OPRAVNENI%TYPE;
        v_nazev_clean OPRAVNENI.NAZEV%TYPE := TRIM(p_nazev);
    BEGIN
        IF p_uroven NOT IN (0, 1, 2, 3) THEN
            RAISE PCK_GLOBAL_EXCEPTIONS.E_INVALID_UROVEN;
        END IF;
        
        SELECT id_opravneni
        INTO v_id_opravneni
        FROM OPRAVNENI
        WHERE UPPER(nazev) = UPPER(v_nazev_clean);
        
        o_id_opravneni := v_id_opravneni;
        o_status_code := 1; -- ZMĚNA: Vrátit 1 (Úspěch) a ID
        o_status_message := 'Úspěch: Záznam již existuje a bylo vráceno jeho ID.';

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            INSERT INTO OPRAVNENI(nazev, uroven)
            VALUES(v_nazev_clean, p_uroven)
            RETURNING id_opravneni INTO o_id_opravneni;
            
            o_status_code := 1;
            o_status_message := 'Úspěch: Operace proběhla úspěšně.';
        
        WHEN PCK_GLOBAL_EXCEPTIONS.E_INVALID_UROVEN THEN
            o_id_opravneni := NULL;
            o_status_code := -20; 
            o_status_message := 'Selhání validace: Úroveň oprávnění musí být 0, 1, 2 nebo 3.';
            
        WHEN OTHERS THEN
            o_id_opravneni := NULL;
            o_status_code := -999; 
            o_status_message := 'Kritická chyba: Neočekávaná chyba: ' || SQLERRM;
    END PROC_INSERT_OPRAVNENI;

    PROCEDURE PROC_UPDATE_OPRAVNENI(
        p_id_opravneni IN NUMBER,
        p_nazev IN VARCHAR2,
        p_uroven IN NUMBER,
        
        o_id_opravneni OUT NUMBER,
        o_status_code OUT NUMBER,
        o_status_message OUT VARCHAR2
    )
    AS
        v_nazev_clean OPRAVNENI.NAZEV%TYPE := TRIM(p_nazev);
    BEGIN
        IF p_uroven NOT IN (0, 1, 2, 3) THEN
            RAISE PCK_GLOBAL_EXCEPTIONS.E_INVALID_UROVEN;
        END IF;
        
        UPDATE OPRAVNENI
        SET nazev = v_nazev_clean,
            uroven = p_uroven
        WHERE id_opravneni = p_id_opravneni;
        
        IF SQL%ROWCOUNT = 0 THEN
            PROC_INSERT_OPRAVNENI(v_nazev_clean, p_uroven, o_id_opravneni, o_status_code, o_status_message);
            IF o_status_code = 1 THEN
                o_status_message := 'Úspěch: Záznam nebyl nalezen, byl místo toho vytvořen nový záznam.';
            END IF;
        ELSE
            o_id_opravneni := p_id_opravneni;
            o_status_code := 1;
            o_status_message := 'Úspěch: Operace proběhla úspěšně.';
        END IF;
        
    EXCEPTION
        WHEN PCK_GLOBAL_EXCEPTIONS.E_INVALID_UROVEN THEN
            o_id_opravneni := p_id_opravneni;
            o_status_code := -20; 
            o_status_message := 'Selhání validace: Úroveň oprávnění musí být 0, 1, 2 nebo 3.';
            
        WHEN OTHERS THEN
            o_id_opravneni := p_id_opravneni;
            o_status_code := -999; 
            o_status_message := 'Kritická chyba: Neočekávaná chyba: ' || SQLERRM;
    END PROC_UPDATE_OPRAVNENI;

    PROCEDURE PROC_DELETE_OPRAVNENI(
        p_id_opravneni IN NUMBER,
        
        o_status_code OUT NUMBER,
        o_status_message OUT VARCHAR2
    )
    AS
    BEGIN
        DELETE FROM OPRAVNENI
        WHERE id_opravneni = p_id_opravneni;
        
        IF SQL%ROWCOUNT = 1 THEN
            o_status_code := 1;
            o_status_message := 'Úspěch: Operace proběhla úspěšně.';
        ELSE
            RAISE NO_DATA_FOUND;
        END IF;
        
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            o_status_code := 0; 
            o_status_message := 'Selhání odstranění: Záznam nebyl nalezen.';
            
        WHEN OTHERS THEN
            o_status_code := -999; 
            o_status_message := 'Kritická chyba: Neočekávaná chyba: ' || SQLERRM;
    END PROC_DELETE_OPRAVNENI;
END PCK_OPRAVNENI;
/

CREATE OR REPLACE PACKAGE PCK_PLATBY AS
    PROCEDURE PROC_INSERT_PLATBA(
        p_nazev IN VARCHAR2,
        
        o_id_zpusob_platby OUT NUMBER,
        o_status_code OUT NUMBER,
        o_status_message OUT VARCHAR2
    );
    
    PROCEDURE PROC_UPDATE_PLATBA(
        p_id_zpusob_platby IN NUMBER,
        p_nazev IN VARCHAR2,
        
        o_id_zpusob_platby OUT NUMBER,
        o_status_code OUT NUMBER,
        o_status_message OUT VARCHAR2
    );
    
    PROCEDURE PROC_DELETE_PLATBA(
        p_id_zpusob_platby IN NUMBER,
        
        o_status_code OUT NUMBER,
        o_status_message OUT VARCHAR2
    );
END PCK_PLATBY;
/

CREATE OR REPLACE PACKAGE BODY PCK_PLATBY AS
    PROCEDURE PROC_INSERT_PLATBA(
        p_nazev IN VARCHAR2,
        
        o_id_zpusob_platby OUT NUMBER,
        o_status_code OUT NUMBER,
        o_status_message OUT VARCHAR2
    )
    AS
        v_id_zpusob_platby ZPUSOBYPLATEB.ID_ZPUSOB_PLATBY%TYPE;
        v_nazev_clean ZPUSOBYPLATEB.NAZEV%TYPE := TRIM(p_nazev);
    BEGIN
        SELECT id_zpusob_platby
        INTO v_id_zpusob_platby
        FROM ZPUSOBYPLATEB
        WHERE UPPER(nazev) = UPPER(v_nazev_clean);
        
        o_id_zpusob_platby := v_id_zpusob_platby;
        o_status_code := 1; -- ZMĚNA: Vrátit 1 (Úspěch) a ID
        o_status_message := 'Úspěch: Záznam již existuje a bylo vráceno jeho ID.';

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            INSERT INTO ZPUSOBYPLATEB(nazev)
            VALUES(v_nazev_clean)
            RETURNING id_zpusob_platby INTO o_id_zpusob_platby;
            
            o_status_code := 1;
            o_status_message := 'Úspěch: Operace proběhla úspěšně.';
        
        WHEN OTHERS THEN
            o_id_zpusob_platby := NULL;
            o_status_code := -999; 
            o_status_message := 'Kritická chyba: Neočekávaná chyba: ' || SQLERRM;
    END PROC_INSERT_PLATBA;

    PROCEDURE PROC_UPDATE_PLATBA(
        p_id_zpusob_platby IN NUMBER,
        p_nazev IN VARCHAR2,
        
        o_id_zpusob_platby OUT NUMBER,
        o_status_code OUT NUMBER,
        o_status_message OUT VARCHAR2
    )
    AS
        v_nazev_clean ZPUSOBYPLATEB.NAZEV%TYPE := TRIM(p_nazev);
    BEGIN
        UPDATE ZPUSOBYPLATEB
        SET nazev = v_nazev_clean
        WHERE id_zpusob_platby = p_id_zpusob_platby;
        
        IF SQL%ROWCOUNT = 0 THEN
            PROC_INSERT_PLATBA(v_nazev_clean, o_id_zpusob_platby, o_status_code, o_status_message);
            IF o_status_code = 1 THEN
                o_status_message := 'Úspěch: Záznam nebyl nalezen, byl místo toho vytvořen nový záznam.';
            END IF;
        ELSE
            o_id_zpusob_platby := p_id_zpusob_platby;
            o_status_code := 1;
            o_status_message := 'Úspěch: Operace proběhla úspěšně.';
        END IF;
        
    EXCEPTION
        WHEN OTHERS THEN
            o_id_zpusob_platby := p_id_zpusob_platby;
            o_status_code := -999; 
            o_status_message := 'Kritická chyba: Neočekávaná chyba: ' || SQLERRM;
    END PROC_UPDATE_PLATBA;

    PROCEDURE PROC_DELETE_PLATBA(
        p_id_zpusob_platby IN NUMBER,
        
        o_status_code OUT NUMBER,
        o_status_message OUT VARCHAR2
    )
    AS
    BEGIN
        DELETE FROM ZPUSOBYPLATEB
        WHERE id_zpusob_platby = p_id_zpusob_platby;
        
        IF SQL%ROWCOUNT = 1 THEN
            o_status_code := 1;
            o_status_message := 'Úspěch: Operace proběhla úspěšně.';
        ELSE
            RAISE NO_DATA_FOUND;
        END IF;
        
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            o_status_code := 0; 
            o_status_message := 'Selhání odstranění: Záznam nebyl nalezen.';
            
        WHEN OTHERS THEN
            o_status_code := -999; 
            o_status_message := 'Kritická chyba: Neočekávaná chyba: ' || SQLERRM;
    END PROC_DELETE_PLATBA;
END PCK_PLATBY;
/

CREATE OR REPLACE PACKAGE PCK_STAVYOBJEDNAVEK AS
    PROCEDURE PROC_INSERT_STAV(
        p_nazev IN VARCHAR2,
        
        o_id_stav_objednavky OUT NUMBER,
        o_status_code OUT NUMBER,
        o_status_message OUT VARCHAR2
    );
    
    PROCEDURE PROC_UPDATE_STAV(
        p_id_stav_objednavky IN NUMBER,
        p_nazev IN VARCHAR2,
        
        o_id_stav_objednavky OUT NUMBER,
        o_status_code OUT NUMBER,
        o_status_message OUT VARCHAR2
    );
    
    PROCEDURE PROC_DELETE_STAV(
        p_id_stav_objednavky IN NUMBER,
        
        o_status_code OUT NUMBER,
        o_status_message OUT VARCHAR2
    );
END PCK_STAVYOBJEDNAVEK;
/

CREATE OR REPLACE PACKAGE BODY PCK_STAVYOBJEDNAVEK AS
    PROCEDURE PROC_INSERT_STAV(
        p_nazev IN VARCHAR2,
        
        o_id_stav_objednavky OUT NUMBER,
        o_status_code OUT NUMBER,
        o_status_message OUT VARCHAR2
    )
    AS
        v_id_stav STAVYOBJEDNAVEK.ID_STAV_OBJEDNAVKY%TYPE;
        v_nazev_clean STAVYOBJEDNAVEK.NAZEV%TYPE := TRIM(p_nazev);
    BEGIN
        SELECT id_stav_objednavky
        INTO v_id_stav
        FROM STAVYOBJEDNAVEK
        WHERE UPPER(nazev) = UPPER(v_nazev_clean);
        
        o_id_stav_objednavky := v_id_stav;
        o_status_code := 1; -- ZMĚNA: Vrátit 1 (Úspěch) a ID
        o_status_message := 'Úspěch: Záznam již existuje a bylo vráceno jeho ID.';
        
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            INSERT INTO STAVYOBJEDNAVEK(nazev)
            VALUES(v_nazev_clean)
            RETURNING id_stav_objednavky INTO o_id_stav_objednavky;
            
            o_status_code := 1;
            o_status_message := 'Úspěch: Operace proběhla úspěšně.';
        
        WHEN OTHERS THEN
            o_id_stav_objednavky := NULL;
            o_status_code := -999; 
            o_status_message := 'Kritická chyba: Neočekávaná chyba: ' || SQLERRM;
    END PROC_INSERT_STAV;

    PROCEDURE PROC_UPDATE_STAV(
        p_id_stav_objednavky IN NUMBER,
        p_nazev IN VARCHAR2,
        
        o_id_stav_objednavky OUT NUMBER,
        o_status_code OUT NUMBER,
        o_status_message OUT VARCHAR2
    )
    AS
        v_nazev_clean STAVYOBJEDNAVEK.NAZEV%TYPE := TRIM(p_nazev);
    BEGIN
        UPDATE STAVYOBJEDNAVEK
        SET nazev = v_nazev_clean
        WHERE id_stav_objednavky = p_id_stav_objednavky;
        
        IF SQL%ROWCOUNT = 0 THEN
            PROC_INSERT_STAV(v_nazev_clean, o_id_stav_objednavky, o_status_code, o_status_message);
            IF o_status_code = 1 THEN
                o_status_message := 'Úspěch: Záznam nebyl nalezen, byl místo toho vytvořen nový záznam.';
            END IF;
        ELSE
            o_id_stav_objednavky := p_id_stav_objednavky;
            o_status_code := 1;
            o_status_message := 'Úspěch: Operace proběhla úspěšně.';
        END IF;
        
    EXCEPTION
        WHEN OTHERS THEN
            o_id_stav_objednavky := p_id_stav_objednavky;
            o_status_code := -999; 
            o_status_message := 'Kritická chyba: Neočekávaná chyba: ' || SQLERRM;
    END PROC_UPDATE_STAV;

    PROCEDURE PROC_DELETE_STAV(
        p_id_stav_objednavky IN NUMBER,
        
        o_status_code OUT NUMBER,
        o_status_message OUT VARCHAR2
    )
    AS
    BEGIN
        DELETE FROM STAVYOBJEDNAVEK
        WHERE id_stav_objednavky = p_id_stav_objednavky;
        
        IF SQL%ROWCOUNT = 1 THEN
            o_status_code := 1;
            o_status_message := 'Úspěch: Operace proběhla úspěšně.';
        ELSE
            RAISE NO_DATA_FOUND;
        END IF;
        
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            o_status_code := 0; 
            o_status_message := 'Selhání odstranění: Záznam nebyl nalezen.';
            
        WHEN OTHERS THEN
            o_status_code := -999; 
            o_status_message := 'Kritická chyba: Neočekávaná chyba: ' || SQLERRM;
    END PROC_DELETE_STAV;
END PCK_STAVYOBJEDNAVEK;
/

CREATE OR REPLACE PACKAGE PCK_KVETINY AS
    PROCEDURE PROC_INSERT_KVETINA(
        p_nazev IN VARCHAR2,
        p_cena IN NUMBER,
        p_id_kategorie IN NUMBER,
        p_id_obrazek IN NUMBER,
        
        o_id_kvetina OUT NUMBER,
        o_status_code OUT NUMBER,
        o_status_message OUT VARCHAR2
    );
    
    PROCEDURE PROC_UPDATE_KVETINA(
        p_id_kvetina IN NUMBER,
        p_nazev IN VARCHAR2,
        p_cena IN NUMBER,
        p_id_kategorie IN NUMBER,
        p_id_obrazek IN NUMBER,
        
        o_id_kvetina OUT NUMBER,
        o_status_code OUT NUMBER,
        o_status_message OUT VARCHAR2
    );
    
    PROCEDURE PROC_DELETE_KVETINA(
        p_id_kvetina IN NUMBER,
        
        o_status_code OUT NUMBER,
        o_status_message OUT VARCHAR2
    );
END PCK_KVETINY;
/

CREATE OR REPLACE PACKAGE BODY PCK_KVETINY AS
    v_existuje NUMBER;
    
    PROCEDURE CHECK_FOREIGN_KEYS(
        p_id_kategorie IN NUMBER,
        p_id_obrazek IN NUMBER
    )
    AS
    BEGIN
        BEGIN
            SELECT 1 INTO v_existuje FROM KATEGORIE WHERE id_kategorie = p_id_kategorie;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN RAISE PCK_GLOBAL_EXCEPTIONS.E_FK_KATEGORIE_NEEXISTUJE;
        END;
        
        IF p_id_obrazek IS NOT NULL THEN
            BEGIN
                SELECT 1 INTO v_existuje FROM OBRAZKY WHERE id_obrazek = p_id_obrazek;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN RAISE PCK_GLOBAL_EXCEPTIONS.E_FK_OBRAZEK_NEEXISTUJE;
            END;
        END IF;
    END CHECK_FOREIGN_KEYS;

    PROCEDURE PROC_INSERT_KVETINA(
        p_nazev IN VARCHAR2,
        p_cena IN NUMBER,
        p_id_kategorie IN NUMBER,
        p_id_obrazek IN NUMBER,
        
        o_id_kvetina OUT NUMBER,
        o_status_code OUT NUMBER,
        o_status_message OUT VARCHAR2
    )
    AS
        v_id_kvetina KVETINY.ID_KVETINA%TYPE;
        v_nazev_clean KVETINY.NAZEV%TYPE := TRIM(p_nazev);
    BEGIN
        -- Check if flower already exists (using unique index on nazev, cena, id_kategorie for example)
        SELECT id_kvetina
        INTO v_id_kvetina
        FROM KVETINY
        WHERE UPPER(nazev) = UPPER(v_nazev_clean) 
          AND cena = p_cena 
          AND id_kategorie = p_id_kategorie;
        
        o_id_kvetina := v_id_kvetina;
        o_status_code := 1; -- ZMĚNA: Vrátit 1 (Úspěch) a ID
        o_status_message := 'Úspěch: Záznam již existuje a bylo vráceno jeho ID.';
        
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            CHECK_FOREIGN_KEYS(p_id_kategorie, p_id_obrazek);
            
            INSERT INTO KVETINY(nazev, cena, id_kategorie, id_obrazek)
            VALUES (v_nazev_clean, p_cena, p_id_kategorie, p_id_obrazek)
            RETURNING id_kvetina INTO o_id_kvetina;
            
            o_status_code := 1;
            o_status_message := 'Úspěch: Operace proběhla úspěšně.';
            
        WHEN PCK_GLOBAL_EXCEPTIONS.E_FK_KATEGORIE_NEEXISTUJE THEN
            o_id_kvetina := NULL; o_status_code := -404;
            o_status_message := 'Selhání cizího klíče: Zadaná kategorie neexistuje.';
            
        WHEN PCK_GLOBAL_EXCEPTIONS.E_FK_OBRAZEK_NEEXISTUJE THEN
            o_id_kvetina := NULL; o_status_code := -407;
            o_status_message := 'Selhání cizího klíče: Zadaný obrázek neexistuje.';

        WHEN OTHERS THEN
            o_id_kvetina := NULL;
            o_status_code := -999; 
            o_status_message := 'Kritická chyba: Neočekávaná chyba: ' || SQLERRM;
    END PROC_INSERT_KVETINA;

    PROCEDURE PROC_UPDATE_KVETINA(
        p_id_kvetina IN NUMBER,
        p_nazev IN VARCHAR2,
        p_cena IN NUMBER,
        p_id_kategorie IN NUMBER,
        p_id_obrazek IN NUMBER,
        
        o_id_kvetina OUT NUMBER,
        o_status_code OUT NUMBER,
        o_status_message OUT VARCHAR2
    )
    AS
        v_nazev_clean KVETINY.NAZEV%TYPE := TRIM(p_nazev);
    BEGIN
        CHECK_FOREIGN_KEYS(p_id_kategorie, p_id_obrazek);
        
        UPDATE KVETINY
        SET nazev = v_nazev_clean,
            cena = p_cena,
            id_kategorie = p_id_kategorie,
            id_obrazek = p_id_obrazek
        WHERE id_kvetina = p_id_kvetina;
        
        IF SQL%ROWCOUNT = 0 THEN
            PROC_INSERT_KVETINA(v_nazev_clean, p_cena, p_id_kategorie, p_id_obrazek, o_id_kvetina, o_status_code, o_status_message);
            IF o_status_code = 1 THEN
                o_status_message := 'Úspěch: Záznam nebyl nalezen, byl místo toho vytvořen nový záznam.';
            END IF;
        ELSE
            o_id_kvetina := p_id_kvetina;
            o_status_code := 1;
            o_status_message := 'Úspěch: Operace proběhla úspěšně.';
        END IF;
        
    EXCEPTION
        WHEN PCK_GLOBAL_EXCEPTIONS.E_FK_KATEGORIE_NEEXISTUJE THEN
            o_id_kvetina := p_id_kvetina; o_status_code := -404;
            o_status_message := 'Selhání cizího klíče: Zadaná kategorie neexistuje.';
            
        WHEN PCK_GLOBAL_EXCEPTIONS.E_FK_OBRAZEK_NEEXISTUJE THEN
            o_id_kvetina := p_id_kvetina; o_status_code := -407;
            o_status_message := 'Selhání cizího klíče: Zadaný obrázek neexistuje.';

        WHEN OTHERS THEN
            o_id_kvetina := p_id_kvetina;
            o_status_code := -999; 
            o_status_message := 'Kritická chyba: Neočekávaná chyba: ' || SQLERRM;
    END PROC_UPDATE_KVETINA;

    PROCEDURE PROC_DELETE_KVETINA(
        p_id_kvetina IN NUMBER,
        
        o_status_code OUT NUMBER,
        o_status_message OUT VARCHAR2
    )
    AS
    BEGIN
        DELETE FROM KVETINY
        WHERE id_kvetina = p_id_kvetina;
        
        IF SQL%ROWCOUNT = 1 THEN
            o_status_code := 1;
            o_status_message := 'Úspěch: Operace proběhla úspěšně.';
        ELSE
            RAISE NO_DATA_FOUND;
        END IF;
        
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            o_status_code := 0; 
            o_status_message := 'Selhání odstranění: Záznam nebyl nalezen.';
            
        WHEN OTHERS THEN
            o_status_code := -999; 
            o_status_message := 'Kritická chyba: Neočekávaná chyba: ' || SQLERRM;
    END PROC_DELETE_KVETINA;
END PCK_KVETINY;
/

CREATE OR REPLACE PACKAGE PCK_KOSIKY AS
    PROCEDURE PROC_INSERT_KOSIK(
        p_cena            IN NUMBER,
        p_sleva           IN NUMBER,
        p_id_uzivatel     IN NUMBER,
        p_id_stav         IN NUMBER,
        p_id_platba       IN NUMBER,
        
        o_id_kosik        OUT NUMBER,
        o_status_code     OUT NUMBER,
        o_status_message  OUT VARCHAR2
    );
    
    PROCEDURE PROC_UPDATE_KOSIK(
        p_id_kosik        IN NUMBER,
        p_cena            IN NUMBER,
        p_sleva           IN NUMBER,
        p_id_uzivatel     IN NUMBER,
        p_id_stav         IN NUMBER,
        p_id_platba       IN NUMBER,
        
        o_id_kosik        OUT NUMBER,
        o_status_code     OUT NUMBER,
        o_status_message  OUT VARCHAR2
    );
    
    PROCEDURE PROC_DELETE_KOSIK(
        p_id_kosik        IN NUMBER,
        
        o_status_code     OUT NUMBER,
        o_status_message  OUT VARCHAR2
    );
END PCK_KOSIKY;
/

CREATE OR REPLACE PACKAGE BODY PCK_KOSIKY AS
    v_existuje NUMBER;
    
    PROCEDURE CHECK_FOREIGN_KEYS(
        p_id_uzivatel IN NUMBER,
        p_id_stav IN NUMBER,
        p_id_platba IN NUMBER
    )
    AS
    BEGIN
        BEGIN
            SELECT 1 INTO v_existuje FROM UZIVATELE WHERE id_uzivatel = p_id_uzivatel;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN RAISE PCK_GLOBAL_EXCEPTIONS.E_FK_UZIVATEL_NEEXISTUJE;
        END;
        
        BEGIN
            SELECT 1 INTO v_existuje FROM STAVYOBJEDNAVEK WHERE id_stav_objednavky = p_id_stav;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN RAISE PCK_GLOBAL_EXCEPTIONS.E_FK_STAV_OBJEDNAVKY_NEEXISTUJE;
        END;
        
        BEGIN
            SELECT 1 INTO v_existuje FROM ZPUSOBYPLATEB WHERE id_zpusob_platby = p_id_platba;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN RAISE PCK_GLOBAL_EXCEPTIONS.E_FK_ZPUSOB_PLATBY_NEEXISTUJE;
        END;
    END CHECK_FOREIGN_KEYS;

    PROCEDURE PROC_INSERT_KOSIK(
        p_cena            IN NUMBER,
        p_sleva           IN NUMBER,
        p_id_uzivatel     IN NUMBER,
        p_id_stav         IN NUMBER,
        p_id_platba       IN NUMBER,
        
        o_id_kosik        OUT NUMBER,
        o_status_code     OUT NUMBER,
        o_status_message  OUT VARCHAR2
    )
    AS
    BEGIN
        CHECK_FOREIGN_KEYS(p_id_uzivatel, p_id_stav, p_id_platba);
        
        -- Kosik is an order, which is always newly inserted. No uniqueness check is needed.
        INSERT INTO KOSIKY(cena, sleva, id_uzivatel, id_stav_objednavky, id_zpusob_platby)
        VALUES (p_cena, p_sleva, p_id_uzivatel, p_id_stav, p_id_platba)
        RETURNING id_kosik INTO o_id_kosik;
        
        o_status_code := 1;
        o_status_message := 'Úspěch: Operace proběhla úspěšně.';

    EXCEPTION
        WHEN PCK_GLOBAL_EXCEPTIONS.E_FK_UZIVATEL_NEEXISTUJE THEN
            o_id_kosik := NULL; o_status_code := -411;
            o_status_message := 'Selhání cizího klíče: Zadaný uživatel neexistuje.';
            
        WHEN PCK_GLOBAL_EXCEPTIONS.E_FK_STAV_OBJEDNAVKY_NEEXISTUJE THEN
            o_id_kosik := NULL; o_status_code := -412;
            o_status_message := 'Selhání cizího klíče: Zadaný stav objednávky neexistuje.';
            
        WHEN PCK_GLOBAL_EXCEPTIONS.E_FK_ZPUSOB_PLATBY_NEEXISTUJE THEN
            o_id_kosik := NULL; o_status_code := -413;
            o_status_message := 'Selhání cizího klíče: Zadaný způsob platby neexistuje.';

        WHEN OTHERS THEN
            o_id_kosik := NULL;
            o_status_code := -999; 
            o_status_message := 'Kritická chyba: Neočekávaná chyba: ' || SQLERRM;
    END PROC_INSERT_KOSIK;
    
    PROCEDURE PROC_UPDATE_KOSIK(
        p_id_kosik        IN NUMBER,
        p_cena            IN NUMBER,
        p_sleva           IN NUMBER,
        p_id_uzivatel     IN NUMBER,
        p_id_stav         IN NUMBER,
        p_id_platba       IN NUMBER,
        
        o_id_kosik        OUT NUMBER,
        o_status_code     OUT NUMBER,
        o_status_message  OUT VARCHAR2
    )
    AS
    BEGIN
        CHECK_FOREIGN_KEYS(p_id_uzivatel, p_id_stav, p_id_platba);
        
        UPDATE KOSIKY
        SET cena = p_cena,
            sleva = p_sleva,
            id_uzivatel = p_id_uzivatel,
            id_stav_objednavky = p_id_stav,
            id_zpusob_platby = p_id_platba
        WHERE id_kosik = p_id_kosik;
        
        IF SQL%ROWCOUNT = 0 THEN
            PROC_INSERT_KOSIK(p_cena, p_sleva, p_id_uzivatel, p_id_stav, p_id_platba, o_id_kosik, o_status_code, o_status_message);
            IF o_status_code = 1 THEN
                o_status_message := 'Úspěch: Záznam nebyl nalezen, byl místo toho vytvořen nový záznam.';
            END IF;
        ELSE
            o_id_kosik := p_id_kosik;
            o_status_code := 1;
            o_status_message := 'Úspěch: Operace proběhla úspěšně.';
        END IF;
        
    EXCEPTION
        WHEN PCK_GLOBAL_EXCEPTIONS.E_FK_UZIVATEL_NEEXISTUJE THEN
            o_id_kosik := p_id_kosik; o_status_code := -411;
            o_status_message := 'Selhání cizího klíče: Zadaný uživatel neexistuje.';
            
        WHEN PCK_GLOBAL_EXCEPTIONS.E_FK_STAV_OBJEDNAVKY_NEEXISTUJE THEN
            o_id_kosik := p_id_kosik; o_status_code := -412;
            o_status_message := 'Selhání cizího klíče: Zadaný stav objednávky neexistuje.';
            
        WHEN PCK_GLOBAL_EXCEPTIONS.E_FK_ZPUSOB_PLATBY_NEEXISTUJE THEN
            o_id_kosik := p_id_kosik; o_status_code := -413;
            o_status_message := 'Selhání cizího klíče: Zadaný způsob platby neexistuje.';

        WHEN OTHERS THEN
            o_id_kosik := p_id_kosik;
            o_status_code := -999; 
            o_status_message := 'Kritická chyba: Neočekávaná chyba: ' || SQLERRM;
    END PROC_UPDATE_KOSIK;

    PROCEDURE PROC_DELETE_KOSIK(
        p_id_kosik        IN NUMBER,
        
        o_status_code     OUT NUMBER,
        o_status_message  OUT VARCHAR2
    )
    AS
    BEGIN
        DELETE FROM KOSIKY
        WHERE id_kosik = p_id_kosik;
        
        IF SQL%ROWCOUNT = 1 THEN
            o_status_code := 1;
            o_status_message := 'Úspěch: Operace proběhla úspěšně.';
        ELSE
            RAISE NO_DATA_FOUND;
        END IF;
        
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            o_status_code := 0; 
            o_status_message := 'Selhání odstranění: Záznam nebyl nalezen.';
            
        WHEN OTHERS THEN
            o_status_code := -999; 
            o_status_message := 'Kritická chyba: Neočekávaná chyba: ' || SQLERRM;
    END PROC_DELETE_KOSIK;
END PCK_KOSIKY;
/

CREATE OR REPLACE PACKAGE PCK_UZIVATELE AS
    FUNCTION FUNC_IS_EMAIL_UNIQUE(
        p_email IN VARCHAR2 
    )
    RETURN BOOLEAN;

    PROCEDURE PROC_INSERT_UZIVATEL(
        p_email IN VARCHAR2,
        p_pw_hash IN CHAR,
        p_salt IN CHAR,
        p_id_opravneni IN NUMBER,
        p_id_obrazek IN NUMBER,
        p_id_adresa IN NUMBER,
        
        o_id_uzivatel OUT NUMBER,
        o_status_code OUT NUMBER,
        o_status_message OUT VARCHAR2
    );
    
    PROCEDURE PROC_UPDATE_UZIVATEL(
        p_id_uzivatel IN NUMBER,
        p_email IN VARCHAR2,
        p_pw_hash IN CHAR,
        p_salt IN CHAR,
        p_id_opravneni IN NUMBER,
        p_id_obrazek IN NUMBER,
        p_id_adresa IN NUMBER,
        
        o_id_uzivatel OUT NUMBER,
        o_status_code OUT NUMBER,
        o_status_message OUT VARCHAR2
    );
    
    PROCEDURE PROC_DELETE_UZIVATEL(
        p_id_uzivatel IN NUMBER,
        
        o_status_code OUT NUMBER,
        o_status_message OUT VARCHAR2
    );
END PCK_UZIVATELE;
/

CREATE OR REPLACE PACKAGE BODY PCK_UZIVATELE AS
    v_existuje NUMBER;

    FUNCTION FUNC_IS_EMAIL_UNIQUE(
        p_email IN VARCHAR2
    )
    RETURN BOOLEAN
    AS
        v_count NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_count
        FROM UZIVATELE
        WHERE UPPER(email) = UPPER(TRIM(p_email));
        RETURN v_count = 0;
    END FUNC_IS_EMAIL_UNIQUE;

    PROCEDURE CHECK_FOREIGN_KEYS(
        p_id_opravneni IN NUMBER,
        p_id_obrazek IN NUMBER,
        p_id_adresa IN NUMBER
    )
    AS
    BEGIN
        BEGIN
            SELECT 1 INTO v_existuje FROM OPRAVNENI WHERE id_opravneni = p_id_opravneni;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN RAISE PCK_GLOBAL_EXCEPTIONS.E_FK_OPRAVNENI_NEEXISTUJE;
        END;
        
        IF p_id_obrazek IS NOT NULL THEN
            BEGIN
                SELECT 1 INTO v_existuje FROM OBRAZKY WHERE id_obrazek = p_id_obrazek;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN RAISE PCK_GLOBAL_EXCEPTIONS.E_FK_OBRAZEK_NEEXISTUJE;
            END;
        END IF;

        IF p_id_adresa IS NOT NULL THEN
            BEGIN
                SELECT 1 INTO v_existuje FROM ADRESY WHERE id_adresa = p_id_adresa;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN RAISE PCK_GLOBAL_EXCEPTIONS.E_FK_ADRESA_NEEXISTUJE;
            END;
        END IF;
    END CHECK_FOREIGN_KEYS;

    PROCEDURE PROC_INSERT_UZIVATEL(
        p_email IN VARCHAR2,
        p_pw_hash IN CHAR,
        p_salt IN CHAR,
        p_id_opravneni IN NUMBER,
        p_id_obrazek IN NUMBER,
        p_id_adresa IN NUMBER,
        
        o_id_uzivatel OUT NUMBER,
        o_status_code OUT NUMBER,
        o_status_message OUT VARCHAR2
    )
    AS
        v_id_uzivatel UZIVATELE.ID_UZIVATEL%TYPE;
        v_email_clean UZIVATELE.EMAIL%TYPE := TRIM(p_email);
    BEGIN
        IF REGEXP_LIKE(v_email_clean, '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$') = FALSE THEN
            RAISE PCK_GLOBAL_EXCEPTIONS.E_NEPLATNY_FORMAT_EMAILU;
        END IF;

        -- NEW LOGIC: Check if user already exists based on email
        SELECT id_uzivatel
        INTO v_id_uzivatel
        FROM UZIVATELE
        WHERE UPPER(email) = UPPER(v_email_clean);
        
        o_id_uzivatel := v_id_uzivatel;
        o_status_code := 1; 
        o_status_message := 'Úspěch: Záznam již existuje a bylo vráceno jeho ID.';
        
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            -- If not found, then insert.
            CHECK_FOREIGN_KEYS(p_id_opravneni, p_id_obrazek, p_id_adresa);
            
            INSERT INTO UZIVATELE(email, pw_hash, salt, id_opravneni, id_obrazek, id_adresa)
            VALUES (v_email_clean, p_pw_hash, p_salt, p_id_opravneni, p_id_obrazek, p_id_adresa)
            RETURNING id_uzivatel INTO o_id_uzivatel;
            
            o_status_code := 1;
            o_status_message := 'Úspěch: Operace proběhla úspěšně.';

        WHEN PCK_GLOBAL_EXCEPTIONS.E_NEPLATNY_FORMAT_EMAILU THEN
            o_id_uzivatel := NULL;
            o_status_code := -23; 
            o_status_message := 'Selhání validace: Neplatný formát emailu.';

        WHEN PCK_GLOBAL_EXCEPTIONS.E_FK_OPRAVNENI_NEEXISTUJE THEN
            o_id_uzivatel := NULL;
            o_status_code := -420; 
            o_status_message := 'Selhání cizího klíče: Zadané ID oprávnění neexistuje.';

        WHEN PCK_GLOBAL_EXCEPTIONS.E_FK_OBRAZEK_NEEXISTUJE THEN
            o_id_uzivatel := NULL;
            o_status_code := -407; 
            o_status_message := 'Selhání cizího klíče: Zadané ID obrázku neexistuje.';

        WHEN PCK_GLOBAL_EXCEPTIONS.E_FK_ADRESA_NEEXISTUJE THEN
            o_id_uzivatel := NULL;
            o_status_code := -422; 
            o_status_message := 'Selhání cizího klíče: Zadané ID adresy neexistuje.';
            
        WHEN OTHERS THEN
            o_id_uzivatel := NULL;
            o_status_code := -999; 
            o_status_message := 'Kritická chyba: Neočekávaná chyba: ' || SQLERRM;
    END PROC_INSERT_UZIVATEL;

    PROCEDURE PROC_UPDATE_UZIVATEL(
        p_id_uzivatel IN NUMBER,
        p_email IN VARCHAR2,
        p_pw_hash IN CHAR,
        p_salt IN CHAR,
        p_id_opravneni IN NUMBER,
        p_id_obrazek IN NUMBER,
        p_id_adresa IN NUMBER,
        
        o_id_uzivatel OUT NUMBER,
        o_status_code OUT NUMBER,
        o_status_message OUT VARCHAR2
    )
    AS
        v_email_clean UZIVATELE.EMAIL%TYPE := TRIM(p_email);
    BEGIN
        IF REGEXP_LIKE(v_email_clean, '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$') = FALSE THEN
            RAISE PCK_GLOBAL_EXCEPTIONS.E_NEPLATNY_FORMAT_EMAILU;
        END IF;

        IF FUNC_IS_EMAIL_UNIQUE(v_email_clean) = FALSE THEN 
            DECLARE 
                v_existing_id UZIVATELE.ID_UZIVATEL%TYPE;
            BEGIN 
                SELECT id_uzivatel 
                INTO v_existing_id 
                FROM UZIVATELE 
                WHERE UPPER(email) = UPPER(v_email_clean);
                
                IF v_existing_id != p_id_uzivatel THEN 
                    o_id_uzivatel := p_id_uzivatel; 
                    o_status_code := -10; 
                    o_status_message := 'Selhání aktualizace: Záznam s tímto emailem již existuje.';
                    RETURN; 
                END IF;
            EXCEPTION 
                WHEN NO_DATA_FOUND THEN 
                    NULL; -- Should not happen if FUNC_IS_EMAIL_UNIQUE is FALSE
            END;
        END IF;

        CHECK_FOREIGN_KEYS(p_id_opravneni, p_id_obrazek, p_id_adresa);

        UPDATE UZIVATELE
        SET
            email = v_email_clean,
            pw_hash = p_pw_hash,
            salt = p_salt,
            id_opravneni = p_id_opravneni,
            id_obrazek = p_id_obrazek,
            id_adresa = p_id_adresa
        WHERE
            id_uzivatel = p_id_uzivatel;

        IF SQL%ROWCOUNT = 0 THEN
            PROC_INSERT_UZIVATEL(v_email_clean, p_pw_hash, p_salt, p_id_opravneni, p_id_obrazek, p_id_adresa, o_id_uzivatel, o_status_code, o_status_message);
            IF o_status_code = 1 THEN
                o_status_message := 'Úspěch: Záznam nebyl nalezen, byl místo toho vytvořen nový záznam.';
            END IF;
        ELSE
            o_id_uzivatel := p_id_uzivatel;
            o_status_code := 1;
            o_status_message := 'Úspěch: Operace proběhla úspěšně.';
        END IF;
        
    EXCEPTION
        WHEN PCK_GLOBAL_EXCEPTIONS.E_NEPLATNY_FORMAT_EMAILU THEN
            o_id_uzivatel := p_id_uzivatel;
            o_status_code := -23; 
            o_status_message := 'Selhání validace: Neplatný formát emailu.';

        WHEN PCK_GLOBAL_EXCEPTIONS.E_FK_OPRAVNENI_NEEXISTUJE THEN
            o_id_uzivatel := p_id_uzivatel;
            o_status_code := -420; 
            o_status_message := 'Selhání cizího klíče: Zadané ID oprávnění neexistuje.';

        WHEN PCK_GLOBAL_EXCEPTIONS.E_FK_OBRAZEK_NEEXISTUJE THEN
            o_id_uzivatel := p_id_uzivatel;
            o_status_code := -407; 
            o_status_message := 'Selhání cizího klíče: Zadané ID obrázku neexistuje.';

        WHEN PCK_GLOBAL_EXCEPTIONS.E_FK_ADRESA_NEEXISTUJE THEN
            o_id_uzivatel := p_id_uzivatel;
            o_status_code := -422; 
            o_status_message := 'Selhání cizího klíče: Zadané ID adresy neexistuje.';

        WHEN OTHERS THEN
            o_id_uzivatel := p_id_uzivatel;
            o_status_code := -999; 
            o_status_message := 'Kritická chyba: Neočekávaná chyba: ' || SQLERRM;
    END PROC_UPDATE_UZIVATEL;

    PROCEDURE PROC_DELETE_UZIVATEL(
        p_id_uzivatel IN NUMBER,
        
        o_status_code OUT NUMBER,
        o_status_message OUT VARCHAR2
    )
    AS
    BEGIN
        DELETE FROM UZIVATELE
        WHERE id_uzivatel = p_id_uzivatel;
        
        IF SQL%ROWCOUNT = 1 THEN
            o_status_code := 1;
            o_status_message := 'Úspěch: Operace proběhla úspěšně.';
        ELSE
            RAISE NO_DATA_FOUND;
        END IF;
        
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            o_status_code := 0; 
            o_status_message := 'Selhání odstranění: Záznam nebyl nalezen.';
            
        WHEN OTHERS THEN
            o_status_code := -999; 
            o_status_message := 'Kritická chyba: Neočekávaná chyba: ' || SQLERRM;
    END PROC_DELETE_UZIVATEL;
END PCK_UZIVATELE;
/

CREATE OR REPLACE PACKAGE PCK_KVETINYKOSIKY AS
    PROCEDURE PROC_INSERT_KVETINYKOSIKY(
        p_id_kvetina IN NUMBER,
        p_id_kosik IN NUMBER,
        p_pocet IN NUMBER DEFAULT 1,
        
        o_id_kvetina OUT NUMBER,
        o_id_kosik OUT NUMBER,
        o_status_code OUT NUMBER,
        o_status_message OUT VARCHAR2
    );
    
    PROCEDURE PROC_UPDATE_KVETINYKOSIKY(
        p_id_kvetina IN NUMBER,
        p_id_kosik IN NUMBER,
        p_pocet IN NUMBER,
        
        o_id_kvetina OUT NUMBER,
        o_id_kosik OUT NUMBER,
        o_status_code OUT NUMBER,
        o_status_message OUT VARCHAR2
    );
    
    PROCEDURE PROC_DELETE_KVETINYKOSIKY(
        p_id_kvetina IN NUMBER,
        p_id_kosik IN NUMBER,
        
        o_status_code OUT NUMBER,
        o_status_message OUT VARCHAR2
    );
END PCK_KVETINYKOSIKY;
/

CREATE OR REPLACE PACKAGE BODY PCK_KVETINYKOSIKY AS
    v_existuje NUMBER;

    PROCEDURE CHECK_FOREIGN_KEYS(
        p_id_kvetina IN NUMBER,
        p_id_kosik IN NUMBER
    )
    AS
    BEGIN
        BEGIN
            SELECT 1 INTO v_existuje FROM KVETINY WHERE id_kvetina = p_id_kvetina;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN RAISE PCK_GLOBAL_EXCEPTIONS.E_FK_KVETINA_NEEXISTUJE;
        END;
        
        BEGIN
            SELECT 1 INTO v_existuje FROM KOSIKY WHERE id_kosik = p_id_kosik;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN RAISE PCK_GLOBAL_EXCEPTIONS.E_FK_KOSIK_NEEXISTUJE;
        END;
    END CHECK_FOREIGN_KEYS;

    PROCEDURE PROC_INSERT_KVETINYKOSIKY(
        p_id_kvetina IN NUMBER,
        p_id_kosik IN NUMBER,
        p_pocet IN NUMBER DEFAULT 1,
        
        o_id_kvetina OUT NUMBER,
        o_id_kosik OUT NUMBER,
        o_status_code OUT NUMBER,
        o_status_message OUT VARCHAR2
    )
    AS
        v_pocet KVETINYKOSIKY.POCET%TYPE;
        v_id_kvetina KVETINYKOSIKY.ID_KVETINA%TYPE := p_id_kvetina;
        v_id_kosik KVETINYKOSIKY.ID_KOSIK%TYPE := p_id_kosik;
    BEGIN
        IF p_pocet <= 0 THEN
            RAISE PCK_GLOBAL_EXCEPTIONS.E_NEPLATNY_POCET;
        END IF;
        
        CHECK_FOREIGN_KEYS(p_id_kvetina, p_id_kosik);

        SELECT pocet
        INTO v_pocet
        FROM KVETINYKOSIKY
        WHERE id_kvetina = p_id_kvetina AND id_kosik = p_id_kosik;
        
        o_id_kvetina := v_id_kvetina;
        o_id_kosik := v_id_kosik;
        o_status_code := 1; -- ZMĚNA: Vrátit 1 (Úspěch) a klíče
        o_status_message := 'Úspěch: Položka již existuje a byly vráceny její klíče.';
        
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            INSERT INTO KVETINYKOSIKY(id_kvetina, id_kosik, pocet)
            VALUES(p_id_kvetina, p_id_kosik, p_pocet);
            
            o_id_kvetina := p_id_kvetina;
            o_id_kosik := p_id_kosik;
            o_status_code := 1;
            o_status_message := 'Úspěch: Operace proběhla úspěšně.';
        
        WHEN PCK_GLOBAL_EXCEPTIONS.E_NEPLATNY_POCET THEN
            o_id_kvetina := p_id_kvetina;
            o_id_kosik := p_id_kosik;
            o_status_code := -20;
            o_status_message := 'Selhání validace: Počet musí být kladné číslo (>= 1).';
            
        WHEN PCK_GLOBAL_EXCEPTIONS.E_FK_KVETINA_NEEXISTUJE THEN
            o_id_kvetina := p_id_kvetina;
            o_id_kosik := p_id_kosik;
            o_status_code := -430;
            o_status_message := 'Selhání cizího klíče: Zadaná květina neexistuje.';
            
        WHEN PCK_GLOBAL_EXCEPTIONS.E_FK_KOSIK_NEEXISTUJE THEN
            o_id_kvetina := p_id_kvetina;
            o_id_kosik := p_id_kosik;
            o_status_code := -431;
            o_status_message := 'Selhání cizího klíče: Zadaný košík neexistuje.';
            
        WHEN OTHERS THEN
            o_id_kvetina := p_id_kvetina;
            o_id_kosik := p_id_kosik;
            o_status_code := -999; 
            o_status_message := 'Kritická chyba: Neočekávaná chyba: ' || SQLERRM;
    END PROC_INSERT_KVETINYKOSIKY;

    PROCEDURE PROC_UPDATE_KVETINYKOSIKY(
        p_id_kvetina IN NUMBER,
        p_id_kosik IN NUMBER,
        p_pocet IN NUMBER,
        
        o_id_kvetina OUT NUMBER,
        o_id_kosik OUT NUMBER,
        o_status_code OUT NUMBER,
        o_status_message OUT VARCHAR2
    )
    AS
    BEGIN
        o_id_kvetina := p_id_kvetina;
        o_id_kosik := p_id_kosik;
        
        IF p_pocet <= 0 THEN
            RAISE PCK_GLOBAL_EXCEPTIONS.E_NEPLATNY_POCET;
        END IF;
        
        CHECK_FOREIGN_KEYS(p_id_kvetina, p_id_kosik);

        UPDATE KVETINYKOSIKY
        SET pocet = p_pocet
        WHERE id_kvetina = p_id_kvetina AND id_kosik = p_id_kosik;
        
        IF SQL%ROWCOUNT = 0 THEN
            PROC_INSERT_KVETINYKOSIKY(p_id_kvetina, p_id_kosik, p_pocet, o_id_kvetina, o_id_kosik, o_status_code, o_status_message);
            IF o_status_code = 1 THEN
                o_status_message := 'Úspěch: Položka nebyla nalezena, byla místo toho vytvořena s nastaveným počtem.';
            END IF;
        ELSE
            o_status_code := 1;
            o_status_message := 'Úspěch: Operace proběhla úspěšně.';
        END IF;

    EXCEPTION
        WHEN PCK_GLOBAL_EXCEPTIONS.E_NEPLATNY_POCET THEN
            o_status_code := -20;
            o_status_message := 'Selhání validace: Počet musí být kladné číslo (>= 1).';
            
        WHEN PCK_GLOBAL_EXCEPTIONS.E_FK_KVETINA_NEEXISTUJE THEN
            o_status_code := -430;
            o_status_message := 'Selhání cizího klíče: Zadaná květina neexistuje.';
            
        WHEN PCK_GLOBAL_EXCEPTIONS.E_FK_KOSIK_NEEXISTUJE THEN
            o_status_code := -431;
            o_status_message := 'Selhání cizího klíče: Zadaný košík neexistuje.';
            
        WHEN OTHERS THEN
            o_status_code := -999; 
            o_status_message := 'Kritická chyba: Neočekávaná chyba: ' || SQLERRM;
    END PROC_UPDATE_KVETINYKOSIKY;

    PROCEDURE PROC_DELETE_KVETINYKOSIKY(
        p_id_kvetina IN NUMBER,
        p_id_kosik IN NUMBER,
        
        o_status_code OUT NUMBER,
        o_status_message OUT VARCHAR2
    )
    AS
    BEGIN
        DELETE FROM KVETINYKOSIKY
        WHERE id_kvetina = p_id_kvetina AND id_kosik = p_id_kosik;
        
        IF SQL%ROWCOUNT = 1 THEN
            o_status_code := 1;
            o_status_message := 'Úspěch: Operace proběhla úspěšně.';
        ELSE
            RAISE NO_DATA_FOUND;
        END IF;
        
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            o_status_code := 0; 
            o_status_message := 'Selhání odstranění: Záznam nebyl nalezen.';
            
        WHEN OTHERS THEN
            o_status_code := -999; 
            o_status_message := 'Kritická chyba: Neočekávaná chyba: ' || SQLERRM;
    END PROC_DELETE_KVETINYKOSIKY;
END PCK_KVETINYKOSIKY;
/

CREATE OR REPLACE PACKAGE PCK_DOTAZY AS
    
    PROCEDURE PROC_INSERT_DOTAZ(
        p_text IN CLOB,
        p_verejny IN NUMBER DEFAULT 0,
        p_odpoved IN CLOB DEFAULT NULL,
        p_id_odpovidajici_uzivatel IN NUMBER DEFAULT NULL,
        
        o_id_dotaz OUT NUMBER,
        o_status_code OUT NUMBER,
        o_status_message OUT VARCHAR2
    );
    
    PROCEDURE PROC_UPDATE_DOTAZ(
        p_id_dotaz IN NUMBER,
        p_text IN CLOB,
        p_verejny IN NUMBER,
        p_odpoved IN CLOB,
        p_id_odpovidajici_uzivatel IN NUMBER,
        
        o_id_dotaz OUT NUMBER,
        o_status_code OUT NUMBER,
        o_status_message OUT VARCHAR2
    );
    
    PROCEDURE PROC_DELETE_DOTAZ(
        p_id_dotaz IN NUMBER,
        
        o_status_code OUT NUMBER,
        o_status_message OUT VARCHAR2
    );
END PCK_DOTAZY;
/

CREATE OR REPLACE PACKAGE BODY PCK_DOTAZY AS
    v_existuje NUMBER;

    PROCEDURE CHECK_LOGIC(
        p_odpoved IN CLOB,
        p_id_odpovidajici_uzivatel IN NUMBER
    )
    AS
    BEGIN
        IF (p_odpoved IS NULL AND p_id_odpovidajici_uzivatel IS NOT NULL) OR 
           (p_odpoved IS NOT NULL AND p_id_odpovidajici_uzivatel IS NULL) THEN
            RAISE PCK_GLOBAL_EXCEPTIONS.E_NEKONZISTENTNI_ODPOVED;
        END IF;
        
        IF p_id_odpovidajici_uzivatel IS NOT NULL THEN
            BEGIN
                SELECT 1 INTO v_existuje FROM UZIVATELE WHERE id_uzivatel = p_id_odpovidajici_uzivatel;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN RAISE PCK_GLOBAL_EXCEPTIONS.E_FK_UZIVATEL_NEEXISTUJE;
            END;
        END IF;
    END CHECK_LOGIC;

    PROCEDURE PROC_INSERT_DOTAZ(
        p_text IN CLOB,
        p_verejny IN NUMBER DEFAULT 0,
        p_odpoved IN CLOB DEFAULT NULL,
        p_id_odpovidajici_uzivatel IN NUMBER DEFAULT NULL,
        
        o_id_dotaz OUT NUMBER,
        o_status_code OUT NUMBER,
        o_status_message OUT VARCHAR2
    )
    AS
    BEGIN
        CHECK_LOGIC(p_odpoved, p_id_odpovidajici_uzivatel);
        
        -- Dotaz is a temporal record, always inserted. No uniqueness check is needed.
        INSERT INTO DOTAZY(datum_podani, text, verejny, odpoved, id_odpovidajici_uzivatel)
        VALUES(SYSTIMESTAMP, p_text, p_verejny, p_odpoved, p_id_odpovidajici_uzivatel)
        RETURNING id_dotaz INTO o_id_dotaz;
        
        o_status_code := 1;
        o_status_message := 'Úspěch: Operace proběhla úspěšně.';
        
    EXCEPTION
        WHEN PCK_GLOBAL_EXCEPTIONS.E_NEKONZISTENTNI_ODPOVED THEN
            o_id_dotaz := NULL;
            o_status_code := -20; 
            o_status_message := 'Selhání validace: Odpověď a ID odpovídajícího uživatele musí být buď oba vyplněné, nebo oba NULL.';

        WHEN PCK_GLOBAL_EXCEPTIONS.E_FK_UZIVATEL_NEEXISTUJE THEN
            o_id_dotaz := NULL;
            o_status_code := -411; 
            o_status_message := 'Selhání cizího klíče: Zadaný ID odpovídajícího uživatele neexistuje.';

        WHEN OTHERS THEN
            o_id_dotaz := NULL;
            o_status_code := -999; 
            o_status_message := 'Kritická chyba: Neočekávaná chyba: ' || SQLERRM;
    END PROC_INSERT_DOTAZ;

    PROCEDURE PROC_UPDATE_DOTAZ(
        p_id_dotaz IN NUMBER,
        p_text IN CLOB,
        p_verejny IN NUMBER,
        p_odpoved IN CLOB,
        p_id_odpovidajici_uzivatel IN NUMBER,
        
        o_id_dotaz OUT NUMBER,
        o_status_code OUT NUMBER,
        o_status_message OUT VARCHAR2
    )
    AS
    BEGIN
        CHECK_LOGIC(p_odpoved, p_id_odpovidajici_uzivatel);
        
        UPDATE DOTAZY
        SET
            text = p_text,
            verejny = p_verejny,
            odpoved = p_odpoved,
            id_odpovidajici_uzivatel = p_id_odpovidajici_uzivatel
        WHERE
            id_dotaz = p_id_dotaz;
            
        IF SQL%ROWCOUNT = 0 THEN
            -- Update not found, attempt insert (using default nulls for date/other fields if needed)
            PROC_INSERT_DOTAZ(p_text, p_verejny, p_odpoved, p_id_odpovidajici_uzivatel, o_id_dotaz, o_status_code, o_status_message);
            IF o_status_code = 1 THEN
                o_status_message := 'Úspěch: Záznam nebyl nalezen, byl místo toho vytvořen nový záznam.';
            END IF;
        ELSE
            o_id_dotaz := p_id_dotaz;
            o_status_code := 1;
            o_status_message := 'Úspěch: Operace proběhla úspěšně.';
        END IF;

    EXCEPTION
        WHEN PCK_GLOBAL_EXCEPTIONS.E_NEKONZISTENTNI_ODPOVED THEN
            o_id_dotaz := p_id_dotaz;
            o_status_code := -20; 
            o_status_message := 'Selhání validace: Odpověď a ID odpovídajícího uživatele musí být buď oba vyplněné, nebo oba NULL.';

        WHEN PCK_GLOBAL_EXCEPTIONS.E_FK_UZIVATEL_NEEXISTUJE THEN
            o_id_dotaz := p_id_dotaz;
            o_status_code := -411; 
            o_status_message := 'Selhání cizího klíče: Zadaný ID odpovídajícího uživatele neexistuje.';

        WHEN OTHERS THEN
            o_id_dotaz := p_id_dotaz;
            o_status_code := -999; 
            o_status_message := 'Kritická chyba: Neočekávaná chyba: ' || SQLERRM;
    END PROC_UPDATE_DOTAZ;


    PROCEDURE PROC_DELETE_DOTAZ(
        p_id_dotaz IN NUMBER,
        
        o_status_code OUT NUMBER,
        o_status_message OUT VARCHAR2
    )
    AS
    BEGIN
        DELETE FROM DOTAZY
        WHERE id_dotaz = p_id_dotaz;
        
        IF SQL%ROWCOUNT = 1 THEN
            o_status_code := 1;
            o_status_message := 'Úspěch: Operace proběhla úspěšně.';
        ELSE
            RAISE NO_DATA_FOUND;
        END IF;
        
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            o_status_code := 0; 
            o_status_message := 'Selhání odstranění: Záznam nebyl nalezen.';
            
        WHEN OTHERS THEN
            o_status_code := -999; 
            o_status_message := 'Kritická chyba: Neočekávaná chyba: ' || SQLERRM;
    END PROC_DELETE_DOTAZ;
END PCK_DOTAZY;
/