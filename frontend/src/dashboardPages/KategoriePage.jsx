import axios from "axios";
import { useEffect, useState } from "react";
import { IP } from "../ApiURL";
import { useModal } from "../components/ModalContext";

const KategorieData = (props) => {

    const { showModal } = useModal();

    const [nazev, setNazev] = useState(props.nazev);
    const [idNadrazena, setIdNadrazena] = useState(props.id_nadrazene_kategorie);

    console.log(props.id_nadrazene_kategorie)

    const upravitData = () => {
        console.log(props.id_kategorie, nazev, idNadrazena);

        showModal({
            type: 'confirmation',
            heading: 'Upravit data',
            message: 'Opravdu chcete upravit data?',
            onConfirm: () => {
                axios.put(IP + "/kategorie",
                    {
                        id_kategorie: props.id_kategorie,
                        nazev: nazev,
                        id_nadrazene_kategorie: idNadrazena
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
                    IP + "/kategorie/" + props.id_kategorie 
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
        <input type="text" className="form-control mx-2" onChange={e => setNazev(e.target.value)} value={nazev} />
        {
            props.id_nadrazene_kategorie !== null ?
            <select onChange={e => setIdNadrazena(e.target.value)} className="mx-2 form-select" aria-label="Nadřazená kategorie">
                {props.kategorieData.map(m => {
                    return (
                        <option selected={idNadrazena === m.id_kategorie} value={Number(m.id_kategorie)} key={m.id_kategorie}>{m.nazev}</option>
                    )
                })}
            </select>
            :
            <select onChange={e => setIdNadrazena(e.target.value)} className="mx-2 form-select" aria-label="Nadřazená kategorie">
                <option>Nemá nadřazenou kategorii</option>
            </select>
        }
        <button onClick={upravitData} type="button" className="btn btn-primary mx-2">Upravit</button>
        <button onClick={smazatData} type="button" className="btn btn-danger mx-2">Smazat</button>
    </li>
}

export const KategoriePage = () => {

    const { showModal } = useModal();

    const [data, setData] = useState([]);

    const [nazev, setNazev] = useState('');
    const [idNadrazena, setIdNadrazena] = useState(null);

    const fetchData = () => {
        axios.get(IP + "/kategorie").then(response => setData(response.data));
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
                axios.post(IP + "/kategorie",
                    {
                        nazev: nazev,
                        id_nadrazene_kategorie: idNadrazena
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
                    setIdNadrazena(null);
                    fetchData();
                })
            }
        });
    }

    return <div className="d-flex flex-column flex-nowrap w-100 mx-5">
        <h1>kategorie</h1>
        <ul className="list-group list-group-flush">
            <li className="d-flex flex-row justify-content-between list-group-item list-group-item-action w-100">
                <h5 className="mx-2">Vytvořit</h5>
            </li>
            <li className="d-flex flex-row justify-content-between list-group-item list-group-item-action w-100">
                <input type="text" className="form-control mx-2" onChange={e => setNazev(e.target.value)} value={nazev} />
                <select onChange={e => setIdNadrazena(e.target.value)} className="mx-2 form-select" aria-label="Nadřazená kategorie">
                    {data.map(m => {
                        return (
                            <option key={m.id_kategorie} value={Number(m.id_kategorie)}>{m.nazev}</option>
                        )
                    })}
                    <option value={null}>Žádná</option>
                </select>
                <button type="button" className="btn btn-primary mx-2" onClick={vytvoritData}>Vytvořit</button>
            </li>
            <li className="d-flex flex-row justify-content-between list-group-item list-group-item-action w-100">
                <h5 className="mx-2">Název</h5>
                <h5 className="mx-2">Nadřazená kategorie</h5>
                <h5 className="mx-2">Ovládání</h5>
            </li>
            {data.map((m) => <KategorieData key={m.id_kategorie} id_kategorie={m.id_kategorie} nazev={m.nazev} id_nadrazene_kategorie={m.id_nadrazene_kategorie} kategorieData={data} onRefresh={fetchData}/>)}
        </ul>
    </div>
}