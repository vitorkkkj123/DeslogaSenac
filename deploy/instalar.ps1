# DeslogaSenac - Instalador de Automação
# Este script configura a execução automática ao fazer Logon

Write-Host "Iniciando instalação do DeslogaSenac..." -ForegroundColor Cyan

# 1. Descobre o caminho da pasta src que está um nível acima da pasta deploy
$Pai = Get-Item $PSScriptRoot | Split-Path
$CaminhoBat = Join-Path $Pai "src\INICIAR_DESLOGA_SENAC.bat"

# 2. Verifica se o arquivo existe antes de agendar
if (Test-Path $CaminhoBat) {
    Write-Host "Arquivo encontrado em: $CaminhoBat" -ForegroundColor Green
    
    # 3. Cria a tarefa agendada
    # /sc onlogon: Roda ao entrar na conta
    # /rl highest: Roda como admin
    schtasks /create /tn "DeslogaSenac_Startup" /tr "$CaminhoBat" /sc onlogon /rl highest /f
    
    Write-Host "`n[SUCESSO] O DeslogaSenac agora rodará automaticamente em cada login!" -ForegroundColor Green
} else {
    Write-Host "`n[ERRO] Não foi possível encontrar o arquivo .bat na pasta src." -ForegroundColor Red
}

pause