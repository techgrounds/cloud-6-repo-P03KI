# **Containers**

**Azure Container Instance**

Voorkeursmethode voor het verpakken, implementeren en beheren van cloudtoepassingen, waarbij het niet nodig is om virtuele machines te beheren of het serviceniveau te verhogen. PaaS. Snel en simpel.

**Azure Kubernetes Service**

Kubernetes is een snel ontwikkelend managementplatform dat containertoepassingen en de bijbehorende netwerk- en opslagonderdelen beheert. Kubernetes richt zich op de workloads van de toepassing, niet op de onderliggende infrastructuuronderdelen. Kubernetes biedt een declaratieve benadering van implementaties, met ondersteuning van een robuuste set API's voor beheerbewerkingen. Betaalt alleen voor de AKS nodes die de applicaties uitvoeren.

AKS is verdeeld in 2 componenten:

![IMG](https://docs.microsoft.com/en-us/azure/aks/media/concepts-clusters-workloads/control-plane-and-nodes.png)

- **Control plane**
    
    Core service en orchestration van applicatie workloads. Automatisch gecreeerd bij het maken van een AKS cluster. Controlplane en resources zijn alleen beschikbaar in de regio waar het aangemaakt wordt.

    - **kube-apiserver**	
    
    De API-server is de manier waarop de onderliggende Kubernetes-API's beschikbaar worden gemaakt. Dit onderdeel biedt de interactie voor beheerhulpprogramma's, zoals `kubectl` of het Kubernetes-dashboard.

    - **etcd**	
    
    Als u de status van uw Kubernetes-cluster en -configuratie wilt behouden, is de opslag met hoge beschikbare waarden in Kubernetes een sleutelwaardeopslag.

    - **kube-scheduler**	
    
    Wanneer u toepassingen maakt of schaalt, bepaalt de Scheduler op welke knooppunten de workload kan worden uitgevoerd en wordt deze gestart.

    - **kube-controller-manager**	
    
    Controller Manager houdt toezicht op een aantal kleinere controllers die acties uitvoeren, zoals het repliceren van pods en het verwerken van knooppuntbewerkingen.

- **Nodes**

    Uitvoeren van applicatie workloads

    - **kubelet**	
    
    De Kubernetes-agent die de orchestration-aanvragen verwerkt vanaf het besturingsvlak en de planning voor het uitvoeren van de aangevraagde containers.

    - **kube-proxy**	
    
    Verwerkt virtuele netwerken op elk knooppunt. De proxy routeert netwerkverkeer en beheert IP-adressering voor services en pods.

    - **container runtime**	
    
    Hiermee kunnen toepassingen in containers worden uitgevoerd en communiceren met aanvullende resources, zoals het virtuele netwerk en de opslag. AKS-clusters met Kubernetes versie 1.19+ voor Linux-knooppuntgroepen gebruiken containerd als containerruntime. Vanaf Kubernetes versie 1.20 voor Windows-knooppuntgroepen kan in preview worden gebruikt voor de containerruntime, maar Docker is nog steeds de standaard containerd containerruntime. AKS-clusters die eerdere versies van Kubernetes voor knooppuntgroepen gebruiken, gebruiken Docker als containerruntime.

![IMG](https://docs.microsoft.com/en-us/azure/aks/media/concepts-clusters-workloads/aks-node-resource-interactions.png)
    
<br>

## **Opdracht**

- Bestudeer Containers

### **Gebruikte bronnen**

*<https://docs.microsoft.com/en-us/azure/azure-monitor/containers/container-insights-overview>*

*<https://docs.microsoft.com/en-us/azure/container-instances/container-instances-overview>*

*<https://docs.microsoft.com/en-us/azure/aks/concepts-clusters-workloads>*

*<https://docs.microsoft.com/en-us/azure/aks/intro-kubernetes>*

### **Ervaren problemen**

*Geen*

### **Resultaat**

*Waar zijn Azure Containers voor?*

- Geisoleerde applicaties die snel op te starten zijn zonder VM instellingen. 

*Hoe vervangt Azure Containers in een klassieke setting?*

- Geen Host VM meer nodig om applicaties te draaien.

*Hoe kan ik Azure Containers combineren met andere diensten?*

- Kan een directe koppeling maken met Azure File Share bijv.

*Wat is het verschil tussen Azure Containers en andere gelijksoortige diensten?*

- Geisoleerde containers goed voor eenvoudige toepassingen, taakautomatisering en ontwikkeling. Wanneer er servicedetectie nodig is in meerdere containers, automatisch schalen of gecoordineerde upgrades is er AKS.