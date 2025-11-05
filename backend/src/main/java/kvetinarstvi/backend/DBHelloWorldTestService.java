package kvetinarstvi.backend;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;

import javax.sql.DataSource;

import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

@Component
public class DBHelloWorldTestService implements CommandLineRunner {

    private final DataSource dataSource;

    public DBHelloWorldTestService(DataSource dataSource) {
        this.dataSource = dataSource;
    }

    @Override
    public void run(String... args) throws Exception {
        try (Connection c = dataSource.getConnection())  {
            Statement stmt = c.createStatement();        
            ResultSet rs = stmt.executeQuery("SELECT 'Hello World' FROM dual");

            if (rs.next()) {
                String result = rs.getString(1);
                System.out.println("Success!");
                System.out.println(result);
            } else {
                System.out.println("Connection success, dual returned zero rows");
            }
        } catch (Exception e) {
            System.out.println("Connection failure");    
        }
    }



}
