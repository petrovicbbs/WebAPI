USE BTA
GO
-------------------------------------------------------
--▓▓▓ SetNewKeyStone @id INT▓▓▓
CREATE PROCEDURE SetNewKeyStone @id INT
AS
DECLARE @keystone varchar(100) = '';
DECLARE @num INT;
DECLARE @sign VARCHAR(1);
DECLARE @i INT = 0;
WHILE @i<=100
	BEGIN
		SET @num = ROUND(((255 - 40 - 1) * RAND() + 40),0)
		SET @sign = CAST(@num AS varbinary(1))
		SET @keystone = @keystone + @sign
		SET @i = @i+1
	END
	UPDATE Korisnik SET KeyStone = @keystone WHERE Korisnik.ID=@id
GO

--EXECUTE SetNewKeyStone 8
--EXECUTE SetNewKeyStone INT
--EXECUTE SetNewKeyStone id
--DROP PROCEDURE SetNewKeyStone

--▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓GetUser▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
CREATE PROCEDURE GetUser @id int
AS
IF EXISTS(SELECT * FROM Korisnik WHERE Id=@id)
	BEGIN
		SELECT Korisnik.ID,Email,Pass,Ime,Prezime,Adresa,Adresa2,Grad.Naziv AS Grad,Tel,Tel2,TipKorisnika.Naziv AS TipKorisnika,AutentifikacioniKod,CASE WHEN Autentifikovan = 0 THEN 'Ne' ELSE 'Da' END AS Autentifikovan,CASE WHEN Logovan = 0 THEN 'Ne' ELSE 'Da' END AS Logovan,ZadnjiLogIn,KeyStone FROM Korisnik 
		INNER JOIN Grad ON Grad.ID=GradId
		INNER JOIN TipKorisnika ON TipKorisnika.ID=TipKorisnikaId
		WHERE Korisnik.Id=@id
	END
	ELSE
	BEGIN
		RETURN 0;
	END
GO

--EXECUTE GetUser KorisnikId
--EXECUTE GetUser INT
--EXECUTE GetUser 1
--DROP PROCEDURE GetUser

-------------------------------------------------------
--▓▓▓ LogInChck @mail varchar(50),@pass varchar(50) ▓▓▓
CREATE PROCEDURE LogInChck @mail varchar(50),@pass varchar(50)
AS
IF EXISTS(SELECT * FROM Korisnik WHERE Email = @mail)
BEGIN
	DECLARE @id INT = (SELECT ID FROM Korisnik WHERE Email = @mail)
	IF EXISTS(SELECT * FROM Korisnik WHERE Email = @mail AND Pass = @pass)
	BEGIN
		DECLARE @numLog TINYINT = (SELECT Logovan FROM Korisnik WHERE ID = @id)
		--Autentifikaciju proveriti na back-u a front u slucaju 0 obavestiti korisnika
		UPDATE Korisnik SET Logovan = @numlog + 1 WHERE ID=@id
		UPDATE Korisnik SET ZadnjiLogIn = GETUTCDATE() WHERE ID=@id
		RETURN EXECUTE GetUser @id
	END
	ELSE
	BEGIN
		EXECUTE setNewKeyStone @id
	END
END
ELSE
BEGIN
	RETURN 0
END
GO

--EXECUTE LogInChck 'petrovicbbs@yahoo.com','12345678'
--EXECUTE LogInChck @mail varchar(50),@pass varchar(50)
--EXECUTE LogInChck mail,pass
--DROP PROCEDURE LogInChck
-------------------------------------------------------
--▓▓▓ LogOut @id INT ▓▓▓
CREATE PROCEDURE LogOut @id INT
AS
IF EXISTS(SELECT * FROM Korisnik WHERE Id=@id)
	BEGIN
		UPDATE Korisnik SET Logovan = 0 WHERE ID=@id
		EXECUTE setNewKeyStone @id
	END
	ELSE
	BEGIN
		RETURN 0;
	END
GO

--EXECUTE LogOut 1
--EXECUTE LogOut @id INT
--EXECUTE LogOut id
--DROP PROCEDURE LogOut



/*▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓ RELACIONI MODEL ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
TipKorisnika(ID,Naziv)													#####FINISHED#####
TipTransporta(ID,Naziv)													#####FINISHED#####
TipSmestaja(ID,Naziv)													#####FINISHED#####
TipKomentara(ID,Naziv)													#####FINISHED#####
Drzava(ID,Naziv,CID,Transport,Hrana,Sigurnost,LokalnaKultura,Aerodrom)	#####FINISHED#####	
StateOfCountry(ID,Naziv,CID,DrzavaId)								#####FINISHED#####
Grad(ID,Naziv,Opis,StateOfCountryId)								#####FINISHED#####
Korisnik(ID,Email,Pass,Ime,Prezime,Adresa,Adresa2,GradId,Tel,Tel2,TipKorisnikaId,Autentifikovan,Logovan,ZadnjiLogIn,KeyStone)
Smestaj(ID,Naziv,TipSmestajaId,Opis,Ocena,Email,Telefon,GradId)		#####FINISHED#####
Transport(ID,TipTransportaId,ProvajderId,Ocena,CityFrom,CityTo)		#####FINISHED#####
Provajder(ID,Naziv,TipTransportaId,Kontakt,Adresa,GradId,Telefon,Ocena)		#####FINISHED#####
Komentar(ID,TipKomentaraId,SmestajId,TransportId,ProvajderId,DrzavaId,Tekst,Ocena,KorisnikId,Datum)		#####FINISHED#####

▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓*/
/*▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓ NEW, UPD, DEL ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓*/
--###############################################################################################
--▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓  NewTipKorisnika  NVARCHAR(20)  ▓▓▓▓▓▓▓▓▓▓▓-----------------#####FINISHED#####
------------------▓    TipKorisnika(ID,Naziv)    ▓----------------------------
CREATE PROCEDURE NewTipKorisnika @naziv NVARCHAR(20)
AS
IF NOT EXISTS(SELECT * FROM TipKorisnika WHERE Naziv = @naziv)
	BEGIN
		INSERT INTO TipKorisnika VALUES (@naziv)
	END
	ELSE
	BEGIN
		RETURN 0
	END
GO

--EXECUTE NewTipKorisnika 'Naziv'
--EXECUTE NewTipKorisnika NVARCHAR(20)
--EXECUTE NewTipKorisnika @newTipKorisnika
--DROP PROCEDURE NewTipKorisnika

--▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓  UpdTipKorisnika  INT, NVARCHAR(20)  ▓▓▓▓▓▓▓▓▓▓▓ -----------------#####FINISHED#####
CREATE PROCEDURE UpdTipKorisnika @id INT, @naziv NVARCHAR(20)
AS
IF EXISTS(SELECT * FROM TipKorisnika WHERE ID=@id)
	BEGIN
		UPDATE TipKorisnika SET Naziv=@naziv WHERE ID=@id
	END
	ELSE
	BEGIN
		RETURN 0
	END
GO

--EXECUTE updTipKorisnika 1,N'Naziv'
--EXECUTE updTipKorisnika INT, NVARCHAR(20)
--EXECUTE updTipKorisnika @id, @naziv
--DROP PROCEDURE updTipKorisnika

--▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓  DelTipKorisnika  INT  ▓▓▓▓▓▓▓▓▓▓▓ ------------------------------#####FINISHED#####
CREATE PROCEDURE DelTipKorisnika @id INT
AS
IF EXISTS(SELECT * FROM TipKorisnika WHERE ID=@id)
	BEGIN
		DELETE TipKorisnika WHERE ID=@id
	END
	ELSE
	BEGIN
		RETURN 0
	END
GO

--EXECUTE DelTipKorisnika 1
--EXECUTE DelTipKorisnika INT
--EXECUTE DelTipKorisnika @id
--DROP PROCEDURE DelTipKorisnika
--###################################################################################################
--▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓  NewTipTransporta  NVARCHAR(20)  ▓▓▓▓▓▓▓▓▓▓▓-----------------#####FINISHED#####
------------------▓    TipTransporta(ID,Naziv)    ▓----------------------------
CREATE PROCEDURE NewTipTransporta @naziv NVARCHAR(20)
AS
IF NOT EXISTS(SELECT * FROM TipTransporta WHERE Naziv = @naziv)
	BEGIN
		INSERT INTO TipTransporta VALUES (@naziv)
	END
	ELSE
	BEGIN
		RETURN 0
	END
GO

--EXECUTE NewTipTransporta 'Naziv'
--EXECUTE NewTipTransporta NVARCHAR(20)
--EXECUTE NewTipTransporta @naziv
--DROP PROCEDURE NewTipTransporta

--▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓  UpdTipTransporta  INT, NVARCHAR(20)  ▓▓▓▓▓▓▓▓▓▓▓ -----------------#####FINISHED#####
CREATE PROCEDURE UpdTipTransporta @id INT, @naziv NVARCHAR(20)
AS
IF EXISTS(SELECT * FROM TipTransporta WHERE ID=@id)
	BEGIN
		UPDATE TipTransporta SET Naziv=@naziv WHERE ID=@id
	END
	ELSE
	BEGIN
		RETURN 0
	END
GO

--EXECUTE UpdTipTransporta 1,N'Naziv'
--EXECUTE UpdTipTransporta INT, NVARCHAR(20)
--EXECUTE UpdTipTransporta @id, @naziv
--DROP PROCEDURE UpdTipTransporta

--▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓  DelTipTransporta  INT  ▓▓▓▓▓▓▓▓▓▓▓ ------------------------------#####FINISHED#####
CREATE PROCEDURE DelTipTransporta @id INT
AS
IF EXISTS(SELECT * FROM TipTransporta WHERE ID=@id)
	BEGIN
		DELETE TipTransporta WHERE ID=@id
	END
	ELSE
	BEGIN
		RETURN 0
	END
GO

--EXECUTE delTipTransporta 1
--EXECUTE delTipTransporta INT
--EXECUTE delTipTransporta @id
--DROP PROCEDURE delTipTransporta
--###############################################################################################
--▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓  NewTipSmestaja  NVARCHAR(20)  ▓▓▓▓▓▓▓▓▓▓▓-----------------#####FINISHED#####
------------------▓    TipSmestaja(ID,Naziv)    ▓----------------------------
CREATE PROCEDURE NewTipSmestaja @naziv NVARCHAR(20)
AS
IF NOT EXISTS(SELECT * FROM TipSmestaja WHERE Naziv = @naziv)
	BEGIN
		INSERT INTO TipSmestaja VALUES (@naziv)
	END
	ELSE
	BEGIN
		RETURN 0
	END
GO

--EXECUTE newTipSmestaja 'Naziv'
--EXECUTE newTipSmestaja NVARCHAR(20)
--EXECUTE newTipSmestaja @naziv
--DROP PROCEDURE newTipSmestaja

--▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓  UpdTipSmestaja  INT, NVARCHAR(20)  ▓▓▓▓▓▓▓▓▓▓▓ -----------------#####FINISHED#####
CREATE PROCEDURE UpdTipSmestaja @id INT, @naziv NVARCHAR(20)
AS
IF EXISTS(SELECT * FROM TipSmestaja WHERE ID=@id)
	BEGIN
		UPDATE TipSmestaja SET Naziv=@naziv WHERE ID=@id
	END
	ELSE
	BEGIN
		RETURN 0
	END
GO

--EXECUTE updTipSmestaja 1,N'Naziv'
--EXECUTE updTipSmestaja INT, NVARCHAR(20)
--EXECUTE updTipSmestaja @id, @naziv
--DROP PROCEDURE updTipSmestaja

--▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓  DelTipSmestaja  INT  ▓▓▓▓▓▓▓▓▓▓▓ ------------------------------#####FINISHED#####
CREATE PROCEDURE DelTipSmestaja @id INT
AS
IF EXISTS(SELECT * FROM TipSmestaja WHERE ID=@id)
	BEGIN
		DELETE TipSmestaja WHERE ID=@id
	END
	ELSE
	BEGIN
		RETURN 0
	END
GO

--EXECUTE delTipSmestaja 1
--EXECUTE delTipSmestaja INT
--EXECUTE delTipSmestaja @id
--DROP PROCEDURE delTipSmestaja

--###############################################################################################
--▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓  NewTipKomentara  NVARCHAR(20)  ▓▓▓▓▓▓▓▓▓▓▓-----------------#####FINISHED#####
------------------▓    TipKomentara(ID,Naziv)    ▓----------------------------
CREATE PROCEDURE NewTipKomentara @naziv NVARCHAR(20)
AS
IF NOT EXISTS(SELECT * FROM TipKomentara WHERE Naziv = @naziv)
	BEGIN
		INSERT INTO TipKomentara VALUES (@naziv)
	END
	ELSE
	BEGIN
		RETURN 0
	END
GO

--EXECUTE newTipKomentara 'Naziv'
--EXECUTE newTipKomentara NVARCHAR(20)
--EXECUTE newTipKomentara @naziv
--DROP PROCEDURE newTipKomentara

--▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓  UpdTipKomentara  INT, NVARCHAR(20)  ▓▓▓▓▓▓▓▓▓▓▓ -----------------#####FINISHED#####
CREATE PROCEDURE UpdTipKomentara @id INT, @naziv NVARCHAR(20)
AS
IF EXISTS(SELECT * FROM TipKomentara WHERE ID=@id)
	BEGIN
		UPDATE TipKomentara SET Naziv=@naziv WHERE ID=@id
	END
	ELSE
	BEGIN
		RETURN 0
	END
GO

--EXECUTE updTipKomentara 1,N'Naziv'
--EXECUTE updTipKomentara INT, NVARCHAR(20)
--EXECUTE updTipKomentara @id, @naziv
--DROP PROCEDURE updTipKomentara

--▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓  DelTipKomentara  INT  ▓▓▓▓▓▓▓▓▓▓▓ ------------------------------#####FINISHED#####
CREATE PROCEDURE DelTipKomentara @id INT
AS
IF EXISTS(SELECT * FROM TipKomentara WHERE ID=@id)
	BEGIN
		DELETE TipKomentara WHERE ID=@id
	END
	ELSE
	BEGIN
		RETURN 0
	END
GO

--EXECUTE delTipKomentara 1
--EXECUTE delTipKomentara INT
--EXECUTE delTipKomentara @id
--DROP PROCEDURE delTipKomentara
--###############################################################################################
--▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓    Grad(ID,Naziv,Opis,StateOfCountryId)   ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓------------------
--▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓  NewGrad  NVARCHAR(50), INT, NVARCHAR(4000)  ▓▓▓▓▓▓▓▓▓▓▓-----------------#####FINISHED#####
CREATE PROCEDURE NewGrad @naziv NVARCHAR(50), @opis nvarchar(4000), @stateOfCountry INT
AS
IF NOT EXISTS(SELECT * FROM Grad WHERE Naziv = @naziv)
	BEGIN
		INSERT INTO Grad VALUES (@naziv, @opis, @stateOfCountry)
	END
	ELSE
	BEGIN
		RETURN 0
	END
GO

--EXECUTE newGrad 'Naziv',2,'Text'
--EXECUTE newGrad NVARCHAR(50), INT, NVARCHAR(4000)
--EXECUTE newGrad @naziv, @stateOfCountry, @opis
--DROP PROCEDURE newGrad

--▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓  UpdGrad  INT, NVARCHAR(50), INT, NVARCHAR(4000)  ▓▓▓▓▓▓▓▓▓▓▓ -----------------#####FINISHED#####
CREATE PROCEDURE UpdGrad @id INT, @naziv NVARCHAR(50), @stateOfCountry INT, @opis nvarchar(4000)
AS
IF EXISTS(SELECT * FROM Grad WHERE ID=@id)
	BEGIN
		UPDATE Grad SET Naziv=@naziv,StateOfCountryId=@stateOfCountry,Opis=@opis WHERE ID=@id
	END
	ELSE
	BEGIN
		RETURN 0
	END
GO

--EXECUTE updGrad 1,N'Naziv'
--EXECUTE updGrad INT, NVARCHAR(50)
--EXECUTE updGrad @id, @naziv
--DROP PROCEDURE updGrad

--▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓  DelGrad  INT  ▓▓▓▓▓▓▓▓▓▓▓ ------------------------------#####FINISHED#####
CREATE PROCEDURE DelGrad @id INT
AS
IF NOT EXISTS(SELECT * FROM Korisnik WHERE GradId=@id) AND NOT EXISTS(SELECT * FROM Smestaj WHERE GradId=@id) AND NOT EXISTS(SELECT * FROM Provajder WHERE GradId=@id)
	BEGIN
		DELETE Grad WHERE ID=@id
	END
	ELSE
	BEGIN
		RETURN 0
	END
GO

--EXECUTE delGrad 1
--EXECUTE delGrad INT
--EXECUTE delGrad @id
--DROP PROCEDURE delGrad
--###############################################################################################
--▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓  StateOfCountry(ID,Naziv,CID,DrzavaId)  ▓▓▓▓▓▓▓▓▓▓▓-----------------#####FINISHED#####
------------------▓    NewStateOfCountry  NVARCHAR(50), NVARCHAR(5), INT    ▓----------------------------
CREATE PROCEDURE NewStateOfCountry @naziv NVARCHAR(50), @cid NVARCHAR(5), @drzavaId INT
AS
IF NOT EXISTS(SELECT * FROM StateOfCountry WHERE Naziv = @naziv AND DrzavaId = @drzavaId)
	BEGIN
		INSERT INTO StateOfCountry(Naziv,DrzavaId) VALUES (@naziv,@drzavaId)
	END
	ELSE
	BEGIN
		RETURN 0
	END
GO

--EXECUTE newStateOfCountry 'Naziv','CID',1
--EXECUTE newStateOfCountry NVARCHAR(50),NVARCHAR(5),INT
--EXECUTE newStateOfCountry @naziv,@cid,@drzavaId
--DROP PROCEDURE newStateOfCountry

--▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓  UpdStateOfCountry  INT, NVARCHAR(50), INT  ▓▓▓▓▓▓▓▓▓▓▓ -----------------#####FINISHED#####
CREATE PROCEDURE UpdStateOfCountry @id INT, @naziv NVARCHAR(50), @cid NVARCHAR(5), @drzavaId INT
AS
IF EXISTS(SELECT * FROM StateOfCountry WHERE ID = @id)
	BEGIN
		UPDATE StateOfCountry SET Naziv=@naziv, DrzavaId=@drzavaId WHERE ID=@id
	END
	ELSE
	BEGIN
		RETURN 0
	END
GO

--EXECUTE updStateOfCountry 1, N'Naziv',N'CID',1
--EXECUTE updStateOfCountry INT, NVARCHAR(50), NVARCHAR(5),INT
--EXECUTE updStateOfCountry @id, @naziv, @cid, @drzavaId
--DROP PROCEDURE updStateOfCountry

--▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓  DelStateOfCountry  INT  ▓▓▓▓▓▓▓▓▓▓▓ ------------------------------#####FINISHED#####
CREATE PROCEDURE DelStateOfCountry @id INT
AS
IF EXISTS(SELECT * FROM Grad WHERE StateOfCountryId=@id)
	BEGIN
		DELETE StateOfCountry WHERE ID=@id
	END
	ELSE
	BEGIN
		RETURN 0
	END
GO

--EXECUTE delStateOfCountry 1
--EXECUTE delStateOfCountry INT
--EXECUTE delStateOfCountry @id
--DROP PROCEDURE delStateOfCountry

--###############################################################################################
--▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓  Drzava(ID,Naziv,CID,Transport,Hrana,Sigurnost,LokalnaKultura,Aerodrom)  ▓▓▓▓▓▓▓▓▓▓▓-----------------#####FINISHED#####
------▓    NewDrzava  NVARCHAR(50), NVARCHAR(5), nvarchar(500),nvarchar(500),nvarchar(500),nvarchar(500),nvarchar(500)    ▓----------------------------

CREATE PROCEDURE NewDrzava @naziv NVARCHAR(50), @cid NVARCHAR(5), @transport nvarchar(500), @hrana nvarchar(500), @sigurnost nvarchar(500), @culture nvarchar(500), @airport nvarchar(500)
AS
IF NOT EXISTS(SELECT * FROM Drzava WHERE Naziv = @naziv)
	BEGIN
		INSERT INTO Drzava(Naziv,CID,Transport,Hrana,Sigurnost,LokalnaKultura,Aerodrom) VALUES (@naziv, @cid, @transport, @hrana, @sigurnost, @culture, @airport)
	END
	ELSE
	BEGIN
		RETURN 0
	END
GO

--EXECUTE NewDrzava N'Naziv',N'CID',N'Transport',N'Hrana',N'Sigurnost',N'LokalnaKultura',N'Aerodrom'
--EXECUTE NewDrzava NVARCHAR(50),NVARCHAR(5),NVARCHAR(500),NVARCHAR(500),NVARCHAR(500),NVARCHAR(500),NVARCHAR(500)
--EXECUTE NewDrzava @naziv, @cid, @transport, @hrana, @sigurnost, @culture, @airport
--DROP PROCEDURE NewDrzava

------▓  UpdDrzava  NVARCHAR(50), NVARCHAR(5), nvarchar(500),nvarchar(500),nvarchar(500),nvarchar(500),nvarchar(500)  ▓▓▓▓▓▓▓▓▓▓▓ -----------------#####FINISHED#####
CREATE PROCEDURE UpdDrzava @id INT, @naziv NVARCHAR(50), @cid NVARCHAR(5), @transport nvarchar(500), @hrana nvarchar(500), @sigurnost nvarchar(500), @culture nvarchar(500), @airport nvarchar(500)
AS
IF EXISTS(SELECT * FROM Drzava WHERE ID = @id)
	BEGIN
		UPDATE Drzava SET Naziv=@naziv, CID=@cid,Transport=@transport,Hrana=@hrana,	Sigurnost=@sigurnost,LokalnaKultura=@culture,Aerodrom=@airport WHERE ID=@id
	END
	ELSE
	BEGIN
		RETURN 0
	END
GO

--EXECUTE UpdDrzava 1, N'Naziv',N'CID',N'Transport',N'Hrana',N'Sigurnost',N'LokalnaKultura',N'Aerodrom'
--EXECUTE UpdDrzava INT, NVARCHAR(50),NVARCHAR(5),NVARCHAR(500),NVARCHAR(500),NVARCHAR(500),NVARCHAR(500),NVARCHAR(500)
--EXECUTE UpdDrzava @id, @naziv, @cid, @transport, @hrana, @sigurnost, @culture, @airport
--DROP PROCEDURE UpdDrzava

------▓  DelDrzava  INT  ▓▓▓▓▓▓▓▓▓▓▓ ------------------------------#####FINISHED#####
CREATE PROCEDURE DelDrzava @id INT
AS
IF EXISTS(SELECT * FROM Drzava WHERE ID=@id)
	BEGIN
		DELETE Drzava WHERE ID=@id
	END
	ELSE
	BEGIN
		RETURN 0
	END
GO

--EXECUTE DelDrzava 1
--EXECUTE DelDrzava INT
--EXECUTE DelDrzava @id
--DROP PROCEDURE DelDrzava
--###############################################################################################
--▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓  Smestaj(ID,Naziv,TipSmestajaId,Opis,Ocena,Email,Telefon,GradId)  ▓▓▓▓▓▓▓▓▓▓▓-----------------#####FINISHED#####
------▓    NewSmestaj  NVARCHAR(50), INT, NVARCHAR(500),decimal(2,1),VARCHAR(40),VARCHAR(40),INT    ▓----------------------------
CREATE PROCEDURE NewSmestaj @naziv NVARCHAR(50), @tipSmestajaId INT, @opis nvarchar(500), @ocena decimal(2,1), @email varchar(40), @telefon varchar(40), @gradId INT
AS
IF NOT EXISTS(SELECT * FROM Smestaj WHERE Naziv = @naziv)
	BEGIN
INSERT INTO Smestaj(Naziv,TipSmestajaId,Opis,Ocena,Email,Telefon,GradId) VALUES (@naziv, @tipSmestajaId, @opis, @ocena, @email, @telefon, @gradId)
	END
	ELSE
	BEGIN
		RETURN 0
	END
GO

--EXECUTE NewSmestaj N'Naziv',1,N'Opis',N'Ocena',N'Email',N'Telefon',1
--EXECUTE NewSmestaj NVARCHAR(50), INT, NVARCHAR(500),decimal(2,1),VARCHAR(40),VARCHAR(40),INT
--EXECUTE NewSmestaj @naziv, @tipSmestajaId, @opis, @ocena, @email, @telefon, @gradId
--DROP PROCEDURE NewSmestaj

------▓    UpdSmestaj  INT,NVARCHAR(50), INT, NVARCHAR(500),decimal(2,1),VARCHAR(40),VARCHAR(40),INT    ▓----------#####FINISHED#####
CREATE PROCEDURE UpdSmestaj @id INT, @naziv NVARCHAR(50), @tipSmestajaId INT, @opis nvarchar(500), @ocena decimal(2,1), @email varchar(40), @telefon varchar(40), @gradId INT
AS
IF EXISTS(SELECT * FROM Smestaj WHERE ID = @id)
	BEGIN
		UPDATE Smestaj SET	Naziv=@naziv,TipSmestajaId=@tipSmestajaId,Opis=@opis,Ocena=@ocena,Email=@email,Telefon=@telefon,GradId=@gradId WHERE ID=@id
	END
	ELSE
	BEGIN
		RETURN 0
	END
GO

--EXECUTE UpdSmestaj 1, N'Naziv',1,N'Opis',N'Ocena',N'Email',N'Telefon',1
--EXECUTE UpdSmestaj INT,NVARCHAR(50), INT, NVARCHAR(500),decimal(2,1),VARCHAR(40),VARCHAR(40),INT
--EXECUTE UpdSmestaj @naziv,@tipSmestajaId,@opis,@ocena,@email,@telefon,@gradId
--DROP PROCEDURE UpdSmestaj

------▓  DelSmestaj  INT  ▓▓▓▓▓▓▓▓▓▓▓ ------------------------------#####FINISHED#####
CREATE PROCEDURE DelSmestaj @id INT
AS
IF EXISTS(SELECT * FROM Smestaj WHERE ID=@id)
	BEGIN
		DELETE Smestaj WHERE ID=@id
	END
	ELSE
	BEGIN
		RETURN 0
	END
GO

--EXECUTE DelSmestaj 1
--EXECUTE DelSmestaj INT
--EXECUTE DelSmestaj @id
--DROP PROCEDURE DelSmestaj
--###############################################################################################
--▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓  Transport(ID,TipTransportaId,ProvajderId,Ocena,CityFrom,CityTo)  ▓▓▓▓▓▓▓▓▓▓▓-----------------#####FINISHED#####
------▓    NewTransport INT, INT,decimal(2,1),INT,INT   ▓----------------------------
CREATE PROCEDURE NewTransport @tipTransportaId INT, @provajderId INT, @ocena decimal(2,1)=0, @cityFrom INT, @cityTo INT
AS
IF NOT EXISTS(SELECT * FROM Transport WHERE TipTransportaId = @tipTransportaId) AND NOT EXISTS(SELECT * FROM Transport WHERE CityFrom = @cityFrom) AND NOT EXISTS(SELECT * FROM Transport WHERE CityTo = @cityTo) AND NOT EXISTS(SELECT * FROM Transport WHERE ProvajderId = @provajderId)
	BEGIN
INSERT INTO Transport(TipTransportaId,ProvajderId,Ocena,CityFrom,CityTo) VALUES (@tipTransportaId, @provajderId, @ocena, @cityFrom, @cityTo)
	END
	ELSE
	BEGIN
		RETURN 0
	END
GO

--EXECUTE NewTransport 1,1,1.0,1,1
--EXECUTE NewTransport INT, INT, decimal(2,1),INT,INT
--EXECUTE NewTransport @tipTransportaId, @provajderId, @ocena, @cityFrom, @cityTo
--DROP PROCEDURE NewTransport

------▓    UpdTransport  INT,INT,INT,decimal(2,1),INT,INT    ▓----------#####FINISHED#####
CREATE PROCEDURE UpdTransport @id INT,@tipTransportaId INT, @provajderId INT, @ocena decimal(2,1)=0, @cityFrom INT, @cityTo INT
AS
IF EXISTS(SELECT * FROM Transport WHERE ID = @id)
	BEGIN
		UPDATE Transport SET TipTransportaId=@tipTransportaId,ProvajderId=@provajderId,Ocena=@ocena,CityFrom=@cityFrom,CityTo=@cityTo WHERE ID=@id
	END
	ELSE
	BEGIN
		RETURN 0
	END
GO

--EXECUTE UpdTransport 1,1,1,1.0,1,1
--EXECUTE UpdTransport INT,INT, INT, decimal(2,1),INT,INT
--EXECUTE UpdTransport @id,@tipTransportaId, @provajderId, @ocena, @cityFrom, @cityTo
--DROP PROCEDURE UpdTransport

------▓  DelTransport  INT  ▓▓▓▓▓▓▓▓▓▓▓ ------------------------------#####FINISHED#####
CREATE PROCEDURE DelTransport @id INT
AS
IF EXISTS(SELECT * FROM Transport WHERE ID=@id)
	BEGIN
		DELETE Transport WHERE ID=@id
	END
	ELSE
	BEGIN
		RETURN 0
	END
GO

--EXECUTE DelTransport 1
--EXECUTE DelTransport INT
--EXECUTE DelTransport @id
--DROP PROCEDURE DelTransport
--###############################################################################################
--▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓  Provajder(ID,Naziv,TipTransportaId,Kontakt,Adresa,GradId,Telefon,Ocena)  ▓▓▓▓▓▓▓▓▓▓▓-----------------#####FINISHED#####
------▓    NewProvajder nvarchar(50), INT,nvarchar(150),nvarchar(50),INT,varchar(50),decimal(2,1)   ▓----------------------------
CREATE PROCEDURE NewProvajder @naziv nvarchar(50), @tipTransportaId INT, @kontakt nvarchar(150), @adresa nvarchar(50), @gradId INT,@telefon varchar(50),@ocena decimal(2,1)
AS
IF NOT EXISTS(SELECT * FROM Provajder WHERE Naziv = @naziv)
	BEGIN   
		INSERT INTO Provajder(Naziv,TipTransportaId,Kontakt,Adresa,GradId,Telefon,Ocena) VALUES (@naziv, @tipTransportaId, @kontakt, @adresa, @gradId,@telefon,@Ocena)
	END
	ELSE
	BEGIN
		RETURN 0
	END
GO

--EXECUTE NewProvajder N'Naziv',1,N'Kontakt',N'Adresa',1,'Telefon',1.0
--EXECUTE NewProvajder nvarchar(50), INT,nvarchar(150),nvarchar(50),INT,varchar(50),decimal(2,1)
--EXECUTE NewProvajder @naziv, @tipTransportaId, @kontakt, @adresa, @gradId,@telefon,@Ocena
--DROP PROCEDURE NewProvajder

------▓    UpdProvajder  INT,nvarchar(50), INT,nvarchar(150),nvarchar(50),INT,varchar(50),decimal(2,1)    ▓----------#####FINISHED#####
CREATE PROCEDURE UpdProvajder @id INT,@naziv nvarchar(50), @tipTransportaId INT, @kontakt nvarchar(150), @adresa nvarchar(50), @gradId INT,@telefon varchar(50),@ocena decimal(2,1)
AS
IF EXISTS(SELECT * FROM Provajder WHERE ID = @id)
	BEGIN
		UPDATE Provajder SET Naziv=@naziv,TipTransportaId=@tipTransportaId,Kontakt=@kontakt,Adresa=@adresa,GradId=@gradId,Telefon=@telefon,Ocena=@ocena WHERE ID=@id
	END
	ELSE
	BEGIN
		RETURN 0
	END
GO

--EXECUTE UpdProvajder 1,N'Naziv',1,N'Kontakt',N'Adresa',1,'Telefon',1.0
--EXECUTE UpdProvajder nvarchar(50), INT,nvarchar(150),nvarchar(50),INT,varchar(50),decimal(2,1)
--EXECUTE UpdProvajder @naziv, @tipTransportaId, @kontakt, @adresa, @gradId,@telefon,@Ocena
--DROP PROCEDURE UpdProvajder

------▓  DelProvajder  INT  ▓▓▓▓▓▓▓▓▓▓▓ ------------------------------#####FINISHED#####
CREATE PROCEDURE DelProvajder @id INT
AS
IF EXISTS(SELECT * FROM Provajder WHERE ID=@id)
	BEGIN
		DELETE Provajder WHERE ID=@id
	END
	ELSE
	BEGIN
		RETURN 0
	END
GO

--EXECUTE DelProvajder 1
--EXECUTE DelProvajder INT
--EXECUTE DelProvajder @id
--DROP PROCEDURE DelProvajder
--###############################################################################################
--▓▓▓▓▓▓▓▓▓▓▓▓  Komentar(ID,TipKomentaraId,SmestajId,TransportId,ProvajderId,DrzavaId,Tekst,Ocena,KorisnikId,Datum)  ▓▓▓▓▓▓▓▓▓▓▓-----------------#####FINISHED#####
------▓    NewKomentar INT,INT,INT,INT,INT,nvarchar(500),decimal(2,1),INT,datetime   ▓----------------------------
CREATE PROCEDURE NewKomentar @tipKomentaraId INT, @smestajId INT, @transportId INT, @provajderId INT, @drzavaId INT, @tekst nvarchar(500), @ocena decimal(2,1), @korisnikId INT, @datum datetime 
AS
	BEGIN   
		INSERT INTO Komentar(TipKomentaraId,SmestajId,TransportId,ProvajderId,DrzavaId,Tekst,Ocena,KorisnikId,Datum) VALUES (@tipKomentaraId, @smestajId, @transportId, @provajderId, @drzavaId, @tekst, @ocena, @korisnikId, @datum)
	END
GO

--EXECUTE NewKomentar 1,1,1,1,1,N'',1.0,1,'20190501'
--EXECUTE NewKomentar INT,INT,INT,INT,INT,nvarchar(500),decimal(2,1),INT,datetime
--EXECUTE NewKomentar @tipKomentaraId, @smestajId, @transportId, @provajderId, @drzavaId, @tekst, @ocena, @korisnikId, @datum
--DROP PROCEDURE NewKomentar

------▓    UpdKomentar  INT,INT,INT,INT,INT,INT,nvarchar(500),decimal(2,1),INT,datetime    ▓----------#####FINISHED#####
CREATE PROCEDURE UpdKomentar @id INT,@tipKomentaraId INT, @smestajId INT, @transportId INT, @provajderId INT, @drzavaId INT, @tekst nvarchar(500), @ocena decimal(2,1), @korisnikId INT, @datum datetime 
AS
IF EXISTS(SELECT * FROM Komentar WHERE ID = @id)
	BEGIN
		UPDATE Komentar SET	TipKomentaraId=@tipKomentaraId,	SmestajId=@smestajId,TransportId=@transportId,ProvajderId=@provajderId,DrzavaId=@drzavaId,Tekst=@tekst,Ocena=@ocena,KorisnikId=@korisnikId,Datum=@datum WHERE ID=@id
	END
	ELSE
	BEGIN
		RETURN 0
	END
GO

--EXECUTE UpdKomentar 1,1,1,1,1,1,N'',1.0,1,'20190501'
--EXECUTE UpdKomentar INT,INT,INT,INT,INT,INT,nvarchar(500),decimal(2,1),INT,datetime
--EXECUTE UpdKomentar @id,@tipKomentaraId, @smestajId, @transportId, @provajderId, @drzavaId, @tekst, @ocena, @korisnikId, @datum 
--DROP PROCEDURE UpdKomentar

------▓  DelKomentar  INT  ▓▓▓▓▓▓▓▓▓▓▓ ------------------------------#####FINISHED#####
CREATE PROCEDURE DelKomentar @id INT
AS
IF EXISTS(SELECT * FROM Komentar WHERE ID=@id)
	BEGIN
		DELETE Komentar WHERE ID=@id
	END
	ELSE
	BEGIN
		RETURN 0
	END
GO

--EXECUTE DelKomentar 1
--EXECUTE DelKomentar INT
--EXECUTE DelKomentar @id
--DROP PROCEDURE DelKomentar
--###############################################################################################
--▓▓▓▓▓▓▓▓▓▓▓▓  Korisnik(ID,Email,Pass,Ime,Prezime,Adresa,Adresa2,GradId,Tel,Tel2,TipKorisnikaId,Autentifikovan,Logovan,ZadnjiLogIn,KeyStone)  ▓▓▓▓▓▓▓▓▓▓▓-----------------#####FINISHED#####
------▓    NewKorisnik varchar(50),varchar(30),nvarchar(30),nvarchar(30),nvarchar(50),nvarchar(50),INT,varchar(50),varchar(50),INT,INT,TINYINT,datetime,varchar(100) ▓----------------------------
CREATE PROCEDURE NewKorisnik @email varchar(50),@pass varchar(30),@ime nvarchar(30),@prezime nvarchar(30),@adresa nvarchar(50),@adresa2 nvarchar(50),@gradId INT,@tel varchar(50),@tel2 varchar(50),@tipKorisnikaId INT,@autentifikovan INT,@logovan TINYINT,@zadnjiLogIn datetime
AS
	BEGIN   
		INSERT INTO Korisnik(Email,Pass,Ime,Prezime,Adresa,Adresa2,GradId,Tel,Tel2,TipKorisnikaId,Autentifikovan,Logovan,ZadnjiLogIn) VALUES (@email,@pass,@ime,@prezime,@adresa,@adresa2,@gradId,@tel,@tel2,@tipKorisnikaId,@autentifikovan,@logovan,@zadnjiLogIn)
	END
GO

--EXECUTE NewKorisnik 'Email','Pass',N'Ime',N'Prezime',N'Adresa',N'Adresa2',1,'Tel','Tel2',1,1,0,'20190709'
--EXECUTE NewKorisnik varchar(50),varchar(30),nvarchar(30),nvarchar(30),nvarchar(50),nvarchar(50),INT,varchar(50),varchar(50),INT,INT,TINYINT,datetime
--EXECUTE NewKorisnik @email,@pass,@ime,@prezime,@adresa,@adresa2,@gradId,@tel,@tel2,@tipKorisnikaId,@autentifikovan,@logovan,@zadnjiLogIn
--DROP PROCEDURE NewKorisnik


--▓▓▓▓▓▓▓▓   UpdKorisnik  INT, varchar(50),varchar(30),nvarchar(30),nvarchar(30),nvarchar(50),nvarchar(50),INT,varchar(50),varchar(50),INT,INT,TINYINT,datetime    ▓----------#####FINISHED#####
----▓-▓-▓-▓-▓-▓-▓ PREDMET DVOUMLJENJA - DA LI TREBA PRI UPDATE-u SVI OVI PODACI!!!!!!!
CREATE PROCEDURE UpdKorisnik @id INT, @email varchar(50),@pass varchar(30),@ime nvarchar(30),@prezime nvarchar(30),@adresa nvarchar(50),@adresa2 nvarchar(50),@gradId INT,@tel varchar(50),@tel2 varchar(50),@tipKorisnikaId INT,@autentifikovan INT
AS
IF EXISTS(SELECT * FROM Komentar WHERE ID = @id)
	BEGIN
		UPDATE Korisnik SET	Email=@email,Pass=@pass ,Ime=@ime ,Prezime=@prezime,Adresa=@adresa,Adresa2=@adresa2,GradId=@gradId,Tel=@tel,Tel2=@tel2,TipKorisnikaId=@tipKorisnikaId,Autentifikovan=@autentifikovan WHERE ID=@id
	END
	ELSE
	BEGIN
		RETURN 0
	END
GO

----EXECUTE UpdKorisnik 'Email','Pass',N'Ime',N'Prezime',N'Adresa',N'Adresa2',1,'Tel','Tel2',1,1
----EXECUTE UpdKorisnik INT, varchar(50),varchar(30),nvarchar(30),nvarchar(30),nvarchar(50),nvarchar(50),INT,varchar(50),varchar(50),INT,INT
----EXECUTE UpdKorisnik @id,@email,@pass,@ime,@prezime,@adresa,@adresa2,@gradId,@tel,@tel2,@tipKorisnikaId,@autentifikovan
----DROP PROCEDURE UpdKorisnik

--▓▓▓▓▓▓▓▓   DelKorisnik  INT  ▓▓▓▓▓▓▓▓▓▓▓ ------------------------------#####FINISHED#####
----▓-▓-▓-▓-▓-▓-▓ PREDMET DVOUMLJENJA - GDE SE SVE MOZE POJAVITI KORISNIK!!!!!!!
CREATE PROCEDURE DelKorisnik @id INT
AS
IF NOT EXISTS(SELECT * FROM Komentar WHERE KorisnikId=@id)
	BEGIN
		DELETE Korisnik WHERE ID=@id
	END
	ELSE
	BEGIN
		RETURN 0
	END
GO

----EXECUTE DelKorisnik 1
----EXECUTE DelKorisnik INT
----EXECUTE DelKorisnik @id
----DROP PROCEDURE DelKorisnik




/*▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓*/

/*▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓*/

/*▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓     OVDE     ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓*/

/*▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓*/

/*▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓*/

--▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓ClearAllTriggers▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
CREATE PROCEDURE ClearAllTriggers
AS
	DROP TRIGGER chngTipKorisnika
	DROP TRIGGER chngTipTransporta
	DROP TRIGGER chngTipSmestaja
	DROP TRIGGER chngTipKomentara
	DROP TRIGGER chngDrzava
	DROP TRIGGER chngStateOfCountry
	DROP TRIGGER chngGrad
	DROP TRIGGER chngKorisnik
	DROP TRIGGER chngSmestaj
	DROP TRIGGER chngTransport
	DROP TRIGGER chngProvajder
	DROP TRIGGER chngKomentar
GO

--EXECUTE ClearAllTriggers
--DROP PROCEDURE ClearAllTriggers

------------------------------------------------------------------------------
--▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓chgHasBeenMade▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
CREATE PROCEDURE ChgHasBeenMade
AS
	BACKUP DATABASE BTA
	TO DISK = 'D:\BTA.bak'
	WITH DIFFERENTIAL;
GO

--EXECUTE chgHasBeenMade
--DROP PROCEDURE chgHasBeenMade


