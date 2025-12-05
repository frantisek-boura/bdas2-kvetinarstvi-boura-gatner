import axios from "axios";
import { useEffect, useState } from "react";
import { IP } from "../ApiURL";


const SysKatalogData = (props) => {

    return <li className="d-flex flex-row justify-content-between align-items-center list-group-item list-group-item-action">
        <p className="mx-2">{props.katalogEntry.tabulka}</p>
        <p className="mx-2">{props.katalogEntry.sloupec}</p>
        <p className="mx-2">{props.katalogEntry.datovy_typ}</p>
    </li>
}

export const SysKatalogPage = () => {

    const [data, setData] = useState([]);

    const fetchData = () => {
        axios.get(IP + "/syskatalog").then(response => setData(response.data));
    }

    useEffect(() => {
        fetchData();
    }, []);

    return <div className="d-flex flex-column flex-nowrap w-100 mx-5">
        <h1>Sys Katalog</h1>
        <ul className="list-group list-group-flush">
            <li className="d-flex flex-row justify-content-between list-group-item list-group-item-action w-100">
                <h5 className="mx-5">Tabulka</h5>
                <h5 className="mx-5">Sloupec</h5>
                <h5 className="mx-5">Datový typ</h5>
            </li>
            {data.map((m, i) => <SysKatalogData key={i} katalogEntry={m} />)}
        </ul>
    </div>
}