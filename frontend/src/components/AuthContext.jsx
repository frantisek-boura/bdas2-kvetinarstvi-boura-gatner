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

    const emulate = (userData, opravneni) => {
        localStorage.setItem('emulatingUser', localStorage.getItem('user'));
        localStorage.setItem('emulatingOpravneni', localStorage.getItem('opravneni'));
        localStorage.setItem('user', JSON.stringify(userData));
        localStorage.setItem('opravneni', JSON.stringify(opravneni));
        localStorage.setItem('isEmulating', "true");

        setUser(userData);
        setOpravneni(opravneni);
    }

    const stopEmulate = () => {
        const userData = JSON.parse(localStorage.getItem('emulatingUser'));
        const opravneniData = JSON.parse(localStorage.getItem('emulatingOpravneni'));

        localStorage.setItem('user', localStorage.getItem('emulatingUser'));
        localStorage.setItem('opravneni', localStorage.getItem('emulatingOpravneni'));
        localStorage.removeItem('emulatingUser');
        localStorage.removeItem('emulatingOpravneni');
        localStorage.setItem('isEmulating', "false");

        setUser(userData);
        setOpravneni(opravneniData);
    }

    const login = (userData, opravneni) => {
        setUser(userData);
        setOpravneni(opravneni);
        localStorage.setItem('user', JSON.stringify(userData));
        localStorage.setItem('opravneni', JSON.stringify(opravneni));
    };

    const logout = () => {
        if (JSON.parse(localStorage.getItem('isEmulating')) === true) {
            stopEmulate();
        }

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
        emulate,
        stopEmulate,
        isAuthenticated: !!user,
        isEmulating: JSON.parse(localStorage.getItem('isEmulating')) === true
    };

    return (
        <AuthContext.Provider value={authValue}>
            {!isLoading && children}
        </AuthContext.Provider>
    );
};