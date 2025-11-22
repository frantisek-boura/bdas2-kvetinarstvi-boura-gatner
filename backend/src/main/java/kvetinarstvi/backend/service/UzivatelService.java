package kvetinarstvi.backend.service;

import kvetinarstvi.backend.records.Uzivatel;
import kvetinarstvi.backend.repository.Status;
import kvetinarstvi.backend.repository.UzivatelRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.sql.DataSource;
import java.sql.*;

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

    public Status<Void> verifyUzivatel(LoginRequest request) {
        final String QUERY = "SELECT PCK_HESLA.FUNC_OVER_HESLO(?, ?) AS vysledek FROM dual";

        try (Connection connection = dataSource.getConnection();
            CallableStatement cs = connection.prepareCall(QUERY)) {

            cs.setString(1, request.email());
            cs.setString(2, request.heslo());

            int vysledek = -1;
            try (ResultSet rs = cs.executeQuery()) {
                if (rs.next()) {
                    vysledek = rs.getInt("vysledek");
                }
            }

            if (vysledek == -1) {
                return new Status<>(-1, "Přihlášení selhalo: E-mail nebyl nalezen", null);
            } else if (vysledek == 0) {
                return new Status<>(0, "Přihlášení selhalo: Špatně zadané heslo", null);
            } else {
                return new Status<>(1, "Přihlášení proběhlo úspěšně", null);
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

}
