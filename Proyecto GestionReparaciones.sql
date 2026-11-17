Create Database GestionReparaciones; -- Crear la base de datos
Go

Use GestionReparaciones; -- Seleccionar la base de datos
Go

Create Table Usuarios ( -- Crear tabla de usuarios
UsuarioID Int Identity(1,1)Primary Key, -- ID unico autogenerado del usuario
Nombre Nvarchar(100) Not Null, -- Nombre del usuario
CorreoElectronico Nvarchar(254) Not Null Unique, -- Correo unico y obligatorio
Telefono Varchar (20) -- Numero de telefono
);
Go

Create Table Tecnicos ( -- Crear tabla de tecnicos
TecnicoID Int Identity(1,1) Primary Key, -- ID unico autogenerado del tecnico
Nombre Nvarchar(100) Not Null, -- Nombre del tecnico
Especialidad Nvarchar(100)Not Null -- Especialidad del tecnico
);
Go

Create Table Equipos ( -- Crear tabla de equipos
EquipoID Int Identity(1,1) Primary Key, -- ID unico autogenerado del equipo
TipoEquipo Nvarchar(50) Not Null, -- Tipo de equipo
Modelo Nvarchar(100) Not Null, -- Modelo del equipo
UsuarioID Int Not Null, -- ID del usuario propietario

Constraint FK_Equipos_Usuarios -- Nombre de la relacion
Foreign Key (UsuarioID) -- Indicar la clave foranea
References Usuarios(UsuarioID) -- Relacionar con la tabla Usuarios
);
Go

Create Table Reparaciones ( -- Crear tabla de reparaciones
ReparacionID Int Identity(1,1) Primary Key, -- ID unico autogenerado de la reparacion
EquipoID Int Not Null, -- ID del equipo que necesita reparacion
FechaSolicitud DateTime2(0) Not Null -- Fecha y hora de solicitud
Default SysDateTime(), -- Asignar fecha y hora actual automaticamente
Estado Nvarchar(30) Not Null -- Estado actual de la reparacion
Default 'Pendiente', -- Estado inicial por defecto

Constraint FK_Reparaciones_Equipos -- Nombre de la relacion
Foreign Key (EquipoID) -- Indicar la clave foranea
References Equipos(EquipoID), -- Relacionar con la tabla Equipos

Constraint CK_Reparaciones_Estado -- Nombre de la restriccion
Check (Estado In ( -- Validar los estados permitidos
'Pendiente', -- Reparacion pendiente
'En proceso', -- Reparacion en proceso
'Completado', -- Reparacion finalizada
'Cancelada' -- Reparacion cancelada
))
);
Go

Create Table Asignaciones ( -- Crear tabla de asignaciones
AsignacionID Int Identity(1,1) Primary Key, -- ID unico autogenerado de la asignacion
ReparacionID Int Not Null, -- ID de la reparacion asignada
TecnicoID Int Not Null, -- ID del tecnico asignado
FechaAsignacion DateTime2(0) Not Null -- Fecha y hora de asignacion
Default SysDateTime(), -- Asignar fecha y hora actual automaticamente

Constraint FK_Asignaciones_Reparaciones -- Nombre de la relacion
Foreign Key (ReparacionID) -- Indicar la clave foranea
References Reparaciones(ReparacionID), -- Relacionar con Reparaciones

Constraint FK_Asignaciones_Tecnicos -- Nombre de la relacion
Foreign Key (TecnicoID) -- Indicar la clave foranea
References Tecnicos(TecnicoID) -- Relacionar con Tecnicos
);
Go

Create Table DetallesReparacion ( -- Crear tabla de detalles de reparacion
DetalleID Int Identity(1,1) Primary Key, -- ID unico autogenerado del detalle
ReparacionID Int Not Null, -- ID de la reparacion correspondiente
Descripcion Nvarchar(500) Not Null, -- Descripcion del trabajo realizado
FechaInicio DateTime2(0), -- Fecha y hora de inicio
FechaFin DateTime2(0), -- Fecha y hora de finalizacion

Constraint FK_Detalles_Reparaciones -- Nombre de la relacion
Foreign Key (ReparacionID) -- Indicar la clave foranea
References Reparaciones(ReparacionID), -- Relacionar con Reparaciones

Constraint CK_Detalles_Fechas -- Nombre de la restriccion
Check ( -- Validar las fechas
FechaFin Is Null -- Permitir fecha final vacia
Or FechaInicio Is Null -- Permitir fecha inicial vacia
Or FechaFin >= FechaInicio -- La fecha final debe ser mayor o igual a la inicial
)
);
Go

/*
Pregunta de análisis:

¿Por qué es más eficiente este modelo relacional que tener un único archivador electrónico con toda la información duplicada?

El modelo relacional es más eficiente porque permite organizar la información en diferentes tablas relacionadas entre sí, evitando
la redundancia de datos, que ocurre cuando se almacena la misma información varias veces.

Por ejemplo, en nuestro sistema de gestión de reparaciones, los usuarios, técnicos, equipos y reparaciones se encuentran separados
en diferentes tablas. Esto permite que los datos de un usuario se registren una sola vez y puedan relacionarse con varios equipos
sin tener que repetir toda su información.

En cambio, si utilizáramos un único archivador electrónico, tendríamos que repetir constantemente los nombres, correos, teléfonos y
otros datos, provocando duplicación de información y aumentando la posibilidad de cometer errores.

Por eso, el modelo relacional facilita la organización, actualización y consulta de los datos, reduce la redundancia
y permite mantener una mayor integridad de la información mediante las claves primarias y foráneas.
*/