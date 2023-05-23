use bdalmacen;
/*
drop procedure if exists EJER_7_3_1;
DELIMITER $$
CREATE PROCEDURE EJER_7_3_1()
BEGIN
-- call EJER_7_3_1();

DECLARE	nomcat, nomcataux varchar(30);
DECLARE descat varchar(100);
DECLARE codprod int;
DECLARE desprod varchar(50);
DECLARE precio decimal(12,2);
DECLARE existencias char(2);

DECLARE final bit default 0;
	
DECLARE curCatalogo CURSOR 
	FOR select categorias.Nomcategoria, categorias.descripcion, 
            productos.codproducto, productos.descripcion, productos.preciounidad,
            case
                when stock > 0 then 'SI'
                when stock = 0 then 'NO'
            END 
        from categorias join productos on productos.codcategoria = categorias.codcategoria
        order by categorias.Nomcategoria, productos.descripcion;

DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET final = 1;

drop table if exists listado;
create temporary table listado
    (descripcion varchar(100));
OPEN curCatalogo;
FETCH FROM curCatalogo INTO nomcat,descat,codprod, desprod,precio, existencias;
SET nomcataux='';
WHILE final = 0 DO
BEGIN
	IF (nomcataux <> nomcat) THEN
	BEGIN
		INSERT INTO listado 
            -- (descripcion) 
        VALUES 
            (CONCAT('Productos de: ', nomcat, ' --- ', descat));
        INSERT INTO listado 
            -- (descripcion) 
        VALUES 
            (CONCAT('Ref. prod          Descripcion             Precio        Existencias'));
		SET nomcataux = nomcat;
	END;
    END IF;
    INSERT INTO listado 
            (descripcion) 
        VALUES 
            (CONCAT('  ',codprod, '            ', desprod, '            ', precio, '      ',
                existencias));
	FETCH FROM curCatalogo INTO nomcat,descat,codprod, desprod,precio, existencias;
END;
END WHILE;
CLOSE curCatalogo;

if (select count(*) from listado) > 0 then
    select * from listado;
else
    select 'No existen productos';
end if;
drop table if exists listado;

END $$
DELIMITER ;
*/
/*
drop procedure if exists EJER_7_3_2;
DELIMITER $$
CREATE PROCEDURE EJER_7_3_2()
BEGIN
-- call EJER_7_3_2();


DECLARE	cantped int;
DECLARE fechaped date;
DECLARE codprod int;
DECLARE desprod, desprodaux varchar(50);
DECLARE numpedidos int;

DECLARE final bit default 0;
	
DECLARE curPedidos CURSOR 
	FOR select productos.codproducto, productos.descripcion, productos.pedidos,
	            (SELECT sum(cantidad) from pedidos where codproducto = productos.codproducto)
            pedidos.fecpedido, pedidos.cantidad
        from productos  join pedidos on productos.codproducto = pedidos.codproducto
        where fecentrega is null or fecentrega >= curdate()
        order by productos.descripcion;

DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET final = 1;

drop table if exists listado;
create temporary table listado
    (descripcion varchar(100));
OPEN curPedidos;
FETCH FROM curPedidos INTO codprod, desprod,numpedidos, fechaped, cantped;
SET desprodaux='';
WHILE final = 0 DO
BEGIN
	IF (desprodaux <> desprod) THEN
	BEGIN
		INSERT INTO listado 
            -- (descripcion) 
        VALUES 
            (CONCAT('Producto: ', desprod, '(', codprod,')'));
        
		SET desprodaux = desprod;
	END;
    END IF;
    INSERT INTO listado 
            (descripcion) 
        VALUES 
            (CONCAT('  ',fechaped, '            ', cantped));
	FETCH FROM curPedidos INTO codprod, desprod,numpedidos, fechaped, cantped;
END;
END WHILE;
CLOSE curPedidos;

if (select count(*) from listado) > 0 then
    select * from listado;
else
    select 'No existen productos pedidos';
end if;
drop table if exists listado;

END $$
DELIMITER ;
*/
/*
drop procedure if exists EJER_7_3_3;
DELIMITER $$
CREATE PROCEDURE EJER_7_3_3
(
    in codprod int
)
BEGIN
-- call EJER_7_3_3(10);
-- call EJER_7_3_3(17);
-- call EJER_7_3_3(21);

DECLARE desprod, nombreprov, contactoprov varchar(50);
DECLARE tlfprov char(9);
DECLARE fechaped, fechaent varchar(30);
DECLARE cantped int;

DECLARE final bit default 0;
	
DECLARE curPedidos CURSOR 
	FOR select  date_format(fecpedido,'%d/%m/%Y'), ifnull(date_format(fecentrega,'%d/%m/%Y'),'SIN FECHA PREVISTA DE ENTREGA'), cantidad
        from pedidos
        where codproducto = codprod
        order by fecpedido;
DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET final = 1;

SELECT productos.descripcion, proveedores.nomempresa, proveedores.nomcontacto, proveedores.telefono
    INTO desprod, nombreprov, contactoprov, tlfprov 
FROM productos join categorias on categorias.codcategoria = productos.codcategoria
    join proveedores on proveedores.codproveedor = categorias.codproveedor
where productos.codproducto =codprod;

drop table if exists listado;
create temporary table listado
    (descripcion varchar(100));
-- escribimos los datos del producto y proveedor
INSERT INTO listado 
   -- (descripcion) 
VALUES 
   (CONCAT('Nombre del producto: ', desprod)),
   (CONCAT('Proveedor: ', nombreprov)),
   (CONCAT('Contacto: ', contactoprov)),
   (CONCAT('Teléfono: ', tlfprov)),
   ('Pedidos: '),
   ('   Fecha pedido               Unidades Pedidas           Fecha entrega');
OPEN curPedidos;
FETCH FROM curPedidos INTO fechaped,fechaent,cantped;
        
WHILE final = 0 DO
BEGIN
-- insertamos las fechas de pedidos 
    INSERT INTO listado 
           -- (descripcion) 
        VALUES 
            (CONCAT('  ',fechaped, '                    ', 
                    cantped, '                       ', case fechaent
                                                            when null then 'SIN FECHA PREVISTA DE ENTREGA'
                                                            else fechaent
                                                        end));
	FETCH FROM curPedidos INTO fechaped,fechaent,cantped;
END;
END WHILE;
CLOSE curPedidos;

if (select count(*) from listado) = 6 then
    insert into listado values ('No existen pedidos para este producto');
end if;
select * from listado;
drop table if exists listado;

END $$
DELIMITER ;
*/
/* ejercicio 4*/
/*
DROP PROCEDURE IF EXISTS EJER_7_3_4;
DELIMITER $$
CREATE PROCEDURE EJER_7_3_4
(
    in fecha date
)
BEGIN
-- CALL EJER_6_4_4(CURDATE());
-- CALL EJER_6_4_4('2012-12-31');
DECLARE codprod, unidades int;
DECLARE desprod VARCHAR(100);
DECLARE total, importe DECIMAL(12,2) DEFAULT 0;

DECLARE final BIT DEFAULT 0;
DECLARE curPedidos CURSOR
    FOR SELECT pedidos.codproducto, productos.descripcion, sum(pedidos.cantidad), sum(productos.preciounidad*pedidos.cantidad)
        FROM pedidos JOIN productos on productos.codproducto = pedidos.codproducto
        WHERE pedidos.fecpedido <= fecha
        GROUP BY pedidos.codproducto;
DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' BEGIN set final = 1; END;

DROP TEMPORARY TABLE IF EXISTS listado;
CREATE TEMPORARY TABLE listado (descripcion VARCHAR(200));

INSERT INTO listado VALUES (CONCAT('Pedidos hasta: ', date_format(fecha,'%d/%m/%Y')));
OPEN curPedidos;

FETCH FROM curPedidos INTO codprod, desprod, unidades, importe;

WHILE not final DO
BEGIN
    INSERT INTO listado VALUES
        (CONCAT('   ', codprod,' ==> ', desprod, ' ----- ', unidades, ' ----- ', importe,'€')); 
    set total = total + importe;
    FETCH FROM curPedidos INTO codprod, desprod, unidades, importe;
END;
END WHILE;
    IF (SELECT COUNT(*) FROM listado) > 1 THEN
        INSERT INTO listado VALUES
            ('---------------------------------------------------------'),
            (CONCAT('Precio Total de los pedidos: ', total, '€'));
    ELSE
        INSERT INTO listado VALUES
            ('---------------------------------------------------------'),
            ('NO EXISTEN PEDIDOS HASTA LA FECHA');

    END IF;
    CLOSE curPedidos;
    SELECT * FROM listado;
    DROP TABLE IF EXISTS listado;
    
END $$
DELIMITER ;
*/
/* ejercicio 5 */
/*
DROP PROCEDURE IF EXISTS PEDIDOSMASIVOS;
DELIMITER $$
CREATE PROCEDURE PEDIDOSMASIVOS()
BEGIN
-- CALL PEDIDOSMASIVOS();
-- SELECT * FROM pedidos WHERE fecpedido = CURDATE();
DECLARE numpedidos, codprod, stockprod int;
DECLARE desprod VARCHAR(50);
DECLARE maxpedido int;

DECLARE final BIT DEFAULT 0;

DECLARE curProd CURSOR FOR
	SELECT codproducto, descripcion, stock, pedidos
	FROM productos
	WHERE stock <= 5;

DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET final = 1;

DROP TABLE IF EXISTS listado;
CREATE TEMPORARY TABLE listado (descripcion VARCHAR(200));

OPEN curProd;	
FETCH FROM curProd INTO codprod, desprod, stockprod, numpedidos;

WHILE not final DO
BEGIN
    SELECT MAX(codpedido) + 1 INTO maxpedido FROM pedidos;
	INSERT pedidos
		(codpedido, codproducto, fecpedido, fecentrega, cantidad)
	VALUES
		(maxpedido,
		 codprod, CURDATE(), null, 5);
	UPDATE productos
	SET pedidos = pedidos + 5
	WHERE codproducto = codprod;
    
    INSERT INTO listado
    VALUES
        (CONCAT('SE HA REALIZADO UN PEDIDO DE 5 UNIDADES DEL PRODUCTO ', codprod,
                ' (', desprod, ')'));

	FETCH FROM curProd INTO codprod, desprod, stockprod, numpedidos;
END;
END WHILE;

CLOSE curProd;

if (select count(*) from listado) > 0 then
    select * from listado;
else
    select 'No ha sido necesario realizar ningún pedido automático';
end if;
drop table if exists listado;

END $$
DELIMITER ;
*/