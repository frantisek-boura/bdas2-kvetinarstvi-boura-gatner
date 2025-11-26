import React, { useEffect, useState } from 'react'
import Logo from '../assets/logo.png'
import { useAuth } from '../components/AuthContext'
import { validateHeslo, validateCp, validatePSC, validateValue } from '../components/validators';
import axios from 'axios';
import { IP } from '../ApiURL';
import { useModal } from '../components/ModalContext';

export default function ProfilePage() {

    const { user, opravneni, isAuthenticated, login } = useAuth();
    const { showModal, hideModal, modalState } = useModal();

    const [heslo1, setHeslo1] = useState('');
    const [heslo2, setHeslo2] = useState('');
    const [hesloError, setHesloError] = useState([]);

    const [ulice, setUlice] = useState('');
    const [cp, setCp] = useState(0);
    const [psc, setPsc] = useState('');
    const [mesto, setMesto] = useState('');
    const [adresaError, setAdresaError] = useState([]);

    useEffect(() => {
        if (!isAuthenticated) {
            return;
        }

        axios.get(
            IP + "/adresy/" + user.id_adresa
        ).then(responseA => {
            axios.get(
                IP + "/ulice/" + responseA.data.id_ulice
            ).then(responseU => {
                setUlice(responseU.data.nazev);
            });


            axios.get(
                IP + "/mesta/" + responseA.data.id_mesto
            ).then(responseM => {
                setMesto(responseM.data.nazev);
            });


            axios.get(
                IP + "/psc/" + responseA.data.id_psc
            ).then(responseP => {
                setPsc(responseP.data.psc);
            });

            setCp(responseA.data.cp);

            validateAdresa();
        })
    }, []);

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
    }, [ulice, cp, psc, mesto]);

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
                                        <img src={Logo} alt="Profilový obrázek" className='img-thumbnail' />
                                    </div>
                                    <button className='btn btn-primary m-1'>Změnit obrázek</button>
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
                            <button className='btn d-flex flex-column bg-success rounded m-1 p-1 text-white w-100' type='button' data-bs-toggle="collapse" data-bs-target="#orderCollapse" aria-expanded="false" aria-controls="orderCollapse" >
                                <div className='d-flex flex-row justify-content-between'>
                                    <h5 className='mx-2'>16.10.2025</h5>
                                    <h5 className='mx-2'>650 Kč</h5>
                                </div>
                            </button>
                            <div className='collapse bg-success rounded m-1 p-1 text-white w-100' id="orderCollapse">
                                <div className='d-flex justify-content-between align-items-center m-1 p-1'>
                                    <span>Způsob platby</span>
                                    <span>Kartou</span>
                                </div>
                                <div className='d-flex flex-column justify-content-between m-1 px-1'>
                                    <ul className='list-group'>
                                        <li className='d-flex justify-content-between align-items-center px-3 py-1'>
                                            <span>Květina</span>
                                            <span>10x</span>
                                            <span>300 Kč</span>
                                        </li>
                                        <li className='d-flex justify-content-between align-items-center px-3 py-1'>
                                            <span>Květina</span>
                                            <span>3x</span>
                                            <span>250 Kč</span>
                                        </li>
                                        <li className='d-flex justify-content-between align-items-center px-3 py-1'>
                                            <span>Květina</span>
                                            <span>5x</span>
                                            <span>100 Kč</span>
                                        </li>
                                    </ul>
                                </div>
                            </div>
                            <button className='btn d-flex flex-column bg-danger rounded m-1 p-1 text-white w-100' type='button' data-bs-toggle="collapse" data-bs-target="#orderCollapse2" aria-expanded="false" aria-controls="orderCollapse2" >
                                <div className='d-flex flex-row justify-content-between'>
                                    <h5 className='mx-2'>16.10.2025</h5>
                                    <h5 className='mx-2'>650 Kč</h5>
                                </div>
                            </button>
                            <div className='collapse bg-danger rounded m-1 p-1 text-white w-100' id="orderCollapse2">
                                <div className='d-flex justify-content-between align-items-center m-1 p-1'>
                                    <span>Způsob platby</span>
                                    <span>Kartou</span>
                                </div>
                                <div className='d-flex flex-column justify-content-between m-1 px-1'>
                                    <ul className='list-group'>
                                        <li className='d-flex justify-content-between align-items-center px-3 py-1'>
                                            <span>Květina</span>
                                            <span>10x</span>
                                            <span>300 Kč</span>
                                        </li>
                                        <li className='d-flex justify-content-between align-items-center px-3 py-1'>
                                            <span>Květina</span>
                                            <span>3x</span>
                                            <span>250 Kč</span>
                                        </li>
                                        <li className='d-flex justify-content-between align-items-center px-3 py-1'>
                                            <span>Květina</span>
                                            <span>5x</span>
                                            <span>100 Kč</span>
                                        </li>
                                    </ul>
                                </div>
                            </div>
                            <button className='btn d-flex flex-column bg-warning rounded m-1 p-1 text-white w-100' type='button' data-bs-toggle="collapse" data-bs-target="#orderCollapse3" aria-expanded="false" aria-controls="orderCollapse3" >
                                <div className='d-flex flex-row justify-content-between'>
                                    <h5 className='mx-2'>16.10.2025</h5>
                                    <h5 className='mx-2'>650 Kč</h5>
                                </div>
                            </button>
                            <div className='collapse bg-warning rounded m-1 p-1 text-white w-100' id="orderCollapse3">
                                <div className='d-flex justify-content-between align-items-center m-1 p-1'>
                                    <span>Způsob platby</span>
                                    <span>Kartou</span>
                                </div>
                                <div className='d-flex flex-column justify-content-between m-1 px-1'>
                                    <ul className='list-group'>
                                        <li className='d-flex justify-content-between align-items-center px-3 py-1'>
                                            <span>Květina</span>
                                            <span>10x</span>
                                            <span>300 Kč</span>
                                        </li>
                                        <li className='d-flex justify-content-between align-items-center px-3 py-1'>
                                            <span>Květina</span>
                                            <span>3x</span>
                                            <span>250 Kč</span>
                                        </li>
                                        <li className='d-flex justify-content-between align-items-center px-3 py-1'>
                                            <span>Květina</span>
                                            <span>5x</span>
                                            <span>100 Kč</span>
                                        </li>
                                    </ul>
                                </div>
                            </div>
                            <button className='btn d-flex flex-column bg-info rounded m-1 p-1 text-white w-100' type='button' data-bs-toggle="collapse" data-bs-target="#orderCollapse4" aria-expanded="false" aria-controls="orderCollapse4" >
                                <div className='d-flex flex-row justify-content-between'>
                                    <h5 className='mx-2'>16.10.2025</h5>
                                    <h5 className='mx-2'>650 Kč</h5>
                                </div>
                            </button>
                            <div className='collapse bg-info rounded m-1 p-1 text-white w-100' id="orderCollapse4">
                                <div className='d-flex justify-content-between align-items-center m-1 p-1'>
                                    <span>Způsob platby</span>
                                    <span>Kartou</span>
                                </div>
                                <div className='d-flex flex-column justify-content-between m-1 px-1'>
                                    <ul className='list-group'>
                                        <li className='d-flex justify-content-between align-items-center px-3 py-1'>
                                            <span>Květina</span>
                                            <span>10x</span>
                                            <span>300 Kč</span>
                                        </li>
                                        <li className='d-flex justify-content-between align-items-center px-3 py-1'>
                                            <span>Květina</span>
                                            <span>3x</span>
                                            <span>250 Kč</span>
                                        </li>
                                        <li className='d-flex justify-content-between align-items-center px-3 py-1'>
                                            <span>Květina</span>
                                            <span>5x</span>
                                            <span>100 Kč</span>
                                        </li>
                                    </ul>
                                </div>
                            </div>
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
