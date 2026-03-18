$log = "C:\choco-app-log.txt"
"--- Inicio da Instalação: $(Get-Date) ---" | Out-File $log -Append

# 1. Lista Completa de Apps para Help Desk
$apps = @(
    "googlechrome",    # Motor do Jira
    "anydesk",         # Suporte Remoto
    "greenshot",       # Print de erros para tickets
    "notepadplusplus", # Leitura de logs
    "7zip",            # Compactador
    "putty",           # SSH/Rede
    "windirstat",      # Diagnóstico de disco
    "advanced-ip-scanner", # Mapear a rede
    "vlc",             # Ver vídeos de erros
)

foreach ($app in $apps) {
    "A instalar: $app ..." | Out-File $log -Append
    & choco install $app -y --no-progress | Out-File $log -Append
}

# 2. Criar Atalho do JIRA no Ambiente de Trabalho do Zé Manel
$WshShell = New-Object -ComObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("$env:PUBLIC\Desktop\ABRIR TICKETS JIRA.lnk")
$Shortcut.TargetPath = "https://ajuda.atlassian.net" # <-- SUBSTITUA PELO VOSSO LINK DO JIRA
$Shortcut.Save()

"--- Instalação Finalizada: $(Get-Date) ---" | Out-File $log -Append
