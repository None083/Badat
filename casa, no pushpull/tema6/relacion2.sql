use empresaclase;
-- 3 --
select numem, empleados.numde, fecnaem, salarem, comisem, nomem, nomde from empleados 
	join departamentos 
	where empleados.numde=departamentos.numde;
    
-- 4 --
select empleados.extelem, centros.nomce 
	from empleados 
		join departamentos,centros
        where empleados.numde=departamentos.numde 
			and departamentos.numce=centros.numce 
			and nomem='JUAN' and ape1em='LOPEZ';

-- 5 --
select concat_ws(' ',nomem,ape1em,ape2em) as nombreCompleto
	from empleados 
    join departamentos
    where empleados.numde=departamentos.numde
		and (nomde='PERSONAL' or nomde='FINANZAS');

select * from empleados;

-- 6 --
select concat_ws(' ',nomem,ape1em,ape2em) as nombreCompleto
	from empleados
    join departamentos, dirigir
    where empleados.numde=departamentos.numde 
		and departamentos.numde=dirigir.numdepto
        and nomde='PERSONAL'
        and (fecfindir>curdate() or fecfindir is null);
	
select * from dirigir;

-- 7 --
select nomde, presude
	from departamentos join centros
    where departamentos.numce=centros.numce
		and nomce=" SEDE CENTRAL";

select * from centros;

-- 8 --
select nomce
	from centros join departamentos
    where centros.numce=departamentos.numce
		and presude>=100000 and presude<=150000;

-- 9 --
select extelem from empleados;

select DISTINCT extelem 
	from empleados join departamentos
    where empleados.numde=departamentos.numde
		and nomde="FINANZAS";
        
-- 10 --        
delimiter $$
drop procedure if exists ejercicio10 $$

create procedure ejercicio10(nombre varchar(60))
begin 

    select concat_ws(' ',nomem,ape1em,ape2em) as nombreCompleto
	from dirigir join departamentos, empleados
    where dirigir.numempdirec=empleados.numem and empleados.numde=departamentos.numde
        and nomde=nombre;

end $$
delimiter ;
call ejercicio10("DIRECCION GENERAL");

select * from departamentos;
select * from dirigir where numdepto=100;

-- 11 -- 12?
delimiter $$
drop procedure if exists ejercicio11 $$

create procedure ejercicio11(nombre varchar(60))
begin 
    select numem, empleados.numde, fecnaem, salarem, comisem, nomem, nomde from empleados 
	join departamentos 
	where empleados.numde=departamentos.numde
		and nomde=nombre;
    
end $$
delimiter ;
call ejercicio11("DIRECCION GENERAL");

-- 12 --
delimiter $$
drop procedure if exists ejercicio12 $$
create procedure ejercicio12(nomDepto varchar(60))
begin

	select concat_ws(' ',nomem,ape1em,ape2em) as nombreCompleto
	from empleados 
    join departamentos on empleados.numde=departamentos.numde
	where nomde=nomDepto;

end $$
delimiter ;
select ejercicio12("");






