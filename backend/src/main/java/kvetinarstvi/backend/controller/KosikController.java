package kvetinarstvi.backend.controller;

import kvetinarstvi.backend.records.Kosik;
import kvetinarstvi.backend.repository.Status;
import kvetinarstvi.backend.service.ObjednavkaRequest;
import kvetinarstvi.backend.service.ObjednavkaService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/kosiky")
public class KosikController extends AbstractController<Kosik> {

    @Autowired
    private ObjednavkaService service;

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
}

