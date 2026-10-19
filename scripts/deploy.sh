#!/bin/bash
# ==============================================================================
# Script: deploy.sh
# Descripción: Despliegue seguro de dos servidores web Nginx en contenedores Docker.
# Práctica: Crear y personalizar dos servidores web con Nginx usando Docker.
# Puertos: nginx1 -> 8089:80 | nginx2 -> 8090:80
# ==============================================================================

set -e

# Colores para salida informativa
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=====================================================${NC}"
echo -e "${BLUE}  Despliegue Seguro de Servidores Nginx con Docker  ${NC}"
echo -e "${BLUE}=====================================================${NC}"

# 1. Comprobar que Docker está instalado y en ejecución
if ! command -v docker &> /dev/null; then
    echo -e "${RED}[ERROR] Docker no está instalado en el sistema o no está en el PATH.${NC}"
    echo -e "${YELLOW}Por favor, instale Docker o inicie Docker Desktop / servicio dockerd.${NC}"
    exit 1
fi

if ! docker info &> /dev/null; then
    echo -e "${RED}[ERROR] El demonio de Docker (dockerd) no está en ejecución.${NC}"
    echo -e "${YELLOW}Inicie el servicio de Docker antes de continuar (ejemplo: sudo systemctl start docker).${NC}"
    exit 1
fi

echo -e "${GREEN}[OK] Docker está instalado y activo.${NC}"

# Obtener directorio base del script y del proyecto
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

cd "$PROJECT_DIR"

# Verificar existencia de archivos HTML
if [ ! -f "index1.html" ]; then
    echo -e "${RED}[ERROR] No se encontró index1.html en $PROJECT_DIR${NC}"
    exit 1
fi

if [ ! -f "index2.html" ]; then
    echo -e "${RED}[ERROR] No se encontró index2.html en $PROJECT_DIR${NC}"
    exit 1
fi

# 2. Despliegue de nginx1 (Puerto 8089)
echo -e "\n${BLUE}--> Verificando contenedor 'nginx1'...${NC}"
if docker ps -a --format '{{.Names}}' | grep -Eq '^nginx1$'; then
    STATUS=$(docker inspect --format '{{.State.Status}}' nginx1)
    echo -e "${YELLOW}[AVISO] El contenedor 'nginx1' ya existe (Estado: $STATUS).${NC}"
    if [ "$STATUS" != "running" ]; then
        echo -e "${YELLOW}Iniciando contenedor 'nginx1' existente sin destruirlo...${NC}"
        docker start nginx1
    fi
else
    echo -e "${BLUE}Creando y arrancando contenedor 'nginx1' en puerto 8089:80...${NC}"
    docker run -d --name nginx1 -p 8089:80 nginx
    echo -e "${GREEN}[OK] Contenedor 'nginx1' creado con éxito.${NC}"
fi

# 3. Despliegue de nginx2 (Puerto 8090)
echo -e "\n${BLUE}--> Verificando contenedor 'nginx2'...${NC}"
if docker ps -a --format '{{.Names}}' | grep -Eq '^nginx2$'; then
    STATUS=$(docker inspect --format '{{.State.Status}}' nginx2)
    echo -e "${YELLOW}[AVISO] El contenedor 'nginx2' ya existe (Estado: $STATUS).${NC}"
    if [ "$STATUS" != "running" ]; then
        echo -e "${YELLOW}Iniciando contenedor 'nginx2' existente sin destruirlo...${NC}"
        docker start nginx2
    fi
else
    echo -e "${BLUE}Creando y arrancando contenedor 'nginx2' en puerto 8090:80...${NC}"
    docker run -d --name nginx2 -p 8090:80 nginx
    echo -e "${GREEN}[OK] Contenedor 'nginx2' creado con éxito.${NC}"
fi

# 4. Copia segura de los HTML personalizados a cada contenedor
echo -e "\n${BLUE}--> Copiando páginas personalizadas con 'docker cp'...${NC}"
docker cp index1.html nginx1:/usr/share/nginx/html/index.html
echo -e "${GREEN}[OK] index1.html copiado a nginx1:/usr/share/nginx/html/index.html${NC}"

docker cp index2.html nginx2:/usr/share/nginx/html/index.html
echo -e "${GREEN}[OK] index2.html copiado a nginx2:/usr/share/nginx/html/index.html${NC}"

echo -e "\n${GREEN}=====================================================${NC}"
echo -e "${GREEN}  ¡Despliegue finalizado con éxito!                  ${NC}"
echo -e "${GREEN}  - Servidor Institucional: http://localhost:8089     ${NC}"
echo -e "${GREEN}  - Servidor Personal:      http://localhost:8090     ${NC}"
echo -e "${GREEN}=====================================================${NC}"
echo -e "${YELLOW}Para verificar las respuestas HTTP ejecute: ./scripts/verify.sh${NC}"
