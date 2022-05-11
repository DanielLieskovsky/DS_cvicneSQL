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
select count(cis_predm), os_cislo
 from zap_predmety
  having count(cis_predm) > 1
  group by cis_predm, os_cislo;
  
select *
 from os_udaje join student using(rod_cislo)
                join zap_predmety using(os_cislo)
    where os_cislo like '500424'
     order by cis_predm;