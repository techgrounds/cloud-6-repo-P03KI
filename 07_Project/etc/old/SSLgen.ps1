$dir = "C:\Users\suher\OneDrive\Documents\Techgrounds\TG_REPO\07_Project\Application\etc\"

$subj = "CN=SSLDUMMY" #need either DnsName or Subject when calling New-SelfSignedCertificate

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