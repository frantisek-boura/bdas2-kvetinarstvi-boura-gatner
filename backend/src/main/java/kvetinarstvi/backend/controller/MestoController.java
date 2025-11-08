package kvetinarstvi.backend.controller;

import java.sql.SQLException;
import java.util.List;
import java.util.Optional;

import kvetinarstvi.backend.repository.enums.DeleteStatus;
import kvetinarstvi.backend.request.MestoRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import kvetinarstvi.backend.records.Mesto;
import kvetinarstvi.backend.repository.MestoRepository;

@RestController
@RequestMapping("/api/mesta")
public class MestoController {

    @Autowired
    private MestoRepository repository;

    @PostMapping("")
    public ResponseEntity<Mesto> createMesto(@RequestBody MestoRequest request) {
        try {
            Mesto mesto = repository.createMesto(request);

            return ResponseEntity.status(HttpStatus.CREATED).body(mesto);
        } catch (SQLException e) {
            return ResponseEntity.internalServerError().build();
        }
    }

    @PutMapping("")
    public ResponseEntity<Mesto> updateMesto(@RequestBody MestoRequest request) {
        try {
            Mesto mesto = repository.updateMesto(request);

            return ResponseEntity.ok().body(mesto);
        } catch (SQLException e) {
            return ResponseEntity.internalServerError().build();
        }
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteMesto(@PathVariable Integer id) {
        try {
            DeleteStatus status = repository.deleteMesto(id);

            switch (status) {
                case DeleteStatus.SUCCESS -> { return ResponseEntity.noContent().build(); }
                case DeleteStatus.NOT_FOUND -> { return ResponseEntity.notFound().build(); }
                case DeleteStatus.FAILURE -> { return ResponseEntity.internalServerError().build(); }
            }
            return ResponseEntity.internalServerError().build();
        } catch (SQLException e) {
            return ResponseEntity.internalServerError().build();
        }
    }

    @GetMapping("")
    public ResponseEntity<List<Mesto>> getAllMesta() {
        try {
            List<Mesto> mesta = repository.findAllMesta();

            if (mesta.isEmpty()) {
                return ResponseEntity.noContent().build();
            }

            return ResponseEntity.ok(mesta);
        } catch (SQLException e) {
            return ResponseEntity.internalServerError().build();
        } 
    }

    @GetMapping("/{id}")
    public ResponseEntity<Mesto> getMestoById(@PathVariable Integer id) {
        try {
            Optional<Mesto> mesto = repository.findMestoById(id);

            if (mesto.isEmpty()) {
                return ResponseEntity.notFound().build();
            }

            return ResponseEntity.ok(mesto.get());
        } catch (SQLException e) {
            return ResponseEntity.internalServerError().build();
        } 
    }
    
}
