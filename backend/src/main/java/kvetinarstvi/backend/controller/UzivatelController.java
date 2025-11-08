package kvetinarstvi.backend.controller;

import kvetinarstvi.backend.records.Uzivatel;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import kvetinarstvi.backend.repository.UzivatelRepository;

import java.sql.SQLException;
import java.util.List;
import java.util.Optional;


@RestController
@RequestMapping("/api/uzivatele")
public class UzivatelController {

    @Autowired
    private UzivatelRepository repository;

    @GetMapping("")
    public ResponseEntity<List<Uzivatel>> getAllUzivatele() {
        try {
            List<Uzivatel> uzivatele = repository.findAllUzivatele();

            if (uzivatele.isEmpty()) {
                return ResponseEntity.noContent().build();
            }

            return ResponseEntity.ok(uzivatele);
        } catch (SQLException e) {
            return ResponseEntity.internalServerError().build();
        }
    }

    @GetMapping("/{id}")
    public ResponseEntity<Uzivatel> getUzivatelById(@PathVariable Integer id) {
        try {
            Optional<Uzivatel> uzivatel = repository.findUzivatelById(id);

            if (uzivatel.isEmpty()) {
                return ResponseEntity.notFound().build();
            }

            return ResponseEntity.ok(uzivatel.get());
        } catch (SQLException e) {
            return ResponseEntity.internalServerError().build();
        }
    }

}
