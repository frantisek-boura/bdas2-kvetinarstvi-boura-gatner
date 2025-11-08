package kvetinarstvi.backend.repository;

import kvetinarstvi.backend.records.Kategorie;
import kvetinarstvi.backend.records.Kvetina;
import kvetinarstvi.backend.records.Obrazek;
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
public class KvetinaRepository {

    @Autowired
    private DataSource dataSource;

    public List<Kvetina> findAllKvetiny() throws SQLException {
        final String QUERY = """
                SELECT
                    k.id_kvetina, k.nazev AS nazev_kvetiny, k.cena,
                    k.id_kategorie, ka.nazev AS nazev_kategorie,
                    k.id_obrazek, o.nazev_souboru, o.data
                FROM
                    kvetiny k
                JOIN
                    kategorie ka ON k.id_kategorie = ka.id_kategorie
                JOIN
                    obrazky o ON k.id_obrazek = o.id_obrazek
                """;
        List<Kvetina> kvetiny = new ArrayList<>();

        Connection c = dataSource.getConnection();
        PreparedStatement stmt = c.prepareStatement(QUERY);
        ResultSet rs = stmt.executeQuery();

        while (rs.next()) {
            int id_kvetina = rs.getInt("id_kvetina");
            String nazev_kvetiny = rs.getString("nazev_kvetiny");
            double cena = rs.getDouble("cena");
            int id_kategorie = rs.getInt("id_kategorie");
            String nazev_kategorie = rs.getString("nazev_kategorie");
            int id_obrazek = rs.getInt("id_obrazek");
            String nazev_souboru = rs.getString("nazev_souboru");
            byte[] data = rs.getBytes("data");

            kvetiny.add(
                    new Kvetina(
                            id_kvetina, nazev_kvetiny, cena,
                            new Kategorie(id_kategorie, nazev_kategorie, null),
                            new Obrazek(id_obrazek, nazev_souboru, data)
                    )
            );
        }

        return kvetiny;
    }

    public Optional<Kvetina> findKvetinaById(Integer id) throws SQLException {
        final String QUERY = """
                SELECT
                    k.id_kvetina, k.nazev AS nazev_kvetiny, k.cena,
                    k.id_kategorie, ka.nazev AS nazev_kategorie,
                    k.id_obrazek, o.nazev_souboru, o.data
                FROM
                    kvetiny k
                JOIN
                    kategorie ka ON k.id_kategorie = ka.id_kategorie
                JOIN
                    obrazky o ON k.id_obrazek = o.id_obrazek
                WHERE
                    k.id_kvetina = ?
                """;

        Connection c = dataSource.getConnection();
        PreparedStatement stmt = c.prepareStatement(QUERY);
        stmt.setInt(1, id);

        ResultSet rs = stmt.executeQuery();

        if (rs.next()) {
            int id_kvetina = rs.getInt("id_kvetina");
            String nazev_kvetiny = rs.getString("nazev_kvetiny");
            double cena = rs.getDouble("cena");
            int id_kategorie = rs.getInt("id_kategorie");
            String nazev_kategorie = rs.getString("nazev_kategorie");
            int id_obrazek = rs.getInt("id_obrazek");
            String nazev_souboru = rs.getString("nazev_souboru");
            byte[] data = rs.getBytes("data");

            return Optional.of(
                    new Kvetina(
                            id_kvetina, nazev_kvetiny, cena,
                            new Kategorie(id_kategorie, nazev_kategorie, null),
                            new Obrazek(id_obrazek, nazev_souboru, data)
                    )
            );
        } else {
            return Optional.empty();
        }
    }

}
