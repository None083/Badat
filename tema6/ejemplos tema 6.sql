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
	(nombre varchar(60),
    ape1 varchar(60)
    )
begin -- bloque de procedimiento
    
select * from empleados.extelem
from empleados
where nomem = nombre and ape1em = ape1;
    
    
end $$
    
delimiter ;
