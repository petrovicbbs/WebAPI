@echo off
title Ubacivanje strukturnih trigera BTA v1.3
::****************************************************************
echo #############################################################
echo ###### Ubacivanje strukturnih trigera BTA v1.3 ##############
echo #############################################################
set /p server="Unesite SQL Server: "
::******************************************************
echo ######################################################
echo ############## Instalacija trigera ###################
echo ######################################################
::################################################################
echo ######################################################
echo Pocinje...............................................
call sqlcmd -S %server% -i TRIGERI\TRIGERS.sql
echo ####################################################
echo -------------- INSTALACIJA GOTOVA!!! ---------------
echo ####################################################
pause