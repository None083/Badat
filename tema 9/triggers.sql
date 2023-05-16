-- ventas - comprobar si hay stock suficiente
--        - quiero modificar el stock
-- cuando queden - 5 unidades de stock quiero hacer pedido automático de 5 unidades
-- crear tablas detalleventas y ventas

delimiter $$
drop trigger if exists pedidoStock $$
create trigger pedidoStock
	before insert on detalleventas
-- after insert on detalleventas
for each row
begin
	
end $$
delimiter ;







-- cae examen: triggers, eventos, expresiones regulares(12.8.2), lenguaje procedimental