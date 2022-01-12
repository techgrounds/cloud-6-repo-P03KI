# **CosmosDB**



## **Key-terms**




## **Opdracht**

- Bestudeer CosmosDB

### **Gebruikte bronnen**

*<https://docs.microsoft.com/en-us/azure/cosmos-db/>*
*<https://docs.microsoft.com/en-us/azure/cosmos-db/introduction>*



### **Ervaren problemen**

*Geen*

### **Resultaat**

*Waar is Azure Files voor?*

    Hosting-service voor DNS-domeinen geintegreerd in de Azure-omgeving.

*Hoe vervangt Azure Files in een klassieke setting?*

    Gebaseert op Azure resource Manager, dus functies als Azure RBAC, activity-logs en resource-locks wat niet mogelijk zou zijn met een extern DNS.

*Hoe kan ik Azure Files combineren met andere diensten?*

    Door de integratie werkt het goed samen met andere Azure-diensten zoals bijv. Azure RBAC voor specifieke toegang. Zelfde contract en factuur. Azure DNS kan ook DNS leveren voor externe bronnen.

*Wat is het verschil tussen Azure Files en andere gelijksoortige diensten?*

    Facturering is gebaseerd op het aantal DNS-zones dat wordt gehost en het aantal DNS-query's.
    Ook mogelijk persoonlijk DNS domein aan te maken.(Aangepaste domeinnamen in persoonlijk virtueel netwerk) Via aliasrecordsets mogelijk te verwijzen naar een openbaar ip van een Azure resource. Wanneer het IP wijzigt, wordt de aliasrecordset automatisch bijgewerkt. 

*Waar kan ik deze dienst vinden in de console?*


*Hoe zet ik deze dienst aan?*


*Hoe kan ik deze dienst koppelen aan andere resources?*
