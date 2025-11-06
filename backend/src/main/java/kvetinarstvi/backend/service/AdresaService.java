package kvetinarstvi.backend.service;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kvetinarstvi.backend.records.Adresa;
import kvetinarstvi.backend.records.Mesto;
import kvetinarstvi.backend.records.PSC;
import kvetinarstvi.backend.records.Ulice;

@Service
public class AdresaService {
    
    @Autowired
    private DataSource dataSource;

    public List<Adresa> findAllAdresy() throws SQLException {
        final String QUERY = """
                    SELECT 
                        a.id_adresa, a.cp, 
                        a.id_mesto, m.nazev AS mesto_nazev,
                        a.id_ulice, u.nazev AS ulice_nazev,
                        a.id_psc, p.psc AS psc 
                    FROM 
                        adresy a  
                    JOIN 
                        mesta m ON a.id_mesto = m.id_mesto
                    JOIN
                        ulice u ON a.id_ulice = u.id_ulice
                    JOIN 
                        psc p ON a.id_psc = p.id_psc
                """;
                
        List<Adresa> adresy = new ArrayList<>();

        Connection c = dataSource.getConnection();
        PreparedStatement stmt = c.prepareStatement(QUERY);        
        ResultSet rs = stmt.executeQuery();

        while (rs.next()) {
            int id_adresa = rs.getInt("id_adresa");
            int cp = rs.getInt("cp");
            int id_mesto = rs.getInt("id_mesto");
            String mesto_nazev = rs.getString("mesto_nazev");
            int id_ulice = rs.getInt("id_ulice");
            String ulice_nazev = rs.getString("ulice_nazev");
            int id_psc = rs.getInt("id_psc");
            String psc = rs.getString("psc");


            adresy.add(
                new Adresa(
                    id_adresa, cp,
                    new Mesto(id_mesto, mesto_nazev),
                    new Ulice(id_ulice, ulice_nazev),
                    new PSC(id_psc, psc) 
                ));
        } 

        return adresy;
    }

    public Optional<Adresa> findAdresaById(Integer id) throws SQLException {
        final String QUERY = """
                    SELECT 
                        a.id_adresa, a.cp, 
                        a.id_mesto, m.nazev AS mesto_nazev,
                        a.id_ulice, u.nazev AS ulice_nazev,
                        a.id_psc, p.psc AS psc 
                    FROM 
                        adresy a  
                    JOIN 
                        mesta m ON a.id_mesto = m.id_mesto
                    JOIN
                        ulice u ON a.id_ulice = u.id_ulice
                    JOIN 
                        psc p ON a.id_psc = p.id_psc
                    WHERE
                        a.id_adresa = ?
                """;

        Connection c = dataSource.getConnection();
        PreparedStatement stmt = c.prepareStatement(QUERY);        
        stmt.setInt(1, id);

        ResultSet rs = stmt.executeQuery();

        if (rs.next()) {
            int id_adresa = rs.getInt("id_adresa");
            int cp = rs.getInt("cp");
            int id_mesto = rs.getInt("id_mesto");
            String mesto_nazev = rs.getString("mesto_nazev");
            int id_ulice = rs.getInt("id_ulice");
            String ulice_nazev = rs.getString("ulice_nazev");
            int id_psc = rs.getInt("id_psc");
            String psc = rs.getString("psc");

            return Optional.of(
                new Adresa(
                    id_adresa, cp,
                    new Mesto(id_mesto, mesto_nazev),
                    new Ulice(id_ulice, ulice_nazev),
                    new PSC(id_psc, psc) 
                ));
        } else {
            return Optional.empty();
        }
    }

}
