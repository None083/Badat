create database if not exists actividad1;
use actividad1;

drop table if exists tcentro;
create table if not exists tcentro(
numcentro int not null,
nomcentro varchar(60),
direccion varchar(60),
 CONSTRAINT pk_tcentro PRIMARY KEY (numcentro)
);

drop table if exists tdepto;
create table if not exists tdepto(
numdepto int not null,
nomdepto varchar(60),
presupuesto decimal(8,2),
numcentro int,
 CONSTRAINT pk_tdepto PRIMARY KEY (numdepto, numcentro),
 constraint fk_tdepto_tcentro foreign key(numcentro) 
	references tcentro(numcentro) on delete no action on update cascade
);

drop table if exists templeado;
create table if not exists templeado(
numempleado int not null,
extelefon tinyint,
fecnacim date null,
fecingreso date not null,
salario decimal(7, 2),
comision decimal(4, 2),
numhijos tinyint unsigned,
nomempleado varchar(20) not null,
apellido1 varchar(20) not null,
apellido2 varchar(20) null,
numdepto int,
numcentro int,
 CONSTRAINT pk_templeado PRIMARY KEY (numempleado),
 constraint fk_templeado_tdepto foreign key(numdepto, numcentro) 
	references tdepto(numdepto, numcentro) on delete no action on update cascade
);

drop table if exists tdirigir;
create table if not exists tdirigir(
fecinidir date,
fecfindir date,
numempleado int not null,
numdepto int not null,
 constraint fk_tdirigir_templeado foreign key(numempleado) 
	references templeado(numempleado) on delete no action on update cascade,
 constraint fk_tdirigir_tdepto foreign key(numdepto) 
	references tdepto(numdepto) on delete no action on update cascade,
 constraint pk_tdirigir primary key(numempleado, numdepto)
);