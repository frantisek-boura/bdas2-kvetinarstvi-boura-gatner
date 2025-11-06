package kvetinarstvi.backend.controller;

import java.sql.SQLException;
import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import kvetinarstvi.backend.records.Mesto;
import kvetinarstvi.backend.service.MestoService;

@RestController
@RequestMapping("/api/mesta")
public class MestoController {

    @Autowired
    private MestoService service;

    @GetMapping("")
    public ResponseEntity<List<Mesto>> getAllMesta() {
        try {
            List<Mesto> mesta = service.findAllMesta();

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
            Optional<Mesto> mesto = service.findMestoById(id);

            if (mesto.isEmpty()) {
                return ResponseEntity.notFound().build();
            }

            return ResponseEntity.ok(mesto.get());
        } catch (SQLException e) {
            return ResponseEntity.internalServerError().build();
        } 
    }
    
}
