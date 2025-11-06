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

import kvetinarstvi.backend.records.Mesto;

@Service
public class MestoService {
    
    @Autowired
    private DataSource dataSource;

    public List<Mesto> findAllMesta() throws SQLException {
        final String QUERY = "SELECT id_mesto, nazev FROM mesta";
        List<Mesto> mesta = new ArrayList<>();

        Connection c = dataSource.getConnection();
        PreparedStatement stmt = c.prepareStatement(QUERY);        
        ResultSet rs = stmt.executeQuery();

        while (rs.next()) {
            int id_mesto = rs.getInt("id_mesto");
            String nazev = rs.getString("nazev");

            mesta.add(new Mesto(id_mesto, nazev));
        } 

        return mesta;
    }

    public Optional<Mesto> findMestoById(Integer id) throws SQLException {
        final String QUERY = "SELECT id_mesto, nazev FROM mesta WHERE id_mesto = ?";

        Connection c = dataSource.getConnection();
        PreparedStatement stmt = c.prepareStatement(QUERY);        
        stmt.setInt(1, id);

        ResultSet rs = stmt.executeQuery();

        if (rs.next()) {
            int id_mesto = rs.getInt("id_mesto");
            String nazev = rs.getString("nazev");

            return Optional.of(new Mesto(id_mesto, nazev));
        } else {
            return Optional.empty();
        }
    }

}
