# Handleiding

Voor het uitvoeren van het script dient u gebruik te maken van Powershell

[Install URL](https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-windows?view=powershell-7.2#msi)

## Bicep extensie

### Controleer of bicep al is geinstalleerd op de lokale client
    
    bicep 
    --version

### Installeer bicep in Powershell

Set policy

    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

Install bicep    

    Install-Module 
    -Name Az 
    -Scope CurrentUser 
    -Repository PSGallery 
    -Force
## Azure CLI

[Install URL](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)

### Installeer Project v1.0

Indien er een eigen SSH-sleutel voorhanden is, kan deze direct mee worden geinstalleerd met de deployment. 
In de ./etc folder staat SSHKey.pub welke te wijzigen is in een SSH sleutel naar keuze. 
**NB. Behoud wel dezelfde naamgeving!**

Ook staat in deze folder apache_install.sh. 
Het is mogelijk deze te wijzigen voor een uitgebreidere installatie voor de webserver.

Params.json is te wijzigen naar eigen inzicht.
- Wijzig 'pwdWin' voor het Windows wachtwoord
- Wijzig 'privIp' voor het IP van de Admin Server's trusted location
- Wijzig 'user' naar de gebruikers identiteit voor Windows
- Wijzig ook 'objId' naar het objectId van de account waarmee de deployment plaats vindt. Dit is vanwege huidige accountbeperkingen niet te automatiseren gezien dit via AAD verloopt.

**Deploy het netwerk door 'DeployV1.ps1' uit te voeren**

    DeployV1.ps1
    New-AzSubscriptionDeployment 
    -TemplateFile ./07_Project/Application/main.bicep 
    -TemplateParameterFile ./07_Project/Application/params.json 
    -Location westeurope                  <------- Locatie van deployment
    -Name {YOUR DEPLOYMENT NAME}          <------- Kies hier een herkenbare naam voor de uitvoering

Middels RDP/SSH is het mogelijk in te loggen in de Windows VM.
Hier kan met het wachtwoord zoals in param.json is ingevuld worden ingelogd.

In de Windows omgeving mogelijk een CLI naar keuze te installeren/openen en via deze CLI in te loggen op de webserver via SSH/RDP


## Extra PowerShell commando's

Maak een connectie met Azure

    Connect-AzAccount

Verkrijg het abonnementsID:

    Get-AzSubscription

Stel een standaardabonnement in:

    $context = Get-AzSubscription -SubscriptionName {YOUR SUBSCRIPTION}
    Set-AzContext $context

Wijzigen actieve abonnement:

    $context = Get-AzSubscription -SubscriptionId {YOUR SUBSCRIPTION}
    Set-AzContext $context

Wijzig standaard Resource Group:

    Set-AzDefault 
    -ResourceGroupName {YOUR RESOURCEGROUP}

Importeren sjabloon

    New-AzResourceGroupDeployment 
    -TemplateFile ******.bicep

Controle deployment:

    Get-AzResourceGroupDeployment -ResourceGroupName {YOUR RESOURCEGROUP} | Format-Table

Opzetten Subscriptie

    New-AzSubscriptionDeployment 
        -Name {INSERT}
        -Location {INSERT}
        -TemplateFile {INSERT}
        -rgName {INSERT}
        -rgLocation {INSERT}

## VM SKU

Met de volgende commando's is het mogelijk om de verschillende versies van Azure-ondersteunende besturingssystemen te zien

Lijst van uitgevers:

    $locName="<location>"
    Get-AzVMImagePublisher 
    -Location $locName

Lijst van offers van uitgever

    $pubName="<publisher>"
    Get-AzVMImageOffer 
    -Location $locName 
    -PublisherName $pubName

Lijst van ondersteunde SKU van offer 

    $offerName="<offer>"
    Get-AzVMImageSku 
    -Location $locName 
    -PublisherName $pubName 
    -Offer $offerName 

Lijst van versies van SKU van offer

    $skuName="<SKU>"
    Get-AzVMImage 
    -Location $locName 
    -PublisherName $pubName 
    -Offer $offerName 
    -Sku $skuName 


