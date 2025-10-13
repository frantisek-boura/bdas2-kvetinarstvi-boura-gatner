select jmeno, prijmeni
from uzivatele
join adresy on uzivatele.adresa_id = adresy.id
where adresy.mesto = 'Opava';

select rostliny.rostlina_id, druhy_rostliny.nazev, barvy.nazev
from rostliny
join barvy on barvy.id = rostliny.barva_id
join druhy_rostliny on druhy_rostliny.id = rostliny.druh_rostliny_id
where barvy.nazev <> 'Červená';

select zbozi.*
from zbozi
where zbozi.id not in (select zbozi_id from objednane_zbozi);

select uzivatele.jmeno, uzivatele.prijmeni, objednane_zbozi.zbozi_id
from objednavky
join objednane_zbozi on objednane_zbozi.objednavka_id = objednavky.id
join uzivatele on uzivatele.id = objednavky.uzivatel_id
where objednane_zbozi.zbozi_id = 10;

select rostliny.rostlina_id, objednavky.id
from rostliny
join objednane_zbozi using (zbozi_id)
join objednavky on objednavky.id = objednane_zbozi.objednavka_id;

select distinct uzivatele.id, uzivatele.jmeno, uzivatele.prijmeni, objednavky.id
from uzivatele
left join objednavky on uzivatele.id = objednavky.uzivatel_id
where objednavky.uzivatel_id is null;

select distinct zbozi.*
from objednane_zbozi
natural join zbozi
where zbozi.id in (select zbozi_id from objednane_zbozi);

select zbozi.id, potreby.zbozi_id
from zbozi
cross join potreby;

select uzivatele.jmeno, uzivatele.prijmeni, objednavky.*
from uzivatele
left outer join objednavky on uzivatele.id = objednavky.uzivatel_id;

select uzivatele.jmeno, uzivatele.prijmeni, objednavky.*
from uzivatele
right outer join objednavky on objednavky.uzivatel_id = uzivatele.id;

select rostliny.rostlina_id, barvy.nazev, druhy_rostliny.nazev
from rostliny
join druhy_rostliny on druhy_rostliny.id = rostliny.druh_rostliny_id
full join barvy on barvy.id = rostliny.barva_id;

select barvy.nazev
from barvy
where barvy.nazev not in (select barvy.nazev from rostliny join barvy on barvy.id = rostliny.barva_id);

select count(*)
from (select distinct uzivatele.id from uzivatele join objednavky on objednavky.uzivatel_id = uzivatele.id);

select objednavky.id, objednavky.celkova_cena, (select avg(objednavky.celkova_cena) from objednavky)
from objednavky 
where objednavky.celkova_cena > (select avg(objednavky.celkova_cena) from objednavky);

select potreby.*
from potreby
where exists (select dodane_zbozi.dodavatel_id from dodane_zbozi where potreby.zbozi_id = dodane_zbozi.zbozi_id and dodane_zbozi.dodavatel_id = 3);

select nazev from barvy
union
select nazev from druhy_rostliny;

select potreby.nazev, objednane_zbozi.mnozstvi
from potreby
join objednane_zbozi on objednane_zbozi.zbozi_id = potreby.zbozi_id
minus
select potreby.nazev, objednane_zbozi.mnozstvi
from potreby
join objednane_zbozi on objednane_zbozi.zbozi_id = potreby.zbozi_id
where potreby.nazev = 'Nůžky';

select rostliny.zbozi_id
from rostliny
intersect
select objednane_zbozi.zbozi_id 
from objednane_zbozi 
where objednane_zbozi.zbozi_id <> 10;

select distinct upper(potreby.nazev)
from potreby;

select objednane_zbozi.zbozi_id, ceil(objednane_zbozi.mnozstvi * objednane_zbozi.cena_za_kus)
from objednane_zbozi
where objednane_zbozi.objednavka_id = 5;

select to_char(dodane_zbozi.datum_dodani, 'Month DD, YYYY')
from dodane_zbozi;

select count(*)
from objednavky;

select objednavky.uzivatel_id, count(*)
from objednavky
group by objednavky.uzivatel_id;

select adresy.*
from adresy
where adresy.id = 2;

select adresy.*
from adresy
where adresy.id in (2);

select adresy.*
from adresy
where adresy.id like 2;

select uzivatele.jmeno, uzivatele.prijmeni, count(objednavky.id)
from objednavky
join uzivatele on uzivatele.id = objednavky.uzivatel_id
where uzivatele.id in (1, 5)
group by uzivatele.jmeno, uzivatele.prijmeni
having count(objednavky.id) > 1
order by uzivatele.prijmeni desc;

create or replace view v_objednavky as 
select *
from objednavky;

select *
from v_objednavky
where uzivatel_id > 5;

insert into dodavatele(id, nazev, email, adresa_id)
select max(dodavatele.id) + 1, 'Pridany dodavatel', 'pridany@email.cz', 5 from dodavatele;

update adresy
set mesto = 'Pardubice'
where adresy.id in (select dodavatele.adresa_id from dodavatele where dodavatele.nazev = 'Zahrada Express');

delete from rostliny
where rostliny.zbozi_id in (select zbozi_id from zbozi where zbozi_id = 18);

