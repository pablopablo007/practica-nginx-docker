# Instrucciones para Publicación en GitHub

Este documento describe el procedimiento seguro para publicar el repositorio local `practica-nginx-docker` en tu cuenta de GitHub.

---

## Estado Actual de la Preparación
- Repositorio Git local: Preparado e inicializado con todos los archivos de la práctica.
- Archivo `.gitignore`: Configurado para ignorar temporales, logs y secretos.
- Autenticación: Se detectó que el cliente GitHub CLI (`gh`) se encuentra autenticado en este equipo con el usuario `pablopablo007`.

> **IMPORTANTE:** Conforme a las directrices de seguridad, no se ha publicado ni enviado ningún cambio al repositorio remoto de forma automática. La publicación requiere tu autorización y ejecución explícita.

---

## Método 1: Publicación Automática con GitHub CLI (Recomendado)

Si deseas crear el repositorio remoto y subir los cambios en un solo comando:

```powershell
# 1. Navegar a la carpeta del proyecto
cd "C:\Users\pablo\.gemini\antigravity\scratch\practica-nginx-docker"

# 2. Crear el repositorio público en GitHub y subir la rama principal
gh repo create practica-nginx-docker --public --source=. --remote=origin --push
```

Si prefieres que el repositorio sea privado inicialmente:
```powershell
gh repo create practica-nginx-docker --private --source=. --remote=origin --push
```

---

## Método 2: Creación Manual en la Web de GitHub

Si prefieres crearlo desde la interfaz web de GitHub:

1. Ve a [https://github.com/new](https://github.com/new).
2. En **Repository name**, escribe: `practica-nginx-docker`.
3. Selecciona la visibilidad (**Public** o **Private** según lo requerido por tu docente).
4. **NO** marques las casillas "Add a README file", "Add .gitignore" ni "Choose a license" (ya están creados en este proyecto).
5. Haz clic en **Create repository**.
6. En tu terminal (PowerShell o Git Bash), ejecuta los siguientes comandos:

```powershell
cd "C:\Users\pablo\.gemini\antigravity\scratch\practica-nginx-docker"

# Renombrar rama a main si es necesario
git branch -M main

# Vincular al repositorio remoto creado (reemplaza con tu usuario si fuera distinto)
git remote add origin https://github.com/pablopablo007/practica-nginx-docker.git

# Enviar los commits a GitHub
git push -u origin main
```

---

## Verificación Posterior a la Publicación
Una vez completado el push:
1. Abre tu navegador en `https://github.com/pablopablo007/practica-nginx-docker`.
2. Verifica que el archivo `README.md` se visualice en la página principal con las imágenes de la carpeta `evidencias/`.
3. Comprueba que el archivo de audio [`audio/reflexion.mp3`](../audio/reflexion.mp3) esté accesible para reproducirse o descargarse.
