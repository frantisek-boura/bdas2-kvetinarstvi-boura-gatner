package kvetinarstvi.backend.service;

import java.util.Optional;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kvetinarstvi.backend.records.Obrazek;

@Service
public class ObrazekService {
    
    @Autowired
    private DataSource dataSource;

    public Optional<Obrazek> findObrazekById(Integer id) {
        return null;
    }
}
