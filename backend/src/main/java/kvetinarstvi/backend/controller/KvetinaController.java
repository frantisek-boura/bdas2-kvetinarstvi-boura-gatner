package kvetinarstvi.backend.controller;

import kvetinarstvi.backend.records.Kvetina;
import kvetinarstvi.backend.service.KvetinaService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.sql.SQLException;
import java.util.List;

@RestController
@RequestMapping("/api/kvetiny")
public class KvetinaController extends AbstractController<Kvetina> {

    @Autowired
    private KvetinaService service;

    @GetMapping("/podle-kategorie/{id}")
    protected ResponseEntity<List<Kvetina>> getKvetinyByKategorie(@PathVariable Integer id) {
        try {
            List<Kvetina> item = service.getKvetinyPodleKategorie(id);

            if (item.isEmpty()) {
                return ResponseEntity.notFound().build();
            }

            return ResponseEntity.ok(item);
        } catch (SQLException e) {
            return ResponseEntity.internalServerError().build();
        }
    }


}
