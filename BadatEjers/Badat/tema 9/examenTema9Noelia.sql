use GBDgestionaTests;

-- P1
drop trigger if exists ejer1;
delimiter $$
create trigger ejer1
	before insert on preguntas
	for each row
    begin
		if new.textopreg=(select textopreg from preguntas where codtest=new.codtest) then
        signal sqlstate '45000' set message_text = 'Pregunta repetida';
        end if;
    end $$
    
    
-- P2

-- a
drop procedure if exists incrementaNotas;
delimiter $$
create procedure incrementaNotas()
begin
	update matriculas
    set notas= notas+1
    where numexped = (select numexped 
						from alumnos join respuestas on alumnos.numexped=respuestas.numexped
                        where count(codtest) > 10);
end $$

-- b
drop event if exists ejer2b;
delimiter $$
create event ejer2b
on schedule every 1 year
starts '2023-06-20'
ends curdate() + interval 10 year do
begin
	call incrementaNotas();
end $$


-- P3
drop trigger if exists ejer3;
delimiter $$
create trigger ejer3
	before update on matriculas
	for each row
    begin
		if new.nota > 10 then
        signal sqlstate '45000' set message_text = 'El alumno no puede tener más de un 10';
		end if;
    end $$
-- para insert sería igual


-- P4
-- a
drop trigger if exists ejer4a;
delimiter $$
create trigger ejer4a
	before insert on alumnos
	for each row
    begin
		if new.nomuser not like('^[a-z=_?!][0-9a-z=_?!]{6+}') then
        signal sqlstate '45000' set message_text = 'Nombre de usuario no válido';
        end if;
    end $$


-- b
drop trigger if exists ejer4b;
delimiter $$
create trigger ejer4b
	before insert on alumnos
	for each row
    begin
		if new.email not like('@*\\.([a-z]{2}|[a-z]{3})') then
        signal sqlstate '45000' set message_text = 'Email no válido';
        end if;
    end $$


-- c
drop trigger if exists ejer4c;
delimiter $$
create trigger ejer4c
	before insert on alumnos
	for each row
    begin
		if new.telefono not like('^[679][0-9]{2} [0-9]{3} [0-9]{3}') then
        signal sqlstate '45000' set message_text = 'Teléfono no válido';
        end if;
    end $$


-- P5
drop trigger if exists ejer5;
delimiter $$
create trigger ejer5
	before insert on preguntas
	for each row
    begin
		if resa=resb and resa=resc and resb=resc then
        signal sqlstate '45000' set message_text = 'Todas las respuestas deben ser diferentes';
        end if;
    end $$




