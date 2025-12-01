package kvetinarstvi.backend.controller;

import kvetinarstvi.backend.repository.AdresaRepository;
import kvetinarstvi.backend.repository.AdresaZkratka;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import kvetinarstvi.backend.records.Adresa;

import java.sql.SQLException;
import java.util.List;

@RestController
@RequestMapping("/api/adresy")
public class AdresaController extends AbstractController<Adresa> {

    @GetMapping("/zkratky")
    public ResponseEntity<List<AdresaZkratka>> findZkratky() {
        try {
            List<AdresaZkratka> items = ((AdresaRepository) repository).findZkratky();

            return ResponseEntity.ok(items);
        } catch (SQLException e) {
            return ResponseEntity.internalServerError().build();
        }
    }
}
