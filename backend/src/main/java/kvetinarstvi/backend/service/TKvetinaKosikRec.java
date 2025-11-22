package kvetinarstvi.backend.service;

import java.sql.SQLData;
import java.sql.SQLException;
import java.sql.SQLInput;
import java.sql.SQLOutput;

public class TKvetinaKosikRec implements SQLData {

    public static final String SQL_TYPE = "T_KVETINA_KOSIK_REC";

    private Long id_kvetina;
    private Integer pocet;

    @Override
    public String getSQLTypeName() throws SQLException {
        return SQL_TYPE;
    }

    @Override
    public void readSQL(SQLInput stream, String typeName) throws SQLException {
        id_kvetina = stream.readLong();
        pocet = stream.readInt();
    }

    @Override
    public void writeSQL(SQLOutput stream) throws SQLException {
        stream.writeLong(id_kvetina);
        stream.writeInt(pocet);
    }

    public TKvetinaKosikRec() { }

    public TKvetinaKosikRec(Long id_kvetina, Integer pocet) {
        this.id_kvetina = id_kvetina;
        this.pocet = pocet;
    }

    public Long getId_kvetina() {
        return id_kvetina;
    }

    public void setId_kvetina(Long id_kvetina) {
        this.id_kvetina = id_kvetina;
    }

    public Integer getPocet() {
        return pocet;
    }

    public void setPocet(Integer pocet) {
        this.pocet = pocet;
    }
}