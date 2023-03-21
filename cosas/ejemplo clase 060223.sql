/*
a- implemento todo, mantengo el contenido semantico (se puede siempre)
b- se implementa todo en los hijos (si es parcial no se puede)
c- solo implementamos al padre ()
-----para textos grandes se puede poner tipo text o varchar(8000)
ciudadanos(pk_codCiu,...)
departamentos(pk_codDepto, ...)
profesores(pk[codProf, codDepto*], codCiu*...)
asignaturas(pk_codAsig,...)
grupos(pk_codGrupo, ...)
alumnos(pk_codAlum, codGrupo*,  codCiu*...)
imparten(pk_[codProf,codDepto]*_codAsig*_codGrupo*, ...)
*/
create database if not exists ejemploClase060223;
use ejemploClase060223;

create table if not exists ciudadanos(
	codCiu int unsigned,
    nomCiu varchar(60),
    constraint pk_ciudadanos primary key (codCiu)
);

create table if not exists departamentos(
	codDepto int unsigned,
    nomDepto varchar(60),
    constraint pk_departamentos primary key (codDepto)
);

create table if not exists profesores(
	codProf int unsigned,
    codDepto int unsigned,
    codCiu int unsigned,
    constraint pk_profesores primary key (codProf, codDepto),
    constraint fk_profesores_departamentos foreign key (codDepto)
		references departamentos (codDepto) on delete no action on update cascade,
	constraint fk_profesores_ciudadanos foreign key (codCiu)
		references ciudadanos (codCiu) on delete no action on update cascade
);

create table if not exists asignaturas(
	codAsig int unsigned,
    nomAsig varchar(60),
    constraint pk_asignaturas primary key (codAsig)
);

create table if not exists grupos(
	codGrupo int unsigned,
    nomGrupo varchar(60),
    constraint pk_grupos primary key (codGrupo)
);

create table if not exists alumnos(
	codAlum int unsigned,
    codGrupo int unsigned,
    codCiu int unsigned,
    constraint pk_alumnos primary key (codAlum),
    constraint fk_alumnos_grupos foreign key (codGrupo)
		references grupos (codGrupo) on delete no action on update cascade,
	constraint fk_alumnos_ciudadanos foreign key (codCiu)
		references ciudadanos (codCiu) on delete no action on update cascade
);

create table if not exists imparten(
	codProf int unsigned,
    codDepto int unsigned,
    codAsig int unsigned,
    codDepto int unsigned,
    
);

-- añadir al tutor del grupo como relacion 1:1, 
-- tratamos como 1:n siendo el lado de la n el grupo

alter table grupos
    add column deptotutor int,
	add column proftutor int,
    add constraint fk_tutor foreign key (deptotutor, proftutor)
		references profesores (codProf) on delete no action on update cascade;