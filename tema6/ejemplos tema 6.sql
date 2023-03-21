select numem, nomem
from empleados;

select *
from empleados;

select salarem*0.10
from empleados;

select numem, numem as NumEmpleado,
	ape1em, ape2em, nomem,
    concat(ape1em, ape2em, nomem),
    concat(ape1em, ape2em, nomem) as nombreCompleto1,
    concat(ape1em,' ', ape2em, ' ', nomem) as nombreCompleto2,
    concat(ape1em,' ', ifnull(ape2em, ' '), ' ', nomem) as nombreCompleto3,
    concat_ws(' ', ape1em,ape2em,nomem) as nombreCompleto1_ws
from empleados
where numde= 110 or numde= 120
order by ape1em desc, ape2em desc, nomem asc; 
/* el desc es para orden descendente, asc es ascendente, 
aunque no hace falta porque siempre es ascendente por defecto */


/* ejer 2 */
delimiter $$
drop procedure if exists muestraExtension $$
create procedure muestraExtension
	(nombre varchar(60), -- si no se necesitan parametros se deja vacío
    ape1 varchar(60)
    )
begin -- bloque de procedimiento
    
select * from empleados.extelem
from empleados
where nomem = nombre and ape1em = ape1;
    
    
end $$
    
delimiter ;

/* como función */
delimiter $$
drop function if exists devuelveExtension $$
create function devuelveExtension
	(nombre varchar(60),
    ape1 varchar(60)
    )
returns char(3)
DETERMINISTIC -- para indicar que es un valor determinado
begin
	declare extension char(3);

/*	set extension = (select empleados.extelem
			from empleados
			where nomem = nombre and ape1em = ape1
			);
*/

	select empleados.extelem into extension
	from empleados
	where nomem = nombre and ape1em = ape1;

	return extension;
end $$
    
delimiter ;

select devuelveExtension('Juan', 'López'); -- esta funcion devuelve ese valor
set @miExtension = devuelveExtension('Juan', 'López'); -- se lo podemos asignar a una variable?
select @miExtension;

call muestraExtension('Juan', 'López');

/* procedimiento que devuelve la extension */

delimiter $$
drop procedure if exists DevExtensionProc $$
create procedure DevExtensionProc
	(in nombre varchar(60),
    in ape1 varchar(60),
    out extension char(3)
    )
begin 
    
set extension = (select empleados.extelem
				from empleados
				where nomem = nombre and ape1em = ape1);
    
end $$
delimiter ;

call DevExtensionProc('Juan', 'López', @miExtension); -- parametro de salida
select @miExtension;

/* 
prepara una rutina (procedimiento | funcion)
que muestre => procedimiento
que devuelva (funcion | procedimiento)
1 valor => función
+ de 1 valor => procedimiento
*/

-- RELACION 2 --

-- everiguar nombre de empleados que trabajan en la calle atocha
select empleados.numem, empleados.nomem, empleados.numde, departamentos.numde, departamentos.numce, centros.numce
from centros join departamentos on centros.numce = departamentos.numce
			 join empleados on departamentos.numde = empleados.numde
where centros.dirce like '%atocha%';

-- obten una lista de nombres de centros y nombres de departamentos (el departamento en el que están)
select centros.nomce as centro, nomce as nombrecentro, nomde as nombredepto
from centros join departamentos on centros.numce = departamentos.numce
order by nomce;

-- innerjoin es lo mismo que join, es automatico

-- left join saca todos los valores de la izquierda, 
-- tenemos una tabla deptos y una centros que hemos hecho join, pues cogería los datos de centros
-- left join centros on deptos.numce=centros.numce

-- right join lo mismo pero con la derecha

-- everiguar nombre de empleados que trabajan en la calle atocha, incluir el nombre del director de cada depto
select empleados.nomem, empleados.numem, departamentos.nomde, centros.numce, dirigir.numempdirec, empleados.nomce
from centros join departamentos on centros.numce = departamentos.numce
			 join empleados on departamentos.numde = empleados.numde
             join dirigir on departamentos.numde = empleados.numde
             -- con el as "" clonamos la tabla para poder utilizar empleados.nomem otra vez
             join empleados as el on dirigir.numempdirec = el.numem
where fecfindir is null
order by nomce, nomde, empleados.nomem;

-- relaciones 1-4 entran en el examen --





