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