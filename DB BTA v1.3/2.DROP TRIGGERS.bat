@echo off
title Brisanje TRIGGER-a baze BTA v1.3
::****************************************************************
echo #############################################################
echo ########## Deinstalacija Trigger-a BTA v1.3 #################
echo #############################################################
set /p server="Unesite SQL Server name: "
echo #############################################################
:Brisanje
echo ##################Deinstalacija u toku#######################
call sqlcmd -S %server% -i DROP\DROPTRIGGERS.sql
goto commonexit

:commonexit
echo "############ BRISANJE TRIGGER-a ZAVRSENO! ##################
pause