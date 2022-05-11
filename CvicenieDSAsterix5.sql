--1
select *
 from priklad_db2.st_odbory;
 
 desc priklad_db2.st_odbory;

create or replace procedure Vyskladaj_skupinu(pracovisko char, 
    odbor integer, zameranie integer, rocnik integer, kruzok char, st_skupina out char)
is
    pom_sk_odboru char;
begin
    select sk_odbor into pom_sk_odboru
     from priklad_db2.st_odbory
      where c_st_odboru = odbor;
      
    st_skupina := '5' || pracovisko || pom_sk_odboru || zameranie || rocnik || kruzok;
end;
/

variable skupina char;
exec Vyskladaj_skupinu('Z', 101, 0, 3, 'A', :skupina);
print skupina;

--2
create or replace function f_vyskladaj_skupinu(pracovisko char, odbor integer, zameranie integer, rocnik integer, kruzok char)
 return char
 is
    pom_sk_predmetu char;
 begin
    select sk_odbor into pom_sk_predmetu from priklad_db2.st_odbory  where c_st_odboru = odbor;
      
    return '5' || pracovisko || pom_sk_predmetu || zameranie || rocnik || kruzok;
 end;
 /
 
variable skupina char;
exec :skupina := f_vyskladaj_skupinu('Z', 101, 0, 3, 'C');
print skupina;

--3
select meno, priezvisko, st_skupina
 from os_udaje join student using(rod_cislo)
  where st_skupina like f_vyskladaj_skupinu('Z', 100, 0, 1, '2');
  
--4
create or replace procedure Vloz_predmet(p_cis_predm char, p_nazov varchar)
is
begin
    insert into predmet
     values (p_cis_predm, p_nazov);
end;
/

exec Vloz_predmet('BI14', 'Databazové systémy');
exec vloz_predmet('BI12', 'Úvod do inžinierstva');
--2 krat nepojde -> duplicitny pk

--5
create or replace procedure Vloz_predmet(p_cis_predm char, p_nazov varchar)
is
begin
    insert into predmet values (p_cis_predm, p_nazov);
    
    exception
     when dup_val_on_index then
      dbms_output.put_line('Uz existujuci predmet');
     when others then
     dbms_output.put_line('Ina chyba');
end;
/

select * 
 from zap_predmety
  order by cis_predm;
 
select count(os_cislo)
 from zap_predmety
  where cis_predm like 'BA14' and skrok = 2005;
  
create or replace function pocet_studentov(p_cis_predm char, p_skrok number)
return integer
is
    pom_pocet integer;
begin
   select count(os_cislo)
    into pom_pocet
     from zap_predmety
      where cis_predm like p_cis_predm and skrok = p_skrok;
      
      return pom_pocet;
end;
/

variable pocet number;
exec :pocet := pocet_studentov('BA14', 2005);
print pocet;