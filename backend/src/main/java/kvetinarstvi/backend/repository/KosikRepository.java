package kvetinarstvi.backend.repository;

import java.sql.*;
import java.time.OffsetDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import javax.sql.DataSource;

import kvetinarstvi.backend.records.StavObjednavky;
import kvetinarstvi.backend.records.Uzivatel;
import kvetinarstvi.backend.records.ZpusobPlatby;
import kvetinarstvi.backend.repository.enums.DeleteStatus;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kvetinarstvi.backend.records.Kosik;

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
                    k.id_zpusob_platby, zp.nazev as nazev_zpusob_objednavky
                FROM
                    kosiky k
                JOIN
                    uzivatele u ON k.id_uzivatel = u.id_uzivatel
                JOIN
                    adresy a ON u.id_adresa = a.id_adresa
                JOIN\s
                    mesta m ON a.id_mesto = m.id_mesto
                JOIN
                    ulice ul ON ul.id_ulice = a.id_ulice
                JOIN
                    psc p ON p.id_psc = a.id_psc
                JOIN
                    stavyobjednavek so ON so.id_stav_objednavky = k.id_stav_objednavky
                JOIN
                    zpusobyplateb zp ON zp.id_zpusob_platby = k.id_zpusob_platby;
                """;
        List<Kosik> kosiky = new ArrayList<>();

        Connection c = dataSource.getConnection();
        PreparedStatement stmt = c.prepareStatement(QUERY);
        ResultSet rs = stmt.executeQuery();

        while (rs.next()) {
            int id_kosik = rs.getInt("id_kosik");
            OffsetDateTime datum_vytvoreni;
            Double cena;
            Integer sleva;


            kosiky.add(new Kosik(id_kosik, datum_vytvoreni, cena, sleva, new Uzivatel(

            ), new StavObjednavky(

            ), new ZpusobPlatby(

            )));
        }

        return kosiky;
    }

    public Optional<Kosik> findKosikById(Integer id) throws SQLException {
        final String QUERY = "SELECT id_kosik, nazev FROM kosiky WHERE id_kosik = ?";

        Connection c = dataSource.getConnection();
        PreparedStatement stmt = c.prepareStatement(QUERY);
        stmt.setInt(1, id);

        ResultSet rs = stmt.executeQuery();

        if (rs.next()) {
            int id_kosik = rs.getInt("id_kosik");
            String nazev = rs.getString("nazev");

            return Optional.of(new Kosik(id_kosik, nazev));
        } else {
            return Optional.empty();
        }
    }
}
