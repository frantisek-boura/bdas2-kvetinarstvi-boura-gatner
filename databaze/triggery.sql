CREATE OR REPLACE TRIGGER trg_opravneni_uroven_chk
BEFORE INSERT OR UPDATE OF uroven ON OPRAVNENI
FOR EACH ROW
BEGIN
  IF :NEW.uroven IS NULL
     OR :NEW.uroven < 0
     OR :NEW.uroven > 3
  THEN
    RAISE_APPLICATION_ERROR(
      -20020,
      'Uroven opravneni musi byt v rozsahu 0–3.'
    );
  END IF;
END;
/

CREATE OR REPLACE TRIGGER trg_kosiky_datum_ne_minulost
BEFORE INSERT OR UPDATE OF datum_vytvoreni ON KOSIKY
FOR EACH ROW
BEGIN
  IF :NEW.datum_vytvoreni < SYSTIMESTAMP THEN
    RAISE_APPLICATION_ERROR(
      -20030,
      'Datum podani objednavky nesmi byt driv, nez aktualni cas.'
    );
  END IF;
END;
/

CREATE OR REPLACE TRIGGER trg_kvetiny_cena_chk
BEFORE INSERT OR UPDATE OF cena ON KVETINY
FOR EACH ROW
BEGIN
  IF :NEW.cena IS NULL
     OR :NEW.cena < 0
     OR :NEW.cena > 999999999.99
  THEN
    RAISE_APPLICATION_ERROR(
      -20040,
      'Cena kvetiny musi byt v rozsahu 0 az 999999999.99.'
    );
  END IF;
END;
/

CREATE OR REPLACE TRIGGER trg_kosiky_cena_chk
BEFORE INSERT OR UPDATE OF cena ON KOSIKY
FOR EACH ROW
BEGIN
  IF :NEW.cena IS NULL
     OR :NEW.cena < 0
     OR :NEW.cena > 999999999.99
  THEN
    RAISE_APPLICATION_ERROR(
      -20050,
      'Cena objednavky musi byt v rozsahu 0 az 999999999.99.'
    );
  END IF;
END;
/