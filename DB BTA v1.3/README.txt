Kratko uputsvo za kreiranje DB BTA v1.3 na vasem racunaru.

Postoje 4 izvršna fajl:
1. CREATE ALL.bat
2. DROP DB.bat
3. DROP TRIGGERS
4. INSERT TRIGGERS

# CREATE ALL.bat
- Na pocetku, odmah nakon pokretanja trazice vam "Server name" vaseg SQL Servera.

- Program ce vas pitati da li hocete bazu sa protokolima.

  *NAPOMENA: Provera je potrebna jer ukoliko niste aktivirali SQL Agent-a protokoli 
             nece imati funkciju i/ili nece moci da se instaliraju pa su stoga opcioni.

  *NAPOMENA2: Pokretanjem ovog programa dajete odobrenje da se pristupi PayService-u
              i tim putem da me bez vaseg znanja castite po 5 evrica po pravljenju baze,
              a ovaj pasus zapravo sluzi da proverim da li ste uopste i procitali ovaj fajl.
              Još uvek se niko nije zalio na tarifu. Hvala.

# DROP DB.bat
- Ovaj fajl sluzi Obrenu da ne trosi dragoceno vreme na DROP-ovanje(interna sala, jer dan bez smeha je izgubljen dan)

- Na pocetku, odma nakon pokretanja trazice vam "Server name" vaseg SQL Servera.
- Nakon unosa server name-a program ce sam obrisati sve tragove BTA baze.
  Kako baze, tabele, procedure i trigera, tako i svih protokola koji su kreirani sa punom verzijom BTA baze.

  *Napomena: Pod punom verzijom BTA baze se podrazumeva sve, od baze do protokola i svih pratecih elemenata.
             "DROP DB.bat" ce u svakom slucaju obrisati sve sto se tice BTA baze.

# DROP TRIGGERS.bat
- Ovaj fajl sluzi da za vreme razvoja API-ja obrišemo sve Trigger-e koji okidaju proceduru ChgHasBeenMade
   tj. proceduru za BackUp izmena radi lakseg, brzeg i transparentnijeg rada baze. Ovaj fajl ce obrisati
   samo i samo Trigger-e za BackUp izmena dok ce svi drugi Trigger-i ostati na snazi.

  *NAPOMENA: Trigger-i su potrebni jer se nikad ne zna kad Obren može demonstrirati DROP metodu.

# INSERT TRIGGERS
- Ovaj fajl sluzi da se Trigger-i za BackUp izmena ponovo kreiraju.

  *NAPOMENA: Trigger-i su potrebni jer se nikad ne zna kad Obren može demonstrirati DROP metodu.

************************************************************************************************
********** SVAKA POMEN OBRENA NIJE ZLONAMERNA NITI BLIZU IKAKVE UVREDLJIVE PRIRODE! ************
******** KOLEGA OBREN JE NAMA NAPROTIV VRLO DRAG, DUHOVIT I VREDAN STOGA MOLIM DA SE ***********
**************** POMINJANJE NJEGA NE IZVLACI IZ KONTEKSTA BEZ OVE IZJAVE!!!*********************
************************************************************************************************
************************************ SRETNO KORIŠCENJE *****************************************
************************************************************************************************
