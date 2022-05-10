--DDL
--1
create table t1 (
    id integer,
    kpk integer,
    atr integer,
    primary key(id)
);

--2
create table t2 (
    id integer,
    datum date,
    primary key(id, datum)
);

--3
alter table t2
 add foreign key(id) references t1(id);
 
--4
alter table t2
 add poznamka varchar(20);
 
--5
create index
 datum_index on t2(datum);
 
--6
create unique index
 kpk_index on t1(kpk);
 
--7
drop table t2;
drop table t1;

--opakovanie
--1
select meno, priezvisko
 from p_osoba
  where substr(rod_cislo,3,2) >= 50;
  
--2
select meno, priezvisko
 from p_osoba
  where to_char(sysdate, 'MM') - substr(rod_cislo,3,2) = 1;
  
select months_between(sysdate, substr(rod_cislo,5,2) || '.' || substr(rod_cislo,3,2) || '.' || substr(rod_cislo,1,2))
 from p_osoba;
 
select to_char(sysdate, 'MM')
 from dual;
 
--3
select * 
 from p_ZTP
  order by rod_cislo;

select distinct meno, priezvisko
 from p_osoba join p_ZTP using(rod_cislo)
  where dat_do is not null;
  
--4
select meno, priezvisko
 from p_osoba
  where rod_cislo not in (select rod_cislo
                            from p_ZTP);

--5
select meno, priezvisko
 from p_osoba
  where substr(rod_cislo,2,1) = to_char(sysdate, 'Y');
  
select * 
 from p_osoba
  where meno like 'Robert' and priezvisko like 'Fejes';
  
--6
select *
 from p_poistenie;
 
select *
 from p_platitel;
 
select ICO
 from p_zamestnavatel 
  where nazov like 'Tesco';
  
select count(*)
 from p_poistenie
  where id_platitela in ( select ICO
                            from p_zamestnavatel 
                             where nazov like 'Tesco');
                             
--7
select * 
 from p_typ_prispevku;
 
select distinct count(*)
 from p_poberatel
  where id_typu = 3
   order by rod_cislo;
  
select count(*)
 from p_osoba
  order by rod_cislo;
  
select meno, priezvisko
 from p_osoba
  where rod_cislo not in ( select rod_cislo
                            from p_poberatel
                             where id_typu = 3);
                            
--8
select meno, priezvisko
 from p_osoba
  where rod_cislo in (select rod_cislo
                        from p_poberatel
                         where (dat_do is not null) and (id_typu <> 3));
                         
--9 
select count(*) as celkovy_pocet
 from p_zamestnanec
  where dat_do is null and id_zamestnavatela in (select ICO
                                                 from p_zamestnavatel
                                                  where nazov like 'Tesco');
                                                  
select * 
 from p_zamestnanec
  where id_zamestnavatela in (select ICO
                              from p_zamestnavatel
                               where nazov like 'Tesco');
                               
--10
select sum(suma)
 from p_odvod_platba
  where id_poistenca in (select id_poistenca
                         from p_poistenie
                          where id_platitela in (select id_zamestnavatela
                                                 from p_zamestnanec
                                                  where dat_do is null and id_zamestnavatela in (select ICO
                                                                                                    from p_zamestnavatel
                                                                                                     where nazov like 'Tesco'))
                        );