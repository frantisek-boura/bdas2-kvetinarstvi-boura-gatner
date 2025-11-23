package kvetinarstvi.backend.service;

import kvetinarstvi.backend.records.Kvetina;
import kvetinarstvi.backend.repository.KvetinaRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

@Service
public class KvetinaService {

    @Autowired
    private DataSource dataSource;

    @Autowired
    private KvetinaRepository repository;

    public List<Kvetina> getKvetinyPodleKategorie(Integer id) throws SQLException {
        List<Kvetina> vsechnyKvetiny = repository.findAll();

        List<Kvetina> kvetiny = new ArrayList<>();
        final String QUERY = """
                SELECT DISTINCT
                    id_kategorie,
                    id_kvetina
                FROM
                    VIEW_KATEGORIE_PODSTROM_KVETIN
                WHERE
                    ID_KATEGORIE IN (
                        SELECT
                            ID_KATEGORIE
                        FROM
                            KATEGORIE
                        START WITH
                            ID_KATEGORIE = ?
                        CONNECT BY
                            PRIOR ID_KATEGORIE = ID_NADRAZENE_KATEGORIE
                    )
                """;

        try (Connection c = dataSource.getConnection();
             PreparedStatement stmt = c.prepareStatement(QUERY);
        ) {
            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    int id_kategorie = rs.getInt("id_kategorie");
                    int id_kvetina = rs.getInt("id_kvetina");

                    kvetiny.add(vsechnyKvetiny.stream().filter(k -> k.id_kvetina() == id_kvetina).findFirst().get());
                }
            }

        }

        return kvetiny;
    }
}
