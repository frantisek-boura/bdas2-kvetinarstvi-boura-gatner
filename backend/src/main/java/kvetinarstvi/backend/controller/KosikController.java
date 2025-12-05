package kvetinarstvi.backend.controller;

import kvetinarstvi.backend.records.Kosik;
import kvetinarstvi.backend.repository.Status;
import kvetinarstvi.backend.service.ObjednavkaRequest;
import kvetinarstvi.backend.service.KosikService;
import kvetinarstvi.backend.service.UzivatelObjednavka;
import kvetinarstvi.backend.service.UzivatelPolozka;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.sql.SQLException;
import java.util.List;

@RestController
@RequestMapping("/api/kosiky")
public class KosikController extends AbstractController<Kosik> {

    @Autowired
    private KosikService service;

    @PostMapping("/podani")
    public ResponseEntity<Status<Kosik>> podatObjednavku(@RequestBody ObjednavkaRequest request) {
        Status<Kosik> result = service.podatObjednavku(
                request.id_uzivatel(),
                request.id_zpusob_platby(),
                request.objednaneKvetiny()
        );

        if (result.status_code() == 1) {
            return new ResponseEntity<>(result, HttpStatus.CREATED);
        } else if (result.status_code() == -999) {
            return new ResponseEntity<>(result, HttpStatus.INTERNAL_SERVER_ERROR);
        } else {
            return new ResponseEntity<>(result, HttpStatus.BAD_REQUEST);
        }
    }

    @GetMapping("/polozky/{id}")
    protected ResponseEntity<List<UzivatelPolozka>> getPolozky(@PathVariable Integer id) {
        try {
            List<UzivatelPolozka> items = service.getPolozky(id);

            return ResponseEntity.ok(items);
        } catch (SQLException e) {
            return ResponseEntity.internalServerError().build();
        }
    }
}

