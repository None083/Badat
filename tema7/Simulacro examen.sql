use ventapromoscompleta;

/* P1. Queremos saber el importe de las ventas de artículos a cada uno 
de nuestros clientes (muestra el nombre). Queremos que cada cliente se muestre 
una sola vez y que aquellos a los que hayamos vendido más se muestren primero. */

select * from clientes;

select clientes.nomcli, sum(precioventa) as importe
from ventas join clientes on ventas.codcli = clientes.codcli
			join detalleVenta on ventas.codventa = detalleVenta.codventa
group by ventas.codcli
order by importe desc;


/* P2. Muestra un listado de todos los artículos vendidos, queremos mostrar 
la descripción del artículo y entre paréntesis la descripción de la categoría 
a la que pertenecen y la fecha de la venta con el formato “march - 2016, 1 (tuesday)”. 
Haz que se muestren todos los artículos de la misma categoría juntos. */

select detalleVenta.refart, articulos.nomart, 
				concat_ws('', articulos.desart,' (',categorias.descat,')') as descripcion, 
				date_format(fecventa, '%M - %Y, %d (%W)')
from detalleVenta join articulos on detalleVenta.refart = articulos.refart
					join categorias on articulos.codcat = categorias.codcat
                    join ventas on detalleVenta.codventa = ventas.codventa
order by categorias.codcat;


 /* P3. Obtener el precio medio de los artículos de cada promoción (muestra la 
 descripción de la promoción) del año 2012. (Se usará en el ejercicio 7). */
 
select promociones.despromo, avg(precioartpromo)
from catalogospromos join promociones on catalogospromos.codpromo = promociones.codpromo
where year(fecinipromo) = 2012
group by promociones.codpromo;
 
 
 /* P4. Prepara una rutina que muestre un listado de artículos, su referencia, 
 su nombre y la categoría que no hayan estado en ninguna promoción 
 que haya empezado en este año. */

select * from promociones;
select * from catalogospromos join articulos on catalogospromos.refart = articulos.refart;

drop procedure if exists simul7_4;
delimiter **
create procedure simul7_4()
begin
	select articulos.refart, articulos.nomart, articulos.codcat
    from articulos 	
    where refart not in (select refart
							from catalogospromos join promociones on catalogospromos.codpromo = promociones.codpromo
                            where year(fecinipromo) = 2012
						);
end **
delimiter ;
call simul7_4();


/* P5. Queremos asignar una contraseña a nuestros clientes para la APP de la cadena, 
prepara una rutina que dado un dni y un teléfono, nos devueltva la contraseña 
inicial que estará formada por: la inicial del nombre, los números correspondientes 
a las posiciones 3ª, 4ª Y 5ª del dni y el número de caracteres de su nombre completo. 
Asegúrate que el nombre no lleva espacios a izquierda ni derecha. */

select * from clientes;

drop function if exists simul7_5;
delimiter **
create function simul7_5(email varchar(30),
						telefono char(9))
returns char(7)
deterministic
begin
	return (select concat(substring(nomcli, 1, 1),
							substring(email, 3, 3),
                             length(trim(concat_ws(' ', nomcli, ape1cli, ape2cli))))
			from clientes
            where clientes.email = email and clientes.tlfcli = telefono
    );
end **
delimiter ;
select simul7_5('EliseaPabonAngulo@dodgit.com', '984 208 4');


/* P6. Sabemos que de nuestros vendedores almacenamos en nomvende su nombre 
y su primer apellido y su segundo apellido, no hay vendedores con nombres 
ni apellidos compuestos. Obten su contraseña formada por la inicial del nombre, 
las 3 primeras letras del primer apellido y las 3 primeras letras del segundo apellido. */

select * from vendedores;

select concat(substring(nomvende, 1, 1),
				substring(nomvende, locate(' ', nomvende) + 1, 3),
                substring(nomvende, locate(' ', nomvende, locate(' ', nomvende) + 1) + 1, 3)) as clave
from vendedores;


/* P7. Queremos saber las promociones que comiencen en el mes actual y para 
las que la media de los precios de los artículos de dichas promociones coincidan 
con alguna de las de un año determinado (utiliza el ejercicio P3. 
Tendrás que hacer alguna modificación). */

drop procedure if exists simul7_7;
delimiter **
create procedure simul7_7(anio int)
begin
	select promociones.despromo, avg(precioartpromo)
	from catalogospromos join promociones on catalogospromos.codpromo = promociones.codpromo
	-- where year(fecinipromo) = year(curdate()) and month(fecinipromo) = month(curdate())
	group by promociones.codpromo
    having avg(precioartpromo) in (select avg(precioartpromo)
									from catalogospromos join promociones on catalogospromos.codpromo = promociones.codpromo
									where year(fecinipromo) = anio
									group by promociones.codpromo);

end **
delimiter ;
call simul7_7(2012);


/* P8. Obtén un listado de artículos (referencia y nombre) cuyo precio venta 
sin promocionar sea el mismo que el que han tenido en alguna promoción. */

select refart, nomart
from articulos
where precioventa in (select precioartpromo
						from catalogospromos
                        where catalogospromos.refart = articulos.refart);
                        
-- eva
select refart, nomart
from articulos
where precioventa = any 
						(
							select precioartpromo
							from catalogospromos
							where catalogospromos.refart = articulos.refart
						);



