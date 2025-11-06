package kvetinarstvi.backend.service;

import java.util.Optional;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kvetinarstvi.backend.records.PSC;

@Service
public class UliceService {
    
    @Autowired
    private DataSource dataSource;

    public Optional<PSC> findPSCById(Integer id) {
        return null;
    }

}
