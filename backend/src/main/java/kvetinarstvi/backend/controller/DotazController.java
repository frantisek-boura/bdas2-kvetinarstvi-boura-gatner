package kvetinarstvi.backend.controller;

import kvetinarstvi.backend.records.Dotaz;
import kvetinarstvi.backend.repository.DotazRepository;
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
@RequestMapping("/api/dotazy")
public class DotazController {

    @Autowired
    private DotazRepository repository;

    @GetMapping("")
    public ResponseEntity<List<Dotaz>> getAllDotazy() {
        try {
            List<Dotaz> dotazy = repository.findAllDotazy();

            if (dotazy.isEmpty()) {
                return ResponseEntity.noContent().build();
            }

            return ResponseEntity.ok(dotazy);
        } catch (SQLException e) {
            return ResponseEntity.internalServerError().build();
        }
    }

    @GetMapping("/{id}")
    public ResponseEntity<Dotaz> getDotazById(@PathVariable Integer id) {
        try {
            Optional<Dotaz> dotaz = repository.findDotazById(id);

            if (dotaz.isEmpty()) {
                return ResponseEntity.notFound().build();
            }

            return ResponseEntity.ok(dotaz.get());
        } catch (SQLException e) {
            return ResponseEntity.internalServerError().build();
        }
    }
}
