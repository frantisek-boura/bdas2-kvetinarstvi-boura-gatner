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

import kvetinarstvi.backend.records.PSC;
import kvetinarstvi.backend.repository.PSCRepository;

@RestController
@RequestMapping("/api/psc")
public class PSCController {
    
    @Autowired
    private PSCRepository repository;

    @GetMapping("")
    public ResponseEntity<List<PSC>> getAllPSC() {
        try {
            List<PSC> psc = repository.findAllPSC();

            if (psc.isEmpty()) {
                return ResponseEntity.noContent().build();
            }

            return ResponseEntity.ok(psc);
        } catch (SQLException e) {
            return ResponseEntity.internalServerError().build();
        } 
    }

    @GetMapping("/{id}")
    public ResponseEntity<PSC> getPSCById(@PathVariable Integer id) {
        try {
            Optional<PSC> psc = repository.findPSCById(id);

            if (psc.isEmpty()) {
                return ResponseEntity.notFound().build();
            }

            return ResponseEntity.ok(psc.get());
        } catch (SQLException e) {
            return ResponseEntity.internalServerError().build();
        } 
    }

}
