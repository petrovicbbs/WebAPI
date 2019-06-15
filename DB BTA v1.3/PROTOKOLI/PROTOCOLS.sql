USE BTA
GO
/*▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓ PROTOCOLS ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓*/

--▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
--******************************************************************************************************************************************************************************
--#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓

--#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓# ClearAllProtocols #▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#
USE master
GO
CREATE PROCEDURE ClearAllProtocols
AS
DECLARE @clearMaintainceProtocol NVARCHAR(100)='USE msdb EXEC sp_delete_job  @job_name = N''MaintainceProtocol'';';
EXEC(@clearMaintainceProtocol)
DECLARE @clearSecurityProtocol NVARCHAR(100)='USE msdb EXEC sp_delete_job  @job_name = N''SecurityProtocol'';';
EXEC(@clearSecurityProtocol)
DECLARE @clearMaintainProcedure NVARCHAR(100)='USE master DROP PROCEDURE MaintainceProtocol;';
EXEC(@clearMaintainProcedure)
GO

--EXECUTE ClearAllProtocols
--DROP PROCEDURE ClearProtocols

--#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓
--#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓# SecurityProtocol #▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#

/*▓▓▓▓▓▓▓▓ SecurityCases ▓▓▓▓▓▓▓▓▓▓*/
USE BTA
GO
---------------------------------------------------------------------------------------
CREATE PROCEDURE LogedOff
AS
DECLARE @id INT;
/*▓ 1.CASE - LogedOff - ReShuffle▓*/
DECLARE Kursor CURSOR 
	LOCAL STATIC READ_ONLY FORWARD_ONLY 
	FOR 
/*SELECT SET*/
	SELECT ID FROM Korisnik
	WHERE Logovan=0

	OPEN Kursor
	FETCH NEXT FROM Kursor INTO @id

	WHILE @@FETCH_STATUS = 0
	BEGIN
		EXECUTE setNewKeyStone @id
	FETCH NEXT FROM Kursor INTO @id
	END
CLOSE Kursor
DEALLOCATE Kursor
GO
	--DROP PROCEDURE LogedOff
--#################################################
CREATE PROCEDURE DeviceCheck
AS
DECLARE @id INT;
/*▓ 2.CASE - LogedOnMultiDevices - LogOut ▓*/
DECLARE Kursor CURSOR 
	LOCAL STATIC READ_ONLY FORWARD_ONLY 
	FOR 
/*SELECT SET*/
	SELECT ID FROM Korisnik
	WHERE Logovan>1

	OPEN Kursor
	FETCH NEXT FROM Kursor INTO @id

	WHILE @@FETCH_STATUS = 0
	BEGIN
		EXECUTE logOut @id
	FETCH NEXT FROM Kursor INTO @id
	END
CLOSE Kursor
DEALLOCATE Kursor
GO
	--DROP PROCEDURE DeviceCheck
--#################################################
CREATE PROCEDURE DurationCheck
AS
DECLARE @id INT;
DECLARE @now datetime = GETUTCDATE();
DECLARE @minut decimal = (1/24/60);
DECLARE @loged datetime;
/*▓ 3.CASE - LogedOnMoreThan60min - LogOut ▓*/
DECLARE Kursor CURSOR 
	LOCAL STATIC READ_ONLY FORWARD_ONLY 
	FOR 
/*SELECT SET*/
	SELECT ID, ZadnjiLogIn FROM Korisnik
	WHERE Logovan=1

	OPEN Kursor
	FETCH NEXT FROM Kursor INTO @id

	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF(@loged+@minut*60>@now)
		BEGIN
			EXECUTE logOut @id
		END
	FETCH NEXT FROM Kursor INTO @id, @loged
	END
CLOSE Kursor
DEALLOCATE Kursor
GO
	--DROP PROCEDURE DurationCheck
--#################################################
----------------------------------------------------------------------------------------
CREATE PROCEDURE SecurityCheck
AS
EXECUTE LogedOff;
EXECUTE DeviceCheck;
EXECUTE DurationCheck;
GO
	--DROP PROCEDURE SecurityCheck
	--EXECUTE SecurityCheck 1
----------------------------------------------------------------------------------------
/*▓▓▓▓▓▓▓▓ SecurityProtocol Job ▓▓▓▓▓▓▓▓▓▓*/
USE msdb;  
GO  
DECLARE @user NVARCHAR(100) = (SELECT SYSTEM_USER);
DECLARE @jobname NVARCHAR(100) = N'SecurityProtocol';
DECLARE @db NVARCHAR(100) = N'BTA';
DECLARE @stepName NVARCHAR(100) = N'SecurityCheck';
DECLARE @stepCommand NVARCHAR(100) = N'EXECUTE SecurityCheck';

EXEC sp_add_job
		@job_name=@jobname,
		@enabled=1, 
		@description=N'No description available.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=@user; 
EXEC sp_add_jobserver
		@job_name=@jobname,
		@server_name=@@SERVERNAME;
EXEC sp_add_jobstep
		@job_name=@jobname, 
		@step_name=@stepName, 
		@step_id=1, 
		@on_success_action=1, 
		@retry_interval=1, 
		@subsystem=N'TSQL', 
		@command=@stepCommand, 
		@database_name=@db, 
		@flags=0;
EXEC sp_add_jobschedule 
		@job_name=@jobname, 
		@name=N'Minutno', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=4, 
		@freq_subday_interval=1, 
		@active_start_date=20190526, 
		@active_end_date=99991231, 
		@active_start_time=0, 
		@active_end_time=235959;
EXEC sp_start_job @jobname;
GO
---------------------------------------------------------------------------------------
USE BTA
GO
---------------------------------------------------------------------------------------

--Brisanje Protokola--
/*
USE msdb;
GO
EXEC sp_delete_job  @job_name = N'SecurityProtocol';  
GO
*/
--#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓
--#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓# MaintainceProtocol #▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓#▓

--▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

--▓▓▓▓▓▓▓▓▓▓▓▓▓	Maintain - Location: master
USE master
GO
CREATE PROCEDURE MaintainceProtocol 
AS
IF NOT EXISTS (SELECT * FROM sysdatabases WHERE NAME='BTA')
	BEGIN
		RESTORE DATABASE BTA
		FROM DISK = 'D:\BTA.bak'
	END
ELSE
	BEGIN
		BACKUP DATABASE BTA
		TO DISK = 'D:\BTA.bak'
		WITH DIFFERENTIAL; 
	END
GO
--USE master EXECUTE MaintainceProtocol
--USE master DROP PROCEDURE MaintainceProtocol

/*▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓ MaintainceProtocol Job ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓*/
USE msdb;  
GO  
DECLARE @user NVARCHAR(100) = (SELECT SYSTEM_USER);
DECLARE @jobname NVARCHAR(100) = N'MaintainceProtocol';
DECLARE @db NVARCHAR(100) = N'master';
DECLARE @stepName NVARCHAR(100) = N'MaintainceProtocol';
DECLARE @stepCommand NVARCHAR(100) = N'EXECUTE MaintainceProtocol';

EXEC sp_add_job
		@job_name=@jobname,
		@enabled=1, 
		@description=N'No description available.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=@user; 
EXEC sp_add_jobserver
		@job_name=@jobname,
		@server_name=@@SERVERNAME;
EXEC sp_add_jobstep
		@job_name=@jobname, 
		@step_name=@stepName, 
		@step_id=1, 
		@on_success_action=1, 
		@retry_interval=1, 
		@subsystem=N'TSQL', 
		@command=@stepCommand, 
		@database_name=@db, 
		@flags=0;
EXEC sp_add_jobschedule 
		@job_name=@jobname, 
		@name=N'Minutno', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=4, 
		@freq_subday_interval=1, 
		@active_start_date=20190526, 
		@active_end_date=99991231, 
		@active_start_time=0, 
		@active_end_time=235959;
EXEC sp_start_job @jobname;
GO
------------------------------------------------------------------
USE BTA
GO
------------------------------------------------------------------
--Brisanje Protokola--
/*
USE msdb;
GO
EXEC sp_delete_job  @job_name = N'MaintainceProtocol';  
GO
*/
-------------------------------------------------------------------
/**************************SIMULACIJA*****************************/
/*Rola - Nebojša*/

--USE master
--GO
--DROP DATABASE BTA
------------------------------
/*Rola - Agent*/

--EXECUTE MaintainceProtocol