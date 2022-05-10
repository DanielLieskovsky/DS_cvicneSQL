--cvicenie 2
--1
select meno, priezvisko
 from os_udaje join student using(rod_cislo);
 
--2
select meno, priezvisko
 from os_udaje join student using(rod_cislo)
  where rocnik = 2;
  
--3
select meno, priezvisko
 from os_udaje join student using(rod_cislo)
  where substr(rod_cislo,1,2) between 85 and 89;
  
select meno, priezvisko
 from os_udaje join student using(rod_cislo)
  where substr(rod_cislo,1,2) >= 85
   and substr(rod_cislo,1,2) <= 89;
   
--4
select meno,priezvisko
 from os_udaje join student using(rod_cislo)
  where substr(st_skupina,2,1) like 'P';

select meno,priezvisko
 from os_udaje join student using(rod_cislo)
  where substr(st_skupina,2,1) = 'P';
  
--5 
select meno,priezvisko
 from os_udaje join student using(rod_cislo)
  where substr(st_skupina,2,1) like 'P'
   order by priezvisko desc;
   
--6
-- prvy select necha aj studenta ktorý to mal zapísane 2krat, druhy to eliminuje
-- staci dat do prveho distinct
select meno, priezvisko, os_cislo
 from os_udaje join student using(rod_cislo)
               join zap_predmety using(os_cislo)
    where cis_predm like 'BI06'
     order by priezvisko desc;
    
select meno, priezvisko, os_cislo
 from os_udaje join student using(rod_cislo)
  where os_cislo in (select os_cislo
                        from zap_predmety
                         where cis_predm like 'BI06')
    order by priezvisko desc;
    
--7
select distinct prednasajuci, cis_predm
 from zap_predmety
  order by prednasajuci, cis_predm;
 
--8
select distinct nazov, cis_predm, meno, priezvisko 
 from zap_predmety zp join ucitel uc on (uc.os_cislo = zp.prednasajuci)
                   join predmet using(cis_predm)
    order by cis_predm, priezvisko;
    
--9
select distinct uc.meno, uc.priezvisko
 from ucitel uc join zap_predmety zp on (zp.prednasajuci = uc.os_cislo)
                join student stud on (stud.os_cislo = zp.os_cislo)
                join os_udaje os on (os.rod_cislo = stud.rod_cislo)
        where rocnik = 2 and st_odbor between 100 and 199
         order by uc.meno;
        
select meno, priezvisko
 from ucitel
  where os_cislo in ( select prednasajuci
                      from zap_predmety 
                       where os_cislo in ( select os_cislo
                                            from student 
                                             where rocnik = 2 and st_odbor between 100 and 199)
                    )
    order by meno;
    
select nazov
 from predmet 
  where cis_predm in ( select cis_predm
                        from zap_predmety
                         where os_cislo in ( select os_cislo
                                              from student 
                                               where rod_cislo in ( select rod_cislo
                                                                     from os_udaje
                                                                      where priezvisko like 'Balaz')
                                            )
                     )
    order by nazov;
    
select nazov
 from predmet join zap_predmety using(cis_predm)
              join student using(os_cislo)
              join os_udaje using(rod_cislo)
    where priezvisko like 'Balaz'
     order by nazov;
           
--11
select count(*)
 from zap_predmety;

--12
select count(*)
 from student
  where os_cislo in ( select os_cislo
                      from zap_predmety
                       where cis_predm in (select cis_predm
                                                from predmet
                                                 where nazov like 'Zaklady databazovych systemov')
                    );
                    
select count(*)
 from student join zap_predmety using(os_cislo)
              join predmet using(cis_predm)
    where nazov like 'Zaklady databazovych systemov';

--13
select meno, priezvisko, substr(rod_cislo,5,2) || '.' || mod(substr(rod_cislo,3,2),50) || '.' || '19' || substr(rod_cislo,1,2)
 from os_udaje
  where rod_cislo in (select rod_cislo
                        from student);
                    
select distinct meno, priezvisko, substr(rod_cislo,5,2) || '.' || mod(substr(rod_cislo,3,2),50) || '.' || '19' || substr(rod_cislo,1,2)
 from os_udaje join student using(rod_cislo);
 
--14
select sum(ects)
 from zap_predmety 
  where os_cislo in (select os_cislo
                        from student
                         where os_cislo like '500439')
    and vysledok is not null and vysledok <> 'F';
    
select sum(ects)
 from zap_predmety join student using(os_cislo)
  where os_cislo like '500439' and vysledok is not null and vysledok <> 'F';

--15
select meno, priezvisko, 
    trunc(
     months_between(sysdate, 
       to_date(substr(rod_cislo,5,2) || '.' || mod(substr(rod_cislo,3,2),50) || '.' || '19' || substr(rod_cislo,1,2))) / 12) as vek
 from os_udaje join student using(rod_cislo)
  where rocnik = 2
   order by meno;
  
select meno, priezvisko, 
    trunc(
     months_between(sysdate, 
       to_date(substr(rod_cislo,5,2) || '.' || mod(substr(rod_cislo,3,2),50) || '.' || '19' || substr(rod_cislo,1,2))) / 12) as vek
 from os_udaje 
  where rod_cislo in (select rod_cislo 
                        from student
                         where rocnik = 2)
    order by meno;
               