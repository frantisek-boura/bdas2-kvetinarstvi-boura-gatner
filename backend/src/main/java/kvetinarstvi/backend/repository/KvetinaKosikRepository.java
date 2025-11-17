package kvetinarstvi.backend.repository;

import kvetinarstvi.backend.records.KvetinaKosik;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import javax.sql.DataSource;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Repository
public class KvetinaKosikRepository implements IRepository<KvetinaKosik> {

    @Autowired
    private DataSource dataSource;

    @Override
    public Optional<KvetinaKosik> findById(Integer ID) throws SQLException {
        throw new UnsupportedOperationException("Tato entita nemá jednoduchý primární klíč. Použijte metodu findByIds.");
    }

    public Optional<KvetinaKosik> findByIds(Integer id_kvetina, Integer id_kosik) throws SQLException {
        final String QUERY = "SELECT id_kvetina, id_kosik, pocet FROM kvetinykosiky WHERE id_kvetina = ? AND id_kosik = ?";

        try (Connection c = dataSource.getConnection();
             PreparedStatement stmt = c.prepareStatement(QUERY)
        ) {
            stmt.setInt(1, id_kvetina);
            stmt.setInt(2, id_kosik);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    int pocet = rs.getInt("pocet");
                    return Optional.of(new KvetinaKosik(id_kvetina, id_kosik, pocet));
                }
            }
        }

        return Optional.empty();
    }

    @Override
    public List<KvetinaKosik> findAll() throws SQLException {
        List<KvetinaKosik> kvetinyKosiky = new ArrayList<>();
        final String QUERY = "SELECT id_kvetina, id_kosik, pocet FROM kvetinykosiky";

        try (Connection c = dataSource.getConnection();
             PreparedStatement stmt = c.prepareStatement(QUERY);
             ResultSet rs = stmt.executeQuery()
        ) {
            while (rs.next()) {
                Integer id_kvetina = rs.getInt("id_kvetina");
                Integer id_kosik = rs.getInt("id_kosik");
                int pocet = rs.getInt("pocet");

                kvetinyKosiky.add(new KvetinaKosik(id_kvetina, id_kosik, pocet));
            }
        }

        return kvetinyKosiky;
    }

    public List<KvetinaKosik> findAllByKosikId(Integer id_kosik) throws SQLException {
        List<KvetinaKosik> kvetinyKosiky = new ArrayList<>();
        final String QUERY = "SELECT id_kvetina, id_kosik, pocet FROM kvetinykosiky WHERE id_kosik = ?";

        try (Connection c = dataSource.getConnection();
             PreparedStatement stmt = c.prepareStatement(QUERY)
        ) {
            stmt.setInt(1, id_kosik);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Integer id_kvetina = rs.getInt("id_kvetina");
                    int pocet = rs.getInt("pocet");
                    kvetinyKosiky.add(new KvetinaKosik(id_kvetina, id_kosik, pocet));
                }
            }
        }

        return kvetinyKosiky;
    }

    @Override
    public Status<KvetinaKosik> insert(KvetinaKosik kvetinaKosikRequest) {
        final String QUERY = "{CALL PCK_KVETINYKOSIKY.PROC_INSERT_KVETINYKOSIKY(?, ?, ?, ?, ?, ?, ?)}";

        try (Connection c = dataSource.getConnection();
             CallableStatement stmt = c.prepareCall(QUERY)
        ) {
            stmt.setInt(1, kvetinaKosikRequest.id_kvetina());
            stmt.setInt(2, kvetinaKosikRequest.id_kosik());
            stmt.setInt(3, kvetinaKosikRequest.pocet());

            stmt.registerOutParameter(4, Types.INTEGER); // o_id_kvetina
            stmt.registerOutParameter(5, Types.INTEGER); // o_id_kosik
            stmt.registerOutParameter(6, Types.INTEGER); // o_status_code
            stmt.registerOutParameter(7, Types.VARCHAR); // o_status_message

            stmt.execute();

            int out_id_kvetina = stmt.getInt(4);
            int out_id_kosik = stmt.getInt(5);
            int status_code = stmt.getInt(6);
            String status_message = stmt.getString(7);

            if (status_code == 1) {
                try {
                    KvetinaKosik result = findByIds(out_id_kvetina, out_id_kosik).get();
                    return new Status<>(status_code, status_message, result);
                } catch (SQLException e) {
                    return new Status<>(-998, "Chyba při dohledání vloženého záznamu KvetinaKosik: " + e.getMessage(), null);
                }
            } else {
                return new Status<>(status_code, status_message, null);
            }
        } catch (SQLException e) {
            return new Status<>(-999, "Kritická chyba databáze: " + e.getMessage(), null);
        }
    }

    @Override
    public Status<KvetinaKosik> update(KvetinaKosik kvetinaKosikRequest) {
        final String QUERY = "{CALL PCK_KVETINYKOSIKY.PROC_UPDATE_KVETINYKOSIKY(?, ?, ?, ?, ?, ?, ?)}";

        try (Connection c = dataSource.getConnection();
             CallableStatement stmt = c.prepareCall(QUERY)
        ) {
            stmt.setInt(1, kvetinaKosikRequest.id_kvetina());
            stmt.setInt(2, kvetinaKosikRequest.id_kosik());
            stmt.setInt(3, kvetinaKosikRequest.pocet());

            stmt.registerOutParameter(4, Types.INTEGER); // o_id_kvetina
            stmt.registerOutParameter(5, Types.INTEGER); // o_id_kosik
            stmt.registerOutParameter(6, Types.INTEGER); // o_status_code
            stmt.registerOutParameter(7, Types.VARCHAR); // o_status_message

            stmt.execute();

            int out_id_kvetina = stmt.getInt(4);
            int out_id_kosik = stmt.getInt(5);
            int status_code = stmt.getInt(6);
            String status_message = stmt.getString(7);

            if (status_code == 1) {
                try {
                    KvetinaKosik result = findByIds(out_id_kvetina, out_id_kosik).get();
                    return new Status<>(status_code, status_message, result);
                } catch (SQLException e) {
                    return new Status<>(-998, "Chyba při dohledání aktualizovaného záznamu KvetinaKosik: " + e.getMessage(), null);
                }
            } else {
                return new Status<>(status_code, status_message, null);
            }
        } catch (SQLException e) {
            return new Status<>(-999, "Kritická chyba databáze: " + e.getMessage(), null);
        }
    }

    @Override
    public Status<KvetinaKosik> delete(Integer id) {
        throw new UnsupportedOperationException("Tato entita nemá jednoduchý primární klíč. Použijte metodu deleteByIds.");
    }

    public Status<KvetinaKosik> deleteByIds(Integer id_kvetina, Integer id_kosik) {
        final String QUERY = "{CALL PCK_KVETINYKOSIKY.PROC_DELETE_KVETINYKOSIKY(?, ?, ?, ?)}";

        try (Connection c = dataSource.getConnection();
             CallableStatement stmt = c.prepareCall(QUERY)
        ) {
            stmt.setInt(1, id_kvetina);
            stmt.setInt(2, id_kosik);
            stmt.registerOutParameter(3, Types.INTEGER);
            stmt.registerOutParameter(4, Types.VARCHAR);

            stmt.execute();
            int status_code = stmt.getInt(3);
            String status_message = stmt.getString(4);

            return new Status<>(status_code, status_message, null);
        } catch (SQLException e) {
            return new Status<>(-999, "Kritická chyba databáze: " + e.getMessage(), null);
        }
    }
}