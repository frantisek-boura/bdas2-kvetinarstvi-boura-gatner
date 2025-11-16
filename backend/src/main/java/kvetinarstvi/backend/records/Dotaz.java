package kvetinarstvi.backend.records;

import java.time.ZonedDateTime;

public record Dotaz(Integer id_dotaz, ZonedDateTime datum_podani, boolean verejny, String text, String odpoved, Integer id_odpovidajici_uzivatel) {
}
