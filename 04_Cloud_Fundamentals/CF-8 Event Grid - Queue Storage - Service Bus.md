# **Event Grid, Queue Storage, Service Bus**

## **Event Grid**

Met Event Grid is het eenvoudig om toepassingen te bouwen met op gebeurtenissen architecturen. Azure Event Grid wordt geïmplementeerd om de beschikbaarheid te maximaliseren door systeem-eigen verspreiding uit te breiden over meerdere foutdomeinen in elke regio, en over beschikbaarheidszones (in regio's die deze ondersteunen).

![img](https://docs.microsoft.com/nl-nl/azure/event-grid/media/overview/functional-model-big.png#lightbox)

**Architectuur voor serverloze toepassingen**

Event Grid verbindt gegevensbronnen en gebeurtenis-handlers. Gebruik Event Grid bijvoorbeeld voor het activeren van een serverloze functie waarmee afbeeldingen worden geanalyseerd wanneer deze worden toegevoegd aan een blobopslagcontainer.

![img](https://docs.microsoft.com/nl-nl/azure/event-grid/media/overview/serverless_web_app.png)

**Automatisering van bewerkingen**

Met Event Grid kunt u sneller automatiseren en gemakkelijker beleid afdwingen. U kunt bijvoorbeeld met Event Grid een melding sturen naar Azure Automation wanneer er een virtuele machine of database in Azure SQL wordt gemaakt. Gebruik de gebeurtenissen om automatisch te controleren of serviceconfiguraties compatibel zijn, metagegevens aan te bieden aan tools voor bewerkingen, virtuele machines te taggen of werkitems te archiveren.

![img](https://docs.microsoft.com/nl-nl/azure/event-grid/media/overview/ops_automation.png)

**Integratie van toepassingen**

Event Grid verbindt uw app met andere services. Maak bijvoorbeeld een aangepast onderwerp om de gebeurtenisgegevens van uw app naar Event Grid te versturen en zo uw voordeel te doen met de betrouwbare bezorging, geavanceerde routering en directe integratie met Azure. U kunt Event Grid ook gebruiken met Logic Apps om op elke locatie gegevens te verwerken, zonder dat u hiervoor code hoeft te schrijven.

![img](https://docs.microsoft.com/nl-nl/azure/event-grid/media/overview/app_integration.png)

**Wat kost Event Grid?**

Azure Event Grid maakt gebruik van een prijsmodel voor betalen per gebeurtenis, zodat u alleen betaalt voor wat u gebruikt. De eerste 100.000 bewerkingen per maand zijn gratis. Bewerkingen worden gedefinieerd als inkomende gebeurtenissen, bezorgingspogingen voor abonnementen, beheeroproepen, en filteren op achtervoegsels van onderwerpen. 

<br>

## **Queue Storage**

Azure Queue Storage is een service voor het opslaan van grote aantallen berichten. Overal ter wereld is er toegang tot berichten via geverifieerde oproepen via HTTP of HTTPS. Een wachtrijbericht kan maximaal 64 KB groot zijn. Een wachtrij kan miljoenen berichten bevatten, tot de totale capaciteitslimiet van een opslagaccount. Wachtrijen worden vaak gebruikt om een backlog van werk te maken om asynchron te verwerken.

![Diagram met de relatie tussen een opslagaccount, wachtrijen en berichten](https://docs.microsoft.com/nl-nl/azure/storage/queues/media/storage-queues-introduction/queue1.png)

- URL-indeling: Wachtrijen kunnen worden geadresseerd met de volgende URL-indeling:

    - `https://<storage account>.queue.core.windows.net/<queue>`

- Met de volgende URL wordt een wachtrij in het diagram geadresseerd:

    - `https://myaccount.queue.core.windows.net/images-to-download`

- Storage account: Alle toegang tot Azure Storage wordt uitgevoerd via een opslagaccount. Zie Schaalbaarheids- en prestatiedoelen voor standaardopslagaccounts voor informatie over de capaciteit van het opslagaccount.

- Wachtrij: Een wachtrij bevat een set berichten. De naam van de wachtrij moet kleine letters zijn. Zie Wachtrijen en metagegevens benoemen voor informatie over naamgevingswachtrijen.

- Bericht: Een bericht, in elke indeling, van maximaal 64 KB. Vóór versie 2017-07-29 is de maximale toegestane time-to-live zeven dagen. Voor versie 2017-07-29 of hoger kan de maximale time-to-live een positief getal zijn of -1 waarmee wordt aangegeven dat het bericht niet verloopt. Als deze parameter wordt weggelaten, is de standaardtijd zeven dagen.

## **Service Bus**

De Azure Service Bus is een volledig beheerde berichtenbroker voor ondernemingen met berichtenwachtrijen en onderwerpen voor publiceren/abonneren (in een naamruimte). Service Bus wordt gebruikt om toepassingen en services van elkaar los te koppelen, waardoor de volgende voordelen worden geboden:

- Taakverdeling tussen concurrerende werkrollen
- Veilig routeren en overdragen van gegevens en controle over de grenzen van services en toepassingen heen
- Transactionele werkzaamheden coördineren waarvoor een hoge mate van betrouwbaarheid vereist is    

Gegevens worden uitgewisseld tussen verschillende toepassingen en services met behulp van berichten. Een bericht is een container die is voorzien van metagegevens en gegevens bevat. De gegevens kunnen elk soort informatie zijn, inclusief gestructureerde gegevens die zijn gecodeerd in algemene indelingen, zoals de volgende: JSON, XML, Apache Avro, tekst zonder opmaak.

Berichten worden verzonden naar en ontvangen van wachtrijen. Wachtrijen slaan berichten op totdat de ontvangende toepassing ze kan ontvangen en verwerken.

![img](https://docs.microsoft.com/nl-nl/azure/service-bus-messaging/media/service-bus-messaging-overview/about-service-bus-queue.png)

U kunt ook **onderwerpen** gebruiken voor het verzenden en ontvangen van berichten. Daar waar een wachtrij vaak wordt gebruikt voor punt-naar-punt communicatie, zijn onderwerpen handig in scenario's met publiceren/abonneren.

![img](https://docs.microsoft.com/nl-nl/azure/service-bus-messaging/media/service-bus-messaging-overview/about-service-bus-topic.png)

Onderwerpen kunnen meerdere, onafhankelijke abonnementen hebben, die aan het onderwerp worden gekoppeld en anders exact als wachtrijen van de ontvangerzijde werken. Een abonnee van een onderwerp kan een kopie ontvangen van elk bericht dat naar dat onderwerp wordt verzonden. Abonnementen worden entiteiten genoemd. Abonnementen duren standaard lang, maar kunnen worden geconfigureerd om te verlopen en vervolgens automatisch te worden verwijderd. Via de Java Message Service -API (JMS) Service Bus Premium ook vluchtige abonnementen maken die bestaan voor de duur van de verbinding.

U kunt regels definiëren voor een abonnement. Een abonnementsregel bevat een filter om een voorwaarde te definiëren voor het bericht dat moet worden gekopieerd naar het abonnement en een optionele actie die metagegevens van berichten kan wijzigen. Zie Onderwerpfilters en acties voor meer informatie. Deze functie is handig in de volgende scenario's:

- U wilt niet dat een abonnement alle berichten ontvangt die naar een onderwerp worden gestuurd.
- U wilt berichten met extra metagegevens markeren wanneer deze via een abonnement worden doorgegeven.

Een **naamruimte** is een container voor alle berichtenonderdelen (wachtrijen en onderwerpen). Er kunnen zich meerdere wachtrijen en onderwerpen in één naamruimte bevinden, en naamruimten fungeren vaak als toepassingscontainers.

Een naamruimte kan worden vergeleken met een server in de terminologie van andere brokers, maar de concepten zijn niet direct gelijkwaardig. Een Service Bus-naamruimte is uw eigen capaciteitssegment van een groot cluster dat uit tientallen allemaal actieve virtuele machines bestaat. Deze kan eventueel drie Azure-beschikbaarheidszones omvatten. Daarom krijgt u alle voordelen van beschikbaarheid en robuustheid van het uitvoeren van de berichtenbroker op een enorme schaal. En u hoeft zich geen zorgen te maken over de onderliggende complexiteiten. Service Bus is serverloze berichten.
## **Key-terms**


## **Opdracht**

- Bestudeer Event Grid, Queue Storage en Service Bus 

### **Gebruikte bronnen**

*<https://docs.microsoft.com/en-us/azure/event-grid/overview>*

*<https://docs.microsoft.com/en-us/azure/storage/queues/storage-queues-introduction>*

*<https://docs.microsoft.com/en-us/azure/service-bus-messaging/service-bus-messaging-overview>*

### **Ervaren problemen**

*Geen*

### **Resultaat**

*Waar is Azure Database voor?*



*Hoe vervangt Azure Database in een klassieke setting?*


*Hoe kan ik Azure Database combineren met andere diensten?*



*Wat is het verschil tussen Azure Database en andere gelijksoortige diensten?*



*Waar kan ik deze dienst vinden in de console?*


*Hoe zet ik deze dienst aan?*


*Hoe kan ik deze dienst koppelen aan andere resources?*
