package kvetinarstvi.backend.service;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
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

    @Autowired
    private OpravneniService opravneniService;

    @Autowired
    private ObrazekService obrazekService;

    @Autowired
    private AdresaService adresaService;

    public Optional<Uzivatel> findUzivatelById(Integer id) {
        return null;
    }

    public List<Uzivatel> findAllUzivatele() {

        try (Connection c = dataSource.getConnection())  {
            Statement stmt = c.createStatement();        
            ResultSet rs = stmt.executeQuery("SELECT id_uzivatel, email, pw_hash, salt, id_opravneni, id_obrazek, id_adresa FROM uzivatele");

            if (rs.next()) {
                String result = rs.getString(1);
                System.out.println("Success!");
                System.out.println(result);
            } else {
                System.out.println("Connection success, dual returned zero rows");
            }
        } catch (Exception e) {
            System.out.println("Connection failure");    
        }

        return null;
    }

}
