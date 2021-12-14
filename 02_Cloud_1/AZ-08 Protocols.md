# Protocols

Een netwerk protocol is een afspraak die wij mensen gemaakt hebben over hoe computers met elkaar communiceren. Deze afspraken maken het mogelijk dat het Internet kan bestaan, zonder dat je voor iedere verbinding een andere standaard moet aanhouden.
Het OSI-model is een goed hulpmiddel om te beschrijven waar een protocol ‘leeft’ en wat het doel is van een protocol. Vaak genoeg ‘leeft’ een protocol in meerdere lagen van het OSI-model.

Twee protocols die in laag 4 ‘leven’ is TCP en UDP. Deze protocols zijn verantwoordelijk voor het transport van internet pakketten. 
TCP, veel gebruikt op het web, heeft een aantal stappen waarin er zeker gesteld wordt dat de verbinding gemaakt kan worden en om zeker te zijn dat alle data is overgekomen. Dit is ook wel de ‘three-way handshake’ genoemd. Dit maakt TCP erg betrouwbaar.
UDP heeft een hele andere aanpak: ‘fire and forget’. UDP maakt geen zorgen over of een pakketje aankomt. Dit maakt dit protocol onbetrouwbaar, maar wel veel sneller. UDP wordt veel gebruikt in omstandigheden waar snelheid belangrijker is dan snelheid. Zoals de video data van een Zoom-call.

Protocols die ‘leven’ in hogere lagen van het OSI-model hebben meestal specifieke toepassingen. HTTP(s) of SSH zijn enkele voorbeelden van hogere level protocols.

Onderdeel van de afspraken die wij gemaakt hebben over protocols is dat deze meestal een ‘standaard poort’ hebben. Voor SSH is dit poort 22.

## Key-terms

- [OSI model met protocols](https://www.strato.nl/server/wat-is-het-osi-model/)

    Het Open Systems Interconnection Model (kortweg OSI-model) werd door de International Organization for Standardization (ISO) ontworpen als referentiemodel voor een open communicatie tussen verschillende technische systemen. Waarom wordt duidelijk als men terugdenkt aan de beginperiode van het internet: eind jaren 70 van de vorige eeuw stuitten de toonaangevende fabrikanten in de netwerktechnologie op het probleem dat door propriëtaire netwerkarchitecturen alleen apparaten van dezelfde fabrikanten met elkaar konden worden verbonden. Vrijwel geen fabrikant kwam op het idee hardware- of softwarecomponenten te ontwikkelen op basis van de specificaties van andere fabrikanten. Een project als het internet vergt echter bepaalde standaards opdat een gemeenschappelijke communicatie mogelijk wordt.

- TCP

    TCP staat voor Transmission Control Protocol en wordt het meeste gebruikt; als je bijvoorbeeld vanaf je eigen computer op een link op een webpagina klikt, stuurt je browser TCP packets over het internet naar de server die de website host, en de betreffende server stuurt TCP packets terug. Deze packets krijgen een getal toegewezen, zodat de ontvanger ze in de juiste volgorde ontvangt. TCP controleert daarnaast ook de data die verstuurd wordt, dus de server stuurt ook berichten terug naar de verzender om te bevestigen dat het je packets heeft ontvangen en dat er geen fouten in zitten. Krijgt je computer een onjuist antwoord terug? Dan worden de packets opnieuw gestuurd.

    Naast webverkeer wordt TCP bijvoorbeeld ook gebruikt voor downloaden en het (niet live) streamen van video.



- IP
    Het internetprotocol, meestal afgekort tot IP, is een netwerkprotocol waarmee computers op een computernetwerk met elkaar kunnen communiceren, zoals op het internet. Sinds 20 juli 2004 worden binnen het internet twee versies van het internetprotocol ondersteund, de versies IPv4 en IPv6. De eerste domeinen die van IPv6 gebruikmaken zijn Japan en Korea.

    IPv4 wordt in tegenstelling tot veel andere protocollen door alle computers op het internet ondersteund. Het internetprotocol is een onderdeel van een stack die nodig is voor communicatie. In combinatie met het Transmission Control Protocol (TCP) wordt wel over TCP/IP gesproken. Een ander veelgebruikt protocol dat samen met IP gebruikt kan worden is het User Datagram Protocol. Iedere afzonderlijke computer die via IP met andere computers communiceert moet een uniek adres hebben. Aanvankelijk had iedere netwerkkaart een vast adres. Wegens het gebrek aan adressen wordt nu door gebruikmaking van NAT en DHCP meestal een tijdelijk of een intern IP-adres (IP-nummer) toegewezen.

- HTTPS
    HyperText Transfer Protocol Secure, afgekort HTTPS, is een uitbreiding op het HTTP-protocol met als doel een veilige uitwisseling van gegevens. Bij gebruik van HTTPS worden de gegevens versleuteld, waardoor het voor een buitenstaander, bijvoorbeeld iemand die afluistert, onmogelijk zou moeten zijn om te weten welke gegevens verstuurd worden.

- TLS
    Transport Layer Security (TLS) en diens voorganger Secure Sockets Layer (SSL), zijn encryptie-protocollen die de communicatie tussen computers (bijvoorbeeld op het internet) beveiligen.

## Opdracht

1. Begrijp hoe een HTTPS TCP/IP-pakket opgebouwd is
2. Begrijp wie bepaalt welke protocols wij gebruiken en wat je zelf moet doen om een  nieuw protocol te introduceren.
3. Identificeer op zijn minst één protocol per OSI-laag.
Facebook was recent een lange tijd niet beschikbaar. Ontdek waarom. Tip: BGP.

### Gebruikte bronnen

<https://www.transip.nl/knowledgebase/artikel/2086-wat-is-tcp-udp/>

<https://nl.wikipedia.org/wiki/Internetprotocol>

<https://nl.wikipedia.org/wiki/HyperText_Transfer_Protocol_Secure>

<https://nl.wikipedia.org/wiki/Transport_Layer_Security>

<https://www.ietf.org/about/groups/iesg/>

<https://www.imperva.com/learn/application-security/osi-model/>

<https://www.guru99.com/layers-of-osi-model.html>

### Ervaren problemen

Geen

### Resultaat

1. Begrijp hoe een HTTPS TCP/IP-pakket opgebouwd is
    TCP staat voor Transmission Control Protocol en wordt het meeste gebruikt; als je bijvoorbeeld vanaf je eigen computer op een link op een webpagina klikt, stuurt je browser TCP packets over het internet naar de server die de website host, en de betreffende server stuurt TCP packets terug.

2. Begrijp wie bepaalt welke protocols wij gebruiken en wat je zelf moet doen om een nieuw protocol te introduceren.

    De Internet Engineering Steering Group (IESG) is verantwoordelijk voor het technisch beheer van IETF-activiteiten en het internetstandaardenproces. RFC's (Request for Comments) zijn een groep documenten die de internetprotocollen en hun vereisten definiëren.
    
3. Identificeer op zijn minst één protocol per OSI-laag.
Facebook was recent een lange tijd niet beschikbaar. Ontdek waarom. Tip: BGP.

![OSI]](https://www.imperva.com/learn/wp-content/uploads/sites/13/2020/02/OSI-7-layers.jpg.webp)

    - Laag 7 Applicatielaag
         Ontvangt informatie rechtstreeks van gebruikers en geeft binnenkomende gegevens weer aan de gebruiker.
         HTTP (Hypertext Transfer Protocol), FTP (File Transfer Protocol), POP (Post Office Protocol), SMTP (Simple Mail Transfer Protocol) en DNS (Domain Name System)

    - Laag 6 Presentatielaag
         Versleuteling en decodering van gegevens voor veilige overdracht. MPEG, ASCH, SSL, TLS

    - Laag 5 Sessielaag
         Installatie, coördinatie (hoe lang moet een systeem wachten op een reactie, bijvoorbeeld) en beëindiging tussen de applicaties aan elk einde van de sessie. NetBIOS, SAP

    - Laag 4 Transportlaag
         Transmission Control Protocol (TCP), dat bovenop het Internet Protocol (IP) is gebouwd, beter bekend als TCP/IP. TCP- en UDP-poortnummers werken bijvoorbeeld ook op Laag 4.

    - Laag 3 Netwerklaag
         Het doorsturen van pakketten, inclusief routering via verschillende routers. IPV5, IPV6, ICMP, IPSEC, ARP, MPLS

    - Laag 2 Data Link-laag
         Gegevensoverdracht van knooppunt naar knooppunt (tussen twee rechtstreeks verbonden knooppunten) en verwerkt ook foutcorrectie van de fysieke laag. Hier bestaan ook twee sublagen: de MAC-laag (Media Access Control) en de LLC-laag (Logical Link Control). RAPA, PPP, Frame Relay, ATM, Fiber Cable, etc.

    - Laag 1 Fysieke laag
         Elektrische en fysieke representatie van het systeem. RS232, 100BaseTX, ISDN, 11.
