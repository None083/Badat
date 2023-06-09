use empresaclase;
select * from departamentos;

-- 1 --
delimiter $$
drop function if exists devuelvePresupuesto $$
create function devuelvePresupuesto(numeroDepto int)
returns decimal(10,2)
deterministic
begin

	declare presupuesto decimal(10,2);
    
	select departamentos.presude into presupuesto
    from departamentos
    where numde=numeroDepto;
    
    return presupuesto;

end $$
delimiter ;
call devuelvePresupuesto(130);
set @miPresupuesto = devuelvePresupuesto(130);
select @miPresupuesto;


-- 2 --
delimiter $$
drop procedure if exists muestraFecIngresoNombre $$
create procedure muestraFecIngresoNombre
	(in fecIngreso date,
    in nombre varchar(60),
    out numeroEmpleado int
    )
begin
    
	
    
    
end $$ 
delimiter ;


-- 3 version jorge, que en verda está mal --
/*	drop procedure if exists empleadoDirigir;
	delimiter **
	create procedure empleadosDirigir()
		begin
			select nomem, nomde
			from empleados
			left join dirigir on empleados.numem = dirigir.numempdirec
				left join departamentos on dirigir.numdepto = departamentos.numde
					and (fecfindir is null or fecfindir=curdate());
		end **
*/







