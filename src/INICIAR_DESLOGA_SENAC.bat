@echo off
title Abrindo DeslogaSenac
:: Garante que o script rode como Administrador para poder deletar as pastas do sistema
net session >nul 2>&1
if %errorLevel% == 0 (
    goto :run
) else (
    powershell -Command "Start-Process '%0' -Verb RunAs"
    exit /b
)

:run
:: O comando abaixo roda o PowerShell em modo "Hidden" (escondido) 
:: para que apenas a janela bonitinha do seu programa apareça, sem o fundo preto.
powershell -windowstyle hidden -ExecutionPolicy Bypass -File "%~dp0deslogasenac.ps1"
exit