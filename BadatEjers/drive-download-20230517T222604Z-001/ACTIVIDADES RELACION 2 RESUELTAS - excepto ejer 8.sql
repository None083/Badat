use empresa_clase_2014;
/*
drop procedure if exists EJER_6_2;
DELIMITER $$
CREATE PROCEDURE EJER_6_2()
BEGIN
-- call EJER_6_2();
DECLARE numeroem int;
DECLARE fincursor bit default 0;
DECLARE curEmple CURSOR 
	FOR SELECT numem
	FROM empleados
	-- WHERE comisem is null or comisem =0;
    WHERE ifnull(comisem,0)=0;
DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' 
				SET fincursor = 1;


drop table if exists listado;
create temporary table listado
    (descripcion varchar(100));

OPEN curEmple;
FETCH FROM curEmple INTO numeroem;

WHILE fincursor = 0 DO
BEGIN
	
	INSERT INTO listado (descripcion)
    values (CONCAT('El empleado ', numeroem,' no tiene comisión'));

	FETCH FROM curEmple INTO numeroem;
END;
END WHILE;
CLOSE curEmple;

if (select count(*) from listado) > 0 then
    select * from listado;
else
    select 'NO EXISTEN EMPLEADOS SIN COMISIÓN';
end if;
drop table if exists listado;
END $$
DELIMITER ;
*/

drop procedure if exists EJER_6_3;
DELIMITER $$
CREATE PROCEDURE EJER_6_3()
BEGIN
-- call EJER_6_3();
DECLARE numeroem int;
DECLARE	nomdepto, nomdeaux varchar(60);
DECLARE final bit default 0;	

DECLARE curEmple CURSOR 
	FOR SELECT numem, nomde
	FROM empleados join departamentos on departamentos.numde = empleados.numde
	WHERE empleados.comisem is null or empleados.comisem =0
	ORDER BY departamentos.nomde;
DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET final = 1;

drop table if exists listado;
create temporary table listado
    (descripcion varchar(100));
OPEN curEmple;
FETCH FROM curEmple INTO numeroem,nomdepto;
SET nomdeaux='';
WHILE final = 0 DO
BEGIN
	IF (nomdeaux <> nomdepto) THEN
	BEGIN
		INSERT INTO listado 
            (descripcion) 
        VALUES 
            (CONCAT('Departamento: ', nomdepto));
		SET nomdeaux = nomdepto;
	END;
    END IF;
    INSERT INTO listado 
            (descripcion) 
        VALUES 
            (CONCAT('    El empleado ',numeroem, ' no tiene comisión'));
	FETCH FROM curEmple INTO numeroem, nomdepto;
END;
END WHILE;
CLOSE curEmple;

if (select count(*) from listado) > 0 then
    select * from listado;
else
    select 'NO EXISTEN EMPLEADOS SIN COMISIÓN';
end if;
drop table if exists listado;

END $$
DELIMITER ;




drop procedure if exists EJER_7_4;
delimiter $$

CREATE PROCEDURE EJER_7_4()
BEGIN
  select numem, salarem 
  from empleados where ifnull(comisem,0)=0
 		OR numhiem > (select avg(numhiem) from empleados);

-- call EJER_7_4();

  select numem, salarem 
  from empleados where ifnull(comisem,0)=0
		OR numhiem > (select avg(numhiem) from empleados);

DECLARE final bit default 0;
DECLARE numeroem, cont int;
DECLARE curEmple CURSOR
	FOR SELECT numem
	FROM empleados
	WHERE comisem is null OR comisem =0 -- ifnull(comiem,0)=0
		OR numhiem > (select avg(numhiem) from empleados);

DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' 
	SET final = 1;

set cont = 0;
OPEN curEmple;
FETCH FROM curEmple INTO numeroem;

WHILE (final = FALSE) DO -- NOT final DO
BEGIN
	UPDATE empleados
	SET salarem = salarem*1.02
	WHERE numem = numeroem;
    set cont = cont +1;
 	FETCH FROM curEmple INTO numeroem;
END;
END WHILE;	
CLOSE curEmple;

SELECT CONCAT('Se ha incrementado el salario de ', cont, ' empleados');
END $$
delimiter ;


drop procedure if exists EJER_7_5;
DELIMITER $$
CREATE PROCEDURE EJER_7_5
(	accion bit,
	porcentaje decimal
)
BEGIN
-- SELECT numem, salarem from empleados;
-- CALL EJER_7_5(1,5);
-- CALL EJER_7_5(0,5);
DECLARE numeroem, cont int;
DECLARE final bit default 0;

DECLARE curEmple CURSOR
	FOR SELECT numem
	FROM empleados;

DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET final = 1;

set cont = 0;
OPEN curEmple;
FETCH FROM curEmple INTO numeroem;
-- WHILE not final DO
WHILE final = 0 DO
BEGIN
	IF (accion = 1) THEN
		UPDATE empleados
		SET salarem = salarem + salarem*porcentaje/100
		WHERE numem = numeroem;
	ELSE 
		UPDATE empleados
		SET salarem = salarem - salarem*porcentaje/100
		WHERE numem = numeroem;
    END IF;
    set cont = cont +1;
	FETCH FROM curEmple INTO numeroem;
END;
END WHILE;
CLOSE curEmple;

IF accion = 1 then
    SELECT CONCAT('Se ha incrementado el salario de ', cont, ' empleados');
else
    SELECT CONCAT('Se ha decrementado el salario de ', cont, ' empleados');
end if;

END $$
DELIMITER ;

/*
ALTER TABLE empleados
ADD 
	userem varchar(12),
	passem varchar(12)
*/
/*
DROP PROCEDURE IF EXISTS EJER_7_6;
DELIMITER $$
CREATE PROCEDURE EJER_7_6()
BEGIN
-- select numem, nomem, ape1em, userem, passem from empleados;
-- CALL EJER_7_6();
DECLARE nombreem, apellido1em VARCHAR(20);
DECLARE numeroem int;
DECLARE final bit default 0;
	 
DECLARE curEmple CURSOR
	FOR SELECT numem,nomem, ape1em
	FROM empleados;

DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET final = 1;

OPEN curEmple;
FETCH FROM curEmple INTO numeroem, nombreem, apellido1em;

WHILE not final DO
BEGIN
	UPDATE empleados
	SET userem = LEFT(concat(nombreem,apellido1em),12),
		passem = LEFT(concat(nombreem,apellido1em),12)
	WHERE numem = numeroem;
	FETCH NEXT FROM curEmple INTO numeroem, nombreem, apellido1em;
END;
END WHILE;	
CLOSE curEmple;

END $$
DELIMITER ;
*/
/*
DROP PROCEDURE IF EXISTS EJER_6_7;
DELIMITER $$
CREATE PROCEDURE EJER_6_7()
BEGIN
DECLARE final BIT DEFAULT 0;
DECLARE numeroem INT;
DECLARE nomuserem VARCHAR(12);

DECLARE curEmple CURSOR
	FOR SELECT numem, nomuserem
	FROM empleados;
DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET final = 1;
OPEN curEmple;

FETCH FROM curEmple INTO numeroem, nomuserem;

WHILE (final = 0) DO
BEGIN
	UPDATE empleados
	SET passem = nomuserem
	WHERE numem = numeroem;	
	FETCH FROM curEmple INTO numeroem, nomuserem;
END;
END WHILE;
CLOSE curEmple;

END $$
DELIMITER ;
*/


drop procedure if exists EJER_6_9;
DELIMITER $$
CREATE PROCEDURE EJER_6_9()
BEGIN
-- call EJER_6_9();

DECLARE numeroem int;
declare comision decimal(10,2);
declare sincomis, concomis smallint;
DECLARE nombre varchar(100);
DECLARE	nomdepto, nomdeaux varchar(60);
DECLARE final bit default 0;
	
DECLARE curEmple CURSOR 
	FOR SELECT empleados.numem, departamentos.nomde, 
        ifnull(empleados.comisem,0), concat(empleados.nomem, 
            empleados.ape1em, ifnull(empleados.ape2em,''))
	FROM empleados join departamentos on departamentos.numde = empleados.numde
	ORDER BY departamentos.nomde, ifnull(empleados.comisem,0);

DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET final = 1;

drop table if exists listado;
create temporary table listado
    (descripcion varchar(100));
OPEN curEmple;
FETCH FROM curEmple INTO numeroem,nomdepto, comision, nombre;
SET nomdeaux='';
WHILE final = 0 DO
BEGIN
	IF (nomdeaux <> nomdepto) THEN
	BEGIN
		INSERT INTO listado 
            (descripcion) 
        VALUES 
            (CONCAT('Departamento: ', nomdepto));
		SET nomdeaux = nomdepto;
        SET sincomis = 0;
		SET concomis = 0;
	END;
    END IF;

    IF comision =0 and sincomis = 0 then
	BEGIN
        INSERT INTO listado 
            (descripcion) 
        VALUES 
            ('Empleados sin comisión:');
		SET sincomis = 1;
	END;
    end if;

    IF comision >0 and concomis = 0 then
	BEGIN
        INSERT INTO listado 
            (descripcion) 
        VALUES 
            ('Empleados con comisión:');
		SET concomis = 1;
	END;
    end if;

    if comision = 0 then
        INSERT INTO listado 
            (descripcion) 
        VALUES 
            (CONCAT('    ',numeroem, ' -- ', nombre));
	ELSE
        INSERT INTO listado 
            (descripcion) 
        VALUES 
            (CONCAT('    ',numeroem, ' -- ', nombre, ' --- COMISION: ', comision));
    END IF;
	FETCH FROM curEmple INTO numeroem, nomdepto, comision, nombre;
END;
END WHILE;
CLOSE curEmple;

if (select count(*) from listado) > 0 then
    select * from listado;
else
    select 'NO EXISTEN EMPLEADOS';
end if;
drop table if exists listado;

END $$
DELIMITER ;


drop procedure if exists EJER_6_10; 
DELIMITER $$
create procedure EJER_6_10
(
numdepto int
)
BEGIN
-- CALL EJER_6_10(121);
DECLARE director, nomdirdep VARCHAR(70);
DECLARE nomdepto VARCHAR(60);
DECLARE final bit default 0;
	 
DECLARE deptosdep CURSOR
	FOR select departamentos.nomde, 
            CONCAT(empleados.ape1em, IFNULL(CONCAT(' ', empleados.ape2em),''), ', ', nomem)
        from departamentos join dirigir on departamentos.numde = dirigir.numdepto
            join empleados on dirigir.numempdirec = empleados.numem
        where depende = numdepto and (fecfindir is null or fecfindir >= curdate());

DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET final = 1;

drop table if exists listado;
create temporary table listado
    (descripcion varchar(200));

SELECT CONCAT(empleados.ape1em, IFNULL(CONCAT(' ', empleados.ape2em),''), ', ', nomem) INTO director
FROM dirigir JOIN empleados ON empleados.numem = dirigir.numempdirec
WHERE dirigir.numdepto = numdepto and (fecfindir is null or fecfindir >= curdate());

INSERT INTO listado
    (descripcion)
VALUES
    (CONCAT('DIRECTOR: ', director));

OPEN deptosdep;
FETCH FROM deptosdep INTO nomdepto, nomdirdep;

IF found_rows() is null THEN -- devuelve el número de filas rdel cursor con el que estoy trabajando
begin
/*    INSERT INTO listado
        (descripcion)
    VALUES
        (CONCAT('NO HAY DEPARTAMENTOS QUE DEPENDAN DEL DEPTO ',numdepto));
*/
end;
ELSE
BEGIN
	INSERT INTO listado
        (descripcion)
    VALUES
        ('DEPARTAMENTOS DEPENDIENTES:' );

	WHILE not final DO
	BEGIN
        INSERT INTO listado
            (descripcion)
        VALUES
            (CONCAT('  DEPTO: ', nomdepto, ' --- DIRECTOR: ', nomdirdep));
		
		FETCH FROM deptosdep INTO nomdepto, nomdirdep;
	END;
    END WHILE;
END;
END IF;
CLOSE deptosdep;

select * from listado;

drop table if exists listado;
END $$
DELIMITER ;


DROP PROCEDURE IF EXISTS EJER_6_11;
DELIMITER $$
CREATE PROCEDURE EJER_6_11()
BEGIN

-- CALL EJER_6_11();

DECLARE numcentro, numdepto, numeroemple int;
DECLARE nomcentro, nomceaux, nomdepto varchar(60) DEFAULT '';
DECLARE final bit DEFAULT 0;
	
DECLARE curCentros CURSOR
	FOR SELECT centros.numce, centros.nomce, departamentos.numde, departamentos.nomde,
        (SELECT count(*) from empleados where numde = departamentos.numde)
	FROM departamentos inner join centros on centros.numce = departamentos.numce 
	ORDER BY centros.numce;

/*	FOR SELECT centros.numce, centros.nomce, departamentos.numde, departamentos.nomde, count(*) 
	FROM departamentos inner join centros on centros.numce = departamentos.numce 
		inner join empleados on departamentos.numde = empleados.numde
	GROUP BY centros.numce, departamentos.numde;
*/ 
DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET final = 1;

drop table if exists listado;
create temporary table listado
    (descripcion varchar(100));

OPEN curCentros;
FETCH FROM curCentros INTO numcentro,nomcentro,numdepto,nomdepto, numeroemple;

WHILE not final DO
BEGIN
	IF (nomceaux <> nomcentro) THEN
	BEGIN
        INSERT INTO listado
            (descripcion)
        VALUES
            (CONCAT('Centro de trabajo: ', numcentro, ' ==> ', nomcentro));
		
		INSERT INTO listado
        VALUES
		('Departamentos: ');
		SET nomceaux = nomcentro;
	END;
    END IF;
    INSERT INTO listado
        -- (descripcion)
    VALUES
        (CONCAT('   ', numdepto, ' - ', nomdepto, ' ==> ', numeroemple, ' empleados'));
		
	FETCH FROM curCentros INTO numcentro,nomcentro,numdepto,nomdepto, numeroemple;
END;	
END WHILE;

CLOSE curCentros;

select * from listado;

drop table if exists listado;

END $$
DELIMITER ;

