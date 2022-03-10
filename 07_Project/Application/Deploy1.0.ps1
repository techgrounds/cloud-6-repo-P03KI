Write-Output "----------> Importing your ObjectId"
$output = az ad signed-in-user show --query objectId
Write-Output "----------> Generating a safe password"
$arrayParam = @{objId = $(ConvertFrom-Json $output);pwd = .\etc/New-Password -Length 25}
Write-Output "----------> Deploying your infrastructure"
New-AzSubscriptionDeployment -TemplateFile ./main1.1.bicep -TemplateParameterFile ./params.json -iVar $arrayParam -Location westeurope -Name xyz-deploy
.\getPw.ps1
Write-Output " "
Write-Output "----------> Done =)"
Write-Output "----------> Have a nice day!"