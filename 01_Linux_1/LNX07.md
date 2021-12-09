# Processes

Installeren, aanzetten en stopzetten van een SSH server voor remote connections.

## Key-terms

- Processes

Alles wat op een Linux-systeem gebeurt, is in de vorm van een proces; een taak die door het besturingssysteem gestart wordt en processorcapaciteit claimt.

Er kunnen in principe 2 soorten processen actief zijn:

   1. De processen die door de computer tijdens het opstarten geactiveerd worden zoals init, syslogd, etc. Deze automatisch bij het opstarten geactiveerde processen noemen we deamons.
   2. De tweede soort zijn de interactieve processen die door de gebruikers opgestart worden door een commando in te typen. Elk commando veroorzaakt een proces, het is de enige manier om systeembronnen van de kernel te vragen.

Alle processen hebben een Proces-ID waarmee het bij de kernel bekend is. Ook om procesbeheer, zoals het uitschakelen, uit te voeren moet gebruik gemaakt worden van dit PID. Dit nummer wordt toegekend in de volgorde van opstarten.
PID 1 is altijd het proces 'init', de moeder van alle processen, elk ander proces komt namelijk voort uit 'init'.
Voor een overzicht van alle active processen is het commando:

    $ ps aux 

of voor een continue update

    $ top

Processen zijn altijd uitvoerbare bestanden, die in het geheugen geladen worden en daar instructies doorgeven naar de processor. Uitvoerbare bestanden hebben een “x” in minstens één van de groepen “user”, “group” of “other”.

- SSH

Secure Shell (kortweg: SSH) is een protocol uit de toepassingslaag van de TCP/IP-protocolgroep. De term ssh werd gemakshalve ook gebruikt voor het clientprogramma dat het protocol toepast (het serverprogramma heet sshd, 'Secure Shell daemon'). SSH vervangt oudere protocollen zoals telnet, rlogin, en rsh/rexec door een beveiligbare variant daarvan. De standaard poort van SSH is 22.

SSH maakt het mogelijk om op een versleutelde manier in te loggen op een andere computer, en op afstand commando's op de andere computer uit te voeren via een shell. Omdat ssh met encryptie werkt, is het voor eventuele afluisteraars, die de (internet)verbinding aftappen, zo goed als onmogelijk om wachtwoorden of commando's te achterhalen.

Een groot voordeel van SSH is dat ook authenticatie met een publiek/geheim sleutelpaar (public/private key) mogelijk is. Hierdoor is het mogelijk om SSH-toepassingen geautomatiseerd te gebruiken zonder dat er een wachtwoord in de code hoeft te staan. Ook kan op elk systeem dat de publieke sleutel kent, aangemeld worden door het gebruik van de geheime sleutel. Als de eigenaar van de geheime sleutel het wachtwoord van die sleutel wijzigt, heeft dit geen gevolgen voor het sleutelpaar.

SSH heeft ook de mogelijkheid om een X11-verbinding en TCP/IP-poorten door te sturen (forwarding). Het doorsturen van X11 maakt het mogelijk om veilig met een grafisch programma te werken dat op een andere computer draait dan waar de gebruiker achter zit.

SSH kan ook voor beveiligde bestandsoverdracht gebruikt worden, door middel van de programma's SCP (Secure Copy, vervanger van het oudere rcp, remote copy) en sftp (secure file transfer protocol, vervanger van FTP).

Commando:

    sudo apt-get install openssh-server

    sudo systemctl start ssh
    sudo systemctl stop ssh
    sudo systemctl status ssh

## Opdracht

- Start the ssh daemon.

![screenshot Desktop](../00_includes/LNX/LNX07_1.png)

- Find out the PID of the ssh daemon.
- Find out how much memory the sshd is using.

![screenshot Desktop](../00_includes/LNX/LNX07_2.png)

- Stop or kill the sshd process.

![screenshot Desktop](../00_includes/LNX/LNX07_3.png)

### Gebruikte bronnen

<https://nl.wikibooks.org/wiki/Ubuntu:_Linux_voor_mensen/Processen/Wat_is_een_proces%3F>

<https://nl.wikipedia.org/wiki/Secure_Shell>

<https://en.wikipedia.org/wiki/Process_identifier>

<https://www.digitalocean.com/community/tutorials/how-to-use-ps-kill-and-nice-to-manage-processes-in-linux>

<https://www.cyberciti.biz/faq/howto-start-stop-ssh-server/>

<https://askubuntu.com/questions/1161579/ssh-server-cannot-be-found-even-though-installed>

<https://askubuntu.com/questions/961025/how-do-i-exit-the-systemctl-status-commands-output>

### Ervaren problemen

SSH status report bleef continue updaten zodat ik geen prompt meer kreeg. CTRL-Q en CTRL-X geen effect. Opgezocht hoe dit te stoppen. Antwoord "q".

### Resultaat

Zie screenshots bij Opdracht.
