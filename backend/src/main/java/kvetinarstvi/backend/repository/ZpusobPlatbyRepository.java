package kvetinarstvi.backend.repository;

import kvetinarstvi.backend.records.ZpusobPlatby;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import javax.sql.DataSource;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Repository
public class ZpusobPlatbyRepository implements IRepository<ZpusobPlatby> {

    @Autowired
    private DataSource dataSource;

    @Override
    public Optional<ZpusobPlatby> findById(Integer ID) throws SQLException {
        final String QUERY = "SELECT id_zpusob_platby, nazev FROM zpusobyplateb WHERE id_zpusob_platby = ?";

        Connection c = dataSource.getConnection();
        PreparedStatement stmt = c.prepareStatement(QUERY);
        stmt.setInt(1, ID);
        ResultSet rs = stmt.executeQuery();

        if (rs.next()) {
            int id_zpusob_platby = rs.getInt("id_zpusob_platby");
            String nazev = rs.getString("nazev");

            return Optional.of(new ZpusobPlatby(id_zpusob_platby, nazev));
        }

        return Optional.empty();
    }

    @Override
    public List<ZpusobPlatby> findAll() throws SQLException {
        List<ZpusobPlatby> zpusobyplateb = new ArrayList<>();
        final String QUERY = "SELECT id_zpusob_platby, nazev FROM zpusobyplateb";

        Connection c = dataSource.getConnection();
        PreparedStatement stmt = c.prepareStatement(QUERY);
        ResultSet rs = stmt.executeQuery();

        while (rs.next()) {
            int id_zpusob_platby = rs.getInt("id_zpusob_platby");
            String nazev = rs.getString("nazev");

            zpusobyplateb.add(new ZpusobPlatby(id_zpusob_platby, nazev));
        }

        return zpusobyplateb;
    }

    @Override
    public Status<ZpusobPlatby> insert(ZpusobPlatby zpusobPlatbyRequest) {
        final String QUERY = "{CALL PCK_PLATBY.PROC_INSERT_PLATBA(?, ?, ?, ?)}";

        try {
            Connection c = dataSource.getConnection();
            CallableStatement stmt = c.prepareCall(QUERY);
            stmt.setString(1, zpusobPlatbyRequest.nazev());
            stmt.registerOutParameter(2, Types.INTEGER);
            stmt.registerOutParameter(3, Types.INTEGER);
            stmt.registerOutParameter(4, Types.VARCHAR);

            stmt.execute();
            int id_zpusob_platby = stmt.getInt(2);
            int status_code = stmt.getInt(3);
            String status_message = stmt.getString(4);

            if (status_code == 1) {
                ZpusobPlatby platba = findById(id_zpusob_platby).get();
                return new Status<>(status_code, status_message, platba);
            } else {
                return new Status<>(status_code, status_message, null);
            }
        } catch (SQLException e) {
            return new Status<>(-999, "Kritická chyba databáze: " + e.getMessage(), null);
        }
    }

    @Override
    public Status<ZpusobPlatby> update(ZpusobPlatby zpusobPlatbyRequest) {
        final String QUERY = "{CALL PCK_PLATBY.PROC_UPDATE_PLATBA(?, ?, ?, ?, ?)}";

        try {
            Connection c = dataSource.getConnection();
            CallableStatement stmt = c.prepareCall(QUERY);
            stmt.setInt(1, zpusobPlatbyRequest.id_zpusob_platby());
            stmt.setString(2, zpusobPlatbyRequest.nazev());
            stmt.registerOutParameter(3, Types.INTEGER);
            stmt.registerOutParameter(4, Types.INTEGER);
            stmt.registerOutParameter(5, Types.VARCHAR);

            stmt.execute();
            int id_zpusob_platby = stmt.getInt(3);
            int status_code = stmt.getInt(4);
            String status_message = stmt.getString(5);

            if (status_code == 1) {
                ZpusobPlatby platba = findById(id_zpusob_platby).get();
                return new Status<>(status_code, status_message, platba);
            } else {
                return new Status<>(status_code, status_message, null);
            }
        } catch (SQLException e) {
            return new Status<>(-999, "Kritická chyba databáze: " + e.getMessage(), null);
        }
    }

    @Override
    public Status<ZpusobPlatby> delete(Integer id) {
        final String QUERY = "{CALL PCK_PLATBY.PROC_DELETE_PLATBA(?, ?, ?)}";

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