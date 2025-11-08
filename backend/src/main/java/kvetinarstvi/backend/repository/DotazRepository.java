package kvetinarstvi.backend.repository;

import kvetinarstvi.backend.records.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.OffsetDateTime;
import java.time.ZoneId;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Service
public class DotazRepository {

    @Autowired
    private DataSource dataSource;

    public List<Dotaz> findAllDotazy() throws SQLException {
        final String QUERY = """
                SELECT
                    d.id_dotaz, d.datum_podani, d.verejny, d.text, d.odpoved, d.id_odpovidajici_uzivatel,
                    u.email,
                    u.id_opravneni, op.nazev, op.uroven,
                    u.id_obrazek, o.nazev_souboru, o.data
                FROM
                    dotazy d
                LEFT JOIN
                    uzivatele u ON d.id_odpovidajici_uzivatel = u.id_uzivatel
                LEFT JOIN
                    obrazky o ON u.id_obrazek = o.id_obrazek
                LEFT JOIN
                    opravneni op ON u.id_opravneni = op.id_opravneni
                """;
        List<Dotaz> dotazy = new ArrayList<>();

        Connection c = dataSource.getConnection();
        PreparedStatement stmt = c.prepareStatement(QUERY);
        ResultSet rs = stmt.executeQuery();

        while (rs.next()) {
            int id_dotaz = rs.getInt("id_dotaz");
            OffsetDateTime datum_podani = rs.getTimestamp("datum_podani").toInstant().atZone(ZoneId.systemDefault()).toOffsetDateTime();
            boolean verejny = rs.getBoolean("verejny");
            String text = rs.getString("text");
            String odpoved = rs.getString("odpoved");

            Dotaz dotaz;
            if (!rs.wasNull()) {
                int id_uzivatel = rs.getInt("id_odpovidajici_uzivatel");
                String email = rs.getString("email");
                int id_opravneni = rs.getInt("id_opravneni");
                String nazev = rs.getString("nazev");
                int uroven = rs.getInt("uroven");
                int id_obrazek = rs.getInt("id_obrazek");
                String nazev_souboru = rs.getString("nazev_souboru");
                byte[] data = rs.getBytes("data");

                // neni potreba poskytovat dalsi data o uzivateli jako hash, sul, adresu atd...
                Uzivatel odpovidajiciUzivatel = new Uzivatel(id_uzivatel, email, null, null,
                        new Opravneni(id_opravneni, nazev, uroven),
                        new Obrazek(id_obrazek, nazev_souboru, data),
                        null
                );

                dotaz = new Dotaz(id_dotaz, datum_podani, verejny, text, odpoved, odpovidajiciUzivatel);
            } else {
                dotaz = new Dotaz(id_dotaz, datum_podani, verejny, text, odpoved, null);
            }

            dotazy.add(dotaz);
        }

        return dotazy;
    }

    public Optional<Dotaz> findDotazById(Integer id) throws SQLException {
        final String QUERY = """
                SELECT
                    d.id_dotaz, d.datum_podani, d.verejny, d.text, d.odpoved, d.id_odpovidajici_uzivatel,
                    u.email,
                    u.id_opravneni, op.nazev, op.uroven,
                    u.id_obrazek, o.nazev_souboru, o.data
                FROM
                    dotazy d
                LEFT JOIN
                    uzivatele u ON d.id_odpovidajici_uzivatel = u.id_uzivatel
                LEFT JOIN
                    obrazky o ON u.id_obrazek = o.id_obrazek
                LEFT JOIN
                    opravneni op ON u.id_opravneni = op.id_opravneni
                WHERE
                    d.id_dotaz = ?
                """;
        Connection c = dataSource.getConnection();
        PreparedStatement stmt = c.prepareStatement(QUERY);
        stmt.setInt(1, id);
        ResultSet rs = stmt.executeQuery();

        if (rs.next()) {
            int id_dotaz = rs.getInt("id_dotaz");
            OffsetDateTime datum_podani = rs.getTimestamp("datum_podani").toInstant().atZone(ZoneId.systemDefault()).toOffsetDateTime();
            boolean verejny = rs.getBoolean("verejny");
            String text = rs.getString("text");
            String odpoved = rs.getString("odpoved");

            Dotaz dotaz;
            if (!rs.wasNull()) {
                int id_uzivatel = rs.getInt("id_odpovidajici_uzivatel");
                String email = rs.getString("email");
                int id_opravneni = rs.getInt("id_opravneni");
                String nazev = rs.getString("nazev");
                int uroven = rs.getInt("uroven");
                int id_obrazek = rs.getInt("id_obrazek");
                String nazev_souboru = rs.getString("nazev_souboru");
                byte[] data = rs.getBytes("data");

                // neni potreba poskytovat dalsi data o uzivateli jako hash, sul, adresu atd...
                Uzivatel odpovidajiciUzivatel = new Uzivatel(id_uzivatel, email, null, null,
                        new Opravneni(id_opravneni, nazev, uroven),
                        new Obrazek(id_obrazek, nazev_souboru, data),
                        null
                );

                return Optional.of(new Dotaz(id_dotaz, datum_podani, verejny, text, odpoved, odpovidajiciUzivatel));
            } else {
                return Optional.of(new Dotaz(id_dotaz, datum_podani, verejny, text, odpoved, null));
            }

        } else {
            return Optional.empty();
        }
    }

}
