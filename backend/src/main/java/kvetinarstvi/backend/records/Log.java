package kvetinarstvi.backend.records;

import java.time.ZonedDateTime;

public record Log(Integer id_log, String akce, String nazev_tabulky, ZonedDateTime datum_akce, String novy_zaznam, String stary_zaznam) {
}
