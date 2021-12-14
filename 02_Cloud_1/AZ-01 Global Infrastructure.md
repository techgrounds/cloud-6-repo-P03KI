# Azure Global Infrastructure

Alles in de cloud, van servers tot networking, is virtualized. Als klant van een cloud provider hoef je je geen zorgen te maken over de onderliggende fysieke infrastructuur. De fysieke locatie van je applicatie of data kan echter wel belangrijk zijn.

De global infrastructure van Azure bestaat uit de volgende componenten:
1. Regions
2. Availability Zones
3. Region Pairs

Je hebt zelf controle over welke regio je gebruikt, maar niet elke service is beschikbaar in elke regio. Sommige services zijn ook niet gebonden aan een specifieke regio. Denk hierbij bijvoorbeeld aan Azure Subscriptions.

## Key-terms

- Virtualization

    Met virtualisatie wordt een gesimuleerde, oftewel virtuele, computeromgeving gemaakt, dit in tegenstelling tot een fysieke omgeving. Bij virtualisatie gaat het vaak om door een computer gegenereerde versies van hardware, besturingssystemen, opslagapparaten en meer. Hierdoor kan een organisatie één fysieke computer of server partitioneren in een aantal virtuele machines. Vervolgens kan elke virtuele machine onafhankelijk interactie aangaan met verschillende besturingssystemen of toepassingen en deze uitvoeren, terwijl de resources van één hostcomputer worden gedeeld.

    Door meerdere resources vanaf één computer of server te maken, kunnen dankzij virtualisatie de schaalbaarheid en de workloads worden verbeterd, terwijl er minder servers worden gebruikt, er minder energie wordt verbruikt, er minder onderhoud nodig is en de kosten voor de infrastructuur lager zijn. Virtualisatie kan in vier hoofdcategorieën worden onderverdeeld. De eerste is desktopvirtualisatie. Hierbij worden afzonderlijke desktops door één centrale server voorzien en beheerd. De tweede is netwerkvirtualisatie, ontworpen om de netwerkbandbreedte te splitsen in onafhankelijke kanalen die vervolgens worden toegewezen aan specifieke servers of apparaten. De derde categorie is softwarevirtualisatie. Hierbij zijn de toepassingen gescheiden van de hardware en het besturingssysteem. De vierde is opslagvirtualisatie, waarbij meerdere netwerkopslagresources tot één opslagapparaat worden gecombineerd, waartoe meerdere gebruikers toegang hebben.

## Opdracht

- Wat is een Azure Region?
- Wat is een Azure Availability Zone?
- Wat is een Azure Region Pair?
- Waarom zou je een regio boven een andere verkiezen?

### Gebruikte bronnen

<https://azure.microsoft.com/nl-nl/overview/what-is-virtualization/>

<https://www.dataweb.nl/waar-staan-de-microsoft-azure-datacenters/>

<https://scct.nl/azure-availability-zones-uitgelegd/>

<https://build5nines.com/azure-region-pairs-explained/>

<https://azure.microsoft.com/nl-nl/global-infrastructure/geographies/#geographies>

### Ervaren problemen

Geen

### Resultaat

- Wat is een Azure Region?

    Een regio is een set datacenters die is geïmplementeerd in een op basis van latentie gedefinieerde perimeter en verbonden via een toegewezen regionaal netwerk. 

- Wat is een Azure Availability Zone?

    Availability Zones is een Azure dienst met die uw toepassingen en gegevens beveiligt tegen storingen in, en uitval van Azure datacenters. Availability Zones zijn aparte fysieke locaties binnen een Azure-regio. Elke Availability Zone bestaat uit een of meer datacenters uitgerust met onafhankelijke stroom, koeling en netwerken. Om hoge beschikbaarheid te garanderen, zijn er minimaal drie afzonderlijke Availability Zones in een regio. Zone-redundante services repliceren uw toepassingen en gegevens over de Availability Zones ter bescherming van single-points-of-failure. Met Availability Zones biedt Azure een 99,99% VM-uptime SLA.

    Een Availability Zone in een Azure-regio is een combinatie van een ‘fault domain’ en een ‘update domain’. Bijvoorbeeld, als u drie of meer virtuele machines over drie zones in een Azure-regio maakt, worden de VM’s effectief over drie ‘fault domains’ en drie ‘update domains’ gedistribueerd. Het Azure-platform herkent deze verdeling tussen ‘update domains’ om ervoor te zorgen dat virtuele machines in verschillende zones op hetzelfde moment niet worden geüpdatet.

- Wat is een Azure Region Pair?

    An Azure Region Pair is a relationship between 2 Azure Regions within the same geographic region for disaster recovery purposes. If one of the regions were to experience a disaster or failure, then the services in that region will automatically failover to that regions secondary region in the pair. For example, North Central US region’s pair is South Central US.

    Almost all the Azure Regions are located within the same geographic region as at least 1 other Azure Region; it’s Region Pair. The only exception to this rule is the Brazil South region, which is the only Azure Region in Brazil, so it’s Region Pair is South Central US in a one-way pairing connection, as South Central US’s pair is North Central US. I know this sounds confusing, but this is the only Azure Region who’s pair is outside it’s geographic region.

    The Azure Region Pairs are more than just a visual concept to think about with Azure Regions. The Azure Region pairs are connected directly together and offer multiple benefits when utilized together in the same distributed or redundant system. Before we get into these benefits of Azure Region Pairs, let’s first discuss the Azure Regions and Datacenters in further details.

    Azure Regions in a Pair have direct connections which bring additional benefits to use them together.

    The geographic disparity of Azure Regions is important. Global distribution of Azure Regions is strategic according to geography. There are many factors involved in their placement; from geo-political to internet latency for large population centers. However, Azure Region pairs have another big consideration that defines where they are placed.

    Each Azure Region in a pair are always located greater than 300 miles apart when possible. This is to isolate each region in the pair from being affected by the same regional disasters that could take one of the regions down. These disasters could be earthquakes, hurricanes, tornados, fires, or some other natural or man-made disaster.

- Waarom zou je een regio boven een andere verkiezen?

    - Naleving en gegevenslocatie
    - Beschikbaarheid van services
    - Prijs