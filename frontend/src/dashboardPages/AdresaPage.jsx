import axios from "axios";
import { useEffect, useState } from "react";
import { IP } from "../ApiURL";
import { useModal } from "../components/ModalContext";

const AdresaData = (props) => {

    const { showModal } = useModal();

    const [cp, setcp] = useState(props.cp);
    const [idMesto, setIdMesto] = useState(props.id_mesto);
    const [idUlice, setIdUlice] = useState(props.id_ulice);
    const [idPsc, setIdPsc] = useState(props.id_psc);

    const upravitData = () => {
        showModal({
            type: 'confirmation',
            heading: 'Upravit data',
            message: 'Opravdu chcete upravit data?',
            onConfirm: () => {
                axios.put(IP + "/adresy",
                    {
                        id_adresa: props.id_adresa,
                        cp: cp,
                        id_mesto: idMesto,
                        id_ulice: idUlice,
                        id_psc: idPsc 
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
                    IP + "/adresy/" + props.id_adresa 
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
        <input type="number" className="form-control mx-2" onChange={e => setcp(e.target.value)} value={cp} />
        <select onChange={e => setIdMesto(e.target.value)} className="mx-2 form-select" aria-label="Města">
            {props.mestoData.map(m => {
                return (
                    <option selected={idMesto === m.id_mesto} value={Number(m.id_mesto)} key={m.id_mesto}>{m.nazev}</option>
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

export const AdresaPage = () => {

    const { showModal } = useModal();

    const [data, setData] = useState([]);
    const [mestoData, setMestoData] = useState([]);
    const [uliceData, setUliceData] = useState([]);
    const [pscData, setPscData] = useState([]);

    const [cp, setcp] = useState(0);
    const [idMesto, setIdMesto] = useState(1);
    const [idUlice, setIdUlice] = useState(1);
    const [idPsc, setIdPsc] = useState(1);

    const fetchData = () => {
        axios.get(IP + "/adresy").then(response => setData(response.data));
        axios.get(IP + "/mesta").then(response => setMestoData(response.data));
        axios.get(IP + "/ulice").then(response => setUliceData(response.data));
        axios.get(IP + "/psc").then(response => setPscData(response.data));
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
                axios.post(IP + "/adresy",
                    {
                        cp: cp,
                        id_mesto: idMesto,
                        id_ulice: idUlice,
                        id_psc: idPsc 
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
                    setcp('');
                    fetchData();
                })
            }
        });
    }

    return <div className="d-flex flex-column flex-nowrap w-100 mx-5">
        <h1>Adresy</h1>
        <ul className="list-group list-group-flush">
            <li className="d-flex flex-row justify-content-between list-group-item list-group-item-action w-100">
                <h5 className="mx-2">Vytvořit</h5>
            </li>
            <li className="d-flex flex-row justify-content-between list-group-item list-group-item-action w-100">
                <input type="number" className="form-control mx-2" onChange={e => setcp(e.target.value)} value={cp} />
                <select onChange={e => setIdMesto(e.target.value)} className="mx-2 form-select" aria-label="Města">
                    {mestoData.map(m => {
                        return (
                            <option key={m.id_mesto} value={Number(m.id_mesto)}>{m.nazev}</option>
                        )
                    })}
                </select>
                <select onChange={e => setIdUlice(e.target.value)} className="mx-2 form-select" aria-label="Ulice">
                    {uliceData.map(m => {
                        return (
                            <option key={m.id_ulice} value={Number(m.id_ulice)}>{m.nazev}</option>
                        )
                    })}
                </select>
                <select onChange={e => setIdPsc(e.target.value)} className="mx-2 form-select" aria-label="PSČ">
                    {pscData.map(m => {
                        return (
                            <option key={m.id_psc} value={Number(m.id_psc)}>{m.psc}</option>
                        )
                    })}
                </select>
                <button type="button" className="btn btn-primary mx-2" onClick={vytvoritData}>Vytvořit</button>
            </li>
            <li className="d-flex flex-row justify-content-between list-group-item list-group-item-action w-100">
                <h5 className="mx-2">Č.P.</h5>
                <h5 className="mx-2">Město</h5>
                <h5 className="mx-2">Ulice</h5>
                <h5 className="mx-2">PSČ</h5>
                <h5 className="mx-2">Ovládání</h5>
            </li>
            {data.map((m) => <AdresaData key={m.id_adresa} id_adresa={m.id_adresa} cp={m.cp} id_ulice={m.id_ulice} id_psc={m.id_psc} id_mesto={m.id_mesto} mestoData={mestoData} uliceData={uliceData} pscData={pscData} onRefresh={fetchData}/>)}
        </ul>
    </div>
}