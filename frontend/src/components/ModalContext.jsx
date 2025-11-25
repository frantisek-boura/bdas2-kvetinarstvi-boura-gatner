import { createContext, useContext, useState } from 'react';
import Modal from './Modal';

const ModalContext = createContext();

export const ModalProvider = ({ children }) => {
 
    const [modalState, setModalState] = useState({
        isVisible: false,
        type: 'info',
        heading: '',
        message: '',
        redirectPath: null,
        onConfirm: null,
    });

    const showModal = ({ type, heading, message, redirectPath = null, onConfirm = null }) => { 
        setModalState({
            isVisible: true,
            type,
            heading,
            message,
            redirectPath,
            onConfirm,
        });
    };

    const hideModal = () => {
        setModalState(prev => ({ ...prev, isVisible: false, onConfirm: null })); 
    };

    const contextValue = {
        showModal,
        hideModal,
        modalState
    };

    return (
        <ModalContext.Provider value={contextValue}>
            {children}
            {modalState.isVisible && (
                <Modal
                    type={modalState.type}
                    heading={modalState.heading}
                    message={modalState.message}
                    redirectPath={modalState.redirectPath}
                    onClose={hideModal}
                    onConfirm={modalState.onConfirm}
                />
            )}
        </ModalContext.Provider>
    );
};

export const useModal = () => {
    return useContext(ModalContext);
};