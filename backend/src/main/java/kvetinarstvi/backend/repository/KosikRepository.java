package kvetinarstvi.backend.repository;

import kvetinarstvi.backend.records.Kosik;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import javax.sql.DataSource;
import java.sql.*;
import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Repository
public class KosikRepository implements IRepository<Kosik> {

    @Autowired
    private DataSource dataSource;

    @Override
    public Optional<Kosik> findById(Integer ID) throws SQLException {
        final String QUERY = "SELECT id_kosik, datum_vytvoreni, cena, sleva, id_uzivatel, id_stav_objednavky, id_zpusob_platby FROM kosiky WHERE id_kosik = ?";

        Connection c = dataSource.getConnection();
        PreparedStatement stmt = c.prepareStatement(QUERY);
        stmt.setInt(1, ID);
        ResultSet rs = stmt.executeQuery();

        if (rs.next()) {
            int id_kosik = rs.getInt("id_kosik");
            Timestamp timestamp = rs.getTimestamp("datum_vytvoreni");
            ZonedDateTime datum_vytvoreni = timestamp != null
                    ? timestamp.toLocalDateTime().atZone(ZoneId.systemDefault())
                    : null;

            Double cena = rs.getDouble("cena");
            int sleva = rs.getInt("sleva");
            Integer id_uzivatel = rs.getInt("id_uzivatel");
            Integer id_stav_objednavky = rs.getInt("id_stav_objednavky");
            Integer id_zpusob_platby = rs.getInt("id_zpusob_platby");

            return Optional.of(new Kosik(id_kosik, datum_vytvoreni, cena, sleva, id_uzivatel, id_stav_objednavky, id_zpusob_platby));
        }

        return Optional.empty();
    }

    @Override
    public List<Kosik> findAll() throws SQLException {
        List<Kosik> kosiky = new ArrayList<>();
        final String QUERY = "SELECT id_kosik, datum_vytvoreni, cena, sleva, id_uzivatel, id_stav_objednavky, id_zpusob_platby FROM kosiky";

        Connection c = dataSource.getConnection();
        PreparedStatement stmt = c.prepareStatement(QUERY);
        ResultSet rs = stmt.executeQuery();

        while (rs.next()) {
            int id_kosik = rs.getInt("id_kosik");
            Timestamp timestamp = rs.getTimestamp("datum_vytvoreni");
            ZonedDateTime datum_vytvoreni = timestamp != null
                    ? timestamp.toLocalDateTime().atZone(ZoneId.systemDefault())
                    : null;

            Double cena = rs.getDouble("cena");
            int sleva = rs.getInt("sleva");
            Integer id_uzivatel = rs.getInt("id_uzivatel");
            Integer id_stav_objednavky = rs.getInt("id_stav_objednavky");
            Integer id_zpusob_platby = rs.getInt("id_zpusob_platby");

            kosiky.add(new Kosik(id_kosik, datum_vytvoreni, cena, sleva, id_uzivatel, id_stav_objednavky, id_zpusob_platby));
        }

        return kosiky;
    }

    @Override
    public Status<Kosik> insert(Kosik kosikRequest) {
        final String QUERY = "{CALL PCK_KOSIKY.PROC_INSERT_KOSIK(?, ?, ?, ?, ?, ?, ?, ?)}";

        try {
            Connection c = dataSource.getConnection();
            CallableStatement stmt = c.prepareCall(QUERY);

            stmt.setDouble(1, kosikRequest.cena());
            stmt.setInt(2, kosikRequest.sleva());

            if (kosikRequest.id_uzivatel() == null) {
                stmt.setNull(3, Types.INTEGER);
            } else {
                stmt.setInt(3, kosikRequest.id_uzivatel());
            }

            if (kosikRequest.id_stav_objednavky() == null) {
                stmt.setNull(4, Types.INTEGER);
            } else {
                stmt.setInt(4, kosikRequest.id_stav_objednavky());
            }

            if (kosikRequest.id_zpusob_platby() == null) {
                stmt.setNull(5, Types.INTEGER);
            } else {
                stmt.setInt(5, kosikRequest.id_zpusob_platby());
            }

            stmt.registerOutParameter(6, Types.INTEGER); // o_id_kosik
            stmt.registerOutParameter(7, Types.INTEGER); // o_status_code
            stmt.registerOutParameter(8, Types.VARCHAR); // o_status_message

            stmt.execute();

            int id_kosik = stmt.getInt(6);
            int status_code = stmt.getInt(7);
            String status_message = stmt.getString(8);

            if (status_code == 1) {
                Kosik kosik = findById(id_kosik).get();
                return new Status<>(status_code, status_message, kosik);
            } else {
                return new Status<>(status_code, status_message, null);
            }
        } catch (SQLException e) {
            return new Status<>(-999, "Kritická chyba databáze: " + e.getMessage(), null);
        }
    }

    @Override
    public Status<Kosik> update(Kosik kosikRequest) {
        final String QUERY = "{CALL PCK_KOSIKY.PROC_UPDATE_KOSIK(?, ?, ?, ?, ?, ?, ?, ?, ?)}";

        try {
            Connection c = dataSource.getConnection();
            CallableStatement stmt = c.prepareCall(QUERY);

            stmt.setInt(1, kosikRequest.id_kosik());
            stmt.setDouble(2, kosikRequest.cena());
            stmt.setInt(3, kosikRequest.sleva());

            if (kosikRequest.id_uzivatel() == null) {
                stmt.setNull(4, Types.INTEGER);
            } else {
                stmt.setInt(4, kosikRequest.id_uzivatel());
            }

            if (kosikRequest.id_stav_objednavky() == null) {
                stmt.setNull(5, Types.INTEGER);
            } else {
                stmt.setInt(5, kosikRequest.id_stav_objednavky());
            }

            if (kosikRequest.id_zpusob_platby() == null) {
                stmt.setNull(6, Types.INTEGER);
            } else {
                stmt.setInt(6, kosikRequest.id_zpusob_platby());
            }

            stmt.registerOutParameter(7, Types.INTEGER); // o_id_kosik
            stmt.registerOutParameter(8, Types.INTEGER); // o_status_code
            stmt.registerOutParameter(9, Types.VARCHAR); // o_status_message

            stmt.execute();

            int id_kosik = stmt.getInt(7);
            int status_code = stmt.getInt(8);
            String status_message = stmt.getString(9);

            if (status_code == 1) {
                Kosik kosik = findById(id_kosik).get();
                return new Status<>(status_code, status_message, kosik);
            } else {
                return new Status<>(status_code, status_message, null);
            }
        } catch (SQLException e) {
            return new Status<>(-999, "Kritická chyba databáze: " + e.getMessage(), null);
        }
    }

    @Override
    public Status<Kosik> delete(Integer id) {
        final String QUERY = "{CALL PCK_KOSIKY.PROC_DELETE_KOSIK(?, ?, ?)}";

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