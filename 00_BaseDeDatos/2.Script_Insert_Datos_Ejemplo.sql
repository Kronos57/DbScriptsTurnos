USE [Turnos]
GO

INSERT INTO [dbo].[comercios]
           ([nom_comercio]
           ,[aforo_maximo])
     VALUES
		   ('TecnoCar', 10)
GO

INSERT INTO [dbo].[servicios]
           ([id_comercio]
           ,[nom_servicio]
           ,[hora_apertura]
           ,[hora_cierre]
           ,[duracion])
     VALUES
		   (1, 'Revisi�n T�cnico Mec�nica - RTM', '07:00:00', '18:00:00', 60),
		   (1, 'Alineaci�n y Balanceo', '10:00:00', '13:00:00', 30),
		   (1, 'Auto Lavado', '07:00:00', '15:00:00', 120)
GO
