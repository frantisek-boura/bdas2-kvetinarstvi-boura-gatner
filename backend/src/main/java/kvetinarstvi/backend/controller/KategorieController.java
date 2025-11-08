package kvetinarstvi.backend.controller;

import kvetinarstvi.backend.records.Kategorie;
import kvetinarstvi.backend.repository.KategorieRepository;
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
@RequestMapping("/api/kategorie")
public class KategorieController {

    @Autowired
    private KategorieRepository repository;

    @GetMapping("")
    public ResponseEntity<List<Kategorie>> getAllKategorie() {
        try {
            List<Kategorie> kategorie = repository.findAllKategorie();

            if (kategorie.isEmpty()) {
                return ResponseEntity.noContent().build();
            }

            return ResponseEntity.ok(kategorie);
        } catch (SQLException e) {
            return ResponseEntity.internalServerError().build();
        }
    }

    @GetMapping("/{id}")
    public ResponseEntity<Kategorie> getKategorieById(@PathVariable Integer id) {
        try {
            Optional<Kategorie> kategorie = repository.findKategorieById(id);

            if (kategorie.isEmpty()) {
                return ResponseEntity.notFound().build();
            }

            return ResponseEntity.ok(kategorie.get());
        } catch (SQLException e) {
            return ResponseEntity.internalServerError().build();
        }
    }

}
