# Hoja de Referencia de Comandos: Docker & Nginx

Resumen rápido de comandos utilizados en la práctica académica y comandos de utilidad para administración.

---

## 1. Comandos de la Práctica

| Acción | Comando | Descripción |
| :--- | :--- | :--- |
| **Crear y arrancar nginx1** | `docker run -d --name nginx1 -p 8089:80 nginx` | Levanta contenedor en puerto 8089 en segundo plano |
| **Crear y arrancar nginx2** | `docker run -d --name nginx2 -p 8090:80 nginx` | Levanta contenedor en puerto 8090 en segundo plano |
| **Extraer index original** | `docker cp nginx1:/usr/share/nginx/html/index.html ./index1.html` | Copia archivo del contenedor al anfitrión |
| **Inyectar index1 custom** | `docker cp index1.html nginx1:/usr/share/nginx/html/index.html` | Copia archivo del anfitrión al contenedor |
| **Inyectar index2 custom** | `docker cp index2.html nginx2:/usr/share/nginx/html/index.html` | Copia archivo del anfitrión al contenedor |
| **Ver estado de contenedores**| `docker ps` | Muestra contenedores activos, puertos y nombres |
| **Probar respuesta HTTP** | `curl -I http://localhost:8089` | Solicita encabezados HTTP en puerto 8089 |
| **Probar respuesta HTTP** | `curl -I http://localhost:8090` | Solicita encabezados HTTP en puerto 8090 |

---

## 2. Comandos de Inspección y Diagnóstico

```bash
# Ver todos los contenedores (activos y detenidos)
docker ps -a

# Ver registros (logs) en tiempo real de nginx1
docker logs -f nginx1

# Ver consumo de CPU y memoria de los contenedores
docker stats nginx1 nginx2 --no-stream

# Inspeccionar configuración completa (IP, montajes, red)
docker inspect nginx1

# Abrir una terminal interactiva dentro del contenedor
docker exec -it nginx1 bash
```

---

## 3. Comandos de Ciclo de Vida y Limpieza

```bash
# Detener contenedores
docker stop nginx1 nginx2

# Iniciar contenedores previamente detenidos
docker start nginx1 nginx2

# Reiniciar servidores web
docker restart nginx1 nginx2

# Eliminar contenedores (deben estar detenidos)
docker rm nginx1 nginx2

# Forzar detención y eliminación inmediata
docker rm -f nginx1 nginx2
```
