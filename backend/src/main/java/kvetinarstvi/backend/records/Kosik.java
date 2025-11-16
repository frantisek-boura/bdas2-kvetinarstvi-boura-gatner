package kvetinarstvi.backend.records;

import java.time.ZonedDateTime;

public record Kosik(Integer id_kosik, ZonedDateTime datum_vytvoreni, Double cena, Integer sleva, Integer id_uzivatel, Integer id_stav_objednavky, Integer id_zpusob_platby) {
}
