/* ejercicio 3 */
SELECT empleados.*, nomde -- departamentos.nomde
FROM empleados join departamentos 
	on empleados.numde = departamentos.numde;


/* ejercicio 4 */
drop procedure if exists ejer_6_2_4;
delimiter $$
create procedure ejer_6_2_4
	(IN nombre varchar(60),
	 out extension char(3),
     out nombrecentro varchar(150)
	)
begin
	SELECT empleados.extelem, centros.nomce into  extension, nombrecentro
	FROM empleados join departamentos 
		on empleados.numde = departamentos.numde
			join centros
				on departamentos.numce = centros.numce
	WHERE concat_ws(' ',empleados.nomem,empleados.ape1em) = nombre;
    
end $$
delimiter ;

-- call ejer_6_2_4('Juan López', @dir,@centro);
-- select @dir, @centro;

/* ejercicio 5*/
SELECT nomde, concat(empleados.nomem, ' ', empleados.ape1em, ' ',
 			  ifnull(empleados.ape2em, ''))
	AS NOMBRECOMPLETO
FROM empleados join departamentos 
	on empleados.numde = departamentos.numde
WHERE departamentos.nomde = 'Personal' OR
		departamentos.nomde = 'Finanzas'
-- ORDER BY 2;
-- ORDER BY NOMBRECOMPLETO;
ORDER BY ape1em, ape2em, nomem; -- concat(empleados.nomem, empleados.ape1em, ifnull(empleados.ape2em, ''));

/* ejercicio 6*/
SELECT empleados.nomem, dirigir.fecinidir, dirigir.fecfindir
FROM empleados join dirigir 
	on empleados.numem = dirigir.numempdirec
		join departamentos on dirigir.numdepto = departamentos.numde
WHERE departamentos.nomde = 'Personal' and 
	fecinidir <= curdate() and
	(fecfindir is null or fecfindir >= curdate());
/* O TAMBIÉN:

WHERE departamentos.nomde = 'Personal' and 
	curdate() between fecinidir and
		ifnull(fecfindir,date_add(curdate(), interval 1 day))
*/
/* OTRA VERSIÓN DEL EJER. 6:
OBTENER LO MISMO PERO MEDIANTE UN PROCEDIMIENTO ALMACENADO 
AL QUE LE PASO POR PARÁMETROS LA FECHA EN LA QUE QUIERO CALCULAR
QUIEN ES EL DIRECTOR EN ESE MOMENTO
*/

DELIMITER $$
DROP PROCEDURE IF EXISTS ejer_5_2_6 $$
CREATE PROCEDURE ejer_5_2_6
	(in fecha date, in depto varchar(20),
	 out nombre varchar(100),
	 out extension char(3))
begin
	/* CALL ejer_5_2_6(curdate(), 'Personal', @var_nombre);
	   select @var_nombre;
	*/
	/* CALL ejer_5_2_6(curdate(), 'Personal', @var_nombre,
			@var_extension);
	   select @var_nombre;
	   select @var_extension;
	*/
	-- CALL ejer_5_2_6(curdate(), 'Dirección General');
	-- CALL ejer_5_2_6('2000-1-1', 'Personal');
	-- CALL ejer_5_2_6('1980-3-31', 'Dirección General');
/*	SET nombre = 
		(SELECT concat_ws(' ', empleados.nomem, empleados.ape1em, empleados.ape2em)
		FROM empleados join dirigir on empleados.numem = dirigir.numempdirec
			join departamentos on dirigir.numdepto = departamentos.numde
		WHERE departamentos.nomde = depto and 
			fecinidir <= fecha and
				(fecfindir is null or fecfindir >= fecha)
		);
	SET extension = 
		(SELECT extelem
		FROM empleados join dirigir on empleados.numem = dirigir.numempdirec
			join departamentos on dirigir.numdepto = departamentos.numde
		WHERE departamentos.nomde = depto and 
			fecinidir <= fecha and
				(fecfindir is null or fecfindir >= fecha)
		);
*/
/* O TAMBIÉN:*/
	SELECT concat_ws(' ', empleados.nomem, 
				empleados.ape1em, empleados.ape2em),
		empleados.extelem 
		into nombre, extension
	FROM empleados join dirigir on empleados.numem = dirigir.numempdirec
		join departamentos on dirigir.numdepto = departamentos.numde
	WHERE departamentos.nomde = depto and 
		fecinidir <= fecha and
			(fecfindir is null or fecfindir >= fecha);

end $$
delimiter ;

/* EL MISMO EJERCICIO PERO MEDIANTE UNA FUNCIÓN */

DELIMITER $$
DROP FUNCTION IF EXISTS FUN_ejer_5_2_6 $$
CREATE FUNCTION FUN_ejer_5_2_6
	(fecha date, 
	 depto varchar(20))
RETURNS varchar(100)
begin
	-- select FUN_ejer_5_2_6(curdate(), 'Personal');
	-- select FUN_ejer_5_2_6(curdate(), 'Dirección General');
	-- select FUN_ejer_5_2_6('2000-1-1', 'Personal');
	-- select FUN_ejer_5_2_6('1980-3-31', 'Dirección General');
	DECLARE nombre varchar(100);
	
	SELECT concat_ws(' ', empleados.nomem, 
				empleados.ape1em, empleados.ape2em)
		into nombre
	FROM empleados join dirigir on empleados.numem = dirigir.numempdirec
		join departamentos on dirigir.numdepto = departamentos.numde
	WHERE departamentos.nomde = depto and 
		fecinidir <= fecha and
			(fecfindir is null or fecfindir >= fecha);
	return nombre;
end $$
delimiter ;

/* EJERCICIO 7 */

DROP PROCEDURE IF EXISTS ejer_5_2_7;
DELIMITER $$
CREATE PROCEDURE ejer_5_2_7()
BEGIN
	SELECT departamentos.nomde, departamentos.presude
    FROM departamentos join centros 
		on departamentos.numce = centros.numce
    WHERE trim(centros.nomce) = 'SEDE CENTRAL'; 
END $$
DELIMITER ;
/* EJERCICIO 7 VERSIÓN - CUALQUIER DEPARTAMENTO */
DROP PROCEDURE IF EXISTS ejer_5_2_7_v2;
DELIMITER $$
CREATE PROCEDURE ejer_5_2_7_v2(centro varchar(60))
BEGIN
	SELECT departamentos.nomde, departamentos.presude
    FROM departamentos join centros on departamentos.numce = centros.numce
    WHERE lower(trim(centros.nomce)) = lower(trim(centro)); 
END $$
DELIMITER ;


/* EJERCICIO 8*/
/*
obtener el nombre de los centros de trabajo con
departamentos cuyo presupuesto esté entre x e y
*/

SELECT centros.nomce, 
FROM centros join departamentos 
	on centros.numce= departamentos.numce
where departamentos.presude between x and y;


DROP PROCEDURE IF EXISTS ejer_5_2_8;
DELIMITER $$
CREATE PROCEDURE ejer_5_2_8
	(valorini decimal(9,2), valorfin decimal(9,2))
	-- call ejer_5_2_8(100000, 150000)
BEGIN
	SELECT centros.nomce, sum(departamentos.presude)/count(*),
		avg(departamentos.presude)
	FROM centros join departamentos 
		on centros.numce= departamentos.numce
	where departamentos.nomde like 'd%'
	GROUP BY centros.nomce
	
	having sum(departamentos.presude) between 300000 and 500000;
END $$

DELIMITER ;

/* EJERCICIO 9*/
SELECT distinct  empleados.extelem
FROM empleados join departamentos 
		on empleados.numde= departamentos.numde
WHERE departamentos.nomde = 'Proceso de datos';
-- WHERE departamentos.nomde = 'Finanzas';

-- pero si quisieramos obtener el numero de 
-- extensiones telefónicas de un depto:
-- no entra
SELECT count(distinct empleados.extelem)
FROM empleados join departamentos 
		on empleados.numde= departamentos.numde
WHERE departamentos.nomde = 'Proceso de datos';

-- Si quisiéramos obtener el numero de extensiones 
-- telefónicas que usa cada depto:
SELECT nomde, count(distinct empleados.extelem)
FROM empleados join departamentos 
		on empleados.numde= departamentos.numde
GROUP BY nomde;

SELECT nomde, empleados.extelem
FROM empleados join departamentos 
		on empleados.numde= departamentos.numde
order BY nomde;

/* EJERCICIO 10*/
DROP PROCEDURE IF EXISTS ejer_5_2_10;
DELIMITER $$
CREATE PROCEDURE ejer_5_2_10(in nombredepto VARCHAR(60))
BEGIN
	select CONCAT(empleados.ape1em, 
				  ifnull(concat(' ', empleados.ape2em), ''),
                  ', ', 
                  empleados.nomem)
	from departamentos join dirigir
		on departamentos.numde = dirigir.numdepto
			join empleados 
				on empleados.numem = dirigir.numempdirec
	where departamentos.nomde =nombredepto
	    	and ifnull(dirigir.fecfindir,curdate()) >= curdate();
END $$
DELIMITER ;
/* ejercicio 10, pero solo el director actual (lo devolveremos a través del parametro que es de entrada y de salida: 
OJO ==> PARA SEGUNDO EXAMEN DE LA UNIDAD 5*/
DROP PROCEDURE IF EXISTS ejer_5_2_10;
DELIMITER $$
CREATE PROCEDURE ejer_5_2_10(inout nombredepto VARCHAR(60))
BEGIN
	select CONCAT(empleados.ape1em, 
				  ifnull(concat(' ', empleados.ape2em), ''),
                  ', ', 
                  empleados.nomem) into nombredepto
	from departamentos join dirigir
	on departamentos.numde = dirigir.numdepto
		join empleados 
			on empleados.numem = dirigir.numempdirec
where departamentos.nomde =nombredepto
	and ifnull(dirigir.fecfindir,curdate()) >= curdate();
END $$
DELIMITER ;

/* EJERCICIO 12*/
DROP PROCEDURE IF EXISTS ejer_5_2_12;
DELIMITER $$
CREATE PROCEDURE ejer_5_2_12(nombredepto VARCHAR(60))
BEGIN
	SELECT empleados.nomem
	FROM empleados join departamentos on empleados.numde
		= departamentos.numde
	WHERE departamentos.nomde = nombredepto
	-- ORDER BY departamentos.nomde desc,empleados.nomem desc;
	ORDER BY 1 desc;

END $$

DELIMITER ;

/* EJERCICIO 15*/
DROP PROCEDURE IF EXISTS ejer_5_2_15;
DELIMITER $$
CREATE PROCEDURE ejer_5_2_15
	(nomdepto varchar(60), fecini date, fecfin date)
BEGIN
	-- call ejer_5_2_15('Personal', '1995/1/1', '2005/12/31');
	SELECT empleados.nomem
	FROM empleados join dirigir on empleados.numem = dirigir.numempdirec
		join departamentos on dirigir.numdepto = departamentos.numde
	WHERE departamentos.nomde = nomdepto and 
		((dirigir.fecinidir >= fecini and dirigir.fecinidir <= fecfin)
			or dirigir.fecinidir <= fecini and 
				(fecfindir is null or fecfindir >= fecini)
		);
end $$
delimiter ;

