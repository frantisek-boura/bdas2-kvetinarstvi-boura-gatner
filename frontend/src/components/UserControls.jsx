import React from 'react'
import { Link } from 'react-router-dom'

export default function UserControls({username}) {
    return (
        <div className='d-flex flex-column justify-content-center align-items-center'>
            <div className='text-align-center'>
                {username ?? "Nepřihlášený"}
            </div>
            {
                username ?
                    <div className='d-flex flex-row'>
                        <button>Odhlásit se</button>
                    </div>
                    :
                    <div className='d-flex flex-row'>
                        <Link to="login"><button>Přihlásit se</button></Link>
                        <button>Registrace</button>
                    </div>
            }
        </div>
    )
}
