package kvetinarstvi.backend.controller;

import kvetinarstvi.backend.records.Log;
import kvetinarstvi.backend.service.LogsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.sql.SQLException;
import java.util.List;

@RestController
@RequestMapping("/api/logs")
public class LogsController {

    @Autowired
    private LogsService service;

    @GetMapping("")
    public ResponseEntity<List<Log>> findAll() {
        try {
            List<Log> items = service.findAll();

            return ResponseEntity.ok(items);
        } catch (SQLException e) {
            return ResponseEntity.internalServerError().build();
        }
    }
}
