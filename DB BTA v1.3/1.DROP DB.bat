@echo off
title Brisanje baze BTA v1.3
::****************************************************************
echo #############################################################
echo ################ Deinstalacija BTA v1.3 #####################
echo #############################################################
set /p server="Unesite SQL Server name: "
echo #############################################################
set /p odg="Da li ste sigurni da zelite obrisati BTA bazu?(Y/N) -"
echo #############################################################
IF /i "%odg%"=="Y" goto Brisanje
goto commonexit

:Brisanje
echo ##################Deinstalacija u toku#######################
call sqlcmd -S %server% -i DROP\DROPALL.sql
goto commonexit

:commonexit
echo "############################ BRISANJE ZAVRSENO! ############################"
pause