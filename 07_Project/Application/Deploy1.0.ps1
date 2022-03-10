$output = az ad signed-in-user show --query objectId
$arrayParam = @{objId = $(ConvertFrom-Json $output);pwd = .\etc/New-Password -Length 25}
New-AzSubscriptionDeployment -TemplateFile ./main1.1.bicep -TemplateParameterFile ./params.json -iVar $arrayParam -Location westeurope -Name xyz-deploy
.\getPw.ps1