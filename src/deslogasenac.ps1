# --- CORREÇÃO DE UTF-8 (LETRAS E ACENTOS) ---
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# --- CRIAÇÃO DA JANELA ---
$Form = New-Object System.Windows.Forms.Form
$Form.Text = "DeslogaSenac - v1.0"
$Form.Size = New-Object System.Drawing.Size(400,280)
$Form.StartPosition = "CenterScreen"
$Form.FormBorderStyle = "FixedDialog"
$Form.MaximizeBox = $false
$Form.BackColor = "#F0F0F0"

# --- TÍTULO ---
$LabelTitulo = New-Object System.Windows.Forms.Label
$LabelTitulo.Text = "DeslogaSenac"
$LabelTitulo.Font = New-Object System.Drawing.Font("Segoe UI", 18, [System.Drawing.FontStyle]::Bold)
$LabelTitulo.ForeColor = "#004587"
$LabelTitulo.Location = New-Object System.Drawing.Point(0, 20)
$LabelTitulo.Size = New-Object System.Drawing.Size(400, 40)
$LabelTitulo.TextAlign = "MiddleCenter"
$Form.Controls.Add($LabelTitulo)

# --- STATUS ---
$LabelStatus = New-Object System.Windows.Forms.Label
$LabelStatus.Text = "Pronto para proteger seus dados."
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
$BtnLimpar.BackColor = "#004587"
$BtnLimpar.ForeColor = "White"
$BtnLimpar.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$BtnLimpar.FlatStyle = "Flat"
$Form.Controls.Add($BtnLimpar)

# --- LÓGICA DE LIMPEZA OTIMIZADA ---
$BtnLimpar.Add_Click({
    $BtnLimpar.Enabled = $false
    $LabelStatus.Text = "Encerrando navegadores..."
    $Form.Refresh() # Força a interface a atualizar o texto na tela imediatamente
    $ProgressBar.Value = 30
    
    # 1. Encerra processos de forma agressiva para liberar os arquivos
    $browsers = "chrome", "msedge", "brave"
    Stop-Process -Name $browsers -Force -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 2
    
    $LabelStatus.Text = "Limpando rastros e sessões..."
    $Form.Refresh()
    $ProgressBar.Value = 70
    
    # 2. Caminhos específicos de Cache, Cookies e Sessões (Protege a estrutura e apaga os dados)
    $Paths = @(
        # Google Chrome
        "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Cache\*",
        "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Network\Cookies",
        "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Current Session",
        "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Current Tabs",
        # Microsoft Edge
        "$env:LOCALAPPDATA\Microsoft\Edge\User Data\Default\Cache\*",
        "$env:LOCALAPPDATA\Microsoft\Edge\User Data\Default\Network\Cookies",
        "$env:LOCALAPPDATA\Microsoft\Edge\User Data\Default\Current Session",
        "$env:LOCALAPPDATA\Microsoft\Edge\User Data\Default\Current Tabs",
        # Brave Browser (Adicionado para dar suporte completo)
        "$env:LOCALAPPDATA\BraveSoftware\Brave-Browser\User Data\Default\Cache\*",
        "$env:LOCALAPPDATA\BraveSoftware\Brave-Browser\User Data\Default\Network\Cookies",
        "$env:LOCALAPPDATA\BraveSoftware\Brave-Browser\User Data\Default\Current Session",
        "$env:LOCALAPPDATA\BraveSoftware\Brave-Browser\User Data\Default\Current Tabs"
    )
    
    foreach ($path in $Paths) {
        if (Test-Path $path) {
            Remove-Item -Path $path -Recurse -Force -ErrorAction SilentlyContinue
        }
    }
    
    # 3. Limpeza de arquivos temporários gerais da máquina (Garante mais privacidade)
    Remove-Item -Path "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue
    
    $ProgressBar.Value = 100
    $LabelStatus.Text = "Concluído!"
    $Form.Refresh()
    
    [System.Windows.Forms.MessageBox]::Show("Dados limpos com sucesso. Sua privacidade está protegida!", "DeslogaSenac")
    $Form.Close()
})

$Form.ShowDialog() | Out-Null