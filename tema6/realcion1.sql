use  empresaclase;

-- 1 -- 
select * from empleados;

-- 2 --
select extelem from empleados 
	where nomem="JUAN" and ape1em="LOPEZ";

-- 3 --
select concat_ws(" ",ape1em,ape2em, nomem) as nombreCompleto1 from empleados
	where numhiem>1;
    
-- 4 --
select concat_ws(" ",ape1em,ape2em, nomem) as nombreCompleto2 from empleados
	where numhiem>=1 and numhiem<=3;
    
-- 5 --
select concat_ws(" ",ape1em,ape2em, nomem) as nombreCompleto2 from empleados
	where comisem is null or comisem=0;
    
-- 6 --
select * from centros;
select dirce from centros
	where nomce=' SEDE CENTRAL';
    
-- 7 --
select nomde from departamentos
	where presude>6000;
    
-- 8 --
select nomde from departamentos
	where presude>=6000;
    
-- 9 ---
select concat_ws(" ",ape1em,ape2em,nomem) as nombreCompleto1 from empleados
	where fecinem<=subdate(curdate(), interval 1 year);

-- 10 --
select concat_ws(" ",ape1em,ape2em, nomem) as nombreCompleto1 from empleados
	where fecinem<=subdate(curdate(), interval 1 year) and fecinem>=subdate(curdate(), interval 3 year);
    
-- 11 --
delimiter $$
drop procedure if exists ejercicio1 $$

create procedure ejercicio1()
begin 
    select * from empleados;

    
end $$
drop procedure if exists ejercicio5 $$
create procedure ejercicio5(comision int)
begin 

    select concat_ws(" ",ape1em,ape2em, nomem) as nombreCompleto2 from empleados
	where comisem is null or comisem=comision;
    
end $$
    
delimiter ;
call ejercicio1();
call ejercicio5(0);

-- 12 --
delimiter $$
drop procedure if exists ejercicio12 $$

create procedure ejercicio12(nombre varchar(20))
begin 
    select extelem from empleados 
	where nomem=nombre;

    
end $$
delimiter ;
call ejercicio12("eva");

-- 13 --
delimiter $$
drop procedure if exists ejercicio13a $$
create procedure ejercicio13a(numeroHijos tinyint)
begin 
    select concat_ws(" ",ape1em,ape2em, nomem) as nombreCompleto1 from empleados
	where numhiem>numeroHijos;

    
end $$

drop procedure if exists ejercicio13b $$
create procedure ejercicio13b(numeroHijosMin tinyint, numeroHijosMax tinyint)
begin 
    select concat_ws(" ",ape1em,ape2em,nomem) as nombreCompleto2 from empleados
	where numhiem>numeroHijosMin and numhiem<=numeroHijosMax;

    
end $$
delimiter ;
call ejercicio13a(2);
call ejercicio13b(3, 5);

-- 14 --


-- 15 --


-- 16 --


-- 17 --


-- 18 --


-- 19 --

