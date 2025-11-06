package kvetinarstvi.backend.service;

import java.util.Optional;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kvetinarstvi.backend.records.Opravneni;

@Service
public class OpravneniService {
    
    @Autowired
    private DataSource dataSource;
    
    public Optional<Opravneni> findOpravneniById(Integer id) {
        return null;
    }
    
}
