package kvetinarstvi.backend.repository;

import kvetinarstvi.backend.records.Kategorie;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import javax.sql.DataSource;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Repository
public class KategorieRepository implements IRepository<Kategorie> {

    @Autowired
    private DataSource dataSource;

    @Override
    public Optional<Kategorie> findById(Integer ID) throws SQLException {
        final String QUERY = "SELECT id_kategorie, nazev, id_nadrazene_kategorie FROM kategorie WHERE id_kategorie = ?";

        try (Connection c = dataSource.getConnection();
             PreparedStatement stmt = c.prepareStatement(QUERY)) {

            stmt.setInt(1, ID);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    int id_kategorie = rs.getInt("id_kategorie");
                    String nazev = rs.getString("nazev");
                    int id_nadrazene_kategorie = rs.getInt("id_nadrazene_kategorie");
                    Integer id_nadrazene = rs.wasNull() ? null : id_nadrazene_kategorie;

                    return Optional.of(new Kategorie(id_kategorie, nazev, id_nadrazene));
                }
            }
        }

        return Optional.empty();
    }

    @Override
    public List<Kategorie> findAll() throws SQLException {
        List<Kategorie> kategorieList = new ArrayList<>();
        final String QUERY = "SELECT id_kategorie, nazev, id_nadrazene_kategorie FROM kategorie";

        try (Connection c = dataSource.getConnection();
             PreparedStatement stmt = c.prepareStatement(QUERY);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                int id_kategorie = rs.getInt("id_kategorie");
                String nazev = rs.getString("nazev");
                int id_nadrazene_kategorie = rs.getInt("id_nadrazene_kategorie");
                Integer id_nadrazene = rs.wasNull() ? null : id_nadrazene_kategorie;

                kategorieList.add(new Kategorie(id_kategorie, nazev, id_nadrazene));
            }
        }

        return kategorieList;
    }

    @Override
    public Status<Kategorie> insert(Kategorie kategorieRequest) {
        final String QUERY = "{CALL PCK_KATEGORIE.PROC_INSERT_KATEGORIE(?, ?, ?, ?, ?)}";

        try (Connection c = dataSource.getConnection();
             CallableStatement stmt = c.prepareCall(QUERY)) {

            stmt.setString(1, kategorieRequest.nazev());

            if (kategorieRequest.id_nadrazene_kategorie() == null) {
                stmt.setNull(2, Types.INTEGER);
            } else {
                stmt.setInt(2, kategorieRequest.id_nadrazene_kategorie());
            }

            stmt.registerOutParameter(3, Types.INTEGER);
            stmt.registerOutParameter(4, Types.INTEGER);
            stmt.registerOutParameter(5, Types.VARCHAR);

            stmt.execute();

            int id_kategorie = stmt.getInt(3);
            int status_code = stmt.getInt(4);
            String status_message = stmt.getString(5);

            if (status_code == 1) {
                try {
                    Kategorie kategorie = findById(id_kategorie).get();
                    return new Status<>(status_code, status_message, kategorie);
                } catch (SQLException e) {
                    return new Status<>(-998, "Chyba při dohledání vložené kategorie: " + e.getMessage(), null);
                }
            } else {
                return new Status<>(status_code, status_message, null);
            }
        } catch (SQLException e) {
            return new Status<>(-999, "Kritická chyba databáze: " + e.getMessage(), null);
        }
    }

    @Override
    public Status<Kategorie> update(Kategorie kategorieRequest) {
        final String QUERY = "{CALL PCK_KATEGORIE.PROC_UPDATE_KATEGORIE(?, ?, ?, ?, ?, ?)}";

        try (Connection c = dataSource.getConnection();
             CallableStatement stmt = c.prepareCall(QUERY)) {

            stmt.setInt(1, kategorieRequest.id_kategorie());
            stmt.setString(2, kategorieRequest.nazev());

            if (kategorieRequest.id_nadrazene_kategorie() == null) {
                stmt.setNull(3, Types.INTEGER);
            } else {
                stmt.setInt(3, kategorieRequest.id_nadrazene_kategorie());
            }

            stmt.registerOutParameter(4, Types.INTEGER);
            stmt.registerOutParameter(5, Types.INTEGER);
            stmt.registerOutParameter(6, Types.VARCHAR);

            stmt.execute();

            int id_kategorie = stmt.getInt(4);
            int status_code = stmt.getInt(5);
            String status_message = stmt.getString(6);

            if (status_code == 1) {
                try {
                    Kategorie kategorie = findById(id_kategorie).get();
                    return new Status<>(status_code, status_message, kategorie);
                } catch (SQLException e) {
                    return new Status<>(-998, "Chyba při dohledání aktualizované kategorie: " + e.getMessage(), null);
                }
            } else {
                return new Status<>(status_code, status_message, null);
            }
        } catch (SQLException e) {
            return new Status<>(-999, "Kritická chyba databáze: " + e.getMessage(), null);
        }
    }

    @Override
    public Status<Kategorie> delete(Integer id) {
        final String QUERY = "{CALL PCK_KATEGORIE.PROC_DELETE_KATEGORIE(?, ?, ?)}";

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