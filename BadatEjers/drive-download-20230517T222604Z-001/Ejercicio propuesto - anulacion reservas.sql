//****1 EN BBDD TURRUAL **/////
/*1. Prepara una función que, dadas dos fechas y un número n, 
devuelva verdadero (1) si hay menos de n días entre las dos fechas y falso (0) en caso contrario
*/
drop function if exists menosdias;
delimiter $$
create function menosdias
	(fechaini date,
     fechafin date,
     dias int
     )
returns boolean
deterministic
begin
	declare resultado boolean default false;
    
	if abs(datediff(fechafin,fechaini)) < dias then
		set resultado = true;
	end if;
	return resultado;
    -- return (abs(datediff(fechafin,fechaini)) < dias );
end $$ 
delimiter ;

select datediff(curdate(),'2020/5/10');
select datediff('2020/5/10', curdate());

select datediff(curdate(),'2020/5/2') <7;
select datediff('2020/5/2', curdate()) <7;




select menosdias('2020/5/10', '2020/5/2', 5); -- ==> false
select menosdias('2020/5/3', '2020/5/2', 5); -- ==> true

/*
2. Crea una tabla de reservasanuladas, en la que almacenaremos las reservas que se anulen, 
la anulación será manual (tipo M) o automática (A). Los campos de esta tabla serán:
codanulacion (int), codreserva (int), fecanulacion (date), tipo_anulacion (contendrá M o A), observaciones
*/
drop table if exists reservasanuladas;
create table if not exists reservasanuladas
	(codanulacion int,
     -- codanulacion int auto_increment,
     codreserva int,
     fecanulacion date,
     tipoanulacion enum('M','A'), -- tipoanulacion podrá ser M o A
     -- tipoanulacion set('M,A'), -- tipoanulacion podrá ser 'M', 'A', 'M,A'
     -- en este caso set no tendría sentido
     observaciones varchar(500),
    constraint pk_reservasAnuladas primary key (codanulacion),
    constraint fk_reservasAnuladas_reservas foreign key (codreserva) 
		references reservas (codreserva) on delete no action on update cascade
    );
select * from reservasanuladas;
/*
3. Haz el procedimiento “anulacionesAutomaticas”, 
en este procedimiento se registrará la anulación automática (en la tabla del apartado 2) 
de las reservas no anuladas que se hayan hecho hace más de una semana y de las que no hayamos recibido el pago 
a cuenta.
Además anotaremos la fecha de anulación en la reserva y se añadirá como observación 
‘Se ha procedido a hacer anulación automática por exceder tiempo sin pago a cuenta’. 
Utiliza la función del apartado 1 donde consideres necesario.

Piensa en dos versiones de este procedimiento. 
Ver1.- Sin utilizar cursores
Ver2.- Utilizando un cursor para recorrer las reservas de las que hay que hacer anulaciones.
*/

/*** VERSION 1 - SIN UTILIZAR CURSORES ***//


	/** versión Fabian */
    
/* 1. creaamos una tabla temporal con todos los datos que necesitamos
 2. codanulacion es auto_increment
 3. insertar todos las reservas a anular en la tabla temporal
 4.
 insert into reservasanuladas
 
 (select * from tablatemporal)
*/

/**** VERSIÓN SANDER

CREATE PROCEDURE anulacionesautomaticas
	()
    BEGIN
		DECLARE codres INT;
        DECLARE maxres INT;
        DECLARE contador INT DEFAULT 1;
        
		SET codres = (SELECT min(codreserva)
						FROM reservas
						WHERE ifnull(pagocuenta, 0) = 0 AND 
							NOT rel1act1(fecreserva, curdate(), 7));
                
		SET maxres = (SELECT max(codreserva)
						FROM reservas
						WHERE ifnull(pagocuenta, 0) = 0 AND 
							NOT rel1act1(fecreserva, curdate(), 7));
		
        SET contador = ifnull((SELECT max(codanulacion)
						    FROM reservasanuladas), 1) + 1;
		
        WHILE (codres <> (maxres + 1)) DO
			BEGIN
				IF EXISTS (SELECT codreserva 
						       FROM reservas 
                               WHERE codreserva = codres) AND
					NOT EXISTS (SELECT codreserva 
						            FROM reservasanuladas 
									WHERE codreserva = codres) THEN
                    BEGIN           
						INSERT INTO reservasanuladas
							VALUES (contador, codres, curdate(), 'A', 
								'Se ha procedido a hacer anulación automática por exceder tiempo sin pago a cuenta');
					
						SET contador = contador + 1;
                    END;
				END IF;
                SET codres = codres + 1;
            END;
        END WHILE;
    END::

**/

delimiter $$
drop procedure if exists AnulacionesAutomaticasV1 $$
create procedure AnulacionesAutomaticasV1 ()
begin
	-- call AnulacionesAutomaticasv1();
	declare codigoNuevaAnulacion int;
    declare ultimaReservaAnulada int default null;
    declare numReservasAnuladas int default 0;
	declare exit handler FOR sqlexception
				rollback;
   
   	start transaction;
    -- lo siguiente no sería necesario si codanulacion fuera auto_increment
    set codigoNuevaAnulacion = (select ifnull(max(codanulacion),0) from reservasanuladas);
    
	(select codreserva into ultimaReservaAnulada
	from reservas
    where pagocuenta is null
	 	and menosdias(fecreserva,curdate(),7) = 0
			and fecanulacion is null
	limit 1);
    
    while ultimaReservaAnulada is not null do
    begin
		-- la siguiente línea no sería necesaria si codanulacion fuera auto_increment:
		set codigoNuevaAnulacion = codigoNuevaAnulacion+1;
		insert into reservasanuladas
			-- (codreserva, fecanulacion, tipoanulacion, observaciones)
			(codanulacion, codreserva, fecanulacion, tipoanulacion, observaciones)
		values
			/* (ultimaReservaAnulada,curdate(),'A',
				'Se ha procedido a hacer anulación automática por exceder tiempo sin pago a cuenta');
			*/
			(codigoNuevaAnulacion,ultimaReservaAnulada,curdate(),'A',
				'Se ha procedido a hacer anulación automática por exceder tiempo sin pago a cuenta');
        update reservas
			set fecanulacion = curdate(),
				observaciones = 'Se ha procedido a hacer anulación automática por exceder tiempo sin pago a cuenta'
		where codreserva = ultimaReservaAnulada;
		
        set numReservasAnuladas = numReservasAnuladas+1;
        
        set ultimaReservaAnulada = null;
        (select codreserva into ultimaReservaAnulada
		from reservas
			where pagocuenta is null
				and menosdias(fecreserva,curdate(),7) = 0
					and fecanulacion is null
		limit 1);
    end;
    end while;
	commit;
    select concat('Se han anulado ', numReservasAnuladas, ' reservas');
end $$
delimiter ;

/*** VERSION 2 --- USANDO CURSORES ***/

delimiter $$
drop procedure if exists AnulacionesAutomaticasV2 $$
create procedure AnulacionesAutomaticasV2 ()
begin
	-- call AnulacionesAutomaticasv2();
	declare codigoNuevaAnulacion int;
    declare ultimaReservaAnulada int default null;
    declare finalcursor boolean default false;
    declare numReservasAnuladas int default 0;
    
    declare reservasPorAnular cursor for
						(select codreserva
						from reservas
						where pagocuenta is null
							and menosdias(fecreserva,curdate(),7) = false
								and fecanulacion is null
						);
	
    declare continue handler FOR SQLSTATE '02000' 
				SET finalcursor = true;
	declare exit handler FOR sqlexception
				begin
					rollback;
                    close reservasPorAnular;
                end;
	start transaction;
    set codigoNuevaAnulacion = (select ifnull(max(codanulacion),0) from reservasanuladas);
    
	open reservasPorAnular;
    fetch next from reservasPorAnular into ultimaReservaAnulada;
    
    while not finalcursor do
    begin
		set codigoNuevaAnulacion = codigoNuevaAnulacion+1;
		insert into reservasanuladas
			(codanulacion, codreserva, fecanulacion, tipoanulacion, observaciones)
		values
			(codigoNuevaAnulacion,ultimaReservaAnulada,curdate(),'A',
				'Se ha procedido a hacer anulación automática por exceder tiempo sin pago a cuenta');
        update reservas
			set fecanulacion = curdate(),
				observaciones = 'Se ha procedido a hacer anulación automática por exceder tiempo sin pago a cuenta'
		where codreserva = ultimaReservaAnulada;
		
        set numReservasAnuladas = numReservasAnuladas+1;
        fetch next from reservasPorAnular into ultimaReservaAnulada;
    end;
    end while;
    
    close reservasPorAnular;
    commit;
    select concat('Se han anulado ', numReservasAnuladas, ' reservas');
end $$
delimiter ;