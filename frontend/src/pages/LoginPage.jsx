import React from 'react'
import { Link } from 'react-router-dom'

export default function LoginPage() {
    return (
        <div className='w-50'>
            <form className='m-5'>
                <div className="form-group p-1">
                    <label for="username">Uživatelské jméno</label>
                    <input type="text" className="form-control" id="username" placeholder="Zadejte uživatelské jméno" />
                </div>
                <div className="form-group p-1">
                    <label for="password">Heslo</label>
                    <input type="password" className="form-control" id="password" placeholder="Zadejte heslo" />
                </div>
                <button type="submit" className="btn btn-primary m-1">Přihlásit</button>
            </form>
        </div>
    )
}
