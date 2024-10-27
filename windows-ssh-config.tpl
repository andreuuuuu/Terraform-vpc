# Parametrii pentru configurarea SSH
param (
    [string]$hostname = "3.252.70.12",  # Schimbă cu adresa IP a serverului tău
    [string]$user = "ubuntu",              # Schimbă cu utilizatorul tău
    [string]$identityfile = "D:\.ssh\id_rsa" # Calea către cheia ta SSH
)

# Calea către fișierul de configurare
$configPath = "D:\.ssh\config"

# Crearea fișierului de configurare dacă nu există
if (-Not (Test-Path $configPath)) {
    New-Item -Path $configPath -ItemType File -Force
}

# Conținutul de adăugat în fișier
$configContent = @"
Host $hostname
    HostName $hostname
    User $user
    IdentityFile $identityfile
"@

# Verifică dacă configurația pentru gazda specificată există deja
$existingContent = Get-Content -Path $configPath
if (-not ($existingContent -contains "Host $hostname")) {
    # Adaugă conținutul în fișier
    Add-Content -Path $configPath -Value $configContent
} else {
    Write-Host "Configurarea pentru $hostname există deja."
}
