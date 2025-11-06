package kvetinarstvi.backend.service;

import kvetinarstvi.backend.records.StavObjednavky;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Service
public class StavObjednavkyService {

    @Autowired
    private DataSource dataSource;

    public List<StavObjednavky> findAllStavyObjednavek() throws SQLException {
        final String QUERY = "SELECT id_stav_objednavky, nazev FROM stavyobjednavek";
        List<StavObjednavky> stavyObjednavek = new ArrayList<>();

        Connection c = dataSource.getConnection();
        PreparedStatement stmt = c.prepareStatement(QUERY);
        ResultSet rs = stmt.executeQuery();

        while (rs.next()) {
            int id_stav_objednavky = rs.getInt("id_stav_objednavky");
            String nazev = rs.getString("nazev");

            stavyObjednavek.add(new StavObjednavky(id_stav_objednavky, nazev));
        }

        return stavyObjednavek;
    }

    public Optional<StavObjednavky> findStavObjednavkyById(Integer id) throws SQLException {
        final String QUERY = "SELECT id_stav_objednavky, nazev FROM stavyobjednavek WHERE id_stav_objednavky = ?";

        Connection c = dataSource.getConnection();
        PreparedStatement stmt = c.prepareStatement(QUERY);
        stmt.setInt(1, id);

        ResultSet rs = stmt.executeQuery();

        if (rs.next()) {
            int id_stav_objednavky = rs.getInt("id_stav_objednavky");
            String nazev = rs.getString("nazev");

            return Optional.of(new StavObjednavky(id_stav_objednavky, nazev));
        } else {
            return Optional.empty();
        }
    }

}
