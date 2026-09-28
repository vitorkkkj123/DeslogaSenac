@echo off
title DeslogaSenac
powershell.exe -NoProfile -ExecutionPolicy Bypass -STA -WindowStyle Hidden -File "%~dp0deslogasenac.ps1"
exit /b 0