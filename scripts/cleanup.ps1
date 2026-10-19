# ==============================================================================
# Script: cleanup.ps1
# Descripción: Detención y eliminación segura de los contenedores nginx1 y nginx2 en Windows.
# ==============================================================================

[CmdletBinding()]
param(
    [switch]$Force
)

Write-Host "=====================================================" -ForegroundColor Yellow
Write-Host "  Limpieza Opcional de Contenedores de la Práctica   " -ForegroundColor Yellow
Write-Host "=====================================================" -ForegroundColor Yellow
Write-Host "Este script detendrá y eliminará ÚNICAMENTE los contenedores:"
Write-Host "  - nginx1 (puerto 8089)"
Write-Host "  - nginx2 (puerto 8090)"
Write-Host "No se eliminará ninguna imagen, volumen o contenedor ajeno."

if (-not $Force) {
    $resp = Read-Host "¿Está seguro de que desea detener y eliminar nginx1 y nginx2? (s/N)"
    if ($resp -notmatch "^[sS]$") {
        Write-Host "Operación cancelada por el usuario. No se modificó nada." -ForegroundColor Cyan
        exit 0
    }
}

$useWsl = $false
if (Get-Command docker -ErrorAction SilentlyContinue) {
    try { & docker version | Out-Null; $useWsl = $false } catch { $useWsl = $true }
} else {
    $useWsl = $true
}

Write-Host "`n--> Deteniendo y eliminando 'nginx1'..." -ForegroundColor Cyan
if ($useWsl) {
    wsl bash -c "docker stop nginx1 2>/dev/null; docker rm nginx1 2>/dev/null; true"
} else {
    docker stop nginx1 2>$null; docker rm nginx1 2>$null
}
Write-Host "[OK] Contenedor nginx1 procesado." -ForegroundColor Green

Write-Host "`n--> Deteniendo y eliminando 'nginx2'..." -ForegroundColor Cyan
if ($useWsl) {
    wsl bash -c "docker stop nginx2 2>/dev/null; docker rm nginx2 2>/dev/null; true"
} else {
    docker stop nginx2 2>$null; docker rm nginx2 2>$null
}
Write-Host "[OK] Contenedor nginx2 procesado." -ForegroundColor Green

Write-Host "`n[COMPLETADO] Limpieza finalizada." -ForegroundColor Green
