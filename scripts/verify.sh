#!/bin/bash
# ==============================================================================
# Script: verify.sh
# Descripción: Comprobación del estado de contenedores y respuestas HTTP en puertos 8089 y 8090.
# ==============================================================================

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}=====================================================${NC}"
echo -e "${BLUE}  Verificación de Estado y Conectividad HTTP         ${NC}"
echo -e "${BLUE}=====================================================${NC}"

# 1. Comprobar Docker
if ! command -v docker &> /dev/null; then
    echo -e "${RED}[ERROR] Docker no está en el PATH.${NC}"
    exit 1
fi

# 2. Comprobar estado de los contenedores
echo -e "\n${BLUE}--> 1. Verificando estado de contenedores con 'docker ps':${NC}"
docker ps --filter "name=nginx" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

# Comprobar si nginx1 está corriendo
if docker ps --format '{{.Names}}' | grep -Eq '^nginx1$'; then
    echo -e "${GREEN}[OK] Contenedor 'nginx1' está en ejecución.${NC}"
else
    echo -e "${RED}[FALLO] Contenedor 'nginx1' no está en ejecución.${NC}"
fi

# Comprobar si nginx2 está corriendo
if docker ps --format '{{.Names}}' | grep -Eq '^nginx2$'; then
    echo -e "${GREEN}[OK] Contenedor 'nginx2' está en ejecución.${NC}"
else
    echo -e "${RED}[FALLO] Contenedor 'nginx2' no está en ejecución.${NC}"
fi

# 3. Comprobación HTTP Puerto 8089 (nginx1)
echo -e "\n${BLUE}--> 2. Verificando respuesta HTTP en http://localhost:8089 (nginx1):${NC}"
HTTP_CODE_1=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8089 || echo "000")
if [ "$HTTP_CODE_1" = "200" ]; then
    echo -e "${GREEN}[OK] Código HTTP: $HTTP_CODE_1 OK en puerto 8089${NC}"
    CONTENT_TITLE_1=$(curl -s http://localhost:8089 | grep -o "<title>[^<]*" | sed 's/<title>//' || echo "Sin título")
    echo -e "     Título detectado: \"$CONTENT_TITLE_1\""
else
    echo -e "${RED}[FALLO] No se obtuvo HTTP 200 en http://localhost:8089 (Código: $HTTP_CODE_1)${NC}"
fi

# 4. Comprobación HTTP Puerto 8090 (nginx2)
echo -e "\n${BLUE}--> 3. Verificando respuesta HTTP en http://localhost:8090 (nginx2):${NC}"
HTTP_CODE_2=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8090 || echo "000")
if [ "$HTTP_CODE_2" = "200" ]; then
    echo -e "${GREEN}[OK] Código HTTP: $HTTP_CODE_2 OK en puerto 8090${NC}"
    CONTENT_TITLE_2=$(curl -s http://localhost:8090 | grep -o "<title>[^<]*" | sed 's/<title>//' || echo "Sin título")
    echo -e "     Título detectado: \"$CONTENT_TITLE_2\""
else
    echo -e "${RED}[FALLO] No se obtuvo HTTP 200 en http://localhost:8090 (Código: $HTTP_CODE_2)${NC}"
fi

# Resumen final
echo -e "\n${BLUE}=====================================================${NC}"
if [ "$HTTP_CODE_1" = "200" ] && [ "$HTTP_CODE_2" = "200" ]; then
    echo -e "${GREEN}  ✓ TODOS LOS TESTS PASARON EXITOSAMENTE            ${NC}"
    echo -e "${GREEN}  Ambos servidores responden y están aislados.       ${NC}"
    echo -e "${BLUE}=====================================================${NC}"
    exit 0
else
    echo -e "${RED}  ✗ HUBO ERRORES EN LA VERIFICACIÓN                 ${NC}"
    echo -e "${BLUE}=====================================================${NC}"
    exit 1
fi
