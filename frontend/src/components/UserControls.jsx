import React from 'react'
import { Link, useParams } from 'react-router-dom'

export default function UserControls({username}) {

    return (
        <div className='d-flex flex-row justify-content-center align-items-center'>
            { username && <Link to="/checkout"><button className='btn btn-secondary m-1'>Košík</button></Link> }
            <div className='d-flex flex-column justify-content-center align-items-center'>
                <div className='text-align-center p-1'>
                    {
                        username ?
                            <div className='d-flex flex-row'>
                                <p className='align-middle m-1'>{username}</p>
                            </div>
                            :
                            <p className='align-middle m-1'>Nepřihlášený</p>
                    }
                </div>
                {
                    username ?
                        <div className='d-flex flex-row'>
                            <Link to='/profile'><button className='btn btn-primary m-1'>Profil</button></Link>
                            <button className='btn btn-danger m-1'>Odhlásit se</button>
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
