import axios from "axios";
import { useEffect, useState } from "react";
import { IP } from "../ApiURL";
import { useModal } from "../components/ModalContext";

const DotazData = (props) => {

    const { showModal } = useModal();

    const [text, setText] = useState(props.dotaz.text);
    const [verejny, setVerejny] = useState(props.dotaz.verejny);
    const [odpoved, setOdpoved] = useState(props.dotaz.odpoved);
    const [odpovidajiciUzivatel, setOdpovidajiciUzivatel] = useState(props.dotaz.id_odpovidajici_uzivatel);

    const upravitData = () => {
        showModal({
            type: 'confirmation',
            heading: 'Upravit data',
            message: 'Opravdu chcete upravit data?',
            onConfirm: () => {
                axios.put(IP + "/dotazy", {
                    id_dotaz: props.dotaz.id_dotaz,
                    text: text,
                    verejny: verejny,
                    odpoved: odpoved,
                    id_odpovidajici_uzivatel: odpovidajiciUzivatel === '' ? null : odpovidajiciUzivatel
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
                    IP + "/dotazy/" + props.dotaz.id_dotaz
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
        <textarea className="form-control mx-2" onChange={(e) => setText(e.target.value)} value={text} />
        <input className="form-check-input mx-2" onChange={(e) => setVerejny(e.target.checked)} id="checkbox" type="checkbox" checked={verejny} />
        <label htmlFor="checkbox" className="mx-2">Veřejný</label>
        <textarea className="form-control mx-2" onChange={(e) => setOdpoved(e.target.value)} value={odpoved} />
        <select onChange={e => setOdpovidajiciUzivatel(e.target.value)} className="mx-2 form-select" aria-label="Odpovídající uživatel">
            {props.uzivateleData.map(m => {
                return (
                    <option selected={m.id_uzivatel === odpovidajiciUzivatel} key={m.id_uzivatel} value={Number(m.id_uzivatel)}>{m.email}</option>
                )
            })}
            <option value={''}>Žádný uživatel</option>
        </select>
        <div>
            <button type="button" className="btn btn-primary mx-2" onClick={upravitData}>Upravit</button>
            <button type="button" className="btn btn-danger mx-2" onClick={smazatData}>Smazat</button>
        </div>
    </li>
}

export const DotazPage = () => {

    const { showModal } = useModal();

    const [data, setData] = useState([]);
    const [uzivateleData, setUzivateleData] = useState([]);

    const [text, setText] = useState('');
    const [verejny, setVerejny] = useState(false);
    const [odpoved, setOdpoved] = useState('');
    const [odpovidajiciUzivatel, setOdpovidajiciUzivatel] = useState(1);

    const fetchData = () => {
        let opravneni = [];

        axios.get(IP + "/dotazy").then(response => setData(response.data));
        axios.get(IP + "/opravneni").then(response => {
            opravneni = response.data.filter(o => o.uroven_opravneni >= 1).map(o => o.id_opravneni);

            return axios.get(IP + "/uzivatele");
        }).then(response => {
            let uzivatele = response.data.filter(u => {
                return opravneni.includes(u.id_opravneni);
            });
            setUzivateleData(uzivatele);
        });
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
                axios.post(IP + "/dotazy", {
                    text: text,
                    verejny: verejny,
                    odpoved: odpoved,
                    id_odpovidajici_uzivatel: odpovidajiciUzivatel === '' ? null : odpovidajiciUzivatel
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
        <h1>Dotazy</h1>
        <ul className="list-group list-group-flush">
            <li className="d-flex flex-row justify-content-between list-group-item list-group-item-action w-100">
                <h5 className="mx-2">Vytvořit</h5>
            </li>
            <li className="d-flex flex-row justify-content-between align-items-center list-group-item list-group-item-action w-100">
                {/* <input type="text" className="form-control mx-2" onChange={e => setNazev(e.target.value)} value={nazev} /> */}
                <textarea className="form-control mx-2" onChange={(e) => setText(e.target.value)}></textarea>
                <input className="form-check-input mx-2" onChange={(e) => setVerejny(e.target.checked)} id="checkbox" type="checkbox" />
                <label htmlFor="checkbox" className="mx-2">Veřejný</label>
                <textarea className="form-control mx-2" onChange={(e) => setOdpoved(e.target.value)}></textarea>
                <select onChange={e => setOdpovidajiciUzivatel(e.target.value)} className="mx-2 form-select" aria-label="Odpovídající uživatel">
                    {uzivateleData.map(m => {
                        return (
                            <option selected={m.id_uzivatel === odpovidajiciUzivatel} key={m.id_uzivatel} value={Number(m.id_uzivatel)}>{m.email}</option>
                        )
                    })}
                    <option value={''}>Žádný uživatel</option>
                </select>
                <button type="button" className="btn btn-primary mx-2" onClick={vytvoritData}>Vytvořit</button>
            </li>
            <li className="d-flex flex-row justify-content-between list-group-item list-group-item-action w-100">
                <h5 className="mx-2">Text</h5>
                <h5 className="mx-2">Veřejný</h5>
                <h5 className="mx-2">Odpověď</h5>
                <h5 className="mx-2">Odpovídající uživatel</h5>
                <h5 className="mx-2">Ovládání</h5>
            </li>
            {data.map((m) => <DotazData key={m.id_dotaz} dotaz={m} uzivateleData={uzivateleData} onRefresh={fetchData}/>)}
        </ul>
    </div>
}