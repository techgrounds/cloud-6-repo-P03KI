Write-Host "Creating Certifcate SSL" -ForegroundColor Green
$Cert = New-SelfSignedCertificate -dnsname 'SSL' -NotAfter (Get-Date).AddYears(1)
Write-Host "Exporting Certificate SSL" -ForegroundColor Green
# Set password to export certificate
$pw = ConvertTo-SecureString -String "Pazzword" -Force -AsPlainText
# Get thumbprint
$thumbprint = $Cert.Thumbprint
# Export certificate
Export-PfxCertificate -cert cert:\localMachine\my\$thumbprint -FilePath ./etc/SSL.pfx -Password $pw