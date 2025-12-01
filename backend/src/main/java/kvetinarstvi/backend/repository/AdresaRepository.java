package kvetinarstvi.backend.repository;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import kvetinarstvi.backend.records.Adresa;
import kvetinarstvi.backend.records.Mesto;
import kvetinarstvi.backend.records.PSC;
import kvetinarstvi.backend.records.Ulice;

@Repository
public class AdresaRepository implements IRepository<Adresa> {

    @Autowired
    private DataSource dataSource;

    @Autowired
    private IRepository<Mesto> mestoRepository;
    @Autowired
    private IRepository<PSC> pscRepository;
    @Autowired
    private IRepository<Ulice> uliceRepository;

    public List<AdresaZkratka> findZkratky() throws SQLException {
        final String QUERY = "SELECT id_adresa, zkratka FROM  view_adresy_zkratky";

        List<AdresaZkratka> adresy = new ArrayList<>();

        try (Connection c = dataSource.getConnection();
             PreparedStatement stmt = c.prepareStatement(QUERY);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                int id_adresa = rs.getInt("id_adresa");
                String zkratka = rs.getString("zkratka");

                adresy.add(new AdresaZkratka(id_adresa, zkratka));
            }
        }

        return adresy;
    }

    @Override
    public List<Adresa> findAll() throws SQLException {
        final String QUERY = "SELECT id_adresa, cp, id_mesto, id_ulice, id_psc FROM ADRESY";

        List<Adresa> adresy = new ArrayList<>();

        try (Connection c = dataSource.getConnection();
             PreparedStatement stmt = c.prepareStatement(QUERY);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                int id_adresa = rs.getInt("id_adresa");
                int cp = rs.getInt("cp");
                int id_mesto = rs.getInt("id_mesto");
                int id_ulice = rs.getInt("id_ulice");
                int id_psc = rs.getInt("id_psc");

                adresy.add(new Adresa(id_adresa, cp, id_mesto, id_ulice, id_psc));
            }
        }

        return adresy;
    }

    @Override
    public Optional<Adresa> findById(Integer id) throws SQLException {
        final String QUERY = "SELECT id_adresa, cp, id_mesto, id_ulice, id_psc FROM ADRESY WHERE ID_ADRESA = ?";

        try (Connection c = dataSource.getConnection();
             PreparedStatement stmt = c.prepareStatement(QUERY)) {

            stmt.setInt(1, id);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    int id_adresa = rs.getInt("id_adresa");
                    int cp = rs.getInt("cp");
                    int id_mesto = rs.getInt("id_mesto");
                    int id_ulice = rs.getInt("id_ulice");
                    int id_psc = rs.getInt("id_psc");

                    return Optional.of(new Adresa(id_adresa, cp, id_mesto, id_ulice, id_psc));
                } else {
                    return Optional.empty();
                }
            }
        }
    }

    @Override
    public Status<Adresa> insert(Adresa adresaRequest) {
        final String QUERY = "{CALL PCK_ADRESY.PROC_INSERT_ADRESA(?, ?, ?, ?, ?, ?, ?)}";

        try (Connection c = dataSource.getConnection();
             CallableStatement stmt = c.prepareCall(QUERY)) {

            stmt.setInt(1, adresaRequest.cp());
            stmt.setInt(2, adresaRequest.id_mesto());
            stmt.setInt(3, adresaRequest.id_ulice());
            stmt.setInt(4, adresaRequest.id_psc());

            stmt.registerOutParameter(5, Types.INTEGER); // o_id_adresa
            stmt.registerOutParameter(6, Types.INTEGER); // o_status_code
            stmt.registerOutParameter(7, Types.VARCHAR); // o_status_message

            stmt.execute();

            int id_adresa = stmt.getInt(5);
            int status_code = stmt.getInt(6);
            String status_message = stmt.getString(7);

            if (status_code == 1) {
                try {
                    Adresa adresa = findById(id_adresa).get();
                    return new Status<>(status_code, status_message, adresa);
                } catch (SQLException e) {
                    return new Status<>(-998, "Chyba při dohledání vložené adresy: " + e.getMessage(), null);
                }
            } else {
                return new Status<>(status_code, status_message, null);
            }
        } catch (SQLException e) {
            return new Status<>(-999, "Kritická chyba databáze: " + e.getMessage(), null);
        }
    }

    @Override
    public Status<Adresa> update(Adresa adresaRequest) {
        final String QUERY = "{CALL PCK_ADRESY.PROC_UPDATE_ADRESA(?, ?, ?, ?, ?, ?, ?, ?)}";

        try (Connection c = dataSource.getConnection();
             CallableStatement stmt = c.prepareCall(QUERY)) {

            stmt.setInt(1, adresaRequest.id_adresa());
            stmt.setInt(2, adresaRequest.cp());
            stmt.setInt(3, adresaRequest.id_mesto());
            stmt.setInt(4, adresaRequest.id_ulice());
            stmt.setInt(5, adresaRequest.id_psc());

            stmt.registerOutParameter(6, Types.INTEGER);
            stmt.registerOutParameter(7, Types.INTEGER);
            stmt.registerOutParameter(8, Types.VARCHAR);

            stmt.execute();

            int id_adresa = stmt.getInt(6);
            int status_code = stmt.getInt(7);
            String status_message = stmt.getString(8);

            if (status_code == 1) {
                try {
                    Adresa adresa = findById(id_adresa).get();
                    return new Status<>(status_code, status_message, adresa);
                } catch (SQLException e) {
                    return new Status<>(-998, "Chyba při dohledání aktualizované adresy: " + e.getMessage(), null);
                }
            } else {
                return new Status<>(status_code, status_message, null);
            }
        } catch (SQLException e) {
            return new Status<>(-999, "Kritická chyba databáze: " + e.getMessage(), null);
        }
    }

    @Override
    public Status<Adresa> delete(Integer id) {
        final String QUERY = "{CALL PCK_ADRESY.PROC_DELETE_ADRESA(?, ?, ?)}";

        try (Connection c = dataSource.getConnection();
             CallableStatement stmt = c.prepareCall(QUERY)) {

            stmt.setInt(1, id);

            stmt.registerOutParameter(2, Types.INTEGER); // o_status_code
            stmt.registerOutParameter(3, Types.VARCHAR); // o_status_message

            stmt.execute();

            int status_code = stmt.getInt(2);
            String status_message = stmt.getString(3);

            return new Status<>(status_code, status_message, null);
        } catch (SQLException e) {
            return new Status<>(-999, "Kritická chyba databáze: " + e.getMessage(), null);
        }
    }
}