alter table profesorado
add column especialidad
set('','','') -- campos
not null
default 'sin especificar';

update profesorado
set especialidad='back-end,administracion' -- sin espacios
where codprof=122;