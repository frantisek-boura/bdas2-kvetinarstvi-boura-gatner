import React from 'react'
import Logo from '../assets/logo.png'

export default function ProfilePage({username}) {

    if (username == null) {
        return (<h1>Nejste přihlášeni</h1>)
    }

    return (
        <div className='d-flex flex-row w-75 m-5'>
            <div className='d-flex flex-column align-items-start m-2'>
                <div className='d-flex flex-column justify-content-center mx-2 w-100'>
                    <h1>{username}</h1>
                    <h5>Role</h5>
                </div>
                <div className='d-flex flex-column align-items-center justify-content-center'>
                    <div className='ratio ratio-1x1'>
                        <img src={Logo} alt="Profilový obrázek" className='img-thumbnail' />
                    </div>
                    <button className='btn btn-primary m-1'>Změnit obrázek</button>
                </div>
                <div className='d-flex flex-column align-items-stat my-2'>
                    <h3>Změna hesla</h3>
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
            <div className='d-flex flex-column justify-content-center m-2'>
                <h3>Doručovací adresa</h3>
                <form className=''>
                    <div className="form-group p-1">
                        <label for="city">Město</label>
                        <input type="text" className="form-control" id="city" name="city" placeholder="Název města" />
                    </div>
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
            <div className='d-flex flex-column mx-2 w-50'>
                <h3>Historie objednávek</h3>
                <div className='d-flex flex-column'>
                    <div className='d-flex flex-row justify-content-between'>
                        <p className='bg-success text-white rounded p-1 m-1'>Vyřízena</p>
                        <p className='bg-danger text-white rounded p-1 m-1'>Zrušena</p>
                        <p className='bg-warning text-white rounded p-1 m-1'>Čeká na zaplacení</p>
                        <p className='bg-info text-white rounded p-1 m-1'>Na cestě</p>
                    </div>
                </div>
                <div className='d-flex flex-column bg-success rounded m-1 p-1 text-white w-100'>
                    <div className='d-flex flex-row justify-content-between'>
                        <h5 className='mx-2'>16.10.2025</h5>
                        <h5 className='mx-2'>650 Kč</h5>
                    </div>
                    <div className='d-flex justify-content-between align-items-center m-1 p-1'>
                        <span>Způsob platby</span>
                        <span>Kartou</span>
                    </div>

                    <div className='d-flex flex-column justify-content-between m-1 px-1'>
                        <span>Položky</span>
                        <ul className='list-group'>
                            <li className='d-flex justify-content-between align-items-center px-3 py-1'>
                                <span>Květina</span>
                                <span>10x</span>
                                <span>300 Kč</span>
                            </li>
                            <li className='d-flex justify-content-between align-items-center px-3 py-1'>
                                <span>Květina</span>
                                <span>3x</span>
                                <span>250 Kč</span>
                            </li>
                            <li className='d-flex justify-content-between align-items-center px-3 py-1'>
                                <span>Květina</span>
                                <span>5x</span>
                                <span>100 Kč</span>
                            </li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    )
}
