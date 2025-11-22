package kvetinarstvi.backend.service;

public record ZmenaHeslaRequest(Integer id_uzivatel, boolean generovat_heslo, String nove_heslo) {
}
