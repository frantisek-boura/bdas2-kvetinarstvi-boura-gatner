package kvetinarstvi.backend.controller;

import kvetinarstvi.backend.records.Kvetina;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/kvetiny")
public class KvetinaController extends AbstractController<Kvetina> {
}
