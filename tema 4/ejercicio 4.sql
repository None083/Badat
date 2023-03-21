create database if not exists actividad4;
use actividad4;

create table if not exists artistas(
codArt int unsigned, -- int(4) el int son bytes, no es como en el decimal
nomArt varchar(60),
biografia text,
edad tinyint unsigned, -- int(1)
fecNacim date,
CONSTRAINT pk_artistas PRIMARY KEY (codArt)
);

create table if not exists tipObras(
codTipObra int unsigned, -- del 0 al 255?
desTipObra varchar(20),
CONSTRAINT pk_tipObras PRIMARY KEY (codTipObra)
);

create table if not exists estilos(

);

create table if not exists salas(

);

create table if not exists empleados(

);

create table if not exists seguridad(

);

create table if not exists restauradores(

);

create table if not exists seguridad(

);

