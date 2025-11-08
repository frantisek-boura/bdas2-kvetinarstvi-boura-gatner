package kvetinarstvi.backend.controller;

import kvetinarstvi.backend.records.Kvetina;
import kvetinarstvi.backend.repository.KvetinaRepository;
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
@RequestMapping("/api/kvetiny")
public class KvetinaController {

    @Autowired
    private KvetinaRepository repository;

    @GetMapping("")
    public ResponseEntity<List<Kvetina>> getAllKvetiny() {
        try {
            List<Kvetina> kvetiny = repository.findAllKvetiny();

            if (kvetiny.isEmpty()) {
                return ResponseEntity.noContent().build();
            }

            return ResponseEntity.ok(kvetiny);
        } catch (SQLException e) {
            return ResponseEntity.internalServerError().build();
        }
    }

    @GetMapping("/{id}")
    public ResponseEntity<Kvetina> getKvetinaById(@PathVariable Integer id) {
        try {
            Optional<Kvetina> kvetina = repository.findKvetinaById(id);

            if (kvetina.isEmpty()) {
                return ResponseEntity.notFound().build();
            }

            return ResponseEntity.ok(kvetina.get());
        } catch (SQLException e) {
            return ResponseEntity.internalServerError().build();
        }
    }

}
