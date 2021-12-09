# Processes

Installeren, aanzetten en stopzetten van een SSH server voor remote connections.

## Key-terms

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

- PID

In computing, the process identifier (a.k.a. process ID or PID) is a number used by most operating system kernels—such as those of Unix, macOS and Windows—to uniquely identify an active process. This number may be used as a parameter in various function calls, allowing processes to be manipulated, such as adjusting the process's priority or killing it altogether.

Commando:

    pgrep [process]

## Opdracht

- Start the ssh daemon.

![screenshot Desktop](../00_includes/LNX/LNX07_1.png)

- Find out the PID of the ssh daemon.
- Find out how much memory the sshd is using.

![screenshot Desktop](../00_includes/LNX/LNX07_2.png)

- Stop or kill the sshd process.

![screenshot Desktop](../00_includes/LNX/LNX07_3.png)

### Gebruikte bronnen

<https://nl.wikipedia.org/wiki/Secure_Shell>

<https://en.wikipedia.org/wiki/Process_identifier>

<https://www.cyberciti.biz/faq/howto-start-stop-ssh-server/>

<https://askubuntu.com/questions/1161579/ssh-server-cannot-be-found-even-though-installed>

<https://askubuntu.com/questions/961025/how-do-i-exit-the-systemctl-status-commands-output>

### Ervaren problemen

SSH status report bleef continue updaten zodat ik geen prompt meer kreeg. CTRL-Q en CTRL-X geen effect. Opgezocht hoe dit te stoppen. Antwoord "q".

### Resultaat

Zie screenshots bij Opdracht.
