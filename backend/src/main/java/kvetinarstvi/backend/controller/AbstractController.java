package kvetinarstvi.backend.controller;

import kvetinarstvi.backend.repository.IRepository;
import kvetinarstvi.backend.repository.Status;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.sql.SQLException;
import java.util.List;
import java.util.Optional;

public abstract class AbstractController<E> {

    @Autowired
    protected IRepository<E> repository;

    @PostMapping("")
    protected ResponseEntity<Status<E>> insert(@RequestBody E request) {
        Status<E> status = repository.insert(request);

        if (status.status_code() == 1) {
            return ResponseEntity.status(HttpStatus.CREATED).body(status);
        } else if (status.status_code() == 0 || (status.status_code() <= -400 && status.status_code() >= -499)) {
            return ResponseEntity.badRequest().body(status);
        } else {
            return ResponseEntity.internalServerError().body(status);
        }
    }

    @PutMapping("")
    protected ResponseEntity<Status<E>> update(@RequestBody E request) {
        Status<E> status = repository.update(request);

        if (status.status_code() == 1) {
            return ResponseEntity.status(HttpStatus.OK).body(status);
        } else if (status.status_code() == 0 || (status.status_code() <= -400 && status.status_code() >= -499)) {
            return ResponseEntity.badRequest().body(status);
        } else {
            return ResponseEntity.internalServerError().body(status);
        }
    }

    @DeleteMapping("/{id}")
    protected ResponseEntity<Status<E>> delete(@PathVariable Integer id) {
        Status<E> status = repository.delete(id);

        if (status.status_code() == 1) {
            return ResponseEntity.status(HttpStatus.OK).body(status);
        } else if (status.status_code() == 0 || (status.status_code() <= -400 && status.status_code() >= -499)) {
            return ResponseEntity.badRequest().body(status);
        } else {
            return ResponseEntity.internalServerError().body(status);
        }
    }

    @GetMapping("")
    protected ResponseEntity<List<E>> getAll() {
        try {
            List<E> items = repository.findAll();

            if (items.isEmpty()) {
                return ResponseEntity.noContent().build();
            }

            return ResponseEntity.ok(items);
        } catch (SQLException e) {
            return ResponseEntity.internalServerError().build();
        }
    }

    @GetMapping("/{id}")
    protected ResponseEntity<E> getById(@PathVariable Integer id) {
        try {
            Optional<E> item = repository.findById(id);

            if (item.isEmpty()) {
                return ResponseEntity.notFound().build();
            }

            return ResponseEntity.ok(item.get());
        } catch (SQLException e) {
            return ResponseEntity.internalServerError().build();
        }
    }
}
