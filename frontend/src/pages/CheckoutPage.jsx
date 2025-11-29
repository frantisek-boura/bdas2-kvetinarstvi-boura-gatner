import React, { useEffect, useState } from 'react'
import { useCheckout } from '../components/CheckoutContext';
import { useAuth } from '../components/AuthContext';
import axios from 'axios';
import { IP } from '../ApiURL';
import { useProducts } from '../components/ProductsContext';
import { useNavigate } from 'react-router-dom';
import { useModal } from '../components/ModalContext';

export default function CheckoutPage() {

    const navigateHome = useNavigate();

    const { showModal } = useModal()
    const { user, isAuthenticated } = useAuth();
    const { items, addItem, removeItem, countItems, clearKosik } = useCheckout();
    const { products, images, categories, defaults } = useProducts();

    const [kvetiny, setKvetiny] = useState([]);
    const [zpusobyPlatby, setZpusobyPlatby] = useState([]);
    const [zpusobPlatby, setZpusobPlatby] = useState(null);

    const [cena, setCena] = useState(null);

    useEffect(() => {
        if (products.length == 0 || items.length == 0 || user == null || !isAuthenticated) {
            return;
        }

        axios.get(IP + "/kvetiny")
        .then(response => {
            setKvetiny(response.data);
            defaults();
            return axios.get(IP + "/zpusobyplateb");
        }).then(response => {
            setZpusobyPlatby(response.data);
        }).finally(() => {
            let cena = 0;
            items.forEach(i => {
                cena += i.pocet * products.filter(k => k.id_kvetina == i.id_kvetina)[0].cena;
            });

            setCena(cena);
        });

    }, [products, items, user]);

    const handlePodatObjednavku = () => {
        showModal({
            type: 'confirmation',
            heading: 'Podat objednávku',
            message: 'Opravdu chcete podat objednávku?',
            onConfirm: () => {
                axios.post(IP + "/kosiky/podani", {
                    id_uzivatel: user.id_uzivatel,
                    id_zpusob_platby: zpusobPlatby,
                    objednaneKvetiny: [
                        ...items
                    ]
                }).then(response => {
                    if (response.data.status_code == 1) {
                        clearKosik();
                        showModal({
                            type: 'info',
                            heading: "Úspěch",
                            message: response.data.status_message,
                            redirectPath: '/profile',
                        });
                    } else {
                        showModal({
                            type: 'error',
                            heading: "Chyba",
                            message: response.data.status_message
                        });
                    }
                }).catch(error => {
                    showModal({
                        type: 'error',
                        heading: "Chyba",
                        message: "Server je nedostupný" 
                    });
                })
            },
        });
    }

    return (

        <>
            {!isAuthenticated && <h1>Nejste přihlášení</h1>}
            {(isAuthenticated && items.length === 0) && <h1>Košík je prázdný</h1>}
            {(isAuthenticated && items.length !== 0) &&
            <>
                <div className='d-flex flex-column align-items-center w-100'>
                    <ul className="list-group list-group-flush my-5 w-75">
                        {items.map((item, i) => {
                            const kvetina = products.filter(p => p.id_kvetina == item.id_kvetina)[0];

                            if (kvetina != null) {

                                const image = images.filter(it => it.id_obrazek == kvetina.id_obrazek)[0];
                                let data = '';
                                let alt = '';
                                if (image != null) {
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

                                    const parts = image.nazev_souboru.toLowerCase().split('.');
                                    const extension = parts.pop();

                                    const mimeType = mimeTypeMap[extension];

                                    data = `data:${mimeType};base64,` + image.base64;
                                    alt = image.nazev_souboru;
                                }

                                let categoryName = '';
                                if (categories.length != 0) {
                                    categoryName = categories.filter(k => k.id_kategorie == kvetina.id_kategorie)[0].nazev;
                                }

                                return (
                                    <li key={i} className="d-flex justify-content-between align-items-center list-group-item">
                                        <div className='d-flex align-items-center justify-content-center'>
                                            <div className='ratio ratio-1x1 mx-4' style={{ width: '4em', height: '4em' }}>
                                                <img src={data === '' ? null : data} alt={alt} className='img-thumbnail' />
                                            </div>
                                            <h3>{kvetina.nazev}</h3>
                                        </div>
                                        <div className='d-flex align-items-center justify-content-between w-25'>
                                            <h5>{countItems(kvetina.id_kvetina)} x</h5>
                                            <h5>{kvetina.cena} Kč</h5>
                                            <button type='button' className='btn btn-danger' onClick={() => removeItem(kvetina.id_kvetina, item.pocet)}>Odebrat</button>
                                        </div>
                                    </li>
                                )
                            }
                        })}
                    </ul>
                    <div className='d-flex flex-column align-items-end w-50'>
                        <h3>Celkem {cena} Kč</h3>
                    </div>
                    <div className='d-flex flex-column align-items-start w-50'>
                        <h5>Způsob platby</h5>
                        {zpusobyPlatby.map((zp, i) => {
                            return <div key={i} className="form-check">
                                <input onChange={(e) => setZpusobPlatby(e.target.value)} value={zp.id_zpusob_platby} className="form-check-input" type="radio" name="flexRadioDefault" id="flexRadioDefault1" />
                                <label className="form-check-label" htmlFor="flexRadioDefault1">
                                    {zp.nazev}
                                </label>
                            </div>
                        })}
                    </div>
                    <button onClick={handlePodatObjednavku} type='button' className='btn btn-primary large w-25 h-25 my-5'>Odeslat objednávku</button>
                </div>
            </>
            }
        </>
    )
}
