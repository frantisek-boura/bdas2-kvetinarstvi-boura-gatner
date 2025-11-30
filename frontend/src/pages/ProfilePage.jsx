import React, { useEffect, useState } from 'react'
import Logo from '../assets/logo.png'
import { useAuth } from '../components/AuthContext'
import { validateHeslo, validateCp, validatePSC, validateValue } from '../components/validators';
import axios from 'axios';
import { IP } from '../ApiURL';
import { useModal } from '../components/ModalContext';

export default function ProfilePage() {

    const { user, opravneni, isAuthenticated, login, isEmulating } = useAuth();
    const { showModal, hideModal, modalState } = useModal();

    const [obrazek, setObrazek] = useState('');
    const [nazevSouboru, setNazevSouboru] = useState('');

    const [heslo1, setHeslo1] = useState('');
    const [heslo2, setHeslo2] = useState('');
    const [hesloError, setHesloError] = useState([]);

    const [ulice, setUlice] = useState('');
    const [cp, setCp] = useState(0);
    const [psc, setPsc] = useState('');
    const [mesto, setMesto] = useState('');
    const [adresaError, setAdresaError] = useState([]);

    const [stavyObjednavek, setStavyObjednavek] = useState([]);
    const [zpusobyPlatby, setZpusobyPlatby] = useState([]);
    const [objednavky, setObjednavky] = useState([]);

    useEffect(() => {
        if (!isAuthenticated) {
            return;
        }

        const uzivatel_objednavky = [];

        let id_ulice, id_mesto, id_psc;

        axios.get(IP + "/zpusobyplateb")
        .then(responseZP => {
            setZpusobyPlatby(responseZP.data);
            return axios.get(IP + "/stavyobjednavek");
        }).then(responseSO => {
            setStavyObjednavek(responseSO.data);
            return axios.get(IP + "/uzivatele/objednavky/" + user.id_uzivatel);
        }).then(responseOB => {
            uzivatel_objednavky.push(...responseOB.data);
            return axios.get(IP + "/kosiky");
        }).then(responseKO => {
            const objednavky_s_polozkami = [];
            const kosiky = [];

            kosiky.push(...responseKO.data);
            uzivatel_objednavky.forEach(o => {
                const kosik = kosiky.find(k => k.id_kosik == o.id_kosik);
                kosik.polozky = o.polozky;
                objednavky_s_polozkami.push(kosik);
            });
            setObjednavky(objednavky_s_polozkami.sort((a, b) => new Date(b.datum_vytvoreni) - new Date(a.datum_vytvoreni)));
            return axios.get(IP + "/obrazky/" + user.id_obrazek);
        }).then(responseO => {
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

            const parts = responseO.data.nazev_souboru.toLowerCase().split('.');
            const extension = parts.pop();

            const mimeType = mimeTypeMap[extension];

            if (mimeType) {
                setObrazek(`data:${mimeType};base64,` + responseO.data.base64);
            }

            setNazevSouboru(responseO.data.nazev_souboru);
            return axios.get(IP + "/adresy/" + user.id_adresa);
        }).then(responseA => {
            setCp(responseA.data.cp);
            id_ulice = responseA.data.id_ulice;
            id_psc = responseA.data.id_psc;
            id_mesto = responseA.data.id_mesto;
            return axios.get(IP + "/ulice/" + id_ulice);
        }).then(responseU => {
            setUlice(responseU.data.nazev);
            return axios.get(IP + "/mesta/" + id_mesto);
        }).then(responseM => {
            setMesto(responseM.data.nazev);
            return axios.get(IP + "/psc/" + id_psc);
        }).then(responseP => {
            setPsc(responseP.data.psc);
        });
    }, [user]);

    useEffect(() => {
        setHesloError(validateHeslo(heslo1, heslo2));
    }, [heslo1, heslo2]);

    const validateAdresa = () => {
        const chyby = [];

        const uliceError = validateValue(ulice, 'ulici');
        const cpError = validateCp(cp);
        const mestoError = validateValue(mesto, 'město');
        const pscError = validatePSC(psc);

        if (uliceError) {
            chyby.push(uliceError);
        }
        if (cpError) {
            chyby.push(cpError);
        }
        if (mestoError) {
            chyby.push(mestoError);
        }
        if (pscError) {
            chyby.push(pscError);
        }

        setAdresaError(chyby);
    }

    useEffect(() => {
        validateAdresa();
    }, [user, opravneni, isAuthenticated, isEmulating, ulice, cp, psc, mesto]);

    const zaplatitObjednavku = (kosik) => {
        axios.put(
            IP + "/kosiky", {
                id_kosik: kosik.id_kosik,
                datum_vytvoreni: kosik.datum_vytvoreni,
                cena: kosik.cena,
                sleva: kosik.sleva,
                id_uzivatel: kosik.id_uzivatel,
                id_stav_objednavky: 3,
                id_zpusob_platby: kosik.id_zpusob_platby
            }
        ).then(response => {
            if (response.data.status_code == 1) {
                showModal({
                    type: 'info',
                    heading: 'Úspěch',
                    message: 'Objednávka úspěšně zaplacena' 
                });
            } else {
                showModal({
                    type: 'error',
                    heading: 'Chyba',
                    message: 'Chyba při placení objednávky, zkuste to znovu' 
                });
            }
        }).catch(error => {
            showModal({
                type: 'error',
                heading: 'Chyba',
                message: 'Chyba při placení objednávky, zkuste to znovu'
            });
        })
    }

    const handleZmenitObrazek = (img) => {
        const reader = new FileReader();
        reader.onload = function(e) {
            const base64String_org = e.target.result;
            const base64String = base64String_org.substring(e.target.result.indexOf(',') + 1)
            
            axios.post(
                IP + "/obrazky", {
                    nazev_souboru: img.name,
                    base64: base64String,
                }
            ).then(responseO => {
                const v_id_obrazek = responseO.data.value.id_obrazek;
                return axios.put(
                    IP + "/uzivatele", {
                    id_uzivatel: user.id_uzivatel,
                    email: user.email,
                    pw_hash: user.pw_hash,
                    salt: user.salt,
                    id_opravneni: user.id_opravneni,
                    id_obrazek: v_id_obrazek,
                    id_adresa: user.id_adresa
                });
            }).then(userR => {
                const userData = userR.data.value;
                if (userR.data.status_code == 1) {
                    showModal({
                        type: 'info',
                        heading: 'Úspěch',
                        message: userR.data.status_message
                    });

                    login(userData, opravneni);
                    setObrazek(base64String_org);
                    setNazevSouboru(img.name);
                } else {
                    showModal({
                        type: 'error',
                        heading: 'Chyba',
                        message: userR.data.status_message
                    });
                }
            }).catch(error => {
                showModal({
                    type: 'error',
                    heading: 'Chyba při změně adresy',
                    message: 'Server není dostupný'
                });
            });
        }
        reader.readAsDataURL(img);
    }

    const handleAddressChange = (e) => {
        e.preventDefault();

        if (adresaError.length !== 0) {
            showModal({
                type: 'error',
                heading: 'Chyba při změně adresy',
                message: 'Vyplňtě všechna pole správně'
            });
            return;
        }

        // omlouvam se tohle je opravdu odporne
        showModal({
            type: 'confirmation',
            heading: 'Změna adresy',
            message: 'Opravdu chcete změnit adresu?',
            onConfirm: () => {
                let v_id_ulice, v_id_psc, v_id_mesto, v_id_adresa;
                let error = false;
                let errorMsg = '';

                axios.post(
                    IP + "/ulice", {
                        nazev: ulice
                    }
                ).then(uliceR => {
                    if (uliceR.data.status_code == 1) {
                        v_id_ulice = uliceR.data.value.id_ulice;

                        axios.post(
                            IP + "/mesta", {
                                nazev: mesto 
                            }
                        ).then(mestoR => {
                            if (mestoR.data.status_code == 1) {
                                v_id_mesto = mestoR.data.value.id_mesto;

                                axios.post(
                                    IP + "/psc", {
                                        psc: psc 
                                    }
                                ).then(pscR => {
                                    if (pscR.data.status_code == 1) {
                                        v_id_psc = pscR.data.value.id_psc;

                                        axios.post(
                                            IP + "/adresy", {
                                                cp: cp,
                                                id_mesto: v_id_mesto,
                                                id_ulice: v_id_ulice,
                                                id_psc: v_id_psc
                                            }
                                        ).then(adresaR => {
                                            if (adresaR.data.status_code == 1) {
                                                v_id_adresa = adresaR.data.value.id_adresa;

                                                axios.put(
                                                    IP + "/uzivatele", {
                                                    id_uzivatel: user.id_uzivatel,
                                                    email: user.email,
                                                    pw_hash: user.pw_hash,
                                                    salt: user.salt,
                                                    id_opravneni: user.id_opravneni,
                                                    id_obrazek: user.id_obrazek,
                                                    id_adresa: v_id_adresa
                                                }
                                                ).then(userR => {
                                                    const userData = userR.data.value;

                                                    if (userR.data.status_code == 1) {
                                                        showModal({
                                                            type: 'info',
                                                            heading: 'Úspěch',
                                                            message: userR.data.status_message
                                                        });

                                                        login(userData, opravneni)
                                                    } else {
                                                        showModal({
                                                            type: 'error',
                                                            heading: 'Chyba',
                                                            message: userR.data.status_message
                                                        });
                                                    }
                                                }).catch(error => {
                                                    showModal({
                                                        type: 'error',
                                                        heading: 'Chyba při změně adresy',
                                                        message: 'Server není dostupný'
                                                    });
                                                    return;
                                                })
                                            } else {
                                                showModal({
                                                    type: 'info',
                                                    heading: 'Chyba při změně adresy',
                                                    message: adresaR.data.status_message
                                                });
                                                return;
                                            }
                                        });
                                        
                                    } else {
                                        error = true;
                                        errorMsg = pscR.data.status_message;
                                        showModal({
                                            type: 'error',
                                            heading: 'Chyba při změně adresy',
                                            message: errorMsg
                                        });
                                        return;
                                    }
                                });

                            } else {
                                error = true;
                                errorMsg = mestoR.data.status_message;

                                showModal({
                                    type: 'error',
                                    heading: 'Chyba při změně adresy',
                                    message: errorMsg
                                });
                                return;
                            }
                        });

                    } else {
                        error = true;
                        errorMsg = uliceR.data.status_message;
                        showModal({
                            type: 'error',
                            heading: 'Chyba při změně adresy',
                            message: errorMsg 
                        });
                        return;
                    }
                });
            }
        });
    }

    const handlePasswordChange = (e) => {
        e.preventDefault();

        if (hesloError.length !== 0) {
            showModal({
                type: 'error',
                heading: 'Chyba při změně hesla',
                message: 'Heslo nesplňuje požadavky'
            });

            return;
        }

        showModal({
            type: 'confirmation',
            heading: 'Změna hesla',
            message: 'Opravdu chcete změnit heslo?',
            onConfirm: () => {
                axios.post(
                    IP + "/uzivatele/zmena-hesla", {
                        "id_uzivatel": user.id_uzivatel,
                        "generovat_heslo": false,
                        "nove_heslo": heslo1
                    }
                ).then(response => {
                    if (response.data.status_code == 1) {

                        axios.get(
                            IP + "/uzivatele/" + user.id_uzivatel
                        ).then(userR => {
                            login(userR.data, opravneni);
                        })

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
                        heading: 'Chyba při změně hesla',
                        message: 'Server není dostupný'
                    });
                    return;
                })
            },
        });
    };

    return (
        <div className='d-flex flex-row justify-content-center w-100 m-5'>
            {
                isAuthenticated ?
                    <>
                        <div className='d-flex flex-column w-25'>
                            <div className='d-flex flex-column align-items-start'>
                                <div className='d-flex flex-column justify-content-center mx-2'>
                                    <h1>{user.email}</h1>
                                    <h5>{opravneni.nazev}</h5>
                                </div>
                                <div className='d-flex flex-column align-items-center justify-content-center'>
                                    <div className='ratio ratio-1x1'>
                                        <img src={obrazek == "" ? null : obrazek} alt={nazevSouboru} className='img-thumbnail' />
                                    </div>
                                    <label htmlFor="file" className="btn btn-primary">Změnit obrázek</label>
                                    <input type="file" accept="image/*" id="file" className='m-1' style={{display: 'none'}} onChange={(e) => handleZmenitObrazek(e.target.files[0])}/>
                                </div>
                                <div className='d-flex flex-column align-items-stat my-2'>
                                    <h3>Změna hesla</h3>
                                    <form className='' onSubmit={handlePasswordChange}>
                                        <div className="form-group py-1">
                                            <label htmlFor="password">Nové heslo</label>
                                            <input type="password" onChange={(e) => setHeslo1(e.target.value)} className="form-control" id="password" name="password" placeholder="Zadejte heslo" />
                                        </div>
                                        <div className="form-group py-1">
                                            <label htmlFor="password2">Nové heslo znovu</label>
                                            <input type="password" onChange={(e) => setHeslo2(e.target.value)} className="form-control" id="password2" name="password2" placeholder="Zadejte heslo znovu" />
                                        </div>
                                        <button type="submit" className="btn btn-primary m-1" disabled={hesloError.length !== 0}>Změnit heslo</button>
                                    </form>
                                    <ul className="list-group">
                                        {hesloError.map((v, i) => {
                                            return (<li key={i} className="list-group-item list-group-item-danger">{v}</li>);
                                        })}
                                    </ul>
                                </div>
                                <div className='d-flex flex-column justify-content-center m-2'>
                                    <h3>Doručovací adresa</h3>
                                    <form className='' onSubmit={handleAddressChange}>
                                        <div className="form-group py-1">
                                            <label htmlFor="street">Ulice</label>
                                            <input value={ulice} type="text" onChange={(e) => setUlice(e.target.value)} className="form-control" id="street" name="street" placeholder="Název ulice" />
                                        </div>
                                        <div className="form-group py-1">
                                            <label htmlFor="cp">Č.p.</label>
                                            <input value={cp} type="number" onChange={(e) => setCp(e.target.value)} className="form-control" min={0} id="cp" name="cp" placeholder="Č.p." />
                                        </div>
                                        <div className="form-group py-1">
                                            <label htmlFor="psc">PSČ</label>
                                            <input value={psc} type="number" onChange={(e) => setPsc(e.target.value)} className="form-control" min={0} id="psc" name="psc" placeholder="PSČ" />
                                        </div>
                                        <div className="form-group py-1">
                                            <label htmlFor="city">Město</label>
                                            <input value={mesto} type="text" onChange={(e) => setMesto(e.target.value)} className="form-control" id="city" name="city" placeholder="Název města" />
                                        </div>
                                        <button type="submit" disabled={adresaError.length !== 0} className="btn btn-primary m-1">Změnit adresu</button>
                                    </form>
                                    <ul className="list-group">
                                        {adresaError.map((v, i) => {
                                            return (<li key={i} className="list-group-item list-group-item-danger">{v}</li>);
                                        })}
                                    </ul>
                                </div>
                            </div>
                        </div>
                        <div className='d-flex flex-column my-5 py-5 w-50'>
                            <h3>Historie objednávek</h3>
                            <div className='d-flex flex-column'>
                                <div className='d-flex flex-row justify-content-start'>
                                    <p className='bg-success text-white rounded p-1 m-1'>Vyřízena</p>
                                    <p className='bg-danger text-white rounded p-1 m-1'>Zrušena</p>
                                    <p className='bg-warning text-white rounded p-1 m-1'>Čeká na zaplacení</p>
                                    <p className='bg-info text-white rounded p-1 m-1'>Na cestě</p>
                                </div>
                            </div>
                            {objednavky.length === 0 && <h3>Tento uživatel nemá žádné objednávky</h3>}
                            { objednavky.map((k, i) => {
                                const id_div = 'orderCollapse' + i;
                                const timestamp = new Date(k.datum_vytvoreni);
                                const date = timestamp.getDate() + '.' + (timestamp.getMonth() + 1) + '.' + timestamp.getFullYear();

                                const cena = k.cena;
                                const zpusobPlatby = zpusobyPlatby.find((v) => v.id_zpusob_platby == k.id_zpusob_platby).nazev;

                                const stavObjednavky = stavyObjednavek.find((v) => v.id_stav_objednavky == k.id_stav_objednavky).nazev;

                                let obj_bg;
                                switch (stavObjednavky) {
                                    case "Čeká na zaplacení":
                                        obj_bg = 'bg-warning '   
                                        break;
                                    case "Vyřízena":
                                        obj_bg = 'bg-success ' 
                                        break;
                                    case "Na cestě":
                                        obj_bg = 'bg-info ' 
                                        break;
                                    case "Zrušena":
                                        obj_bg = 'bg-danger ' 
                                        break;
                                }

                                return <div key={i}>
                                    <button className={obj_bg + 'btn d-flex flex-column rounded m-1 p-1 text-white w-100'} type='button' data-bs-toggle="collapse" data-bs-target={"#" + id_div} aria-expanded="false" aria-controls={id_div} >
                                        <div className='d-flex flex-row justify-content-between'>
                                            <h5 className='mx-2'>{date}</h5>
                                            <h5 className='mx-2'>{cena} Kč</h5>
                                        </div>
                                    </button>
                                    <div className={obj_bg + 'collapse rounded m-1 p-1 text-white w-100'} id={id_div}>
                                        <div className='d-flex justify-content-between align-items-center m-1 p-1'>
                                            <span>{zpusobPlatby}</span>
                                            <span>{k.sleva == 10 ? "Sleva 10%" : "Bez slevy"}</span>
                                        </div>
                                            <div className='d-flex flex-column justify-content-between m-1 px-1'>
                                                <ul className='list-group'>
                                                    <li className='d-flex justify-content-between align-items-center px-3 py-1'>
                                                        <span>Položka</span>
                                                        <span>Počet</span>
                                                        <span>Cena za kus</span>
                                                        <span>Celková cena</span>
                                                    </li>
                                                {
                                                    k.polozky.map((kv, id) => {
                                                        return <div key={id}>
                                                            <li className='d-flex justify-content-between align-items-center px-3 py-1'>
                                                                <span>{kv.nazev}</span>
                                                                <span>{kv.pocet} x</span>
                                                                <span>{kv.cena_za_kus}</span>
                                                                <span>{k.cena}</span>
                                                            </li>
                                                        </div>
                                                })}
                                            </ul>
                                            { stavObjednavky === "Čeká na zaplacení" &&
                                                <button onClick={() => zaplatitObjednavku(k)} type='btn' className='btn btn-primary'>Zaplatit</button>
                                            }
                                        </div>
                                    </div>
                                </div>
                            })
                            }
                        </div>
                    </>
                :
                <>
                    <h1>Nejste přihlášeni</h1> 
                </>
            }
        </div>
    )
}
