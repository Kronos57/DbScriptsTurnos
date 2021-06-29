
/*===================================================================================
* Author:		Ing. Manuel Antonio Rojas Barrero									*					 
* Create date:	23/06/2021 															*		
* Description:	Crea la base de datos Turnos										*
====================================================================================*/
CREATE DATABASE Turnos
GO

USE Turnos
GO

/*===================================================================================
* Author:		Ing. Manuel Antonio Rojas Barrero									*					 
* Create date:	23/06/2021 															*		
* Description:	Crea la tabla comercios.											*	
====================================================================================*/
CREATE TABLE comercios(
	id_comercio INT PRIMARY KEY IDENTITY(1,1) NOT NULL, -- Identificador consecutivo
	nom_comercio VARCHAR(100)			      NOT NULL, -- Nombre del Comercio
	aforo_maximo SMALLINT					  NOT NULL, -- Aforo máximo de personas permitido en el Comercio
)
GO

/*===================================================================================
* Author:		Ing. Manuel Antonio Rojas Barrero									*					 
* Create date:	23/06/2021 															*		
* Description:	Crea la tabla servicios.											*	
====================================================================================*/
CREATE TABLE servicios(
	id_servicio INT PRIMARY KEY IDENTITY(1,1) NOT NULL, -- Identificador consecutivo
	id_comercio INT							  NOT NULL, -- Fk - Identificador del Comercio
	nom_servicio VARCHAR(100)				  NOT NULL, -- Nombre del Servicio
	hora_apertura TIME(0)					  NOT NULL, -- Hora de apertura del Comercio
	hora_cierre TIME(0)						  NOT NULL, -- Hora de cierre del Comercio
	duracion SMALLINT						  NOT NULL, -- Duración del Servicio en minutos enteros		

	CONSTRAINT Fk_servicios_id_comercio FOREIGN KEY (id_comercio) REFERENCES comercios(id_comercio) 
)
GO

/*===================================================================================
* Author:		Ing. Manuel Antonio Rojas Barrero									*					 
* Create date:	23/06/2021 															*		
* Description:	Crea la tabla turnos.					 							*	
====================================================================================*/
CREATE TABLE turnos(
	id_turno INT PRIMARY KEY IDENTITY(1,1)	NOT NULL, -- Identificador consecutivo 
	id_servicio INT							NOT NULL, -- Fk - Identificador del Servicio
	fecha_turno DATE						NOT NULL, -- Hora de apertura del Comercio
	hora_inicio TIME(0)						NOT NULL, -- Hora de inicio del servicio
	hora_fin TIME(0)						NOT NULL, -- Hora fin del servicio
	estado BIT								NOT NULL, -- Estado del Turno: Asignado = 1 - Disponible = 0

	CONSTRAINT Fk_turnos_id_servicio FOREIGN KEY (id_servicio) REFERENCES servicios(id_servicio)
)
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Asignado = 1 - Disponible = 0' , @level0type=N'SCHEMA',@level0name=N'dbo', 
@level1type=N'TABLE',@level1name=N'turnos', @level2type=N'COLUMN',@level2name=N'estado'
GO