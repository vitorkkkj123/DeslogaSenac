[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# Carregamento seguro dos módulos visuais
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# --- CRIAÇÃO DA JANELA PRINCIPAL ---
$Form = New-Object System.Windows.Forms.Form
$Form.Text = "DeslogaSenac - v1.0"
$Form.Size = New-Object System.Drawing.Size(400, 280)
$Form.StartPosition = "CenterScreen"
$Form.FormBorderStyle = "FixedDialog"
$Form.MaximizeBox = $false
$Form.MinimizeBox = $true
$Form.BackColor = [System.Drawing.ColorTranslator]::FromHtml("#F0F0F0")

# --- TÍTULO ---
$LabelTitulo = New-Object System.Windows.Forms.Label
$LabelTitulo.Text = "DeslogaSenac"
$LabelTitulo.Font = New-Object System.Drawing.Font("Segoe UI", 18, [System.Drawing.FontStyle]::Bold)
$LabelTitulo.ForeColor = [System.Drawing.ColorTranslator]::FromHtml("#004587")
$LabelTitulo.Location = New-Object System.Drawing.Point(0, 20)
$LabelTitulo.Size = New-Object System.Drawing.Size(400, 40)
$LabelTitulo.TextAlign = "MiddleCenter"
$Form.Controls.Add($LabelTitulo)

# --- STATUS ---
$LabelStatus = New-Object System.Windows.Forms.Label
$LabelStatus.Text = "Pronto para proteger os seus dados."
$LabelStatus.Location = New-Object System.Drawing.Point(0, 65)
$LabelStatus.Size = New-Object System.Drawing.Size(400, 20)
$LabelStatus.TextAlign = "MiddleCenter"
$Form.Controls.Add($LabelStatus)

# --- BARRA DE PROGRESSO ---
$ProgressBar = New-Object System.Windows.Forms.ProgressBar
$ProgressBar.Location = New-Object System.Drawing.Point(50, 100)
$ProgressBar.Size = New-Object System.Drawing.Size(300, 25)
$ProgressBar.Style = "Continuous"
$Form.Controls.Add($ProgressBar)

# --- BOTÃO ---
$BtnLimpar = New-Object System.Windows.Forms.Button
$BtnLimpar.Text = "INICIAR LIMPEZA AGORA"
$BtnLimpar.Location = New-Object System.Drawing.Point(100, 150)
$BtnLimpar.Size = New-Object System.Drawing.Size(200, 50)
$BtnLimpar.BackColor = [System.Drawing.ColorTranslator]::FromHtml("#004587")
$BtnLimpar.ForeColor = [System.Drawing.Color]::White
$BtnLimpar.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$BtnLimpar.FlatStyle = "Flat"
$BtnLimpar.Cursor = [System.Windows.Forms.Cursors]::Hand
$Form.Controls.Add($BtnLimpar)

# --- LÓGICA DE LIMPEZA BLINDADA ---
$BtnLimpar.Add_Click({
    $BtnLimpar.Enabled = $false
    $Form.Cursor = [System.Windows.Forms.Cursors]::WaitCursor
    $LabelStatus.Text = "A encerrar navegadores..."
    $Form.Refresh()
    $ProgressBar.Value = 20

    # 1. Encerramento forçado de todos os processos relacionados
    $processos = @("chrome", "msedge", "brave", "GoogleCrashHandler", "GoogleCrashHandler64")
    Stop-Process -Name $processos -Force -ErrorAction SilentlyContinue

    # Aguarda a liberação dos arquivos em disco
    $tentativas = 0
    while ((Get-Process -Name @("chrome", "msedge", "brave") -ErrorAction SilentlyContinue) -and ($tentativas -lt 6)) {
        Start-Sleep -Milliseconds 500
        $tentativas++
    }

    $LabelStatus.Text = "A limpar rastos, tokens e sessões..."
    $Form.Refresh()
    $ProgressBar.Value = 50

    # 2. Diretórios base dos navegadores
    $BrowserUserDataRoots = @(
        "$env:LOCALAPPDATA\Google\Chrome\User Data",
        "$env:LOCALAPPDATA\Microsoft\Edge\User Data",
        "$env:LOCALAPPDATA\BraveSoftware\Brave-Browser\User Data"
    )

    foreach ($userDataRoot in $BrowserUserDataRoots) {
        if (Test-Path $userDataRoot) {
            # Remove perfis adicionais criados por alunos (Profile 1, Profile 2, etc.)
            Get-ChildItem -Path $userDataRoot -Directory -ErrorAction SilentlyContinue |
                Where-Object { $_.Name -match "^Profile \d+$" } |
                ForEach-Object {
                    Remove-Item -Path $_.FullName -Recurse -Force -ErrorAction SilentlyContinue
                }

            # Remove o Local State (arquivo que registra as contas logadas e telas de perfil)
            $LocalState = "$userDataRoot\Local State"
            if (Test-Path $LocalState) {
                Remove-Item -Path $LocalState -Force -ErrorAction SilentlyContinue
            }

            # Limpa o perfil padrão (Default)
            $defaultProfile = "$userDataRoot\Default"
            if (Test-Path $defaultProfile) {
                $targetPaths = @(
                    "$defaultProfile\Cache",
                    "$defaultProfile\Code Cache",
                    "$defaultProfile\GPUCache",
                    "$defaultProfile\Sessions",
                    "$defaultProfile\Session Storage",
                    "$defaultProfile\Current Session",
                    "$defaultProfile\Current Tabs",
                    "$defaultProfile\Last Session",
                    "$defaultProfile\Last Tabs",
                    "$defaultProfile\History",
                    "$defaultProfile\Login Data",
                    "$defaultProfile\Login Data-journal",
                    "$defaultProfile\Web Data",
                    "$defaultProfile\Web Data-journal",
                    "$defaultProfile\IndexedDB",
                    "$defaultProfile\Service Worker",
                    "$defaultProfile\Local Storage",
                    "$defaultProfile\Network"
                )

                foreach ($target in $targetPaths) {
                    if (Test-Path $target) {
                        Remove-Item -Path $target -Recurse -Force -ErrorAction SilentlyContinue
                    }
                }
            }
        }
    }

    $ProgressBar.Value = 85
    $LabelStatus.Text = "A limpar ficheiros temporários..."
    $Form.Refresh()

    # 3. Limpeza de temporários do utilizador
    if (Test-Path "$env:TEMP") {
        Get-ChildItem -Path "$env:TEMP" -Recurse -ErrorAction SilentlyContinue |
            Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
    }

    $ProgressBar.Value = 100
    $LabelStatus.Text = "Concluído!"
    $Form.Cursor = [System.Windows.Forms.Cursors]::Default
    $Form.Refresh()

    [System.Windows.Forms.MessageBox]::Show(
        "Dados limpos com sucesso. Todos os perfis e contas foram desconectados!",
        "DeslogaSenac",
        [System.Windows.Forms.MessageBoxButtons]::OK,
        [System.Windows.Forms.MessageBoxIcon]::Information
    )
    $Form.Close()
})

# Executa o ciclo de eventos da interface e liberta os recursos
$Form.ShowDialog() | Out-Null
$Form.Dispose()