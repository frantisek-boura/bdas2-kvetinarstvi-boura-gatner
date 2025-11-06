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

import kvetinarstvi.backend.records.Opravneni;

@Service
public class OpravneniService {
    
    @Autowired
    private DataSource dataSource;

    public List<Opravneni> findAllOpravneni() throws SQLException {
        final String QUERY = "SELECT id_opravneni, nazev, uroven FROM opravneni";
        List<Opravneni> opravneni = new ArrayList<>();

        Connection c = dataSource.getConnection();
        PreparedStatement stmt = c.prepareStatement(QUERY);        
        ResultSet rs = stmt.executeQuery();

        while (rs.next()) {
            int id_opravneni = rs.getInt("id_opravneni");
            String nazev = rs.getString("nazev");
            int uroven = rs.getInt("uroven");

            opravneni.add(new Opravneni(id_opravneni, nazev, uroven));
        } 

        return opravneni;
    }

    public Optional<Opravneni> findOpravneniById(Integer id) throws SQLException {
        final String QUERY = "SELECT id_opravneni, nazev, uroven FROM opravneni WHERE id_opravneni = ?";

        Connection c = dataSource.getConnection();
        PreparedStatement stmt = c.prepareStatement(QUERY);
        stmt.setInt(1, id);

        ResultSet rs = stmt.executeQuery();

        if (rs.next()) {
            int id_opravneni = rs.getInt("id_opravneni");
            String nazev = rs.getString("nazev");
            int uroven = rs.getInt("uroven");

            return Optional.of(new Opravneni(id_opravneni, nazev, uroven));
        } else {
            return Optional.empty();
        }
    }
    
}
