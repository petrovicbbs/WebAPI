USE BTA
GO
/*¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦ RELACIONI MODEL ¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
TipKorisnika(ID,Naziv)
TipTransporta(ID,Naziv)
TipSmestaja(ID,Naziv)
TipKomentara(ID,Naziv)
Drzava(ID,Naziv,CID,Transport,Hrana,Sigurnost,LokalnaKultura,Aerodrom)
StateOfCountry(ID,Naziv,CID,DrzavaId)
Grad(ID,Naziv,Opis,StateOfCountryId)
Korisnik(ID,Email,Pass,Ime,Prezime,Adresa,Adresa2,GradId,Tel,Tel2,TipKorisnikaId,Autentifikovan,Logovan,ZadnjiLogIn,KeyStone)
Smestaj(ID,Naziv,TipSmestajaId,Opis,Ocena,Email,Telefon,GradId)
Transport(ID,TipTransportaId,ProvajderId,Ocena,CityFrom,CityTo)
Provajder(ID,Naziv,TipTransportaId,Kontakt,Adresa,GradId,Telefon,Ocena)
Komentar(ID,TipKomentaraId,SmestajId,TransportId,ProvajderId,DrzavaId,Tekst,Ocena,KorisnikId,Datum)

¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦*/
/* ////////////////TipKorisnika//////////////////////////// */
CREATE TABLE TipKorisnika(
ID INT IDENTITY(1,1) NOT NULL,
Naziv nvarchar(20) NOT NULL,
CONSTRAINT PK_TipKorisnikaID PRIMARY KEY (ID))
GO									--/ PK: TipKorisnikaID				--/ CREATE: TipKorisnika
/* ////////////////TipTransporta//////////////////////////// */
CREATE TABLE TipTransporta(
ID INT IDENTITY(1,1) NOT NULL,
Naziv nvarchar(20) NOT NULL,
CONSTRAINT PK_TipTransportaID PRIMARY KEY (ID))
GO									--/ PK: TipTransportaID				--/ CREATE: TipTransporta
/* ////////////////TipSmestaja//////////////////////////// */
CREATE TABLE TipSmestaja(
ID INT IDENTITY(1,1) NOT NULL,
Naziv nvarchar(20) NOT NULL,
CONSTRAINT PK_TipSmestajaID PRIMARY KEY (ID))
GO									--/ PK: TipSmestajaID				--/ CREATE: TipSmestaja
/* ////////////////TipKomentara//////////////////////////// */
CREATE TABLE TipKomentara(
ID INT IDENTITY(1,1) NOT NULL,
Naziv nvarchar(20) NOT NULL,
CONSTRAINT PK_TipKomentaraID PRIMARY KEY (ID))		
GO									--/ PK: TipKomentaraID				--/ CREATE: TipKomentara
/* ////////////////Drzava//////////////////////////// */
CREATE TABLE Drzava(
ID INT IDENTITY(1,1) NOT NULL,
Naziv nvarchar(50) NOT NULL,
CID nvarchar(5) NOT NULL,
Transport nvarchar(4000) NOT NULL,
Hrana nvarchar(1000) NOT NULL,
Sigurnost nvarchar(1000) NOT NULL,
LokalnaKultura nvarchar(1500) NOT NULL,
Aerodrom nvarchar(1000) NOT NULL,
CONSTRAINT PK_Drzava PRIMARY KEY (ID))
GO									--/ PK: DrzavaID					--/ CREATE: Drzava
/* ////////////////StateOfCountry//////////////////////////// */
CREATE TABLE StateOfCountry(
ID INT IDENTITY(1,1) NOT NULL,
Naziv nvarchar(50) NOT NULL,
DrzavaId INT NOT NULL,
CONSTRAINT PK_StateOfCountryID PRIMARY KEY (ID),
CONSTRAINT FK_DrzavaId FOREIGN KEY (DrzavaId) REFERENCES  Drzava(ID))
GO									--/ PK: StateOfCountryID			--/ CREATE: StateOfCountry
/**************************ForeignKeys********************************/   -- 'FK:¦' - new added, 'FK: ' - existing, '(FK)' - aktuelan u toj tabeli
/* (FK):¦DrzavaId */
/*********************************************************************/
/* ////////////////Grad//////////////////////////// */
CREATE TABLE Grad(
ID INT IDENTITY(1,1) NOT NULL,
Naziv nvarchar(200) NOT NULL,
Opis nvarchar(4000) NOT NULL,
StateOfCountryId INT NULL,
CONSTRAINT PK_GradId PRIMARY KEY (ID),				
CONSTRAINT FK_StateOfCountryId FOREIGN KEY (StateOfCountryId) REFERENCES  StateOfCountry(ID))
GO									--/ PK: GradId						--/ CREATE: Grad
/**************************ForeignKeys********************************/   -- 'FK:¦' - new added, 'FK: ' - existing, '(FK)' - aktuelan u toj tabeli
-- (FK):¦StateOfCountryId
/*********************************************************************/
/* ////////////////Korisnik//////////////////////////// */
CREATE TABLE Korisnik(
ID INT IDENTITY(1,1),
Email varchar(50) NOT NULL,
Pass varchar(30) MASKED WITH (FUNCTION = 'default()') NOT NULL,
Ime nvarchar(30) NOT NULL,
Prezime nvarchar(30) NOT NULL,
Adresa nvarchar(50) NOT NULL,
Adresa2 nvarchar(50),
GradId INT NOT NULL,
Tel varchar(50) NOT NULL,
Tel2 varchar(50),
TipKorisnikaId INT DEFAULT 2 NOT NULL,
AutentifikacioniKod varchar(100) NULL,
Autentifikovan INT DEFAULT 0 NOT NULL,
Logovan tinyint NULL DEFAULT 0,
ZadnjiLogIn datetime DEFAULT '' NULL,
KeyStone varchar(100) NULL,
CONSTRAINT PK_KorisnikID PRIMARY KEY (ID),			
CONSTRAINT FK_GradId FOREIGN KEY (GradId) REFERENCES Grad(ID),
CONSTRAINT FK_TipKorisnikaId FOREIGN KEY (TipKorisnikaId) REFERENCES TipKorisnika(ID))
GO									--/ PK: KorisnikID					--/ CREATE: Korisnik
/**************************ForeignKeys********************************/   -- 'FK:¦' - new added, 'FK: ' - existing, '(FK)' - aktuelan u toj tabeli
-- FK: DrzavaId */
-- FK: StateOfCountryId
-- (FK):¦GradId
-- (FK):¦TipKorisnikaId
/*********************************************************************/
/* ////////////////Smestaj//////////////////////////// */
CREATE TABLE Smestaj(
ID INT IDENTITY(1,1) NOT NULL,
Naziv nvarchar(50) NOT NULL,
TipSmestajaId INT NOT NULL,
Opis nvarchar(500) NOT NULL,
Ocena decimal(2,1) NOT NULL,
Email varchar(40) NOT NULL,
Telefon varchar(40) NOT NULL,
GradId INT NOT NULL,
CONSTRAINT PK_SmestajID PRIMARY KEY (ID),
CONSTRAINT FK_TipSmestajaId FOREIGN KEY (TipSmestajaId) REFERENCES  TipSmestaja(ID),
FOREIGN KEY (GradId) REFERENCES  Grad(ID))
GO									--/ PK: StateOfCountryID			--/ CREATE: Smestaj
/**************************ForeignKeys********************************/   -- 'FK:¦' - new added, 'FK: ' - existing, '(FK)' - aktuelan u toj tabeli
-- FK: DrzavaId */
-- FK: StateOfCountryId
-- (FK): GradId
-- FK: TipKorisnikaId
-- (FK):¦TipSmestajaId
/*********************************************************************/
/* ////////////////Provajder//////////////////////////// */
CREATE TABLE Provajder(
ID INT IDENTITY(1,1) NOT NULL,
Naziv nvarchar(50) NOT NULL,
TipTransportaId INT NOT NULL,
Kontakt nvarchar(150) NOT NULL,
Adresa nvarchar(50) NOT NULL,
GradId INT NOT NULL,
Telefon varchar(50) NOT NULL,
Ocena decimal(2,1) NOT NULL,
CONSTRAINT PK_ProvajderID PRIMARY KEY (ID),
CONSTRAINT FK_TipTransportaId FOREIGN KEY (TipTransportaId) REFERENCES  TipTransporta(ID),
FOREIGN KEY (GradId) REFERENCES  Grad(ID))
GO									--/ PK: ProvajderID					--/ CREATE: Provajder
/**************************ForeignKeys********************************/   -- 'FK:¦' - new added, 'FK: ' - existing, '(FK)' - aktuelan u toj tabeli
-- FK: DrzavaId
-- FK: StateOfCountryId
-- FK: TipKorisnikaId
-- FK: TipSmestajaId
-- (FK):¦TipTransportaId
-- (FK): GradIdId
/*********************************************************************/
/* ////////////////Transport//////////////////////////// */
CREATE TABLE Transport(
ID INT IDENTITY(1,1) NOT NULL,
TipTransportaId INT NOT NULL,
ProvajderId INT NOT NULL,
Ocena decimal(2,1) NOT NULL,
CityFrom INT NOT NULL,
CityTo INT NOT NULL,
CONSTRAINT PK_TransportID PRIMARY KEY (ID),
FOREIGN KEY (TipTransportaId) REFERENCES  TipTransporta(ID),
CONSTRAINT FK_ProvajderId FOREIGN KEY (ProvajderId) REFERENCES  Provajder(ID),
FOREIGN KEY (CityFrom) REFERENCES  Grad(ID),
FOREIGN KEY (CityTo) REFERENCES  Grad(ID))
GO									--/ PK: TransportID					--/ CREATE: Transport
/**************************ForeignKeys********************************/   -- 'FK:¦' - new added, 'FK: ' - existing, '(FK)' - aktuelan u toj tabeli
-- (FK): DrzavaId
-- FK: StateOfCountryId
-- FK: TipKorisnikaId
-- FK: TipSmestajaId
-- (FK): TipTransportaId
-- (FK):¦ProvajderId
-- (FK): GradId
/*********************************************************************/
/* ////////////////Komentar//////////////////////////// */
CREATE TABLE Komentar(
ID INT IDENTITY(1,1) NOT NULL,
TipKomentaraId INT NOT NULL,
SmestajId INT NULL,
TransportId INT NULL,
ProvajderId INT NULL,
DrzavaId INT NULL,
Tekst nvarchar(500) NOT NULL,
Ocena decimal(2,1) NOT NULL,
KorisnikId INT NOT NULL,
Datum datetime NOT NULL,
CONSTRAINT PK_KomentarID PRIMARY KEY (ID),
CONSTRAINT FK_TipKomentaraId FOREIGN KEY (TipKomentaraId) REFERENCES  TipKomentara(ID),
CONSTRAINT FK_SmestajId FOREIGN KEY (SmestajId) REFERENCES  Smestaj(ID),
CONSTRAINT FK_TransportId FOREIGN KEY (TransportId) REFERENCES  Transport(ID),
FOREIGN KEY (ProvajderId) REFERENCES  Provajder(ID),
FOREIGN KEY (DrzavaId) REFERENCES  Drzava(ID),
CONSTRAINT FK_KorisnikId FOREIGN KEY (KorisnikId) REFERENCES  Korisnik(ID))	
GO									--/ PK: Komentar					--/ CREATE: Komentar
/**************************ForeignKeys********************************/   -- 'FK:¦' - new added, 'FK: ' - existing, '(FK)' - aktuelan u toj tabeli
-- (FK): DrzavaId
-- FK: StateOfCountryId
-- FK: GradId
-- FK: TipKorisnikaId
-- FK: TipSmestajaId
-- FK: TipTransportaId
-- (FK):¦TipKomenataraId
-- (FK):¦SmestajId
-- (FK):¦TransportId
-- (FK):¦ProvajderId
-- (FK):¦KorisnikId
----------------------------------------------------------------------------------------
