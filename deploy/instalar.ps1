[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

Write-Host "==================================================" -ForegroundColor Cyan
Write-Host "         INSTALADOR AUTOMATICO - DESLOGASENAC     " -ForegroundColor Cyan
Write-Host "==================================================" -ForegroundColor Cyan

# 1. VERIFICACAO DE PRIVILEGIOS DE ADMINISTRADOR
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-Host "`n[ERRO] PRIVILEGIOS INSUFICIENTES!" -ForegroundColor Red
    Write-Host "Execute este instalador clicando com o botao direito e escolhendo 'Executar como Administrador'." -ForegroundColor Yellow
    $null = [Console]::ReadKey()
    exit
}

# 2. DEFINICAO DOS CAMINHOS (VIA .NET - SEM PARÂMETROS SUSCETÍVEIS A ERRO)
$PastaExecutavel = [System.AppDomain]::CurrentDomain.BaseDirectory.TrimEnd('\')
if (-not $PastaExecutavel) {$PastaExecutavel = (Get-Location).Path
}

# Sobe um nível para chegar na raiz do projeto (sair de \deploy)
$RaizDoProjeto = [System.IO.Directory]::GetParent($PastaExecutavel).FullName

$CaminhoOrigemBat   = "$RaizDoProjeto\src\INICIAR_DESLOGA_SENAC.bat"
$CaminhoOrigemPs1   = "$RaizDoProjeto\src\deslogasenac.ps1"
$CaminhoOrigemIcone = "$RaizDoProjeto\assets\icone.ico"

$PastaDestino        = "C:\DeslogaSenac"
$CaminhoDestinoBat   = "$PastaDestino\INICIAR_DESLOGA_SENAC.bat"
$CaminhoDestinoPs1   = "$PastaDestino\deslogasenac.ps1"
$CaminhoDestinoIcone = "$PastaDestino\icone.ico"

# 3. CRIACAO DO DIRETORIO E COPIA DE FICHEIROS
if ([System.IO.File]::Exists($CaminhoOrigemBat)) {
    Write-Host "`n[+] A preparar diretorio do sistema em $PastaDestino..." -ForegroundColor White
    if (-not [System.IO.Directory]::Exists($PastaDestino)) {
        [System.IO.Directory]::CreateDirectory($PastaDestino) | Out-Null
    }

    Write-Host "[+] A copiar arquivos do motor e interface..." -ForegroundColor White
    [System.IO.File]::Copy($CaminhoOrigemBat, $CaminhoDestinoBat, $true)

    if ([System.IO.File]::Exists($CaminhoOrigemPs1)) {
        [System.IO.File]::Copy($CaminhoOrigemPs1, $CaminhoDestinoPs1, $true)
    }

    if ([System.IO.File]::Exists($CaminhoOrigemIcone)) {
        Write-Host "[+] A copiar o icone personalizado..." -ForegroundColor White
        [System.IO.File]::Copy($CaminhoOrigemIcone, $CaminhoDestinoIcone, $true)
    }

    # 4. GERACAO DO ATALHO NO AMBIENTE DE TRABALHO PUBLICO
    Write-Host "[+] A criar o atalho publico para todos os utilizadores..." -ForegroundColor White
    try {
        $WshShell = New-Object -ComObject WScript.Shell
        $DesktopPublico = [System.Environment]::GetFolderPath('CommonDesktopDirectory')
        $CaminhoAtalho = "$DesktopPublico\DeslogaSenac.lnk"

        $Shortcut = $WshShell.CreateShortcut($CaminhoAtalho)
        $Shortcut.TargetPath = $CaminhoDestinoBat
        $Shortcut.WorkingDirectory = $PastaDestino
        $Shortcut.Description = "Encerra sessoes e limpa credenciais nos navegadores"

        if ([System.IO.File]::Exists($CaminhoDestinoIcone)) {
            $Shortcut.IconLocation = "$CaminhoDestinoIcone,0"
        } else {
            $Shortcut.IconLocation = "shell32.dll,47"
        }

        $Shortcut.Save()
        Write-Host "[OK] Atalho registado com sucesso em: $CaminhoAtalho" -ForegroundColor Green
    } catch {
        Write-Host "[AVISO] Falha ao registar o atalho: $_" -ForegroundColor Yellow
    }

    Write-Host "`n==================================================" -ForegroundColor Green
    Write-Host "   [CONCLUIDO] DESLOGASENAC CONFIGURADO COM SUCESSO!   " -ForegroundColor Green
    Write-Host "==================================================" -ForegroundColor Green
} else {
    Write-Host "`n[ERRO] O ficheiro fonte nao foi localizado em: $CaminhoOrigemBat" -ForegroundColor Red
}

Write-Host "`nPrima qualquer tecla para fechar..." -ForegroundColor Gray
$null = [Console]::ReadKey()