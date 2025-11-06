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

import kvetinarstvi.backend.records.Ulice;

@Service
public class UliceService {
    
    @Autowired
    private DataSource dataSource;

    public List<Ulice> findAllUlice() throws SQLException {
        final String QUERY = "SELECT id_ulice, nazev FROM ulice";
        List<Ulice> ulice = new ArrayList<>();

        Connection c = dataSource.getConnection();
        PreparedStatement stmt = c.prepareStatement(QUERY);        
        ResultSet rs = stmt.executeQuery();

        while (rs.next()) {
            int id_ulice = rs.getInt("id_ulice");
            String nazev = rs.getString("nazev");

            ulice.add(new Ulice(id_ulice, nazev));
        } 

        return ulice;
    }

    public Optional<Ulice> findUliceById(Integer id) throws SQLException {
        final String QUERY = "SELECT id_ulice, nazev FROM ulice WHERE id_ulice = ?";

        Connection c = dataSource.getConnection();
        PreparedStatement stmt = c.prepareStatement(QUERY);        
        stmt.setInt(1, id);

        ResultSet rs = stmt.executeQuery();

        if (rs.next()) {
            int id_ulice = rs.getInt("id_ulice");
            String nazev = rs.getString("nazev");

            return Optional.of(new Ulice(id_ulice, nazev));
        } else {
            return Optional.empty();
        }
    }
}
