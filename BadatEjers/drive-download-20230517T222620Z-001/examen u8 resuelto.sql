
/* examen u8-g1 resuelto */
use bdventapromocionescompleta
/* p1 */

/*

Cuando se incluye un producto en una promoción, queremos controlar que su precio promocionado en ningún caso pueda 
ser mayor o igual al precio de venta habitual (precio fuera de promoción). 
Si sucediera esto habrá que evitar que se añada dicho producto a la promoción y se avisará de lo sucedido mediante mensaje.

TABLA ==> CATALOGOSPROMOS
OPERACIÓN ==> INSERT
TIPO TRIGGER ==> BEFORE

*/

delimiter $$
create trigger compruebaprecio
	before insert on catalogospromos 
for each row
begin
	set new.precioratpromo = abs(new.precioartpromo);
	if new.precioartpromo >= (select precioventa from articulos where refart = new.refart) then
		signal sqlstate  '45000' set message_text  = 'el precio no es adecuado';
	end if;
end $$
delimiter ;

drop trigger if exists compruebamodifprecio;
delimiter $$
create trigger compruebamodifprecio
	before update on catalogospromos 
for each row
begin

	if (new.precioartpromo <> old.precioartpromo) and new.precioartpromo >= (select precioventa from articulos where refart = new.refart) then
		signal sqlstate  '45000' set message_text  = 'el precio no es adecuado';
	end if;


end $$
delimiter ;


/* p2 */
/*
También se nos ha pedido que controlemos lo anterior cuando se esté modificando el precio de un producto 
en una promoción. En este caso se permitirá la modificación pero se mantendrá el precio que tuviera previamente.

TABLA ==> CATALOGOSPROMOS
OPERACIÓN ==> UPDATE
TIPO TRIGGER ==> BEFORE

*/

delimiter $$
drop trigger if exists compruebaModificaprecio $$

create trigger compruebaModificaprecio
	before update on catalogospromos 
for each row
begin

	if old.precioartpromo <> new.precioartpromo 
		and new.precioartpromo >= (select precioventa from articulos where refart = new.refart) then
			set new.precioartpromo = old.precioartpromo;
	end if;
end $$
delimiter ;

/* examen u8-g2 resuelto */
/* p1 */
/*
Cuando un proyecto finaliza, se le pondrá la fecha de fin de proyecto. 
En ese momento queremos que de forma automática se anoten  las gratificaciones a los técnicos 
que han trabajado en dicho proyecto cuando corresponda (si el proyecto termina en el tiempo previsto).

TABLA ==> PROYECTOS
OPERACIÓN ==> UPDATE
TIPO ==> AFTER
*/
USE BDgestProyectos;

delimiter $$
create trigger gratificacionesAutomaticas
	after update on proyectos
for each row
begin

	if new.fecfinproy is not null and old.fecfinproy is null then
		/* EJEMPLO:
			new.fecfinproy = curdate() -- '2022/5/17'
			new.feciniproy = '2022/2/1'
            new.duracionprevista = 180  ('2022/8/1')
			
            '2022/8/1' >= '2022/5/17'
	*/
    
		if date_add(new.feciniproy, interval new.duracionprevista day) >= new.fecfinproy then
			begin
            /*
				update tecnicosenproyectos
					set fecfintrabajo = new.fecfinproy
				where numproyecto = new.numproyecto and fecfintrabajo is null;
              */  
				insert into gratificaciones
					(numproyecto,numtecnico, tiempoenproyecto,gratifTotal)
				(select numproyecto, numtec, datediff(fecfintrabajo,fecinitrabajo),
					datediff(fecfintrabajo,fecinitrabajo)*new.gratifPorDia
				 from tecnicosenproyectos
				 where numproyecto = new.numproyecto);
                 
				
			end;
		end if;
            
	end if;


end $$
delimiter ;

/* p2 */
/*
Se nos ha pedido que si un proyecto ya ha comenzado (la fecha de inicio de proyecto no tiene valor null) 
no se permita hacer ninguna modificación sobre los datos del proyecto.

tabla ==> proyectos
operacion ==> update 
tipo ==> before
*/
delimiter $$
create trigger controlProyectosIniciados
	before update on proyectos
for each row
begin

	if old.feciniproy is not null  then
		signal sqlstate '45000' set message_text = 'En este proyecto no se pueden modificar sus datos';	
	end if;


end $$
delimiter ;
show create trigger modificacionPrecioPromo;
drop trigger modificacionPrecioPromo;
/* g2
Se ha elaborado un procedimiento “OptimizaDuracionProy”. 
Nos piden que hagamos lo que consideremos oportuno para que se ejecute una vez cada trimestre durante 
los próximos 5 años. Para comenzar nos piden que lo dejemos preparado para que, 
desde hoy martes,  comience a ejecutarse el viernes a las 17.00h.


*/

create event ejer_g2_3

on schedule

-- every 1 quarter
every 3 month
	-- starts curdate() + interval 3 day
    -- starts '2021-05-25' + interval '3 17' day_hour
    starts '2021-05-25 17:00' + interval '3' day
    -- starts '2021-05-28 17:00'
    -- ends '2021-05-25' + interval '3 17' day_hour + interval 5 year
    ends '2021-05-25 17:00' + interval '3' day + interval 5 year
do call OptimizaDuracionProy();

/*
Se ha elaborado un procedimiento “OptimizaCatalogosPromos”. Nos piden que hagamos lo que consideremos 
oportuno para que se ejecute cada semestre (2 trimestres) durante el próximo año. 
Para comenzar nos piden que lo dejemos preparado para que, desde hoy martes,  
comience a ejecutarse el domingo a las 00.00h.

*/

create event ejer_g1_3

on schedule

every 2 quarter
-- every 6 month
	-- starts curdate() + interval 3 day
    -- starts curdate() + interval '5 0' day_hour
    starts '2021-05-28 17:00'
    -- ends curdate() + interval '5 0' day_hour + interval 1 year
    ends '2022-05-28 17:00' + interval 1 year
do call OptimizaCatalogosPromos();


select curdate(), curdate() + interval '5 0' day_hour;
