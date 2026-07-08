[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

Write-Host "==================================================" -ForegroundColor Cyan
Write-Host "         INSTALADOR AUTOMÁTICO - DESLOGASENAC     " -ForegroundColor Cyan
Write-Host "==================================================" -ForegroundColor Cyan

# 1. VERIFICAÇÃO DE PRIVILÉGIOS ADMINISTRATIVOS
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-Host "`n[ERRO] PRIVILÉGIOS INSUFICIENTES!" -ForegroundColor Red
    Write-Host "Clique com o botão direito no instalador e selecione 'Executar como Administrador'." -ForegroundColor Yellow
    $null = [Console]::ReadKey()
    exit
}

# 2. DEFINIÇÃO DOS CAMINHOS (ORIGEM E DESTINO SEGURO)
# 2. DEFINIÇÃO DOS CAMINHOS (ORIGEM E DESTINO SEGURO) - VERSÃO BLINDADA
if ($MyInvocation.MyCommand.Definition) {
    $DiretorioAtual = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
} else {
    $DiretorioAtual = Get-Location
}
$RaizDoProjeto = Split-Path -Path $DiretorioAtual -Parent
$CaminhoOrigemBat = Join-Path $RaizDoProjeto "src\INICIAR_DESLOGA_SENAC.bat"
$RaizDoProjeto = Split-Path -Path $DiretorioAtual -Parent
$CaminhoOrigemBat = Join-Path $RaizDoProjeto "src\INICIAR_DESLOGA_SENAC.bat"

# Pasta destino neutra onde o SYSTEM e os Alunos têm acesso garantido
$PastaDestino = "C:\DeslogaSenac"
$CaminhoDestinoBat = Join-Path $PastaDestino "INICIAR_DESLOGA_SENAC.bat"

# 3. CRIAÇÃO DA PASTA LOCAL E CÓPIA DO ARQUIVO
if (Test-Path $CaminhoOrigemBat) {
    Write-Host "`n[+] Criando diretório seguro em $PastaDestino..." -ForegroundColor White
    if (-not (Test-Path $PastaDestino)) {
        New-Item -ItemType Directory -Path $PastaDestino -Force | Out-Null
    }

    Write-Host "[+] Copiando arquivos do projeto..." -ForegroundColor White
    Copy-Item -Path $CaminhoOrigemBat -Destination $CaminhoDestinoBat -Force

    # 4. CRIAÇÃO DA TAREFA APONTANDO PARA O CAMINHO FIXO
    Write-Host "[+] Registrando tarefa no Agendador de Tarefas do Windows..." -ForegroundColor White
    
    # Aponta direto para o C:\DeslogaSenac\INICIAR_DESLOGA_SENAC.bat
    $comandoSchtasks = 'schtasks /create /tn "DeslogaSenac_Startup" /tr "' + $CaminhoDestinoBat + '" /sc onlogon /ru "NT AUTHORITY\SYSTEM" /f'
    cmd /c $comandoSchtasks

    Write-Host "`n[+] Validando instalação..." -ForegroundColor White
    $testeTarefa = cmd /c "schtasks /query /tn DeslogaSenac_Startup" 2>$null

    if ($LASTEXITCODE -eq 0) {
        Write-Host "`n==================================================" -ForegroundColor Green
        Write-Host " [SUCESSO] DeslogaSenac instalado com perfeição! " -ForegroundColor Green
        Write-Host "==================================================" -ForegroundColor Green
        Write-Host "O script foi copiado para: $CaminhoDestinoBat" -ForegroundColor White
        Write-Host "A tarefa rodará perfeitamente a cada novo logon." -ForegroundColor Yellow
    } else {
        Write-Host "`n[ERRO] O comando rodou, mas a tarefa não pôde ser verificada." -ForegroundColor Red
    }
} else {
    Write-Host "`n[ERRO] Não foi possível encontrar o script em: $CaminhoOrigemBat" -ForegroundColor Red
}