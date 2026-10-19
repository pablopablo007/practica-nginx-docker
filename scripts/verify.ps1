# ==============================================================================
# Script: verify.ps1
# Descripción: Verificación del estado de contenedores y respuestas HTTP en 8089 y 8090.
# ==============================================================================

[CmdletBinding()]
param()

$useWsl = $false
if (Get-Command docker -ErrorAction SilentlyContinue) {
    try { & docker version | Out-Null; $useWsl = $false } catch { $useWsl = $true }
} else {
    $useWsl = $true
}

Write-Host "=====================================================" -ForegroundColor Cyan
Write-Host "  Verificación de Estado y Conectividad HTTP         " -ForegroundColor Cyan
Write-Host "=====================================================" -ForegroundColor Cyan

# 1. Comprobar contenedores
Write-Host "`n--> 1. Estado de los contenedores:" -ForegroundColor Cyan
if ($useWsl) {
    wsl docker ps --filter "name=nginx" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
} else {
    docker ps --filter "name=nginx" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
}

# 2. Comprobar HTTP 8089 (nginx1)
Write-Host "`n--> 2. Verificando http://localhost:8089 (nginx1 - Institucional):" -ForegroundColor Cyan
$success1 = $false
try {
    $resp1 = Invoke-WebRequest -Uri "http://localhost:8089" -UseBasicParsing -TimeoutSec 5
    if ($resp1.StatusCode -eq 200) {
        Write-Host "  [OK] Código HTTP: 200 OK" -ForegroundColor Green
        if ($resp1.Content -match "<title>([^<]+)</title>") {
            Write-Host "  [OK] Título: $($matches[1].Trim())" -ForegroundColor Green
        }
        $success1 = $true
    }
} catch {
    Write-Host "  [FALLO] No se pudo conectar a http://localhost:8089 - $($_.Exception.Message)" -ForegroundColor Red
}

# 3. Comprobar HTTP 8090 (nginx2)
Write-Host "`n--> 3. Verificando http://localhost:8090 (nginx2 - Personal):" -ForegroundColor Cyan
$success2 = $false
try {
    $resp2 = Invoke-WebRequest -Uri "http://localhost:8090" -UseBasicParsing -TimeoutSec 5
    if ($resp2.StatusCode -eq 200) {
        Write-Host "  [OK] Código HTTP: 200 OK" -ForegroundColor Green
        if ($resp2.Content -match "<title>([^<]+)</title>") {
            Write-Host "  [OK] Título: $($matches[1].Trim())" -ForegroundColor Green
        }
        $success2 = $true
    }
} catch {
    Write-Host "  [FALLO] No se pudo conectar a http://localhost:8090 - $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`n=====================================================" -ForegroundColor Cyan
if ($success1 -and $success2) {
    Write-Host "  ✓ VERIFICACIÓN EXITOSA: Ambos servidores responden   " -ForegroundColor Green
    Write-Host "=====================================================" -ForegroundColor Cyan
    exit 0
} else {
    Write-Host "  ✗ LA VERIFICACIÓN ENCONTRÓ PROBLEMAS                " -ForegroundColor Red
    Write-Host "=====================================================" -ForegroundColor Cyan
    exit 1
}
