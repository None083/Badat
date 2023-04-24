/*
Para la bd promociones:
Prepara una vista que se llamará CATALOGOPRODUCTOS  que tenga la referencia del artículo,
código y nombre de categoría, nombre del artículo, el precio base y el precio de venta HOY */

drop view if exists catalogoprecios;


select refart, nomart, preciobase, precioventa, codcat
from articulos
where refart not in
	(select catalogospromos.reafart
    from catalogospromos join promociones on catalogospromos.codpromo=promociones.codpromo,
    where curdate() between promociones.fecinipromo
		and date_add(promociones.fecinipromo, interval promociones.duracionpromo day)
    )
union



/* Para la bd de empresaclase:
Prepara una vista que se llamerá LISTINTELEFONICO en la que cada usuario podrá consultar la extensión
telefónica de los empleados de SU DEPARTAMENTO
PISTA ==> USAR FUNCIÓN DE MYSQL USER()
AL CREAR LA VISTA TENER EN CUENTA ESTO:
[SQL SECURITY { DEFINER | INVOKER }]
*/
select substring_index(user(), '@', 1)







-- PARA PROBAR, VAMOS A USAR DOS USUARIOS: EL HABITUAL Y OTRO AL QUE LLAMAREMOS PRUEBA.
-- EN LA BD, TENDREMOS A UN EMPLEADO CON userem = usuario con el que accedmos habitualmente a mysql
-- (en mi caso 'eva', lo voy a asignar a la empleada 890, que está en el depto 121
-- EN LA BD, TENDREMOS A OTRO EMPLEADO CON userem = prueba
-- (lo voy a asignar a la empleada 180, que está en el depto 110
-- El usuario eva ya existe, solo tenemos que crear el usuario prueba y grabar en userem de los empleados mencionados el usuario adecuado
drop user 'prueba'@'192.168.56.1';
create user 'prueba'@'192.168.56.1' identified by '1234';

grant all on *.* to 'prueba'@'192.168.56.1'; 
-- vemaos la función user() que devuelve el usuario conectado:
select user(),
	locate('@', user()),
	left(user(),locate('@', user())),
    locate('@', user())-1;
select left(user(),locate('@', user())-1);
select version();
-- POR TANTO:
CREATE 
	SQL SECURITY INVOKER -- SOLO NECESARIO EN VERSIONES ANTERIORES A MYSQL 8.0.19
	VIEW LISTIN
	(Nombre, extension, depto)
AS
	select concat (ape1em, ifnull(concat(' ', ape2em),''), ', ', nomem), extelem
    from empleados
    where numde = (select numde
				   from empleados
                   where userem = left(user(),locate('@',user())-1 )
				  );

-- cuando ejecutemos la siguiente sentencia conectados con el usuario 'eva', veremos los empleados del depto. 121
-- cuando ejecutemos la siguiente sentencia conectados con el usuario 'prueba', veremos los empleados del depto. 110
select *
from LISTIN;



