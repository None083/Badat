use gbdturrural2015;

-- P1 --
insert into reservas
	(codreserva, codcliente, codcasa, fecreserva, feciniestancia, numdiasestancia, pagocuenta)
values
	(3501, 520, 315, curdate(), '2023-8-5', 7, 100);

-- P2 --
insert into caracteristicasdecasas
	(codcasa, codcaracter, tiene)
values
	(350, 17, 1),
	(350, 3, 1),
	(350, 5, 1);

-- P3 --
start transaction;
	update reservas
	set fecanulacion = curdate(),
		observaciones = 'Se ha cancelado la reserva cumpliendo el plazo, se ha realizado la devolución del pago a cuenta'
	where codreserva = 2450;

	insert into devoluciones
		(numdevol, codreserva, importedevol)
	values
		(226, 2450, 200);
commit;

-- P4 --
start transaction;
	delete from caracteristicasdecasas
	where codcasa=5640 or codcasa=5641;

	delete from casas
	where codcasa=5640 or codcasa=5641;

	delete from propietarios
	where codpropietario=520;
commit;
/* No se podrían borrar estos datos si existiese alguna reserva, ya que se perderían datos */

-- P5 --
update casas
set numhabit=3,
	m2=200,
	minpersonas=4,
	maxpersonas=8
where codcasa=5789;
