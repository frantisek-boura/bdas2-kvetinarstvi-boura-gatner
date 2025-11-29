import { StrictMode } from 'react';
import { createRoot } from 'react-dom/client';
import { BrowserRouter } from 'react-router-dom';
import App from './App.jsx';
import 'bootstrap/dist/css/bootstrap.min.css';
import 'bootstrap/dist/js/bootstrap.min.js';
import { AuthProvider } from './components/AuthContext.jsx';
import { ModalProvider } from './components/ModalContext.jsx';
import { ProductsProvider } from './components/ProductsContext.jsx';
import { CheckoutProvider } from './components/CheckoutContext.jsx';

createRoot(document.getElementById('root')).render(
    <StrictMode>
        <BrowserRouter>
            <AuthProvider>
                <CheckoutProvider>
                    <ProductsProvider>
                        <ModalProvider>
                            <App />
                        </ModalProvider>
                    </ProductsProvider>
                </CheckoutProvider>
            </AuthProvider>
        </BrowserRouter>
    </StrictMode>,
)
