# Eisen

## Team
- Als team willen wij duidelijk hebben wat de eisen zijn van de applicaties

    - Alle VM disks moeten encrypted zijn.
    - De webserver moet dagelijks gebackupt worden. De backups moeten 7 dagen behouden worden.
    - De webserver moet op een geautomatiseerde manier geïnstalleerd worden.
    - De admin/management server moet bereikbaar zijn met een publiek IP.
    - De admin/management server moet alleen bereikbaar zijn van vertrouwde locaties (office/admin’s thuis)
    - De volgende IP ranges worden gebruikt: 10.10.10.0/24 & 10.20.20.0/24
    - Alle subnets moeten beschermd worden door een firewall op subnet niveau.
    - SSH of RDP verbindingen met de webserver mogen alleen tot stand komen vanuit de admin server.

- Als team willen wij een duidelijk overzicht van de aannames die wij gemaakt hebben.

- Als team willen wij een duidelijk overzicht hebben van de Cloud Infrastructuur die de applicatie nodig heeft

## Klant
- Als klant wil ik een werkende applicatie hebben waarmee ik een veilige netwerk kan deployen
- Als klant wil ik een werkende applicatie hebben waarmee ik een werkende webserver kan deployen
- Als klant wil ik een werkende applicatie hebben waarmee ik een werkende management server kan deployen
- Als klant wil ik een opslagoplossing hebben waarin bootstrap/post-deployment script opgeslagen kunnen worden
- Als klant wil ik dat al mijn data in de infrastructuur is versleuteld
- Als klant wil ik iedere dag een backup hebben dat 7 dagen behouden wordt
- Als klant wil ik weten hoe ik de applicatie kan gebruiken
- Als klant wil ik een MVP kunnen deployen om te testen

# Oplevering

- Een werkende CDK / Bicep app van het MVP
- Ontwerp Documentatie
- Beslissing Documentatie
- Tijd logs
- Eindpresentatie

## Data

Belangrijke data:

|  Onderwerp:  | Datum (projectweek):  |
| --- | --- |
|Start Python, Start Project (v1.0)|07-02-2022 (wk 1)|
|Introductie Project v1.1|14-03-2022 (wk 5)|
|Oplevering- / Eindpresentatie|08-04-2022 (wk 9)|

Hou rekening met de volgende projectactiviteiten:

|Project Activiteit:|Datum (projectweek) :|
| --- | --- |
|Sprint 1 Review progressie app v1.0|25-02-2022 (wk 3)|
|Sprint 2 Review oplevering app v1.0|11-03-2022 (wk 5)|
|Sprint 3 Review progressie app v1.1|25-03-2022 (wk 7)|
|Sprint 4 Review oplevering app v1.1 / Eindpresentatie|08-04-2022 (wk 9)|

## Resources:

- Voor het ontwerpen van je architectuur: [Draw.io](https://draw.io) || [Visual Paradigm](https://online.visual-paradigm.com/diagrams/templates/azure-architecture-diagram/)

- Azure Bicep documentatie: [link](https://docs.microsoft.com/nl-nl/azure/azure-resource-manager/bicep/)

- Azure ARM template documentatie: [link](https://docs.microsoft.com/nl-nl/azure/azure-resource-manager/templates/)

- Azure ARM resource omschrijvingen: [link](https://docs.microsoft.com/en-us/azure/templates/)

- Chocolatey: [link](https://chocolatey.org/install)

- FizzBuzz: [link](https://github.com/EnterpriseQualityCoding/FizzBuzzEnterpriseEdition)

![image](../00_includes/PRJ/Azure.png)