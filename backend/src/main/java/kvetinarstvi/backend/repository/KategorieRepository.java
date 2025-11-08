package kvetinarstvi.backend.repository;

import kvetinarstvi.backend.records.Kategorie;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Optional;

@Service
public class KategorieRepository {

    @Autowired
    private DataSource dataSource;

    public List<Kategorie> findAllKategorie() throws SQLException {
        final String QUERY = """
                SELECT
                    id_kategorie,
                    nazev,
                    id_nadrazene_kategorie
                FROM
                    kategorie
                ORDER BY
                    id_nadrazene_kategorie ASC NULLS FIRST 
                """;
        List<Kategorie> kategorie = new ArrayList<>();
        HashMap<Integer, Kategorie> paryIDKategorie = new HashMap<>();

        Connection c = dataSource.getConnection();
        PreparedStatement stmt = c.prepareStatement(QUERY);
        ResultSet rs = stmt.executeQuery();

        Kategorie k;
        while (rs.next()) {
            int id_kategorie = rs.getInt("id_kategorie");
            String nazev = rs.getString("nazev");
            int id_nadrazene_kategorie = rs.getInt("id_nadrazene_kategorie");

            if (rs.wasNull()) {
                k = new Kategorie(id_kategorie, nazev, null);
            } else {
                k = new Kategorie(id_kategorie, nazev, paryIDKategorie.get(id_nadrazene_kategorie));
            }

            paryIDKategorie.put(id_kategorie, k);
            kategorie.add(k);
        }

        return kategorie;
    }

    public Optional<Kategorie> findKategorieById(Integer id) throws SQLException {
        final String QUERY = """
                SELECT
                    id_kategorie,
                    nazev,
                    id_nadrazene_kategorie,
                    LEVEL AS uroven
                FROM
                    kategorie k
                START WITH
                    id_kategorie = ?
                CONNECT BY
                    PRIOR id_nadrazene_kategorie = id_kategorie
                ORDER BY
                    uroven DESC
                """;

        Connection c = dataSource.getConnection();
        PreparedStatement stmt = c.prepareStatement(QUERY);
        stmt.setInt(1, id);

        ResultSet rs = stmt.executeQuery();
        HashMap<Integer, Kategorie> paryIDKategorie = new HashMap<>();

        Kategorie k = null;
        while (rs.next()) {
            int id_kategorie = rs.getInt("id_kategorie");
            String nazev = rs.getString("nazev");
            int id_nadrazene_kategorie = rs.getInt("id_nadrazene_kategorie");

            if (rs.wasNull()) {
                k = new Kategorie(id_kategorie, nazev, null);
            } else {
                k = new Kategorie(id_kategorie, nazev, paryIDKategorie.get(id_nadrazene_kategorie));
            }

            paryIDKategorie.put(id_kategorie, k);
        }

        if (k == null) {
            return Optional.empty();
        }

        return Optional.of(paryIDKategorie.get(id));

    }

}