package kvetinarstvi.backend.service;

import java.util.List;
import java.util.Optional;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kvetinarstvi.backend.records.Uzivatel;

@Service
public class UzivatelService {
    
    @Autowired
    private DataSource dataSource;

    public Optional<Uzivatel> findUzivatelById(Integer id) {
        return null;
    }

    public List<Uzivatel> findAllUzivatele() {
        return null;
    }

}
