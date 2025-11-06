package kvetinarstvi.backend.service;

import kvetinarstvi.backend.records.LogAkce;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Service
public class LogAkceService {

    @Autowired
    private DataSource dataSource;

    public List<LogAkce> findAllLogAkce() throws SQLException {
        final String QUERY = "SELECT id_log_akce, nazev FROM logakce";
        List<LogAkce> logakce = new ArrayList<>();

        Connection c = dataSource.getConnection();
        PreparedStatement stmt = c.prepareStatement(QUERY);
        ResultSet rs = stmt.executeQuery();

        while (rs.next()) {
            int id_log_akce = rs.getInt("id_log_akce");
            String nazev = rs.getString("nazev");

            logakce.add(new LogAkce(id_log_akce, nazev));
        }

        return logakce;
    }


    public Optional<LogAkce> findLogAkceById(Integer id) throws SQLException {
        final String QUERY = "SELECT id_log_akce, nazev FROM logakce WHERE id_log_akce = ?";

        Connection c = dataSource.getConnection();
        PreparedStatement stmt = c.prepareStatement(QUERY);
        stmt.setInt(1, id);

        ResultSet rs = stmt.executeQuery();

        if (rs.next()) {
            int id_log_akce = rs.getInt("id_log_akce");
            String nazev = rs.getString("nazev");

            return Optional.of(new LogAkce(id_log_akce, nazev));
        } else {
            return Optional.empty();
        }
    }
}
