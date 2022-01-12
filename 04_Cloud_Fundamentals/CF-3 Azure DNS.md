# **Azure DNS**

Azure DNS is een hosting-service voor DNS-domeinen. Door domeinen in Azure te hosten, is het mogelijk DNS-records te beheren met dezelfde referenties, API's, hulpprogramma's en facturering als andere Azure-services.

## **Key-terms**

**Domain Name System (DNS)** is het systeem en netwerkprotocol dat op het internet gebruikt wordt om namen van computers naar numerieke adressen (IP-adressen) te vertalen en omgekeerd. DNS is een client-serversysteem: een opvrager (client) gebruikt het DNS-protocol om aan een aanbieder (DNS-server) een naam of adres op te vragen, waarop de server een antwoord terugstuurt. Het opzoeken van een nummer bij een naam wordt forward lookup genoemd; het opzoeken van een naam bij een nummer reverse lookup.

## **Opdracht**

- Bestudeer Azure DNS

### **Gebruikte bronnen**

*<https://azure.microsoft.com/nl-nl/services/dns/#overview>*
*<https://docs.microsoft.com/nl-nl/azure/dns/dns-overview>*
*<https://nl.wikipedia.org/wiki/Domain_Name_System>*

### **Ervaren problemen**

*Geen*

### **Resultaat**

*Waar is Azure DNS voor?*

    Hosting-service voor DNS-domeinen geintegreerd in de Azure-omgeving.

*Hoe vervangt Azure DNS in een klassieke setting?*

    Gebaseert op Azure resource Manager, dus functies als Azure RBAC, activity-logs en resource-locks wat niet mogelijk zou zijn met een extern DNS.

*Hoe kan ik Azure DNS combineren met andere diensten?*

    Door de integratie werkt het goed samen met andere Azure-diensten zoals bijv. Azure RBAC voor specifieke toegang. Zelfde contract en factuur. Azure DNS kan ook DNS leveren voor externe bronnen.

*Wat is het verschil tussen Azure DNS en andere gelijksoortige diensten?*

    Facturering is gebaseerd op het aantal DNS-zones dat wordt gehost en het aantal DNS-query's.
    Ook mogelijk persoonlijk DNS domein aan te maken.(Aangepaste domeinnamen in persoonlijk virtueel netwerk) Via aliasrecordsets mogelijk te verwijzen naar een openbaar ip van een Azure resource. Wanneer het IP wijzigt, wordt de aliasrecordset automatisch bijgewerkt. 
