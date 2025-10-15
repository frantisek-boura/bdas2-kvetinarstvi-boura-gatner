import React from 'react'
import Logo from './assets/logo.png';
import UserControls from './UserControls.jsx'

export default function TopBar({username}) {

    return (
        <>
            <div className='flex-row d-flex justify-content-around align-items-center'>
                <img className='img-fluid' src={Logo} alt='Logo' />
                <div>
                    <input type='text' placeholder='Vyhledávat...' />
                    <input type="submit" value="Najít" />
                </div>
                <UserControls username={username} />
            </div>
        </>
    )
};