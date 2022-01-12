# **MS Learning Path Summary - Module 2**

## **Azure Functions**

**Serverless ->** 
abstractie van servers, infrastructuur en besturingssystemen. Azure regelt het beheer van de serverinfrastructuur, de toewijzing van resources en het ongedaan maken ervan op basis van de vraag. Schalen en prestaties worden automatisch afgehandeld. Betaalt alleen voor gebruikte resources en niet nodig om capaciteit te reserveren.

**Azure Functions**
    
    Eigen code die wordt uitgevoerd op een gebeurtenis zoals REST-request, timer of Azure notificatie. Schaalt automatisch. Betaal alleen voor gebruikte CPU resources. Functions kunnen stateless (standaard, reset) of statefull (Durable, context ivm eerdere actviteiten).

**Azure Logic Apps**

    Logic Apps voeren workstreams uit om bedrijfsscenario's te automatiseren welke opgebouwd zijn uit vooraf gedefinieerde blokken via triggers. Implementatie via GUI.


|   | AZ Functions  | AZ Logic Apps  |
|---|---|---|
| Staat  | Normaal staatloos, maar stateful is mogelijk met Durable Functions.  |  Stateful |
| Ontwikkeling  |  Code-first (imperatief) | Designer-first (declaratief)  |
|  Connectiviteit |  Circa tien ingebouwde bindingstypen. Schrijf code voor aangepaste bindingen. | Grote verzameling connectors. Enterprise Integration Pack voor B2B-scenario's. Bouw aangepaste connectors.  |
| Acties  | Elke activiteit is een Azure-functie. Schrijf code voor de activiteitsfuncties  | Grote verzameling kant-en-klare acties  |
|  Bewaking | Azure Application Insights  | Azure Portal, Log Analytics  |
|  Beheer | REST API, Visual Studio  | Azure Portal, REST API, PowerShell, Visual Studio  |
|  Context voor uitvoering  |  Lokaal of Cloud  |  Cloud-only  |

*<https://docs.microsoft.com/nl-nl/learn/modules/azure-compute-fundamentals/azure-functions>*

<br>

## **Virtual Desktop**

Azure Virtual Desktop is een desktop- en toepassingsvirtualisatieservice in de cloud. Mogelijk vanaf elke locatie een in de cloud gehoste versie van Windows te gebruiken.
Werkt op apparaten zoals Windows, Mac, iOS, Android en Linux.

1. Betere beveliging. 

   1. Gecentraliseerd beveiligingsbeheer met Azure Active Directory
    2. RBAC (rolebased) implementatie
    3. Gecheiden van lokale hardware
    4. Reverse connect verbinding (geen inkomende open poorten)

2. Betere gebruikerservaring

    1. AZ VD via elk apparaat benaderbaar.
    2. Lokalisatie van host-vm's bij datacentrum met andere services voor snelheid.
    3. Geen verschil voor users
    4. Externe persoonlijke bureaubladen zonder invloed op andere users.

3. Vereenvoudigd beheer -> Azure AD en RBAc voor beheer.

4. Prestatiebeheer -> Load balancing in VM-hostgroepen.

5. Windows 10 multi-sessie -> meerdere gelijktijdige gebruikers op 1 VM.
6. Kostenbesparend -> Met 365 licentie gratis beschikbaar. Alleen kosten voor de Azure resources. (Vooraf of maandelijks betalen voor een reservering voor 1 of 3 jaar. Max 72% besparing)

*<https://docs.microsoft.com/nl-nl/learn/modules/azure-compute-fundamentals/windows-virtual-desktop>*

<br>

## **Azure Virtual Network**

**Azure Virtual Network** stelt Azure-resources, zoals virtuele machines, web-apps en databases, in staat om te communiceren met elkaar, gebruikers op internet en on-premises clientcomputers. U kunt een Azure-netwerk zien als een set resources die andere Azure-resources aan elkaar koppelt.

Virtuele Azure-netwerken bieden de volgende belangrijke netwerkmogelijkheden:

- **Isolatie en segmentatie**
    - privé-IP-adresruimte met behulp van een openbaar IP-adresbereik of een privé-IP-adresbereik

- **Communicatie via internet**

    - Azure CLI, Remote Desktop Protocol of Secure Shell

- **Communicatie tussen Azure-resources**
    - **Virtuele netwerken** 
    
    Virtuele netwerken kunnen niet alleen VM's verbinden, maar ook andere Azure-resources, zoals de App Service Environment voor Power Apps, Azure Kubernetes Service en virtuele-machineschaalsets van Azure.

    - **Service Endpoints**
    
     service-eindpunten gebruiken om verbinding te maken met andere typen Azure-resources, zoals Azure SQL-databases en Azure-opslagaccounts. 

- **Communicatie met on-premises resources**

    - **Punt naar punt VPN (pc naar bedrijfsnetwerk)**

    - **Site naar site VPN (On-premis gateway naar virtueel 
    netwerk)**

    - **Azure ExpressRoute (meer bandbreedte, hogere beveiliging, niet via internet)**


- **Netwerkverkeer routeren**

    - Routetabellen Met een routetabel kunt u regels definiëren over hoe verkeer moet worden omgeleid. U kunt aangepaste routetabellen maken die bepalen hoe pakketten tussen subnetten worden gerouteerd.

    - **Border Gateway Protocol** (BGP) werkt met Azure VPN-gateways of ExpressRoute om on-premises BGP-routes door te geven aan virtuele Azure-netwerken.

- **Netwerkverkeer filteren**

    - Netwerkbeveiligingsgroepen Een netwerkbeveiligingsgroep is een Azure-resource die meerdere inkomende en uitgaande beveiligingsregels kan bevatten. U kunt deze regels zo definiëren dat verkeer wordt toegestaan of geblokkeerd op basis van het IP-adres van bron en doel, de poort en het protocol.

    - Virtuele netwerkapparaten Een virtueel netwerkapparaat is een gespecialiseerde VM die kan worden vergeleken met een beveiligd netwerkapparaat. Een virtueel netwerkapparaat voert een bepaalde netwerkfunctie uit, zoals een firewall of WAN-optimalisatie (Wide Area Network).

- **Virtuele netwerken met elkaar verbinden**
    - Koppelen met behulp van peering voor virtuele netwerken. Dankzij peering kunnen resources in ieder virtueel netwerk met elkaar communiceren. Deze virtuele netwerken kunnen zich in verschillende regio's bevinden. Hierdoor kunt u via Azure een wereldwijd verbonden netwerk maken.

![IMG](https://docs.microsoft.com/nl-nl/learn/azure-fundamentals/azure-networking-fundamentals/media/local-or-remote-gateway-in-peered-virual-network-21106a38.png)

*<https://docs.microsoft.com/nl-nl/learn/modules/azure-networking-fundamentals/azure-virtual-network-fundamentals>*

<br>

## **Azure Virtual Network-instellingen**

- **Netwerknaam** uniek in abo, niet wereldwijd.
- **Adresruimkte** CIDR-indeling (Classless Inter-Domain Routing)
- **DDOS bescherming** basis of standaard (premium)
- **Service-endpoints** o.a Azure Cosmos DB, Azure Service Bus en Azure Key Vault
- **NSG** Netwerkbeveiligingsgroepen hebben beveiligingsregels waarmee u kunt filteren op het type netwerkverkeer dat van en naar subnetten van virtuele netwerken en van en naar netwerkinterfaces kan stromen.
- **Routetabel** Azure maakt automatisch een routetabel voor elk subnet binnen een virtueel Azure-netwerk en voegt standaardsysteemroutes toe aan deze tabel. U kunt aangepaste routetabellen toevoegen om het verkeer tussen virtuele netwerken te wijzigen.

*<https://docs.microsoft.com/nl-nl/learn/modules/azure-networking-fundamentals/azure-virtual-network-settings>*

## **Azure VPN Gateway**

- On-premises datacentrums verbinden met virtuele netwerken via een site-naar-site-verbinding.
- Individuele apparaten verbinden met virtuele netwerken via een punt-naar-site-verbinding.
- Virtuele netwerken met elkaar verbinden via een netwerk-naar-netwerk-verbinding.

![IMG](https://docs.microsoft.com/nl-nl/learn/azure-fundamentals/azure-networking-fundamentals/media/vpngateway-site-to-site-connection-diagram-0e1e7db2.png)

Maximaal 1 VPN gateway per virtueel netwerk. Ondersteunt meerdere verbindingen.
Type: policy or route-based

- Op beleid gebaseerde VPN's

    Bij op beleid gebaseerde VPN-gateways wordt voor elke tunnel een statisch IP-adres opgegeven voor pakketten die moeten worden versleuteld. Dit type VPN evalueert elk gegevenspakket op basis van die IP-adressen om de tunnel te kiezen waarmee het pakket wordt verzonden.

    - Alleen ondersteuning voor IKEv1.
    - Gebruik van statische routering, waarbij combinaties van adresvoorvoegsels van beide netwerken bepalen hoe verkeer wordt versleuteld en ontsleuteld via de VPN-tunnel. De bron en het doel van de netwerken die met een tunnel zijn verbonden, zijn gedefinieerd in het beleid en hoeven niet te worden gedeclareerd in routeringstabellen.
    - Op beleid gebaseerde VPN-verbindingen moeten worden gebruikt in specifieke scenario's waarvoor ze zijn vereist, zoals voor compatibiliteit met oudere on-premises VPN-apparaten.

- Op route gebaseerde VPN's

    Met op route gebaseerde gateways worden IPSec-tunnels gemodelleerd als netwerkinterface of virtuele tunnelinterface. Met IP-routering (statische of dynamische routeringsprotocollen) wordt bepaald welke van deze tunnelinterfaces wordt gebruikt wanneer een pakket moet worden verzonden. Op route gebaseerde VPN-verbindingen zijn de voorkeursmethode voor het maken van verbinding met on-premises apparaten. Ze zijn toleranter voor topologiewijzigingen, zoals het maken van nieuwe subnetten.

    Gebruik een op route gebaseerde VPN-gateway als u een van de volgende typen connectiviteit nodig hebt:

    - Verbindingen tussen virtuele netwerken
    - Punt-naar-site-verbindingen
    - Multi-site-verbindingen
    - Co-existentie met een Azure ExpressRoute-gateway


    De belangrijkste kenmerken van op route gebaseerde VPN-gateways in Azure zijn:

    - Biedt ondersteuning voor IKEv2
    - Maakt gebruik van any-to-any-verkeerselectors (jokertekens)
    - Kan dynamische routeringsprotocollen gebruiken, waarbij routerings-/doorstovertabellen verkeer naar verschillende IPSec-tunnels leiden In dit geval worden de bron- en doelnetwerken niet statisch gedefinieerd omdat ze zich in op beleid gebaseerde VPN's of zelfs in op route gebaseerde VPN's met statische routering. In plaats daarvan worden gegevenspakketten versleuteld op basis van netwerkrouteringstabellen die dynamisch worden gemaakt met behulp van routeringsprotocollen, zoals BGP (Border Gateway Protocol).

    ![IMG](https://docs.microsoft.com/en-us/learn/azure-fundamentals/azure-networking-fundamentals/media/resource-requirements-for-vpn-gateway-2518703e.png)

*<https://docs.microsoft.com/en-us/learn/modules/azure-networking-fundamentals/azure-vpn-gateway-fundamentals>*

## **Azure ExpressRoute**

Met ExpressRoute kunt u uw on-premises netwerken in de Microsoft Cloud uitbreiden via een persoonlijke verbinding met de hulp van een connectiviteitsprovider. Met ExpressRoute kunt u verbindingen tot stand brengen met Microsoft-cloudservices, zoals Microsoft Azure en Microsoft 365. Via een connectiviteitsprovider in een colocatiefaciliteit is connectiviteit mogelijk vanuit een any-to-any (IP VPN) netwerk, een point-to-point Ethernet-netwerk of een virtuele overlappende verbinding. ExpressRoute-verbindingen gaan niet via het openbare internet. Daardoor zijn ExpressRoute-verbindingen betrouwbaarder en sneller, en hebben ze consistente wachttijden en betere beveiliging dan gewone verbindingen via internet.

![IMG](https://docs.microsoft.com/nl-nl/learn/azure-fundamentals/azure-networking-fundamentals/media/azure-expressroute-overview-5520731d.png)

Er zijn verschillende voordelen van het gebruik van ExpressRoute als verbindingsservice tussen Azure en on-premises netwerken.

- Laag-3-connectiviteit tussen uw on-premises netwerk en de Microsoft Cloud via een connectiviteitsprovider. Connectiviteit is mogelijk van een any-to-any (IPVPN) netwerk, een point-to-point Ethernet-verbinding of langs een virtuele overlappende verbinding via een Ethernet-exchange.
- Connectiviteit met Microsoft Cloud-services tussen alle gebieden in de geopolitieke regio.
- Globale connectiviteit met Microsoft-services tussen alle regio's met de ExpressRoute Premium-invoegtoepassing.
- Dynamische routering tussen uw netwerk en Microsoft via BGP.
- Ingebouwde redundantie op elke peeringlocatie voor hogere betrouwbaarheid.
- SLA voor verbindingsbedrijfstijd.
- QoS-ondersteuning voor Skype voor Bedrijven.