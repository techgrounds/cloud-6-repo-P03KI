New-AzSubscriptionDeployment 
-TemplateFile ./07_Project/Application/main.bicep 
-TemplateParameterFile ./07_Project/Application/params.json 
-Location westeurope            
-Name xyz         
