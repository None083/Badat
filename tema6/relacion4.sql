use empresaclase;

-- 1
select concat_ws(" ",nomem, ape1em, ape2em) as NombreCompleto, salarem 
from empleados
where numhiem>3 order by NombreCompleto;

-- 2
select concat_ws(" ",nomem, ape1em, ape2em) as NombreCompleto, comisem, nomde
from empleados join departamentos on empleados.numde = departamentos.numde
where salarem < 190000
order by nomde and comisem desc;


drop procedure if exists ejercicio2_4;
delimiter $$
create procedure ejercicio2_4(salarioMax decimal(8,2))
begin
	select concat_ws(" ",nomem, ape1em, ape2em) as NombreCompleto, comisem, nomde
	from empleados join departamentos on empleados.numde = departamentos.numde
	where salarem < salarioMax
	order by nomde and comisem desc;
end $$
call ejercicio2_4(190000);
-- 3
select * from dirigir;

drop procedure if exists ejercicio3_4;
delimiter **
create procedure ejercicio3_4()
begin
	select nomde
    from departamentos join dirigir on departamentos.numde = dirigir.numdepto
    where tipodir= 'F' or tipodir= 'f'
    order by nomde;
end **
call ejercicio3_4();

-- 4
drop procedure if exists ejercicio4_4;
delimiter **
create procedure ejercicio4_4(depto int)
begin
	
end **

-- 26







