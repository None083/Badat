use ventapromoscompleta;

/* Cuando se incluye un producto en una promoción, queremos controlar 
que su precio promocionado en ningún caso pueda ser mayor o igual al 
precio de venta habitual (precio fuera de promoción).  Si sucediera esto 
habrá que evitar que se añada dicho producto a la promoción y se avisará 
de lo sucedido mediante mensaje.
TABLA⇒ catalogospromos
operación ⇒ insert
tipo ⇒ before */

drop trigger if exists ejerp1;
delimiter $$
create trigger ejerp1
	before insert on catalogospromos
    for each row
    begin
		if (select precioventa from articulos where refart = new.refart) <= new.precioartpromo then
        signal sqlstate '45000' set message_text = 'Precio más caro que el original';
        end if;
    end $$

/* También se nos ha pedido que controlemos lo anterior cuando se 
esté modificando el precio de un producto en una promoción. 
En este caso se permitirá la modificación pero se mantendrá 
el precio que tuviera previamente.
TABLA⇒ catalogospromos 
operación ⇒ update
tipo ⇒ before
*/

drop trigger if exists ejerp2;
delimiter $$
create trigger ejerp2
	before update on catalogospromos
    for each row
    begin
		if (select precioventa from articulos where refart = new.refart) <= new.precioartpromo then
        set new.precioartpromo = old.precioartpromo;
        end if;
    end $$







