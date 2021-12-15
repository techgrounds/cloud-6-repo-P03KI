# **Azure Global Infrastructure**

Alles in de cloud, van servers tot networking, is virtualized. Als klant van een cloud provider hoef je je geen zorgen te maken over de onderliggende fysieke infrastructuur. De fysieke locatie van je applicatie of data kan echter wel belangrijk zijn.

De global infrastructure van Azure bestaat uit de volgende componenten:
1. *Regions*
2. *Availability Zones*
3. *Region Pairs*

Je hebt zelf controle over welke regio je gebruikt, maar niet elke service is beschikbaar in elke regio. Sommige services zijn ook niet gebonden aan een specifieke regio. Denk hierbij bijvoorbeeld aan Azure Subscriptions.

## **Key-terms**

- **Virtualization**

Met virtualisatie wordt een gesimuleerde, oftewel virtuele, computeromgeving gemaakt, dit in tegenstelling tot een fysieke omgeving. Bij virtualisatie gaat het vaak om door een computer gegenereerde versies van hardware, besturingssystemen, opslagapparaten en meer. Hierdoor kan een organisatie één fysieke computer of server partitioneren in een aantal virtuele machines. Vervolgens kan elke virtuele machine onafhankelijk interactie aangaan met verschillende besturingssystemen of toepassingen en deze uitvoeren, terwijl de resources van één hostcomputer worden gedeeld.

Door meerdere resources vanaf één computer of server te maken, kunnen dankzij virtualisatie de schaalbaarheid en de workloads worden verbeterd, terwijl er minder servers worden gebruikt, er minder energie wordt verbruikt, er minder onderhoud nodig is en de kosten voor de infrastructuur lager zijn. Virtualisatie kan in vier hoofdcategorieën worden onderverdeeld. De eerste is desktopvirtualisatie. Hierbij worden afzonderlijke desktops door één centrale server voorzien en beheerd. De tweede is netwerkvirtualisatie, ontworpen om de netwerkbandbreedte te splitsen in onafhankelijke kanalen die vervolgens worden toegewezen aan specifieke servers of apparaten. De derde categorie is softwarevirtualisatie. Hierbij zijn de toepassingen gescheiden van de hardware en het besturingssysteem. De vierde is opslagvirtualisatie, waarbij meerdere netwerkopslagresources tot één opslagapparaat worden gecombineerd, waartoe meerdere gebruikers toegang hebben.

## **Opdracht**

- Wat is een Azure Region?
- Wat is een Azure Availability Zone?
- Wat is een Azure Region Pair?
- Waarom zou je een regio boven een andere verkiezen?

### **Gebruikte bronnen**

<*https://azure.microsoft.com/nl-nl/overview/what-is-virtualization/*>

<*https://www.dataweb.nl/waar-staan-de-microsoft-azure-datacenters/*>

<*https://scct.nl/azure-availability-zones-uitgelegd/*>

<*https://build5nines.com/azure-region-pairs-explained/*>

<*https://azure.microsoft.com/nl-nl/global-infrastructure/geographies/#geographies*>

### **Ervaren problemen**

Geen

### **Resultaat**

- **Wat is een Azure Region?**

Een regio is een geografisch gebied op deze planeet met ten minste één, maar mogelijk meerdere datacentra die zich dichtbij en in hetzelfde netwerk bevinden als een netwerk met lage latentie. Resources worden in elke regio op intelligente wijze met Azure toegewezen en beheerd om ervoor te zorgen dat workloads passend worden verdeeld.

![Region](https://docs.microsoft.com/nl-nl/learn/azure-fundamentals/azure-architecture-fundamentals/media/regions-small-be724495.png)

- **Wat is een Azure Availability Zone?**

Beschikbaarheidszones zijn een fysiek afgescheiden datacentrum binnen een Azure-regio. Elke beschikbaarheidszone bestaat uit een of meer datacenters die zijn uitgerust met onafhankelijke voeding, koeling en netwerken. Een beschikbaarheidszone is ingesteld als een isolatiegrens. Als één beschikbaarheidszone uitvalt, blijven de andere werken. Beschikbaarheidszones zijn verbonden via zeer snelle, private glasvezelnetwerken.

![AzureRegion](https://docs.microsoft.com/nl-nl/learn/azure-fundamentals/azure-architecture-fundamentals/media/availability-zones-5c3c490c.png)

- **Wat is een Azure Region Pair?**

Elke Azure-regio is altijd gekoppeld aan een andere regio binnen hetzelfde geografische gebied (zoals VS, Europa of Azië) die zich minstens 480 km verderop bevindt. Hierdoor kunnen resources, zoals VM-opslag, worden gerepliceerd op een andere locatie binnen hetzelfde geografische gebied, zodat de kans wordt beperkt dat beide regio's tegelijkertijd worden beïnvloed door natuurrampen, onrusten, stroomstoringen, fysieke netwerkuitval of andere gebeurtenissen. Als een van beide regio's bijvoorbeeld wordt getroffen door een natuurramp, wordt voor services automatisch een failover-overschakeling naar de andere regio in het regiopaar uitgevoerd.

![AzureRegion](https://docs.microsoft.com/nl-nl/learn/azure-fundamentals/azure-architecture-fundamentals/media/region-pairs-d9eb9728.png)

- **Waarom zou je een regio boven een andere verkiezen?**

    - Gegevenslocatie.
       
        - Hoe korter de fysieke afstand tussen de user(base) en de Azure resources, des te lagere [latentie](https://nl.wikipedia.org/wiki/Latentie) men zal ervaren. Niemand houdt van '*lag*'.

    - Naleving
        
        Bijvoorbeeld:
        - US DoD Central, US Gov Virginia, US Gov Iowa en meer: Deze regio's zijn fysiek en logisch van netwerken afgeschermde instanties van Azure voor de Amerikaanse overheid en haar partners. Deze datacentra worden bediend door gecontroleerde Amerikaanse staatsburgers en bevatten aanvullende nalevingscertificeringen.
        - China - oost, China - noord en meer: Deze regio's zijn beschikbaar via een unieke samenwerking tussen Microsoft en 21Vianet, waarbij Microsoft niet rechtstreeks de datacentra onderhoudt.

    - Beschikbaarheid van services. 
        
        - Niet elke regio biedt bijvoorbeeld [ondersteuning voor beschikbaarheidszones](https://docs.microsoft.com/nl-nl/azure/availability-zones/az-region).

    - Prijs

        - De [prijs](https://azureprice.net/regions) per regio kan verschillen.