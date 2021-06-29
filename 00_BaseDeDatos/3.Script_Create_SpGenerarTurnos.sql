USE Turnos
GO

/*===================================================================================
* Author:		Ing. Manuel Antonio Rojas Barrero									*					 
* Create date:	24/06/2021 															*		
* Description:	Crea el spCrearTurno. 					 							*	
=====================================================================================
 History:                      
 Version  Date	     Author    Description 
====================================================================================*/
CREATE PROCEDURE [dbo].[spGenerarTurnos]
(
	@FechaInicio DATE,
	@FechaFin DATE,
	@IdServicio INT
)
AS
BEGIN
SET NOCOUNT ON;

		-- Variables para cálculos
		DECLARE @HoraApertura TIME
			   ,@HoraCierre TIME
			   ,@DuracionServicio SMALLINT

			   ,@HoraInicioTurno TIME
			   ,@HoraFinTurno TIME
			   ,@FechaCiclo DATE
			   ,@ExistenTurnos BIT

		-- LÓGICA PARA GENERACIÓN DE TURNOS
		-- 1. Consultar la hora de apertura, hora de cierre y duración del servicio
		SELECT @HoraApertura = [hora_apertura]
			  ,@HoraCierre = [hora_cierre]
			  ,@DuracionServicio = [duracion]
		FROM [dbo].[servicios]
		WHERE id_servicio = @IdServicio
		
		-- 2. Se valida si ya se generaron los turnos para el rango de fecha seleccionado
		IF (SELECT COUNT(*) FROM [dbo].[turnos]
					  WHERE fecha_turno BETWEEN @FechaInicio AND @FechaFin
					  AND id_servicio = @IdServicio) > 0
		BEGIN
			SET @ExistenTurnos = 1
		END
		ELSE
		BEGIN
			SET @ExistenTurnos = 0
		END

		-- 3. Si no existen se crean los turnos 
		IF(@ExistenTurnos = 0)
		BEGIN
			SET @FechaCiclo = @FechaInicio

			-- Ciclo para recorrer los días desde @FechaInicio hasta @FechaFin
			WHILE(@FechaCiclo <= @FechaFin) 
			BEGIN

				SET @HoraInicioTurno = @HoraApertura

				-- Ciclo para insertar cada turno generado
				WHILE( @HoraInicioTurno < @HoraCierre) 
				BEGIN  
					SET @HoraFinTurno = DATEADD(MINUTE, @DuracionServicio, @HoraInicioTurno)
				
					INSERT INTO [dbo].[turnos]
							([id_servicio]
							,[fecha_turno]
							,[hora_inicio]
							,[hora_fin]
							,[estado])
						VALUES
							(@IdServicio
							,@FechaCiclo
							,@HoraInicioTurno
							,@HoraFinTurno
							,0)  			 
				
					-- Se asigna la hora de inicio del siguiente turno 
					SET @HoraInicioTurno = @HoraFinTurno 		
				END

				-- Se incrementa el día en 1	 
				SET @FechaCiclo = DATEADD(DAY, 1, @FechaCiclo)  
			END
		END

		-- 4. Se consultan los turnos que se acaban de insertar para el rango de fechas seleccionado
		SELECT [id_turno]
			  ,[id_servicio]
		      ,[fecha_turno]
			  ,[hora_inicio]
			  ,[hora_fin]
			  ,CASE WHEN [estado] = 0 THEN 'Disponible' ELSE 'Asignado' END AS Estado
		FROM [dbo].[turnos]
		WHERE fecha_turno BETWEEN @FechaInicio AND @FechaFin
		AND id_servicio = @IdServicio
END
GO
