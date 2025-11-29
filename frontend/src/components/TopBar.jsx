import React from 'react'
import Logo from '../assets/logo.png';
import UserControls from './UserControls.jsx'
import { Link } from 'react-router-dom';

export default function TopBar() {

    return (
        <>
            <div style={{margin: 'auto'}} className='p-2 flex-row d-flex flex-row justify-content-around align-items-center w-75'>
                <div className='d-flex w-50 justify-content-center'>
                    <Link to="/"><img className='img-fluid' src={Logo} alt='Logo' /></Link>
                </div>
                <UserControls />
            </div>
        </>
    )
};