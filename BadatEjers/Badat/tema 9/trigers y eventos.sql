use empresaclase;

/* Comprueba que no podamos contratar a empleados que no tengan 16 años. */

drop trigger if exists ejer1;
delimiter $$
create trigger ejer1
	before insert on empleados
    for each row
    begin
		if date_add(new.fecnaem, interval 16 year) > curdate() then
        signal sqlstate '45000' set message_text = 'no se cumple la edad';
        end if;
    end $$

/* Comprueba que el departamento de las personas que ejercen 
la dirección de los departamentos pertenezcan a dicho departamento. */

drop trigger if exists ejer2;
delimiter $$
create trigger ejer2
	before insert on dirigir
    for each row
    begin
		if (select numde from empleados where numem = new.numempdirec) <> new.numdepto then
        begin
        declare mensaje varchar(100);
        set mensaje = concat('El empleado no pertenece al departamento ', new.numdepto);
        signal sqlstate '45000' set message_text = mensaje;
        end;
        end if;
    end $$

/* Añade lo que consideres oportuno para que las comprobaciones 
anteriores se hagan también cuando se modifiquen la fecha de 
nacimiento de un empleado o al director/a de un departamento. */

drop trigger if exists ejer3;
delimiter $$
create trigger ejer3
	before update on empleados
    for each row
    begin
		if old.fecnaem <> new.fecnaem and date_add(new.fecnaem, interval 16 year) > curdate() then
        signal sqlstate '45000' set message_text = 'no se cumple la edad';
        end if;
    end $$
    
/* Añade una columna numempleados en la tabla departamentos. 
En ella vamos a almacenar el número de empleados de cada departamento.*/

alter table departamentos add column numeroEmpleados int;

/* Prepara un procecdimiento que para cada departamento calcule 
el número de empleados y guarde dicho valor en la columna creada en el apartado 4.*/

drop trigger if exists ejer5;
delimiter $$
create trigger ejer5
	after insert on empleados
    for each row
    begin

        update departamentos
        set numeroEmpleados = (select count(*) from empleados where numde = new.numde)
        where numde = new.numde;
        
    end $$
    
/* Prepara lo que consideres necesario para que cada 
trimestre se compruebe y actualice, en caso de 
ser necesario, el número de empleados de cada departamento.*/

drop event if exists ejer6;
delimiter $$
create event ejer6
	on schedule every 1 quarter
    starts '2023-05-17' do
    begin
		update departamentos
        set numeroEmpleados = (select count(*) from empleados where numde = departamentos.numde);
    end $$
    







