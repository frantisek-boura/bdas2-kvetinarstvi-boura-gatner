package kvetinarstvi.backend.service;

import kvetinarstvi.backend.records.Log;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.sql.DataSource;
import java.sql.*;
import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.util.ArrayList;
import java.util.List;

@Service
public class LogsService {

    @Autowired
    private DataSource dataSource;

    public List<Log> findAll() throws SQLException {
        List<Log> logs = new ArrayList<>();
        final String QUERY = "SELECT * FROM view_logs";

        try (Connection c = dataSource.getConnection();
             PreparedStatement stmt = c.prepareStatement(QUERY);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                int id_log = rs.getInt("id_log");
                String akce = rs.getString("akce");
                String nazev_tabulky = rs.getString("nazev_tabulky");
                Timestamp timestamp = rs.getTimestamp("datum_akce");
                ZonedDateTime datum_akce = timestamp != null
                        ? timestamp.toLocalDateTime().atZone(ZoneId.systemDefault())
                        : null;
                String novy_zaznam = rs.getString("novy_zaznam");
                String stary_zaznam = rs.getString("stary_zaznam");

                logs.add(new Log(id_log, akce, nazev_tabulky, datum_akce, novy_zaznam, stary_zaznam));
            }
        }

        return logs;
    }
}
