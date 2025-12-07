import axios from "axios";
import { useEffect, useState } from "react";
import { IP } from "../ApiURL";
import { useModal } from "../components/ModalContext";


const convertBase64ToSrc = (nazev_souboru, base64) => {
    const mimeTypeMap = {
        'png': 'image/png',
        'jpg': 'image/jpeg',
        'jpeg': 'image/jpeg',
        'gif': 'image/gif',
        'svg': 'image/svg+xml',
        'webp': 'image/webp',
        'bmp': 'image/bmp',
        'ico': 'image/x-icon'
    };

    const parts = nazev_souboru.toLowerCase().split('.');
    const extension = parts.pop();

    const mimeType = mimeTypeMap[extension];

    return `data:${mimeType};base64,` + base64;
}

const formatISOToDatetimeLocal = (isoString) => {
    const date = new Date(isoString);
    const pad = (num) => String(num).padStart(2, '0');
    const year = date.getFullYear();
    const month = pad(date.getMonth() + 1);
    const day = pad(date.getDate()); 
    const hours = pad(date.getHours());
    const minutes = pad(date.getMinutes());

    return `${year}-${month}-${day}T${hours}:${minutes}`;
}

const KosikData = (props) => {

    const { showModal } = useModal();

    const [polozky, setPolozky] = useState([]);

    const [stavObjednavky, setStavObjednavky] = useState(props.kosik.id_stav_objednavky);

    const upravitStavObjednavky = () => {
        showModal({
            type: 'confirmation',
            heading: 'Smazat data',
            message: 'Opravdu chcete upravit data?',
            onConfirm: () => {
                axios.put(
                    IP + "/kosiky", {
                        id_kosik: props.kosik.id_kosik,
                        datum_vytvoreni: props.datum_vytvoreni,
                        cena: props.kosik.cena,
                        sleva: props.kosik.sleva,
                        id_uzivatel: props.kosik.id_uzivatel,
                        id_stav_objednavky: stavObjednavky,
                        id_zpusob_platby: props.kosik.id_zpusob_platby
                    }
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

    useEffect(() => {
        axios.get(IP + "/kosiky/polozky/" + props.kosik.id_kosik).then(response => {
            setPolozky(response.data);
        });
    }, []);

    if (props.uzivateleData.length == 0) return;


    return <li className="d-flex flex-row justify-content-between align-items-center list-group-item list-group-item-action w-100">
        <div className="d-flex flex-column w-100">
            <div className="d-flex flex-row w-100 justify-content-between">
                <p>{props.kosik.id_kosik}</p>
                <div className="w-25 d-flex flex-column mx-2">
                    <p>{formatISOToDatetimeLocal(props.kosik.datum_vytvoreni)}</p>
                    <p>{props.kosik.cena} Kč</p>
                    <p>{props.kosik.sleva} % sleva</p>
                </div>
                <div className="w-25 d-flex flex-column mx-2">
                    <p>{props.uzivateleData.filter(u => u.id_uzivatel == props.kosik.id_uzivatel)[0].email}</p>
                    <select onChange={e => setStavObjednavky(e.target.value)} className="form-select" aria-label="Stav objednávky">
                        {props.stavyObjednavekData.map(m => {
                            return (
                                <option selected={stavObjednavky === m.id_stav_objednavky} value={Number(m.id_stav_objednavky)} key={m.id_stav_objednavky}>{m.nazev}</option>
                            )
                        })}
                    </select>
                    <p>{props.zpusobyPlatebData.filter(u => u.id_zpusob_platby == props.kosik.id_zpusob_platby)[0].nazev}</p>
                </div>
            </div>
            <ul className="list-group list-group-flush">
                {polozky.map(p => {
                    return <li className="d-flex flex-row justify-content-between align-items-center list-group-item list-group-item-action w-100">
                        <img src={convertBase64ToSrc(p.nazev_souboru, p.data)} className='img img-thumbnail' style={{height: '4em', width: '4em'}} />
                        <p>{p.nazev}</p>
                        <p>{p.nazev_kategorie}</p>
                        <p>{p.cena_za_kus} Kč</p>
                        <p>{p.pocet} x</p>
                    </li>
                })}
            </ul>
            <button className="btn btn-primary mx-2" onClick={upravitStavObjednavky} disabled={stavObjednavky == null}>Upravit stav objednávky</button>
        </div>
    </li>
}

export const KosikPage = () => {

    const [data, setData] = useState([]);
    const [uzivateleData, setUzivateleData] = useState([]);
    const [stavyObjednavekData, setStavyObjednavekData] = useState([]);
    const [zpusobyPlatebData, setZpusobyPlatebData] = useState([]);

    const fetchData = () => {
        axios.get(IP + "/kosiky").then(response => setData(response.data));
        axios.get(IP + "/uzivatele").then(response => setUzivateleData(response.data));
        axios.get(IP + "/stavyobjednavek").then(response => setStavyObjednavekData(response.data));
        axios.get(IP + "/zpusobyplateb").then(response => setZpusobyPlatebData(response.data));
    }

    useEffect(() => {
        if (data.length !== 0) return;

        fetchData();
    }, []);

    return <div className="d-flex flex-column flex-nowrap w-100 mx-5">
        <h1>Košíky</h1>
        <ul className="list-group list-group-flush">
            <li className="d-flex flex-row justify-content-between list-group-item list-group-item-action w-100">
                <h5 className="mx-2">Číslo objednávky</h5>
                <div>
                    <h5 className="mx-2">Datum vytvoření</h5>
                    <h5 className="mx-2">Cena</h5>
                    <h5 className="mx-2">Sleva</h5>
                </div>
                <div>
                    <h5 className="mx-2">Uživatel</h5>
                    <h5 className="mx-2">Stav objednávky</h5>
                    <h5 className="mx-2">Způsob platby</h5>
                </div>
            </li>
            <li className="d-flex flex-row justify-content-between list-group-item list-group-item-action w-100">
                <h5 className="mx-2">Náhled květiny</h5>
                <h5 className="mx-2">Název</h5>
                <h5 className="mx-2">Kategorie</h5>
                <h5 className="mx-2">Cena</h5>
                <h5 className="mx-2">Počet</h5>
            </li>
            {data.map((m) => <KosikData key={m.id_kosik} kosik={m} uzivateleData={uzivateleData} stavyObjednavekData={stavyObjednavekData} zpusobyPlatebData={zpusobyPlatebData} onRefresh={fetchData}/>)}
        </ul>
    </div>
}