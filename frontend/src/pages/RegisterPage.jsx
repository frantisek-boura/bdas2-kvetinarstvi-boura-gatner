import React, { useEffect, useState } from 'react'
import { Link } from 'react-router-dom'
import { validatePSC, validateEmail, validateHeslo, validateValue, validateCp } from '../components/validators';
import { useAuth } from '../components/AuthContext';
import { useModal } from '../components/ModalContext';
import { IP } from '../ApiURL';
import axios from 'axios';

export default function RegisterPage() {

    const { login, isAuthenticated } = useAuth();
    const { showModal, hideModal, modalState } = useModal();

    const [email, setEmail] = useState('');
    const [heslo, setHeslo] = useState('');
    const [hesloZnovu, setHesloZnovu] = useState('');
    const [ulice, setUlice] = useState('');
    const [cp, setCp] = useState(0);
    const [mesto, setMesto] = useState('');
    const [psc, setPsc] = useState('');
    const [souhlas, setSouhlas] = useState(false);

    const [error, setError] = useState([]);    

    useEffect(() => {
        const chyby = [];

        const emailError = validateEmail(email);
        const hesloErrors = validateHeslo(heslo, hesloZnovu);
        const uliceError = validateValue(ulice, 'ulici');
        const cpError = validateCp(cp);
        const mestoError = validateValue(mesto, 'město');
        const pscError = validatePSC(psc);
        const souhlasError = souhlas === false;

        if (emailError) {
            chyby.push(emailError);
        }
        hesloErrors.forEach((v, _) => {
            chyby.push(v);
        })
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
        if (souhlasError) {
            chyby.push('Musíte souhlasit se zpracováním osobních údajů.');
        }

        setError(chyby);
    }, [email, heslo, hesloZnovu, ulice, cp, mesto, psc, souhlas]);

    const handleRegister = (e) => {
        e.preventDefault();

        if (error.length > 0) {
            handleShowError('Chyba', 'Dodržte všechna stanovená omezení pro registraci');
        }

        axios.post(
            IP + '/uzivatele/registrace', {
                email: email,
                heslo: heslo,
                ulice: ulice,
                cp: cp,
                mesto: mesto,
                psc: psc
            }
        ).then(response => {
            const userData = response.data.value;

            axios.get(
                IP + "/opravneni/" + userData.id_opravneni
            ).then(response2 => {
                const opravneni = response2.data

                login(userData, opravneni);

                if (response.data.status_code == 1) {
                    handleShowInfo('Úspěch', 'Byli jste úspěšně zaregistrováni a přihlášeni.');
                } else {
                    handleShowowError('Chyba', response.data.status_message);
                }
            }).catch(er => {
                handleShowError('Chyba', "Server je nedostupný");
            })

        }).catch(er => {
            handleShowError('Chyba', "Server je nedostupný");
        });
    }

    const handleShowError = (heading_message, status_message) => {
        showModal({
            type: 'error',
            heading: heading_message,
            message: status_message,
        });
    };

    const handleShowInfo = (heading_message, status_message) => {
        showModal({
            type: 'info',
            heading: heading_message,
            message: status_message,
            redirectPath: '/',
        });
    };

    return (
        <div className='w-50'>
            <form className='m-5' onSubmit={handleRegister}>
                <div className="form-group p-1">
                    <label htmlFor="email">E-mail</label>
                    <input type="text" className="form-control" id="email" name="email" onChange={e => setEmail(e.target.value)} placeholder="Zadejte e-mail" />
                </div>
                <div className="form-group p-1">
                    <label htmlFor="password">Heslo</label>
                    <input type="password" className="form-control" id="password" name="password" onChange={e => setHeslo(e.target.value)} placeholder="Zadejte heslo" />
                </div>
                <div className="form-group p-1">
                    <label htmlFor="password2">Heslo znovu</label>
                    <input type="password" className="form-control" id="password2" name="password2" onChange={e => setHesloZnovu(e.target.value)} placeholder="Zadejte heslo znovu" />
                </div>
                <div className="form-group p-1">
                    <label htmlFor="street">Ulice</label>
                    <input type="text" className="form-control" id="street" name="street" onChange={e => setUlice(e.target.value)} placeholder="Název ulice" />
                </div>
                <div className="form-group p-1">
                    <label htmlFor="cp">Č.p.</label>
                    <input type="number" className="form-control" min={0} id="cp" name="cp" onChange={e => setCp(e.target.value)} placeholder="Č.p." />
                </div>
                <div className="form-group p-1">
                    <label htmlFor="psc">PSČ</label>
                    <input type="number" className="form-control" min={0}  id="psc" name="psc" onChange={e => setPsc(e.target.value)} placeholder="PSČ" />
                </div>
                <div className="form-group p-1">
                    <label htmlFor="city">Město</label>
                    <input type="text" className="form-control" id="city" name="city" onChange={e => setMesto(e.target.value)} placeholder="Název města" />
                </div>
                <div className="form-check m-1">
                    <input type="checkbox" className="form-check-input" id="tos" onChange={e => setSouhlas(e.target.checked)} />
                    <label className="form-check-label" htmlFor="tos">Souhlas se zpracováním osobních údajů</label>
                </div>
                <button type="submit" className="btn btn-primary m-1" disabled={error.length !== 0}>Registrovat</button>
            </form>
            <div>
                <ul className="list-group">
                    {error.map((v, i) => {
                        return (<li key={i} className="list-group-item list-group-item-danger">{v}</li>);
                    })}
                </ul>
            </div>
        </div>
    )
}
