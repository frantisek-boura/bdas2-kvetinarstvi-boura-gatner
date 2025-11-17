package kvetinarstvi.backend.repository;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import kvetinarstvi.backend.records.Ulice;

@Repository
public class UliceRepository implements IRepository<Ulice> {

    @Autowired
    private DataSource dataSource;

    @Override
    public List<Ulice> findAll() throws SQLException {
        final String QUERY = "SELECT id_ulice, nazev FROM ulice";
        List<Ulice> ulice = new ArrayList<>();

        try (Connection c = dataSource.getConnection();
             PreparedStatement stmt = c.prepareStatement(QUERY);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                int id_ulice = rs.getInt("id_ulice");
                String nazev = rs.getString("nazev");

                ulice.add(new Ulice(id_ulice, nazev));
            }
        }

        return ulice;
    }

    @Override
    public Optional<Ulice> findById(Integer id) throws SQLException {
        final String QUERY = "SELECT id_ulice, nazev FROM ulice WHERE id_ulice = ?";

        try (Connection c = dataSource.getConnection();
             PreparedStatement stmt = c.prepareStatement(QUERY)) {

            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {

                if (rs.next()) {
                    int id_ulice = rs.getInt("id_ulice");
                    String nazev = rs.getString("nazev");

                    return Optional.of(new Ulice(id_ulice, nazev));
                }
            }
        }

        return Optional.empty();
    }

    @Override
    public Status<Ulice> insert(Ulice uliceRequest) {
        final String QUERY = "{CALL PCK_ULICE.PROC_INSERT_ULICE(?, ?, ?, ?)}";

        try (Connection c = dataSource.getConnection();
             CallableStatement stmt = c.prepareCall(QUERY)) {

            stmt.setString(1, uliceRequest.nazev());
            stmt.registerOutParameter(2, Types.INTEGER);
            stmt.registerOutParameter(3, Types.INTEGER);
            stmt.registerOutParameter(4, Types.VARCHAR);

            stmt.execute();
            int id_ulice = stmt.getInt(2);
            int status_code = stmt.getInt(3);
            String status_message = stmt.getString(4);

            if (status_code == 1) {
                try {
                    Ulice ulice = findById(id_ulice).get();
                    return new Status<>(status_code, status_message, ulice);
                } catch (SQLException e) {
                    return new Status<>(-998, "Chyba při dohledání vložené ulice: " + e.getMessage(), null);
                }
            } else {
                return new Status<>(status_code, status_message, null);
            }
        } catch (SQLException e) {
            return new Status<>(-999, "Kritická chyba databáze: " + e.getMessage(), null);
        }
    }

    @Override
    public Status<Ulice> update(Ulice uliceRequest) {
        final String QUERY = "{CALL PCK_ULICE.PROC_UPDATE_ULICE(?, ?, ?, ?, ?)}";

        try (Connection c = dataSource.getConnection();
             CallableStatement stmt = c.prepareCall(QUERY)) {

            stmt.setInt(1, uliceRequest.id_ulice());
            stmt.setString(2, uliceRequest.nazev());
            stmt.registerOutParameter(3, Types.INTEGER);
            stmt.registerOutParameter(4, Types.INTEGER);
            stmt.registerOutParameter(5, Types.VARCHAR);

            stmt.execute();
            int id_ulice = stmt.getInt(3);
            int status_code = stmt.getInt(4);
            String status_message = stmt.getString(5);

            if (status_code == 1) {
                try {
                    Ulice ulice = findById(id_ulice).get();
                    return new Status<>(status_code, status_message, ulice);
                } catch (SQLException e) {
                    return new Status<>(-998, "Chyba při dohledání aktualizované ulice: " + e.getMessage(), null);
                }
            } else {
                return new Status<>(status_code, status_message, null);
            }
        } catch (SQLException e) {
            return new Status<>(-999, "Kritická chyba databáze: " + e.getMessage(), null);
        }
    }

    @Override
    public Status<Ulice> delete(Integer id) {
        final String QUERY = "{CALL PCK_ULICE.PROC_DELETE_ULICE(?, ?, ?)}";

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