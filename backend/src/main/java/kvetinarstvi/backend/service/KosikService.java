package kvetinarstvi.backend.service;

import java.sql.*;
import java.util.List;

import kvetinarstvi.backend.records.Kosik;
import kvetinarstvi.backend.repository.KosikRepository;
import kvetinarstvi.backend.repository.Status;
import oracle.sql.ArrayDescriptor;
import oracle.sql.ARRAY;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.sql.DataSource;

@Service
public class KosikService {

    @Autowired
    private DataSource dataSource;

    @Autowired
    private KosikRepository repository;

    public KosikService(DataSource dataSource) {
        this.dataSource = dataSource;
    }

    public Status<Kosik> podatObjednavku(Integer id_uzivatel, Integer id_zpusob_platby, List<TKvetinaKosikRec> objednaneKvetiny) {
        final String procedureCall = "{CALL PCK_ADMINISTRATIVA.PROC_PODEJ_OBJEDNAVKU(?, ?, ?, ?)}";
        final String oracleTableType = "T_KVETINA_KOSIK_LIST";

        try (Connection connection = dataSource.getConnection();
            CallableStatement cs = connection.prepareCall(procedureCall)) {

            oracle.jdbc.OracleConnection oracleConnection = connection.unwrap(oracle.jdbc.OracleConnection.class);
            TKvetinaKosikRec[] recordsArray = objednaneKvetiny.toArray(new TKvetinaKosikRec[0]);
            ArrayDescriptor arrayDescriptor = ArrayDescriptor.createDescriptor(oracleTableType, oracleConnection);
            ARRAY inputArray = new ARRAY(arrayDescriptor, oracleConnection, recordsArray);


            cs.setInt(1, id_uzivatel);
            cs.setInt(2, id_zpusob_platby);
            cs.setArray(3, inputArray);

            cs.registerOutParameter(4, Types.NUMERIC);

            cs.execute();
            int id_kosik = cs.getInt(4);

            Kosik kosik = repository.findById(id_kosik).get();

            return new Status<>(1, "Úspěch: Objednávka úspěšně podána", kosik);
        } catch (SQLException e) {
            return new Status<>(-999, "Kritická chyba databáze: " + e.getMessage(), null);
        }
    }
}