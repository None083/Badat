CREATE DATABASE ArteBD;

USE ArteBD;

CREATE TABLE Usuario (
  id INT AUTO_INCREMENT,
  nombre VARCHAR(50) NOT NULL,
  email VARCHAR(100) NOT NULL,
  fecha_registro DATE,
  constraint pk_usuario primary key (id)
);

CREATE TABLE Obra (
  id INT AUTO_INCREMENT,
  titulo VARCHAR(100) NOT NULL,
  autor_id INT,
  descripcion VARCHAR(200),
  año_publicacion INT,
  categoria VARCHAR(50),
  constraint pk_obra primary key (id),
  constraint fk_obra_autor FOREIGN KEY (autor_id) REFERENCES Usuario(id)
);

CREATE TABLE Puntuacion (
  id INT AUTO_INCREMENT,
  obra_id INT,
  usuario_id INT,
  puntuacion INT,
  constraint pk_puntuacion primary key (id),
  constraint fk_puntuacion_obra FOREIGN KEY (obra_id) REFERENCES Obra(id),
  constraint fk_puntuacion_usuario FOREIGN KEY (usuario_id) REFERENCES Usuario(id)
);

-- INSERCION DE DATOS


