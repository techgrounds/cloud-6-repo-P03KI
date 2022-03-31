# Handleiding Techgrounds/Sentia Project 1.1
### Author: Suheri Koes 
### Date: 24/03/2022

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

### Installeer Project v1.1

Indien er een eigen SSH-sleutel voorhanden is, kan deze direct mee worden geinstalleerd met de deployment. 
In de ./etc folder staat SSHKey.pub welke te wijzigen is in een SSH sleutel naar keuze. 
Indien er SSL certificaten geinstalleerd dienen te worden, kunnen deze in dezelfde /etc map worden geplaatst. 
**NB. Behoud wel dezelfde naamgeving of wijzig de benamingen in de deploy.ps1!**

Indien er geen SSL certificaat wordt toegevoegd, wordt er automatisch een dummy-sleutel gegeneerd. Deze kan later via de keyvault worden ge-update. 
Ook wordt er dan gevraagd om het wachtwoord behorende bij het certificaat. Dit is te wijzigen in de ps1. Indien het SSL-certificaat al bestaat, vraagt de Powershell om het huidige wachtwoord. Indien het wachtwoord is vergeten verwijder de DUMMY certificaten en laat de Powershell nieuwe certificaten maken met een nieuw gekozen wachtwoord.

Ook staat in deze folder apache_install.sh. 
Het is mogelijk deze te wijzigen voor een uitgebreidere installatie voor de webserver.

Params.json is te wijzigen naar eigen inzicht.

- Wijzig 'privIp' voor het IP van de Admin Server's trusted location (momenteel ingesteld op 'internet')

De IaC is agnostisch opgebouwd, wat betekent dat de deployment van elke locatie moet kunnen worden uitgevoerd. Dit betekent wel dat de website-bestanden vanaf een externe URI moeten worden ingelezen. 
Wanneer de deployment geisoleerd dient te worden, is het mogelijk de paramter 'clientvar. deploy' inde json te wijzigen van 'dev' naar 'prd'.
Voor de goede orde kunt u dan ook de tag is de json respectievelijk aanpassen.

**Deploy het netwerk door 'DeployV1.ps1' uit te voeren**

Het wachtwoord voor de Windows Admin-server wordt automatisch gegenereerd en direct in de Azure KeyVault geplaatst. Na de deployment wordt het wachtwoord in de powershell weergegeven. In de /etc map staat een script om de sleutel middels de Powershell op te halen wanneer het wachtwoord kwijt is. Ook is het wachtwoord middels de portal op te halen in de KeyVault.


Middels RDP/SSH is het mogelijk in te loggen in de Windows VM.
Hier kan met het gegenereerde wachtwoord worden ingelogt. 

In de Windows omgeving mogelijk een CLI naar keuze te installeren/openen en via deze CLI in te loggen op de webserver via SSH/RDP.


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


