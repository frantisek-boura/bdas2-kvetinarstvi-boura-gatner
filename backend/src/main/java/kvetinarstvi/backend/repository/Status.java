package kvetinarstvi.backend.repository;

public record Status<E>(Integer status_code, String status_message, E value) {
}
