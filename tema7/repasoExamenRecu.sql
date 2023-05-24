-- EXAMEN T7
use gbdgestionatests;

/* 1_ Queremos saber el código de test y la materia a la que pertenece (su nombre) 
de aquellos tests en los que la diferencia entre la fecha de creación y 
publicación es de 3 meses o más. Ten en cuenta que puede que haya tests no 
pulicados aún, estos también deben ser tenidos en cuenta. */

select tests.codtest, materias.nommateria
from tests join materias on tests.codmateria = materias.codmateria
where DATE_ADD(feccreacion, interval 3 month) < ifnull(fecpublic, curdate());

/* 2_ Queremos asignar al alumnado una cuenta de email del dominio del centro (“micentro.es”). 
El nombre de usuario estará formado por: la primera y la última letra de su nombre, 
las 3 letras centrales de su primer apellido y su mes de nacimiento. Prepara una función que, 
dado el número de expediente de un alumno/a, nos devuelva su nombre de usuario. */

drop function if exists ejer2;
delimiter $$
create function ejer2(
						numExp varchar(12)
                        )
returns varchar(40)
deterministic
begin
	return (
			select concat(left(nomalum, 1), right(nomalum, 1), 
				substring(ape1alum, length(ape1alum) div 2, 3), month(fecnacim), '@micentro.es')
			from alumnos
            where numexped = numExp
			);
end $$
select ejer2(1);

/* 3_ dado el número de expediente de un alumno o alumna, obtener el número 
de respuestas acertadas en cada test y cada repetición. Queremos descartar 
aquellos tests y o repeticiones en los que el alumno haya contestado  
menos de 4 preguntas acertadamente. */

drop procedure if exists ejer3;
delimiter &&
create procedure ejer3(numExp char(12))
begin
	select respuestas.codtest, numrepeticion, count(*)
    from respuestas join preguntas on respuestas.codtest = preguntas.codtest 
		and respuestas.numpreg = preguntas.numpreg
	where respuestas.numexped = numExp 
		and respuestas.respuesta = preguntas.resvalida
		group by respuestas.codtest, respuestas.numrepeticion
	having count(*) >= 4;
end &&
call ejer3(1);

/* 4_ Obtén un listado en el que se muestre para cada materia (su nombre y curso) 
el número de tests que han realizado más de 2 alumnos o alumnas. */

select materias.nommateria, materias.cursomateria, count(distinct respuestas.codtest)
from materias join tests on materias.codmateria = tests.codmateria
				join respuestas on tests.codtest = respuestas.codtest
group by materias.nommateria
having count(distinct respuestas.numexped) > 2;


/* 5_ Hemos detectado errores en el sistema de selección de tests a alumnos/as 
y se han dado casos de alumnos/as que han resuelto tests de materias de las que 
no están matriculados. Prepara un procedimiento que nos de un listado con estos alumnos/as. 
Queremos que se muestre su número de expediente y su nombre completo (en una sola columna). */

select respuestas.numexped, tests.codtest, tests.codmateria
from respuestas join tests on respuestas.codtest = tests.codtest
    join materias on tests.codmateria = materias.codmateria;



drop procedure if exists ejer5;
delimiter &&
create procedure ejer5()
begin
	select alumnos.numexped, concat_ws(" ", nomalum, ape1alum, ape2alum) as NombreAlumno
    from alumnos join respuestas on alumnos.numexped = respuestas.numexped
					join tests on respuestas.codtest = tests.codtest
                    join materias on tests.codmateria = materias.codmateria
	where materias.codmateria not in (select codmateria
										 from matriculas
										 where matriculas.numexped = alumnos.numexped);
end &&
call ejer5();


/* 6_ Prepara una vista que nos sirva de catálogo de tests y preguntas y en el que 
no se muestren los nombres reales de las columnas. Los datos que queremos que se muestren 
son: el código y nombre de la materia, el código y la descripción del test, la respuesta 
valida (el texto de la respuesta válida),  el número de preguntas que tiene dicho test y 
si se puede repetir (debe mostrarse el texto ‘repetible’ o ‘no repetible’). 
(Pista.- Flow control function) */

drop view if exists catalogoTests;
create view catalogoTests
	(codMateria, NombreMateria, codTest, descripTest, /*respuestaValida,*/ repetible, numPreguntas)
AS
	select materias.codmateria, materias.nommateria, tests.codtest, tests.descrip, 
        /*if(resvalida='a',resa, if(resvalida ='b',resb,resc)),*/
        if(repetible > 0,'repetible','no repetible'), count(*)
    from materias join tests on materias.codmateria = tests.codmateria
		join preguntas on tests.codtest = preguntas.codtest
	
	group by materias.codmateria, tests.codtest;

select * from catalogoTests;

/* 7_ Prepara una función que, dado un alumno/a y una materia, nos devuelva la nota de 
dicho alumno/a en dicha materia. La nota se calculará obteniendo la media entre el número 
de respuestas correctas y el num. de preguntas de cada test de la materia. Solo se utilizarán 
los tests no repetibles (estos tendrán en el campo repetible de la tabla tests el valor 1, 
indicando así que solo se puede hacer una vez). Los alumnos que no hayan hecho alguno de 
los tests no repetibles de la materia, obtendrán una puntuación de cero en dicho test 
y esta nota entrará en la media. */

drop function if exists ejer7;
delimiter $$
create function ejer7(
						numExp char(12),
                        codMate int
                        )
returns decimal(4,2)
deterministic
begin
	return (
			select count(*)/count(distinct respuestas.codtest) 
			from respuestas join preguntas on respuestas.codtest = preguntas.codtest and respuestas.numpreg = preguntas.numpreg
							join tests on tests.codtest = preguntas.codtest
			where numexped = numExp and tests.codmateria = codMate
				and tests.repetible = 0 and respuestas.respuesta = preguntas.resvalida
			);
end $$
select ejer7("1", 1);



-- SIMULACRO T7

use ventapromoscompleta;

/* 1_ Queremos saber el importe de las ventas de artículos a cada uno de nuestros 
clientes (muestra el nombre). Queremos que cada cliente se muestre una sola vez y 
que aquellos a los que hayamos vendido más se muestren primero. */

select nomcli, sum(precioventa)
from detalleventa join ventas on detalleventa.codventa = ventas.codventa
					join clientes on ventas.codcli = clientes.codcli
group by clientes.codcli
order by sum(precioventa) desc;


/* 2_ Muestra un listado de todos los artículos vendidos, queremos mostrar 
la descripción del artículo y entre paréntesis la descripción de la categoría 
a la que pertenecen y la fecha de la venta con el formato “march - 2016, 1 (tuesday)”. 
Haz que se muestren todos los artículos de la misma categoría juntos. */

select articulos.refart, concat(articulos.desart," (",categorias.descat,")") as descripcion, date_format(ventas.fecventa, '%M - %Y, %d (%W)')
from articulos join categorias on articulos.codcat = categorias.codcat
				join detalleventa on articulos.refart = detalleventa.refart
                join ventas on detalleventa.codventa = ventas.codventa
order by categorias.codcat;


/* 3_ Obtener el precio medio de los artículos de cada promoción 
(muestra la descripción de la promoción) del año 2012. 
(Se usará en el ejercicio 7). */

select avg(precioartpromo), promociones.despromo
from catalogospromos join promociones on catalogospromos.codpromo = promociones.codpromo
where year(fecinipromo) = 2012
group by promociones.codpromo;


/* 4_ Prepara una rutina que muestre un listado de artículos, su referencia, 
su nombre y la categoría que no hayan estado en ninguna promoción que haya 
empezado en este año. */

select articulos.refart, articulos.nomart, articulos.codcat
from articulos
where articulos.refart not in (select catalogospromos.refart 
								from catalogospromos join promociones on catalogospromos.codpromo = promociones.codpromo
                                where year(fecinipromo) = year(curdate()));


/* 5_ Queremos asignar una contraseña a nuestros clientes para la APP de la cadena, 
prepara una rutuina que dado un dni y un teléfono, nos devueltva la contraseña 
inicial que estará formada por: la inicial del nombre, los números correspondientes 
a las posiciones 3ª, 4ª Y 5ª del dni y el número de caracteres de su nombre completo. 
Asegúrate que el nombre no lleva espacios a izquierda ni derecha. */

delimiter $$
drop function if exists exam_2019_5_2_5 $$
create function exam_2019_5_2_5
	(correo varchar(30),
	telefono char(9))
returns char(7)
begin
	-- select exam_2019_5_2_5('EliseaPabonAngulo@dodgit.com', '984 208 4')
	return (
			select concat(left(trim(nomcli),1), 
						  substring(email, 3,1),
						  substring(email, 4,1),
						  substring(email, 5,1), 
						  length(concat(trim(nomcli), trim(ape1cli), ifnull(trim(ape2cli),'')))
						)
			from clientes
			where email = correo and tlfcli = telefono
        );
        
end $$
delimiter ;

/* 6_ Sabemos que de nuestros vendedores almacenamos en nomvende su nombre 
y su primer apellido y su segundo apellido, no hay vendedores con nombres 
ni apellidos compuestos. Obten su contraseña formada por la inicial del nombre, 
las 3 primeras letras del primer apellido y las 3 primeras letras del segundo apellido.  */

select nomvende, concat(
						substring(nomvende,1,1),
						substring(nomvende,
								  locate(' ',nomvende)+1,3),
						substring(nomvende,locate(' ',nomvende,locate(' ',nomvende) + 1)+1,3)
					)
from vendedores;


/* 7_ Queremos saber las promociones que comiencen en el mes actual y 
para las que la media de los precios de los artículos de dichas 
promociones coincidan con alguna de las de un año determinado 
(utiliza el ejercicio P3. Tendrás que hacer alguna modificación). */

delimiter $$
drop procedure if exists exam_2019_5_2_7 $$
create procedure exam_2019_5_2_7
	(in anyo int)
begin    
	-- call exam_2019_5_2_7(2012);
	select despromo, avg(precioartpromo)
	from catalogospromos join promociones
		on catalogospromos.codpromo = promociones.codpromo
	-- NOTA: quitar where para probar, ya que no hay datos de este año
	where year(fecinipromo)=year(curdate()) and month(fecinipromo)=month(curdate())
	group by promociones.codpromo
	having avg(precioartpromo) in (select avg(precioartpromo)
								   from catalogospromos join promociones
										on catalogospromos.codpromo = promociones.codpromo
								   where year(fecinipromo)=anyo
								   group by promociones.codpromo
								   );
end $$
delimiter ;


/* 8_ Obtén un listado de artículos (referencia y nombre) cuyo 
precio venta sin promocionar sea el mismo que el que han tenido 
en alguna promoción. */

select refart, nomart
from articulos
where precioventa = any (
						select precioartpromo
						from catalogospromos
						where catalogospromos.refart = articulos.refart
						);







