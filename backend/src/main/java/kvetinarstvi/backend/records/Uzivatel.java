package kvetinarstvi.backend.records;

public record Uzivatel(Integer id_uzivatel, String email, String pw_hash, String salt, Integer id_opravneni, Integer id_obrazek, Integer id_adresa) {
    
}
