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
-- Borrar de la tabla EMPLEADOS a los empleados cuyo salario (sin incluir la comisión) 
-- supere al salario medio de los empleados de su departamento.

drop procedure if exists proc_ejer_6_4_26;
delimiter $$

create procedure proc_ejer_6_4_26()
begin
	-- call proc_ejer_6_4_26();
    -- el ejercicio pide que los borremos, pero, para verlo vamos a hacer una selección:
	/* select numem
	from empleados 
    where salarem >= (select avg(salarem)
					  from empleados as e
                      where e.numde = empleados.numde); */	
    -- HAGAMOS AHORA EL BORRADO COMO PIDE EL EJERCICIO
    delete from empleados 
    where salarem >= (select avg(salarem)
					  from empleados as e
                      where e.numde = empleados.numde);
end $$
delimiter ;


-- 27
-- Disminuir en la tabla EMPLEADOS un 5% el salario de los empleados 
-- que superan el 50% del salario máximo de su departamento.

update empleados
set salarem = salarem*0.95
where salarem > 0.50*(select max(salarem)
						from empleados as e 
						where e.numde = empleado.numde);







