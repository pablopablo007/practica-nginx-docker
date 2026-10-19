# ==============================================================================
# Script: deploy.ps1
# Descripción: Despliegue seguro de dos servidores web Nginx con Docker en Windows/WSL.
# ==============================================================================

[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"

Write-Host "=====================================================" -ForegroundColor Cyan
Write-Host "  Despliegue Seguro de Servidores Nginx con Docker   " -ForegroundColor Cyan
Write-Host "=====================================================" -ForegroundColor Cyan

# Función auxiliar para ejecutar docker nativo o mediante WSL
$useWsl = $false

if (Get-Command docker -ErrorAction SilentlyContinue) {
    try {
        & docker version | Out-Null
        $useWsl = $false
        Write-Host "[OK] Docker detectado de forma nativa en Windows." -ForegroundColor Green
    } catch {
        $useWsl = $true
    }
} else {
    $useWsl = $true
}

if ($useWsl) {
    if (Get-Command wsl -ErrorAction SilentlyContinue) {
        $wslDocker = wsl bash -c "which docker" 2>$null
        if ($wslDocker) {
            Write-Host "[OK] Docker detectado y operativo a través de WSL (Ubuntu)." -ForegroundColor Green
        } else {
            Write-Host "[ERROR] Docker no está instalado ni en Windows ni en WSL." -ForegroundColor Red
            exit 1
        }
    } else {
        Write-Host "[ERROR] No se encontró Docker ni WSL en el sistema." -ForegroundColor Red
        exit 1
    }
}

function Invoke-DockerCmd {
    param([string]$ArgsString)
    if ($script:useWsl) {
        $cmd = "docker $ArgsString"
        wsl bash -c "$cmd"
    } else {
        Invoke-Expression "docker $ArgsString"
    }
}

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$projectDir = Split-Path -Parent $scriptDir

$index1 = Join-Path $projectDir "index1.html"
$index2 = Join-Path $projectDir "index2.html"

if (!(Test-Path $index1) -or !(Test-Path $index2)) {
    Write-Host "[ERROR] Faltan los archivos index1.html o index2.html en $projectDir" -ForegroundColor Red
    exit 1
}

# 1. Despliegue de nginx1
Write-Host "`n--> Verificando contenedor 'nginx1'..." -ForegroundColor Cyan
$nginx1List = if ($useWsl) { (wsl docker ps -a --format '{{.Names}}') } else { (docker ps -a --format '{{.Names}}') }
if ($nginx1List -split "`n" | Where-Object { $_.Trim() -eq "nginx1" }) {
    Write-Host "[AVISO] El contenedor 'nginx1' ya existe. Comprobando estado..." -ForegroundColor Yellow
    $status = if ($useWsl) { (wsl docker inspect --format '{{.State.Status}}' nginx1).Trim() } else { (docker inspect --format '{{.State.Status}}' nginx1).Trim() }
    if ($status -ne "running") {
        Write-Host "Iniciando contenedor 'nginx1' existente..." -ForegroundColor Yellow
        Invoke-DockerCmd "start nginx1"
    } else {
        Write-Host "[OK] Contenedor 'nginx1' ya está en ejecución." -ForegroundColor Green
    }
} else {
    Write-Host "Creando contenedor 'nginx1' en puerto 8089:80..." -ForegroundColor Cyan
    Invoke-DockerCmd "run -d --name nginx1 -p 8089:80 nginx"
    Write-Host "[OK] Contenedor 'nginx1' creado exitosamente." -ForegroundColor Green
}

# 2. Despliegue de nginx2
Write-Host "`n--> Verificando contenedor 'nginx2'..." -ForegroundColor Cyan
$nginx2List = if ($useWsl) { (wsl docker ps -a --format '{{.Names}}') } else { (docker ps -a --format '{{.Names}}') }
if ($nginx2List -split "`n" | Where-Object { $_.Trim() -eq "nginx2" }) {
    Write-Host "[AVISO] El contenedor 'nginx2' ya existe. Comprobando estado..." -ForegroundColor Yellow
    $status = if ($useWsl) { (wsl docker inspect --format '{{.State.Status}}' nginx2).Trim() } else { (docker inspect --format '{{.State.Status}}' nginx2).Trim() }
    if ($status -ne "running") {
        Write-Host "Iniciando contenedor 'nginx2' existente..." -ForegroundColor Yellow
        Invoke-DockerCmd "start nginx2"
    } else {
        Write-Host "[OK] Contenedor 'nginx2' ya está en ejecución." -ForegroundColor Green
    }
} else {
    Write-Host "Creando contenedor 'nginx2' en puerto 8090:80..." -ForegroundColor Cyan
    Invoke-DockerCmd "run -d --name nginx2 -p 8090:80 nginx"
    Write-Host "[OK] Contenedor 'nginx2' creado exitosamente." -ForegroundColor Green
}

# 3. Copia de HTMLs a contenedores
Write-Host "`n--> Copiando páginas personalizadas a contenedores..." -ForegroundColor Cyan
if ($useWsl) {
    # Convertir ruta tipo C:\Users\... a /mnt/c/Users/...
    $wslDrive = $projectDir.Substring(0, 1).ToLower()
    $wslSubPath = $projectDir.Substring(2).Replace('\', '/')
    $wslPath = "/mnt/$wslDrive$wslSubPath"
    
    wsl docker cp "$wslPath/index1.html" "nginx1:/usr/share/nginx/html/index.html"
    wsl docker cp "$wslPath/index2.html" "nginx2:/usr/share/nginx/html/index.html"
} else {
    docker cp "$index1" "nginx1:/usr/share/nginx/html/index.html"
    docker cp "$index2" "nginx2:/usr/share/nginx/html/index.html"
}

Write-Host "[OK] index1.html copiado a nginx1." -ForegroundColor Green
Write-Host "[OK] index2.html copiado a nginx2." -ForegroundColor Green

Write-Host "`n=====================================================" -ForegroundColor Green
Write-Host "  ¡Despliegue finalizado exitosamente!              " -ForegroundColor Green
Write-Host "  - Servidor Institucional: http://localhost:8089     " -ForegroundColor Green
Write-Host "  - Servidor Personal:      http://localhost:8090     " -ForegroundColor Green
Write-Host "=====================================================" -ForegroundColor Green
