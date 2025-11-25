
export const validatePSC = (value) => {
    const regex = /^\d{5}$/;
    if (regex.test(value)) {
        return '';
    }

    return 'Zadejte PSČ ve správném formátu.';
}

export const validateCp = (value) => {
    if (!!!value) {
        return `Zadejte č.p.`
    } else if (value < 0) {
        return 'Zadejte č.p. ve správném formátu';
    }
    return '';
}

export const validateValue = (value, nazev) => {
    if (!!value) {
        return '';
    }
    return `Zadejte ${nazev}.`
}

export const validateHeslo = (heslo, hesloZnovu) => {
    const minDelka = 12;
    const minCislic = 3;
    const regexSpeci = /[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]/;
    const regexVelke = /[A-Z]/;
    const regexCislo = /\d/g;

    let chyby = [];

    if (heslo.length < minDelka) {
        chyby.push(`Heslo musí mít minimálně ${minDelka} znaků.`);
    }

    if (!regexVelke.test(heslo)) {
        chyby.push("Heslo musí obsahovat minimálně 1 velké písmeno.");
    }

    if (!regexSpeci.test(heslo)) {
        chyby.push("Heslo musí obsahovat minimálně 1 speciální znak (např. !@#$%^&*).");
    }

    const pocetCislic = (heslo.match(regexCislo) || []).length;
    if (pocetCislic < minCislic) {
        chyby.push(`Heslo musí obsahovat minimálně ${minCislic} číslice.`);
    }

    if (heslo != hesloZnovu) {
        chyby.push("Hesla nejsou shodná.")
    }

    return chyby;
}

export const validateEmail = (input) => {
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

    if (!input.trim()) {
        return 'Zadejte e-mail.';
    } else if (!emailRegex.test(input)) {
        return 'Zadejte e-mail ve vhodném tvaru.';
    }

    return '';
}