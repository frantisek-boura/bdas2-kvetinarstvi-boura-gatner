package kvetinarstvi.backend.service;

import kvetinarstvi.backend.records.Uzivatel;
import kvetinarstvi.backend.repository.Status;
import kvetinarstvi.backend.repository.UzivatelRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.sql.DataSource;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@Service
public class UzivatelService {

    @Autowired
    private DataSource dataSource;

    @Autowired
    private UzivatelRepository repository;

    public Status<Void> registerUzivatel(RegistraceRequest request) {
        final String QUERY = "{CALL PCK_HESLA.PROC_REGISTRUJ_UZIVATELE(?, ?, ?, ?, ?, ?, ?, ?, ?)}";

        try (Connection connection = dataSource.getConnection();
            CallableStatement cs = connection.prepareCall(QUERY)) {

            cs.setString(1, request.email());
            cs.setString(2, request.heslo());
            cs.setString(3, request.ulice());
            cs.setInt(4, request.cp());
            cs.setString(5, request.mesto());
            cs.setString(6, request.psc());

            cs.registerOutParameter(7, Types.NUMERIC);
            cs.registerOutParameter(8, Types.NUMERIC);
            cs.registerOutParameter(9, Types.VARCHAR);
            cs.execute();

            return new Status<>(cs.getInt(8), cs.getString(9), null);
        } catch (SQLException e) {
            return new Status<>(-999, "Kritická chyba databáze: " + e.getMessage(), null);
        }
    }

    public Status<Uzivatel> verifyUzivatel(LoginRequest request) {

        final String FUNCTION_CALL_QUERY = "{? = call PCK_HESLA.FUNC_OVER_HESLO(?, ?, ?)}";

        try (Connection connection = dataSource.getConnection();
             CallableStatement cs = connection.prepareCall(FUNCTION_CALL_QUERY)) {
            cs.registerOutParameter(1, Types.INTEGER);
            cs.setString(2, request.email());
            cs.setString(3, request.heslo());

            cs.registerOutParameter(4, Types.INTEGER);
            cs.execute();
            int loginStatus = cs.getInt(1);
            int userId = cs.getInt(4);

            if (loginStatus == -1) {
                return new Status<>(-1, "Přihlášení selhalo: E-mail nebyl nalezen", null);
            } else if (loginStatus == 0) {
                return new Status<>(0, "Přihlášení selhalo: Špatně zadané heslo", null);
            } else {
                Uzivatel uzivatel = repository.findById(userId).get();

                return new Status<>(1, "Přihlášení proběhlo úspěšně", uzivatel);
            }
        } catch (SQLException e) {
            return new Status<>(-999, "Kritická chyba databáze: " + e.getMessage(), null);
        }
    }

    public Status<String> changeHeslo(ZmenaHeslaRequest request) {
        String heslo = "";
        if (request.generovat_heslo()) {
            final String QUERY = "SELECT PCK_HESLA.FUNC_GENERUJ_HESLO() AS heslo FROM dual";

            try (Connection connection = dataSource.getConnection();
                CallableStatement cs = connection.prepareCall(QUERY)) {
                try (ResultSet rs = cs.executeQuery()) {
                    if (rs.next()) {
                        heslo = rs.getString("heslo");
                    } else {
                        return new Status<>(-999, "Chyba při změně hesla. Zkuste to později.", null);
                    }
                }

                return new Status<>(1, "Změna hesla proběhla úspěšně", heslo);
            } catch (SQLException e) {
                return new Status<>(-999, "Kritická chyba databáze: " + e.getMessage(), null);
            }
        } else {
            heslo = request.nove_heslo();

            final String QUERY = "{CALL PCK_HESLA.PROC_ZMEN_HESLO(?, ?)}";
            try (Connection connection = dataSource.getConnection();
                CallableStatement cs = connection.prepareCall(QUERY)) {
                cs.setInt(1, request.id_uzivatel());
                cs.setString(2, heslo);
                cs.execute();

                return new Status<>(1, "Změna hesla proběhla úspěšně", null);
            } catch (SQLException e) {
                return new Status<>(-999, "Kritická chyba databáze: " + e.getMessage(), null);
            }
        }
    }

    public List<UzivatelObjednavka> getObjednavky(Integer id) throws SQLException {
        List<UzivatelObjednavka> objednavky = new ArrayList<>();
        final String QUERY = """
                select * from view_objednavky_uzivatelu
                where id_uzivatel = ?
                order by id_kosik asc
                """;

        try (Connection c = dataSource.getConnection();
            PreparedStatement stmt = c.prepareStatement(QUERY)) {

            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                UzivatelObjednavka objednavka = null;
                while (rs.next()) {
                    int id_kvetina = rs.getInt("id_kvetina");
                    int id_kosik = rs.getInt("id_kosik");
                    double cena_za_kus = rs.getDouble("cena_za_kus");
                    int pocet = rs.getInt("pocet");
                    String nazev_kvetiny = rs.getString("nazev_kvetiny");
                    int id_obrazek = rs.getInt("id_obrazek");
                    int id_kategorie = rs.getInt("id_kategorie");
                    String nazev_souboru = rs.getString("nazev_souboru");
                    byte[] data = rs.getBytes("data");
                    String nazev_kategorie = rs.getString("nazev_kategorie");

                    if (objednavka == null) {
                        objednavka = new UzivatelObjednavka(id_kosik, new ArrayList<>());
                    }

                    if (objednavka.id_kosik() != id_kosik) {
                        objednavky.add(objednavka);
                        objednavka = new UzivatelObjednavka(id_kosik, new ArrayList<>());
                    }

                    objednavka.polozky().add(new UzivatelPolozka(
                            id_kvetina, cena_za_kus, pocet, nazev_kvetiny, id_obrazek, nazev_souboru, data, id_kategorie, nazev_kategorie
                    ));
                }
                if (objednavka != null) {
                    objednavky.add(objednavka);
                }
            }
        }

        return objednavky;
    }
}
