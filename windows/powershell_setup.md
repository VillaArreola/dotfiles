# 🚀 Configuración Maestra de PowerShell (Windows)

Este documento detalla cómo configurar un entorno de terminal moderno en Windows, separando el entorno de trabajo principal (PS 7) del entorno de respaldo (PS 5.1).

## 📦 1. Requisitos Previos

### A. Instalar Fuente 
Para ver los iconos, se debe instalar una **Nerd Font** en Windows.
1. Descargar [Hack Nerd Font (Zip)](https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/Hack.zip).
2. Descomprimir e instalar los archivos `.ttf` (Seleccionar todos > Clic derecho > Instalar).
3. Configurar en **Windows Terminal**:
   * *Configuración > Perfiles > Apariencia > Tipo de fuente > Hack Nerd Font*.

### B. Instalar PowerShell 7 (Core)
Es la versión moderna y rápida.


```powershell
winget install --id Microsoft.PowerShell --source winget
⚡ 2. PowerShell 7 (Daily Driver)
Iconos, autocompletado inteligente y velocidad.

Instalación de Módulos
Ejecutar en la terminal negra (PS 7):

PowerShell

# Permitir scripts
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser

# Instalar dependencias
Install-Module -Name Terminal-Icons -Repository PSGallery -Scope CurrentUser -Force
Install-Module -Name TabExpansionPlusPlus -Repository PSGallery -Scope CurrentUser -AllowClobber -Force
Install-Module -Name PSReadLine -Repository PSGallery -Scope CurrentUser -Force -AllowClobber
Configuración del Perfil ($PROFILE)
Comando para editar: notepad $PROFILE

PowerShell

# Cargar Módulos
Import-Module Terminal-Icons
Import-Module TabExpansionPlusPlus
Import-Module PSReadLine

# Configuración Visual
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle ListView

# Prompt Hacker (Zsh Style)
function prompt {
    Write-Host "┌──(" -NoNewline -ForegroundColor Blue
    Write-Host "PS:7.x" -NoNewline -ForegroundColor Yellow
    Write-Host ") @ [" -NoNewline -ForegroundColor Blue
    Write-Host (Get-Location) -NoNewline -ForegroundColor Green
    Write-Host "]" -ForegroundColor Blue
    return "└─> "
}
🛡️ 3. PowerShell 5.1 (Legacy / Backup)

Instalación de Módulos
Ejecutar en la terminal azul (PS 5.1):

PowerShell

Install-Module -Name Terminal-Icons -Repository PSGallery -Scope CurrentUser -Force
Configuración del Perfil ($PROFILE)
Comando para editar: notepad $PROFILE Nota: Usar codificación ANSI al guardar.

PowerShell

# Carga segura de iconos
if (Get-Module -ListAvailable Terminal-Icons) { Import-Module Terminal-Icons }

# Prompt Simplificado (Anti-errores de compatibilidad)
function prompt {
    Write-Host "PS 5.1 [" -NoNewline -ForegroundColor Yellow
    Write-Host (Get-Location) -NoNewline -ForegroundColor Green
    Write-Host "]" -ForegroundColor Yellow
    return " > "
}

