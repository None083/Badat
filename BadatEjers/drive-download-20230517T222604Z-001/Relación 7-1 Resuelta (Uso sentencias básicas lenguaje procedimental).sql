use empresa_clase;

/* EJERCICIO 6.1 */
/*
delimiter $$
create procedure GBD_2012_2013_U6_EJER1_1(out anio int)
no sql
begin
    set anio = year(current_date);

end
$$
delimiter ;
*/
/*
call GBD_2012_2013_U6_EJER1_1(@n);
select @n;
*/

/* EJERCICIO 6.2 */
/*
delimiter $$
create function GBD_2012_2013_U6_EJER1_2()

returns int
begin
    return year(current_date);

end
$$
delimiter ;
*/
/*
select GBD_2012_2013_U6_EJER1_2();
*/

/* EJERCICIO 6.3 */

/*
delimiter $$
create procedure GBD_2012_2013_U6_EJER1_3(in cadena varchar(50))
no sql
begin
    select upper(left(cadena,3));

end
$$
delimiter ;
*/
/*
call GBD_2012_2013_U6_EJER1_3('En un lugar de la Mancha');
*/

/* EJERCICIO 6.4 */
/*
delimiter $$
create procedure GBD_2012_2013_U6_EJER1_4(in cad1 varchar(50), 
    in cad2 varchar(50), out cad3 varchar(100) )

begin
    set cad3 =  upper(concat(cad1,cad2));

end
$$
delimiter ;
*/
/*
call GBD_2012_2013_U6_EJER1_4('cadena1 +', ' cadena2 ', @result);

select @result;
*/

/*  EJERCICIO 6.5 */
/*
delimiter $$
create function GBD_2012_2013_U6_EJER1_5(cat1 int, cat2 int)
returns decimal(10,2)
begin
    return sqrt(pow(cat1,2)+pow(cat2,2));

end
$$
delimiter ;
*/
/* select GBD_2012_2013_U6_EJER1_5(2,2);

/*
select GBD_2012_2013_U6_EJER1_5(2,2)
*/

/* EJERCICIO 6.6 */

/*
delimiter $$
create function GBD_2012_2013_U6_EJER1_6(dividendo int, divisor int)
returns boolean
begin
    declare res boolean;
    if mod(dividendo,divisor) = 0 then
        set res = 1;
    else
        set res = 0;
    end if;
    return res;
end
$$
delimiter ;
*/
/* select GBD_2012_2013_U6_EJER1_6(4,2),
          GBD_2012_2013_U6_EJER1_6(5,3),
          GBD_2012_2013_U6_EJER1_6(9,3);*/
/* EJERCICIO 6.7 */
/*
delimiter $$
create function GBD_2012_2013_U6_EJER1_7(numero int)
returns varchar(10)
begin
    declare res varchar(10);
    case numero
        when 1 then
            set res = 'lunes';
        when 2 then
            set res = 'martes';
        when 3 then
            set res = 'miércoles';
        when 4 then
            set res = 'jueves';
        when 5 then
            set res = 'viernes';
        when 6 then
            set res = 'sábado';
        when 7 then
            set res = 'domingo';
        else set res = 'no día semana';
    end case;
    return res;	
end $$
delimiter ;
*/

/* EJERCICIO 6.8 */

drop function GBD_2012_2013_U6_EJER1_8;
delimiter $$
create function GBD_2012_2013_U6_EJER1_8(n1 int, n2 int, n3 int)
returns int
begin
    /* select GBD_2012_2013_U6_EJER1_8(2,3,4), 
            GBD_2012_2013_U6_EJER1_8(5,4,2), 
            GBD_2012_2013_U6_EJER1_8(34,989,87),
            GBD_2012_2013_U6_EJER1_8(1,1,2);
    */
    declare max int;

    if n1 > n2 then 
    begin
        if n1 > n3 then
        begin
            set max = n1;
        end;
        else
        begin
            set max = n3;
        end;
        end if;
    end;
    else
    begin
        if n2 > n3 then
        begin
            set max = n2;
        end;
        else
        begin
            set max = n3;
        end;
        end if;
    end;
    end if;

    return max;
end
$$
delimiter ;

/* EJERCICIO 6.9 */

delimiter $$
create function GBD_2012_2013_U6_EJER1_9(palabra varchar(15))
returns bit
begin
    /* select GBD_2012_2013_U6_EJER1_9('ANA'),
            GBD_2012_2013_U6_EJER1_9('BELEN');*/
    DECLARE palindroma bit;
    if palabra = reverse(palabra) then
        set palindroma= 1;
    else 
        set palindroma= 0;
    end if;
    return palindroma;
end
$$
delimiter ;

/* EJERCICIO 6.10 */

delimiter $$
create procedure suma_n_con_repeat(in n int)

begin
    declare cont,suma int;
    set cont = 0;
    set suma = 0;
    REPEAT

    begin
        set suma = suma + cont;
        set cont = cont + 1;
    end;
    UNTIL cont>n
    end repeat;
    select suma;
end
$$
delimiter ;


delimiter $$
create procedure suma_n_con_while(in n int)

begin
	declare cont,suma int default 0;
    
	set cont = n;
    while  cont >= 1 do
    begin
        set suma = suma + cont;
        set cont = cont - 1;
    end;
    end while;
    select suma;  

/* empezando desde 0 hasta n ==>
	declare cont,suma int default 0;
    -- set cont = 0;
    -- set suma = 0;

    while cont <= n do
    begin
        set suma = suma + cont;
        set cont = cont + 1;
    end;
    end while;
    select suma;
*/
end $$
delimiter ;


/* EJERCICIO 6.11 */

delimiter $$
create procedure GBD_2012_2013_U6_EJER1_11(in m int)

begin
    declare cont,
        suma decimal (10,2);
    if m=0 then
        select 'división por cero';
    else if m = 1 then
        select 1;
    else
        begin
            set cont = 2;
           
            set suma = 0;
            
            while cont <= m do
            begin
                set suma = suma + 1/cont;
                set cont = cont + 1;
            end;
            end while;
            select suma;
        end;
    end if;
    end if;
end
$$
delimiter ;

delimiter $$
create procedure GBD_2012_2013_U6_EJER1_11_con_repeat(in m int)

begin
    declare cont,
        suma decimal (10,2);
    if m=0 then
        select 'división por cero';
    else if m = 1 then
        select 1;
    else
        begin
            set cont = 2;
           
            set suma = 0;
            
            repeat
            -- while cont <= m do
            begin
                set suma = suma + 1/cont;
                set cont = cont + 1;
            end;
            until cont > m end repeat;
            -- end while;
            select suma;
        end;
    end if;
    end if;
end
$$
delimiter ;


/* EJERCICIO 6.12 */
drop function if exists es_primo;
delimiter $$
-- create function GBD_2012_2013_U6_EJER1_12(n int)
create function es_primo(n int)
returns boolean
begin
    declare cont int;
   declare es_primo bit default 1;
    set cont = 2;
       
    while (cont < n) do
    begin
	if (n%cont = 0) then
        begin
           set es_primo = 0;
           set cont = n;
        end;
        else
        	set cont = cont + 1;
        end if;
    end;
    end while;
    
    return es_primo;
end
$$
delimiter ;
-- select es_primo(2), es_primo(10), es_primo(7);

/* EJERCICIO 6.13 */
drop function if exists GBD_2012_2013_U6_EJER1_13;
delimiter $$
create function GBD_2012_2013_U6_EJER1_13(n int)
returns int
begin
    declare cont, suma int;
    declare num_primos  int default 1;
    
    set cont = 1;
    set suma = 0;
    
    while (num_primos <= n) do
    begin
        if (es_primo (cont)) then
        begin
            set suma = suma + cont;
            set num_primos = num_primos + 1;
        end;
        end if;
       set cont = cont + 1;
    end;
    end while;

    return suma;
end
$$
delimiter ;

-- select GBD_2012_2013_U6_EJER1_13(5)

/* EJERCICIO 6.14 */
drop procedure if exists GBD_2012_2013_U6_EJER1_14;
delimiter $$
create procedure GBD_2012_2013_U6_EJER1_14(n int)
begin
    declare cont int;
    declare numid int;
    declare num_primos int default 0;
    
    drop table if exists primos;
    create temporary table if not exists primos
        (id int auto_increment primary key,
        primo int);

    set cont = 1;

    while (num_primos< n) do
    begin
        if es_primo (cont) then
            -- set numid = (select ifnull(max(id),0)+1 from primos);
            insert primos
                (primo)
            values
                (cont);
            set num_primos = num_primos + 1;
        end if;
        set cont = cont + 1;
    end;
    
    end while;
    select * from primos;
end
$$
delimiter ;
/* call GBD_2012_2013_U6_EJER1_14(5);
    select * from primos;
*/
/* EJERCICIO 6.15 */
/*
delimiter $$
create procedure GBD_2012_2013_U6_EJER1_15(n int, out n_primos int)
begin
    declare cont int;
    
    set cont = 1;
    delete
    from primos;
    while (cont <= n) do
    begin
        if (es_primo (cont)) then
            insert primos
                (id, primo)
            values
                ((select ifnull(max(id),0)+1 from primos), cont);
        end if;
        set cont = cont + 1;
    end;
    end while;
    select n_primos = ifnull(count(*),0)
    from primos;
end
$$
delimiter ;
*/
