
-- priklad triggeru
CREATE OR REPLACE TRIGGER t_log_mesta AFTER
   INSERT OR UPDATE OR DELETE ON Mesta
   FOR EACH ROW
DECLARE
   v_id_log_akce logakce.id_log_akce%TYPE;
   v_json_data_novy logs.novy_zaznam%TYPE;
   v_json_data_stary logs.stary_zaznam%TYPE DEFAULT NULL;
BEGIN
   CASE
      WHEN INSERTING THEN
         SELECT id_log_akce
         INTO v_id_log_akce
         FROM logakce
         WHERE nazev = 'Insert';

         v_json_data_novy := JSON_OBJECT(
            'id_mesto' VALUE :NEW.id_mesto,
            'nazev'    VALUE :NEW.nazev
         );
      WHEN UPDATING THEN
         SELECT id_log_akce
         INTO v_id_log_akce
         FROM logakce
         WHERE nazev = 'Update';

         v_json_data_stary := JSON_OBJECT(
            'id_mesto' VALUE :OLD.id_mesto,
            'nazev'    VALUE :OLD.nazev
         );

         v_json_data_novy := JSON_OBJECT(
            'id_mesto' VALUE :NEW.id_mesto,
            'nazev'    VALUE :NEW.nazev
         );
      WHEN DELETING THEN
         SELECT id_log_akce
         INTO v_id_log_akce
         FROM logakce
         WHERE nazev = 'Delete';

         v_json_data_novy := JSON_OBJECT(
            'id_mesto' VALUE :OLD.id_mesto,
            'nazev'    VALUE :OLD.nazev
         );
   END CASE;

   INSERT INTO logs(nazev_tabulky, datum, novy_zaznam, stary_zaznam, id_log_akce)
   VALUES ('mesta', CURRENT_TIMESTAMP, v_json_data_novy, v_json_data_stary, v_id_log_akce);
END;
/

CREATE OR REPLACE TRIGGER t_log_uzivatele
AFTER INSERT OR UPDATE OR DELETE ON Uzivatele
FOR EACH ROW
DECLARE
    v_id_log_akce logakce.id_log_akce%TYPE;
   v_json_data_novy logs.novy_zaznam%TYPE;
   v_json_data_stary logs.stary_zaznam%TYPE DEFAULT NULL;
BEGIN
    CASE
        WHEN INSERTING THEN
            SELECT id_log_akce INTO v_id_log_akce FROM LogAkce WHERE nazev = 'Insert';
            v_json_data_novy := JSON_OBJECT(
                'id_uzivatel' VALUE :NEW.id_uzivatel,
                'email' VALUE :NEW.email,
                'pw_hash' VALUE :NEW.pw_hash,
                'salt' VALUE :NEW.salt,
                'id_opravneni' VALUE :NEW.id_opravneni,
                'id_obrazek' VALUE :NEW.id_obrazek,
                'id_adresa' VALUE :NEW.id_adresa
            );
        WHEN UPDATING THEN
            SELECT id_log_akce INTO v_id_log_akce FROM LogAkce WHERE nazev = 'Update';
            v_json_data_stary := JSON_OBJECT(
                'id_uzivatel' VALUE :OLD.id_uzivatel,
                'email' VALUE :OLD.email,
                'id_opravneni' VALUE :OLD.id_opravneni,
                'id_obrazek' VALUE :OLD.id_obrazek,
                'id_adresa' VALUE :OLD.id_adresa
            );
            v_json_data_novy := JSON_OBJECT(
                'id_uzivatel' VALUE :NEW.id_uzivatel,
                'email' VALUE :NEW.email,
                'id_opravneni' VALUE :NEW.id_opravneni,
                'id_obrazek' VALUE :NEW.id_obrazek,
                'id_adresa' VALUE :NEW.id_adresa
            );
        WHEN DELETING THEN
            SELECT id_log_akce INTO v_id_log_akce FROM LogAkce WHERE nazev = 'Delete';
            v_json_data_novy := JSON_OBJECT(
                'id_uzivatel' VALUE :OLD.id_uzivatel,
                'email' VALUE :OLD.email,
                'id_opravneni' VALUE :OLD.id_opravneni,
                'id_obrazek' VALUE :OLD.id_obrazek,
                'id_adresa' VALUE :OLD.id_adresa
            );
    END CASE;

    INSERT INTO logs (nazev_tabulky, datum, novy_zaznam, stary_zaznam, id_log_akce)
    VALUES ('UZIVATELE', CURRENT_TIMESTAMP, v_json_data_novy, v_json_data_stary, v_id_log_akce);
END;
/

create or replace TRIGGER t_log_kosiky
AFTER INSERT OR UPDATE OR DELETE ON Kosiky
FOR EACH ROW
DECLARE
    v_id_log_akce logakce.id_log_akce%TYPE;
   v_json_data_novy logs.novy_zaznam%TYPE;
   v_json_data_stary logs.stary_zaznam%TYPE DEFAULT NULL;
BEGIN
    CASE
        WHEN INSERTING THEN
            SELECT id_log_akce INTO v_id_log_akce FROM LogAkce WHERE nazev = 'Insert';
            v_json_data_novy := JSON_OBJECT(
                'id_kosik' VALUE :NEW.id_kosik,
                'datum_vytvoreni' VALUE TO_CHAR(:NEW.datum_vytvoreni, 'YYYY-MM-DD HH24:MI:SS'),
                'cena' VALUE :NEW.cena,
                'sleva' VALUE :NEW.sleva,
                'id_uzivatel' VALUE :NEW.id_uzivatel,
                'id_stav_objednavky' VALUE :NEW.id_stav_objednavky,
                'id_zpusob_platby' VALUE :NEW.id_zpusob_platby
            );
        WHEN UPDATING THEN
            SELECT id_log_akce INTO v_id_log_akce FROM LogAkce WHERE nazev = 'Update';
            v_json_data_stary := JSON_OBJECT(
                'id_kosik' VALUE :OLD.id_kosik,
                'cena' VALUE :OLD.cena,
                'sleva' VALUE :OLD.sleva,
                'id_stav_objednavky' VALUE :OLD.id_stav_objednavky
            );
            v_json_data_novy := JSON_OBJECT(
                'id_kosik' VALUE :NEW.id_kosik,
                'cena' VALUE :NEW.cena,
                'sleva' VALUE :NEW.sleva,
                'id_stav_objednavky' VALUE :NEW.id_stav_objednavky
            );
        WHEN DELETING THEN
            SELECT id_log_akce INTO v_id_log_akce FROM LogAkce WHERE nazev = 'Delete';
            v_json_data_novy := JSON_OBJECT(
                'id_kosik' VALUE :OLD.id_kosik,
                'datum_vytvoreni' VALUE TO_CHAR(:OLD.datum_vytvoreni, 'YYYY-MM-DD HH24:MI:SS'),
                'cena' VALUE :OLD.cena,
                'sleva' VALUE :OLD.sleva,
                'id_uzivatel' VALUE :OLD.id_uzivatel,
                'id_stav_objednavky' VALUE :OLD.id_stav_objednavky,
                'id_zpusob_platby' VALUE :OLD.id_zpusob_platby
            );
    END CASE;

    INSERT INTO logs (nazev_tabulky, datum, novy_zaznam, stary_zaznam, id_log_akce)
    VALUES ('KOSIKY', CURRENT_TIMESTAMP, v_json_data_novy, v_json_data_stary, v_id_log_akce);
END;
/

CREATE OR REPLACE TRIGGER t_log_kvetiny
AFTER INSERT OR UPDATE OR DELETE ON Kvetiny
FOR EACH ROW
DECLARE
    v_id_log_akce logakce.id_log_akce%TYPE;
   v_json_data_novy logs.novy_zaznam%TYPE;
   v_json_data_stary logs.stary_zaznam%TYPE DEFAULT NULL;
BEGIN
    CASE
        WHEN INSERTING THEN
            SELECT id_log_akce INTO v_id_log_akce FROM LogAkce WHERE nazev = 'Insert';
            v_json_data_novy := JSON_OBJECT(
                'id_kvetina' VALUE :NEW.id_kvetina,
                'nazev' VALUE :NEW.nazev,
                'cena' VALUE :NEW.cena,
                'id_kategorie' VALUE :NEW.id_kategorie,
                'id_obrazek' VALUE :NEW.id_obrazek
            );
        WHEN UPDATING THEN
            SELECT id_log_akce INTO v_id_log_akce FROM LogAkce WHERE nazev = 'Update';
            v_json_data_stary := JSON_OBJECT(
                'id_kvetina' VALUE :OLD.id_kvetina,
                'nazev' VALUE :OLD.nazev,
                'cena' VALUE :OLD.cena,
                'id_kategorie' VALUE :OLD.id_kategorie,
                'id_obrazek' VALUE :OLD.id_obrazek
            );
            v_json_data_novy := JSON_OBJECT(
                'id_kvetina' VALUE :NEW.id_kvetina,
                'nazev' VALUE :NEW.nazev,
                'cena' VALUE :NEW.cena,
                'id_kategorie' VALUE :NEW.id_kategorie,
                'id_obrazek' VALUE :NEW.id_obrazek
            );
        WHEN DELETING THEN
            SELECT id_log_akce INTO v_id_log_akce FROM LogAkce WHERE nazev = 'Delete';
            v_json_data_novy := JSON_OBJECT(
                'id_kvetina' VALUE :OLD.id_kvetina,
                'nazev' VALUE :OLD.nazev,
                'cena' VALUE :OLD.cena,
                'id_kategorie' VALUE :OLD.id_kategorie,
                'id_obrazek' VALUE :OLD.id_obrazek
            );
    END CASE;

    INSERT INTO logs (nazev_tabulky, datum, novy_zaznam, stary_zaznam, id_log_akce)
    VALUES ('KVETINY', CURRENT_TIMESTAMP, v_json_data_novy, v_json_data_stary, v_id_log_akce);
END;
/
