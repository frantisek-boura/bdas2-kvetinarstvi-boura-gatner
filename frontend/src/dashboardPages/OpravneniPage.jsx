import axios from "axios";
import { useEffect, useState } from "react";
import { IP } from "../ApiURL";
import { useModal } from "../components/ModalContext";

const OpravneniData = (props) => {

    const { showModal } = useModal();

    const [nazev, setNazev] = useState(props.nazev);
    const [uroven, setUroven] = useState(props.uroven_opravneni);

    const upravitData = () => {
        showModal({
            type: 'confirmation',
            heading: 'Upravit data',
            message: 'Opravdu chcete upravit data?',
            onConfirm: () => {
                axios.put(IP + "/opravneni",
                    {
                        id_opravneni: props.id_opravneni,
                        nazev: nazev,
                        uroven_opravneni: uroven
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
                    IP + "/opravneni/" + props.id_opravneni 
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
        <input type="text" className="form-control mx-2" onChange={(e) => setNazev(e.target.value)} defaultValue={props.nazev} />
        <input type="number" className="form-control mx-2" onChange={(e) => setUroven(Number(e.target.value))} defaultValue={props.uroven_opravneni} />
        <button onClick={upravitData} type="button" className="btn btn-primary mx-2">Upravit</button>
        <button onClick={smazatData} type="button" className="btn btn-danger mx-2">Smazat</button>
    </li>
}

export const OpravneniPage = () => {

    const { showModal } = useModal();

    const [data, setData] = useState([]);
    const [nazev, setNazev] = useState('');
    const [uroven, setUroven] = useState(0);

    const fetchData = () => {
        axios.get(IP + "/opravneni").then(response => setData(response.data));
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
                axios.post(IP + "/opravneni",
                    {
                        nazev: nazev,
                        uroven_opravneni: uroven 
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
                    setNazev('');
                    setUroven(0);
                    fetchData();
                })
            }
        });
    }

    return <div className="d-flex flex-column flex-nowrap w-100 mx-5">
        <h1>Oprávnění</h1>
        <ul className="list-group list-group-flush">
            <li className="d-flex flex-row justify-content-between list-group-item list-group-item-action w-100">
                <h5 className="mx-2">Vytvořit</h5>
            </li>
            <li className="d-flex flex-row justify-content-between list-group-item list-group-item-action w-100">
                <input type="text" className="form-control mx-2" onChange={e => setNazev(e.target.value)} value={nazev} />
                <input type="number" className="form-control mx-2" onChange={(e) => setUroven(Number(e.target.value))} value={uroven} />
                <button type="button" className="btn btn-primary mx-2" onClick={vytvoritData}>Vytvořit</button>
            </li>
            <li className="d-flex flex-row justify-content-between list-group-item list-group-item-action w-100">
                <h5 className="mx-2">Název</h5>
                <h5 className="mx-2">Úroveň oprávnění</h5>
                <h5 className="mx-2">Ovládání</h5>
            </li>
            {data.map((m) => <OpravneniData key={m.id_opravneni} id_opravneni={m.id_opravneni} nazev={m.nazev} uroven_opravneni={m.uroven_opravneni} onRefresh={fetchData}/>)}
        </ul>
    </div>
}