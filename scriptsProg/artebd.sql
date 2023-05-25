CREATE DATABASE ArteBD;

USE ArteBD;

CREATE TABLE Obra (
  id INT PRIMARY KEY AUTO_INCREMENT,
  titulo VARCHAR(100) NOT NULL,
  autor_id INT,
  descripcion VARCHAR(200),
  año_publicacion INT,
  categoria VARCHAR(50),
  FOREIGN KEY (autor_id) REFERENCES Usuario(id)
);

CREATE TABLE Puntuacion (
  id INT PRIMARY KEY AUTO_INCREMENT,
  obra_id INT,
  usuario_id INT,
  puntuacion INT,
  FOREIGN KEY (obra_id) REFERENCES Obra(id),
  FOREIGN KEY (usuario_id) REFERENCES Usuario(id)
);

CREATE TABLE Usuario (
  id INT PRIMARY KEY AUTO_INCREMENT,
  nombre VARCHAR(50) NOT NULL,
  email VARCHAR(100) NOT NULL,
  fecha_registro DATE
);