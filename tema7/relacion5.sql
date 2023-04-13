use bdalmacen;

-- 1
select * from productos;

drop procedure if exists ejer5_1;
delimiter **
create procedure ejer5_1(letra char(1))
begin
	select descripcion
	from productos
	where descripcion like concat(letra, '%');
end **
call ejer5_1('b');

-- 2
select * from proveedores;

drop function if exists ejer6_2;
delimiter **
create function ejer6_2(codProveedor int)
returns char(9)
deterministic
begin
	return (select reverse(telefono)
			from proveedores
            where proveedores.codproveedor=codProveedor);
end **
select ejer6_2(2);

