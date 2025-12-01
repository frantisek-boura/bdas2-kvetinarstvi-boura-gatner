import { useState } from "react";
import { useAuth } from "../components/AuthContext"
import { MestoPage } from "../dashboardPages/MestoPage";
import { UlicePage } from "../dashboardPages/UlicePage";
import { PscPage } from "../dashboardPages/PscPage";
import { AdresaPage } from "../dashboardPages/AdresaPage";
import { KategoriePage } from "../dashboardPages/KategoriePage";
import { OpravneniPage } from "../dashboardPages/OpravneniPage";
import { StavObjednavkyPage } from "../dashboardPages/StavyObjednavekPage";
import { ZpusobPlatbyPage } from "../dashboardPages/ZpusobyPlatebPage";
import { ObrazekPage } from "../dashboardPages/ObrazekPage";
import { UzivatelPage } from "../dashboardPages/UzivatelPage";


export const DashboardPage = () => {

    const { isAuthenticated, opravneni } = useAuth();

    const [Page, setPage] = useState(<AdresaPage />);

    if (!isAuthenticated) {
        return <h1>Nejste přihlášeni</h1>
    }

    if (opravneni.uroven_opravneni === 0) {
        return <h1>Nemáte dostatečné oprávnění pro vstup</h1>
    }

    return (
        <div className="d-flex flex-row flex-nowrap w-100 m-4">
            <div className="w-25">
                <ul className="card list-group list-group-flush">
                    <li className="card-header bg-primary text-white bg-primary list-group-item list-group-item-action">
                        <h1>Dashboard</h1>
                    </li>
                    <li onClick={() => setPage(<AdresaPage />)} className="card-header list-group-item list-group-item-action">
                        Adresy
                    </li>
                    <li className="card-header list-group-item list-group-item-action">
                        Dotazy
                    </li>
                    <li onClick={() => setPage(<KategoriePage />)} className="card-header list-group-item list-group-item-action">
                        Kategorie
                    </li>
                    <li className="card-header list-group-item list-group-item-action">
                        Košíky
                    </li>
                    <li className="card-header list-group-item list-group-item-action">
                        Květiny 
                    </li>
                    <li className="card-header list-group-item list-group-item-action">
                        Položky v košících 
                    </li>
                    <li onClick={() => setPage(<MestoPage />)} className="card-header list-group-item list-group-item-action">
                        Města 
                    </li>
                    <li onClick={() => setPage(<ObrazekPage />)} className="card-header list-group-item list-group-item-action">
                        Obrázky 
                    </li>
                    {opravneni.uroven_opravneni == 2 &&
                    <li onClick={() => setPage(<OpravneniPage />)} className="card-header list-group-item list-group-item-action">
                        Oprávnění 
                    </li>
                    }
                    <li onClick={() => setPage(<PscPage />)} className="card-header list-group-item list-group-item-action">
                        PSČ
                    </li>
                    {opravneni.uroven_opravneni == 2 &&
                    <li onClick={() => setPage(<StavObjednavkyPage />)} className="card-header list-group-item list-group-item-action">
                        Stavy objednávek 
                    </li>
                    }
                    <li onClick={() => setPage(<UlicePage />)} className="card-header list-group-item list-group-item-action">
                        Ulice
                    </li>
                    {opravneni.uroven_opravneni == 2 &&
                    <li onClick={() => setPage(<UzivatelPage />)} className="card-header list-group-item list-group-item-action">
                        Uživatelé
                    </li>
                    }
                    {opravneni.uroven_opravneni == 2 &&
                    <li onClick={() => setPage(<ZpusobPlatbyPage />)} className="card-header list-group-item list-group-item-action">
                        Způsoby plateb
                    </li>
                    }
                </ul>
            </div>
            <div className="w-75">
                { Page !== null && Page}
            </div>
        </div>
    )
}
