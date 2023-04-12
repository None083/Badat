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

-- relaciones 1-4 y 9 entran en el examen --

-- funciones agregado --

-- cuantos empleados hay
select count(*), count(numem), count(distinct numde) -- cuenta celdas
from empleados;

-- cuanto me cuesta al mes pagar a mis empleados
select sum(salarem)
from empleados;

-- cual es el salario maximo
select max(salarem)
from empleados;

-- cual es el salario minimo
select min(salarem)
from empleados;

-- cual es la media
select avg(salarem)
from empleados;

select count(*) as numEmpleados, max(salarem) as SalarMax, sum(salarem) as TotalSalar,
	min(salarem) as SalarMin, avg(salarem) as SalarMedio
from empleados;

-- grupos por departamento
select numde, count(*) as numEmpleados, max(salarem) as SalarMax, sum(salarem) as TotalSalar,
	min(salarem) as SalarMin, avg(salarem) as SalarMedio
from empleados
group by numde;

-- una rutina que devuelva el numero de extensiones que utiliza un departamento

delimiter **
drop function if exists devuelveNumeroExtensiones **
create function devuelveNumeroExtensiones
	(numDepto int)
returns int
DETERMINISTIC
begin

	return (select count(distinct extelem)
    from empleados
    where numde = numdepto);

end **    
delimiter ;
select nomde, devuelveNumeroExtensiones(numde)
from departamentos
order by nomde;

-- 10/04/23

-- simulacro actividades
-- 3
-- fecinirest between fec1 and fec2 MEJOR OPCION
-- fecinirest>= fec1 and fecinirest<= fec2;

-- esto estaría mal, ya que no se puede devolver una lista de datos, solo uno en concreto
delimiter **
create function devExtension()
returns char(3) -- está mal, ya que no devuelve un char, si no una lista, la cual tampoco se puede hacer
deterministic
begin
	return
		(select extelem
        from empleados
        );
end **
delimiter **
select devExtension();

-- esto sí estaría bien, porque se devuelve un solo dato en concreto
drop function if exists devExtension;
delimiter **
create function devExtension(
					empleado int)
returns char(3)
deterministic
begin
	return
		(select extelem
        from empleados
        where numem= empleado
        );
end **
delimiter **
select devExtension(120);

-- version procedimiento con varios datos a devolver
drop procedure if exists devExtension;
delimiter **
create procedure devExtension(
					in empleado int, out extension char(3), out salario decimal(10,2))
begin
		select extelem, salarem into extension, salario -- es importante el orden para guardar correctamente
        from empleados
        where numem= empleado;
end **
delimiter **
call devExtension(120, @extension, @salario); -- con solo esto no se vería nada, aunque se ejecutaría correctamente
select @extension as extension, @salario as salario; -- al haber guadado los datos con el into, ya podemos ver los datos


-- simulacro actividades, p6, version modificada para left join

select nomsala, nombreobra, ifnull(valoracion, 'sin valorar')
from salas left join obras on salas.codsala=obras.codsala
order by salas.nomsala, nombreobra;







