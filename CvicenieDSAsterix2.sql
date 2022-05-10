--Insert
--1 prva osoba
insert into os_udaje (rod_cislo, meno, priezvisko)
 values ('820722/6247', 'Karol', 'Novy');
 
select *
 from st_odbory;
 
insert into student (os_cislo, st_odbor, st_zameranie, rod_cislo, rocnik, st_skupina)
 values ('123', '100', '0', '820722/6247', '1', '5ZI012');
 
insert into zap_predmety (os_cislo, cis_predm, skrok, prednasajuci, ects)
 select 123, cis_predm, skrok, garant, ects
  from predmet_bod 
   where (cis_predm like 'BI11' and skrok = 2008) or
         (cis_predm like 'BI02' and skrok = 2008) or 
         (cis_predm like 'BE01' and skrok = 2003);
         
--1 druha osoba
insert into os_udaje(rod_cislo, meno, priezvisko)
 values ('860114/2462', 'Karol', 'Lempassky');
 
insert into student(os_cislo, st_odbor, st_zameranie, rod_cislo, rocnik, st_skupina)
 values ('90', '200', '2', '860114/2462', '2', '5ZSA21');
 
insert into zap_predmety(os_cislo, cis_predm, skrok, prednasajuci, ects)
 select 90, cis_predm, skrok, garant, ects
  from predmet_bod
   where (cis_predm = 'II08' and skrok = 2006) or 
         (cis_predm = 'II07' and skrok = 2007);
       
--2  
select *
 from kvet3.osoba;
 
select * 
 from kvet3.skusky;

insert into os_udaje(rod_cislo, meno, priezvisko)
 select rod_cislo, meno, priezvisko
  from kvet3.osoba;
  
insert into student(os_cislo, st_odbor, st_zameranie, rod_cislo, rocnik, st_skupina)
 select os_cislo, st_odbor, st_zameranie, rod_cislo, rocnik, st_skupina
  from kvet3.osoba;
  
insert into zap_predmety(os_cislo, cis_predm, skrok, prednasajuci, ects)
 select os_cislo, cis_predm, skrok, garant, ects
  from kvet3.skusky join predmet_bod using(cis_predm, skrok); 
  
select *
 from zap_predmety 
  where os_cislo like '8';
  
--Update
--1
update os_udaje 
 set priezvisko = 'Stary'
  where priezvisko = 'Novy';
  
select * 
 from os_udaje 
  where priezvisko like 'Stary';
  
--2
update os_udaje
 set meno = 'Karolina'
  where meno in (select meno
                 from os_udaje
                  where rod_cislo in (select rod_cislo
                                      from student
                                       where os_cislo = 8)
                );

select * 
 from os_udaje join student using(rod_cislo)
  where os_cislo = 8;
  
--3
update zap_predmety
 set cis_predm = 'BI01'
  where cis_predm like 'BI11' 
   and 
    os_cislo in (select os_cislo
                 from student
                  where rocnik = 1);
                  
select *
 from zap_predmety
  where os_cislo in (123, 8);
  
--4
update student
 set stav = 'S'
  where stav is null;
  
--5
update student
 set rocnik = rocnik + 1, st_skupina = substr(st_skupina,1,4) || (substr(st_skupina,5,1) + 1) || substr(st_skupina,6,1)
  where stav like 'S' 
   and 
   (
    (st_odbor >= 100 and st_odbor <= 199 and rocnik < 3) 
     or
      (st_odbor >= 200 and st_odbor <= 299 and rocnik < 2)
    );
    
--Delete
--1
select *
 from zap_predmety
  where os_cislo = 123;
  
delete from zap_predmety
 where os_cislo = '123' and cis_predm like 'BE01';
 
insert into zap_predmety(os_cislo, cis_predm, skrok, prednasajuci, ects)
 select 123, cis_predm, skrok, garant, ects
  from predmet_bod
   where
    (cis_predm like 'BE01' and skrok = 2003);
    
--2
delete from zap_predmety
 where cis_predm like 'BI01' and 
  os_cislo in (select os_cislo
                from student
                 where st_skupina like '5ZI022');
