#!/bin/bash
# ==============================================================================
# Script: cleanup.sh
# Descripción: Detención y eliminación segura de contenedores de la práctica.
# NOTA IMPORTANTE: Requiere confirmación explícita del usuario o el argumento --force.
# ==============================================================================

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${YELLOW}=====================================================${NC}"
echo -e "${YELLOW}  Limpieza Opcional de Contenedores de la Práctica   ${NC}"
echo -e "${YELLOW}=====================================================${NC}"
echo "Este script detendrá y eliminará ÚNICAMENTE los contenedores:"
echo "  - nginx1 (puerto 8089)"
echo "  - nginx2 (puerto 8090)"
echo "No afectará ningún otro contenedor, imagen o volumen del sistema."

CONFIRM="$1"

if [ "$CONFIRM" != "--force" ] && [ "$CONFIRM" != "-y" ]; then
    read -p "¿Está seguro de que desea detener y eliminar nginx1 y nginx2? (s/N): " RESP
    if [[ ! "$RESP" =~ ^[sS]$ ]]; then
        echo -e "${BLUE}Operación de limpieza cancelada por el usuario. No se modificó nada.${NC}"
        exit 0
    fi
fi

echo -e "\n${BLUE}--> Deteniendo y eliminando 'nginx1'...${NC}"
if docker ps -a --format '{{.Names}}' | grep -Eq '^nginx1$'; then
    docker stop nginx1 || true
    docker rm nginx1 || true
    echo -e "${GREEN}[OK] Contenedor 'nginx1' eliminado.${NC}"
else
    echo -e "${YELLOW}[INFO] El contenedor 'nginx1' no existía.${NC}"
fi

echo -e "\n${BLUE}--> Deteniendo y eliminando 'nginx2'...${NC}"
if docker ps -a --format '{{.Names}}' | grep -Eq '^nginx2$'; then
    docker stop nginx2 || true
    docker rm nginx2 || true
    echo -e "${GREEN}[OK] Contenedor 'nginx2' eliminado.${NC}"
else
    echo -e "${YELLOW}[INFO] El contenedor 'nginx2' no existía.${NC}"
fi

echo -e "\n${GREEN}[COMPLETADO] Limpieza finalizada.${NC}"
