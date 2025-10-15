import { useState } from 'react'
import PageLayout from './pages/PageLayout.jsx'
import LoginPage from './pages/LoginPage.jsx'
import RegisterPage from './pages/RegisterPage.jsx';
import { Routes, Route } from 'react-router-dom';

export default function App() {

    return (
        <Routes>
            <Route path="/" element={<PageLayout username={null} />} >
                <Route path="login" element={<LoginPage />} />
                <Route path="register" element={<RegisterPage />} />
            </Route>
        </Routes>
    )
};