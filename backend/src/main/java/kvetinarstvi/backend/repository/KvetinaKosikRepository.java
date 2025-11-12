package kvetinaKosikrstvi.backend.repository;

import kvetinarstvi.backend.records.KvetinaKosik;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import java.util.Optional;

@Service
public class KvetinaKosikRepository {

    @Autowired
    private DataSource dataSource;

    // V dobe podani objednavky tahame o kvetinach data z logu, protoze se ceny kvetin mohou menit, coz by ovlivnovalo
    // cenu starych objednavek
    public Optional<KvetinaKosik> findKvetinyKosikyByKosikId(Integer id) throws SQLException {
        final String QUERY = """
                """;

        Connection c = dataSource.getConnection();
        PreparedStatement stmt = c.prepareStatement(QUERY);
        stmt.setInt(1, id);

        ResultSet rs = stmt.executeQuery();

        if (rs.next()) {
            int id_kvetinaKosik = rs.getInt("id_kvetinaKosik");
            String nazev_kvetinyKosiky = rs.getString("nazev_kvetinyKosiky");
            double cena = rs.getDouble("cena");
            int id_kategorie = rs.getInt("id_kategorie");
            String nazev_kategorie = rs.getString("nazev_kategorie");
            int id_obrazek = rs.getInt("id_obrazek");
            String nazev_souboru = rs.getString("nazev_souboru");
            byte[] data = rs.getBytes("data");

            return Optional.of(
                    new KvetinaKosik(
                            id_kvetinaKosik, nazev_kvetinyKosiky, cena,
                            new Kategorie(id_kategorie, nazev_kategorie, null),
                            new Obrazek(id_obrazek, nazev_souboru, data)
                    )
            );
        } else {
            return Optional.empty();
        }
    }

}
