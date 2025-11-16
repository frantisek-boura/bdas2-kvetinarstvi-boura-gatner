package kvetinarstvi.backend.controller;

import org.springframework.web.bind.annotation.*;

import kvetinarstvi.backend.records.Mesto;

@RestController
@RequestMapping("/api/mesta")
public class MestoController extends AbstractController<Mesto> {

}
