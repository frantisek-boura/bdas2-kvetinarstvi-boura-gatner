package kvetinarstvi.backend.controller;

import kvetinarstvi.backend.records.Kosik;
import kvetinarstvi.backend.repository.KosikRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.sql.SQLException;
import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/kosiky")
public class KosikController {

    @Autowired
    private KosikRepository repository;

//    @PostMapping("")
//    public ResponseEntity<Kosik> createKosik(@RequestBody KosikRequest request) {
//        try {
//            Kosik kosik = repository.createKosik(request);
//
//            return ResponseEntity.status(HttpStatus.CREATED).body(kosik);
//        } catch (SQLException e) {
//            return ResponseEntity.internalServerError().build();
//        }
//    }
//
//    @PutMapping("")
//    public ResponseEntity<Kosik> updateKosik(@RequestBody KosikRequest request) {
//        try {
//            Kosik kosik = repository.updateKosik(request);
//
//            return ResponseEntity.ok().body(kosik);
//        } catch (SQLException e) {
//            return ResponseEntity.internalServerError().build();
//        }
//    }
//
//    @DeleteMapping("/{id}")
//    public ResponseEntity<Void> deleteKosik(@PathVariable Integer id) {
//        try {
//            DeleteStatus status = repository.deleteKosik(id);
//
//            switch (status) {
//                case DeleteStatus.SUCCESS -> { return ResponseEntity.noContent().build(); }
//                case DeleteStatus.NOT_FOUND -> { return ResponseEntity.notFound().build(); }
//                case DeleteStatus.FAILURE -> { return ResponseEntity.internalServerError().build(); }
//            }
//            return ResponseEntity.internalServerError().build();
//        } catch (SQLException e) {
//            return ResponseEntity.internalServerError().build();
//        }
//    }

    @GetMapping("/historie-obj/{id}")
    public ResponseEntity<List<Kosik>> getHistorieObjednavky(@PathVariable Integer id) {
        // TODO:
        return null;
    }

    @GetMapping("/historie-obj-uz/{id}")
    public ResponseEntity<List<Kosik>> getHistorieObjednavekUzivatele(@PathVariable Integer id) {
        // TODO:
        return null;
    }

    @GetMapping("")
    public ResponseEntity<List<Kosik>> getAllKosiky() {
        try {
            List<Kosik> kosiky = repository.findAllKosiky();

            if (kosiky.isEmpty()) {
                return ResponseEntity.noContent().build();
            }

            return ResponseEntity.ok(kosiky);
        } catch (SQLException e) {
            return ResponseEntity.internalServerError().build();
        }
    }

    @GetMapping("/{id}")
    public ResponseEntity<Kosik> getKosikById(@PathVariable Integer id) {
        try {
            Optional<Kosik> kosik = repository.findKosikById(id);

            if (kosik.isEmpty()) {
                return ResponseEntity.notFound().build();
            }

            return ResponseEntity.ok(kosik.get());
        } catch (SQLException e) {
            return ResponseEntity.internalServerError().build();
        }
    }

}

