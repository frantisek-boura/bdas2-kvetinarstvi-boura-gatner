package kvetinarstvi.backend.repository;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import javax.sql.DataSource;

import kvetinarstvi.backend.records.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class UzivatelRepository {
    
    @Autowired
    private DataSource dataSource;

    public List<Uzivatel> findAllUzivatele() throws SQLException {
        final String QUERY = """
                SELECT
                    u.id_uzivatel, u.email, u.pw_hash, u.salt,
                    u.id_opravneni, op.nazev as nazev_opravneni, op.uroven,
                    u.id_obrazek, o.nazev_souboru, o.data,
                    u.id_adresa, a.cp,
                    a.id_ulice, ul.nazev as nazev_ulice,
                    a.id_psc, p.psc,
                    a.id_mesto, m.nazev as nazev_mesta
                FROM
                    uzivatele u
                JOIN
                    opravneni op ON op.id_opravneni = u.id_opravneni
                JOIN
                    obrazky o ON o.id_obrazek = u.id_obrazek
                JOIN
                    adresy a ON a.id_adresa = u.id_adresa
                JOIN
                    ulice ul ON ul.id_ulice = a.id_ulice
                JOIN
                    psc p ON p.id_psc = a.id_psc
                JOIN
                    mesta m ON m.id_mesto = a.id_mesto
                """;
        List<Uzivatel> uzivatele = new ArrayList<>();

        Connection c = dataSource.getConnection();
        PreparedStatement stmt = c.prepareStatement(QUERY);
        ResultSet rs = stmt.executeQuery();

        while (rs.next()) {
            int id_uzivatel = rs.getInt("id_uzivatel");
            String email = rs.getString("email");
            String pw_hash = rs.getString("pw_hash");
            String salt = rs.getString("salt");
            int id_opravneni = rs.getInt("id_opravneni");
            String nazev_opravneni = rs.getString("nazev_opravneni");
            int uroven = rs.getInt("uroven");
            int id_obrazek = rs.getInt("id_obrazek");
            String nazev_souboru = rs.getString("nazev_souboru");
            byte[] data = rs.getBytes("data");
            int id_adresa = rs.getInt("id_adresa");
            int cp = rs.getInt("cp");
            int id_ulice = rs.getInt("id_ulice");
            String nazev_ulice = rs.getString("nazev_ulice");
            int id_psc = rs.getInt("id_psc");
            String psc = rs.getString("psc");
            int id_mesto = rs.getInt("id_mesto");
            String nazev_mesta = rs.getString("nazev_mesta");

            Uzivatel uzivatel = new Uzivatel(
                    id_uzivatel,
                    email,
                    pw_hash,
                    salt,
                    new Opravneni(
                            id_opravneni,
                            nazev_opravneni,
                            uroven
                    ),
                    new Obrazek(
                            id_obrazek,
                            nazev_souboru,
                            data
                    ),
                    new Adresa(
                            id_adresa,
                            cp,
                            new Mesto(
                                    id_mesto,
                                    nazev_mesta
                            ),
                            new Ulice(
                                    id_ulice,
                                    nazev_ulice
                            ),
                            new PSC(
                                    id_psc,
                                    psc
                            )
                    )
            );

            uzivatele.add(uzivatel);
        }

        return uzivatele;
    }

    public Optional<Uzivatel> findUzivatelById(Integer id) throws SQLException {
        final String QUERY = """
                SELECT
                    u.id_uzivatel, u.email, u.pw_hash, u.salt,
                    u.id_opravneni, op.nazev as nazev_opravneni, op.uroven,
                    u.id_obrazek, o.nazev_souboru, o.data,
                    u.id_adresa, a.cp,
                    a.id_ulice, ul.nazev as nazev_ulice,
                    a.id_psc, p.psc,
                    a.id_mesto, m.nazev as nazev_mesta
                FROM
                    uzivatele u
                JOIN
                    opravneni op ON op.id_opravneni = u.id_opravneni
                JOIN
                    obrazky o ON o.id_obrazek = u.id_obrazek
                JOIN
                    adresy a ON a.id_adresa = u.id_adresa
                JOIN
                    ulice ul ON ul.id_ulice = a.id_ulice
                JOIN
                    psc p ON p.id_psc = a.id_psc
                JOIN
                    mesta m ON m.id_mesto = a.id_mesto
                WHERE
                    u.id_uzivatel = ?
                """;

        Connection c = dataSource.getConnection();
        PreparedStatement stmt = c.prepareStatement(QUERY);
        stmt.setInt(1, id);

        ResultSet rs = stmt.executeQuery();

        if (rs.next()) {
            int id_uzivatel = rs.getInt("id_uzivatel");
            String email = rs.getString("email");
            String pw_hash = rs.getString("pw_hash");
            String salt = rs.getString("salt");
            int id_opravneni = rs.getInt("id_opravneni");
            String nazev_opravneni = rs.getString("nazev_opravneni");
            int uroven = rs.getInt("uroven");
            int id_obrazek = rs.getInt("id_obrazek");
            String nazev_souboru = rs.getString("nazev_souboru");
            byte[] data = rs.getBytes("data");
            int id_adresa = rs.getInt("id_adresa");
            int cp = rs.getInt("cp");
            int id_ulice = rs.getInt("id_ulice");
            String nazev_ulice = rs.getString("nazev_ulice");
            int id_psc = rs.getInt("id_psc");
            String psc = rs.getString("psc");
            int id_mesto = rs.getInt("id_mesto");
            String nazev_mesta = rs.getString("nazev_mesta");

            return Optional.of(new Uzivatel(
                    id_uzivatel,
                    email,
                    pw_hash,
                    salt,
                    new Opravneni(
                            id_opravneni,
                            nazev_opravneni,
                            uroven
                    ),
                    new Obrazek(
                            id_obrazek,
                            nazev_souboru,
                            data
                    ),
                    new Adresa(
                            id_adresa,
                            cp,
                            new Mesto(
                                    id_mesto,
                                    nazev_mesta
                            ),
                            new Ulice(
                                    id_ulice,
                                    nazev_ulice
                            ),
                            new PSC(
                                    id_psc,
                                    psc
                            )
                    )
            ));
        } else {
            return Optional.empty();
        }
    }


}
