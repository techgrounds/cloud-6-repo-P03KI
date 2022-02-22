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