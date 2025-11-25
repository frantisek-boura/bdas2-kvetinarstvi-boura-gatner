import React from 'react'
import { Link, useParams, useNavigate, replace } from 'react-router-dom'
import { useAuth } from './AuthContext';
import { useModal } from './ModalContext'

export default function UserControls() {

    const {user, opravneni, isAuthenticated, logout} = useAuth();
    const { showModal, hideModal, modalState } = useModal();
    const navigateHome = useNavigate();

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

    return (
        <div className='d-flex flex-row justify-content-center align-items-center'>
            <div className='d-flex flex-column justify-content-center align-items-center'>
                <div className='text-align-center p-1'>
                    <div className='d-flex flex-row justify-content-center align-items-center'>
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
                            <Link to="/checkout"><button className='btn btn-secondary mx-1'>Košík</button></Link>
                            <Link to='/profile'><button className='btn btn-primary mx-1'>Profil</button></Link>
                            <button className='btn btn-danger mx-1' onClick={handleConfirmModal}>Odhlásit se</button>
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
