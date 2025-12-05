package kvetinarstvi.backend.controller;

import kvetinarstvi.backend.records.KatalogEntry;
import kvetinarstvi.backend.service.SysKatalogService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.sql.SQLException;
import java.util.List;

@RestController
@RequestMapping("/api/syskatalog")
public class SysKatalogController {

    @Autowired
    private SysKatalogService service;

    @GetMapping("")
    public ResponseEntity<List<KatalogEntry>> findAll() {
        try {
            List<KatalogEntry> items = service.findAll();

            return ResponseEntity.ok(items);
        } catch (SQLException e) {
            return ResponseEntity.internalServerError().build();
        }
    }

}
