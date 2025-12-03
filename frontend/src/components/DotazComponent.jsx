import { useEffect, useState } from "react";
import { useAuth } from "./AuthContext";
import axios from "axios";
import { IP } from "../ApiURL";
import { useModal } from "./ModalContext";
import { flushSync } from "react-dom";


export const DotazComponent = ({dotaz, uzivatele }) => {

    const { user, opravneni } = useAuth()
    const { showModal } = useModal()

    const zodpovezeny = dotaz.odpoved == null;
    const [odpoved, setOdpoved] = useState('');

    const handleOdpoved = () => {
        showModal({
            type: 'confirmation',
            heading: 'Odpovědět',
            message: 'Opravdu chcete odeslat svou odpověď?',
            onConfirm: () => {
                axios.post(
                    IP + "/dotazy/odpoved-na-dotaz", {
                        id_dotaz: dotaz.id_dotaz,
                        odpoved: odpoved,
                        id_odpovidajici_uzivatel: user.id_uzivatel
                    }
                ).then(response => {
                    if (response.data.status_code === 1) {
                        showModal({
                            type: 'info',
                            heading: 'Úspěch',
                            message: response.data.status_message,
                        });
                        dotaz.odpoved = odpoved;
                        dotaz.id_odpovidajici_uzivatel = user.id_uzivatel;
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
                        heading: 'Chyba',
                        message: 'Server je nedostupný'
                    });
                });
            }
        });
    }

    return (
        <li className="list-group-item list-group-item-action">
            <p className='fw-bold'>{dotaz.text}</p>
            { zodpovezeny ?
                <>
                    {(opravneni !== null && opravneni.uroven_opravneni !== 0) &&
                    <>
                        <textarea onChange={(e) => setOdpoved(e.target.value)} className='form-control'></textarea>
                        <button onClick={handleOdpoved} type='button' disabled={odpoved.trim().length === 0} className='btn btn-primary my-2'>Odpovědět</button>
                    </>
                    }
                </>
                : 
                <>
                <span className='fw-bold'>{uzivatele.filter(u => u.id_uzivatel === dotaz.id_odpovidajici_uzivatel)[0].email} odpovídá:</span>
                <p>{dotaz.odpoved}</p>
                </>
            }
            
        </li>
    )
}