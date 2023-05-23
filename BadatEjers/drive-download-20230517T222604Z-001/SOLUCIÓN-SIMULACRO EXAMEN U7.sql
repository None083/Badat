/*
USANDO CURSORES PREPARA UN CATÁLOGO DE CASAS POR ZONAS E INDICANDO LAS CARACTERISTICAS DE CADA CASA

ZONA: ZONA1 (NOMBRE)

CASA: NOMBRE DE CASA 1 (M2, BAÑOS: X, HABIT: Y)
CARACTERÍSTICAS:
PISCINA, BARBACOA, .....

CASA: NOMBRE DE CASA 15 (M2, BAÑOS: X, HABIT: Y)
CARACTERÍSTICAS:
PISCINA CLIMATIZADA, BARBACOA, JARDÍN,L A/A.....


...
PRECIO MEDIO DE LA ZONA: PRECIO_MEDIO_DE_CASAS_DE_LA_ZONA

ZONA: ZONA2 (NOMBRE)

CASA: NOMBRE DE CASA 4 (M2, BAÑOS: X, HABIT: Y)
CARACTERÍSTICAS:
PISCINA, BARBACOA, .....

CASA: NOMBRE DE CASA 18 (M2, BAÑOS: X, HABIT: Y)
CARACTERÍSTICAS:
PISCINA CLIMATIZADA, BARBACOA, JARDÍN,L A/A.....

...
PRECIO MEDIO DE LA ZONA: PRECIO_MEDIO_DE_CASAS_DE_LA_ZONA




*/
USE GBDturRural2015;
/*
SELECT nomcasa, m2, numbanios, numhabit, preciobase, nomzona, nomcaracter
	-- (select avg(preciobase) from casas as c where casas.codzona = c.codzona) as mediazona --  no es eficiente ya que se calcula la media de la zona de cada casa
FROM casas join zonas on casas.codzona = zonas.numzona
	join caracteristicasdecasas on casas.codcasa = caracteristicasdecasas.codcasa
		join caracteristicas on caracteristicasdecasas.codcaracter = caracteristicas.numcaracter
ORDER BY nomzona, nomcasa;
*/
/*
FROM zonas join casas on zonas.codzona = casas.numzona
	join caracacteristicasdecasas on casas.codcasa = caracacteristicasdecasas.codcasa
		join caracteristicas on caracacteristicasdecasas.codcaracter = caracteristicas.numcaracter
*/

drop procedure if exists SIMULACRO_EXAMEN_U7;
DELIMITER $$
CREATE PROCEDURE SIMULACRO_EXAMEN_U7()
BEGIN

-- CALL SIMULACRO_EXAMEN_U7;

DECLARE nombrecasa, nomcasaaux varchar(100) default '';
DECLARE nombrezona, nomzonaaux varchar(100) default '';
DECLARE nombrecaracteristica varchar(100) default '';
DECLARE metros, baños, habitaciones int default 0;
DECLARE preciocasa, preciototalzona decimal(9,2) default 0;
DECLARE primeraZona, primeraCasa boolean default 1;
DECLARE numcasaszona int default 0;


DECLARE DesCaracteristicas varchar(4000) default '';


DECLARE final bit default 0;

DECLARE curCasas CURSOR
	FOR SELECT nomcasa, m2, numbanios, numhabit, preciobase, nomzona, nomcaracter
	-- (select avg(preciobase) from casas as c where casas.codzona = c.codzona) as mediazona /* no es eficiente ya que se calcula la media de la zona de cada casa*/
		FROM casas join zonas on casas.codzona = zonas.numzona
			join caracteristicasdecasas on casas.codcasa = caracteristicasdecasas.codcasa
				join caracteristicas on caracteristicasdecasas.codcaracter = caracteristicas.numcaracter
		ORDER BY nomzona, nomcasa;


DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET final = 1;

drop table if exists listado;
create temporary table listado
    (descripcion varchar(4000));

OPEN curCasas;
FETCH FROM curCasas INTO nombrecasa, metros, baños, habitaciones, preciocasa, nombrezona, nombrecaracteristica;
-- WHILE not final DO
WHILE final = 0 DO
BEGIN
	
    IF nomzonaaux <> nombrezona THEN
		begin
		
			set nomzonaaux = nombrezona;
			IF (primeraZona = 1) THEN
				set primeraZona = 0;
			ELSE
				BEGIN
					INSERT INTO listado 
						(descripcion) 
					VALUES
						(concat('PRECIO MEDIO DE LA ZONA: ', preciototalzona/numcasaszona));
					set numcasaszona = 0;
				END;
			END IF;
    
			INSERT INTO listado 
				(descripcion) 
			VALUES 
				(concat('ZONA: ', nombrezona));
			set primeraCasa = 1;
			
			set preciototalzona = 0;
		end;
	END IF;
    
    
    if nomcasaaux <> nombrecasa then
	begin
		IF (primeraCasa = 1) THEN
			set primeraCasa = 0;
		ELSE 
			begin
				-- guardarmos los datos del anterior grupo
				INSERT INTO listado 
					(descripcion) 
				VALUES
					('CARACTERÍSTICAS:'),
					(DesCaracteristicas);
				set DesCaracteristicas= '';
			end;
		END IF;
    
		INSERT INTO listado 
            (descripcion) 
        VALUES 
            (concat('CASA: ', nombrecasa,' (METROS:', metros, ', BAÑOS: ', baños, ', HABIT: ',habitaciones, ')'));
		set preciototalzona = preciototalzona + preciocasa;
        set numcasaszona = numcasaszona + 1;
        set nomcasaaux = nombrecasa;
    end;
    end if;
    set DesCaracteristicas = concat(DesCaracteristicas, ', ', nombrecaracteristica);

	FETCH FROM curCasas INTO nombrecasa, metros, baños, habitaciones, preciocasa, nombrezona, nombrecaracteristica;
END;
END WHILE;
CLOSE curCasas;

if (select count(*) from listado) > 0 then
BEGIN
	INSERT INTO listado 
		(descripcion) 
	VALUES
		('CARACTERÍSTICAS:'),
		(DesCaracteristicas),
        (concat('PRECIO MEDIO DE LA ZONA: ', preciototalzona/numcasaszona));
	
    select * from listado;
END;
else
    select 'NO EXISTEN CASAS';
end if;
drop table if exists listado;
END $$
DELIMITER ;
