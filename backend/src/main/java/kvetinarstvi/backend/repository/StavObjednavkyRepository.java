package kvetinarstvi.backend.repository;

import kvetinarstvi.backend.records.StavObjednavky;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import javax.sql.DataSource;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Repository
public class StavObjednavkyRepository implements IRepository<StavObjednavky> {

    @Autowired
    private DataSource dataSource;

    @Override
    public Optional<StavObjednavky> findById(Integer ID) throws SQLException {
        final String QUERY = "SELECT id_stav_objednavky, nazev FROM stavyobjednavek WHERE id_stav_objednavky = ?";

        try (Connection c = dataSource.getConnection();
             PreparedStatement stmt = c.prepareStatement(QUERY)) {

            stmt.setInt(1, ID);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    int id_stav_objednavky = rs.getInt("id_stav_objednavky");
                    String nazev = rs.getString("nazev");

                    return Optional.of(new StavObjednavky(id_stav_objednavky, nazev));
                }
            }
        }

        return Optional.empty();
    }

    @Override
    public List<StavObjednavky> findAll() throws SQLException {
        List<StavObjednavky> stavyObjednavek = new ArrayList<>();
        final String QUERY = "SELECT id_stav_objednavky, nazev FROM stavyobjednavek";

        try (Connection c = dataSource.getConnection();
             PreparedStatement stmt = c.prepareStatement(QUERY);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                int id_stav_objednavky = rs.getInt("id_stav_objednavky");
                String nazev = rs.getString("nazev");

                stavyObjednavek.add(new StavObjednavky(id_stav_objednavky, nazev));
            }
        }

        return stavyObjednavek;
    }

    @Override
    public Status<StavObjednavky> insert(StavObjednavky stavObjednavkyRequest) {
        final String QUERY = "{CALL PCK_STAVYOBJEDNAVEK.PROC_INSERT_STAV(?, ?, ?, ?)}";

        try (Connection c = dataSource.getConnection();
             CallableStatement stmt = c.prepareCall(QUERY)) {

            stmt.setString(1, stavObjednavkyRequest.nazev());
            stmt.registerOutParameter(2, Types.INTEGER);
            stmt.registerOutParameter(3, Types.INTEGER);
            stmt.registerOutParameter(4, Types.VARCHAR);

            stmt.execute();
            int id_stav_objednavky = stmt.getInt(2);
            int status_code = stmt.getInt(3);
            String status_message = stmt.getString(4);

            if (status_code == 1) {
                try {
                    StavObjednavky stav = findById(id_stav_objednavky).get();
                    return new Status<>(status_code, status_message, stav);
                } catch (SQLException e) {
                    return new Status<>(-998, "Chyba při dohledání vloženého stavu objednávky: " + e.getMessage(), null);
                }
            } else {
                return new Status<>(status_code, status_message, null);
            }
        } catch (SQLException e) {
            return new Status<>(-999, "Kritická chyba databáze: " + e.getMessage(), null);
        }
    }

    @Override
    public Status<StavObjednavky> update(StavObjednavky stavObjednavkyRequest) {
        final String QUERY = "{CALL PCK_STAVYOBJEDNAVEK.PROC_UPDATE_STAV(?, ?, ?, ?, ?)}";

        try (Connection c = dataSource.getConnection();
             CallableStatement stmt = c.prepareCall(QUERY)) {

            stmt.setInt(1, stavObjednavkyRequest.id_stav_objednavky());
            stmt.setString(2, stavObjednavkyRequest.nazev());
            stmt.registerOutParameter(3, Types.INTEGER);
            stmt.registerOutParameter(4, Types.INTEGER);
            stmt.registerOutParameter(5, Types.VARCHAR);

            stmt.execute();
            int id_stav_objednavky = stmt.getInt(3);
            int status_code = stmt.getInt(4);
            String status_message = stmt.getString(5);

            if (status_code == 1) {
                try {
                    StavObjednavky stav = findById(id_stav_objednavky).get();
                    return new Status<>(status_code, status_message, stav);
                } catch (SQLException e) {
                    return new Status<>(-998, "Chyba při dohledání aktualizovaného stavu objednávky: " + e.getMessage(), null);
                }
            } else {
                return new Status<>(status_code, status_message, null);
            }
        } catch (SQLException e) {
            return new Status<>(-999, "Kritická chyba databáze: " + e.getMessage(), null);
        }
    }

    @Override
    public Status<StavObjednavky> delete(Integer id) {
        final String QUERY = "{CALL PCK_STAVYOBJEDNAVEK.PROC_DELETE_STAV(?, ?, ?)}";

        try (Connection c = dataSource.getConnection();
             CallableStatement stmt = c.prepareCall(QUERY)) {

            stmt.setInt(1, id);
            stmt.registerOutParameter(2, Types.INTEGER);
            stmt.registerOutParameter(3, Types.VARCHAR);

            stmt.execute();
            int status_code = stmt.getInt(2);
            String status_message = stmt.getString(3);

            return new Status<>(status_code, status_message, null);
        } catch (SQLException e) {
            return new Status<>(-999, "Kritická chyba databáze: " + e.getMessage(), null);
        }
    }
}