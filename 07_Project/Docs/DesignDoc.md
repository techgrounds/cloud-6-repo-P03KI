# Project: Sentia 1.0
## Azure Webserver Deployment

15/02/2022


## Inhoudsopgave

### 1 Introductie



Describe the scope of this document and who’s the target audience. Capture the design objectives, constraints, assumptions (if any) and appetite (or vision) for the cloud and make sure to add a quick summary as an overview.

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