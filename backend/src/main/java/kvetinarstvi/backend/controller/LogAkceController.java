package kvetinarstvi.backend.controller;

import kvetinarstvi.backend.records.LogAkce;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/logakce")
public class LogAkceController {

    @GetMapping("/api/logakce")
    public ResponseEntity<LogAkce> getLogAkce() {

    }
}
