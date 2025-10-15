import React from 'react'
import Logo from '../assets/logo.png';
import UserControls from './UserControls.jsx'
import { Link } from 'react-router-dom';

export default function TopBar({username}) {

    return (
        <>
            <div className='flex-row d-flex flex-row justify-content-around align-items-center'>
                <Link to="/"><img className='img-fluid' src={Logo} alt='Logo' /></Link>
                <div className='input-group w-25'>
                    <input type='text' className='form-control' placeholder='Vyhledávat...' />
                    <input type="submit" className='btn btn-primary' value="Najít" />
                </div>
                <UserControls username={username} />
            </div>
        </>
    )
};