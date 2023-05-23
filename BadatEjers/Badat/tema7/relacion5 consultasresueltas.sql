use bdalmacen;

-- 1 Obtener todos los productos que comiencen por una letra determinada.
select * from productos;

drop procedure if exists ejer5_1;
delimiter **
create procedure ejer5_1(letra char(1))
begin
	select descripcion
	from productos
	where descripcion like concat(letra, '%');
end **
call ejer5_1('b');

-- 2 Se ha diseñado un sistema para que los proveedores puedan acceder a ciertos datos, 
-- la contraseña que se les da es el teléfono de la empresa al revés. Se pide elaborar 
-- un procedimiento almacenado que dado un proveedor obtenga su contraseña y la muestre en los resultados.
select * from proveedores;

drop function if exists ejer6_2;
delimiter **
create function ejer6_2(codProveedor int)
returns char(9)
deterministic
begin
	return (select reverse(telefono)
			from proveedores
            where proveedores.codproveedor=codProveedor);
end **
select ejer6_2(2);


/*3 Obtener el mes previsto de entrega para los pedidos que no se han recibido aún 
y para una categoría determinada.*/

delimiter $$
drop procedure if exists ejer_u6_r5_e3 $$
create procedure ejer_u6_r5_e3(in categoria int)
begin
	/* call ejer_u5_r5_e3(1);
	*/
	
select pedidos.codpedido, convert(ifnull(month(fecentrega),'sin especificar'), char(15))
	-- ifnull(month(fecentrega),'sin especificar') /* funcionaría así también, solo que por cuestines de aspecto es mejor con convert*/
from pedidos join productos on pedidos.codproducto = productos.codproducto
where productos.codcategoria=categoria and 
	(pedidos.fecentrega >= curdate() or pedidos.fecentrega is null);
end $$
delimiter ;

/*4 Obtener un listado con todos los productos, ordenados por categoría, en el 
que se muestre solo las tres primeras letras de la categoría.*/

select Nomcategoria, left(Nomcategoria, 3),
	substring(Nomcategoria, 1, 3)
from categorias;

/*5 Obtener el cuadrado y el cubo de los precios de los productos.*/

select descripcion, preciounidad, power(preciounidad, 2) as CUADRADO,
	power(preciounidad, 3) as CUBO
from productos;

/*6 Devuelve la fecha del mes actual.*/

select month(curdate()), monthname(curdate());

/*7 Para los pedidos entregados el mismo mes que el actual, obtener cuantos días hace que se entregaron.*/

select fecentrega, datediff(curdate(), fecentrega),
	datediff(fecentrega, curdate())
from pedidos
where month(fecentrega) = month(curdate())
	and year(fecentrega) = year(curdate());

/*8 En el nombre de los productos, sustituir “tarta” por “pastel”.*/

select descripcion from productos
where descripcion like '%pastel%';

update productos
set descripcion = replace(descripcion, 'Tarta', 'pastel');
-- where descripcion like '%Tarta%';

/*9 Obtener la población del código postal de los proveedores (los primeros dos caracteres se 
refieren a la provincia y los tres últimos a la población).*/

select codpostal,right(codpostal,3),
	substring(codpostal, 3,3), ciudad
from proveedores;

/* ejemplos con subcadenas */
select right('hola que tal', 3);
select right('29680', 3);

set @cadena = '29680';
select length(@cadena);

select substring(@cadena, length(@cadena)-2,3);


/*10 Obtén el número de productos de cada categoría, haz que el nombre de la categoría 
se muestre en mayúsculas.*/

select upper(categorias.Nomcategoria), count(*) as numProductos
from productos join categorias on categorias.codcategoria = productos.codcategoria
group by categorias.Nomcategoria;

/*11 Obtén un listado de productos por categoría y dentro de cada categoría del nombre 
de producto más corto al más largo.*/

select Nomcategoria, productos.descripcion
from categorias join productos on
	productos.codcategoria = categorias.codcategoria
order by Nomcategoria, length(productos.descripcion);


/*12 Asegúrate de que los nombres de los productos no tengan espacios en blanco 
al principio o al final de dicho nombre.*/

update productos
set descripcion= trim(descripcion);

/*13 Lo mismo que en el ejercicio 2, pero ahora, además, sustituye el 4 y 5 
número del resultado por las 2 últimas letras del nombre de la empresa.*/

select telefono, reverse(telefono),
	   substring(reverse(telefono), 4,2),
		right(nomempresa,2),
		replace(reverse(telefono),
				substring(reverse(telefono), 4,2),
				right(nomempresa,2))
from proveedores;

/*14 Obtén el 10 por ciento del precio de los productos redondeados a dos decimales.*/

select descripcion, round(preciounidad*0.10,2)
from productos;

/*15 Muestra un listado de productos en que aparezca el nombre del producto y el código 
de producto y el de categoría repetidos (por ejemplo para la tarta de azucar se mostrará “623623”).*/

-- NOTA.- Convertir a char(12) es simplemente por cuestiones de formato, no es necesario
select descripcion, convert(repeat(concat(codproducto, codcategoria),2), char(12)) as resultado,
	repeat(concat(codproducto, codcategoria),2) as SinFormato
from productos;












