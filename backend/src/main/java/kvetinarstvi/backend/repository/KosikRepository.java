package kvetinarstvi.backend.repository;

import java.sql.*;
import java.time.OffsetDateTime;
import java.time.ZoneId;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import javax.sql.DataSource;

import kvetinarstvi.backend.records.*;
import kvetinarstvi.backend.repository.enums.DeleteStatus;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class KosikRepository {

    @Autowired
    private DataSource dataSource;

    public List<Kosik> findAllKosiky() throws SQLException {
        final String QUERY = """
                SELECT k.id_kosik, k.datum_vytvoreni, k.cena, k.sleva,
                    k.id_uzivatel, u.email,
                    u.id_adresa, a.cp,
                    a.id_mesto, m.nazev as nazev_mesta,
                    a.id_ulice, ul.nazev as nazev_ulice,
                    a.id_psc, p.psc,
                    k.id_stav_objednavky, so.nazev as nazev_stav_objednavky,
                    k.id_zpusob_platby, zp.nazev as nazev_zpusob_platby
                FROM
                    kosiky k
                JOIN
                    uzivatele u ON k.id_uzivatel = u.id_uzivatel
                JOIN
                    adresy a ON u.id_adresa = a.id_adresa
                JOIN
                    mesta m ON a.id_mesto = m.id_mesto
                JOIN
                    ulice ul ON ul.id_ulice = a.id_ulice
                JOIN
                    psc p ON p.id_psc = a.id_psc
                JOIN
                    stavyobjednavek so ON so.id_stav_objednavky = k.id_stav_objednavky
                JOIN
                    zpusobyplateb zp ON zp.id_zpusob_platby = k.id_zpusob_platby
                """;
        List<Kosik> kosiky = new ArrayList<>();

        Connection c = dataSource.getConnection();
        PreparedStatement stmt = c.prepareStatement(QUERY);
        ResultSet rs = stmt.executeQuery();

        while (rs.next()) {
            int id_kosik = rs.getInt("id_kosik");
            OffsetDateTime datum_vytvoreni = rs.getTimestamp("datum_vytvoreni").toInstant().atZone(ZoneId.systemDefault()).toOffsetDateTime();;
            Double cena = rs.getDouble("cena");
            int sleva = rs.getInt("sleva");
            int id_uzivatel = rs.getInt("id_uzivatel");
            String email = rs.getString("email");
            int id_adresa = rs.getInt("id_adresa");
            int cp = rs.getInt("cp");
            int id_mesto = rs.getInt("id_mesto");
            String nazev_mesta = rs.getString("nazev_mesta");
            int id_ulice = rs.getInt("id_ulice");
            String nazev_ulice = rs.getString("nazev_ulice");
            int id_psc = rs.getInt("id_psc");
            String psc = rs.getString("psc");
            int id_stav_objednavky = rs.getInt("id_stav_objednavky");
            String nazev_stav_objednavky = rs.getString("nazev_stav_objednavky");
            int id_zpusob_platby = rs.getInt("id_zpusob_platby");
            String nazev_zpusob_platby = rs.getString("nazev_zpusob_platby");

            kosiky.add(
                    new Kosik(
                            id_kosik, datum_vytvoreni, cena, sleva, new Uzivatel(
                            id_uzivatel, email, null, null, null, null,
                            new Adresa(
                                    id_adresa,
                                    cp,
                                    new Mesto(id_mesto, nazev_mesta),
                                    new Ulice(id_ulice, nazev_ulice),
                                    new PSC(id_psc, psc)
                            )
                    ), new StavObjednavky(
                            id_stav_objednavky,
                            nazev_stav_objednavky
                    ), new ZpusobPlatby(
                            id_zpusob_platby,
                            nazev_zpusob_platby
                    )));
        }

        return kosiky;
    }

    public Optional<Kosik> findKosikById(Integer id) throws SQLException {
        final String QUERY = """
                SELECT k.id_kosik, k.datum_vytvoreni, k.cena, k.sleva,
                    k.id_uzivatel, u.email,
                    u.id_adresa, a.cp,
                    a.id_mesto, m.nazev as nazev_mesta,
                    a.id_ulice, ul.nazev as nazev_ulice,
                    a.id_psc, p.psc,
                    k.id_stav_objednavky, so.nazev as nazev_stav_objednavky,
                    k.id_zpusob_platby, zp.nazev as nazev_zpusob_platby
                FROM
                    kosiky k
                JOIN
                    uzivatele u ON k.id_uzivatel = u.id_uzivatel
                JOIN
                    adresy a ON u.id_adresa = a.id_adresa
                JOIN
                    mesta m ON a.id_mesto = m.id_mesto
                JOIN
                    ulice ul ON ul.id_ulice = a.id_ulice
                JOIN
                    psc p ON p.id_psc = a.id_psc
                JOIN
                    stavyobjednavek so ON so.id_stav_objednavky = k.id_stav_objednavky
                JOIN
                    zpusobyplateb zp ON zp.id_zpusob_platby = k.id_zpusob_platby
                WHERE
                    k.id_uzivatel = ?
                """;

        Connection c = dataSource.getConnection();
        PreparedStatement stmt = c.prepareStatement(QUERY);
        stmt.setInt(1, id);

        ResultSet rs = stmt.executeQuery();

        if (rs.next()) {
            int id_kosik = rs.getInt("id_kosik");
            OffsetDateTime datum_vytvoreni = rs.getTimestamp("datum_vytvoreni").toInstant().atZone(ZoneId.systemDefault()).toOffsetDateTime();;
            Double cena = rs.getDouble("cena");
            int sleva = rs.getInt("sleva");
            int id_uzivatel = rs.getInt("id_uzivatel");
            String email = rs.getString("email");
            int id_adresa = rs.getInt("id_adresa");
            int cp = rs.getInt("cp");
            int id_mesto = rs.getInt("id_mesto");
            String nazev_mesta = rs.getString("nazev_mesta");
            int id_ulice = rs.getInt("id_ulice");
            String nazev_ulice = rs.getString("nazev_ulice");
            int id_psc = rs.getInt("id_psc");
            String psc = rs.getString("psc");
            int id_stav_objednavky = rs.getInt("id_stav_objednavky");
            String nazev_stav_objednavky = rs.getString("nazev_stav_objednavky");
            int id_zpusob_platby = rs.getInt("id_zpusob_platby");
            String nazev_zpusob_platby = rs.getString("nazev_zpusob_platby");


            return Optional.of(
                    new Kosik(
                            id_kosik, datum_vytvoreni, cena, sleva, new Uzivatel(
                            id_uzivatel, email, null, null, null, null,
                            new Adresa(
                                    id_adresa,
                                    cp,
                                    new Mesto(id_mesto, nazev_mesta),
                                    new Ulice(id_ulice, nazev_ulice),
                                    new PSC(id_psc, psc)
                            )
                    ), new StavObjednavky(
                            id_stav_objednavky,
                            nazev_stav_objednavky
                    ), new ZpusobPlatby(
                            id_zpusob_platby,
                            nazev_zpusob_platby
                    )));
        } else {
            return Optional.empty();
        }
    }
}
