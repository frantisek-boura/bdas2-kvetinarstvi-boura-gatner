import React, { useEffect, useState } from 'react'
import { Link, useParams, useNavigate, replace } from 'react-router-dom'
import { useAuth } from './AuthContext';
import { useModal } from './ModalContext'
import axios from 'axios';
import { IP } from '../ApiURL';
import { useCheckout } from './CheckoutContext';

export default function UserControls() {

    const { user, opravneni, isAuthenticated, logout, emulate, stopEmulate, isEmulating } = useAuth();
    const { showModal, hideModal, modalState } = useModal();
    const { items } = useCheckout();

    const navigateHome = useNavigate();

    const [uzivatele, setUzivatele] = useState([]);
    const [selectedUziv, setSelectedUziv] = useState(user);

    useEffect(() => {
        if (isEmulating) {
            return;
        }

        axios.get(
            IP + "/uzivatele"
        ).then(response => {
            setUzivatele(response.data);
            setSelectedUziv(response.data[0]);
        })
    }, []);

    const handleConfirmModal = () => {
        showModal({
            type: 'confirmation',
            heading: 'Odhlášení',
            message: 'Opravdu se chcete odhlásit?',
            onConfirm: () => {
                logout();
                navigateHome('/', {replace: true});
            },
        });
    };

    const emulovatUzivatele = () => {
        axios.get(
            IP + "/opravneni/" + selectedUziv.id_opravneni
        ).then(response => {
            const opr = response.data;
            emulate(selectedUziv, opr);
        })
    }

    const prestatEmulovatUzivatele = () => {
        stopEmulate();
    }

    return (
        <div className='d-flex flex-row justify-content-end align-items-end w-50'>
            <div className='d-flex flex-column justify-content-end align-items-start w-100'>
                <div className='text-align-center p-1'>
                    <div className='d-flex flex-row justify-content-center align-items-center w-100'>
                    {
                        isAuthenticated ?
                            <>
                                <p className='align-middle m-1'>{user.email}</p>
                                <p className='align-middle m-2'>{opravneni.nazev}</p>
                            </>
                        :
                            <p className='align-middle m-1'>Nepřihlášený</p>
                    }
                    </div>
                </div>
                {
                    isAuthenticated ?
                        <div className='d-flex flex-row'>
                            <Link to="/checkout"><button className='btn btn-secondary mx-1'>Košík ({items.length})</button></Link>
                            <Link to='/profile'><button className='btn btn-primary mx-1'>Profil</button></Link>
                            <button className='btn btn-danger mx-1' onClick={handleConfirmModal}>Odhlásit se</button>
                            {(opravneni.uroven_opravneni == 2 && !isEmulating) &&
                                <>
                                    <button className='btn btn-info mx-1' onClick={emulovatUzivatele}>Emulovat uživatele</button>
                                    <div className="dropdown">
                                        <button className="btn btn-secondary dropdown-toggle" type="button" id="dropdownMenu2" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                            {selectedUziv.email} 
                                        </button>
                                        <div className="dropdown-menu" aria-labelledby="dropdownMenu2">
                                            {uzivatele.map((u, i) => {
                                                return <button key={i} className="dropdown-item" type="button" onClick={() => setSelectedUziv(u)}>{u.email}</button>
                                            })}
                                        </div>
                                    </div>
                                </>
                            }
                            {isEmulating && 
                                <button className='btn btn-danger mx-1' onClick={prestatEmulovatUzivatele}>Přestat emulovat</button>
                            }
                        </div>
                    :
                        <div className='d-flex flex-row'>
                            <Link to="login"><button className='btn btn-primary m-1'>Přihlásit se</button></Link>
                            <Link to="register"><button className='btn btn-secondary m-1'>Registrace</button></Link>
                        </div>
                }
            </div>
        </div>
    )
}
