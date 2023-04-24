-- Para la base de datos empresa_clase:
/*1 Hallar el salario medio para cada grupo de empleados con igual comisión y para 
los que no la tengan, pero solo nos interesan aquellos grupos de comisión en 
los que haya más de un empleado.*/

select ifnull(comisem,0), avg(salarem)
from empleados
group by ifnull(comisem,0)
having count(*) >1;

/*2 Para cada extensión telefónica, hallar cuantos empleados la usan y el 
salario medio de éstos. Solo nos interesan aquellos grupos en los que hay entre 1 y 3 empleados.*/

select extelem, count(*), avg(salarem)
from empleados
group by extelem
having count(*) between 1 and 3;


-- Para la base de datos de las promociones:
/*3 Prepara un procedimiento que, dado un código de promoción obtenga un listado 
con el nombre de las categorías que tienen al menos dos productos incluidos en dicha promoción.*/

select nomcat
from categorias join articulos 
		on categorias.codcat = articulos.codcat
		join catalogospromos 
			on articulos.refart = catalogospromos.refart
where catalogospromos.codpromo = 1
group by nomcat
having count(*) > 1;

/*4 Prepara un procedimiento que, dado un precio, obtenga un listado con el nombre 
de las categorías en las que el precio  medio de sus productos supera a dicho precio.*/

select nomcat, avg(precioventa)
from categorias join articulos 
		on categorias.codcat = articulos.codcat
group by nomcat
having avg(precioventa) > 3;

/*5 Prepara un procedimiento que muestre el importe total de las ventas por meses de un año dado.*/

select sum(precioventa)
from ventas join detalleVenta 
	on ventas.codventa = detalleVenta.codventa
where year(fecventa) = parametro -- year(curdate)
group by month(fecventa)

/*6 Como el ejercicio anterior, pero ahora solo nos interesa mostrar aquellos meses 
en los que se ha superado a la media del año.*/

having sum(precioventa) > (select avg(precioventa)
							from ventas join detalleVenta 
								on ventas.codventa = detalleVenta.codventa
									where year(fecventa) = parametro; -- year(curdate)


