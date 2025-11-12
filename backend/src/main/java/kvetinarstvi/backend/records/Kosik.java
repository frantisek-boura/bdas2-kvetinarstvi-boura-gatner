package kvetinarstvi.backend.records;

import java.time.OffsetDateTime;
import java.util.List;

public record Kosik(Integer id_kosik, OffsetDateTime datum_vytvoreni, Double cena, Integer sleva, Uzivatel uzivatel, StavObjednavky stav_objednavky, ZpusobPlatby zpusob_platby) {
}
