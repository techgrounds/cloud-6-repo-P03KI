# Project: Sentia 1.0
## Azure Webserver Deployment

15/02/2022

## Inhoudsopgave

- [1 Introductie]()
- [2 Azure Architecture Overview]()
- [3 Microsoft Azure Networking]()
- [4 Microsoft Azure Storage]()
- [5 Microsoft Azure Compute]()
- [6 Microsoft Azure Identity]()
- [7 Compliance & Security]()
- [8 Backup]()
- [9 Management and Maintenance]()
- [10 Appendix]()

### 1 Introductie

    Describe the scope of this document and who’s the target audience. Capture the design objectives, constraints, assumptions (if any) and appetite (or vision) for the cloud and make sure to add a quick summary as an overview.

Het project omvat het opzetten van een webserver met een adminserver in de Azure cloud omgeving. 

![img](../00_includes/PRJ/ontwerp.png)

| Onderwerp: | Datum (projectweek): |
| --- | --- |
|Start Python, Start Project (v1.0) | 07-02-2022 (wk 1)|
|Introductie Project v1.1 | 14-03-2022 (wk 5)|
|Oplevering- / Eindpresentatie | 08-04-2022 (wk 9)|

|Project Activiteit:|Datum (projectweek) :|
| --- | --- |
|Sprint 1 Review progressie app v1.0 | 25-02-2022 (wk 3)|
|Sprint 2 Review oplevering app v1.0 | 11-03-2022 (wk 5)|
|Sprint 3 Review progressie app v1.1 | 25-03-2022 (wk 7)|
|Sprint 4 Review oplevering app v1.1 / Eindpresentatie | 08-04-2022 (wk 9)|

### 2 Azure Architecture Overview

    A starting point to define which Azure Regions will be used. Also, cover topics like Subscription Model, Administrative Roles, Naming Standards, Role Based Access Control (RBAC) and Azure Resource Manager.

### 3 Microsoft Azure Networking

    Networking represents one of the most important chapters of the document. Things like Network structure, ExpressRoute, Virtual Network Address Space, Virtual Network Gateway, DNS, Network Security Groups, Forced Tunneling, … will go here. Move lists of IP’s to an external document or the appendix.

### 4 Microsoft Azure Storage

    Capture the decisions on the requirements for the workloads (e.g., path-through, IOPS), Storage Accounts, Managed Disks and Virtual Hard Disks. Encryption and Azure Files also would make an important part.

### 5 Microsoft Azure Compute

    Often we focus on Infrastructure-as-a-Service (IaaS) here, which would include information about VM Types, Instances, Availability Set, how Images will be documented and which VM Extensions can be used.

### 6 Microsoft Azure Identity

    Define how the existing on-premises identity and name services will be made available in Azure, and how this could get extended using Azure Active Directory (AAD). This doesn’t necessarily have to cover the AD or AAD design.

### 7 Compliance & Security

    Design Guidelines to ensure a secure adoption of Azure, including certifications for PCI-DSS (if required) and integration with Azure Security Center.

### 8 Backup

    Design Guidelines on Backup, ow the existing solution will be used for the cloud or how Azure Backup would be used. Ideal chapter to touch on the requirement of Disaster Recovery, cloud to cloud using Azure Site Recovery (ASR).

### 9 Management and Maintenance

    Decisions on how the newly deployed services will be integrated into the existing monitoring and patch management. Position Log Analytics, Azure Automation and other management capabilities to support these activities.

### 10 Appendix

    Move the full naming convention to the Appendix. The end of the document is also an excellent place to keep all links to the online resources.

Bronnen:
- [Document template](https://www.cloudelicious.net/how-to-write-a-design-document-for-azure/)