@echo off
rem Launch Godot XR apps on DisplayXR. The options and notes are in
rem Launch-Godot-DisplayXR.ps1, e.g.  Launch-Godot-DisplayXR.cmd -Runtime dev -Fullscreen
where pwsh >nul 2>nul || (echo This needs PowerShell 7: winget install Microsoft.PowerShell & exit /b 1)
pwsh -NoProfile -File "%~dp0Launch-Godot-DisplayXR.ps1" %*
