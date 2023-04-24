use empresaclase;

-- 1
drop procedure if exists ejercicio3_1;
delimiter $$
create procedure ejercicio3_1(out salariomaximo decimal(7,2))
begin 
	select max(salarem) into salariomaximo from empleados;
    end $$
delimiter ;

call ejercicio3_1(@salarioMaximo);
select @salarioMaximo;

-- 2
drop procedure if exists ejercicio3_2;
delimiter $$
create procedure ejercicio3_1(out salariominimo decimal(7,2))
begin 
	select min(salarem) into salariominimo from empleados;
    end $$
delimiter ;

call ejercicio3_2(@salarioMinimo);
select @salarioMinimo;

-- 3
drop procedure if exists ejercicio3_3;
delimiter $$
create procedure ejercicio3_3(out salariomedio decimal(7,2))
begin
	select avg(salarem) into salariomedio from empleados;
end $$
delimiter ;
call ejercicio3_3(@salarioMedio);
select @salarioMedio;

-- 4
drop procedure if exists ejercicio3_4;
delimiter $$
create procedure ejercicio3_4(out salariomaximo decimal(7,2),
								out salariominimo decimal(7,2),
                                out salariomedio decimal(7,2))
begin
	select max(empleados.salarem), min(empleados.salarem), avg(empleados.salarem)
    into salariomaximo, salariominimo, salariomedio
    from empleados join departamentos on empleados.numde = departamentos.numde
    where departamentos.nomde='Organización';
end $$
call ejercicio3_4(@maxSalario, @minSalario, @salarioMedio);
select @maxSalario, @minSalario, @salarioMedio;

-- 5
drop procedure if exists ejercicio3_5;
delimiter $$
create procedure ejercicio3_5(out salariomaximo decimal(7,2),
								out salariominimo decimal(7,2),
                                out salariomedio decimal(7,2),
                                nomdepto varchar(60))
begin
	select max(empleados.salarem), min(empleados.salarem), avg(empleados.salarem)
    into salariomaximo, salariominimo, salariomedio
    from empleados join departamentos on empleados.numde = departamentos.numde
    where departamentos.nomde=nomdepto;
end $$
call ejercicio3_5(@maxSalario, @minSalario, @salarioMedio, 'Finanzas');
select @maxSalario, @minSalario, @salarioMedio;

-- 6
drop procedure if exists ejercicio3_6;
delimiter $$
create procedure ejercicio3_6(nomdepto varchar(60),
								out sumaSalarios decimal(9,2))
begin
	select sum(empleados.salarem+ifnull(empleados.comisem,0)) 
    into sumaSalarios
    from empleados
    join departamentos
    on empleados.numde=departamentos.numde
    where departamentos.nomde=nomdepto;
end $$
call ejercicio3_6('Finanzas', @sumaSalarios);
select @sumaSalarios;

-- 8
drop procedure if exists ejercicio3_8;
delimiter $$
create procedure ejercicio3_8()
begin
	select departamentos.nomde, max(empleados.salarem), min(empleados.salarem), avg(empleados.salarem)
    from departamentos join empleados on departamentos.numde=empleados.numde
    group by departamentos.nomde;
end $$
call ejercicio3_8();