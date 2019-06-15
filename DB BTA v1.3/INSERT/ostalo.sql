USE BTA
GO
/*TipKomentara(ID,Naziv)*/
INSERT INTO TipKomentara(Naziv) VALUES ('Comment'),('Rating');

/*TipSmestaja(ID,Naziv)*/
INSERT INTO TipSmestaja(Naziv) VALUES ('Hotel'),('Hostel'),('Apartment'),('Home');

/*TipTransporta(ID,Naziv)*/
INSERT INTO TipTransporta(Naziv) VALUES ('Airplane'),('Bus'),('Company car'),('Rent a car'),('Train'),('Taxi');

/*TipKorisnika(ID,Naziv)*/
INSERT INTO TipKorisnika(Naziv) VALUES (N'Administrator'),(N'Traveler');

/*Smestaj(ID,Naziv,TipSmestajaId,Opis,Ocena,Email,Telefon,GradId) */
INSERT INTO Smestaj VALUES (N'Holiday Inn',1,N'Odlican hotel na Novom Beogradu, crna staklena zgrada',2.1,N'info@holidayinn.com',N'+381111001001',12125),
(N'HYATT REGENCY',1,N'Odlican hotel na Novom Beogradu, odlican smestaj, sve glavonje tu odsedaju.',4.8,N'info@hyatt.com',N'+3811110022002',12125),
(N'Falkensteiner',1,N'Odlican hotel na Novom Beogradu, cudnog nepravilnog oblika zgrada, kod kruznog toka nedaleko od cuvene Ulice gladnih',2.1,N'info@falkensteiner.com',N'+381115005005',12125);

/* Provajder(ID,Naziv,TipTransportaId,Kontakt,Adresa,GradId,Telefon,Ocena) */
INSERT INTO Provajder VALUES (N'Raketa DOO',2,'Marko Preletacevic','Ratka Mitrovica 55',12125,'+3811165412121',4.7),
(N'Lasta DOO',2,'Suzana Mancic','Auto put Bg-Nis bb',12125,'+381117778887',4.6 ),
(N'Strela DOO',2,'Jelena Karleusa','Poletacka 22',12125,'+381112223331',5.0 );

/* Transport(ID,TipTransportaId,ProvajderId,Ocena,CityFrom,CityTo) */
INSERT INTO Transport VALUES (3,1,4.7,12125,13414),
(2,3,4.4,12125,13397),
(2,2,4.5,12125,13520),
(2,1,4.4,12125,12927);