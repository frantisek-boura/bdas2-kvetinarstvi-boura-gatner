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

import kvetinarstvi.backend.records.Ulice;
import kvetinarstvi.backend.service.UliceService;

@RestController
@RequestMapping("/api/ulice")
public class UliceController {

    @Autowired
    private UliceService service;

    @GetMapping("")
    public ResponseEntity<List<Ulice>> getAllUlice() {
        try {
            List<Ulice> ulice = service.findAllUlice();

            if (ulice.isEmpty()) {
                return ResponseEntity.noContent().build();
            }

            return ResponseEntity.ok(ulice);
        } catch (SQLException e) {
            return ResponseEntity.internalServerError().build();
        } 
    }

    @GetMapping("/{id}")
    public ResponseEntity<Ulice> getUliceById(@PathVariable Integer id) {
        try {
            Optional<Ulice> ulice = service.findUliceById(id);

            if (ulice.isEmpty()) {
                return ResponseEntity.notFound().build();
            }

            return ResponseEntity.ok(ulice.get());
        } catch (SQLException e) {
            return ResponseEntity.internalServerError().build();
        } 
    }
    
}
