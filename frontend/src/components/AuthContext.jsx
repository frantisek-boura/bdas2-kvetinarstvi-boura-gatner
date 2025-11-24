import React, { createContext, useContext, useState, useEffect } from 'react';

const AuthContext = createContext(null);

export const useAuth = () => useContext(AuthContext);

export const AuthProvider = ({ children }) => {

    const [user, setUser] = useState(null);
    const [opravneni, setOpravneni] = useState(null);
    const [isLoading, setIsLoading] = useState(true);

    useEffect(() => {
        const storedUser = localStorage.getItem('user');
        const opravneni = localStorage.getItem('opravneni');

        if (storedUser && opravneni) {
            setUser(JSON.parse(storedUser));
            setOpravneni(JSON.parse(opravneni));
        }

        setIsLoading(false);
    }, []);

    const login = (userData, opravneni) => {
        setUser(userData);
        setOpravneni(opravneni);
        localStorage.setItem('user', JSON.stringify(userData));
        localStorage.setItem('opravneni', JSON.stringify(opravneni));
    };

    const logout = () => {
        setUser(null);
        setOpravneni(null);
        localStorage.removeItem('user');
        localStorage.removeItem('opravneni');
    };

    const authValue = {
        user,
        opravneni,
        isLoading,
        login,
        logout,
        isAuthenticated: !!user,
    };

    return (
        <AuthContext.Provider value={authValue}>
            {!isLoading && children}
        </AuthContext.Provider>
    );
};