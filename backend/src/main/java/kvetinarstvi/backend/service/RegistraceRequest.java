package kvetinarstvi.backend.service;

public record RegistraceRequest(String email, String heslo, String ulice, Integer cp, String mesto,  String psc) {
}
