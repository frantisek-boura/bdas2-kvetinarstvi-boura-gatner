import React from 'react'
import Logo from '../assets/logo.png'

export default function ProfilePage({username}) {

    if (username == null) {
        return (<h1>Nejste přihlášeni</h1>)
    }

    return (
        <div className='d-flex flex-row'>
            <div className='d-flex flex-column align-items-start mx-2'>
                <div className='d-flex flex-column align-items-center justify-content-center'>
                    <h1>{username}</h1>
                    <div className='ratio ratio-1x1'>
                        <img src={Logo} alt="Profilový obrázek" className='img-thumbnail' />
                    </div>
                    <button className='btn btn-primary m-1'>Změnit obrázek</button>
                </div>
                <div className='d-flex flex-column align-items-stat'>
                    <form className=''>
                        <div className="form-group py-1">
                            <label for="password">Nové heslo</label>
                            <input type="password" className="form-control" id="password" name="password" placeholder="Zadejte heslo" />
                        </div>
                        <div className="form-group py-1">
                            <label for="password2">Nové heslo znovu</label>
                            <input type="password" className="form-control" id="password2" name="password2" placeholder="Zadejte heslo znovu" />
                        </div>
                        <button type="submit" className="btn btn-primary m-1">Změnit heslo</button>
                    </form>
                </div>
            </div>
            <div className='d-flex flex-column align-items-start mx-2'>
                <form className=''>
                    <div className="form-group py-1">
                        <label for="street">Ulice</label>
                        <input type="text" className="form-control" id="street" name="street" placeholder="Název ulice" />
                    </div>
                    <div className="form-group py-1">
                        <label for="cp">Č.p.</label>
                        <input type="text" className="form-control" id="cp" name="cp" placeholder="Č.p." />
                    </div>
                    <div className="form-group py-1">
                        <label for="psc">PSČ</label>
                        <input type="text" className="form-control" id="psc" name="psc" placeholder="PSČ" />
                    </div>
                    <button type="submit" className="btn btn-primary m-1">Změnit adresu</button>
                </form>
            </div>
        </div>
    )
}
