package kvetinarstvi.backend.service;

import java.util.List;

public record ObjednavkaRequest(Integer id_uzivatel, Integer id_zpusob_platby, List<TKvetinaKosikRec> objednaneKvetiny) {
}
