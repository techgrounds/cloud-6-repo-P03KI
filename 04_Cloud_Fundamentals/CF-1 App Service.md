# **App Service**

Azure Compute is een service voor on-demand computing om cloudtoepassingen uit te voeren. Deze service biedt rekenresources zoals schijven, processors, geheugen, netwerken en besturingssystemen. De resources zijn op aanvraag beschikbaar en kunnen doorgaans in een paar minuten of zelfs seconden worden gebruikt. U betaalt alleen voor de resources die u gebruikt en alleen voor zolang u ze gebruikt.

Azure ondersteunt een breed scala aan rekenoplossingen voor ontwikkelen en testen, het uitvoeren van toepassingen en het uitbreiden van uw datacentrum. De service ondersteunt Linux, Windows Server, SQL Server, Oracle, IBM en SAP. Azure heeft ook veel services waarmee virtuele machines (VM's) kunnen worden uitgevoerd. Elke service biedt verschillende opties, afhankelijk van uw vereisten. Enkele van de bekendste services zijn:

- **Azure Virtual Machines**

    Virtuele machines zijn software-emulaties van fysieke computers. Ze bevatten een virtuele processor, geheugen, opslag en netwerkresources. VM's hosten een besturingssysteem en u kunt er software op installeren en uitvoeren zoals op een fysieke computer. Wanneer u een extern-bureaubladclient gebruikt, kunt u de VM gebruiken en aansturen alsof u er fysiek achter zit.

- **Azure Container Instances**

    Container Instances en Azure Kubernetes Service zijn Azure-rekenresources die u kunt gebruiken om containers te implementeren en te beheren. Containers zijn lichte, gevirtualiseerde toepassingsomgevingen. Ze zijn ontworpen om snel dynamisch te kunnen worden gemaakt, uitgebreid en gestopt. U kunt meerdere exemplaren van een containertoepassing op één hostcomputer uitvoeren.

- **Azure App Service**

    Met Azure App Service kunt u snel web-, mobiele en API-apps op ondernemingsniveau voor elk platform bouwen implementeren en schalen. U kunt voldoen aan strenge vereisten op het gebied van prestaties, schaalbaarheid, beveiliging en naleving met gebruik van een volledig beheerd platform voor onderhoud van infrastructuur. App Service is een PaaS-aanbieding (platform as a service).

- **Azure Functions (of serverloze computing)**

    Functions is ideaal als het u alleen gaat om de code waarmee uw service wordt uitgevoerd en niet om het onderliggende platform of de onderliggende infrastructuur. Het wordt over het algemeen gebruikt als er werk moet worden uitgevoerd als reactie op een gebeurtenis (vaak via een REST-aanvraag), timer of bericht van een andere Azure-service, en als dat werk binnen enkele seconden of sneller kan worden voltooid.
    
<br>

**Azure App Service** is een op HTTP gebaseerde service voor het hosten van webtoepassingen, REST API's en mobiele back-ends. U kunt er in uw favoriete taal programmeren, of het nu .NET, .NET Core, Java, Ruby, Node.js, PHP of Python is. Toepassingen kunnen eenvoudig worden uitgevoerd en geschaald in op Windows en Linux gebaseerde omgevingen.

App Service voegt niet alleen de kracht van Microsoft Azure aan uw toepassing toe, zoals beveiliging, taakverdeling, automatisch schalen en geautomatiseerd beheer. U kunt ook profiteren van de DevOps-mogelijkheden, zoals continue implementatie van Azure DevOps, GitHub, Docker Hub en andere bronnen, pakketbeheer, faseringsomgevingen, aangepast domein en TLS/SSL-certificaten.

Met App Service betaalt u voor de Azure-rekenresources die u gebruikt. De rekenresources die u gebruikt, zijn vastgesteld door het App Service-plan waarmee u uw apps uitvoert. Met App Service kunt u de meeste algemene app-servicestijlen hosten, zoals de volgende:

- **Web apps**

    App Service biedt volledige ondersteuning voor het hosten van web-apps met behulp van ASP.NET, ASP.NET Core, Java, Ruby, Node.js, PHP en Python. U kunt Windows of Linux gebruiken als hostbesturingssysteem.

- **API apps**

    Net als bij het hosten van een website kunt u op [REST](https://www.uptrends.nl/wat-is/rest-api) gebaseerde web-API's maken in een taal en framework naar keuze. U profiteert van volledige Swagger-ondersteuning en de mogelijkheid om van uw API een pakket te maken en de API te publiceren in Azure Marketplace. De gemaakte apps kunnen worden gebruikt op elke op HTTP of HTTPS gebaseerde client.

- **WebJobs**

    U kunt de functie WebJobs gebruiken om een programma (.exe, Java, PHP, Python of Node.js) of een script (.cmd, .bat, PowerShell of Bash) uit te voeren in dezelfde context als een web-app, API-app of mobiele app. U kunt deze programma's of scripts plannen of uitvoeren op basis van een trigger. WebJobs worden vaak gebruikt om achtergrondtaken uit te voeren als onderdeel van uw toepassingslogica.

- **Mobile apps**

    Gebruik de functie Mobile Apps van App Service om snel een back-end voor iOS- en Android-apps te maken. Met slechts enkele klikken in Azure Portal kunt u het volgende doen:

    - Gegevens van mobiele apps opslaan in een SQL-database in de cloud.
    - Klanten verifiëren op basis van socialemediaservices zoals MSA, Google, Twitter en Facebook.
    - Pushmeldingen verzenden.
    - Aangepaste back-endlogica uitvoeren in C # of Node.js.

Voor de mobiele app is SDK-ondersteuning beschikbaar voor systeemeigen iOS- en Android-apps, Xamarin-apps en systeemeigen React-apps.

Met App Service kunnen de meeste infrastructuurbeslissingen worden afgehandeld die u moet nemen bij het hosten van via internet toegankelijke apps:

- Implementatie en beheer zijn geïntegreerd in het platform.
- Eindpunten kunnen worden beveiligd.
- Sites kunnen snel worden geschaald om hoge verkeersbelastingen te verwerken.
- De ingebouwde taakverdeling en Traffic Manager bieden hoge beschikbaarheid.

<br>

**Waarom App Service gebruiken?**

Hier volgen enkele belangrijke functies van App Service:

- **Meerdere talen en frameworks**: App Service biedt uitstekende ondersteuning voor ASP.NET, ASP.NET Core, Java, Ruby, Node.js, PHP of Python. U kunt ook PowerShell en andere scripts of uitvoerbare bestanden als achtergrondservices uitvoeren.
Beheerde productieomgeving: in App Service worden automatisch patches gemaakt en het besturingssysteem en taalframeworks onderhouden. Besteed uw tijd aan het schrijven van geweldige apps en laat het platform aan Azure over.

- **Containervorming en Docker**: converteer uw app voor Dockerize-uitvoering en host een aangepaste Windows- of Linux-container in App Service. Voer apps met meerdere containers uit met Docker Compose. Migreer uw Docker-vaardigheden rechtstreeks naar App Service.

- **DevOps-optimalisatie**: stel continue integratie en implementatie in met Azure DevOps, GitHub, BitBucket, Docker Hub of Azure Container Registry. Verhoog updateniveaus via test- en faseringsomgevingen. Beheer uw apps in App Service met Azure PowerShell of de platformoverschrijdende opdrachtregelinterface (CLI).

- **Globale schaling met hoge beschikbaarheid**: u kunt handmatig of automatisch omhoog schalen of uitschalen. U kunt uw apps overal in de globale datacenterinfrastructuur van Microsoft hosten; de SLA van App Service belooft hoge beschikbaarheid.

- **Verbindingen met SaaS-platforms en on-premises gegevens**: u kunt kiezen uit meer dan 50 connectors voor bedrijfssystemen (zoals SAP), SaaS-services (zoals Salesforce) en internetservices (zoals Facebook). Toegang tot on-premises gegevens met hybride verbindingen en Azure Virtual Networks.

- **Beveiliging en naleving**: App Service voldoet aan de vereisten van ISO, SOC en PCI. Verifieer gebruikers met Azure Active Directory, Google, Facebook, Twitter of een Microsoft-account. Maak IP-adresbeperkingen en beheer service-identiteiten.

- **Toepassingssjablonen**: kies uit een uitgebreide lijst met toepassingssjablonen in Microsoft Azure Marketplace, zoals WordPress, Joomla en Drupal.
Integratie van Visual Studio en Visual Studio Code: specifieke hulpprogramma's in Visual Studio en Visual Studio Code stroomlijnen het maken en implementeren van apps en het opsporen van fouten.

- **API en mobiele functies**: App Service biedt direct CORS-ondersteuning voor RESTful-API-scenario's en vereenvoudigt scenario's met mobiele apps door verificatie, offline gegevenssynchronisatie en pushmeldingen in te schakelen.

- **Serverloze code**: voer een codefragment of script op aanvraag uit zonder dat u expliciet infrastructuur hoeft in te richten of te beheren. En u betaalt slechts voor de rekentijd die feitelijk door de code wordt gebruikt (zie Azure Functions).

## **Key-terms**

*Nvt*

## **Opdracht**

- Bestudeer App Services

### **Gebruikte bronnen**

*<https://docs.microsoft.com/nl-nl/azure/app-service>*

### **Ervaren problemen**

*Geen*

### **Resultaat**

