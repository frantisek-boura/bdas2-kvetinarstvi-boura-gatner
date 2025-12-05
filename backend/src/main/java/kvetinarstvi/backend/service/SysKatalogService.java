package kvetinarstvi.backend.service;

import kvetinarstvi.backend.records.KatalogEntry;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

@Service
public class SysKatalogService {

    @Autowired
    private DataSource dataSource;

    public List<KatalogEntry> findAll() throws SQLException {
        List<KatalogEntry> entries = new ArrayList<>();
        final String QUERY = "SELECT * FROM view_sys_katalog";

        try (Connection c = dataSource.getConnection();
             PreparedStatement stmt = c.prepareStatement(QUERY);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                String tabulka = rs.getString("tabulka");
                String sloupec = rs.getString("sloupec");
                String datovy_typ = rs.getString("datovy_typ");

                entries.add(new KatalogEntry(tabulka, sloupec, datovy_typ));
            }
        }

        return entries;
    }

}
