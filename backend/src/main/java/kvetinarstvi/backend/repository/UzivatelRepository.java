package kvetinarstvi.backend.repository;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import kvetinarstvi.backend.records.Uzivatel;

@Repository
public class UzivatelRepository implements IRepository<Uzivatel> {

    @Autowired
    private DataSource dataSource;

    @Override
    public Optional<Uzivatel> findById(Integer ID) throws SQLException {
        final String QUERY = "SELECT id_uzivatel, email, hash, salt, id_opravneni, id_obrazek, id_adresa FROM uzivatele WHERE id_uzivatel = ?";

        try (Connection c = dataSource.getConnection();
             PreparedStatement stmt = c.prepareStatement(QUERY)) {

            stmt.setInt(1, ID);
            try (ResultSet rs = stmt.executeQuery()) {

                if (rs.next()) {
                    int id_uzivatel = rs.getInt("id_uzivatel");
                    String email = rs.getString("email");
                    String hash = rs.getString("hash");
                    String salt = rs.getString("salt");
                    Integer id_opravneni = rs.getInt("id_opravneni");
                    Integer id_obrazek = rs.getInt("id_obrazek");
                    Integer id_adresa = rs.getInt("id_adresa");

                    return Optional.of(new Uzivatel(id_uzivatel, email, hash, salt, id_opravneni, id_obrazek, id_adresa));
                }
            }
        }

        return Optional.empty();
    }

    @Override
    public List<Uzivatel> findAll() throws SQLException {
        List<Uzivatel> uzivatele = new ArrayList<>();
        final String QUERY = "SELECT id_uzivatel, email, hash, salt, id_opravneni, id_obrazek, id_adresa FROM uzivatele";

        try (Connection c = dataSource.getConnection();
             PreparedStatement stmt = c.prepareStatement(QUERY);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                int id_uzivatel = rs.getInt("id_uzivatel");
                String email = rs.getString("email");
                String hash = rs.getString("hash");
                String salt = rs.getString("salt");
                Integer id_opravneni = rs.getInt("id_opravneni");
                Integer id_obrazek = rs.getInt("id_obrazek");
                Integer id_adresa = rs.getInt("id_adresa");

                uzivatele.add(new Uzivatel(id_uzivatel, email, hash, salt, id_opravneni, id_obrazek, id_adresa));
            }
        }

        return uzivatele;
    }

    @Override
    public Status<Uzivatel> insert(Uzivatel uzivatelRequest) {
        final String QUERY = "{CALL PCK_UZIVATELE.PROC_INSERT_UZIVATEL(?, ?, ?, ?, ?, ?, ?, ?, ?)}";

        try (Connection c = dataSource.getConnection();
             CallableStatement stmt = c.prepareCall(QUERY)) {

            stmt.setString(1, uzivatelRequest.email());
            stmt.setString(2, uzivatelRequest.hash());
            stmt.setString(3, uzivatelRequest.salt());
            stmt.setInt(4, uzivatelRequest.id_opravneni());
            stmt.setInt(5, uzivatelRequest.id_obrazek());
            stmt.setInt(6, uzivatelRequest.id_adresa());
            stmt.registerOutParameter(7, Types.INTEGER);
            stmt.registerOutParameter(8, Types.INTEGER);
            stmt.registerOutParameter(9, Types.VARCHAR);

            stmt.execute();
            int id_uzivatel = stmt.getInt(7);
            int status_code = stmt.getInt(8);
            String status_message = stmt.getString(9);

            if (status_code == 1) {
                try {
                    Uzivatel uzivatel = findById(id_uzivatel).get();
                    return new Status<>(status_code, status_message, uzivatel);
                } catch (SQLException e) {
                    return new Status<>(-998, "Chyba při dohledání vloženého uživatele: " + e.getMessage(), null);
                }
            } else {
                return new Status<>(status_code, status_message, null);
            }
        } catch (SQLException e) {
            return new Status<>(-999, "Kritická chyba databáze: " + e.getMessage(), null);
        }
    }

    @Override
    public Status<Uzivatel> update(Uzivatel uzivatelRequest) {
        final String QUERY = "{CALL PCK_UZIVATELE.PROC_UPDATE_UZIVATEL(?, ?, ?, ?, ?, ?, ?, ?, ?, ?)}";

        try (Connection c = dataSource.getConnection();
             CallableStatement stmt = c.prepareCall(QUERY)) {

            stmt.setInt(1, uzivatelRequest.id_uzivatel());
            stmt.setString(2, uzivatelRequest.email());
            stmt.setString(3, uzivatelRequest.hash());
            stmt.setString(4, uzivatelRequest.salt());
            stmt.setInt(5, uzivatelRequest.id_opravneni());
            stmt.setInt(6, uzivatelRequest.id_obrazek());
            stmt.setInt(7, uzivatelRequest.id_adresa());
            stmt.registerOutParameter(8, Types.INTEGER);
            stmt.registerOutParameter(9, Types.INTEGER);
            stmt.registerOutParameter(10, Types.VARCHAR);

            stmt.execute();
            int id_uzivatel = stmt.getInt(8);
            int status_code = stmt.getInt(9);
            String status_message = stmt.getString(10);

            if (status_code == 1) {
                try {
                    Uzivatel uzivatel = findById(id_uzivatel).get();
                    return new Status<>(status_code, status_message, uzivatel);
                } catch (SQLException e) {
                    return new Status<>(-998, "Chyba při dohledání aktualizovaného uživatele: " + e.getMessage(), null);
                }
            } else {
                return new Status<>(status_code, status_message, null);
            }
        } catch (SQLException e) {
            return new Status<>(-999, "Kritická chyba databáze: " + e.getMessage(), null);
        }
    }

    @Override
    public Status<Uzivatel> delete(Integer id) {
        final String QUERY = "{CALL PCK_UZIVATELE.PROC_DELETE_UZIVATEL(?, ?, ?)}";

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