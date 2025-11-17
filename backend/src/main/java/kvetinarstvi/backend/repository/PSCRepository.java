package kvetinarstvi.backend.repository;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import kvetinarstvi.backend.records.PSC;

@Repository
public class PSCRepository implements IRepository<PSC> {

    @Autowired
    private DataSource dataSource;

    @Override
    public Optional<PSC> findById(Integer ID) throws SQLException {
        final String QUERY = "SELECT id_psc, psc FROM psc WHERE id_psc = ?";

        try (Connection c = dataSource.getConnection();
             PreparedStatement stmt = c.prepareStatement(QUERY)) {

            stmt.setInt(1, ID);
            try (ResultSet rs = stmt.executeQuery()) {

                if (rs.next()) {
                    int id_psc = rs.getInt("id_psc");
                    String psc = rs.getString("psc");

                    return Optional.of(new PSC(id_psc, psc));
                }
            }
        }

        return Optional.empty();
    }

    @Override
    public List<PSC> findAll() throws SQLException {
        List<PSC> pscs = new ArrayList<>();
        final String QUERY = "SELECT id_psc, psc FROM psc";

        try (Connection c = dataSource.getConnection();
             PreparedStatement stmt = c.prepareStatement(QUERY);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                int id_psc = rs.getInt("id_psc");
                String psc = rs.getString("psc");

                pscs.add(new PSC(id_psc, psc));
            }
        }

        return pscs;
    }

    @Override
    public Status<PSC> insert(PSC pscRequest) {
        final String QUERY = "{CALL PCK_PSC.PROC_INSERT_PSC(?, ?, ?, ?)}";

        try (Connection c = dataSource.getConnection();
             CallableStatement stmt = c.prepareCall(QUERY)) {

            stmt.setString(1, pscRequest.psc());
            stmt.registerOutParameter(2, Types.INTEGER);
            stmt.registerOutParameter(3, Types.INTEGER);
            stmt.registerOutParameter(4, Types.VARCHAR);

            stmt.execute();
            int id_psc = stmt.getInt(2);
            int status_code = stmt.getInt(3);
            String status_message = stmt.getString(4);

            if (status_code == 1) {
                try {
                    PSC psc = findById(id_psc).get();
                    return new Status<>(status_code, status_message, psc);
                } catch (SQLException e) {
                    return new Status<>(-998, "Chyba při dohledání vloženého PSC: " + e.getMessage(), null);
                }
            } else {
                return new Status<>(status_code, status_message, null);
            }
        } catch (SQLException e) {
            return new Status<>(-999, "Kritická chyba databáze: " + e.getMessage(), null);
        }
    }

    @Override
    public Status<PSC> update(PSC pscRequest) {
        final String QUERY = "{CALL PCK_PSC.PROC_UPDATE_PSC(?, ?, ?, ?, ?)}";

        try (Connection c = dataSource.getConnection();
             CallableStatement stmt = c.prepareCall(QUERY)) {

            stmt.setInt(1, pscRequest.id_psc());
            stmt.setString(2, pscRequest.psc());
            stmt.registerOutParameter(3, Types.INTEGER);
            stmt.registerOutParameter(4, Types.INTEGER);
            stmt.registerOutParameter(5, Types.VARCHAR);

            stmt.execute();
            int id_psc = stmt.getInt(3);
            int status_code = stmt.getInt(4);
            String status_message = stmt.getString(5);

            if (status_code == 1) {
                try {
                    PSC psc = findById(id_psc).get();
                    return new Status<>(status_code, status_message, psc);
                } catch (SQLException e) {
                    return new Status<>(-998, "Chyba při dohledání aktualizovaného PSC: " + e.getMessage(), null);
                }
            } else {
                return new Status<>(status_code, status_message, null);
            }
        } catch (SQLException e) {
            return new Status<>(-999, "Kritická chyba databáze: " + e.getMessage(), null);
        }
    }

    @Override
    public Status<PSC> delete(Integer id) {
        final String QUERY = "{CALL PCK_PSC.PROC_DELETE_PSC(?, ?, ?)}";

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