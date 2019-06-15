@echo off
title Instalacija baze BTA v1.3
::****************************************************************
echo #############################################################
echo ################ Instalacija BTA v1.3 #######################
echo #############################################################
set /p server="Unesite SQL Server: "
set /p protocols= "Sa protokolima?(Y/N) -"
::******************************************************
echo ######################################################
echo ############ Instalacija DB BTA pocinje ##############
echo ######################################################
::################################################################
::################################################################
::KREIRANJE DB-a
echo ######################################################
echo ......................CREATE..........................
echo ######################################################
echo Kreiranje baze........................................
call sqlcmd -S %server% -i CREATE\createDB.sql
echo Kreiranje tabela......................................
call sqlcmd -S %server% -i CREATE\createTable.sql
echo Insertovanje procedura................................
call sqlcmd -S %server% -i PROCEDURE\STORE.sql
echo ######################################################
echo ......................INSERT..........................
echo ######################################################
echo Insertovanje drzava...................................
call sqlcmd -S %server% -i INSERT\countries.sql
echo Insertovanje country-a................................
call sqlcmd -S %server% -i INSERT\StateOfCountry.sql
echo Insertovanje gradova..................................
call sqlcmd -S %server% -i INSERT\LiteCities.sql
echo Insertovanje tipova...................................
call sqlcmd -S %server% -i INSERT\ostalo.sql
goto ProtocolCheck
::################################################################
::################################################################
::PROTOKOL CHECK
:ProtocolCheck
IF /i "%protocols%"=="Y" goto withProtocols
goto commonexit
::---------------------------------------------------------
::INSERT PROTOKOLA
:withProtocols
echo ####################################################
echo ...................PROTOKOLI........................
echo ####################################################
echo Instalacija protokola...............................
call sqlcmd -S %server% -i PROTOKOLI\PROTOCOLS.sql
goto commonexit
::---------------------------------------------------------
:commonexit
echo ####################################################
echo ................Initialize BackUp...................
echo ####################################################
call sqlcmd -S %server% -i BACKUP\BACKUP.sql
echo Insertovanje trigera................................
call sqlcmd -S %server% -i TRIGERI\TRIGERS.sql
echo Insertovanje korisnika................................
call sqlcmd -S %server% -i INSERT\korisnici.sql
echo Insertovanje trigera za BackUp.......................
call sqlcmd -S %server% -i TRIGERI\TRIGERS-BCKUP.sql
echo ####################################################
echo -------------- INSTALACIJA GOTOVA!!! ---------------
echo ####################################################
pause