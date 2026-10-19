# ==============================================================================
# Script: generate_audio.ps1
# Descripción: Generación de audio MP3 de reflexión (59-60 segundos) mediante TTS nativo de Windows.
# ==============================================================================

[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"

Add-Type -AssemblyName System.Speech
Add-Type -AssemblyName System.Runtime.WindowsRuntime

$projectDir = Split-Path -Parent $PSScriptRoot
$audioDir = Join-Path $projectDir "audio"
$wavPath = Join-Path $audioDir "reflexion_temp.wav"
$mp3Path = Join-Path $audioDir "reflexion.mp3"

Write-Host "Iniciando síntesis de audio para la práctica..." -ForegroundColor Cyan

$synth = New-Object System.Speech.Synthesis.SpeechSynthesizer
$voices = $synth.GetInstalledVoices().VoiceInfo
$esVoice = $voices | Where-Object { $_.Culture.Name -like "es-*" } | Select-Object -First 1

if ($esVoice) {
    $synth.SelectVoice($esVoice.Name)
    Write-Host "Voz seleccionada: $($esVoice.Name) ($($esVoice.Culture.Name))" -ForegroundColor Green
} else {
    Write-Host "Aviso: No se encontró voz en español, usando la predeterminada: $($synth.Voice.Name)" -ForegroundColor Yellow
}

# Velocidad normal (0) calibrada exactamente para una duración de 59-60 segundos
$synth.Rate = 0

# Guion calibrado exactamente para 59-60 segundos
$scriptText = @"
Hola. En esta práctica académica aprendí a implementar y personalizar dos servidores web independientes con Docker y Nginx.

El concepto central fue comprender la tecnología de contenedores: a diferencia de una máquina virtual tradicional, los contenedores comparten el núcleo del sistema operativo anfitrión, iniciando en segundos y con un uso muy eficiente de memoria.

Desplegué dos instancias aisladas de Nginx: el servidor institucional en el puerto 8089 y mi página personal en el puerto 8090. Aprendí cómo el mapeo de puertos redirige las peticiones externas hacia el puerto 80 interno de cada contenedor.

Mediante el comando docker cp, transferí mis archivos HTML personalizados a cada contenedor sin necesidad de reiniciar los servicios.

Esta experiencia práctica demostró la gran eficiencia, modularidad y aislamiento que ofrece Docker para la administración moderna de servidores web.
"@

# Generar archivo WAV temporal
$synth.SetOutputToWaveFile($wavPath)
$synth.Speak($scriptText)
$synth.Dispose()

Write-Host "WAV temporal generado. Codificando a MP3 mediante Windows Media Foundation..." -ForegroundColor Cyan

# Cargar tipos WinRT
[Windows.Storage.StorageFile, Windows.Storage, ContentType = WindowsRuntime] | Out-Null
[Windows.Storage.StorageFolder, Windows.Storage, ContentType = WindowsRuntime] | Out-Null
[Windows.Media.MediaProperties.MediaEncodingProfile, Windows.Media, ContentType = WindowsRuntime] | Out-Null
[Windows.Media.Transcoding.MediaTranscoder, Windows.Media, ContentType = WindowsRuntime] | Out-Null
[Windows.Media.Transcoding.PrepareTranscodeResult, Windows.Media, ContentType = WindowsRuntime] | Out-Null

$genericOpMethod = [System.WindowsRuntimeSystemExtensions].GetMethods() | Where-Object { 
    $_.Name -eq 'AsTask' -and $_.GetParameters().Count -eq 1 -and $_.IsGenericMethod -and $_.GetGenericArguments().Count -eq 1 -and $_.GetParameters()[0].ParameterType.Name -eq 'IAsyncOperation`1' 
} | Select-Object -First 1

$genericProgActionMethod = [System.WindowsRuntimeSystemExtensions].GetMethods() | Where-Object { 
    $_.Name -eq 'AsTask' -and $_.GetParameters().Count -eq 1 -and $_.IsGenericMethod -and $_.GetGenericArguments().Count -eq 1 -and $_.GetParameters()[0].ParameterType.Name -eq 'IAsyncActionWithProgress`1' 
} | Select-Object -First 1

$op = [Windows.Storage.StorageFile]::GetFileFromPathAsync($wavPath)
$task = $genericOpMethod.MakeGenericMethod([Windows.Storage.StorageFile]).Invoke($null, @($op))
$task.Wait()
$sourceFile = $task.Result

$folderOp = [Windows.Storage.StorageFolder]::GetFolderFromPathAsync($audioDir)
$task2 = $genericOpMethod.MakeGenericMethod([Windows.Storage.StorageFolder]).Invoke($null, @($folderOp))
$task2.Wait()
$folder = $task2.Result

$createOp = $folder.CreateFileAsync("reflexion.mp3", [Windows.Storage.CreationCollisionOption]::ReplaceExisting)
$task3 = $genericOpMethod.MakeGenericMethod([Windows.Storage.StorageFile]).Invoke($null, @($createOp))
$task3.Wait()
$destFile = $task3.Result

$profile = [Windows.Media.MediaProperties.MediaEncodingProfile]::CreateMp3([Windows.Media.MediaProperties.AudioEncodingQuality]::High)
$transcoder = New-Object Windows.Media.Transcoding.MediaTranscoder

$prepareOp = $transcoder.PrepareFileTranscodeAsync($sourceFile, $destFile, $profile)
$task4 = $genericOpMethod.MakeGenericMethod([Windows.Media.Transcoding.PrepareTranscodeResult]).Invoke($null, @($prepareOp))
$task4.Wait()
$prepareResult = $task4.Result

if ($prepareResult.CanTranscode) {
    $action = $prepareResult.TranscodeAsync()
    $task5 = $genericProgActionMethod.MakeGenericMethod([System.Double]).Invoke($null, @($action))
    $task5.Wait()
    Write-Host "[OK] Transcodificación a MP3 completada." -ForegroundColor Green
} else {
    Write-Host "[ERROR] No se pudo transcodificar a MP3: $($prepareResult.FailureReason)" -ForegroundColor Red
    exit 1
}

# Limpiar WAV temporal
if (Test-Path $wavPath) {
    Remove-Item $wavPath -Force
}

# Verificar metadatos y duración
$shell = New-Object -ComObject Shell.Application
$shFolder = $shell.Namespace($audioDir)
$shFile = $shFolder.ParseName("reflexion.mp3")
$duration = $shFolder.GetDetailsOf($shFile, 27)
$size = (Get-Item $mp3Path).Length

Write-Host "`n=====================================================" -ForegroundColor Green
Write-Host "  Archivo MP3 generado con éxito en: $mp3Path" -ForegroundColor Green
Write-Host "  Duración registrada: $duration" -ForegroundColor Green
Write-Host "  Tamaño del archivo:  $size bytes ($([math]::Round($size/1024, 1)) KB)" -ForegroundColor Green
Write-Host "=====================================================" -ForegroundColor Green
