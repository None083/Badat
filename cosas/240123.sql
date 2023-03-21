-- añadir campo codcat en tabla productos
-- añadir fk_codcat en productos de tabla categoria
-- drop fk en detVentas a tabla productos
-- drop fk_productos
-- add pk_productos
-- add columna codCat en tabla detVentas
-- add fk en detVentas a tabla productos

alter table productos
add column coscat int after refprod,
add constraint fk_prod_categorias foreign key(codcat),
references categorias(codcat),
