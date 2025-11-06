package kvetinarstvi.backend.records;

public record Uzivatel(Integer id_uzivatel, String email, String hash, String salt, Opravneni opravneni, Obrazek obrazek, Adresa adresa) {
    
}
