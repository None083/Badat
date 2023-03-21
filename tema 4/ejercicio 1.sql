create database if not exists actividad1;
use actividad1;

create table if not exists tcentro(
numcentro int not null,
nomcentro varchar(60),
direccion varchar(60),
 CONSTRAINT pk_tcentro PRIMARY KEY (numcentro)
);

create table if not exists tdepto(
numdepto int not null,
nomdepto varchar(60),
presupuesto decimal(8,2),
numcentro int,
dependepto int,
 CONSTRAINT pk_tdepto PRIMARY KEY (numdepto),
 constraint fk_tdepto_tcentro foreign key(numcentro) references tcentro(numcentro) on delete no action on update cascade,
 constraint fk_tdepto_tdepto foreign key(dependepto) references tdepto(numdepto) on delete no action on update cascade
);

create table if not exists templeado(
numempleado int not null,
extelefon tinyint,
fecnacim date,
fecingreso date,
salario decimal(6, 2),
comision decimal(4, 2),
numhijos tinyint,
nomempleado varchar(60),
numdepto int,
CONSTRAINT pk_templeado PRIMARY KEY (numempleado),
 constraint fk_templeado_tdepto foreign key(numdepto) references tdepto(numdepto) on delete no action on update cascade
);

create table if not exists tdirigir(
fecinidir date,
fecfindir date,
numempleado int not null,
numdepto int not null,
 constraint fk_tdirigir_templeado foreign key(numempleado) references templeado(numempleado) on delete no action on update cascade,
 constraint fk_tdirigir_tdepto foreign key(numdepto) references tdepto(numdepto) on delete no action on update cascade,
 constraint pk_tdirigir primary key(numempleado, numdepto)
);