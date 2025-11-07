package kvetinarstvi.backend.records;

import java.time.OffsetDateTime;

public record Dotaz(Integer id_dotaz, OffsetDateTime datum_podani, boolean verejny, String text, String odpoved, Uzivatel odpovidajici_uzivatel) {
}
