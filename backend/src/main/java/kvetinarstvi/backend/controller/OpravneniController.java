package kvetinarstvi.backend.controller;

import java.sql.SQLException;
import java.util.List;
import java.util.Optional;

import kvetinarstvi.backend.records.Mesto;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import kvetinarstvi.backend.records.Adresa;
import kvetinarstvi.backend.records.Opravneni;
import kvetinarstvi.backend.service.OpravneniService;

@RestController
@RequestMapping("/api/opravneni")
public class OpravneniController {
    
    @Autowired
    private OpravneniService service;

    @GetMapping("")
    public ResponseEntity<List<Opravneni>> getAllOpravneni() {
        try {
            List<Opravneni> opravneni = service.findAllOpravneni();

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
            Optional<Opravneni> opravneni = service.findOpravneniById(id);

            if (opravneni.isEmpty()) {
                return ResponseEntity.notFound().build();
            }

            return ResponseEntity.ok(opravneni.get());
        } catch (SQLException e) {
            return ResponseEntity.internalServerError().build();
        }
    }

}
