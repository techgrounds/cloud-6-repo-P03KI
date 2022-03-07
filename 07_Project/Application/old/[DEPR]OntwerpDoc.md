# Ontwerp Documentatie

## Index

- Inleiding
    - Achtergrond
    - Gebruikte documenten
    - Standaards & richtlijnen


- Systeemarchitectuur
    - Architectuur (subsystemen)
    - Hardware
    - Software
    - Communicatie
    - Gegevensopslag
    - Overzicht systeemarchitectuur

- Gegevensmodel

- Gebruikersinterface
    - Schermen
    - Menu's
    - Knoppenbalken

- Objectmodel
- Processen
[Inventaris](../07_Project\Docs\OntwerpDoc.md#Inventaris)

## 1 Inleiding

Lorem Ipsum
 Algemene inleiding op het ontwerp. 
 
 ### 1.1 Achtergrond
 
 Achtergrondinformatie over het project. Wie is opdrachtgever? Wat doet het systeem? Wie zijn de gebruikers? Wat zijn enkele karakteristieken van het systeem? Enz. 
 
 ### 1.2 Gebruikte documenten
 
 Een opsomming van documenten die zijn gebruikt bij het opstellen van het ontwerp. 
 
 ### 1.3 Standaards & richtlijnen
 
 Een opsomming van standaards en richtlijnen die zijn gebruikt bij het opstellen van dit document. Denk aan ontwerprichtlijnen (UML, DFD, PSD, OMD, ERD enz.),maar ook aan programmeertaal, -richtlijnen enz.

https://docs.microsoft.com/nl-nl/azure/architecture/guide/design-principles/


 ## 2 Systeemarchitectuur
 
 Beschrijving van de systeemarchitectuur en eventuele verschillende subsystemen. 
 
 ### 2.1 Architectuur (subsystemen)
 
 Beschrijving van de architectuur (multi tier, systemen en afhankelijkheden). 
 
 ### 2.2 Hardware
 
 Beschrijving van de benodigde en gebruikte hardware. 
 
 ### 2.3 Software
 
 Beschrijving van de benodigde en gebruikte software. 
 
 ### 2.4 Communicatie
 
 Beschrijving van de manier(en) van communicatie tussen verschillende deelsystemen. Ook een beschrijving van interfaces op deelsystemen. 
 
 ### 2.5 Gegevensopslag
 
 Beschrijving van de manier(en) van gegevensopslag. 
 
 ### 2.6 Overzicht systeem architectuur
 
 Een totaaloverzicht (afbeelding) van de systeemarchitectuur.

## 3 Gegevensmodel

Beschrijving van het gegevensmodel (datamodel) of de verschillende gegevensmodellen. 

### 3.1 ERD (Entiteit Relatie Diagram)

Schematische weergave van de verschillende soorten gegevens die worden opgeslagen. 

### 3.2 Databases
Benoeming van de verschillende databases. 

### 3.3 Database A

Beschrijving van de verschillende databases van het systeem.
#### 3.3.1.Schema's
Beschrijving van de verschillende schema's van database A.
#### 3.3.2.Tabellen
Beschrijving van de verschillende tabellen per schema.
#### 3.3.3.Views
Beschrijving van de verschillende views per schema. 
### 3.4 Bestanden
Beschrijving van de verschillende bestanden waarin informatie wordt opgeslagen. Dit kunnen gegevensbestanden, logbestanden of confguratiebestanden zijn. 
### 3.5 Bestand B
Beschrijving van bestand B.

## 4 Gebruikersinterface
Een beschrijving van de gebruikersinterface van het systeem. 
### 4.1 Schermen
Beschrijving van de schermen, of een verwijzing naar het functioneel ontwerp indien de schermen daar volledig zijn uitgewerkt. 
### 4.2 Menu's
Beschrijving van de verschillende menu's van het systeem. 
### 4.3 Knoppenbalken
Beschrijving van de verschillende knoppenbalken van het systeem.

 ## 5 Object Model
 Beschrijving van het object model van het systeem. 
 5.1 Object Model DiagramSchematische weergave (afbeelding) van het object model.
  5.2 ObjectenBenoeming van de verschillende objecten of classes. 
  5.3 Object ABeschrijving van Object A.
  5.3.1.MethodesUitwerking van de verschillende methodes van Object A. Belangrijkste is input, output en parameters. Pseudocode is optioneel.
  5.3.2.FunctiesUitwerking van de verschillende functies van Object A. Belangrijkste is input, output en parameters. Pseudocode is optioneel.
  5.3.3.EigenschappenUitwerking van de verschillende eigenschappen. Pseudocode is optioneel.5.3.4.EnumeratiesUitwerking van de verschillende enumeraties.

6 Processen
Uitwerking van de verschillende processen binnen het systeem. 
6.1 Gebruikersfuncties (use cases)
Benoeming van de verschillende gebruikersfuncties of use cases die zijn behandeld in het functioneel ontwerp. 6.2 Gebruikersfunctie ABeschrijving van gebruikersfunctie A.
6.2.1.Activity Diagram / Programma Structuur DiagramDe fow van gebruikersfunctie A in schemavorm weergegeven.
6.2.2.GegevensmodelBeschrijving van de gebruikte tabellen en views.
6.2.3.GebruikersinterfaceBeschrijving van de gebruikte schermen, menu's en knoppenbalken.
6.2.4.ObjectmodelBeschrijving van de gebruikte objecten / classes.
6.3 SysteemfunctiesBenoeming van de verschillende systeemfuncties die zijn behandeld in het functioneel ontwerp. Systeemfuncties hebben geen gebruikersinterface. 
6.4 Systeemfunctie BBeschrijving van systeemfunctie B.
6.4.1.Activity Diagram / Programma Structuur DiagramDe fow van systeemfunctie B in schemavorm weergegeven.
6.4.2.GegevensmodelBeschrijving van de gebruikte tabellen en views.
6.4.3.ObjectmodelBeschrijving van de gebruikte objecten / classes

## Inventaris

- Encryptie op schijven.
- Daily Backup met 7 dagen retentie
- Automated install webserver
- Admin server -> Publiek IP en trusted IP's | SSH/RDP
- IP ranges  10.10.10.0/24 & 10.20.20.0/24
- Firewall op subnets

## Kosten

Naar aanleiding van het inventaris een snelle kosten schatting middels de TCO Calculator.
- [TCO Calculator](https://azure.com/tco/9aa04333bb9345df98e651eeee59d5f6/)
    - $6077 per 5 jaar. +/- 100 pm. 

## Implementatie



