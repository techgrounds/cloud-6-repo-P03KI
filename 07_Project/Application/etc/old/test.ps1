# #Login-AzAccount

# # Import parameters from common JSON for reuse
# # This file cannot have comments in it!
# param([string]$paramFile = '.\params.json')
# # For each object in the JSON, create a powershell variable
# $params = Get-Content $paramFile | ConvertFrom-Json
# $params.PSObject.Properties | ForEach-Object {
#     New-Variable -Name $_.Name -Value $_.Value -Force
# }
# #$_.clientVar[$_.client]
# #$params.psobject.properties["clientVar"].value
# #$params.($_.iVar)
# $test = $params.psobject.iVar.pwd 
# $test

#$hash['location']
# $json = (Get-Content "params.json" -Raw) | ConvertFrom-Json

# #Write-Output $params.iVar[1]
# #$tempP = Get-Content -Raw -Path params.json | ConvertFrom-Json
# #$tempP.parameters[] 
$json = Get-Content -Path ./params.json | ConvertFrom-Json
$obj = $json.parameters.iVar.value
Write-Host $obj.objId


 #New-AzResourceGroup -Name "myResourceGroup" -Location "EastUS"
# #New-AzKeyVault -Name "<your-unique-keyvault-name>" -ResourceGroupName "myResourceGroup" -Location "East US"#

# Install-Module 'Az.Network' # required for first use
# Import-Module 'Az.Network'
# $appGw = Get-AzApplicationGateway -ResourceGroupName 'a4' -Name 'appGateway'
# $cert = Get-AzApplicationGatewaySslCertificate -Name 'SSLcert' -ApplicationGateway $appGw
# $cert # see below for info on what this showed