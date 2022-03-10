$tempVault = Get-AzKeyVault
$temp2 = $tempVault.VaultName
$secret = Get-AzKeyVaultSecret -VaultName $temp2 -Name "genPass" -AsPlainText
Write-Output "-----------------------------------------------------------------------"
Write-Output "------------------ Your deployment has finished -----------------------"
Write-Output "--------------------- Your password to log in: ------------------------" 
Write-Output "-----------------------------------------------------------------------" 
Write-Output "---------------------- $secret ----------------------"
Write-Output "-----------------------------------------------------------------------"
Write-Output "--- If you lose your password, retrieve it by running '.\getPw.ps1' ---"
Write-Output "-----------------------------------------------------------------------"
Write-Output "-----------------------------------------------------------------------"