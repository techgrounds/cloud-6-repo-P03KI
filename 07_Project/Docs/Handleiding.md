# Handleiding

Voor het uitvoeren van het script dient u gebruik te maken van Powershell

[Install URL](https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-windows?view=powershell-7.2#msi)

## Bicep extensie

### Controleer of bicep al is geinstalleerd op de lokale client
    
    bicep --version

### Installeer bicep in Powershell
Set policy

    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

Install bicep    

    Install-Module -Name Az -Scope CurrentUser -Repository PSGallery -Force

## Aanmelden

Maak een connectie en selecteer juiste subscriptie:

    Connect-AzAccount

Stel het standaardabonnement in:

    $context = Get-AzSubscription -SubscriptionName 'Concierge Subscription'
    Set-AzContext $context

Verkrijg het abonnementsID:

    Get-AzSubscription

Wijzigen actieve abonnement:

    $context = Get-AzSubscription -SubscriptionId {Your subscription ID}
    Set-AzContext $context

Standaard RG:

    Set-AzDefault -ResourceGroupName learn-923b2203-94f5-4d20-9789-3e4990c034a0

Importeren sjabloon

    New-AzResourceGroupDeployment -TemplateFile main.bicep

Controle deployment:

    Get-AzResourceGroupDeployment -ResourceGroupName learn-923b2203-94f5-4d20-9789-3e4990c034a0 | Format-Table

Opzetten Subscriptie

    New-AzSubscriptionDeployment `
        -Name demoSubDeployment `
        -Location centralus `
        -TemplateFile main.bicep `
        -rgName demoResourceGroup `
        -rgLocation centralus

Deployment
        New-AzResourceGroupDeployment -Name $deploymentName -ResourceGroupName $$SUH_RG -TemplateFile .\main.bicep -TemplateParameterFile .\main.parameters.json -c

        New-AzSubscriptionDeployment -TemplateFile main.bicep -TemplateParameterFile main.parameters.json -SkipTemplateParameterPrompt

        New-AzResourceGroup -Name <resource-group-name> -Location <resource-group-location> 
        #use this command when you need to create a new resource group for your deployment

        New-AzResourceGroupDeployment -ResourceGroupName <resource-group-name> -TemplateUri https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/quickstarts/microsoft.network/existing-vnet-to-vnet-peering/azuredeploy.json

**Welke versie windows? Kosten licentie**
https://docs.microsoft.com/nl-nl/azure/virtual-machines/windows/cli-ps-findimage
// $locName="westeurope"
// Get-AzVMImagePublisher -Location $locName 
// $pubName="MicrosoftWindowsDesktop"
// Get-AzVMImageOffer -Location $locName -PublisherName $pubName  
// $offerName="windows-11"
// Get-AzVMImageSku -Location $locName -PublisherName $pubName -Offer $offerName
// $skuName="win11-21h2-pron"
// Get-AzVMImage -Location $locName -PublisherName $pubName -Offer $offerName -Sku $skuName | Select Version

<!-- Install-Module Posh-SSH
New-SSHSession 
Invoke-SSHCommand -Index 0 -Command "uname" -->