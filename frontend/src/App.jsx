import { useEffect, useState } from 'react'
import PageLayout from './pages/PageLayout.jsx'
import LoginPage from './pages/LoginPage.jsx'
import RegisterPage from './pages/RegisterPage.jsx';
import ProfilePage from './pages/ProfilePage.jsx';
import ProductsPage from './pages/ProductsPage.jsx';
import CheckoutPage from './pages/CheckoutPage.jsx';
import { Routes, Route, Router } from 'react-router-dom';
import { DashboardPage } from './pages/DashboardPage.jsx';

export default function App() { 

    return (
        <Routes>
            <Route path="/" element={<PageLayout />} >
                <Route path="" element={<ProductsPage />} />
                <Route path="dashboard" element={<DashboardPage />} />
                <Route path="checkout" element={<CheckoutPage />} />
                <Route path="login" element={<LoginPage />} />
                <Route path="register" element={<RegisterPage />} />
                <Route path="profile" element={<ProfilePage />} />
            </Route>
        </Routes>
    )
};