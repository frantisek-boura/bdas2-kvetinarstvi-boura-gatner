package kvetinarstvi.backend.repository;

import java.sql.*;
import java.time.ZonedDateTime;
import java.time.ZoneId;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import kvetinarstvi.backend.records.Dotaz;

@Repository
public class DotazRepository implements IRepository<Dotaz> {

    @Autowired
    private DataSource dataSource;

    @Override
    public Optional<Dotaz> findById(Integer ID) throws SQLException {
        final String QUERY = "SELECT id_dotaz, datum_podani, verejny, text, odpoved, id_odpovidajici_uzivatel FROM dotazy WHERE id_dotaz = ?";

        try (Connection c = dataSource.getConnection();
             PreparedStatement stmt = c.prepareStatement(QUERY)
        ) {
            stmt.setInt(1, ID);
            try (ResultSet rs = stmt.executeQuery()) {

                if (rs.next()) {
                    int id_dotaz = rs.getInt("id_dotaz");
                    Timestamp timestamp = rs.getTimestamp("datum_podani");
                    ZonedDateTime datum_podani = timestamp != null
                            ? timestamp.toLocalDateTime().atZone(ZoneId.systemDefault())
                            : null;

                    boolean verejny = rs.getBoolean("verejny");
                    String text = rs.getString("text");
                    String odpoved = rs.getString("odpoved");

                    int id_odpovidajici_uzivatel = rs.getInt("id_odpovidajici_uzivatel");
                    Integer id_uzivatel = rs.wasNull() ? null : id_odpovidajici_uzivatel;

                    return Optional.of(new Dotaz(id_dotaz, datum_podani, verejny, text, odpoved, id_uzivatel));
                }
            }
        }

        return Optional.empty();
    }

    @Override
    public List<Dotaz> findAll() throws SQLException {
        List<Dotaz> dotazy = new ArrayList<>();
        final String QUERY = "SELECT id_dotaz, datum_podani, verejny, text, odpoved, id_odpovidajici_uzivatel FROM dotazy";

        try (Connection c = dataSource.getConnection();
             PreparedStatement stmt = c.prepareStatement(QUERY);
             ResultSet rs = stmt.executeQuery()
        ) {
            while (rs.next()) {
                int id_dotaz = rs.getInt("id_dotaz");
                Timestamp timestamp = rs.getTimestamp("datum_podani");
                ZonedDateTime datum_podani = timestamp != null
                        ? timestamp.toLocalDateTime().atZone(ZoneId.systemDefault())
                        : null;

                boolean verejny = rs.getBoolean("verejny");
                String text = rs.getString("text");
                String odpoved = rs.getString("odpoved");

                int id_odpovidajici_uzivatel = rs.getInt("id_odpovidajici_uzivatel");
                Integer id_uzivatel = rs.wasNull() ? null : id_odpovidajici_uzivatel;

                dotazy.add(new Dotaz(id_dotaz, datum_podani, verejny, text, odpoved, id_uzivatel));
            }
        }

        return dotazy;
    }

    @Override
    public Status<Dotaz> insert(Dotaz dotazRequest) {
        final String QUERY = "{CALL PCK_DOTAZY.PROC_INSERT_DOTAZ(?, ?, ?, ?, ?, ?, ?)}";

        try (Connection c = dataSource.getConnection();
             CallableStatement stmt = c.prepareCall(QUERY)
        ) {
            stmt.setString(1, dotazRequest.text());
            stmt.setInt(2, dotazRequest.verejny() ? 1 : 0);

            if (dotazRequest.odpoved() == null) {
                stmt.setNull(3, Types.CLOB);
            } else {
                stmt.setString(3, dotazRequest.odpoved());
            }

            if (dotazRequest.id_odpovidajici_uzivatel() == null) {
                stmt.setNull(4, Types.INTEGER);
            } else {
                stmt.setInt(4, dotazRequest.id_odpovidajici_uzivatel());
            }

            stmt.registerOutParameter(5, Types.INTEGER);
            stmt.registerOutParameter(6, Types.INTEGER);
            stmt.registerOutParameter(7, Types.VARCHAR);

            stmt.execute();

            int id_dotaz = stmt.getInt(5);
            int status_code = stmt.getInt(6);
            String status_message = stmt.getString(7);

            if (status_code == 1) {
                try {
                    Dotaz dotaz = findById(id_dotaz).get();
                    return new Status<>(status_code, status_message, dotaz);
                } catch (SQLException e) {
                    return new Status<>(-998, "Chyba při dohledání vloženého dotazu: " + e.getMessage(), null);
                }
            } else {
                return new Status<>(status_code, status_message, null);
            }
        } catch (SQLException e) {
            return new Status<>(-999, "Kritická chyba databáze: " + e.getMessage(), null);
        }
    }

    @Override
    public Status<Dotaz> update(Dotaz dotazRequest) {
        final String QUERY = "{CALL PCK_DOTAZY.PROC_UPDATE_DOTAZ(?, ?, ?, ?, ?, ?, ?, ?)}";

        try (Connection c = dataSource.getConnection();
             CallableStatement stmt = c.prepareCall(QUERY)
        ) {
            stmt.setInt(1, dotazRequest.id_dotaz());
            stmt.setString(2, dotazRequest.text());
            stmt.setInt(3, dotazRequest.verejny() ? 1 : 0);

            if (dotazRequest.odpoved() == null) {
                stmt.setNull(4, Types.CLOB);
            } else {
                stmt.setString(4, dotazRequest.odpoved());
            }

            if (dotazRequest.id_odpovidajici_uzivatel() == null) {
                stmt.setNull(5, Types.INTEGER);
            } else {
                stmt.setInt(5, dotazRequest.id_odpovidajici_uzivatel());
            }

            stmt.registerOutParameter(6, Types.INTEGER);
            stmt.registerOutParameter(7, Types.INTEGER);
            stmt.registerOutParameter(8, Types.VARCHAR);

            stmt.execute();

            int id_dotaz = stmt.getInt(6);
            int status_code = stmt.getInt(7);
            String status_message = stmt.getString(8);

            if (status_code == 1) {
                try {
                    Dotaz dotaz = findById(id_dotaz).get();
                    return new Status<>(status_code, status_message, dotaz);
                } catch (SQLException e) {
                    return new Status<>(-998, "Chyba při dohledání aktualizovaného dotazu: " + e.getMessage(), null);
                }
            } else {
                return new Status<>(status_code, status_message, null);
            }
        } catch (SQLException e) {
            return new Status<>(-999, "Kritická chyba databáze: " + e.getMessage(), null);
        }
    }

    @Override
    public Status<Dotaz> delete(Integer id) {
        final String QUERY = "{CALL PCK_DOTAZY.PROC_DELETE_DOTAZ(?, ?, ?)}";

        try (Connection c = dataSource.getConnection();
             CallableStatement stmt = c.prepareCall(QUERY)
        ) {
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