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

import kvetinarstvi.backend.records.Adresa;
import kvetinarstvi.backend.repository.AdresaRepository;

@RestController
@RequestMapping("/api/adresy")
public class AdresaController {

    @Autowired
    private AdresaRepository repository;

    @GetMapping("")
    public ResponseEntity<List<Adresa>> getAllAdresy() {
        try {
            List<Adresa> adresy = repository.findAllAdresy();

            if (adresy.isEmpty()) {
                return ResponseEntity.noContent().build();
            }

            return ResponseEntity.ok(adresy);
        } catch (SQLException e) {
            return ResponseEntity.internalServerError().build();
        } 
    }

    @GetMapping("/{id}")
    public ResponseEntity<Adresa> getAdresaById(@PathVariable Integer id) {
        try {
            Optional<Adresa> adresa = repository.findAdresaById(id);

            if (adresa.isEmpty()) {
                return ResponseEntity.notFound().build();
            }

            return ResponseEntity.ok(adresa.get());
        } catch (SQLException e) {
            return ResponseEntity.internalServerError().build();
        } 
    }
    
}
