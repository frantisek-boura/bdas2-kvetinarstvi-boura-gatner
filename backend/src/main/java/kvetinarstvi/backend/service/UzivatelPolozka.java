package kvetinarstvi.backend.service;

public record UzivatelPolozka(Integer id_kvetina, Double cena_za_kus, Integer pocet, String nazev, Integer id_obrazek, String nazev_souboru, byte[] data, Integer id_kategorie, String nazev_kategorie) {
}
