import React from 'react'
import Logo from '../assets/logo.png';
import UserControls from './UserControls.jsx'
import { Link } from 'react-router-dom';
import { useAuth } from './AuthContext.jsx';

export default function TopBar() {

    const { isAuthenticated, opravneni } = useAuth();

    return (
        <>
            <div style={{margin: 'auto'}} className='p-2 flex-row d-flex flex-row justify-content-around align-items-center w-75'>
                <div className='d-flex w-50 justify-content-center'>
                    <span className='d-flex flex-row mx-5'><Link to="/"><img className='img-fluid mx-5' src={Logo} alt='Logo' style={{height: '4em', width: '4em'}} /></Link><h3>Květinka</h3></span>
                    <Link to="/"><button type='button' className='btn btn-primary mx-1'>Domovská stránka</button></Link>
                    { (isAuthenticated && opravneni.uroven_opravneni !== 0) &&
                        <Link to="/dashboard"><button type='button' className='btn btn-success'>Dashboard</button></Link>
                    }
                </div>
                <UserControls />
            </div>
        </>
    )
};