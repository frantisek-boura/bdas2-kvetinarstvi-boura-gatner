import React from 'react'
import Logo from '../assets/logo.png';
import UserControls from './UserControls.jsx'
import { Link } from 'react-router-dom';

export default function TopBar({username}) {

    return (
        <>
            <div className='flex-row d-flex justify-content-around align-items-center'>
                <Link to="/"><img className='img-fluid' src={Logo} alt='Logo' /></Link>
                <div>
                    <input type='text' placeholder='Vyhledávat...' />
                    <input type="submit" value="Najít" />
                </div>
                <UserControls username={username} />
            </div>
        </>
    )
};