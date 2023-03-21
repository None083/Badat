use gbdturrural2015;

-- P1 --
start transaction;
	insert into clientes
		(codcli, nomcli, ape1cli, ape2cli, dnicli, tlf_contacto)
	values
		(899, 'Juan', 'del Campo', 'Sánchez', '07000001W', '607000001');
	update reservas
		set codcli = 899
			where codreserva = 4356;
commit;

-- P2 --
delete from reservas
	where codcli=456 and fecreserva=curdate();

-- P3 --
update propietarios
set tlf_contacto='789000000',
	correoelectronico='dfg@gmail.com'
	where codpropietario=789;

-- P4 --
/* Si no hubiese casas con estas caracteristricas se podrían borrar sin problemas
y ademas la restriccion de integridad referencial de caracteristicas de casa con caracteristicas es "on delete cascade" o "on delete set null" */
delete from caracteristicas
	where numcaracter=230 or numcaracter=245;
/*  Si algina casa tuviera estas caracteristicas
y ademas la restriccion de integridad referencial de casa con caracteristicasde casa es "on delete no action" */
start transaction;
	delete from caracteristicasdecasa
		where numcaracter=230 or numcaracter=245;
	delete from caracteristicas
		where numcaracter=230 or numcaracter=245;
commit;

-- P5 --
update casas
set preciobase=preciobase+preciobase*0.1
	where numbanios=3 and m2=200;
