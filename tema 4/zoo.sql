/* 
zonas(pk[codZonas],...)
empleados(pk[codEmple],...)
cuidadores(pk[codCuidadores], codEmple*,...)
veterinarios(pk[codVete], codEmple*,...)
recintos(pk[codRecinto, codZona*],..., codCuidadores*)
ejemplares(pk[codEjem], codVete*, codPadre*, codMadre*,...)
está(pk[[codRecinto, codZona], codEjem]*...)
 */
 
 create database if not exists BDZOO;
 use BDZOO;
 
 create table if not exists zonas(
	codZona int unsigned,
    nomZona varchar(60),
    descZona varchar(60),
    constraint pk_zonas primary key (codZona)
 );
 
 create table if not exists empleados(
	codEmple int unsigned,
    nomEmple varchar(60),
    descEmple varchar(60),
    constraint pk_empleados primary key (codEmple)
 );
 
 create table if not exists cuidadores(
	codCuida int unsigned,
    codEmple int unsigned,
    constraint pk_cuidadores primary key (codCuida),
    constraint fk_cuidadores_empleados foreign key (codEmple)
		references empleados (codEmple) on delete no action on update cascade
 );
 
 create table if not exists veterinarios(
	codVete int unsigned,
    codEmple int unsigned,
    constraint pk_veterinarios primary key (codVete),
    constraint fk_veterinarios_empleados foreign key (codEmple)
		references empleados (codEmple) on delete no action on update cascade
 );
 
 create table if not exists recintos(
	codRecin int unsigned,
    nomRecin varchar(60),
    descRecin varchar(60),
    codZona int unsigned,
    codCuida int unsigned,
    constraint pk_recintos primary key (codRecin, codZona),
    constraint fk_recintos_zonas foreign key (codZona) 
		references zonas (codZona) on delete no action on update cascade,
	constraint fk_recintos_cuidadores foreign key (codCuida)
		references cuidadores (codCuida) on delete set null on update cascade
 );
 
 create table if not exists ejempleares(
	codEjem int unsigned,
    nomEjem varchar(60) unique,
    descEjem varchar(60),
    codPadre int unsigned,
    codMadre int unsigned,
    codVete int unsigned,
    clase enum ('peces','anfibios','reptiles', 'aves', 'mamiferos'),
    alimentacion enum ('herbívora', 'carnívora', 'insectívora', 'fructívora'),
    constraint pk_ejempleres primary key (codEjem),
    constraint fk_ejemplares_padre foreign key (codPadre)
		references ejemplares (codEjem) on delete no action on update cascade,
	constraint fk_ejemplares_madre foreign key (codMadre)
		references ejemplares (codEjem) on delete no action on update cascade,
	constraint fk_ejemplares_veterinario foreign key (conVete)
		references veterinarios (codVete) on delete no action on update cascade
 );
 
 create table if not exists esta(
	fecIniEstancia date,
    fecFinEstancia date,
    observaciones varchar(100),
    codRecin int unsigned,
    codZona int unsigned,
    codEjem int unsigned,
    constraint pk_esta primary key (fecIniEstancia, codRecin, codZona, codEjem),
    constraint fk_esta_recintos foreign key (codRecin, codZona)
		references recintos (codRecin, codZona) on delete no action on update cascade,
	constraint fk_esta_ejemplares foreign key (codEjem)
		references ejemplares (codEjem) on delete no action on update cascade
 );
 
 alter table empleados
	add column salario decimal(6,2) unsigned not null;
    
alter table ejemplares
	add column edad tinyint unsigned,
    add column fecNacim datetime;
 
 