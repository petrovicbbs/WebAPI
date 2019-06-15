use BTA
GO
-------chngTipTransporta--------
CREATE TRIGGER chngTipTransporta
ON TipTransporta
AFTER UPDATE,INSERT,DELETE
AS
BEGIN
    COMMIT TRANSACTION
		EXECUTE chgHasBeenMade
	BEGIN TRANSACTION
END
GO
--DROP TRIGGER chngTipTransporta

-------chngTipSmestaja--------
CREATE TRIGGER chngTipSmestaja
ON TipSmestaja
AFTER UPDATE,INSERT,DELETE
AS
BEGIN
    COMMIT TRANSACTION
		EXECUTE chgHasBeenMade
	BEGIN TRANSACTION
END
GO
--DROP TRIGGER chngTipSmestaja

-------chngTipKomentara--------
CREATE TRIGGER chngTipKomentara
ON TipKomentara
AFTER UPDATE,INSERT,DELETE
AS
BEGIN
    COMMIT TRANSACTION
		EXECUTE chgHasBeenMade
	BEGIN TRANSACTION
END
GO
--DROP TRIGGER chngTipKomentara

-------chngDrzava--------
CREATE TRIGGER chngDrzava
ON Drzava
AFTER UPDATE,INSERT,DELETE
AS
BEGIN
    COMMIT TRANSACTION
		EXECUTE chgHasBeenMade
	BEGIN TRANSACTION
END
GO
--DROP TRIGGER chngDrzava

-------chngStateOfCountry--------
CREATE TRIGGER chngStateOfCountry
ON StateOfCountry
AFTER UPDATE,INSERT,DELETE
AS
BEGIN
    COMMIT TRANSACTION
		EXECUTE chgHasBeenMade
	BEGIN TRANSACTION
END
GO
--DROP TRIGGER chngStateOfCountry

-------chngGrad--------
CREATE TRIGGER chngGrad
ON Grad
AFTER UPDATE,INSERT,DELETE
AS
BEGIN
    COMMIT TRANSACTION
		EXECUTE chgHasBeenMade
	BEGIN TRANSACTION
END
GO
--DROP TRIGGER chngGrad

-------chngKorisnik--------
CREATE TRIGGER chngKorisnik
ON Korisnik
AFTER UPDATE,INSERT,DELETE
AS
BEGIN
    COMMIT TRANSACTION
		EXECUTE chgHasBeenMade
	BEGIN TRANSACTION
END
GO
--DROP TRIGGER chngKorisnik

-------chngSmestaj--------
CREATE TRIGGER chngSmestaj
ON Smestaj
AFTER UPDATE,INSERT,DELETE
AS
BEGIN
    COMMIT TRANSACTION
		EXECUTE chgHasBeenMade
	BEGIN TRANSACTION
END
GO
--DROP TRIGGER chngSmestaj

-------chngTransport--------
CREATE TRIGGER chngTransport
ON Transport
AFTER UPDATE,INSERT,DELETE
AS
BEGIN
    COMMIT TRANSACTION
		EXECUTE chgHasBeenMade
	BEGIN TRANSACTION
END
GO
--DROP TRIGGER chngTransport

-------chngProvajder--------
CREATE TRIGGER chngProvajder
ON Provajder
AFTER UPDATE,INSERT,DELETE
AS
BEGIN
    COMMIT TRANSACTION
		EXECUTE chgHasBeenMade
	BEGIN TRANSACTION
END
GO
--DROP TRIGGER chngProvajder

-------chngKomentar--------
CREATE TRIGGER chngKomentar
ON Komentar
AFTER UPDATE,INSERT,DELETE
AS
BEGIN
    COMMIT TRANSACTION
		EXECUTE chgHasBeenMade
	BEGIN TRANSACTION
END
GO
--DROP TRIGGER chngKomentar