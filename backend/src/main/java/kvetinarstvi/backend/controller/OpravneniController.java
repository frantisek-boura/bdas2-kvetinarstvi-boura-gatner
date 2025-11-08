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

import kvetinarstvi.backend.records.Opravneni;
import kvetinarstvi.backend.repository.OpravneniRepository;

@RestController
@RequestMapping("/api/opravneni")
public class OpravneniController {
    
    @Autowired
    private OpravneniRepository repository;

    @GetMapping("")
    public ResponseEntity<List<Opravneni>> getAllOpravneni() {
        try {
            List<Opravneni> opravneni = repository.findAllOpravneni();

            if (opravneni.isEmpty()) {
                return ResponseEntity.noContent().build();
            }

            return ResponseEntity.ok(opravneni);
        } catch (SQLException e) {
            return ResponseEntity.internalServerError().build();
        } 
    }

    @GetMapping("/{id}")
    public ResponseEntity<Opravneni> getOpravneniById(@PathVariable Integer id) {
        try {
            Optional<Opravneni> opravneni = repository.findOpravneniById(id);

            if (opravneni.isEmpty()) {
                return ResponseEntity.notFound().build();
            }

            return ResponseEntity.ok(opravneni.get());
        } catch (SQLException e) {
            return ResponseEntity.internalServerError().build();
        }
    }

}
