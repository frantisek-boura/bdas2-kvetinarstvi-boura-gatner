import axios from 'axios'
import { useState } from 'react'
import { IP } from '../ApiURL'
import { useAuth } from '../components/AuthContext'
import { useModal } from '../components/ModalContext'
import { validateEmail } from '../components/validators';

export default function LoginPage() {

    const { login, isAuthenticated } = useAuth();
    const { showModal, hideModal, modalState } = useModal();

    const [email, setEmail] = useState(null);
    const [error, setError] = useState(false);
    const [buttonDisabled, setButtonDisabled] = useState(true);

    const handleEmailChange = (event) => {
        const newValue = event.target.value;
        setEmail(newValue);

        const validationError = validateEmail(newValue);
        setError(validationError);

        setButtonDisabled(!(!!validationError));
    };

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


    const handleLogin = (e) => {
        e.preventDefault();

        const formData = new FormData(e.target);
        
        if (!formData.get('email').trim() || !formData.get('password').trim()) {
            handleShowError("Prosím zadejte e-mail a heslo.");
            return;
        }

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
                    handleShowInfo('Úspěch', response.data.status_message);
                } else {
                    handleShowowError('Chyba', response.data.status_message);
                }
            }).catch(error => {
                handleShowError('Chyba', "Server je nedostupný");
            })

        }).catch(error => {
            handleShowError('Chyba', "Server je nedostupný");
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
                            <input type="text" className="form-control" id="email" name="email" placeholder="Zadejte e-mail" onChange={handleEmailChange} aria-invalid={!!error}/>
                            {error && <p style={{ color: 'red' }}>{error}</p>}
                        </div>
                        <div className="form-group p-1">
                            <label htmlFor="password">Heslo</label>
                            <input type="password" className="form-control" id="password" name="password" placeholder="Zadejte heslo" />
                        </div>
                        <button type="submit" className="btn btn-primary m-1" disabled={!!error}>Přihlásit</button>
                    </form>
            }
        </div>
    )
}
