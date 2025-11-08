package kvetinarstvi.backend.controller;

import kvetinarstvi.backend.records.ZpusobPlatby;
import kvetinarstvi.backend.repository.ZpusobPlatbyRepository;
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
@RequestMapping("/api/zpusobyplateb")
public class ZpusobPlatbyController {

    @Autowired
    private ZpusobPlatbyRepository repository;

    @GetMapping("")
    public ResponseEntity<List<ZpusobPlatby>> getAllZpusobyPlateb() {
        try {
            List<ZpusobPlatby> zpusobyplateb = repository.findAllZpusobyPlateb();

            if (zpusobyplateb.isEmpty()) {
                return ResponseEntity.noContent().build();
            }

            return ResponseEntity.ok(zpusobyplateb);
        } catch (SQLException e) {
            return ResponseEntity.internalServerError().build();
        }
    }

    @GetMapping("/{id}")
    public ResponseEntity<ZpusobPlatby> getZpusobPlatbyById(@PathVariable Integer id) {
        try {
            Optional<ZpusobPlatby> zpusobPlatby = repository.findZpusobPlatbyById(id);

            if (zpusobPlatby.isEmpty()) {
                return ResponseEntity.notFound().build();
            }

            return ResponseEntity.ok(zpusobPlatby.get());
        } catch (SQLException e) {
            return ResponseEntity.internalServerError().build();
        }
    }

}
