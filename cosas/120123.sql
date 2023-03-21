CREATE DATABASE IF NOT EXISTS BDCLASES;
USE BDCLASES;

CREATE TABLE IF NOT EXISTS deptos
(
	coddepto INT UNSIGNED NOT NULL, -- PRIMARY KEY,
    nomdepto VARCHAR(30),
    CONSTRAINT pk_deptos PRIMARY KEY (coddepto)
);

CREATE TABLE IF NOT EXISTS profesorado
(
	coddepto INT UNSIGNED NOT NULL, -- PRIMARY KEY,
    nomdepto VARCHAR(30) not null,
    codprof INT UNSIGNED NOT NULL, -- PRIMARY KEY,
    nomprof VARCHAR(30) not null,
    ape1prof VARCHAR(30) not null,
    ape2prof VARCHAR(30) null,
    fecincorporacion date null,
    codpostal CHAR(5) null,
    telefono CHAR(9) null, -- CHAR(13),
    
    CONSTRAINT pk_profesorado PRIMARY KEY (coddepto, codprof),
    CONSTRAINT pk_profesorado_deptos FOREIGN KEY (coddepto) REFERENCES deptos(coddepto)
    ON DELETE NO ACTION ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS asignaturas
(
	codasigna INT UNSIGNED NOT NULL, -- PRIMARY KEY,
    nomasigna VARCHAR(30) not null,
    curso VARCHAR(30) not null,
    CONSTRAINT pk_deptos PRIMARY KEY (codasigna)
);

CREATE TABLE IF NOT EXISTS impartir
(
	codasigna INT UNSIGNED NOT NULL, -- PRIMARY KEY,
    coddepto INT UNSIGNED NOT NULL, -- PRIMARY KEY,
    codprof INT UNSIGNED NOT NULL, -- PRIMARY KEY,
    observa VARCHAR(100) null,
    
);

CREATE TABLE IF NOT EXISTS jefes
(
	
);

show create table impartir;