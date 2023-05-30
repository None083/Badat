create table etiquetas(
	idetiqueta integer,
	nombre character varying(60),
	constraint pk_etiquetas primary key (idetiqueta)
);

drop table materiales if exists;
create table materiales(
	idetiqueta integer,
	descripcion character varying(50),
	constraint pk_materiales primary key (idmaterial)
)inherits(etiquetas);

drop table estilos if exists;
create table estilos(
	idetiqueta integer,
	descripcion character varying (50),
	constraint pk_estilos primary key (idestilo)
)inherits(etiquetas);

create rule regla_tipoetiqueta_material
as
	on insert to materiales
		where exists
			(select * from estilos
				where estilos.idetiqueta = new.idetiqueta)
	do instead nothing;
	
create rule regla_tipoetiqueta_estilo
as
	on update to estilos
		where exists
			(select * from materiales
			where materiales.idetiqueta = new.idetiqueta)
	do instead nothing;
	
	
	
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

select * from etiquetas; -- todos

select * from only etiquetas; -- solo el idEtiqueta 1

select * from materiales; -- del idEtiqueta 2 a 5


insert into estilos
	(idetiqueta, nombre, idestilo, descripcion)
values
	(6,'Realista', 10, 'Alta precisión en el detalle');

select * from etiquetas; -- todos

select * from only etiquetas; -- solo el idEstilo 1

select * from estilos; -- solo el idEstilo 6

insert into estilos
	(idetiqueta, nombre, idestilo, descripcion)
values
	(3,'Digital', 11,'Uso de herramientas tecnológicas');
	
select * from etiquetas; -- todos

select * from only etiquetas; -- solo el idEstilo 1

select * from estilos; -- solo el idEstilo 6
