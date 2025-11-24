import axios from 'axios'
import React from 'react'
import { IP } from '../ApiURL'
import { Link, useNavigate } from 'react-router-dom'
import { useAuth } from '../components/AuthContext'
import { useModal } from '../components/ModalProvider'

export default function LoginPage({setUser}) {

    const { login, isAuthenticated } = useAuth();

    const { showModal } = useModal();

    const handleShowSuccess = (status_message) => {
        showModal({
            type: 'success',
            heading: 'Úspěch',
            message: status_message,
            redirectPath: '/',
        });
    };

    const handleShowError = (status_message) => {
        showModal({
            type: 'error',
            heading: 'Login Failed',
            message: status_message,
        });
    };


    const handleLogin = (e) => {
        e.preventDefault();

        const formData = new FormData(e.target);

        axios.post(
            IP + "/uzivatele/login", {
                email: formData.get('email'),
                heslo: formData.get('password')
            }
        ).then(response => {

            const userData = response.data.value;
            
            axios.get(
                IP + "/opravneni/" + userData.id_opravneni
            ).then(response2 => {
                const opravneni = response2.data

                login(userData, opravneni);

                if (response.data.status_code == 1) {
                    handleShowSuccess(response.data.status_message);
                } else {
                    handleShowError(response.data.status_message);
                }
            })

        }).catch(error => {
            handleShowError(error);
        });
    }

    return (
        <div className='w-50'>
            {
                isAuthenticated ?
                    <div>
                        <h2>Už jste přihlášeni</h2>
                    </div>
                :
                    <form className='m-5' onSubmit={handleLogin}>
                        <div className="form-group p-1">
                            <label htmlFor="email">E-mail</label>
                            <input type="text" className="form-control" id="email" name="email" placeholder="Zadejte e-mail" />
                        </div>
                        <div className="form-group p-1">
                            <label htmlFor="password">Heslo</label>
                            <input type="password" className="form-control" id="password" name="password" placeholder="Zadejte heslo" />
                        </div>
                        <button type="submit" className="btn btn-primary m-1">Přihlásit</button>
                    </form>
            }
        </div>
    )
}
