import React from 'react'
import { Link } from 'react-router-dom'

export default function UserControls({username}) {
    return (
        <div className='d-flex flex-column justify-content-center align-items-center'>
            <div className='text-align-center p-1'>
                {username ?? "Nepřihlášený"}
            </div>
            {
                username ?
                    <div className='d-flex flex-row'>
                        <button className='btn btn-primary'>Odhlásit se</button>
                    </div>
                    :
                    <div className='d-flex flex-row'>
                        <Link to="login"><button className='btn btn-primary m-1'>Přihlásit se</button></Link>
                        <Link to="register"><button className='btn btn-primary m-1'>Registrace</button></Link>
                    </div>
            }
        </div>
    )
}
