--1
create or replace view pohlad_st
as 
select meno, priezvisko, st_skupina
 from os_udaje join student using(rod_cislo);
 
select *
 from pohlad_st;
 
--2
create or replace view pohlad_uc
 as
select meno, priezvisko
 from ucitel
 where os_cislo in ( select prednasajuci
                    from zap_predmety);
                    
select * from pohlad_uc;

--3
create or replace view osoby
as
 select meno, priezvisko, rod_cislo
  from os_udaje;
  
select * from osoby;

--4
--Peter Novak 841106/3456
-- 501512
select *
 from zap_predmety join student using(os_cislo)
                   join os_udaje using(rod_cislo)
  where meno like 'Peter' and priezvisko like 'Novak';
  
delete from zap_predmety
 where os_cislo like '501512';
 
delete from student
 where os_cislo like '501512';
 
delete from osoby
 where rod_cislo like '841106/3456';
 
select * 
 from osoby
  where meno like 'Peter';
  
select meno, priezvisko
 from os_udaje
  where meno like 'Peter';
  
--vypsi menny zoznam osob neoslobodenych a nepoberali prispevok typu 8
select meno, priezvisko
 from p_osoba
  where rod_cislo not in (select rod_cislo
                            from p_poistenie
                             where oslobodeny like 'A')
    and not exists (select 'x'
                        from p_poberatel
                         where p_osoba.rod_cislo = p_poberatel.rod_cislo
                          and id_typu = 8);
  
--5
create or replace view studenti
 as
select meno, priezvisko, rod_cislo, os_cislo
 from os_udaje join student using(rod_cislo);
 
 select * from studenti;

--8
create or replace trigger vymazavanie
 instead of delete on studenti
 begin
    delete from student
     where :old.os_cislo like os_cislo;
    delete from os_udaje
     where :old.rod_cisli like rod_cislo;
 end;
 /
  