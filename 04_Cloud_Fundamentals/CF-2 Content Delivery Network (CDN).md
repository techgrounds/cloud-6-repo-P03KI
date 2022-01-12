# **Content Delivery Network**

Een CDN is een gedistribueerd netwerk van servers dat efficient webinhoud levert aan gebruikers.
In CDN's wordt de inhoud in het cache van randservers opgeslagen in POP (Point of Presence) locaties welke zo dicht mogelijk gelokaliseerd zijn bij de eindgebruiker voor lage latency.

CDN is een globale oplossing met een hoge bandbreedte voor snelheid op strategische, fysieke nodes.
Ook kan Azure CDN dynamische inhoud versnellen welke niet in cache staan met netwerkoptimalisaties met POP's.

**Voordelen**:

- Betere prestaties en een verbeterde gebruikerservaring voor eindgebruikers, met name bij het gebruik van toepassingen waarin meerdere round-trips nodig zijn om inhoud te laden.
- Grote schaalbaarheid, zodat korte hoge belastingen beter kunnen worden verwerkt, bijvoorbeeld bij de release van een nieuw product.
- Distribueren van gebruikersaanvragen en uitvoeren van inhoud vanaf randservers, zodat er minder verkeer naar de oorspronkelijke server wordt verzonden.

![IMG](https://docs.microsoft.com/en-us/azure/cdn/media/cdn-overview/cdn-overview.png)

**Beperkingen**

Elk Azure-abonnement kent standaardlimieten voor de volgende resources:

- Het aantal CDN-profielen dat kan worden gemaakt.
- Het aantal eindpunten dat kan worden gemaakt in een CDN-profiel.
- Het aantal aangepaste domeinen dat kan worden toegewezen aan een eindpunt.

<br>

## **Key-terms**

**CDN** - Content Delivery Network
**POP-locatie** - Point of Presence locatie

## **Opdracht**

- Bestudeer Azure Content Delivery Network

### **Gebruikte bronnen**

*<https://azure.microsoft.com/nl-nl/services/cdn/#overview>*
*<https://docs.microsoft.com/nl-nl/azure/cdn/cdn-overview>*
*<https://techcommunity.microsoft.com/t5/azure-developer-community-blog/azure-on-the-cheap-azure-front-door-caching-vs-azure-cdn/ba-p/1372262>*

### **Ervaren problemen**

*Geen*

### **Resultaat**

*Waar is CDN voor?*

    Om webinhoud efficient bij gebruikers te krijgen middels cache via POP randservers.

*Hoe vervangt CDN in een klassieke setting?*

    Bron-server wordt niet elke keer aangesproken. Randservers in POP locaties nemen de benodigde bestanden over en leveren deze aan de gebruiker. 

*Hoe kan ik CDN combineren met andere diensten?*

CDN werkt met bijv. Azure-web-app, Azure Cloud-service, Azure Storage-account of een openbaar toegankelijke webserver. Deze worden ontlast door CDN.

*Wat is het verschil tussen CDN en andere gelijksoortige diensten?*

Azure Front Door kan bijv. ook worden ingezet als CDN. AFD heeft verder nog meerdere functies en wordt ook duurder dan ACDN wanneer dezelfde features worden ingeschakeld. ACDN is over het algemeen ook makkelijker in te stellen.