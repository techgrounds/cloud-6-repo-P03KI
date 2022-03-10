$tempVault = Get-AzKeyVault
$secret = Get-AzKeyVaultSecret -VaultName $tempVault.VaultName -Name "genPass" -AsPlainText
echo "-----------------------------------------------------------------------"
echo "------------------ Your deployment has finished -----------------------"
echo "--------------------- Your password to log in: ------------------------" 
echo "-----------------------------------------------------------------------" 
$secret 
echo "-----------------------------------------------------------------------"
echo "--- If you lose your password, retrieve it by running '.\getPw.ps1' ---"