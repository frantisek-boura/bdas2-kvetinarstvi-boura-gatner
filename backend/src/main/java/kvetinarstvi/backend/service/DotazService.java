package kvetinarstvi.backend.service;

import kvetinarstvi.backend.records.Dotaz;
import kvetinarstvi.backend.repository.DotazRepository;
import kvetinarstvi.backend.repository.Status;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.sql.DataSource;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Types;

@Service
public class DotazService {

    @Autowired
    private DataSource dataSource;

    @Autowired
    private DotazRepository repository;

    public Status<Dotaz> addDotaz(DotazRequest request) {
        final String QUERY = "{CALL PCK_ADMINISTRATIVA.PROC_PRIDEJ_DOTAZ(?, ?, ?, ?)}";

        try (Connection connection = dataSource.getConnection();
             CallableStatement cs = connection.prepareCall(QUERY)) {

            cs.setString(1, request.text());

            cs.registerOutParameter(2, Types.NUMERIC);
            cs.registerOutParameter(3, Types.NUMERIC);
            cs.registerOutParameter(4, Types.VARCHAR);

            cs.execute();

            int id_dotaz = cs.getInt(2);
            int status_code = cs.getInt(3);
            String status_message = cs.getString(4);

            if (status_code == 1) {
                Dotaz dotaz = repository.findById(id_dotaz).get();
                return new Status<>(status_code, status_message, dotaz);
            } else {
                return new Status<>(status_code, status_message, null);
            }
        } catch (SQLException e) {
            return new Status<>(-999, "Kritická chyba databáze: " + e.getMessage(), null);
        }
    }

    public Status<Dotaz> addOdpoved(OdpovedRequest request) {
        final String QUERY = "{CALL PCK_ADMINISTRATIVA.PROC_ODPOVED_NA_DOTAZ(?, ?, ?, ?, ?, ?)}";

        try (Connection connection = dataSource.getConnection();
             CallableStatement cs = connection.prepareCall(QUERY)) {

            cs.setInt(1, request.id_dotaz());
            cs.setInt(2, request.id_odpovidajici_uzivatel());
            cs.setString(3, request.odpoved());

            cs.registerOutParameter(4, Types.NUMERIC);
            cs.registerOutParameter(5, Types.NUMERIC);
            cs.registerOutParameter(6, Types.VARCHAR);
            cs.execute();

            int id_dotaz = cs.getInt(4);
            Dotaz dotaz = repository.findById(id_dotaz).get();

            return new Status<>(cs.getInt(5), cs.getString(6), dotaz);
        } catch (SQLException e) {
            return new Status<>(-999, "Kritická chyba databáze: " + e.getMessage(), null);
        }
    }

}
