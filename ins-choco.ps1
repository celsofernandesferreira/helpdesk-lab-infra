Start-Transcript -Path "C:\choco-log.txt" -Force
$chocopath = "C:\programData\chocolatey\bin\choco.exe"

Write-host "A iniciar arraque do pc. Averificar estado..."

If (-not (Test-Path $chocopath)) {
Write-Host "chocolatey nao encontrado. A Tentar instalar da Internet..."
try {
Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
Write-Host "instalacao concluida com sucesso!"
}catch{
Write-Host "falha Critica de Rede ou sis: $_"
}
}else{
Write-host "o Programa ja ca canta"
}

Stop-Transcript