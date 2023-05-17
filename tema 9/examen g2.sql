use bdgestproyectos;

/* Cuando un proyecto finaliza, se le pondrá la fecha de fin de proyecto. 
En ese momento queremos que de forma automática se anoten  las gratificaciones 
a los técnicos que han trabajado en dicho proyecto cuando corresponda 
(si el proyecto termina en el tiempo previsto).*/

drop trigger if exists exam1;
delimiter $$
create trigger exam1
	after update on proyectos
	for each row
    begin
		if new.fecfinproy is not null and new.fecfinproy <> old.fecfinproy 
										and new.fecfinproy <= date_add(new.feciniproy, interval new.duracionprevista day) then
        insert into gratificaciones
					(numproyecto, numtecnico, tiempoenproyecto, gratifTotal)
				(select numproyecto, numtec, datediff(fecfintrabajo, fecinitrabajo),
					datediff(fecfintrabajo, fecinitrabajo) * new.gratifPorDia
				 from tecnicosenproyectos
				 where numproyecto = new.numproyecto);
		end if;
    end $$
    
/* Se nos ha pedido que si un proyecto ya ha comenzado 
(la fecha de inicio de proyecto no tiene valor null) 
no se permita hacer ninguna modificación sobre los datos del proyecto. */

drop trigger if exists exam2;
delimiter $$
create trigger exam2
	before update on proyectos
	for each row
    begin
		if old.feciniproy is not null then
        signal sqlstate '45000' set message_text = 'Proyecto en curso';
		end if;
    end $$

/* Se ha elaborado un procedimiento “OptimizaDuracionProy”. 
Nos piden que hagamos lo que consideremos oportuno para que 
se ejecute una vez cada trimestre durante los próximos 5 años. 
Para comenzar nos piden que lo dejemos preparado para que, 
desde hoy martes,  comience a ejecutarse el viernes a las 17.00h. */

drop event if exists exam3;
delimiter $$
create event exam3
on schedule every 3 month
starts '2023-05-18 17:00'
ends curdate() + interval 5 year do
begin
	call OptimizaDuracionProy();
end $$
    
    
    
    
