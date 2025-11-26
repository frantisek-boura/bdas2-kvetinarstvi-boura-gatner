import React, { useEffect } from 'react';
import { useNavigate } from 'react-router-dom';

const Modal = ({ type, heading, message, redirectPath, onClose, onConfirm }) => {

    const navigate = useNavigate();

    const typeClasses = {
        success: 'alert-success text-success',
        error: 'alert-danger text-danger',
        warning: 'alert-warning text-warning',
        info: 'alert-info text-info',
        confirmation: 'alert-primary text-primary',
    };

    const alertClass = typeClasses[type] || typeClasses.info;

    useEffect(() => {
        if (type !== 'info') {
            return;
        }

        let timer;
        timer = setTimeout(() => {
            onClose();

            if (redirectPath) {
                navigate(redirectPath, { replace: true });
            }
        }, 1500);

        return () => {
            if (timer) {
                clearTimeout(timer);
            }
        };
    }, [redirectPath, onClose, navigate, type]);

    const handleConfirm = () => {
        if (onConfirm) {
            onConfirm();
        }
        onClose();
    };

    return (
        <div
            className="modal show d-block"
            tabIndex="-1"
            role="dialog"
            style={{ backgroundColor: 'rgba(0, 0, 0, 0.5)' }}
            aria-modal="true"
        >
            <div className="modal-dialog modal-dialog-centered" role="document">
                <div className="modal-content">

                    <div className={`modal-header ${alertClass}`}>
                        <h5 className="modal-title">{heading}</h5>
                    </div>

                    <div className="modal-body">
                        <p>{message}</p>
                        {redirectPath && type === 'info' && <small className="text-muted">Budete přesměrováni...</small>}
                        
                        {type === 'confirmation' ? (
                            <div className="d-flex justify-content-end">
                                <button type="button" className='btn btn-secondary me-2' onClick={onClose}>Zrušit</button>
                                <button type="button" className='btn btn-primary' onClick={handleConfirm}>Potvrdit</button>
                            </div>
                        ) : type !== 'info' ? (
                            <button type="button" className='btn btn-danger' onClick={onClose}>Zavřít</button>
                        ) : null}
                    </div>
                </div>
            </div>
        </div>
    );
};

export default Modal;