Write-Host "==================================================" -ForegroundColor Cyan
Write-Host "         INSTALADOR AUTOMÁTICO - DESLOGASENAC     " -ForegroundColor Cyan
Write-Host "==================================================" -ForegroundColor Cyan

# 1. VERIFICAÇÃO DE PRIVILÉGIOS ADMINISTRATIVOS
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Host "`n[ERRO] PRIVILÉGIOS INSUFICIENTES!" -ForegroundColor Red
    Write-Host "Este script PRECISA ser executado como Administrador para interagir com o Agendador de Tarefas." -ForegroundColor Yellow
    Write-Host "Por favor, feche este terminal, clique com o botão direito no instalador e selecione 'Executar como Administrador'." -ForegroundColor White
    Write-Host "`nPressione qualquer tecla para sair..."
    $null = [Console]::ReadKey()
    exit
}

# 2. LOCALIZAÇÃO DINÂMICA DO PROJETO
$DiretorioAtual = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
if (-not $DiretorioAtual) { $DiretorioAtual = Get-Location }

$RaizDoProjeto = Split-Path -Path $DiretorioAtual -Parent
$CaminhoDoBat = Join-Path $RaizDoProjeto "src\INICIAR_DESLOGA_SENAC.bat"

Write-Host "`n[+] Analisando estrutura de diretórios..." -ForegroundColor White

# 3. VERIFICAÇÃO DE INTEGRIDADE E CRIAÇÃO DA TAREFA
if (Test-Path $CaminhoDoBat) {
    Write-Host "[OK] Arquivo principal localizado em: $CaminhoDoBat" -ForegroundColor Green
    Write-Host "[+] Registrando tarefa no Agendador de Tarefas do Windows..." -ForegroundColor White

    $comandoSchtasks = 'schtasks /create /tn "DeslogaSenac_Startup" /tr "' + $CaminhoDoBat + '" /sc onlogon /rl highest /f'
    cmd /c $comandoSchtasks

    Write-Host "`n[+] Validando instalação..." -ForegroundColor White
    $testeTarefa = cmd /c "schtasks /query /tn DeslogaSenac_Startup" 2>$null

    if ($LASTEXITCODE -eq 0) {
        Write-Host "`n==================================================" -ForegroundColor Green
        Write-Host " [SUCESSO] DeslogaSenac instalado com perfeição! " -ForegroundColor Green
        Write-Host "==================================================" -ForegroundColor Green
        Write-Host "A tarefa 'DeslogaSenac_Startup' está ativa e configurada." -ForegroundColor White
        Write-Host "O sistema rodará automaticamente a cada novo logon." -ForegroundColor Yellow
    } else {
        Write-Host "`n[ERRO] O comando rodou, mas a tarefa não pôde ser verificada pelo sistema." -ForegroundColor Red
    }
} else {
    Write-Host "`n==================================================" -ForegroundColor Red
    Write-Host " [ERRO] FALHA NA INSTALAÇÃO!                      " -ForegroundColor Red
    Write-Host "==================================================" -ForegroundColor Red
    Write-Host "Não foi possível encontrar o arquivo executável em:" -ForegroundColor White
    Write-Host "-> $CaminhoDoBat" -ForegroundColor Yellow
}

Write-Host "`nPressione qualquer tecla para encerrar o instalador..." -ForegroundColor Gray
$null = [Console]::ReadKey()