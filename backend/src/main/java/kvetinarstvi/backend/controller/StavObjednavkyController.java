package kvetinarstvi.backend.controller;

import kvetinarstvi.backend.records.StavObjednavky;
import kvetinarstvi.backend.repository.StavObjednavkyRepository;
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
@RequestMapping("/api/stavyobjednavek")
public class StavObjednavkyController {

    @Autowired
    private StavObjednavkyRepository repository;

    @GetMapping("")
    public ResponseEntity<List<StavObjednavky>> getAllStavyObjednavek() {
        try {
            List<StavObjednavky> stavyobjednavek = repository.findAllStavyObjednavek();

            if (stavyobjednavek.isEmpty()) {
                return ResponseEntity.noContent().build();
            }

            return ResponseEntity.ok(stavyobjednavek);
        } catch (SQLException e) {
            return ResponseEntity.internalServerError().build();
        }
    }

    @GetMapping("/{id}")
    public ResponseEntity<StavObjednavky> getStavObjednavkyById(@PathVariable Integer id) {
        try {
            Optional<StavObjednavky> stavObjednavky = repository.findStavObjednavkyById(id);

            if (stavObjednavky.isEmpty()) {
                return ResponseEntity.notFound().build();
            }

            return ResponseEntity.ok(stavObjednavky.get());
        } catch (SQLException e) {
            return ResponseEntity.internalServerError().build();
        }
    }

}
