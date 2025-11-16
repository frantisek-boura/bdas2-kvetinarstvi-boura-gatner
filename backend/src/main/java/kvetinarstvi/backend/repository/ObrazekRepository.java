package kvetinarstvi.backend.repository;

import java.sql.*;
import java.util.ArrayList;
import java.util.Base64;
import java.util.List;
import java.util.Optional;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import kvetinarstvi.backend.records.Obrazek;

@Repository
public class ObrazekRepository implements IRepository<Obrazek> {

    @Autowired
    private DataSource dataSource;

    @Override
    public Optional<Obrazek> findById(Integer ID) throws SQLException {
        final String QUERY = "SELECT id_obrazek, nazev_souboru, data FROM obrazky WHERE id_obrazek = ?";

        Connection c = dataSource.getConnection();
        PreparedStatement stmt = c.prepareStatement(QUERY);
        stmt.setInt(1, ID);
        ResultSet rs = stmt.executeQuery();

        if (rs.next()) {
            int id_obrazek = rs.getInt("id_obrazek");
            String nazev_souboru = rs.getString("nazev_souboru");
            byte[] dataBytes = rs.getBytes("data");

            String base64 = (dataBytes != null) ? Base64.getEncoder().encodeToString(dataBytes) : "";

            return Optional.of(new Obrazek(id_obrazek, nazev_souboru, base64));
        }

        return Optional.empty();
    }

    @Override
    public List<Obrazek> findAll() throws SQLException {
        List<Obrazek> obrazky = new ArrayList<>();
        final String QUERY = "SELECT id_obrazek, nazev_souboru, data FROM obrazky";

        Connection c = dataSource.getConnection();
        PreparedStatement stmt = c.prepareStatement(QUERY);
        ResultSet rs = stmt.executeQuery();

        while (rs.next()) {
            int id_obrazek = rs.getInt("id_obrazek");
            String nazev_souboru = rs.getString("nazev_souboru");
            byte[] dataBytes = rs.getBytes("data");

            String base64 = (dataBytes != null) ? Base64.getEncoder().encodeToString(dataBytes) : "";

            obrazky.add(new Obrazek(id_obrazek, nazev_souboru, base64));
        }

        return obrazky;
    }

    @Override
    public Status<Obrazek> insert(Obrazek obrazekRequest) {
        final String QUERY = "{CALL PCK_OBRAZKY.PROC_INSERT_OBRAZEK(?, ?, ?, ?, ?)}";

        try {
            Connection c = dataSource.getConnection();
            CallableStatement stmt = c.prepareCall(QUERY);

            stmt.setString(1, obrazekRequest.nazev_souboru());
            stmt.setBytes(2, Base64.getDecoder().decode(obrazekRequest.base64()));

            stmt.registerOutParameter(3, Types.INTEGER);
            stmt.registerOutParameter(4, Types.INTEGER);
            stmt.registerOutParameter(5, Types.VARCHAR);

            stmt.execute();

            int id_obrazek = stmt.getInt(3);
            int status_code = stmt.getInt(4);
            String status_message = stmt.getString(5);

            if (status_code == 1) {
                Obrazek obrazek = findById(id_obrazek).get();
                return new Status<>(status_code, status_message, obrazek);
            } else {
                return new Status<>(status_code, status_message, null);
            }
        } catch (SQLException e) {
            return new Status<>(-999, "Kritická chyba databáze: " + e.getMessage(), null);
        } catch (IllegalArgumentException e) {
            return new Status<>(-998, "Chyba dekódování Base64: " + e.getMessage(), null);
        }
    }

    @Override
    public Status<Obrazek> update(Obrazek obrazekRequest) {
        final String QUERY = "{CALL PCK_OBRAZKY.PROC_UPDATE_OBRAZEK(?, ?, ?, ?, ?, ?)}";

        try {
            Connection c = dataSource.getConnection();
            CallableStatement stmt = c.prepareCall(QUERY);

            stmt.setInt(1, obrazekRequest.id_obrazek());
            stmt.setString(2, obrazekRequest.nazev_souboru());
            stmt.setBytes(3, Base64.getDecoder().decode(obrazekRequest.base64()));

            stmt.registerOutParameter(4, Types.INTEGER);
            stmt.registerOutParameter(5, Types.INTEGER);
            stmt.registerOutParameter(6, Types.VARCHAR);

            stmt.execute();

            int id_obrazek = stmt.getInt(4);
            int status_code = stmt.getInt(5);
            String status_message = stmt.getString(6);

            if (status_code == 1) {
                Obrazek obrazek = findById(id_obrazek).get();
                return new Status<>(status_code, status_message, obrazek);
            } else {
                return new Status<>(status_code, status_message, null);
            }
        } catch (SQLException e) {
            return new Status<>(-999, "Kritická chyba databáze: " + e.getMessage(), null);
        } catch (IllegalArgumentException e) {
            return new Status<>(-998, "Chyba dekódování Base64: " + e.getMessage(), null);
        }
    }

    @Override
    public Status<Obrazek> delete(Integer id) {
        final String QUERY = "{CALL PCK_OBRAZKY.PROC_DELETE_OBRAZEK(?, ?, ?)}";

        try {
            Connection c = dataSource.getConnection();
            CallableStatement stmt = c.prepareCall(QUERY);
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