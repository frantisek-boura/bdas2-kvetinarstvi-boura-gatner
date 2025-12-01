import axios from "axios";
import { useEffect, useState } from "react";
import { IP } from "../ApiURL";
import { useModal } from "../components/ModalContext";

const convertBase64ToSrc = (nazev_souboru, base64) => {
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

    const parts = nazev_souboru.toLowerCase().split('.');
    const extension = parts.pop();

    const mimeType = mimeTypeMap[extension];

    return `data:${mimeType};base64,` + base64;
}

function convertFileToBase64(file) {
  return new Promise((resolve, reject) => {
    if (!file) {
      reject(new Error("No file provided for conversion."));
      return;
    }

    const reader = new FileReader();

    reader.onload = () => {
      const dataURL = reader.result;
      const base64String = dataURL.split(',')[1];
      
      resolve(base64String);
    };

    reader.onerror = (error) => {
      reject(error);
    };

    reader.readAsDataURL(file);
  });
}

const ObrazekData = (props) => {

    const { showModal } = useModal();

    const [img, setImg] = useState(null);

    const [base64, setBase64] = useState(props.base64);

    useEffect(() => {
        if (img === null) {
            return;
        }

        convertFileToBase64(img).then(response => {
            setBase64(response);
        });
    }, [img]);

    const upravitData = () => {
        if (img == null) {
            showModal({
                type: 'error',
                heading: 'Chyba',
                message: 'Nebyl vybrán žádný obrázek',
            });
            return;
        }

        showModal({
            type: 'confirmation',
            heading: 'Upravit data',
            message: 'Opravdu chcete upravit data?',
            onConfirm: () => {
                axios.put(IP + "/obrazky",
                    {
                        id_obrazek: props.id_obrazek,
                        nazev_souboru: img?.name,
                        base64: base64
                    }
                ).then(response => {
                    if (response.data.status_code == 1) {
                        showModal({
                            type: 'info',
                            heading: 'Úspěch',
                            message: response.data.status_message
                        });
                        props.onRefresh();
                    } else {
                        showModal({
                            type: 'error',
                            heading: 'Chyba',
                            message: response.data.status_message
                        });
                    }
                }).catch(error => {
                    showModal({
                        type: 'error',
                        heading: 'Chyba',
                        message: 'Server je nedostupný'
                    });
                });
            }
        });
    }

    const smazatData = () => {
        showModal({
            type: 'confirmation',
            heading: 'Smazat data',
            message: 'Opravdu chcete smazat data?',
            onConfirm: () => {
                axios.delete(
                    IP + "/obrazky/" + props.id_obrazek 
                ).then(response => {
                    if (response.data.status_code == 1) {
                        showModal({
                            type: 'info',
                            heading: 'Úspěch',
                            message: response.data.status_message 
                        });
                        props.onRefresh();
                    } else {
                        showModal({
                            type: 'error',
                            heading: 'Chyba',
                            message: response.data.status_message 
                        });
                    }
                }).catch(error => {
                    showModal({
                        type: 'error',
                        heading: 'Chyba',
                        message: 'Server je nedostupný'
                    });
                })
            }
        });
    }

    return <li className="d-flex flex-row justify-content-between list-group-item list-group-item-action w-100">
        {img !== null && 
        <>
            <img src={base64 !== null ? convertBase64ToSrc(img.name, base64) : null} className='img-thumbnail' style={{width: '4em', height: '4em'}}/>
            <p>{img.name}</p>
        </>
        }
        {img === null &&
        <>
            <img src={convertBase64ToSrc(props.nazev_souboru, props.base64)} className='img-thumbnail' style={{width: '4em', height: '4em'}}/>
            <p>{props.nazev_souboru}</p>
        </>
        }
        <div className="mb-3">
            <input id="file" onChange={(e) => setImg(e.target.files[0])} type="file" accept="image/*" className='m-2 form-control' />
        </div>
        <div>
            <button onClick={upravitData} type="button" className="btn btn-primary mx-2">Upravit</button>
            <button onClick={smazatData} type="button" className="btn btn-danger mx-2">Smazat</button>
        </div>
    </li>
}

export const ObrazekPage = () => {

    const { showModal } = useModal();

    const [data, setData] = useState([]);
    const [img, setImg] = useState(null);

    const [base64, setBase64] = useState(null);
    const [nazevSouboru, setNazevSouboru] = useState('');

    useEffect(() => {
        if (img === null) {
            return;
        }

        convertFileToBase64(img).then(response => {
            setBase64(response);
            setNazevSouboru(img.name);
        });
    }, [img]); 

    const fetchData = () => {
        axios.get(IP + "/obrazky").then(response => setData(response.data));
    }

    useEffect(() => {
        fetchData();
    }, []);

    const vytvoritData = () => {
        showModal({
            type: 'confirmation',
            heading: 'Vytvořit data',
            message: 'Opravdu chcete vytvořit data?',
            onConfirm: () => {
                axios.post(IP + "/obrazky",
                    {
                        nazev_souboru: img.name,
                        base64: base64 
                    }
                ).then(response => {
                    if (response.data.status_code == 1) {
                        showModal({
                            type: 'info',
                            heading: 'Úspěch',
                            message: response.data.status_message 
                        });
                    } else {
                        showModal({
                            type: 'error',
                            heading: 'Chyba',
                            message: response.data.status_message 
                        });
                    }
                }).catch(error => {
                    showModal({
                        type: 'error',
                        heading: 'Chyba',
                        message: 'Server je nedostupný'
                    });
                }).finally(() => {
                    fetchData();
                })
            }
        });
    }

    return <div className="d-flex flex-column flex-nowrap w-100 mx-5">
        <h1>Obrázky</h1>
        <ul className="list-group list-group-flush">
            <li className="d-flex flex-row justify-content-between list-group-item list-group-item-action w-100">
                <h5 className="mx-2">Vytvořit</h5>
            </li>
            <li className="d-flex flex-row justify-content-between list-group-item list-group-item-action w-100">
                <img src={base64 !== null ? convertBase64ToSrc(img.name, base64) : null} className='img-thumbnail' style={{width: '4em', height: '4em'}}/>
                {img === null && <p>Název souboru</p>}
                {img !== null && <p>{img.name}</p>}
                <div className="mb-3">
                    <input id="file" onChange={(e) => setImg(e.target.files[0])} type="file" accept="image/*" className='m-2 form-control' />
                </div>
                <button type="button" className="btn btn-primary mx-2" onClick={vytvoritData}>Vytvořit</button>
            </li>
            <li className="d-flex flex-row justify-content-between list-group-item list-group-item-action w-100">
                <h5 className="mx-2">Obrázek</h5>
                <h5 className="mx-2">Název souboru</h5>
                <h5 className="mx-2">Výběr obrázku</h5>
                <h5 className="mx-2">Ovládání</h5>
            </li>
            {data.map((m) => <ObrazekData key={m.id_obrazek} id_obrazek={m.id_obrazek} nazev_souboru={m.nazev_souboru} base64={m.base64} onRefresh={fetchData}/>)}
        </ul>
    </div>
}