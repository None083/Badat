/* Para la base de datos empresa_clase:
Sabiendo que en la extensión de teléfono que utilizan los empleados, 
el primer dígito corresponde con el edificio, el segundo con la planta 
y el tercero con la puerta. Busca aquellos empleados que trabajan en 
la misma planta (aunque sea en edificios diferentes) que el empleado 120. */
use empresaclase;

drop procedure if exists ejer1;
delimiter $$
create procedure ejer1(numEm int)
begin
	select *
    from empleados
    where substring(extelem, 2, 1) = (select substring(extelem, 2, 1)
										from empleados
                                        where numem = 120);
end $$
delimiter ;
call ejer1(120);


-- Para la base de datos turRural:
/* Sabiendo que los dos primeros dígitos del código postal se corresponden 
con la provincia y los 3 siguientes a la población dentro de esa provincia.
Busca los clientes (todos sus datos) de las 9 primeras poblaciones 
de la provincia de Málaga (29001 a 29009). */
use gbdturrural2015;

select * 
from clientes
where codpostalcli rlike('^2900[1-9]');




/* Sabiendo que los dos primeros dígitos del código postal se corresponden 
con la provincia y los 3 siguientes a la población dentro de esa provincia. 
Busca los clientes (todos sus datos) de las 20 primeras poblaciones 
de la provincia de Málaga (29001 a 29020).*/

select * 
from clientes
where codpostalcli rlike('^290[01][1-9]|20|10');


/* Queremos encontrar clientes con direcciones de correo válidas, 
para ello queremos buscar aquellos clientes cuya dirección de email 
contiene una “@”, y termina en un símbolo punto (.) 
seguido de “com”, “es”, “eu” o “net”.*/

select * 
from clientes
where correoelectronico rlike('@*\\.(com|es|eu|net)');


/*Queremos encontrar ahora aquellos clientes que no cumplan con la expresión regular anterior.*/

select * 
from clientes
where not correoelectronico rlike('@*\\.(com|es|eu|net)');

