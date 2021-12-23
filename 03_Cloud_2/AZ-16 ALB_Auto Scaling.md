# **Azure Load Balancer (ALB) & Auto Scaling**

Een van de grootste voordelen van de cloud is dat je niet hoeft te gokken hoeveel capaciteit je nodig hebt. Je kan altijd up en down schalen met on-demand services. Een van de services die dit mogelijk maakt heet Auto Scaling.

Wanneer je applicaties runt met een spiky workload, kan je een VM Scale Set aanmaken in plaats van een enkele server. Wanneer de vraag naar de applicatie hoog is, kan Auto Scaling automatisch VMs toevoegen aan je Scale Set. Wanneer de vraag omlaag gaat, kan het ook weer instances verwijderen.

Om er zeker van te zijn dat alle VMs hetzelfde zijn, moet je een image aanwijzen tijdens het configureren van een VM Scale Set. Je kan deze image later aanpassen met de reimage optie. Auto Scaling maakt gebruik van Azure Monitor om te bepalen of er VMs toegevoegd of verwijderd moeten worden.

In een traditionele architectuur maakt een client verbinding met een enkele server met een enkel publiek IP-adres. Wanneer je een fleet van servers hebt, werkt dit niet meer. Daarom kan je een load balancer gebruiken als endpoint voor de client. De load balancer zal de request forwarden naar een van de servers in je fleet en het antwoord terugsturen naar de client.


## **Key-terms**



## **Opdracht**

**Opdracht 1:**

- Maak een Virtual Machine Scale Set met de volgende vereisten:

        Ubuntu Server 20.04 LTS - Gen1
        Size: Standard_B1ls
        Allowed inbound ports:
        SSH (22)
        HTTP (80)
        OS Disk type: Standard SSD
        Networking: defaults
        Boot diagnostics zijn niet nodig

        Custom data: 
            #!/bin/bash
            sudo su
            apt update
            apt install apache2 -y
            ufw allow 'Apache'
            systemctl enable apache2
            systemctl restart apache2
        Initial Instance Count: 2
        Scaling Policy: Custom
        Aantal VMs: minimaal 1 en maximaal 4
        Voeg een VM toe bij 75% CPU gebruik
        Verwijder een VM bij 30% CPU gebruik

![image](../00_includes/AZ2/AZ16_01.png)        

**Opdracht 2:**

- Controleer of je via het endpoint van je load balancer bij de webserver kan komen.

![image](../00_includes/AZ2/AZ16_03.png) 

- Voer een load test uit op je server(s) om auto scaling the activeren. Er kan een delay zitten in het creëren van nieuwe VMs, afhankelijk van de settings in je VM Scale Set.

![image](../00_includes/AZ2/AZ16_05.png) 
![image](../00_includes/AZ2/AZ16_09.png) 

![image](../00_includes/AZ2/AZ16_08.png) 
![image](../00_includes/AZ2/AZ16_07.png) 
![image](../00_includes/AZ2/AZ16_06.png) 
![image](../00_includes/AZ2/AZ16_10.png)

### **Gebruikte bronnen**

*<https://wiki.ubuntu.com/Kernel/Reference/stress-ng>*

*<https://www.cyberciti.biz/faq/stress-test-linux-unix-server-with-stress-ng/>*

*<>*
### **Ervaren problemen**

*Geen*

### **Resultaat**

