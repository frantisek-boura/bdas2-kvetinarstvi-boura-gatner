package kvetinarstvi.backend.repository;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import javax.sql.DataSource;

import kvetinarstvi.backend.repository.enums.DeleteStatus;
import kvetinarstvi.backend.request.MestoRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kvetinarstvi.backend.records.Mesto;

@Service
public class MestoRepository {
    
    @Autowired
    private DataSource dataSource;

    public Mesto createMesto(MestoRequest request) throws SQLException {
        final String QUERY = "{CALL PCK_MESTA.PROC_INSERT_MESTO(?, ?)}";

        Connection c = dataSource.getConnection();
        CallableStatement stmt = c.prepareCall(QUERY);

        stmt.setString(1, request.nazev().trim());
        stmt.registerOutParameter(2, Types.INTEGER);

        stmt.execute();
        int id_mesto = stmt.getInt(2);

        return new Mesto(id_mesto, request.nazev());
    }

    public Mesto updateMesto(MestoRequest request) throws SQLException {
        final String QUERY = "{CALL PCK_MESTA.PROC_UPDATE_MESTO(?, ?, ?)}";

        Connection c = dataSource.getConnection();
        CallableStatement stmt = c.prepareCall(QUERY);

        stmt.setInt(1, request.id_mesto());
        stmt.setString(2, request.nazev().trim());
        stmt.registerOutParameter(3, Types.INTEGER);

        stmt.execute();
        int id_mesto = stmt.getInt(3);

        return new Mesto(id_mesto, request.nazev().trim());
    }

    public DeleteStatus deleteMesto(Integer id) throws SQLException {
        final String QUERY = "{CALL PCK_MESTA.PROC_DELETE_MESTO(?, ?)}";

        Connection c = dataSource.getConnection();
        CallableStatement stmt = c.prepareCall(QUERY);

        stmt.setInt(1, id);
        stmt.registerOutParameter(2, Types.INTEGER);

        stmt.execute();
        int status = stmt.getInt(2);

        return DeleteStatus.fromCode(status);
    }

    public List<Mesto> findAllMesta() throws SQLException {
        final String QUERY = "SELECT id_mesto, nazev FROM mesta";
        List<Mesto> mesta = new ArrayList<>();

        Connection c = dataSource.getConnection();
        PreparedStatement stmt = c.prepareStatement(QUERY);        
        ResultSet rs = stmt.executeQuery();

        while (rs.next()) {
            int id_mesto = rs.getInt("id_mesto");
            String nazev = rs.getString("nazev");

            mesta.add(new Mesto(id_mesto, nazev));
        } 

        return mesta;
    }

    public Optional<Mesto> findMestoById(Integer id) throws SQLException {
        final String QUERY = "SELECT id_mesto, nazev FROM mesta WHERE id_mesto = ?";

        Connection c = dataSource.getConnection();
        PreparedStatement stmt = c.prepareStatement(QUERY);        
        stmt.setInt(1, id);

        ResultSet rs = stmt.executeQuery();

        if (rs.next()) {
            int id_mesto = rs.getInt("id_mesto");
            String nazev = rs.getString("nazev");

            return Optional.of(new Mesto(id_mesto, nazev));
        } else {
            return Optional.empty();
        }
    }
}
