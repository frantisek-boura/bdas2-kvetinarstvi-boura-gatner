package kvetinarstvi.backend.service;

import java.util.List;

public record UzivatelObjednavka(Integer id_kosik, List<UzivatelPolozka> polozky) {
}
