package kvetinarstvi.backend.repository;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kvetinarstvi.backend.records.PSC;

@Service
public class PSCRepository {
    
    @Autowired
    private DataSource dataSource;

    public List<PSC> findAllPSC() throws SQLException {
        final String QUERY = "SELECT id_psc, psc FROM psc";
        List<PSC> pscs = new ArrayList<>();

        Connection c = dataSource.getConnection();
        PreparedStatement stmt = c.prepareStatement(QUERY);        
        ResultSet rs = stmt.executeQuery();

        while (rs.next()) {
            int id_psc = rs.getInt("id_psc");
            String psc = rs.getString("psc");

            pscs.add(new PSC(id_psc, psc));
        } 

        return pscs;
    }

    public Optional<PSC> findPSCById(Integer id) throws SQLException {
        final String QUERY = "SELECT id_psc, psc FROM psc WHERE id_psc = ?";

        Connection c = dataSource.getConnection();
        PreparedStatement stmt = c.prepareStatement(QUERY);        
        stmt.setInt(1, id);

        ResultSet rs = stmt.executeQuery();

        if (rs.next()) {
            int id_psc = rs.getInt("id_psc");
            String psc = rs.getString("psc");

            return Optional.of(new PSC(id_psc, psc));
        } else {
            return Optional.empty();
        }
    }

}
