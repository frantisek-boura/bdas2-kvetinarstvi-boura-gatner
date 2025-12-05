import axios from "axios";
import { useEffect, useState } from "react";
import { IP } from "../ApiURL";
import { useModal } from "../components/ModalContext";

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

const LogData = (props) => {

    return <li className="d-flex flex-row justify-content-start align-items-center list-group-item list-group-item-action">
        <p className="mx-2">{props.log.nazev_tabulky}</p>
        <p className="mx-2">{props.log.akce}</p>
        <p className="mx-2">{formatISOToDatetimeLocal(props.log.datum_akce)}</p>
        {props.log.stary_zaznam != null ?
            <div className="mx-2 w-25 d-flex flex-column">
                <p className="my-2">Před: {props.log.novy_zaznam}</p>
                <p className="my-2">Po: {props.log.stary_zaznam}</p>
            </div>
            :
            <p className="mx-2 w-25">{props.log.novy_zaznam}</p>
        }
    </li>
}

export const LogsPage = () => {

    const [data, setData] = useState([]);

    const fetchData = () => {
        axios.get(IP + "/logs").then(response => setData(response.data));
    }

    useEffect(() => {
        fetchData();
    }, []);

    return <div className="d-flex flex-column flex-nowrap w-100 mx-5">
        <h1>Logs</h1>
        <ul className="list-group list-group-flush">
            <li className="d-flex flex-row justify-content-start list-group-item list-group-item-action w-100">
                <h5 className="mx-5">Název tabulky</h5>
                <h5 className="mx-5">Akce</h5>
                <h5 className="mx-5">Čas akce</h5>
                <h5 className="mx-5">Data</h5>
            </li>
            {data.map((m) => <LogData key={m.id_log} log={m} />)}
        </ul>
    </div>
}