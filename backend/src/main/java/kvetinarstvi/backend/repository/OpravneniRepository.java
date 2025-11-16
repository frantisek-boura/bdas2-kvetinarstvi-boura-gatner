package kvetinarstvi.backend.repository;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import kvetinarstvi.backend.records.Opravneni;

@Repository
public class OpravneniRepository implements IRepository<Opravneni> {

    @Autowired
    private DataSource dataSource;

    @Override
    public Optional<Opravneni> findById(Integer ID) throws SQLException {
        final String QUERY = "SELECT id_opravneni, nazev, uroven_opravneni FROM opravneni WHERE id_opravneni = ?";

        Connection c = dataSource.getConnection();
        PreparedStatement stmt = c.prepareStatement(QUERY);
        stmt.setInt(1, ID);
        ResultSet rs = stmt.executeQuery();

        if (rs.next()) {
            int id_opravneni = rs.getInt("id_opravneni");
            String nazev = rs.getString("nazev");
            int uroven_opravneni = rs.getInt("uroven_opravneni");

            return Optional.of(new Opravneni(id_opravneni, nazev, uroven_opravneni));
        }

        return Optional.empty();
    }

    @Override
    public List<Opravneni> findAll() throws SQLException {
        List<Opravneni> opravneni = new ArrayList<>();
        final String QUERY = "SELECT id_opravneni, nazev, uroven_opravneni FROM opravneni";

        Connection c = dataSource.getConnection();
        PreparedStatement stmt = c.prepareStatement(QUERY);
        ResultSet rs = stmt.executeQuery();

        while (rs.next()) {
            int id_opravneni = rs.getInt("id_opravneni");
            String nazev = rs.getString("nazev");
            int uroven_opravneni = rs.getInt("uroven_opravneni");

            opravneni.add(new Opravneni(id_opravneni, nazev, uroven_opravneni));
        }

        return opravneni;
    }

    @Override
    public Status<Opravneni> insert(Opravneni opravneniRequest) {
        final String QUERY = "{CALL PCK_OPRAVNENI.PROC_INSERT_OPRAVNENI(?, ?, ?, ?, ?)}";

        try {
            Connection c = dataSource.getConnection();
            CallableStatement stmt = c.prepareCall(QUERY);
            stmt.setString(1, opravneniRequest.nazev());
            stmt.setInt(2, opravneniRequest.uroven_opravneni());
            stmt.registerOutParameter(3, Types.INTEGER);
            stmt.registerOutParameter(4, Types.INTEGER);
            stmt.registerOutParameter(5, Types.VARCHAR);

            stmt.execute();
            int id_opravneni = stmt.getInt(3);
            int status_code = stmt.getInt(4);
            String status_message = stmt.getString(5);

            if (status_code == 1) {
                Opravneni opravneni = findById(id_opravneni).get();
                return new Status<>(status_code, status_message, opravneni);
            } else {
                return new Status<>(status_code, status_message, null);
            }
        } catch (SQLException e) {
            return new Status<>(-999, "Kritická chyba databáze: " + e.getMessage(), null);
        }
    }

    @Override
    public Status<Opravneni> update(Opravneni opravneniRequest) {
        final String QUERY = "{CALL PCK_OPRAVNENI.PROC_UPDATE_OPRAVNENI(?, ?, ?, ?, ?, ?)}";

        try {
            Connection c = dataSource.getConnection();
            CallableStatement stmt = c.prepareCall(QUERY);
            stmt.setInt(1, opravneniRequest.id_opravneni());
            stmt.setString(2, opravneniRequest.nazev());
            stmt.setInt(3, opravneniRequest.uroven_opravneni());
            stmt.registerOutParameter(4, Types.INTEGER);
            stmt.registerOutParameter(5, Types.INTEGER);
            stmt.registerOutParameter(6, Types.VARCHAR);

            stmt.execute();
            int id_opravneni = stmt.getInt(4);
            int status_code = stmt.getInt(5);
            String status_message = stmt.getString(6);

            if (status_code == 1) {
                Opravneni opravneni = findById(id_opravneni).get();
                return new Status<>(status_code, status_message, opravneni);
            } else {
                return new Status<>(status_code, status_message, null);
            }
        } catch (SQLException e) {
            return new Status<>(-999, "Kritická chyba databáze: " + e.getMessage(), null);
        }
    }

    @Override
    public Status<Opravneni> delete(Integer id) {
        final String QUERY = "{CALL PCK_OPRAVNENI.PROC_DELETE_OPRAVNENI(?, ?, ?)}";

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