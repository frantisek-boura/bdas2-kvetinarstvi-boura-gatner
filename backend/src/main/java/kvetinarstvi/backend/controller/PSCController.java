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
import kvetinarstvi.backend.service.PSCService;

@RestController
@RequestMapping("/api/psc")
public class PSCController {
    
    @Autowired
    private PSCService service;

    @GetMapping("")
    public ResponseEntity<List<PSC>> getAllPSC() {
        try {
            List<PSC> psc = service.findAllPSC();

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
            Optional<PSC> psc = service.findPSCById(id);

            if (psc.isEmpty()) {
                return ResponseEntity.notFound().build();
            }

            return ResponseEntity.ok(psc.get());
        } catch (SQLException e) {
            return ResponseEntity.internalServerError().build();
        } 
    }

}
