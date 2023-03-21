-- enum, para enumerar una serie de datos limitados, se asocia solo uno ( ej.colores del parchis)
-- set, conjunto de valores que defino, se pueden asociar varios (ej. idiomas de una persona)
-- unique, para que un valor no se repita

/*
1sujetos (PK(codsujeto), nomsujeto, ape1sujeto,ape2sujeto,dni,dirpostal,email,tlfcontacto)
clientela(PK(codcli), codsujeto*, estadocivil)
abogados(PK(codabogado), codsujeto*,numcolegiado)
tiposcasos(PK(cottipocaso),desTipoCaso)
casos(PK(codcaso,codtipocaso*),descaso,codcli*,presupuesto)
AbogadosenCasos(PK[[codcaso,codtipocaso]*,codabogado,fecinicio], numdias)

*/

create database if not exists BDSIMULBUFETE;
use BDSIMULBUFETE;

create table sujetos(
codSujeto int,
nomSujeto varchar(20),
ape1Sujeto varchar(20),
ape2Sujeto varchar(20),
dni char(9),
dirPostal char(5),
email varchar(60), -- unique
tlfContacto char(8),
constraint pk_sujetos primary key(codSujeto)
-- constraint email_unico unique (dirPostal, email) esto haria que no se repitiera la convinacion de los dos juntos
);

create table clientela(
codCliente int,
estadoCivil enum ('S', 'C', 'D', 'V'),

);