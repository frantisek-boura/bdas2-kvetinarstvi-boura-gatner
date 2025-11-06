package kvetinarstvi.backend.controller;

import kvetinarstvi.backend.records.Mesto;
import kvetinarstvi.backend.records.Obrazek;
import kvetinarstvi.backend.service.ObrazekService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.sql.SQLException;
import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/obrazky")
public class ObrazekController {

    @Autowired
    private ObrazekService service;

    @GetMapping("")
    public ResponseEntity<List<Obrazek>> getAllObrazky() {
        try {
            List<Obrazek> mesta = service.findAllObrazky();

            if (mesta.isEmpty()) {
                return ResponseEntity.noContent().build();
            }

            return ResponseEntity.ok(mesta);
        } catch (SQLException e) {
            return ResponseEntity.internalServerError().build();
        }
    }

    @GetMapping("/{id}")
    public ResponseEntity<Obrazek> getObrazekById(@PathVariable Integer id) {
        try {
            Optional<Obrazek> obrazek = service.findObrazekById(id);

            if (obrazek.isEmpty()) {
                return ResponseEntity.notFound().build();
            }

            return ResponseEntity.ok(obrazek.get());
        } catch (SQLException e) {
            return ResponseEntity.internalServerError().build();
        }
    }

}
