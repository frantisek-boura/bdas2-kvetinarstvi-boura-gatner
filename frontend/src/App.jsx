import { useState } from 'react'
import PageLayout from './pages/PageLayout.jsx'
import LoginPage from './pages/LoginPage.jsx'
import RegisterPage from './pages/RegisterPage.jsx';
import ProfilePage from './pages/ProfilePage.jsx';
import ProductsPage from './pages/ProductsPage.jsx';
import CheckoutPage from './pages/CheckoutPage.jsx';
import { Routes, Route } from 'react-router-dom';

export default function App() { 

    const uzivatel = "Uživatel"
    
    // api calls na backend pro data

    return (
        <Routes>
            <Route path="/" element={<PageLayout username={uzivatel} />} >
                <Route path="" element={<ProductsPage />} />
                <Route path="checkout" element={<CheckoutPage />} />
                <Route path="login" element={<LoginPage />} />
                <Route path="register" element={<RegisterPage />} />
                <Route path="profile" element={<ProfilePage username={uzivatel} />} />
            </Route>
        </Routes>
    )
};