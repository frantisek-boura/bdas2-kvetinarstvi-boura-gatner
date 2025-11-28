import React from 'react'
import Logo from '../assets/logo.png';
import UserControls from './UserControls.jsx'
import { Link } from 'react-router-dom';

export default function TopBar() {

    return (
        <>
            <div className='flex-row d-flex flex-row justify-content-around align-items-center'>
                <Link to="/"><img className='img-fluid' src={Logo} alt='Logo' /></Link>
                <UserControls />
            </div>
        </>
    )
};