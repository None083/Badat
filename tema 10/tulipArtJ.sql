-- Creo las tablas

create table etiquetas(
	idetiqueta integer,
	nombre character varying(60),
	constraint pk_etiquetas primary key (idetiqueta)
);

create table materiales(
	idmaterial integer,
	descripcion character varying(50),
	constraint pk_materiales primary key (idmaterial)
)inherits(etiquetas);

create table estilos(
	idestilo integer,
	descripcion character varying (50),
	constraint pk_estilos primary key (idestilo)
)inherits(etiquetas);


-- Reglas materiales

create rule regla_materiales_insert
as
	on insert to materiales
		where exists
			(select * from estilos
				where estilos.idetiqueta = new.idetiqueta)
	do instead nothing;

CREATE RULE regla_materiales_update
AS
	ON UPDATE TO materiales
		WHERE old.idEtiqueta != new.idEtiqueta AND EXISTS
			(SELECT * FROM estilos
			WHERE estilos.idEtiqueta
			= new.idEtiqueta)
	DO INSTEAD NOTHING;


-- Reglas estilos

CREATE RULE regla_estilos_insert
AS
	ON INSERT TO estilos
		WHERE EXISTS
			(SELECT * FROM materiales
			WHERE materiales.idEtiqueta
			= new.idEtiqueta)
	DO INSTEAD NOTHING;

create rule regla_estilos_update
as
	on update to estilos
		where exists
			(select * from materiales
			where materiales.idetiqueta = new.idetiqueta)
	do instead nothing;
	
	
-- Regla para no insertar etiquetas

CREATE RULE regla_insert_etiquetas
AS
	ON INSERT TO etiquetas
	DO INSTEAD NOTHING;
	
CREATE RULE regla_update_etiquetas
AS
	ON INSERT TO etiquetas
	DO INSTEAD NOTHING;


-- INSERCION DATOS

insert into etiquetas
(idetiqueta, nombre)
values
(1,'Pop art'); -- solo está en etiquetas

insert into materiales
	(idetiqueta, nombre, idmaterial, descripcion)
values
	(2,'Acuarela', 10, 'Base de agua, translúcido'),
	(3,'Lápices polychromos', 11, 'Mina cremosa, color saturado'),
	(4,'Pastel', 12,'Similar a tiza, no necesita disolvente'),
	(5,'Acrílico', 13,'Base de agua, secado muy rápido, acabado satinado');

select * from etiquetas; -- id 2 a 5

select * from only etiquetas; -- nada

select * from materiales; -- id 2 a 5


insert into estilos
	(idetiqueta, nombre, idestilo, descripcion)
values
	(6,'Realista', 10, 'Alta precisión en el detalle');

select * from etiquetas; -- id 2 a 6

select * from only etiquetas; -- nada

select * from estilos; -- id 6


insert into estilos
	(idetiqueta, nombre, idestilo, descripcion)
values
	(3,'Digital', 11,'Uso de herramientas tecnológicas');
	
select * from etiquetas; -- id 2 a 6

select * from only etiquetas; -- nada

select * from estilos; -- id 6
