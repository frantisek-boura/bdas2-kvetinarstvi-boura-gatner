package kvetinarstvi.backend.controller;

import kvetinarstvi.backend.records.Kategorie;
import kvetinarstvi.backend.records.LogAkce;
import kvetinarstvi.backend.service.LogAkceService;
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
@RequestMapping("/api/logakce")
public class LogAkceController {

    @Autowired
    private LogAkceService service;

    @GetMapping("")
    public ResponseEntity<List<LogAkce>> getAllLogAkce() {
        try {
            List<LogAkce> kategorie = service.findAllLogAkce();

            if (kategorie.isEmpty()) {
                return ResponseEntity.noContent().build();
            }

            return ResponseEntity.ok(kategorie);
        } catch (SQLException e) {
            return ResponseEntity.internalServerError().build();
        }
    }

    @GetMapping("/{id}")
    public ResponseEntity<LogAkce> getLogAkceById(@PathVariable Integer id) {
        try {
            Optional<LogAkce> logakce = service.findLogAkceById(id);

            if (logakce.isEmpty()) {
                return ResponseEntity.notFound().build();
            }

            return ResponseEntity.ok(logakce.get());
        } catch (SQLException e) {
            return ResponseEntity.internalServerError().build();
        }
    }
}
