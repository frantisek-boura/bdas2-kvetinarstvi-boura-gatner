package kvetinarstvi.backend.controller;

import kvetinarstvi.backend.records.Uzivatel;
import kvetinarstvi.backend.repository.Status;
import kvetinarstvi.backend.service.LoginRequest;
import kvetinarstvi.backend.service.RegistraceRequest;
import kvetinarstvi.backend.service.UzivatelService;
import kvetinarstvi.backend.service.ZmenaHeslaRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/uzivatele")
public class UzivatelController extends AbstractController<Uzivatel> {

    @Autowired
    private UzivatelService service;

    @PostMapping("/registrace")
    public ResponseEntity<Status<Void>> registerUzivatel(@RequestBody RegistraceRequest request) {
        Status<Void> result = service.registerUzivatel(request);

        if (result.status_code() == 1) {
            return new ResponseEntity<>(result, HttpStatus.CREATED);
        } else if (result.status_code() == -999) {
            return new ResponseEntity<>(result, HttpStatus.INTERNAL_SERVER_ERROR);
        } else {
            return new ResponseEntity<>(result, HttpStatus.BAD_REQUEST);
        }
    }

    @PostMapping("/login")
    public ResponseEntity<Status<Void>> verifyUzivatel(@RequestBody LoginRequest request) {
        Status<Void> result = service.verifyUzivatel(request);

        if (result.status_code() == -1) {
            return new ResponseEntity<>(result, HttpStatus.NOT_FOUND);
        } else if (result.status_code() == 0) {
            return new ResponseEntity<>(result, HttpStatus.BAD_REQUEST);
        } else if (result.status_code() == 1) {
            return new ResponseEntity<>(result, HttpStatus.OK);
        } else {
            return new ResponseEntity<>(result, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @PostMapping("/zmena-hesla")
    public ResponseEntity<Status<String>> changeHeslo(@RequestBody ZmenaHeslaRequest request) {
        Status<String> result = service.changeHeslo(request);

        if (result.status_code() == 1) {
            return new ResponseEntity<>(result, HttpStatus.OK);
        } else {
            return new ResponseEntity<>(result, HttpStatus.BAD_REQUEST);
        }
    }

}
