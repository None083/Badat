use gbdturrural2015;

-- p1
select * from reservas;

select reservas.*
from reservas
where fecreserva between '2010-01-01' and '2012-03-30';

-- p3
drop procedure if exists simul2p3;
delimiter **
create procedure simul2p3(codCarac int)
begin
	select casas.codcasa, casas.nomcasa, casas.poblacion, casas.m2, tiposcasa.nomtipo
    from casas join tiposcasa on casas.codtipocasa=tiposcasa.numtipo 
				join caracteristicasdecasas on casas.codcasa=caracteristicasdecasas.codcasa
                join caracteristicas on caracteristicasdecasas.codcaracter=caracteristicas.numcaracter
    where numcaracter=codCarac
    order by casas.poblacion and casas.m2;
end **
call simul2p3(1);

-- p4
drop procedure if exists simul2p4;
delimiter **
create procedure simul2p4(codigoCasa int)
begin
	select nomcaracter
    from caracteristicas join caracteristicasdecasas on caracteristicas.numcaracter=caracteristicasdecasas.codcaracter
							join casas on caracteristicasdecasas.codcasa=casas.codcasa
    where casas.codcasa=codigoCasa;
end **
call simul2p4(1);

-- p6
drop procedure if exists simul2p6;
delimiter **
create procedure simul2p6(codReser int,
							out nombre varchar(200),
                            out contacto varchar(100))
begin
	select concat_ws(' ', nomcli, ape1cli, ape2cli), concat_ws('//', tlf_contacto, correoelectronico)
		into nombre, contacto
	from clientes join reservas on clientes.codcli=reservas.codcliente
    where reservas.codreserva=codReser;
end **
call simul2p6(1, @nombre, @contacto);
select @nombre, @contacto;





		