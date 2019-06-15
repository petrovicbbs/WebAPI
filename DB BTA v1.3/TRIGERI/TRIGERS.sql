USE BTA
GO
/*¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦ TRIGERI ¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦*/
CREATE TRIGGER newUser
ON Korisnik
AFTER INSERT
AS
DECLARE @id INT = (SELECT MAX(ID) FROM Korisnik)
DECLARE @autentificationCode varchar(20) = '';
DECLARE @num INT;
DECLARE @sign VARCHAR(1);
DECLARE @i INT = 0;
WHILE @i<=20
	BEGIN
		SET @num = ROUND(((123 - 48 - 1) * RAND() + 48),0)
		SET @sign = CAST(@num AS varbinary(1))
		SET @autentificationCode = @autentificationCode + @sign
		SET @i = @i+1
	END
	UPDATE Korisnik SET AutentifikacioniKod = @autentificationCode WHERE Korisnik.ID=@id
EXECUTE setNewKeyStone @id
GO

--DROP TRIGGER newUser
