package kvetinarstvi.backend.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import kvetinarstvi.backend.service.UzivatelService;


@RestController
@RequestMapping("/api/uzivatele")
public class UzivatelController {

    @Autowired
    private UzivatelService service;

    @GetMapping("/")
    public String getUzivatele() {
        //return service.helloWorld();
        return "";
    }

}
