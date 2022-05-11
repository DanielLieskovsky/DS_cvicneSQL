--1
alter table zap_predmety
 add (uzivatel varchar(30), datum date);
 
desc zap_predmety;

create or replace trigger t_zap_predmety_zmena
before insert or update on zap_predmety
for each row
begin
    :new.uzivatel := user;
    :new.datum := sysdate;
end;
/

insert into zap_predmety(os_cislo, cis_predm, skrok, prednasajuci, ects)
 values('500422', 'IA02', 2006, 'KI001', 5);
 
select *
 from zap_predmety
  where os_cislo like '500422' and cis_predm like 'IA02';
  
--2
create or replace trigger t_opakovanie_raz
before update or insert on zap_predmety
for each row
declare
 v_pocet_opakovani integer;
begin
    select count(cis_predm)
     into v_pocet_opakovani
      from zap_predmety
       where os_cislo = :new.os_cislo
        and cis_predm = :new.cis_predm;
        
    if v_pocet_opakovani >= 2 then 
     raise_application_error(-20001, 'uz je raz opakovany');
    end if;
end;
/

select count(cis_predm), os_cislo, cis_predm
 from zap_predmety
  group by os_cislo, cis_predm;
  
--500422, IA02
--nemozem pouzit insert cez select lebo sa meni
insert into zap_predmety(os_cislo, cis_predm, skrok, prednasajuci, ects)
values ('500422', 'IA02', 2007, 'KI001', 5);

drop trigger t_opakovanie_raz;

--3
create or replace trigger t_zmena_os_cisla
 after update on student
  for each row 
begin
    update zap_predmety
     set os_cislo = :new.os_cislo
      where os_cislo = :old.os_cislo;
end;
/

drop trigger t_zmena_os_cisla;

--4
create table log_zap_predmety(
    kto varchar(20),
    kedy date,
    operacia char(1),
    os_cislo integer,
    cis_predm char(4),
    skrok integer,
    prednasajuci char(5),
    ects integer,
    zapocet date,
    vysledok char(1),
    datum_sk date
);

--5
create or replace trigger t_log_zap_predmety
before update or insert or delete on  zap_predmety
for each row
begin
    if inserting then
     insert into log_zap_predmety(kto, kedy, operacia, os_cislo, cis_predm, skrok, prednasajuci, ects, zapocet, vysledok, datum_sk)
      values (user, sysdate, 'I', :new.os_cislo, :new.cis_predm, :new.skrok, :new.prednasajuci, :new.ects, :new.zapocet, :new.vysledok, :new.datum_sk);
    elsif updating then
     insert into log_zap_predmety(kto, kedy, operacia, os_cislo, cis_predm, skrok, prednasajuci, ects, zapocet, vysledok, datum_sk)
     values (user, sysdate, 'U', :old.os_cislo, :old.cis_predm, :old.skrok, :old.prednasajuci, :old.ects, :old.zapocet, :old.vysledok, :old.datum_sk);
    else
     insert into log_zap_predmety(kto, kedy, operacia, os_cislo, cis_predm, skrok, prednasajuci, ects, zapocet, vysledok, datum_sk)
     values (user, sysdate, 'D', :old.os_cislo, :old.cis_predm, :old.skrok, :old.prednasajuci, :old.ects, :old.zapocet, :old.vysledok, :old.datum_sk);
    end if;
end;
/

drop trigger t_log_zap_predmety;

create or replace trigger t_null_ects
before insert or update on zap_predmety
for each row
declare
    v_ects integer;
begin
    if :new.ects is null
     then 
      select ects into v_ects
      from predmet_bod 
       where cis_predm like :new.cis_predm and skrok like :new.skrok;
    end if;
end;
/

--8
drop trigger t_null_ects;

--7
alter trigger t_zap_predmety_zmena disable;
alter trigger t_zap_predmety_zmena enable;
