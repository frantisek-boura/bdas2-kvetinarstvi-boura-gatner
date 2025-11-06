package kvetinarstvi.backend.service;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import javax.sql.DataSource;

import kvetinarstvi.backend.records.Obrazek;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kvetinarstvi.backend.records.Obrazek;

@Service
public class ObrazekService {
    
    @Autowired
    private DataSource dataSource;

    public List<Obrazek> findAllObrazky() throws SQLException {
        final String QUERY = "SELECT id_obrazek, nazev_souboru, data FROM obrazky";
        List<Obrazek> obrazky = new ArrayList<>();

        Connection c = dataSource.getConnection();
        PreparedStatement stmt = c.prepareStatement(QUERY);
        ResultSet rs = stmt.executeQuery();

        while (rs.next()) {
            int id_obrazek = rs.getInt("id_obrazek");
            String nazev_souboru = rs.getString("nazev_souboru");
            byte[] data = rs.getBytes("data");

            obrazky.add(new Obrazek(id_obrazek, nazev_souboru, data));
        }

        return obrazky;
    }

    public Optional<Obrazek> findObrazekById(Integer id) throws SQLException {
        final String QUERY = "SELECT id_obrazek, nazev_souboru, data FROM obrazky WHERE id_obrazek = ?";

        Connection c = dataSource.getConnection();
        PreparedStatement stmt = c.prepareStatement(QUERY);
        stmt.setInt(1, id);

        ResultSet rs = stmt.executeQuery();

        if (rs.next()) {
            int id_obrazek = rs.getInt("id_obrazek");
            String nazev_souboru = rs.getString("nazev_souboru");
            byte[] data = rs.getBytes("data");

            return Optional.of(new Obrazek(id_obrazek, nazev_souboru, data));
        } else {
            return Optional.empty();
        }
    }
}
