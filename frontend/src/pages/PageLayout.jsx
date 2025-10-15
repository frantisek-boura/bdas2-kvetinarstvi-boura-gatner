import React from 'react'
import TopBar from '../components/TopBar.jsx'
import { Routes, Route, Outlet } from 'react-router-dom';

export default function PageLayout({username}) {
    return (
        <>
            <TopBar username={username} />
            <main className='container'>
                <Outlet />
            </main>
        </>
    )
}
