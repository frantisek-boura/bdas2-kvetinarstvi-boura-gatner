package kvetinarstvi.backend.controller;

import kvetinarstvi.backend.records.Dotaz;
import kvetinarstvi.backend.repository.Status;
import kvetinarstvi.backend.service.DotazRequest;
import kvetinarstvi.backend.service.DotazService;
import kvetinarstvi.backend.service.OdpovedRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/dotazy")
public class DotazController extends AbstractController<Dotaz> {

    @Autowired
    private DotazService service;

    @PostMapping("/pridat-dotaz")
    public ResponseEntity<Status<Dotaz>> addDotaz(@RequestBody DotazRequest request) {
        Status<Dotaz> result = service.addDotaz(request);

        if (result.status_code() == 1) {
            return new ResponseEntity<>(result, HttpStatus.CREATED);
        } else {
            return new ResponseEntity<>(result, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @PostMapping("/odpoved-na-dotaz")
    public ResponseEntity<Status<Dotaz>> addOdpoved(@RequestBody OdpovedRequest request) {
        Status<Dotaz> result = service.addDotaz(request);

        if (result.status_code() == 1) {
            return new ResponseEntity<>(result, HttpStatus.CREATED);
        } else {
            return new ResponseEntity<>(result, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

}
