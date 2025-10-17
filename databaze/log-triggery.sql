
-- priklad triggeru
CREATE OR REPLACE TRIGGER t_log_mesta AFTER
   INSERT OR UPDATE OR DELETE ON mesta
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

insert into mesta(nazev) values ('Pardubice');
commit;

update mesta 
set nazev = 'Hradec Králové'
where id_mesto = 8;
commit;

delete from mesta
where id_mesto = 8;
commit;

truncate table mesta;
truncate table logs;