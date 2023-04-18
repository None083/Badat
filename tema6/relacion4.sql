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
set @autocommit = 0; -- para que no se guarde el borrado de datos

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
    
-- en nuevas versiones por cuestiones de bloqueo transaccional 
-- en operaciones update/delete/insert
-- no se puede hacer como anteriormente. Solución:
    
    -- versión Nerea
    create temporary table if not exists temp
		(numde int, 
        media decimal(12.2)
        );
    select numde, round(avg(empleados.salar4em), 2) as media
    from empleados
    group by numde;
    delete from empleados
    where empleados.salarem > (select media
								from temp
                                where empleados.numde = temp.numde);
	drop temporary table if exists temp;
    
    -- versión Eva, que da error
    delete from empleados 
    where salarem >= (select avg(salarem)
					  from empleados as e -- es importante hacer un clon
                      where e.numde = empleados.numde);
end $$
delimiter ;

-- da error todo el tiempo por una actualización de la versión
-- hay que usar otro método que aún no hemos dado (cursores)

-- start transaction;
set @nuevocentro = (select max(numce)+1 from centros);

insert into centros
	(numce, nomce, dirce)
values
	(@nuevocentros, 'prueba', 'dirce');
-- commit;


-- 27
-- Disminuir en la tabla EMPLEADOS un 5% el salario de los empleados 
-- que superan el 50% del salario máximo de su departamento.

update empleados
set salarem = salarem*0.95
where salarem > 0.50*(select max(salarem)
						from empleados as e 
						where e.numde = empleado.numde);

-- 40
drop procedure if exists ej40;
delimiter **
create procedure ej40(
			codigoZona int,
            fechaInicio date,
            fechaFin date)
begin
select codcasa, nomcasa
from casas
where codcasa not in (select codcasa
						from reservas
                        where fecanulacion is null 
							and((feciniestancia between fechaInicio and fechaFin)
								or (date_add(feciniestancia, interval numdiasestancia day) between fechaInicio and fechaFin)
								)
                        )
	and codzona = codigoZona;
end **
delimiter ;
call ej40('2012-3-22', '2012-3-30', 1);
call ej40('2012-3-18', '2012-3-22', 1);
call ej40('2012-3-21', '2012-3-23', 1); -- no sale
call ej40('2012-3-18', '2012-3-30', 1);






