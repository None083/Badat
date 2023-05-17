/*3. Crea un procedimiento que muestre las tres primeras letras 
de una cadena pasada como parámetro en mayúsculas.*/

drop procedure if exists ejer3;
delimiter $$
create procedure ejer3(
						letras varchar(50))
begin
	select upper(left(letras, 3));
end $$
delimiter ;
call ejer3("hola");

/* Crea un procedimiento que devuelva una cadena 
formada por dos cadenas, pasadas como parámetros, concatenadas y en mayúsculas. */

drop procedure if exists ejer4;
delimiter $$
create procedure ejer4(
						cadena1 varchar(20), 
                        cadena2 varchar(20)
                        )
begin
	select upper(concat(cadena1," ", cadena2));
end $$
delimiter ;
call ejer4("hola", "adios");

/* Crea una función que devuelva 1 ó 0 en función de 
si un número es o no divisible por otro. */

drop function if exists ejer6;
delimiter $$
create function ejer6(
						num1 int,
                        num2 int
                        )
returns int
deterministic 
begin
	declare resultado int;
    
    if (num1%num2=0) then -- if mod(num1, num2) = 0 then
    set resultado = 1;
    else 
    set resultado = 0;
    end if;
    
    return resultado;
    
end $$
delimiter ;
select ejer6(6, 4);

/* Crea una función que devuelva el día de la semana (lunes, martes, …) 
en función de un número de entrada (1: lunes, 2:martes, …). */

drop function if exists ejer7;
delimiter $$
create function ejer7(
						num int
                        )
returns varchar(10)
deterministic 
begin
	declare resultado varchar(10);
    
    case num 
    when 1 then 
		set resultado = "lunes";
    when 2 then 
		set resultado = "martes";
	when 3 then 
		set resultado = "miércoles";
	when 4 then 
		set resultado = "jueves";
	else set resultado = 'no día semana';
	end case;
    return resultado;
    
end $$
delimiter ;
select ejer7(2);

/* Crea una función que devuelva el mayor de 
tres números que pasamos como parámetros. */

drop function if exists ejer8;
delimiter $$
create function ejer8(
						num1 int,
                        num2 int,
                        num3 int
                        )
returns int
deterministic 
begin
	declare resul int;
    
    if (num1>num2 and num1>num3) then
    set resul = num1;
    elseif (num2>num3) then
    set resul = num2;
    else
    set resul= num3;
    end if;
    
    return resul;
    
end $$
delimiter ;
select ejer8(4, 4, 2);


