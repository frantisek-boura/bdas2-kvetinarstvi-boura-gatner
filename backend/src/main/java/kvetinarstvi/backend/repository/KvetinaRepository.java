package kvetinarstvi.backend.repository;

import kvetinarstvi.backend.records.Kvetina;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import javax.sql.DataSource;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Repository
public class KvetinaRepository implements IRepository<Kvetina> {

    @Autowired
    private DataSource dataSource;

    @Override
    public Optional<Kvetina> findById(Integer ID) throws SQLException {
        final String QUERY = "SELECT id_kvetina, nazev, cena, id_kategorie, id_obrazek FROM kvetiny WHERE id_kvetina = ?";

        try (Connection c = dataSource.getConnection();
             PreparedStatement stmt = c.prepareStatement(QUERY)) {

            stmt.setInt(1, ID);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    int id_kvetina = rs.getInt("id_kvetina");
                    String nazev = rs.getString("nazev");
                    Double cena = rs.getDouble("cena");
                    Integer id_kategorie = rs.getInt("id_kategorie");
                    Integer id_obrazek = rs.getInt("id_obrazek");

                    return Optional.of(new Kvetina(id_kvetina, nazev, cena, id_kategorie, id_obrazek));
                }
            }
        }

        return Optional.empty();
    }

    @Override
    public List<Kvetina> findAll() throws SQLException {
        List<Kvetina> kvetiny = new ArrayList<>();
        final String QUERY = "SELECT id_kvetina, nazev, cena, id_kategorie, id_obrazek FROM kvetiny";

        try (Connection c = dataSource.getConnection();
             PreparedStatement stmt = c.prepareStatement(QUERY);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                int id_kvetina = rs.getInt("id_kvetina");
                String nazev = rs.getString("nazev");
                Double cena = rs.getDouble("cena");
                Integer id_kategorie = rs.getInt("id_kategorie");
                Integer id_obrazek = rs.getInt("id_obrazek");

                kvetiny.add(new Kvetina(id_kvetina, nazev, cena, id_kategorie, id_obrazek));
            }
        }

        return kvetiny;
    }

    @Override
    public Status<Kvetina> insert(Kvetina kvetinaRequest) {
        final String QUERY = "{CALL PCK_KVETINY.PROC_INSERT_KVETINA(?, ?, ?, ?, ?, ?, ?)}";

        try (Connection c = dataSource.getConnection();
             CallableStatement stmt = c.prepareCall(QUERY)) {

            stmt.setString(1, kvetinaRequest.nazev());
            stmt.setDouble(2, kvetinaRequest.cena());
            stmt.setInt(3, kvetinaRequest.id_kategorie());
            stmt.setInt(4, kvetinaRequest.id_obrazek());

            stmt.registerOutParameter(5, Types.INTEGER); // o_id_kvetina
            stmt.registerOutParameter(6, Types.INTEGER); // o_status_code
            stmt.registerOutParameter(7, Types.VARCHAR); // o_status_message

            stmt.execute();

            int id_kvetina = stmt.getInt(5);
            int status_code = stmt.getInt(6);
            String status_message = stmt.getString(7);

            if (status_code == 1) {
                try {
                    Kvetina kvetina = findById(id_kvetina).get();
                    return new Status<>(status_code, status_message, kvetina);
                } catch (SQLException e) {
                    return new Status<>(-998, "Chyba při dohledání vložené květiny: " + e.getMessage(), null);
                }
            } else {
                return new Status<>(status_code, status_message, null);
            }
        } catch (SQLException e) {
            return new Status<>(-999, "Kritická chyba databáze: " + e.getMessage(), null);
        }
    }

    @Override
    public Status<Kvetina> update(Kvetina kvetinaRequest) {
        final String QUERY = "{CALL PCK_KVETINY.PROC_UPDATE_KVETINA(?, ?, ?, ?, ?, ?, ?, ?)}";

        try (Connection c = dataSource.getConnection();
             CallableStatement stmt = c.prepareCall(QUERY)) {

            stmt.setInt(1, kvetinaRequest.id_kvetina());
            stmt.setString(2, kvetinaRequest.nazev());
            stmt.setDouble(3, kvetinaRequest.cena());
            stmt.setInt(4, kvetinaRequest.id_kategorie());
            stmt.setInt(5, kvetinaRequest.id_obrazek());

            stmt.registerOutParameter(6, Types.INTEGER); // o_id_kvetina
            stmt.registerOutParameter(7, Types.INTEGER); // o_status_code
            stmt.registerOutParameter(8, Types.VARCHAR); // o_status_message

            stmt.execute();

            int id_kvetina = stmt.getInt(6);
            int status_code = stmt.getInt(7);
            String status_message = stmt.getString(8);

            if (status_code == 1) {
                try {
                    Kvetina kvetina = findById(id_kvetina).get();
                    return new Status<>(status_code, status_message, kvetina);
                } catch (SQLException e) {
                    return new Status<>(-998, "Chyba při dohledání aktualizované květiny: " + e.getMessage(), null);
                }
            } else {
                return new Status<>(status_code, status_message, null);
            }
        } catch (SQLException e) {
            return new Status<>(-999, "Kritická chyba databáze: " + e.getMessage(), null);
        }
    }

    @Override
    public Status<Kvetina> delete(Integer id) {
        final String QUERY = "{CALL PCK_KVETINY.PROC_DELETE_KVETINA(?, ?, ?)}";

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