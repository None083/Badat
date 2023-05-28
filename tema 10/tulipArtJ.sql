create table etiquetas(
	idEtiqueta int,
	nombre varchar(60)
	constraint pk_etiquetas primary key(idEtiqueta)
);

create table materiales(
	idMaterial int,
	descripcion varchar (50),
	constraint pk_materiales primary key (idMaterial)
)inherits(etiquetas);

create table estilos(
	idEstilo int,
	descripcion varchar (50),
	constraint pk_estilos primary key (idestilo)
)inherits(etiquetas);

create rule regla_materiales
as
	on insert to materiales
		where exists
			(select * from etiquetas
			where estilos.idEtiqueta
			= new.idEtiqueta)
	do instead nothing;
	
create rule regla_materiales
as
	on update to materiales
		where exists
			(select * from etiquetas
			where estilos.idEtiqueta
			= new.idEtiqueta)
	do instead nothing;
	
	
	
-- INSERCION DATOS

insert into etiquetas
(idEtiqueta, nombre)
values
(1,'Pop art'); -- solo está en etiquetas

insert into materiales
	(idEtiqueta, nombre, idMaterial, descripción)
values
	(2,'Acuarela', 10, 'Base de agua, translúcido'),
	(3,'Lápices polychromos', 11, 'Mina cremosa, color saturado'),
	(4,'Pastel', 12,'Similar a tiza, no necesita disolvente'),
	(5,'Acrílico', 13,'Base de agua, secado muy rápido, acabado satinado');

select * from etiquetas; -- todos

select * from only etiquetas; -- solo el idEtiqueta 1

select * from materiales; -- del idEtiqueta 2 a 5


insert into estilos
	(idEstilo, nombre, idEstilo, descripción)
values
	(6,'Realista', 10, 'Alta precisión en el detalle');

select * from etiquetas; -- todos

select * from only etiquetas; -- solo el idEstilo 1

select * from estilos; -- solo el idEstilo 6

insert into estilos
	(idEstilo, nombre, idEstilo, descripción)
values
	(3,'Digital', 11,'Uso de herramientas tecnológicas');
	
select * from etiquetas; -- todos

select * from only etiquetas; -- solo el idEstilo 1

select * from estilos; -- solo el idEstilo 6

