package kvetinarstvi.backend.controller;

import kvetinarstvi.backend.records.Dotaz;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/dotazy")
public class DotazController extends AbstractController<Dotaz> {
}
