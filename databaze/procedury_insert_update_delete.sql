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
        WHERE UPPER(nazev) = UPPER(v_nazev_clean);
        
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
        WHERE UPPER(nazev) = UPPER(v_nazev_clean);
        
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
        WHERE UPPER(psc) = UPPER(v_psc_clean);
        
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

CREATE OR REPLACE PACKAGE PCK_KATEGORIE AS
  PROCEDURE PROC_INSERT_KATEGORIE(
    p_nazev         IN VARCHAR2,
    p_id_nadrazene  IN NUMBER,
    o_id_kategorie  OUT NUMBER
  );
  PROCEDURE PROC_UPDATE_KATEGORIE(
    p_id_kategorie  IN NUMBER,
    p_nazev         IN VARCHAR2,
    p_id_nadrazene  IN NUMBER,
    o_id_kategorie  OUT NUMBER
  );
  PROCEDURE PROC_DELETE_KATEGORIE(
    p_id_kategorie  IN NUMBER,
    o_status        OUT NUMBER
  );
END PCK_KATEGORIE;
/

CREATE OR REPLACE PACKAGE BODY PCK_KATEGORIE AS
  PROCEDURE PROC_INSERT_KATEGORIE(
    p_nazev         IN VARCHAR2,
    p_id_nadrazene  IN NUMBER,
    o_id_kategorie  OUT NUMBER
  )
  AS
    v_id_kategorie  KATEGORIE.ID_KATEGORIE%TYPE;
    v_nazev_clean   KATEGORIE.NAZEV%TYPE := TRIM(p_nazev);
  BEGIN
    SELECT id_kategorie
      INTO v_id_kategorie
      FROM KATEGORIE
        WHERE UPPER(nazev) = UPPER(v_nazev_clean)
          AND NVL(id_nadrazene_kategorie,-1) = NVL(p_id_nadrazene,-1);

    o_id_kategorie := v_id_kategorie;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      INSERT INTO KATEGORIE(nazev, id_nadrazene_kategorie)
      VALUES (v_nazev_clean, p_id_nadrazene)
      RETURNING id_kategorie INTO o_id_kategorie;
  END;

  PROCEDURE PROC_UPDATE_KATEGORIE(
    p_id_kategorie  IN NUMBER,
    p_nazev         IN VARCHAR2,
    p_id_nadrazene  IN NUMBER,
    o_id_kategorie  OUT NUMBER
  )
  AS
    v_nazev_clean   KATEGORIE.NAZEV%TYPE := TRIM(p_nazev);
  BEGIN
    UPDATE KATEGORIE
       SET nazev = v_nazev_clean,
           id_nadrazene_kategorie = p_id_nadrazene
     WHERE id_kategorie = p_id_kategorie;

    IF SQL%ROWCOUNT = 0 THEN
      PROC_INSERT_KATEGORIE(v_nazev_clean, p_id_nadrazene, o_id_kategorie);
    ELSE
      o_id_kategorie := p_id_kategorie;
    END IF;
  END;

  PROCEDURE PROC_DELETE_KATEGORIE(
    p_id_kategorie  IN NUMBER,
    o_status        OUT NUMBER
  )
  AS
  BEGIN
    DELETE FROM KATEGORIE WHERE id_kategorie = p_id_kategorie;
    IF SQL%ROWCOUNT = 1 THEN
      o_status := 1;
    ELSE
      RAISE NO_DATA_FOUND;
    END IF;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN o_status := 0;
    WHEN OTHERS         THEN o_status := -1;
  END;
END PCK_KATEGORIE;
/

------------------------------------------------------------------
-- PCK_OBRAZKY
------------------------------------------------------------------
CREATE OR REPLACE PACKAGE PCK_OBRAZKY AS
  PROCEDURE PROC_INSERT_OBRAZEK(
    p_nazev_souboru IN VARCHAR2,
    p_data          IN BLOB,
    o_id_obrazek    OUT NUMBER
  );
  PROCEDURE PROC_UPDATE_OBRAZEK(
    p_id_obrazek    IN NUMBER,
    p_nazev_souboru IN VARCHAR2,
    p_data          IN BLOB,
    o_id_obrazek    OUT NUMBER
  );
  PROCEDURE PROC_DELETE_OBRAZEK(
    p_id_obrazek IN NUMBER,
    o_status     OUT NUMBER
  );
END PCK_OBRAZKY;
/

CREATE OR REPLACE PACKAGE BODY PCK_OBRAZKY AS
  PROCEDURE PROC_INSERT_OBRAZEK(
    p_nazev_souboru IN VARCHAR2,
    p_data          IN BLOB,
    o_id_obrazek    OUT NUMBER
  )
  AS
    v_id_obrazek  OBRAZKY.ID_OBRAZEK%TYPE;
    v_name_clean  OBRAZKY.NAZEV_SOUBORU%TYPE := TRIM(p_nazev_souboru);
  BEGIN
    SELECT id_obrazek
      INTO v_id_obrazek
      FROM OBRAZKY
     WHERE UPPER(nazev_souboru) = UPPER(v_name_clean);

    o_id_obrazek := v_id_obrazek;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      INSERT INTO OBRAZKY(nazev_souboru, data)
      VALUES (v_name_clean, NVL(p_data, EMPTY_BLOB()))
      RETURNING id_obrazek INTO o_id_obrazek;
  END;

  PROCEDURE PROC_UPDATE_OBRAZEK(
    p_id_obrazek    IN NUMBER,
    p_nazev_souboru IN VARCHAR2,
    p_data          IN BLOB,
    o_id_obrazek    OUT NUMBER
  )
  AS
    v_name_clean  OBRAZKY.NAZEV_SOUBORU%TYPE := TRIM(p_nazev_souboru);
  BEGIN
    UPDATE OBRAZKY
       SET nazev_souboru = v_name_clean,
           data          = NVL(p_data, data)
     WHERE id_obrazek    = p_id_obrazek;

    IF SQL%ROWCOUNT = 0 THEN
      PROC_INSERT_OBRAZEK(v_name_clean, p_data, o_id_obrazek);
    ELSE
      o_id_obrazek := p_id_obrazek;
    END IF;
  END;

  PROCEDURE PROC_DELETE_OBRAZEK(
    p_id_obrazek IN NUMBER,
    o_status     OUT NUMBER
  )
  AS
  BEGIN
    DELETE FROM OBRAZKY WHERE id_obrazek = p_id_obrazek;
    IF SQL%ROWCOUNT = 1 THEN o_status := 1; ELSE RAISE NO_DATA_FOUND; END IF;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN o_status := 0;
    WHEN OTHERS         THEN o_status := -1;
  END;
END PCK_OBRAZKY;
/

------------------------------------------------------------------
-- PCK_OPRAVNENI
------------------------------------------------------------------
CREATE OR REPLACE PACKAGE PCK_OPRAVNENI AS
  PROCEDURE PROC_INSERT_OPRAVNENI(
    p_nazev  IN VARCHAR2,
    p_uroven IN NUMBER,
    o_id     OUT NUMBER
  );
  PROCEDURE PROC_UPDATE_OPRAVNENI(
    p_id     IN NUMBER,
    p_nazev  IN VARCHAR2,
    p_uroven IN NUMBER,
    o_id     OUT NUMBER
  );
  PROCEDURE PROC_DELETE_OPRAVNENI(
    p_id     IN NUMBER,
    o_status OUT NUMBER
  );
END PCK_OPRAVNENI;
/

CREATE OR REPLACE PACKAGE BODY PCK_OPRAVNENI AS
  PROCEDURE PROC_INSERT_OPRAVNENI(
    p_nazev  IN VARCHAR2,
    p_uroven IN NUMBER,
    o_id     OUT NUMBER
  )
  AS
    v_id_opravneni  OPRAVNENI.ID_OPRAVNENI%TYPE;
    v_nazev_clean   OPRAVNENI.NAZEV%TYPE := TRIM(p_nazev);
  BEGIN
    SELECT id_opravneni
      INTO v_id_opravneni
      FROM OPRAVNENI
     WHERE UPPER(nazev) = UPPER(v_nazev_clean);

    o_id := v_id_opravneni;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      INSERT INTO OPRAVNENI(nazev, uroven)
      VALUES (v_nazev_clean, p_uroven)
      RETURNING id_opravneni INTO o_id;
  END;

  PROCEDURE PROC_UPDATE_OPRAVNENI(
    p_id     IN NUMBER,
    p_nazev  IN VARCHAR2,
    p_uroven IN NUMBER,
    o_id     OUT NUMBER
  )
  AS
    v_nazev_clean OPRAVNENI.NAZEV%TYPE := TRIM(p_nazev);
  BEGIN
    UPDATE OPRAVNENI
       SET nazev = v_nazev_clean,
           uroven = p_uroven
     WHERE id_opravneni = p_id;

    IF SQL%ROWCOUNT = 0 THEN
      PROC_INSERT_OPRAVNENI(v_nazev_clean, p_uroven, o_id);
    ELSE
      o_id := p_id;
    END IF;
  END;

  PROCEDURE PROC_DELETE_OPRAVNENI(
    p_id     IN NUMBER,
    o_status OUT NUMBER
  )
  AS
  BEGIN
    DELETE FROM OPRAVNENI WHERE id_opravneni = p_id;
    IF SQL%ROWCOUNT = 1 THEN o_status := 1; ELSE RAISE NO_DATA_FOUND; END IF;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN o_status := 0;
    WHEN OTHERS         THEN o_status := -1;
  END;
END PCK_OPRAVNENI;
/

------------------------------------------------------------------
-- PCK_PLATBY (ZPUSOBYPLATEB)
------------------------------------------------------------------
CREATE OR REPLACE PACKAGE PCK_PLATBY AS
  PROCEDURE PROC_INSERT_PLATBA(
    p_nazev IN VARCHAR2,
    o_id    OUT NUMBER
  );
  PROCEDURE PROC_UPDATE_PLATBA(
    p_id    IN NUMBER,
    p_nazev IN VARCHAR2,
    o_id    OUT NUMBER
  );
  PROCEDURE PROC_DELETE_PLATBA(
    p_id    IN NUMBER,
    o_status OUT NUMBER
  );
END PCK_PLATBY;
/

CREATE OR REPLACE PACKAGE BODY PCK_PLATBY AS
  PROCEDURE PROC_INSERT_PLATBA(
    p_nazev IN VARCHAR2,
    o_id    OUT NUMBER
  )
  AS
    v_id_platba   ZPUSOBYPLATEB.ID_ZPUSOB_PLATBY%TYPE;
    v_nazev_clean ZPUSOBYPLATEB.NAZEV%TYPE := TRIM(p_nazev);
  BEGIN
    SELECT id_zpusob_platby
      INTO v_id_platba
      FROM ZPUSOBYPLATEB
     WHERE UPPER(nazev) = UPPER(v_nazev_clean);

    o_id := v_id_platba;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      INSERT INTO ZPUSOBYPLATEB(nazev)
      VALUES (v_nazev_clean)
      RETURNING id_zpusob_platby INTO o_id;
  END;

  PROCEDURE PROC_UPDATE_PLATBA(
    p_id    IN NUMBER,
    p_nazev IN VARCHAR2,
    o_id    OUT NUMBER
  )
  AS
    v_nazev_clean ZPUSOBYPLATEB.NAZEV%TYPE := TRIM(p_nazev);
  BEGIN
    UPDATE ZPUSOBYPLATEB
       SET nazev = v_nazev_clean
     WHERE id_zpusob_platby = p_id;

    IF SQL%ROWCOUNT = 0 THEN
      PROC_INSERT_PLATBA(v_nazev_clean, o_id);
    ELSE
      o_id := p_id;
    END IF;
  END;

  PROCEDURE PROC_DELETE_PLATBA(
    p_id    IN NUMBER,
    o_status OUT NUMBER
  )
  AS
  BEGIN
    DELETE FROM ZPUSOBYPLATEB WHERE id_zpusob_platby = p_id;
    IF SQL%ROWCOUNT = 1 THEN o_status := 1; ELSE RAISE NO_DATA_FOUND; END IF;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN o_status := 0;
    WHEN OTHERS         THEN o_status := -1;
  END;
END PCK_PLATBY;
/

------------------------------------------------------------------
-- PCK_STAVY (STAVYOBJEDNAVEK)
------------------------------------------------------------------
CREATE OR REPLACE PACKAGE PCK_STAVY AS
  PROCEDURE PROC_INSERT_STAV(
    p_nazev IN VARCHAR2,
    o_id    OUT NUMBER
  );
  PROCEDURE PROC_UPDATE_STAV(
    p_id    IN NUMBER,
    p_nazev IN VARCHAR2,
    o_id    OUT NUMBER
  );
  PROCEDURE PROC_DELETE_STAV(
    p_id    IN NUMBER,
    o_status OUT NUMBER
  );
END PCK_STAVY;
/

CREATE OR REPLACE PACKAGE BODY PCK_STAVY AS
  PROCEDURE PROC_INSERT_STAV(
    p_nazev IN VARCHAR2,
    o_id    OUT NUMBER
  )
  AS
    v_id_stav     STAVYOBJEDNAVEK.ID_STAV_OBJEDNAVKY%TYPE;
    v_nazev_clean STAVYOBJEDNAVEK.NAZEV%TYPE := TRIM(p_nazev);
  BEGIN
    SELECT id_stav_objednavky
      INTO v_id_stav
      FROM STAVYOBJEDNAVEK
     WHERE UPPER(nazev) = UPPER(v_nazev_clean);

    o_id := v_id_stav;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      INSERT INTO STAVYOBJEDNAVEK(nazev)
      VALUES (v_nazev_clean)
      RETURNING id_stav_objednavky INTO o_id;
  END;

  PROCEDURE PROC_UPDATE_STAV(
    p_id    IN NUMBER,
    p_nazev IN VARCHAR2,
    o_id    OUT NUMBER
  )
  AS
    v_nazev_clean STAVYOBJEDNAVEK.NAZEV%TYPE := TRIM(p_nazev);
  BEGIN
    UPDATE STAVYOBJEDNAVEK
       SET nazev = v_nazev_clean
     WHERE id_stav_objednavky = p_id;

    IF SQL%ROWCOUNT = 0 THEN
      PROC_INSERT_STAV(v_nazev_clean, o_id);
    ELSE
      o_id := p_id;
    END IF;
  END;

  PROCEDURE PROC_DELETE_STAV(
    p_id    IN NUMBER,
    o_status OUT NUMBER
  )
  AS
  BEGIN
    DELETE FROM STAVYOBJEDNAVEK WHERE id_stav_objednavky = p_id;
    IF SQL%ROWCOUNT = 1 THEN o_status := 1; ELSE RAISE NO_DATA_FOUND; END IF;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN o_status := 0;
    WHEN OTHERS         THEN o_status := -1;
  END;
END PCK_STAVY;
/

------------------------------------------------------------------
-- PCK_KVETINY
------------------------------------------------------------------
CREATE OR REPLACE PACKAGE PCK_KVETINY AS
  PROCEDURE PROC_INSERT_KVETINA(
    p_nazev         IN VARCHAR2,
    p_cena          IN NUMBER,
    p_id_kategorie  IN NUMBER,
    p_id_obrazek    IN NUMBER,
    o_id_kvetina    OUT NUMBER
  );
  PROCEDURE PROC_UPDATE_KVETINA(
    p_id_kvetina    IN NUMBER,
    p_nazev         IN VARCHAR2,
    p_cena          IN NUMBER,
    p_id_kategorie  IN NUMBER,
    p_id_obrazek    IN NUMBER,
    o_id_kvetina    OUT NUMBER
  );
  PROCEDURE PROC_DELETE_KVETINA(
    p_id_kvetina IN NUMBER,
    o_status     OUT NUMBER
  );
END PCK_KVETINY;
/

CREATE OR REPLACE PACKAGE BODY PCK_KVETINY AS
  PROCEDURE PROC_INSERT_KVETINA(
    p_nazev         IN VARCHAR2,
    p_cena          IN NUMBER,
    p_id_kategorie  IN NUMBER,
    p_id_obrazek    IN NUMBER,
    o_id_kvetina    OUT NUMBER
  )
  AS
    v_id_kvetina  KVETINY.ID_KVETINA%TYPE;
    v_nazev_clean KVETINY.NAZEV%TYPE := TRIM(p_nazev);
  BEGIN
    SELECT id_kvetina
      INTO v_id_kvetina
      FROM KVETINY
     WHERE UPPER(nazev) = UPPER(v_nazev_clean);

    o_id_kvetina := v_id_kvetina;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      INSERT INTO KVETINY(nazev, cena, id_kategorie, id_obrazek)
      VALUES (v_nazev_clean, p_cena, p_id_kategorie, p_id_obrazek)
      RETURNING id_kvetina INTO o_id_kvetina;
  END;

  PROCEDURE PROC_UPDATE_KVETINA(
    p_id_kvetina    IN NUMBER,
    p_nazev         IN VARCHAR2,
    p_cena          IN NUMBER,
    p_id_kategorie  IN NUMBER,
    p_id_obrazek    IN NUMBER,
    o_id_kvetina    OUT NUMBER
  )
  AS
    v_nazev_clean KVETINY.NAZEV%TYPE := TRIM(p_nazev);
  BEGIN
    UPDATE KVETINY
       SET nazev = v_nazev_clean,
           cena  = p_cena,
           id_kategorie = p_id_kategorie,
           id_obrazek   = p_id_obrazek
     WHERE id_kvetina = p_id_kvetina;

    IF SQL%ROWCOUNT = 0 THEN
      PROC_INSERT_KVETINA(v_nazev_clean, p_cena, p_id_kategorie, p_id_obrazek, o_id_kvetina);
    ELSE
      o_id_kvetina := p_id_kvetina;
    END IF;
  END;

  PROCEDURE PROC_DELETE_KVETINA(
    p_id_kvetina IN NUMBER,
    o_status     OUT NUMBER
  )
  AS
  BEGIN
    DELETE FROM KVETINY WHERE id_kvetina = p_id_kvetina;
    IF SQL%ROWCOUNT = 1 THEN o_status := 1; ELSE RAISE NO_DATA_FOUND; END IF;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN o_status := 0;
    WHEN OTHERS         THEN o_status := -1;
  END;
END PCK_KVETINY;
/

------------------------------------------------------------------
-- PCK_UZIVATELE  (FK řešeny voláním PCK_OPRAVNENI / PCK_ADRESY / PCK_OBRAZKY)
------------------------------------------------------------------
CREATE OR REPLACE PACKAGE PCK_UZIVATELE AS
  PROCEDURE PROC_INSERT_UZIVATEL(
    p_email         IN VARCHAR2,
    p_pw_hash       IN VARCHAR2,
    p_salt          IN VARCHAR2,
    p_nazev_opr     IN VARCHAR2,
    p_cp            IN NUMBER,
    p_nazev_mesta   IN VARCHAR2,
    p_nazev_ulice   IN VARCHAR2,
    p_psc           IN VARCHAR2,
    p_nazev_souboru IN VARCHAR2,   -- může být NULL
    o_id_uzivatel   OUT NUMBER
  );
  PROCEDURE PROC_UPDATE_UZIVATEL(
    p_id_uzivatel   IN NUMBER,
    p_email         IN VARCHAR2,
    p_pw_hash       IN VARCHAR2,
    p_salt          IN VARCHAR2,
    p_nazev_opr     IN VARCHAR2,
    p_cp            IN NUMBER,
    p_nazev_mesta   IN VARCHAR2,
    p_nazev_ulice   IN VARCHAR2,
    p_psc           IN VARCHAR2,
    p_nazev_souboru IN VARCHAR2,   -- může být NULL
    o_id_uzivatel   OUT NUMBER
  );
  PROCEDURE PROC_DELETE_UZIVATEL(
    p_id_uzivatel IN NUMBER,
    o_status      OUT NUMBER
  );
END PCK_UZIVATELE;
/

CREATE OR REPLACE PACKAGE BODY PCK_UZIVATELE AS
  PROCEDURE PROC_INSERT_UZIVATEL(
    p_email         IN VARCHAR2,
    p_pw_hash       IN VARCHAR2,
    p_salt          IN VARCHAR2,
    p_nazev_opr     IN VARCHAR2,
    p_cp            IN NUMBER,
    p_nazev_mesta   IN VARCHAR2,
    p_nazev_ulice   IN VARCHAR2,
    p_psc           IN VARCHAR2,
    p_nazev_souboru IN VARCHAR2,
    o_id_uzivatel   OUT NUMBER
  )
  AS
    v_id_uzivatel  UZIVATELE.ID_UZIVATEL%TYPE;
    v_email_clean  UZIVATELE.EMAIL%TYPE := TRIM(p_email);
    v_id_opr       OPRAVNENI.ID_OPRAVNENI%TYPE;
    v_id_adr       ADRESY.ID_ADRESA%TYPE;
    v_id_img       OBRAZKY.ID_OBRAZEK%TYPE;
  BEGIN
    PCK_OPRAVNENI.PROC_INSERT_OPRAVNENI(p_nazev_opr, 1, v_id_opr);
    PCK_ADRESY.PROC_INSERT_ADRESA(p_cp, p_nazev_mesta, p_nazev_ulice, p_psc, v_id_adr);

    IF p_nazev_souboru IS NOT NULL THEN
      PCK_OBRAZKY.PROC_INSERT_OBRAZEK(p_nazev_souboru, NULL, v_id_img);
    ELSE
      v_id_img := NULL;
    END IF;

    SELECT id_uzivatel
      INTO v_id_uzivatel
      FROM UZIVATELE
     WHERE UPPER(email) = UPPER(v_email_clean);

    o_id_uzivatel := v_id_uzivatel;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      INSERT INTO UZIVATELE(email, pw_hash, salt, id_opravneni, id_obrazek, id_adresa)
      VALUES (v_email_clean, p_pw_hash, p_salt, v_id_opr, v_id_img, v_id_adr)
      RETURNING id_uzivatel INTO o_id_uzivatel;
  END;

  PROCEDURE PROC_UPDATE_UZIVATEL(
    p_id_uzivatel   IN NUMBER,
    p_email         IN VARCHAR2,
    p_pw_hash       IN VARCHAR2,
    p_salt          IN VARCHAR2,
    p_nazev_opr     IN VARCHAR2,
    p_cp            IN NUMBER,
    p_nazev_mesta   IN VARCHAR2,
    p_nazev_ulice   IN VARCHAR2,
    p_psc           IN VARCHAR2,
    p_nazev_souboru IN VARCHAR2,
    o_id_uzivatel   OUT NUMBER
  )
  AS
    v_email_clean  UZIVATELE.EMAIL%TYPE := TRIM(p_email);
    v_id_opr       OPRAVNENI.ID_OPRAVNENI%TYPE;
    v_id_adr       ADRESY.ID_ADRESA%TYPE;
    v_id_img       OBRAZKY.ID_OBRAZEK%TYPE;
  BEGIN
    PCK_OPRAVNENI.PROC_INSERT_OPRAVNENI(p_nazev_opr, 1, v_id_opr);
    PCK_ADRESY.PROC_INSERT_ADRESA(p_cp, p_nazev_mesta, p_nazev_ulice, p_psc, v_id_adr);

    IF p_nazev_souboru IS NOT NULL THEN
      PCK_OBRAZKY.PROC_INSERT_OBRAZEK(p_nazev_souboru, NULL, v_id_img);
    ELSE
      v_id_img := NULL;
    END IF;

    UPDATE UZIVATELE
       SET email        = v_email_clean,
           pw_hash      = p_pw_hash,
           salt         = p_salt,
           id_opravneni = v_id_opr,
           id_obrazek   = v_id_img,
           id_adresa    = v_id_adr
     WHERE id_uzivatel  = p_id_uzivatel;

    IF SQL%ROWCOUNT = 0 THEN
      PROC_INSERT_UZIVATEL(v_email_clean, p_pw_hash, p_salt, p_nazev_opr,
                           p_cp, p_nazev_mesta, p_nazev_ulice, p_psc,
                           p_nazev_souboru, o_id_uzivatel);
    ELSE
      o_id_uzivatel := p_id_uzivatel;
    END IF;
  END;

  PROCEDURE PROC_DELETE_UZIVATEL(
    p_id_uzivatel IN NUMBER,
    o_status      OUT NUMBER
  )
  AS
  BEGIN
    DELETE FROM UZIVATELE WHERE id_uzivatel = p_id_uzivatel;
    IF SQL%ROWCOUNT = 1 THEN o_status := 1; ELSE RAISE NO_DATA_FOUND; END IF;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN o_status := 0;
    WHEN OTHERS         THEN o_status := -1;
  END;
END PCK_UZIVATELE;
/

------------------------------------------------------------------
-- PCK_KOSIKY
------------------------------------------------------------------
CREATE OR REPLACE PACKAGE PCK_KOSIKY AS
  PROCEDURE PROC_INSERT_KOSIK(
    p_datum        IN TIMESTAMP,
    p_cena         IN NUMBER,
    p_sleva        IN NUMBER,
    p_id_uzivatel  IN NUMBER,
    p_id_stav      IN NUMBER,
    p_id_platba    IN NUMBER,
    o_id_kosik     OUT NUMBER
  );
  PROCEDURE PROC_UPDATE_KOSIK(
    p_id_kosik     IN NUMBER,
    p_datum        IN TIMESTAMP,
    p_cena         IN NUMBER,
    p_sleva        IN NUMBER,
    p_id_uzivatel  IN NUMBER,
    p_id_stav      IN NUMBER,
    p_id_platba    IN NUMBER,
    o_id_kosik     OUT NUMBER
  );
  PROCEDURE PROC_DELETE_KOSIK(
    p_id_kosik     IN NUMBER,
    o_status       OUT NUMBER
  );
END PCK_KOSIKY;
/

CREATE OR REPLACE PACKAGE BODY PCK_KOSIKY AS
  PROCEDURE PROC_INSERT_KOSIK(
    p_datum        IN TIMESTAMP,
    p_cena         IN NUMBER,
    p_sleva        IN NUMBER,
    p_id_uzivatel  IN NUMBER,
    p_id_stav      IN NUMBER,
    p_id_platba    IN NUMBER,
    o_id_kosik     OUT NUMBER
  )
  AS
  BEGIN
    INSERT INTO KOSIKY(datum_vytvoreni, cena, sleva, id_uzivatel, id_stav_objednavky, id_zpusob_platby)
    VALUES (p_datum, p_cena, p_sleva, p_id_uzivatel, p_id_stav, p_id_platba)
    RETURNING id_kosik INTO o_id_kosik;
  END;

  PROCEDURE PROC_UPDATE_KOSIK(
    p_id_kosik     IN NUMBER,
    p_datum        IN TIMESTAMP,
    p_cena         IN NUMBER,
    p_sleva        IN NUMBER,
    p_id_uzivatel  IN NUMBER,
    p_id_stav      IN NUMBER,
    p_id_platba    IN NUMBER,
    o_id_kosik     OUT NUMBER
  )
  AS
  BEGIN
    UPDATE KOSIKY
       SET datum_vytvoreni   = p_datum,
           cena              = p_cena,
           sleva             = p_sleva,
           id_uzivatel       = p_id_uzivatel,
           id_stav_objednavky= p_id_stav,
           id_zpusob_platby  = p_id_platba
     WHERE id_kosik          = p_id_kosik;

    IF SQL%ROWCOUNT = 0 THEN
      PROC_INSERT_KOSIK(p_datum, p_cena, p_sleva, p_id_uzivatel, p_id_stav, p_id_platba, o_id_kosik);
    ELSE
      o_id_kosik := p_id_kosik;
    END IF;
  END;

  PROCEDURE PROC_DELETE_KOSIK(
    p_id_kosik     IN NUMBER,
    o_status       OUT NUMBER
  )
  AS
  BEGIN
    DELETE FROM KOSIKY WHERE id_kosik = p_id_kosik;
    IF SQL%ROWCOUNT = 1 THEN o_status := 1; ELSE RAISE NO_DATA_FOUND; END IF;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN o_status := 0;
    WHEN OTHERS         THEN o_status := -1;
  END;
END PCK_KOSIKY;
/

------------------------------------------------------------------
-- PCK_KVETINYKOSIKY (spojka; insert přičítá množství)
------------------------------------------------------------------
CREATE OR REPLACE PACKAGE PCK_KVETINYKOSIKY AS
  PROCEDURE PROC_INSERT_KK(
    p_id_kosik   IN NUMBER,
    p_id_kvetina IN NUMBER,
    p_pocet      IN NUMBER
  );
  PROCEDURE PROC_UPDATE_KK(
    p_id_kosik   IN NUMBER,
    p_id_kvetina IN NUMBER,
    p_pocet      IN NUMBER
  );
  PROCEDURE PROC_DELETE_KK(
    p_id_kosik   IN NUMBER,
    p_id_kvetina IN NUMBER,
    o_status     OUT NUMBER
  );
END PCK_KVETINYKOSIKY;
/

CREATE OR REPLACE PACKAGE BODY PCK_KVETINYKOSIKY AS
  PROCEDURE PROC_INSERT_KK(
    p_id_kosik   IN NUMBER,
    p_id_kvetina IN NUMBER,
    p_pocet      IN NUMBER
  )
  AS
    v_puvodni_pocet  KVETINYKOSIKY.POCET%TYPE;
  BEGIN
    SELECT pocet
      INTO v_puvodni_pocet
      FROM KVETINYKOSIKY
     WHERE id_kosik = p_id_kosik
       AND id_kvetina = p_id_kvetina;

    UPDATE KVETINYKOSIKY
       SET pocet = v_puvodni_pocet + p_pocet
     WHERE id_kosik = p_id_kosik
       AND id_kvetina = p_id_kvetina;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      INSERT INTO KVETINYKOSIKY(id_kosik, id_kvetina, pocet)
      VALUES (p_id_kosik, p_id_kvetina, p_pocet);
  END;

  PROCEDURE PROC_UPDATE_KK(
    p_id_kosik   IN NUMBER,
    p_id_kvetina IN NUMBER,
    p_pocet      IN NUMBER
  )
  AS
  BEGIN
    UPDATE KVETINYKOSIKY
       SET pocet = p_pocet
     WHERE id_kosik = p_id_kosik
       AND id_kvetina = p_id_kvetina;

    IF SQL%ROWCOUNT = 0 THEN
      INSERT INTO KVETINYKOSIKY(id_kosik, id_kvetina, pocet)
      VALUES (p_id_kosik, p_id_kvetina, p_pocet);
    END IF;
  END;

  PROCEDURE PROC_DELETE_KK(
    p_id_kosik   IN NUMBER,
    p_id_kvetina IN NUMBER,
    o_status     OUT NUMBER
  )
  AS
  BEGIN
    DELETE FROM KVETINYKOSIKY
     WHERE id_kosik = p_id_kosik
       AND id_kvetina = p_id_kvetina;

    IF SQL%ROWCOUNT = 1 THEN o_status := 1; ELSE RAISE NO_DATA_FOUND; END IF;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN o_status := 0;
    WHEN OTHERS         THEN o_status := -1;
  END;
END PCK_KVETINYKOSIKY;
/

------------------------------------------------------------------
-- PCK_DOTAZY
------------------------------------------------------------------
CREATE OR REPLACE PACKAGE PCK_DOTAZY AS
  PROCEDURE PROC_INSERT_DOTAZ(
    p_datum     IN TIMESTAMP,
    p_verejny   IN NUMBER,
    p_text      IN CLOB,
    p_odpoved   IN CLOB,
    p_id_odp    IN NUMBER,
    o_id_dotaz  OUT NUMBER
  );
  PROCEDURE PROC_UPDATE_DOTAZ(
    p_id_dotaz  IN NUMBER,
    p_datum     IN TIMESTAMP,
    p_verejny   IN NUMBER,
    p_text      IN CLOB,
    p_odpoved   IN CLOB,
    p_id_odp    IN NUMBER,
    o_id_dotaz  OUT NUMBER
  );
  PROCEDURE PROC_DELETE_DOTAZ(
    p_id_dotaz IN NUMBER,
    o_status   OUT NUMBER
  );
END PCK_DOTAZY;
/

CREATE OR REPLACE PACKAGE BODY PCK_DOTAZY AS
  PROCEDURE PROC_INSERT_DOTAZ(
    p_datum     IN TIMESTAMP,
    p_verejny   IN NUMBER,
    p_text      IN CLOB,
    p_odpoved   IN CLOB,
    p_id_odp    IN NUMBER,
    o_id_dotaz  OUT NUMBER
  )
  AS
    v_id_dotaz  DOTAZY.ID_DOTAZ%TYPE;
  BEGIN
    INSERT INTO DOTAZY(datum_podani, verejny, text, odpoved, id_odpovidajici_uzivatel)
    VALUES (p_datum, p_verejny, p_text, p_odpoved, p_id_odp)
    RETURNING id_dotaz INTO v_id_dotaz;

    o_id_dotaz := v_id_dotaz;
  END;

  PROCEDURE PROC_UPDATE_DOTAZ(
    p_id_dotaz  IN NUMBER,
    p_datum     IN TIMESTAMP,
    p_verejny   IN NUMBER,
    p_text      IN CLOB,
    p_odpoved   IN CLOB,
    p_id_odp    IN NUMBER,
    o_id_dotaz  OUT NUMBER
  )
  AS
  BEGIN
    UPDATE DOTAZY
       SET datum_podani = p_datum,
           verejny      = p_verejny,
           text         = p_text,
           odpoved      = p_odpoved,
           id_odpovidajici_uzivatel = p_id_odp
     WHERE id_dotaz = p_id_dotaz;

    IF SQL%ROWCOUNT = 0 THEN
      PROC_INSERT_DOTAZ(p_datum, p_verejny, p_text, p_odpoved, p_id_odp, o_id_dotaz);
    ELSE
      o_id_dotaz := p_id_dotaz;
    END IF;
  END;

  PROCEDURE PROC_DELETE_DOTAZ(
    p_id_dotaz IN NUMBER,
    o_status   OUT NUMBER
  )
  AS
  BEGIN
    DELETE FROM DOTAZY WHERE id_dotaz = p_id_dotaz;
    IF SQL%ROWCOUNT = 1 THEN o_status := 1; ELSE RAISE NO_DATA_FOUND; END IF;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN o_status := 0;
    WHEN OTHERS         THEN o_status := -1;
  END;
END PCK_DOTAZY;
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


