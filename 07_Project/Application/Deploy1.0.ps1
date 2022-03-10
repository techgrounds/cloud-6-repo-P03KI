#$JSONfromFile = Get-Content -Raw -Path params.json | ConvertFrom-Json
$output = az ad signed-in-user show --query objectId
$arrayParam = @{objId = $(ConvertFrom-Json $output);pwd = .\etc/New-Password -Length 25}
#$arrayParam
# Write-Output $output  d57cde6f-e234-4478-8cb2-6c79e523e416
# $temp = "" | Select parameters
# $temp2 = "" | Select objId
# $temp2.objectId = $output
# $temp.parameters = $temp2
# $temp 
# $JSONfromFile += $temp
# $JSONfromFile
# $JSONfromFile | ConvertTo-Json | Out-File params.json


New-AzSubscriptionDeployment -TemplateFile ./main1.1.bicep -TemplateParameterFile ./params.json -iVar $arrayParam -Location westeurope -Name xyz-deploy