create database if not exists actividad3;
use actividad3;

create table if not exists tCategorias(
numCat int not null,
nomCategor varchar(60),
proveedor varchar(60),
CONSTRAINT pk_tCategorias PRIMARY KEY (numCat)
);

create table if not exists tProductos(
refProd int not null,
descropc varchar(60),
precio decimal(6, 2),
codCat int not null,
constraint fk_tProductos_tCategorias foreign key(codCat) references tCategorias(numCat) on delete no action on update cascade,
CONSTRAINT pk_tProductos PRIMARY KEY (refProd, codCat)
);

create table if not exists tVentas(
codVenta int not null,
fecVenta date,
cliente varchar(60),
CONSTRAINT pk_tVentas primary key(codVenta)
);

create table if not exists tDetVentas(
cantidad int,
refProd int not null,
codCat int not null,
codVenta int not null,
constraint fk_tDetVentas_tProductos foreign key(refProd, codCat) references tProductos(refProd, codCat) on delete no action on update cascade,
constraint fk_tDetVentas_tVentas foreign key(codVenta) references tVentas(codVenta) on delete no action on update cascade,
CONSTRAINT pk_tProductos PRIMARY KEY (refProd, codCat, codVenta)
);