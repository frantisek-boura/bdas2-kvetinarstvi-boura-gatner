package kvetinarstvi.backend.service;

import java.util.Optional;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kvetinarstvi.backend.records.Adresa;

@Service
public class AdresaService {
    
    @Autowired
    private DataSource dataSource;

    @Autowired
    private MestoService mestoService;

    @Autowired
    private UliceService uliceService;

    @Autowired
    private PSCService pscService;

    public Optional<Adresa> findAdresaById(Integer id) {
        return null;
    }

}
