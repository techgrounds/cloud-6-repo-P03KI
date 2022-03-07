# Project: Sentia 1.0
## XYZ: Azure Webserver Deployment

15/02/2022 - 08/04/2022

## Inhoudsopgave

- [1 Introductie](DesignDoc.md#1-introductie)
- [2 Azure Architecture Overview](DesignDoc.md#2-azure-architecture-overview)
- [3 Microsoft Azure Networking](DesignDoc.md#3-microsoft-azure-networking)
- [4 Microsoft Azure Storage](DesignDoc.md#4-microsoft-azure-storage)
- [5 Microsoft Azure Compute](DesignDoc.md#5-microsoft-azure-compute)
- [6 Microsoft Azure Identity](DesignDoc.md#6-microsoft-azure-identity)
- [7 Compliance & Security](DesignDoc.md#7-compliance--security)
- [8 Backup](DesignDoc.md#8-backup)
- [9 Management and Maintenance](DesignDoc.md#9-management-and-maintenance)
- [10 Appendix](DesignDoc.md#10-appendix)

### 1 Introductie

Dit individuele project omvat het opzetten van een webserver met een adminserver in de Azure cloud omgeving. Het doel is hier voldoende lering uit te trekken als basis voor een gedegen start bij Sentia. Het project wordt individueel gemaakt. Wanneer er bepaalde vragen of obstakels zijn, kunnen deze besproken worden in de groep. Indien er geen oplossing gevonden kan worden, kunnen mijn groep en ik terecht bij de learning coach Coen, die als stakeholder fungeert. Om deze opdracht nog iets praktischer te laten ogen en iets van narratief in te brengen, benoem ik de klant als bedrijf **XYZ**. 

XYZ wilt graag zijn webdiensten in de cloud onderbrengen. Zij hebben de volgende eisen aangeven voor hun architectuur:

- Alle VM disks moeten **encrypted** zijn.
- De webserver moet dagelijks gebackupt worden. De backups moeten 7 dagen behouden worden.
- De webserver moet op een geautomatiseerde manier geïnstalleerd worden.
- De admin/management server moet bereikbaar zijn met een publiek IP.
- De admin/management server moet alleen bereikbaar zijn van vertrouwde locaties (office/admin’s thuis)
- De volgende IP ranges worden gebruikt: **10.10.10.0/24 & 10.20.20.0/24**
- Alle subnets moeten beschermd worden door een firewall op subnet niveau.
- SSH of RDP verbindingen met de webserver mogen alleen tot stand komen vanuit de admin server.

**Deadlines:**

| Onderwerp: | Datum (projectweek): |
| --- | --- |
| Start Python, Start Project (v1.0) | 07-02-2022 (wk 1)|
| Sprint 1 Review progressie app v1.0 | 25-02-2022 (wk 3)|
| Sprint 2 Review oplevering app v1.0 | 11-03-2022 (wk 5)|
|Introductie Project v1.1 | 14-03-2022 (wk 5)|
| Sprint 3 Review progressie app v1.1 | 25-03-2022 (wk 7)|
| Oplevering- / Eindpresentatie Sprint 4 Review oplevering app v1.1 / Eindpresentatie | 08-04-2022 (wk 9)|

**Architectuur ontwerp**

Het volgende ontwerp is meegeleverd door de cloud-architect:

![img](/00_includes/PRJ/ontwerp.png)

Hieruit kan het inventaris worden opgemaakt:

    - 2 Public IP's
    - 1 Keyvault nodig voor certificaten en keys/encryptie
    - 2 V-Nets in 2 availibilty zones verbonden middels peering
    - 1 Subnet met NSG voor webserver
    - 1 Subnet met NSG voor adminserver
    - 1 VM webserver met SSH/RDP via adminserver
    - 1 VM adminserver
    - 1 Storage account voor post-deployment scripts

Ondanks enkele variabelen heb ik deze aannames gemaakt:

    - XYZ wilt een veilige applicatie waarmee een werkende web- en adminserver wordt deployed.
    - Verkeer webserver verloopt via PIP.
    - RDP/SSH webserver middels een adminserver (peering), bereikbaar via een PIP met trusted locations.
    - NSG's op subnet-niveau geconfigureerd als firewall ter beveiliging.
    - XYZ gebruikt Linux en Windows (SSH/RDP)

Tijdens de eerste meeting met XYZ is het volgende besproken:

    - Backup -> alles?
    ----- Motivatie voor (extra) kosten. 
    - Webserver PIP voor extern gebruik? Schaalbaar? Hoeveelheid verkeer/Functie?
    ----- Simpele server
    - Kosten/budget
    ----- 130
    - Active Directory users in het huidige systeem?
    ----- Nee. Instellen voor XYZ.
    - Webserver OS? Meer vereisten?
    ----- Windows admin. Linux evt goedkoper voor webserver.
    - Admin server exclusief voor webserver? Andere functionaliteit? Hoeveel users toegang?
    ----- Admin server gaat fungeren net als 'Azure Bastion' Aantal admins uit te breiden.
    - Cloudopslag alleen voor bootscripts (en backups). Users?
    ----- Blob Storage vanwege het makkelijk uit te breiden voor eventuele extra opslag.
    - Tijdstip backups? 
    ----- Buiten kantoortijden
    - Regio
    ----- West-Europa, maar de IaC (Infractructure as Code) dient agnostisch te zijn


### 2 Azure Architecture Overzicht

#### Subscription

De bicep wordt uitgevoerd op subscriptie-niveau voor de vereenvoudigde deployment. De deployment kan worden uitgevoerd op Azure account van de klant mits de juiste variabelen worden meegegeven in de 'params.json'.

#### Benaming

Volgende tags worden geimplementeerd om overzicht te houden bij meerdere deployments:

|Key|Value|
| Client | naam |
| Version | versie |
| Deploydate | datum|
| Time | tijd |

#### KeyVault

Er wordt in de deployment ook een keyvault aangemaakt. De encryptiekey wordt bij installatie automatisch gegenereerd om de data schijven te encrypten. Via portal of CLI is het mogelijk deze te vervangen voor uw eigen sleutel. De omgeving staat ingesteld dat de schijven automatisch uw sleutel gebruiken (rotational).

#### Regio

De infrastructuur wordt gedeployed in regio **West-Europa** vanwege de gunstige ligging van het bedrijf en haar klanten. De IaC wordt vanuit een agnostisch oogpunt ontworpen zodat de IaC ook deployed kan worden in eventuele andere regio's wanneer dat nodig zou zijn. Het enige wat u dient te wijzigen is de locatie in 'params.json'. 
NB. *De (compute) resources kunnen per regio verschillen.*

#### Administrative Roles

Er wordt een admin rol aan de deployment-account toegewezen. Indien er meerdere rollen nodig zijn, is het mogelijk deze toe te voegen via de portal of CLI.

### 3 Microsoft Azure Networking

#### VNET #1
- A
- Bereik: 10.10.10.0/24
- 1 subnet

#### VNET #2
- Bereik: 10.20.20.0/24
- 1 subnet


#### Peering
    Networking represents one of the most important chapters of the document. Things like Network structure, ExpressRoute, Virtual Network Address Space, Virtual Network Gateway, DNS, Network Security Groups, Forced Tunneling, … will go here. Move lists of IP’s to an external document or the appendix.

### 4 Microsoft Azure Storage

#### Encryption

#### Storage Account
xxxxxxxxxxxxxx

#### Hard Disk

    Capture the decisions on the requirements for the workloads (e.g., path-through, IOPS), Storage Accounts, Managed Disks and Virtual Hard Disks. Encryption and Azure Files also would make an important part.

### 5 Microsoft Azure Compute

#### Administratieserver 
- Opgezet in West Europa met 'Availability Zoning' in zone 1. 
- Instellingen worden extra veilig ingesteld
- Grootte VM: Standard_D2s_v3 = 1 vCPU/0,5GB geheugen ($4.38/maand)
- OS = Windows 10 Pro 

Install-Module Posh-SSH
New-SSHSession 
Invoke-SSHCommand -Index 0 -Command "uname"

#### Webserver 
- Opgezet in West Europa met 'Availability Zoning' in zone 1. 
- Instellingen worden extra veilig ingesteld
- Grootte VM: Standard_D2s_v3 = 1 vCPU/0,5GB geheugen ($4.38/maand)
- OS = Ubuntu 10


**Welke versie windows? Kosten licentie**
https://docs.microsoft.com/nl-nl/azure/virtual-machines/windows/cli-ps-findimage
// $locName="westeurope"
// Get-AzVMImagePublisher -Location $locName 
// $pubName="MicrosoftWindowsDesktop"
// Get-AzVMImageOffer -Location $locName -PublisherName $pubName  
// $offerName="windows-11"
// Get-AzVMImageSku -Location $locName -PublisherName $pubName -Offer $offerName
// $skuName="win11-21h2-pron"
// Get-AzVMImage -Location $locName -PublisherName $pubName -Offer $offerName -Sku $skuName | Select Version


    Often we focus on Infrastructure-as-a-Service (IaaS) here, which would include information about VM Types, Instances, Availability Set, how Images will be documented and which VM Extensions can be used.

### 6 Microsoft Azure Identity

#### Azure Active Directory
Admin login zal via AAD lopen naar de admin server.


    Define how the existing on-premises identity and name services will be made available in Azure, and how this could get extended using Azure Active Directory (AAD). This doesn’t necessarily have to cover the AD or AAD design.

### 7 Compliance & Security

#### Network Security Groups

#### Security Center

    Design Guidelines to ensure a secure adoption of Azure, including certifications for PCI-DSS (if required) and integration with Azure Security Center.

### 8 Backup
#### Backup
De webserver zal dagelijks een backup uitvoeren rond 01.00 CET. Retentieperiode van de backups bedraagt 7 dagen.

    Design Guidelines on Backup, ow the existing solution will be used for the cloud or how Azure Backup would be used. Ideal chapter to touch on the requirement of Disaster Recovery, cloud to cloud using Azure Site Recovery (ASR).

### 9 Management and Maintenance
#### Log Analytics
De complete architectuur wordt gekoppeld aan de Azure Log Analytics zodat monitoring van de infrastructuur centraal verloopt. 

    Decisions on how the newly deployed services will be integrated into the existing monitoring and patch management. Position Log Analytics, Azure Automation and other management capabilities to support these activities.

### 10 Appendix

Bronnen:
- [Document template](https://www.cloudelicious.net/how-to-write-a-design-document-for-azure/)
- Ontwerpen architectuur: [Draw.io](https://draw.io) || [Visual Paradigm](https://online.visual-paradigm.com/diagrams/templates/azure-architecture-diagram/)
- Azure Bicep documentatie: [link](https://docs.microsoft.com/nl-nl/azure/azure-resource-manager/bicep/)
- Azure ARM template documentatie: [link](https://docs.microsoft.com/nl-nl/azure/azure-resource-manager/templates/)
- Azure ARM resource omschrijvingen: [link](https://docs.microsoft.com/en-us/azure/templates/)
- Chocolatey: [link](https://chocolatey.org/install)
- FizzBuzz: [link](https://github.com/EnterpriseQualityCoding/FizzBuzzEnterpriseEdition)



    Move the full naming convention to the Appendix. The end of the document is also an excellent place to keep all links to the online resources.
