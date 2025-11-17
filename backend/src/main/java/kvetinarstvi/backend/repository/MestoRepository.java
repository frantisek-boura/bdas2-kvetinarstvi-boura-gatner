package kvetinarstvi.backend.repository;

import kvetinarstvi.backend.records.Mesto;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import javax.sql.DataSource;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Repository
public class MestoRepository implements IRepository<Mesto> {

    @Autowired
    private DataSource dataSource;

    @Override
    public Optional<Mesto> findById(Integer ID) throws SQLException {
        final String QUERY = "SELECT id_mesto, nazev FROM mesta WHERE id_mesto = ?";

        try (Connection c = dataSource.getConnection();
             PreparedStatement stmt = c.prepareStatement(QUERY)) {

            stmt.setInt(1, ID);
            try (ResultSet rs = stmt.executeQuery()) {

                if (rs.next()) {
                    int id_mesto = rs.getInt("id_mesto");
                    String nazev = rs.getString("nazev");

                    return Optional.of(new Mesto(id_mesto, nazev));
                }
            }
        }

        return Optional.empty();
    }

    @Override
    public List<Mesto> findAll() throws SQLException {
        List<Mesto> mesta = new ArrayList<>();
        final String QUERY = "SELECT id_mesto, nazev FROM mesta";

        try (Connection c = dataSource.getConnection();
             PreparedStatement stmt = c.prepareStatement(QUERY);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                int id_mesto = rs.getInt("id_mesto");
                String nazev = rs.getString("nazev");

                mesta.add(new Mesto(id_mesto, nazev));
            }
        }

        return mesta;
    }

    @Override
    public Status<Mesto> insert(Mesto mestoRequest) {
        final String QUERY = "{CALL PCK_MESTA.PROC_INSERT_MESTO(?, ?, ?, ?)}";

        try (Connection c = dataSource.getConnection();
             CallableStatement stmt = c.prepareCall(QUERY)) {

            stmt.setString(1, mestoRequest.nazev());
            stmt.registerOutParameter(2, Types.INTEGER);
            stmt.registerOutParameter(3, Types.INTEGER);
            stmt.registerOutParameter(4, Types.VARCHAR);

            stmt.execute();
            int id_mesto = stmt.getInt(2);
            int status_code = stmt.getInt(3);
            String status_message = stmt.getString(4);

            if (status_code == 1) {
                try {
                    Mesto mesto = findById(id_mesto).get();
                    return new Status<>(status_code, status_message, mesto);
                } catch (SQLException e) {
                    return new Status<>(-998, "Chyba při dohledání vloženého města: " + e.getMessage(), null);
                }
            } else {
                return new Status<>(status_code, status_message, null);
            }
        } catch (SQLException e) {
            return new Status<>(-999, "Kritická chyba databáze: " + e.getMessage(), null);
        }
    }

    @Override
    public Status<Mesto> update(Mesto mestoRequest) {
        final String QUERY = "{CALL PCK_MESTA.PROC_UPDATE_MESTO(?, ?, ?, ?, ?)}";

        try (Connection c = dataSource.getConnection();
             CallableStatement stmt = c.prepareCall(QUERY)) {

            stmt.setInt(1, mestoRequest.id_mesto());
            stmt.setString(2, mestoRequest.nazev());
            stmt.registerOutParameter(3, Types.INTEGER);
            stmt.registerOutParameter(4, Types.INTEGER);
            stmt.registerOutParameter(5, Types.VARCHAR);

            stmt.execute();
            int id_mesto = stmt.getInt(3);
            int status_code = stmt.getInt(4);
            String status_message = stmt.getString(5);

            if (status_code == 1) {
                try {
                    Mesto mesto = findById(id_mesto).get();
                    return new Status<>(status_code, status_message, mesto);
                } catch (SQLException e) {
                    return new Status<>(-998, "Chyba při dohledání aktualizovaného města: " + e.getMessage(), null);
                }
            } else {
                return new Status<>(status_code, status_message, null);
            }
        } catch (SQLException e) {
            return new Status<>(-999, "Kritická chyba databáze: " + e.getMessage(), null);
        }
    }

    @Override
    public Status<Mesto> delete(Integer id) {
        final String QUERY = "{CALL PCK_MESTA.PROC_DELETE_MESTO(?, ?, ?)}";

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