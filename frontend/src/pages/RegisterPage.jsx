import React from 'react'
import { Link } from 'react-router-dom'

export default function RegisterPage() {
    return (
        <div className='w-50'>
            <form className='m-5'>
                <div className="form-group p-1">
                    <label for="username">Uživatelské jméno</label>
                    <input type="text" className="form-control" id="username" name="username" placeholder="Zadejte uživatelské jméno" />
                </div>
                <div className="form-group p-1">
                    <label for="password">Heslo</label>
                    <input type="password" className="form-control" id="password" name="password" placeholder="Zadejte heslo" />
                </div>
                <div className="form-group p-1">
                    <label for="password2">Heslo znovu</label>
                    <input type="password" className="form-control" id="password2" name="password2" placeholder="Zadejte heslo znovu" />
                </div>
                <div className="form-group p-1">
                    <label for="city">Město</label>
                    <input type="text" className="form-control" id="city" name="city" placeholder="Název města" />
                </div>
                <div className="form-group p-1">
                    <label for="street">Ulice</label>
                    <input type="text" className="form-control" id="street" name="street" placeholder="Název ulice" />
                </div>
                <div className="form-group p-1">
                    <label for="cp">Č.p.</label>
                    <input type="text" className="form-control" id="cp" name="cp" placeholder="Č.p." />
                </div>
                <div className="form-group p-1">
                    <label for="psc">PSČ</label>
                    <input type="text" className="form-control" id="psc" name="psc" placeholder="PSČ" />
                </div>
                <div class="form-check m-1">
                    <input type="checkbox" class="form-check-input" id="tos" />
                    <label class="form-check-label" for="tos">Souhlas se sluvními podmínkami</label>
                </div>
                <button type="submit" className="btn btn-primary m-1">Registrovat</button>
            </form>
        </div>
    )
}
