package kvetinarstvi.backend.controller;

import kvetinarstvi.backend.records.KvetinaKosik;
import kvetinarstvi.backend.repository.KvetinaKosikRepository;
import kvetinarstvi.backend.repository.Status;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.sql.SQLException;
import java.util.List;

@RestController
@RequestMapping("/api/kvetinykosiky")
public class KvetinaKosikController extends AbstractController<KvetinaKosik> {

    @Override
    @DeleteMapping("/{id}")
    protected ResponseEntity<Status<KvetinaKosik>> delete(Integer id) {
        return ResponseEntity.status(HttpStatus.NOT_FOUND).body(new Status<KvetinaKosik>(-999, "Chybný požadavek, použijte DELETE /api/kvetinykosiky/{id_kosik}/{id_kvetina}", null));
    }

    @Override
    @GetMapping("/{id}")
    protected ResponseEntity<KvetinaKosik> getById(Integer id) {
        return ResponseEntity.status(HttpStatus.NOT_FOUND).build();
    }

    @GetMapping("/kosik/{id_kosik}")
    public ResponseEntity<List<KvetinaKosik>> getByKosikId(@PathVariable Integer id_kosik) {
        try {
            KvetinaKosikRepository kkRepository = (KvetinaKosikRepository) super.repository;
            List<KvetinaKosik> items = kkRepository.findAllByKosikId(id_kosik);

            if (items.isEmpty()) {
                return ResponseEntity.noContent().build();
            }

            return ResponseEntity.ok(items);
        } catch (SQLException e) {
            return ResponseEntity.internalServerError().build();
        }
    }

    @DeleteMapping("/{id_kvetina}/{id_kosik}")
    public ResponseEntity<Status<KvetinaKosik>> deleteByIds(@PathVariable Integer id_kvetina, @PathVariable Integer id_kosik) {
        KvetinaKosikRepository kkRepository = (KvetinaKosikRepository) super.repository;
        Status<KvetinaKosik> status = kkRepository.deleteByIds(id_kosik, id_kvetina);

        if (status.status_code() == 1) {
            return ResponseEntity.status(HttpStatus.OK).body(status);
        } else if (status.status_code() == 0 || (status.status_code() <= -400 && status.status_code() >= -499)) {
            return ResponseEntity.badRequest().body(status);
        } else {
            return ResponseEntity.internalServerError().body(status);
        }
    }
}
