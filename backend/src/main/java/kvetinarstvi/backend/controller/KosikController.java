package kvetinarstvi.backend.controller;

import kvetinarstvi.backend.records.Kosik;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/kosiky")
public class KosikController extends AbstractController<Kosik> {
}

