package kvetinarstvi.backend.service;

public record RegistraceRequest(String email, String heslo, Integer cp, String mesto, String ulice, String psc) {
}
