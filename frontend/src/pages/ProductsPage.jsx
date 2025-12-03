import React, { useEffect, useMemo, useState } from 'react'
import { useProducts } from '../components/ProductsContext'
import CategoryItem from '../components/CategoryItem';
import { useCheckout } from '../components/CheckoutContext';
import axios from 'axios';
import { IP } from '../ApiURL';
import { useAuth } from '../components/AuthContext';
import { DotazComponent } from '../components/DotazComponent';
import { useModal } from '../components/ModalContext';

export default function ProductsPage() {
    
    const { showModal } = useModal();
    const { user, opravneni } = useAuth();
    const { products, categories, images, filterByCategory, defaults } = useProducts();
    const { items, addItem, removeItem, containsItem, countItems } = useCheckout();

    const [uzivatele, setUzivatele] = useState([]);
    const [dotazy, setDotazy] = useState([]);
    const [filters, setFilters] = useState({
        cheap: true,
        expensive: false,
        from: 0,
        to: 0,
        name: ''
    });

    const [area, setArea] = useState('');
    const [filteredProducts, setFilteredProducts] = useState([]);

    const buildCategoryTree = (data) => {
        const map = {};
        const tree = [];

        data.forEach(item => {
            const clonedItem = JSON.parse(JSON.stringify(item));
            clonedItem.children = [];
            map[clonedItem.id_kategorie] = clonedItem;
        });

        data.forEach(item => {
            const itemInMap = map[item.id_kategorie];
            const parentId = item.id_nadrazene_kategorie;

            if (parentId !== null && map[parentId]) {
                map[parentId].children.push(itemInMap);
            } else {
                tree.push(itemInMap);
            }
        });

        return tree;
    }

    const filter = () => {
        let sorted = [...products];

        if (filters.cheap) {
            sorted.sort((a, b) => a.cena - b.cena);
        } else {
            sorted.sort((a, b) => b.cena - a.cena);
        }

        let filtered = [...sorted];

        filtered = filtered.filter(p => {
            let fits = true;

            if (filters.from != 0) {
                fits = fits && p.cena >= filters.from;
            }

            if (filters.to != 0) {
                fits = fits && p.cena <= filters.to;
            }

            if (filters.name != '') {
                fits = fits && p.nazev.toLowerCase().includes(filters.name.toLowerCase());
            }

            return fits;
        });

        
        return filtered;
    }

    const resetFilters = () => {
        defaults();

        setFilters({
            cheap: true,
            expensive: false,
            from: 0,
            to: 0,
            name: ''
        });
    }

    const handlePodatDotaz = () => {
        showModal({
            type: 'confirmation',
            heading: 'Podat dotaz',
            message: 'Opravdu chcete podat dotaz?',
            onConfirm: () => {
                axios.post(IP + "/dotazy/pridat-dotaz", {
                    text: area,
                }).then(response => {
                    if (response.data.status_code === 1) {
                        const dotaz = response.data.value;
                        showModal({
                            type: 'info',
                            heading: 'Úspěch',
                            message: response.data.status_message,
                        });
                        setDotazy([dotaz, ...dotazy]);
                    } else {
                        showModal({
                            type: 'error',
                            heading: 'Chyba',
                            message: response.data.status_message,
                        });
                    }
                }).catch(error => {
                    showModal({
                        type: 'error',
                        heading: 'Chyba',
                        message: 'Server je nedostupný',
                    });
                })
            }
        });
    }

    useEffect(() => {
        axios.get(
            IP + "/dotazy"
        ).then(response => {
            response.data.sort((a, b) => new Date(a.datum_podani) - new Date(b.datum_podani));
            setDotazy(response.data);
            return axios.get(IP + "/uzivatele");
        }).then(response => {
            setUzivatele(response.data);
        });
    }, []);

    useEffect(() => {
        const filtered = filter();
        setFilteredProducts(filtered);
    }, [filters, products, categories, images, items, dotazy]);

    return (
        <div className='d-flex flex-row justify-content-start w-100'>
            <div className='d-flex flex-column flex-nowrap w-25 mx-5'>
                <div className="card">
                    <div className="card-header bg-primary text-white">
                        <h5>Kategorie</h5>
                    </div>
                    <ul className="list-group list-group-flush">
                        {buildCategoryTree(categories).map((category) => (
                            <CategoryItem
                                key={category.id_kategorie}
                                category={category}
                                level={0}
                                filterHandler={filterByCategory}
                            />
                        ))}
                    </ul>
                </div>
                <div className='card my-3'>
                    <div className="card-header bg-primary text-white">
                        <h5>Dotazy</h5>
                    </div>
                    <ul className="list-group list-group-flush">
                        { (opravneni === null || opravneni.uroven_opravneni === 0) && 
                            <li className="list-group-item list-group-item-action">
                                <p className='fw-bold'>Zanechat dotaz</p>
                                <textarea onChange={(e) => setArea(e.target.value)} className='form-control'></textarea>
                                <button onClick={handlePodatDotaz} disabled={area.length === 0} type='button' className='btn btn-primary my-2'>Odeslat</button>
                            </li>
                        }
                        {dotazy.filter((d) => d.verejny === true).map((d, i) => {
                            if (uzivatele.length === 0 ) {
                                return;
                            }

                            return (
                                <DotazComponent key={d.id_dotaz} dotaz={d} uzivatele={uzivatele} />
                            )
                        })}
                    </ul>
                </div>
            </div>
            <div className='d-flex flex-column flex-nowrap w-75'>
                <h1>Květiny</h1>
                <div className='d-flex flex-row flex-nowrap justify-content-around'>
                    <input type='text' className='form-control' style={{width: '10em'}} onChange={(e) => {setFilters(prevFilters => ({...prevFilters, name: e.target.value.trim()}))}} placeholder='Vyhledávat...' />
                    <button type="button" className='btn btn-secondary' onClick={() => {setFilters(prevFilters => ({...prevFilters, cheap: true, expensive: false}))}} disabled={filters.cheap === true}>Nejlevnější</button>
                    <button type="button" className='btn btn-secondary' onClick={() => {setFilters(prevFilters => ({...prevFilters, cheap: false, expensive: true}))}} disabled={filters.expensive === true}>Nejdražší</button>
                    <span className='d-flex flex-row flex-nowrap justify-content-between align-items-center'>Cena od: <input type="number" className='form-control mx-2' onChange={(e) => {setFilters(prevFilters => ({...prevFilters, from: Number(e.target.value)}))}} min={0} style={{width: '7em'}}/></span>
                    <span className='d-flex flex-row flex-nowrap justify-content-between align-items-center'>Cena do: <input type="number" className='form-control mx-2' onChange={(e) => {setFilters(prevFilters => ({...prevFilters, to: Number(e.target.value)}))}} min={0} style={{width: '7em'}}/></span>
                    <button type="button" className='btn btn-danger' onClick={resetFilters}>Zrušit filtry</button>
                </div>
                <div className='d-flex flex-row flex-wrap'>
                    {filteredProducts.length === 0 && <div className='m-3 p-3 d-flex flex-column flex-nowrap justify-content-center align-items-start'><h1>Filtrům neodpovídají žádné položky</h1></div>}
                    {filteredProducts.map((p, i) => {
                        const image = images.filter(i => i.id_obrazek == p.id_obrazek)[0];
                        let data = '';
                        let alt = '';
                        if (image != null) {
                            const mimeTypeMap = {
                                'png': 'image/png',
                                'jpg': 'image/jpeg',
                                'jpeg': 'image/jpeg',
                                'gif': 'image/gif',
                                'svg': 'image/svg+xml',
                                'webp': 'image/webp',
                                'bmp': 'image/bmp',
                                'ico': 'image/x-icon'
                            };

                            const parts = image.nazev_souboru.toLowerCase().split('.');
                            const extension = parts.pop();

                            const mimeType = mimeTypeMap[extension];

                            data = `data:${mimeType};base64,` + image.base64;
                            alt = image.nazev_souboru;
                        }

                        let categoryName = '';
                        if (categories.length != 0) {
                            categoryName = categories.filter(k => k.id_kategorie == p.id_kategorie)[0].nazev;
                        }

                        return (
                            <div key={i} style={{height: '30em'}} className='w-25 m-3 p-3 d-flex flex-column flex-nowrap text-center justify-content-between align-items-center'>
                                <h5 style={{height: '2em'}}>{p.nazev}</h5>
                                <span>Kategorie: {categoryName}</span>
                                <div className='ratio ratio-1x1'>
                                    <img src={data === '' ? null : data} alt={alt} className='img-thumbnail' />
                                </div>
                                <span>{p.cena} Kč</span>
                                <button onClick={() => addItem(p.id_kvetina, 1)} type="button" className='m-1 btn btn-primary'>Přidat do košíku {countItems(p.id_kvetina) !== 0 && <>({countItems(p.id_kvetina)})</>}</button>
                                <button onClick={() => removeItem(p.id_kvetina, 1)} disabled={containsItem(p.id_kvetina) === false} type="button" className='m-1 btn btn-danger'>Odebrat z košíku</button>
                            </div>
                        )
                    })}
                </div>
            </div>
        </div>
    );
}
