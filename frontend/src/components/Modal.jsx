import React, { useEffect } from 'react';
import { useNavigate } from 'react-router-dom';

const Modal = ({ type, heading, message, redirectPath, onClose }) => {

    const navigate = useNavigate();

    const typeClasses = {
        success: 'alert-success text-success',
        error: 'alert-danger text-danger',
        warning: 'alert-warning text-warning',
        info: 'alert-info text-info',
    };

    const alertClass = typeClasses[type] || typeClasses.info;

    useEffect(() => {
        let timer;
        if (redirectPath) {
            timer = setTimeout(() => {
                onClose();

                navigate(redirectPath, { replace: true });
            }, 3000);
        }

        return () => {
            if (timer) {
                clearTimeout(timer);
            }
        };
    }, [redirectPath, onClose]);

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
                        {redirectPath && <small className="text-muted">Budete přesměrováni...</small>}
                    </div>
                </div>
            </div>
        </div>
    );
};

export default Modal;