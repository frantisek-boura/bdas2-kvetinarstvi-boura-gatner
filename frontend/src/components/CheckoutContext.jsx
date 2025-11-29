import axios from 'axios';
import React, { createContext, useContext, useState, useEffect } from 'react';
import { IP } from '../ApiURL';
import { useAuth } from './AuthContext';

const CheckoutContext = createContext(null);

export const useCheckout = () => useContext(CheckoutContext);

export const CheckoutProvider = ({ children }) => {

    const { user, isEmulating } = useAuth();

    const [items, setItems] = useState([]);

    useEffect(() => {
        if (user == null) return;

        const checkoutItems = localStorage.getItem(user.email + 'CheckoutItems');
        if (checkoutItems !== null) {
            setItems(JSON.parse(checkoutItems));
        } else {
            localStorage.getItem(user.email + 'CheckoutItems')
            setItems([]);
        }
    }, [user, isEmulating]);

    const clearKosik = () => {
        localStorage.removeItem(user.email + 'CheckoutItems');
        setItems([]);
    }

    const addItem = (id_kvetina, pocet) => {
        const currentItems = [...items];

        const found = currentItems.find(i => i.id_kvetina == id_kvetina);
        if (found == null) {
            currentItems.push({id_kvetina: id_kvetina, pocet: pocet});
        } else {
            found.pocet += pocet;
        }
        
        localStorage.setItem(user.email + 'CheckoutItems', JSON.stringify(currentItems));
        setItems(currentItems);
    }
    
    const removeItem = (id_kvetina, pocet) => {
        let currentItems = [...items];

        const found = currentItems.find(i => i.id_kvetina == id_kvetina);
        if (found == null) {
            return;
        }         

        let updatedItems;
        if (found.pocet - pocet <= 0) {
            updatedItems = [...currentItems].filter(item => item.id_kvetina !== id_kvetina);
            currentItems = updatedItems;
        } else {
            updatedItems = [...currentItems].map(item => {
                if (item.id_kvetina !== id_kvetina) {
                    return item;
                } else {
                    item.pocet -= pocet;
                    return item;
                }
            })
            currentItems = updatedItems;
        }

        localStorage.setItem(user.email + 'CheckoutItems', JSON.stringify(updatedItems));
        setItems(updatedItems);
    }

    const containsItem = (id_kvetina) => {
        return items.indexOf(items.find(i => i.id_kvetina == id_kvetina)) !== -1;
    }

    const countItems = (id_kvetina) => {
        const item = items.find(i => i.id_kvetina == id_kvetina);
        if (item == null) {
            return 0;
        }

        return item.pocet;
    }

    const checkoutValue = {
        items,
        addItem,
        removeItem,
        containsItem,
        countItems,
        clearKosik
    };

    return (
        <CheckoutContext.Provider value={checkoutValue}>
            {children}
        </CheckoutContext.Provider>
    );

};