package kvetinarstvi.backend.controller;

import kvetinarstvi.backend.records.Obrazek;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/obrazky")
public class ObrazekController extends AbstractController<Obrazek> {
}
