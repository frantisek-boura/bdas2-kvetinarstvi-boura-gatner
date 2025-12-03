import axios from "axios";
import { useEffect, useState } from "react";
import { IP } from "../ApiURL";
import { useModal } from "../components/ModalContext";

const KvetinaData = (props) => {

    const { showModal } = useModal();

    const [nazev, setNazev] = useState(props.kvetina.nazev);
    const [cena, setCena] = useState(props.kvetina.cena);
    const [obrazek, setObrazek] = useState(props.kvetina.id_obrazek);
    const [kategorie, setKategorie] = useState(props.kvetina.id_kategorie);

    const upravitData = () => {
        showModal({
            type: 'confirmation',
            heading: 'Upravit data',
            message: 'Opravdu chcete upravit data?',
            onConfirm: () => {
                axios.put(IP + "/kvetiny", {
                    id_kvetina: props.kvetina.id_kvetina,
                    nazev: nazev,
                    cena: cena,
                    id_kategorie: kategorie,
                    id_obrazek: obrazek
                }).then(response => {
                    if (response.data.status_code == 1) {
                        showModal({
                            type: 'info',
                            heading: 'Úspěch',
                            message: response.data.status_message 
                        });
                        props.onRefresh();
                    } else {
                        showModal({
                            type: 'error',
                            heading: 'Chyba',
                            message: response.data.status_message 
                        });
                    }
                }).catch(error => {
                    showModal({
                        type: 'error',
                        heading: 'Chyba',
                        message: 'Server je nedostupný'
                    });
                });
            }
        });
    }

    const smazatData = () => {
        showModal({
            type: 'confirmation',
            heading: 'Smazat data',
            message: 'Opravdu chcete smazat data?',
            onConfirm: () => {
                axios.delete(
                    IP + "/kvetiny/" + props.kvetina.id_kvetina
                ).then(response => {
                    if (response.data.status_code == 1) {
                        showModal({
                            type: 'info',
                            heading: 'Úspěch',
                            message: response.data.status_message 
                        });
                        props.onRefresh();
                    } else {
                        showModal({
                            type: 'error',
                            heading: 'Chyba',
                            message: response.data.status_message 
                        });
                    }
                }).catch(error => {
                    showModal({
                        type: 'error',
                        heading: 'Chyba',
                        message: 'Server je nedostupný'
                    });
                })
            }
        });
    }

    return <li className="d-flex flex-row justify-content-between align-items-center list-group-item list-group-item-action w-100">
            <input type="text" className="form-control mx-2" onChange={(e) => setNazev(e.target.value)} value={nazev}/>
            <input type="number" min={0} className="form-control mx-2" onChange={(e) => setCena(Number(e.target.value))} value={cena} />
            <select onChange={e => setKategorie(e.target.value)} className="mx-2 form-select" aria-label="Kategorie">
                {props.kategorieData.map(m => {
                    return (
                        <option selected={m.id_kategorie === kategorie} key={m.id_kategorie} value={Number(m.id_kategorie)}>{m.nazev}</option>
                    )
                })}
            </select>
            <select onChange={e => setObrazek(e.target.value)} className="mx-2 form-select" aria-label="Obrázek">
                {props.obrazkyData.map(m => {
                    return (
                        <option selected={m.id_obrazek === obrazek} key={m.id_obrazek} value={Number(m.id_obrazek)}>{m.nazev_souboru}</option>
                    )
                })}
            </select>
        <div>
            <button type="button" className="btn btn-primary mx-2" onClick={upravitData}>Upravit</button>
            <button type="button" className="btn btn-danger mx-2" onClick={smazatData}>Smazat</button>
        </div>
    </li>
}

export const KvetinaPage = () => {

    const { showModal } = useModal();

    const [data, setData] = useState([]);
    const [obrazkyData, setObrazkyData] = useState([]);
    const [kategorieData, setKategorieData] = useState([]);

    const [nazev, setNazev] = useState('');
    const [cena, setCena] = useState(0);
    const [obrazek, setObrazek] = useState(1);
    const [kategorie, setKategorie] = useState(1);


    const fetchData = () => {
        let opravneni = [];

        axios.get(IP + "/kvetiny").then(response => setData(response.data));
        axios.get(IP + "/obrazky").then(response => setObrazkyData(response.data));
        axios.get(IP + "/kategorie").then(response => setKategorieData(response.data));
    }

    useEffect(() => {
        fetchData();
    }, []);

    const vytvoritData = () => {
        showModal({
            type: 'confirmation',
            heading: 'Vytvořit data',
            message: 'Opravdu chcete vytvořit data?',
            onConfirm: () => {
                axios.post(IP + "/kvetiny", {
                    nazev: nazev,
                    cena: cena,
                    id_kategorie: kategorie,
                    id_obrazek: obrazek
                }
                ).then(response => {
                    if (response.data.status_code == 1) {
                        showModal({
                            type: 'info',
                            heading: 'Úspěch',
                            message: response.data.status_message 
                        });
                    } else {
                        showModal({
                            type: 'error',
                            heading: 'Chyba',
                            message: response.data.status_message 
                        });
                    }
                }).catch(error => {
                    showModal({
                        type: 'error',
                        heading: 'Chyba',
                        message: 'Server je nedostupný'
                    });
                }).finally(() => {
                    fetchData();
                })
            }
        });
    }

    return <div className="d-flex flex-column flex-nowrap w-100 mx-5">
        <h1>Květiny</h1>
        <ul className="list-group list-group-flush">
            <li className="d-flex flex-row justify-content-between list-group-item list-group-item-action w-100">
                <h5 className="mx-2">Vytvořit</h5>
            </li>
            <li className="d-flex flex-row justify-content-between align-items-center list-group-item list-group-item-action w-100">
                <input type="text" className="form-control mx-2" onChange={(e) => setNazev(e.target.value)} />
                <input type="number" min={0} className="form-control mx-2" onChange={(e) => setCena(Number(e.target.value))} />
                <select onChange={e => setKategorie(e.target.value)} className="mx-2 form-select" aria-label="Kategorie">
                    {kategorieData.map(m => {
                        return (
                            <option selected={m.id_kategorie === kategorie} key={m.id_kategorie} value={Number(m.id_kategorie)}>{m.nazev}</option>
                        )
                    })}
                </select>
                <select onChange={e => setObrazek(e.target.value)} className="mx-2 form-select" aria-label="Obrázek">
                    {obrazkyData.map(m => {
                        return (
                            <option selected={m.id_obrazek === obrazek} key={m.id_obrazek} value={Number(m.id_obrazek)}>{m.nazev_souboru}</option>
                        )
                    })}
                </select>
                <button type="button" className="btn btn-primary mx-2" onClick={vytvoritData}>Vytvořit</button>
            </li>
            <li className="d-flex flex-row justify-content-between list-group-item list-group-item-action w-100">
                <h5 className="mx-2">Název</h5>
                <h5 className="mx-2">Cena</h5>
                <h5 className="mx-2">Kategorie</h5>
                <h5 className="mx-2">Obrázek</h5>
                <h5 className="mx-2">Ovládání</h5>
            </li>
            {data.map((m) => <KvetinaData key={m.id_kvetina} kvetina={m} kategorieData={kategorieData} obrazkyData={obrazkyData} onRefresh={fetchData}/>)}
        </ul>
    </div>
}