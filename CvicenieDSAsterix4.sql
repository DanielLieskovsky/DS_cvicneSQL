--1
select to_char(sysdate, 'YY')
 from dual;

select to_char(sysdate,'YYYY') - ('19' || substr(rod_cislo,1,2)) as vek
 from os_udaje
  order by vek desc;
 
select max(to_char(sysdate,'YYYY') - ('19' || substr(rod_cislo,1,2))) as max_vek
 from os_udaje 
  where rod_cislo in (select rod_cislo
                      from student);
        
--2
select *
 from os_udaje join student using(rod_cislo)
  where substr(rod_cislo,3,2) = '06';

select meno, priezvisko, (substr(rod_cislo,5,2) || '.' || substr(rod_cislo,3,2) || '.19' || substr(rod_cislo,1,2)) as datum_narodenia
 from os_udaje
  where substr(rod_cislo,3,2) = (to_char(sysdate,'MM') + '1') and rod_cislo in (select rod_cislo
                        from student);
                        
--3
select * 
 from zap_predmety
  where cis_predm like 'BF01';
 
select count(os_cislo) as pocet, max(nvl(vysledok,'F')), min(nvl(vysledok,'F')), cis_predm
 from zap_predmety
  group by cis_predm
   order by pocet asc;
   
--4
select round(avg(ciselna_znamka)), os_cislo
from (
select case vysledok when 'A' then 1
                     when 'B' then 1.5
                     when 'C' then 2
                     when 'D' then 2.5
                     when 'E' then 3
                     else 4 end as ciselna_znamka, os_cislo
 from zap_predmety)
  having round(avg(ciselna_znamka)) <= 3
   group by os_cislo;
   
--5
--BA14
select * 
 from zap_predmety 
  where skrok = '2006'
   order by cis_predm;
   
select count(os_cislo), cis_predm
 from zap_predmety
  where skrok like '2006'
   having count(os_cislo) >= 4 
    group by cis_predm;

--6
--500424
select count(cis_predm), os_cislo, meno, priezvisko
 from zap_predmety join student using(os_cislo)
                   join os_udaje using(rod_cislo)
  having count(cis_predm) > 1
  group by cis_predm, os_cislo, meno, priezvisko;
  
select *
 from os_udaje join student using(rod_cislo)
                join zap_predmety using(os_cislo)
    where os_cislo like '500424'
     order by cis_predm;
    
--7
select count(cis_predm), meno, priezvisko
 from zap_predmety join student using(os_cislo)
                   join os_udaje using(rod_cislo)
  where skrok like '2008'
   group by meno, priezvisko;
   
--8
select cis_predm
 from st_program 
  where skrok like '2006' and cis_predm not in (select cis_predm 
                            from zap_predmety
                             where skrok = 2006) ;
        
--predmety st programu na dany rok
select cis_predm
 from st_program 
  where skrok like '2006'
   order by cis_predm;
  
--zapisane daneho roku
select cis_predm
 from zap_predmety
  where skrok like '2006'
   order by cis_predm;

--9
select trunc(sysdate - to_date('10.05.2022', 'DD.MM.YYYY'))
 from dual;
 
select trunc(zapocet - datum_sk), os_cislo, cis_predm
 from zap_predmety
  where zapocet is not null and datum_sk is not null;
  
select * 
 from zap_predmety
  where os_cislo like '500428';
  
--10
select round(months_between(zapocet, datum_sk),0) as mesiace_medzi, os_cislo, cis_predm
 from zap_predmety
  where zapocet is not null and datum_sk is not null and months_between(zapocet, datum_sk) >= 1;
  
--11
select distinct meno, priezvisko
 from os_udaje join student using(rod_cislo)
               join zap_predmety using(os_cislo)
    having count(cis_predm) = 1
     group by cis_predm, os_cislo, meno, priezvisko;
   
select distinct count(cis_predm), os_cislo, meno, priezvisko
 from zap_predmety join student using(os_cislo)
                   join os_udaje using(rod_cislo)
  having count(cis_predm) = 1
  group by cis_predm, os_cislo, meno, priezvisko;

--12a
select count(os_cislo)
 from student;
 
--12b
select rocnik, count(os_cislo)
 from student
  group by rocnik
   order by rocnik desc;
   
--12c
select * 
 from st_odbory;
 
select * 
 from st_odbory odb join student st using(st_odbor)
  where st_odbor = 200 and odb.st_zameranie = 1;
  
select count(os_cislo)
 from student join st_odbory odb using(st_odbor)
        group by st_odbor, odb.st_zameranie;
        
--Soc poistovna
--1
select *
 from p_zamestnanec nec join p_zamestnavatel tel on (nec.id_zamestnavatela = tel.ICO)
  where nazov like 'Tesco';
  
select count(rod_cislo)
 from p_zamestnanec nec join p_zamestnavatel tel on (nec.id_zamestnavatela = tel.ICO)
  where nazov like 'Tesco'
  group by ICO;
  
--2
select to_char(sysdate, 'YYYY')
 from dual;
 
select (to_char(sysdate, 'YYYY') - ('19' || substr(rod_cislo,1,2))) as vek, count(id_poistenca)
 from p_poistenie
  where oslobodeny like 'A'
   group by (to_char(sysdate, 'YYYY') - ('19' || substr(rod_cislo,1,2)));
   
--3
select meno, priezvisko
 from p_osoba join p_poistenie using(rod_cislo)
  where oslobodeny like 'A' and rod_cislo not in ( select rod_cislo
                                                    from p_poberatel);
                                                    
select meno, priezvisko
 from p_osoba 
  where rod_cislo in (select rod_cislo
                      from p_poistenie
                      where oslobodeny like 'A')
  and not exists ( select 'x'
                    from p_poberatel
                     where p_poberatel.rod_cislo = p_osoba.rod_cislo);
                     
--5
select o1.meno, o1.priezvisko, o2.meno, o2.priezvisko
 from p_osoba o1, p_osoba o2
  where o2.priezvisko = o1.priezvisko and o2.meno <> o1.meno;
  
--4
select sum(suma)
 from p_odvod_platba
  group by id_poistenca;

--6
select count(rod_cislo), meno, priezvisko
 from p_poberatel join p_osoba using(rod_cislo)
  where dat_do is null
  group by meno, priezvisko;
  
select meno, priezvisko
 from p_poberatel join p_osoba using(rod_cislo)
  where dat_do is null
  having count(rod_cislo) > 1
  group by meno, priezvisko;  
  
select *
 from p_poberatel
  where rod_cislo like '860430/8317';
  
  