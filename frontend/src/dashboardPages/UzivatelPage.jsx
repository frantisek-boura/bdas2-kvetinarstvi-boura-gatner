import axios from "axios";
import { useEffect, useState } from "react";
import { IP } from "../ApiURL";
import { useModal } from "../components/ModalContext";

const UzivatelData = (props) => {

    const { showModal } = useModal();

    const [obrazek, setObrazek] = useState(props.id_obrazek);
    const [opravneni, setOpravneni] = useState(props.id_opravneni);
    const [adresa, setAdresa] = useState(props.id_adresa);

    const upravitData = () => {
        showModal({
            type: 'confirmation',
            heading: 'Upravit data',
            message: 'Opravdu chcete upravit data?',
            onConfirm: () => {
                axios.put(IP + "/uzivatele",
                    {
                        id_uzivatel: props.id_uzivatel,
                        email: props.id_email,
                        pw_hash: props.pw_hash,
                        salt: props.salt,
                        id_opravneni: opravneni,
                        id_obrazek: obrazek,
                        id_adresa: adresa  
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
                    IP + "/uzivatele/" + props.id_uzivatel 
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

    return <li className="d-flex flex-row justify-content-between list-group-item list-group-item-action w-100">
        <input type="text" className="form-control mx-2" onChange={e => setEmail(e.target.value)} value={cp} />
        <select onChange={e => setAdresa(e.target.value)} className="mx-2 form-select" aria-label="Města">
            {props.adresaData.map(m => {
                return (
                    <option selected={adresa === m.id_adresa} value={Number(m.id_adresa)} key={m.id_adresa}>{m.nazev}</option>
                )
            })}
        </select>
        <select onChange={e => setIdUlice(e.target.value)} className="mx-2 form-select" aria-label="Ulice">
            {props.uliceData.map(m => {
                return (
                    <option selected={idUlice === m.id_ulice} value={Number(m.id_ulice)} key={m.id_ulice}>{m.nazev}</option>
                )
            })}
        </select>
        <select onChange={e => setIdPsc(e.target.value)} className="mx-2 form-select" aria-label="PSČ">
            {props.pscData.map(m => {
                return (
                    <option selected={idPsc === m.id_psc} value={Number(m.id_psc)} key={m.id_psc}>{m.psc}</option>
                )
            })}
        </select>
        <button onClick={upravitData} type="button" className="btn btn-primary mx-2">Upravit</button>
        <button onClick={smazatData} type="button" className="btn btn-danger mx-2">Smazat</button>
    </li>
}

export const UzivatelPage = () => {

    const { showModal } = useModal();

    const [data, setData] = useState([]);
    const [adresyData, setAdresyData] = useState([]);
    const [opravneniData, setOpravneniData] = useState([]);
    const [obrazkyData, setObrazkyData] = useState([]);

    const [email, setEmail] = useState('');
    const [adresa, setAdresa] = useState(1);
    const [idAdresa, setIdAdresa] = useState(1);
    const [idOpravneni, setIdOpravneni] = useState(1);
    const [idObrazek, setIdObrazek] = useState(1);

    const fetchData = () => {
        axios.get(IP + "/uzivatele").then(response => setData(response.data));
        axios.get(IP + "/adresy/zkratky").then(response => setAdresyData(response.data));
        axios.get(IP + "/opravneni").then(response => setOpravneniData(response.data));
        axios.get(IP + "/obrazky").then(response => setObrazkyData(response.data));
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
                axios.post(IP + "/uzivatele",
                    {
                        email: email,
                        pw_hash: '',
                        salt: '',
                        id_opravneni: props.id_opravneni,
                        id_obrazek: props.id_obrazek,
                        id_adresa: props.id_adresa
                    }
                ).then(response => {
                    if (response.data.status_code == 1) {
                        showModal({
                            type: 'info',
                            heading: 'Úspěch',
                            message: response.data.status_message 
                        });
                        fetchData();
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
                    setcp('');
                    fetchData();
                })
            }
        });
    }

    return <div className="d-flex flex-column flex-nowrap w-100 mx-5">
        <h1>Uživatelé</h1>
        <ul className="list-group list-group-flush">
            <li className="d-flex flex-row justify-content-between list-group-item list-group-item-action w-100">
                <h5 className="mx-2">Vytvořit</h5>
            </li>
            <li className="d-flex flex-row justify-content-between list-group-item list-group-item-action w-100">
                <input type="text" className="form-control mx-2" onChange={e => setEmail(e.target.value)} value={email} />
                <select onChange={e => setIdAdresa(e.target.value)} className="mx-2 form-select" aria-label="Adresy">
                    {adresyData.map(m => {
                        return (
                            <option key={m.id_adresa} value={Number(m.id_adresa)}>{m.zkratka}</option>
                        )
                    })}
                </select>
                <select onChange={e => setIdOpravneni(e.target.value)} className="mx-2 form-select" aria-label="Oprávnění">
                    {opravneniData.map(m => {
                        return (
                            <option key={m.id_opravneni} value={Number(m.id_opravneni)}>{m.nazev}</option>
                        )
                    })}
                </select>
                <select onChange={e => setIdObrazek(e.target.value)} className="mx-2 form-select" aria-label="Obrázky">
                    {obrazkyData.map(m => {
                        return (
                            <option key={m.id_obrazek} value={Number(m.id_obrazek)}>{m.obrazek}</option>
                        )
                    })}
                </select>
                <button type="button" className="btn btn-primary mx-2" onClick={vytvoritData}>Vytvořit</button>
            </li>
            <li className="d-flex flex-row justify-content-between list-group-item list-group-item-action w-100">
                <h5 className="mx-2">E-mail</h5>
                <h5 className="mx-2">Adresa</h5>
                <h5 className="mx-2">Oprávnění</h5>
                <h5 className="mx-2">Obrázek</h5>
                <h5 className="mx-2">Ovládání</h5>
            </li>
            {data.map((m) => <UzivatelData key={m.id_uzivatel} uzivatel={m} id_adresa={m.id_adresa} id_obrazek={m.id_obrazek} id_opravneni={m.id_opravneni} adresyData={adresyData} obrazkyData={obrazkyData} opravneniData={opravneniData} onRefresh={fetchData}/>)}
        </ul>
    </div>
}