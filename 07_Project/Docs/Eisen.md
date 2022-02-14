# Eisen

## Team

- Als team willen wij duidelijk hebben wat de **eisen** zijn van de applicatie

    - Alle VM disks moeten encrypted zijn.
    - De webserver moet dagelijks gebackupt worden. De backups moeten 7 dagen behouden worden.
    - De webserver moet op een geautomatiseerde manier geïnstalleerd worden.
    - De admin/management server moet bereikbaar zijn met een publiek IP.
    - De admin/management server moet alleen bereikbaar zijn van vertrouwde locaties (office/admin’s thuis)
    - De volgende IP ranges worden gebruikt: 10.10.10.0/24 & 10.20.20.0/24
    - Alle subnets moeten beschermd worden door een firewall op subnet niveau.
    - SSH of RDP verbindingen met de webserver mogen alleen tot stand komen vanuit de admin server.

- Als team willen wij een duidelijk overzicht van de **aannames** die wij gemaakt hebben.

    - Klant wilt een veilige applicatie waarmee een werkende web- + adminserver wordt deployed.
    - Verkeer webserver verloopt via PIP.
    - RDP/SSH webserver middels een adminserver (peering), bereikbaar via een PIP met trusted locations.
    - NSG's op subnet-niveau geconfigureerd als firewall om servers te beschermen.
    - Budget +/- €130 per maand
    - Klant gebruikt Linux en Windows (SSH/RDP)
    - 
    
- Als team willen wij een duidelijk overzicht hebben van de **Cloud Infrastructuur** die de applicatie nodig heeft

    - 2 public IP's
    - Keyvault nodig voor certificaten en keys/encryptie
    - 2 v-nets in 2 availibilty zones verbonden middels peering
    - subnet met NSG voor webserver
    - subnet met NSG voor adminserver
    - 1 vm webserver met SSH/RDP via adminserver
    - 1 vm adminserver
    - storage account voor post-deployment scripts
    - 2 firewall(NSG) subnets

## Klant
- Als klant wil ik een werkende applicatie hebben waarmee ik een veilige netwerk kan deployen
- Als klant wil ik een werkende applicatie hebben waarmee ik een werkende webserver kan deployen
- Als klant wil ik een werkende applicatie hebben waarmee ik een werkende management server kan deployen
- Als klant wil ik een opslagoplossing hebben waarin bootstrap/post-deployment script opgeslagen kunnen worden
- Als klant wil ik dat al mijn data in de infrastructuur is versleuteld
- Als klant wil ik iedere dag een backup hebben dat 7 dagen behouden wordt
- Als klant wil ik weten hoe ik de applicatie kan gebruiken
- Als klant wil ik een MVP kunnen deployen om te testen

- **Vragen voor klant:**
    - Backup -> alles?
        - Motivatie voor kosten. 
    - Webserver PIP voor extern gebruik? Schaalbaar? Hoeveelheid verkeer/Functie?
        - Simpele server. -> 1.1 wss schaalbaar.
    - Kosten/budget
        - 130
    - Active Directory users in het huidige systeem?
        - Nee. Instellen voor klant.
    - Webserver OS? Meer vereisten?
        - Windows admin. Linux evt goedkoper voor webserver.
    - Admin server exclusief voor webserver? Andere functionaliteit? Hoeveel users toegang?
        - Bastion
    - Cloudopslag alleen voor bootscripts (en backups). Users?
        - Blob
    - Tijdstip backups? 
        - Buiten kantoortijden
    - Gebruik per dienst per maand voor terugkerende kosten
        - 130
    - Regio
        - West-Euopa

    
# Oplevering

- Een werkende CDK / Bicep app van het MVP
- Ontwerp Documentatie
- Beslissing Documentatie
- Tijd logs
- Eindpresentatie

## Data

Belangrijke data:

| Onderwerp: | Datum (projectweek): |
| --- | --- |
|Start Python, Start Project (v1.0) | 07-02-2022 (wk 1)|
|Introductie Project v1.1 | 14-03-2022 (wk 5)|
|Oplevering- / Eindpresentatie | 08-04-2022 (wk 9)|

Hou rekening met de volgende projectactiviteiten:

|Project Activiteit:|Datum (projectweek) :|
| --- | --- |
|Sprint 1 Review progressie app v1.0 | 25-02-2022 (wk 3)|
|Sprint 2 Review oplevering app v1.0 | 11-03-2022 (wk 5)|
|Sprint 3 Review progressie app v1.1 | 25-03-2022 (wk 7)|
|Sprint 4 Review oplevering app v1.1 / Eindpresentatie | 08-04-2022 (wk 9)|

## Resources:

- Voor het ontwerpen van je architectuur: [Draw.io](https://draw.io) || [Visual Paradigm](https://online.visual-paradigm.com/diagrams/templates/azure-architecture-diagram/)

- Azure Bicep documentatie: [link](https://docs.microsoft.com/nl-nl/azure/azure-resource-manager/bicep/)

- Azure ARM template documentatie: [link](https://docs.microsoft.com/nl-nl/azure/azure-resource-manager/templates/)

- Azure ARM resource omschrijvingen: [link](https://docs.microsoft.com/en-us/azure/templates/)

- Chocolatey: [link](https://chocolatey.org/install)

- FizzBuzz: [link](https://github.com/EnterpriseQualityCoding/FizzBuzzEnterpriseEdition)

![image](../00_includes/PRJ/Azure.png)