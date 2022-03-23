Write-Host "--> AutoDeployment XYZ CloudInfra v1.1" -ForegroundColor Green
Write-Host "--> Entering the cloud" -ForegroundColor Green
#Login-AzAccount
Write-Host "--> Importing current ObjectId" -ForegroundColor Green
$output = az ad signed-in-user show --query objectId

Write-Host "--> Generating your password" -ForegroundColor Green
$genPw = .\etc/New-Password -Length 20

$SSLPath = Test-Path -Path .\etc/SSLDUMMY.pfx -PathType Leaf
if(!$SSLPath){
    Write-Host "--> Making required SSL certificates" -ForegroundColor Green
    $dir = "C:\Users\suher\OneDrive\Documents\Techgrounds\TG_REPO\07_Project\Application\etc\"
    $subj = "CN=SSLDUMMY"
    $friendlyName = "SSLDUMMY"
    $pfxFilePath = $dir, $friendlyName, ".pfx" -join ""
    $derFilePath = $dir, $friendlyName, ".der" -join ""
    $pemFilePath = $dir, $friendlyName, ".pem" -join ""
    #create new certificate in cert:\currentuser\my and store in variable $cert
    $cert = New-SelfSignedCertificate -CertStoreLocation cert:\currentuser\my -Subject $subj -KeyAlgorithm RSA -KeyLength 2048 -Provider "Microsoft Enhanced RSA and AES Cryptographic Provider" -KeyExportPolicy Exportable -FriendlyName $friendlyName -NotAfter (Get-Date).AddYears(2)
    #get password for pfx file
    $pwInput = Read-Host "Choose a password for your certificate:"
    #export cert to pfx and write to file 
    [io.file]::WriteAllBytes($pfxFilePath,$cert.Export(3, $pwInput))
    #export cert to der and write to file
    Export-Certificate -FilePath $derFilePath -Cert $cert
    $pw = ConvertTo-SecureString -String $pwInput -Force -AsPlainText
    #encode der file as pem file and write to file
    certutil -encode $derFilePath $pemFilePath | Out-Null
} elseif (!$pw) {
    Write-Host "--> SSL Cert detected" -ForegroundColor Green
    $pw = Read-Host  “Please Enter Your Certificate Password” -AsSecureString
} else {
    Write-Host "--> SSL Cert detected" -ForegroundColor Green
}
Write-Host "--> Creating your Resource Group" -ForegroundColor Green
$json = Get-Content -Path ./params.json | ConvertFrom-Json
$obj = $json.parameters.clientVar.value
#$tag = $json.parameters.tags.value
New-AzResourceGroup -Name $obj.rgName -Location $obj.location | Out-Null

Write-Host "--> Deploying your KeyVault" -ForegroundColor Green
$kvName = "kv" + $obj.client + (Get-Random -Maximum 100000)
New-AzKeyVault `
    -Name $kvName `
    -ResourceGroupName $obj.rgName `
    -Location $obj.location `
    -Sku 'Standard' `
    -EnabledForDeployment `
    -EnabledForTemplateDeployment `
    -EnabledForDiskEncryption `
    -EnablePurgeProtection `
    | Out-Null
    #-Tags $tag 

Write-Host "--> Added password to KeyVault" -ForegroundColor Green
$winPW = ConvertTo-SecureString -String $genPw -Force -AsPlainText
Set-AzKeyVaultSecret `
    -VaultName $kvName `
    -Name 'winPW' `
    -SecretValue $winPW `
    | Out-Null
    #-Tags $tag 

Write-Host "--> Added pubSSH to KeyVault" -ForegroundColor Green
$SSHimport = Get-Content -Path ./etc/SSHv1_1.pub -Raw
$SSH = ConvertTo-SecureString -String $SSHimport -Force -AsPlainText
Set-AzKeyVaultSecret `
    -VaultName $kvName `
    -Name 'SSHkey' `
    -SecretValue $SSH `
    | Out-Null
    #-Tags $tag 

Write-Host "--> Added privSSH to KeyVault" -ForegroundColor Green
$privSSHimp = Get-Content -Path C:\Users\suher\OneDrive\Desktop\SSHv1_1.ppk -Raw
$privSSH = ConvertTo-SecureString -String $privSSHimp -Force -AsPlainText
Set-AzKeyVaultSecret `
    -VaultName $kvName `
    -Name 'privSSH' `
    -SecretValue $privSSH `
    | Out-Null
    #-Tags $tag 

Write-Host "--> Added SSL cert to KeyVault" -ForegroundColor Green
Import-AzKeyVaultCertificate `
    -VaultName $kvName `
    -Name 'SSLcert' `
    -FilePath ./etc/SSLDUMMY.pfx `
    -Password $pw `
    | Out-Null
    #-Tags $tag 

Write-Host "--> Evolving your infrastructure" -ForegroundColor Green
$arrayParam = @{objId = $(ConvertFrom-Json $output);kvName = $kvName}
Write-Host "
───▄▄▄───▄██▄──█▀───█─▄
─▄██▀█▌─██▄▄──▐█▀▄─▐█▀
▐█▀▀▌───▄▀▌─▌─█─▌──▌─▌
▌▀▄─▐──▀▄─▐▄─▐▄▐▄─▐▄─▐▄
" -ForegroundColor Green

New-AzSubscriptionDeployment `
    -TemplateFile ./Main.bicep `
    -TemplateParameterFile ./params.json `
    -iVar $arrayParam `
    -Location westeurope `
    -Name xyz-deploy

$tempVault = Get-AzKeyVault
$temp2 = $tempVault.VaultName
$secret = Get-AzKeyVaultSecret -VaultName $temp2 -Name "winPW" -AsPlainText
Write-Host "-----------------------------------------------------------------------" -ForegroundColor Green
Write-Host "--------------------- Your deployment has finished --------------------" -ForegroundColor Green
Write-Host "----------------------- Your password to log in: ----------------------" -ForegroundColor Green
Write-Host "-----------------------------------------------------------------------" -ForegroundColor Green
Write-Host "--------------------      $secret      -------------------" -ForegroundColor Green
Write-Host "-----------------------------------------------------------------------" -ForegroundColor Green
Write-Host "--- If you lose your password, retrieve it by running 'getPwd.ps1' ----" -ForegroundColor Green
Write-Host "-----------------------------------------------------------------------" -ForegroundColor Green
Write-Host "-----------------------------------------------------------------------" -ForegroundColor Green
Write-Host "

█▄▀▄▀▄█
█░▀░▀░█▄
█░▀░░░█─█
█░░░▀░█▄▀
▀▀▀▀▀▀▀
" -ForegroundColor Green
$winPW = ''
Write-Host "--> Cheers! =)" -ForegroundColor Green
Write-Host "--> Have a nice day." -ForegroundColor Green