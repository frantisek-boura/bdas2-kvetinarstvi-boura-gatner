package kvetinarstvi.backend.repository;

import kvetinarstvi.backend.records.ZpusobPlatby;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Service
public class ZpusobPlatbyRepository {

    @Autowired
    private DataSource dataSource;

    public List<ZpusobPlatby> findAllZpusobyPlateb() throws SQLException {
        final String QUERY = "SELECT id_zpusob_platby, nazev FROM zpusobyplateb";
        List<ZpusobPlatby> zpusobyplateb = new ArrayList<>();

        Connection c = dataSource.getConnection();
        PreparedStatement stmt = c.prepareStatement(QUERY);
        ResultSet rs = stmt.executeQuery();

        while (rs.next()) {
            int id_zpusob_platby = rs.getInt("id_zpusob_platby");
            String nazev = rs.getString("nazev");

            zpusobyplateb.add(new ZpusobPlatby(id_zpusob_platby, nazev));
        }

        return zpusobyplateb;
    }

    public Optional<ZpusobPlatby> findZpusobPlatbyById(Integer id) throws SQLException {
        final String QUERY = "SELECT id_zpusob_platby, nazev FROM zpusobyplateb WHERE id_zpusob_platby = ?";

        Connection c = dataSource.getConnection();
        PreparedStatement stmt = c.prepareStatement(QUERY);
        stmt.setInt(1, id);

        ResultSet rs = stmt.executeQuery();

        if (rs.next()) {
            int id_zpusob_platby = rs.getInt("id_zpusob_platby");
            String nazev = rs.getString("nazev");

            return Optional.of(new ZpusobPlatby(id_zpusob_platby, nazev));
        } else {
            return Optional.empty();
        }
    }

}
