use bdmuseo2021;

-- p1
select * from salas;

select obras.*
from obras join salas on obras.codsala=salas.codsala
where salas.codsala=1 or salas.codsala=3;

-- p2
select concat(obras.nombreobra, " (", artistas.nomartista, ")") as Obra, salas.codsala as Sala, obras.valoracion as Valoracion
from obras join artistas on obras.codartista=artistas.codartista
			join salas on obras.codsala=salas.codsala
order by obras.valoracion desc;

-- p3
select * from restauraciones;
select * from obras;
select * from restaurador;

drop procedure if exists simul3p3;
delimiter **
create procedure simul3p3(fecmin date, fecmax date)
begin
	select obras.nombreobra, restaurador.nomres
    from obras join restauraciones on obras.codobra=restauraciones.codobra
				join restaurador on restauraciones.codrestaurador=restaurador.codres
	where fecinirest between 'fecmin' and 'fecmax';
end **
call simul3p3('', '');

-- p4





