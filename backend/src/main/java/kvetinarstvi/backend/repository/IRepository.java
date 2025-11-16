package kvetinarstvi.backend.repository;

import java.sql.SQLException;
import java.util.List;
import java.util.Optional;

public interface IRepository<E> {

    Optional<E> findById(Integer ID) throws SQLException;
    List<E> findAll() throws SQLException;
    Status<E> insert(E e);
    Status<E> update(E e);
    Status<E> delete(Integer id);

}
