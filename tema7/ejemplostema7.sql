-- buscar el numero de empleados de cada depto
-- pero no me interesan los deptos de menos de tres miembros
select numde, count(*)
from empleados
-- where count(*) >= 3 no funciona
group by numde
having count(*) >= 3; -- sí funciona, ya que se ha hecho después de la función de agrupado

-- buscar el numero de empleados de cada depto con salario mayor de 1500
-- pero no me interesan los deptos de menos de tres miembros
select numde, count(*) as numEmple  -- (5)
from empleados                      -- (1)
where salarem > 1500                -- (2)
group by numde                      -- (3)
having count(*) >= 3                -- (4)
-- order by count(*) desc; -- (6)
-- order by 2 desc; -- (6)
order by numEmple desc;             -- (6)


-- 17/04/23

-- subselect
set @depto = (select numem
			from empleados
			where numem=120);
            
insert into empleados
	(num, nomem, numde, ape1em)
value
	(1999, @depto, 'pep', 'del campo');


insert into empleados
	(num, nomem, numde, ape1em)
value
	(1999, (select numde
			from empleados
			where numem=120),
	'pepe', 'del campo');
    
create table centros_new
	(numde int primary key,
    nomce varchar(60)
    );
insert into centros_new
	(numce, nomce)
(select numce, nomce
from centros
);

select *
from centros_new;

update empleados
set numde = (select numde
			from empleados
            where numem=120)
where numem = 280;


-- busca los empleados que ganan mas que las empleados del depto 110

select numem, nomem, salarem
from empleados
where salarem > all (select salarem
					from empleados
					where numde = 110);

select numem, nomem, salarem
from empleados
where salarem > (select max(salarem)
				from empleados
				where numde = 110);
                
-- buscar empleados que ganan lo mismo que alguno de los del departamento 110

select numem, nomem, salarem
from empleados
where salarem > some (select salarem
					from empleados)
	and numde <> 110; -- distinto del 110
    
select numem, nomem, salarem
from empleados
where salarem in (select salarem -- es lo mismo que any y some
					from empleados)
	and numde <> 110;

-- busca empleados que ganen diferente a los del depto 110

select numem, nomem, salarem
from empleados
where salarem not in (select salarem
					from empleados);

select numem, nomem, salarem
from empleados
where salarem <> all (select salarem
					from empleados);
                    
-- 20/04/23

/* se suman filas con "union", deben tener dominios compatibles
si un dato fuera decimal y el otro varchar no se podría
deben haber el mismo numero de columnas y el mismo orden */
drop view if exists invitados;
create view invitados
	(numInvitado, nombreInvitado, emailInvitado) -- alias
as
select numcli as identificador, concat_ws(' ', nomcli, ape1cli, ape2cli) as invitado, email as emailInvitado
from clientes
union -- si le pongo el distinct no salen repetidos, si pongo all salen todos
select numem, concat_ws(' ', nomem, ape1em, ape2em), dniem
from empleados;
/* el create view es parecido auna tabla temporal, pero no ocupa espacio y se puede usar 
para trabajar con estos datos que he unido como he querido con union */

select * from invitados;

/*union
select numcolab, nombrecompleto, emailcolab
from colaboradores
....*/








