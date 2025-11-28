import axios from 'axios';
import React, { createContext, useContext, useState, useEffect } from 'react';
import { IP } from '../ApiURL';

const ProductsContext = createContext(null);

export const useProducts = () => useContext(ProductsContext);

export const ProductsProvider = ({ children }) => {

    const [products, setProducts] = useState([]);
    const [categories, setCategories] = useState([]);

    const defaults = () => {
        axios.get(IP + "/kvetiny")
        .then(response => {
            setProducts(response.data);
            return axios.get(IP + "/kategorie");
        }).then(response => {
            setCategories(response.data);
        });
    }

    useEffect(() => {
        defaults();
    }, []);

    const filterByCategory = (id) => {
        axios.get(IP + "/kvetiny/podle-kategorie/" + id)
        .then(response => {
            setProducts(response.data);
        }).catch(error => {
            //...
        });
    }

    const productsValue = {
        products,
        categories,
        filterByCategory,
        defaults
    };

    return (
        <ProductsContext.Provider value={productsValue}>
            {children}
        </ProductsContext.Provider>
    );

};