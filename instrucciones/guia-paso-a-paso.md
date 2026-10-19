# Guía Paso a Paso: Práctica Nginx con Docker

Esta guía describe detalladamente el procedimiento técnico realizado para aprovisionar, aislar y personalizar dos servidores web Nginx mediante contenedores Docker en un entorno local (Windows con soporte WSL2 Ubuntu).

---

## 1. Requisitos Previos y Entorno de Trabajo
- **Sistema Operativo:** Windows 11 Home con Subsistema de Windows para Linux (WSL2 - Ubuntu 24.04).
- **Motor de Contenedores:** Docker versión 29.1.3 (daemon `dockerd` activo).
- **Control de Versiones:** Git 2.50.1 y GitHub CLI (`gh`).
- **Navegador Web:** Google Chrome / Microsoft Edge para pruebas visuales en `http://localhost:8089` y `http://localhost:8090`.

---

## 2. Fundamentos de la Arquitectura

### ¿Por qué Contenedores y no Máquinas Virtuales?
A diferencia de las máquinas virtuales completas que emulan hardware y ejecutan un sistema operativo huésped completo (consumiendo gigabytes de RAM y varios minutos de arranque), los contenedores Docker:
1. Comparten el núcleo (kernel) del sistema operativo anfitrión.
2. Utilizan características del kernel como `cgroups` (control groups) para limitar el uso de CPU y memoria.
3. Utilizan `namespaces` para aislar procesos, redes, usuarios y sistemas de archivos.
4. Arrancan en milisegundos y consumen apenas megabytes de memoria RAM.

### Mapeo de Puertos (Port Forwarding)
Cada contenedor tiene su propia pila de red con una dirección IP interna en una red bridge virtual privada (por ejemplo, `172.17.0.x`). Para que un usuario o navegador en el equipo físico (host) pueda acceder al servidor web del contenedor:
- El parámetro `-p 8089:80` establece una regla de redirección: cualquier petición TCP recibida en el puerto `8089` del host es redirigida al puerto `80` (puerto HTTP estándar donde escucha Nginx) dentro del contenedor `nginx1`.
- De igual modo, `-p 8090:80` redirige el tráfico del puerto `8090` del host al puerto `80` del contenedor `nginx2`.
- Gracias a esto, no hay colisión de puertos entre los dos contenedores a pesar de que ambos escuchan internamente en el puerto 80.

---

## 3. Secuencia de Comandos de Referencia

### Paso 1: Despliegue de los Contenedores
```bash
# Desplegar el servidor web 1 (Institucional) en segundo plano en el puerto 8089
docker run -d --name nginx1 -p 8089:80 nginx

# Desplegar el servidor web 2 (Personal) en segundo plano en el puerto 8090
docker run -d --name nginx2 -p 8090:80 nginx
```
*Explicación de modificadores:*
- `-d`: Ejecuta el contenedor en modo detached (en segundo plano), liberando la terminal.
- `--name <nombre>`: Asigna un identificador amigable al contenedor en lugar de usar un hash aleatorio.
- `-p <puerto_host>:<puerto_contenedor>`: Publica y mapea los puertos de red.
- `nginx`: Especifica la imagen oficial de Nginx desde Docker Hub.

### Paso 2: Extracción de la Plantilla Original
Para estudiar la estructura HTML por defecto que ofrece Nginx:
```bash
# Extraer index.html original del contenedor 1 hacia el directorio local
docker cp nginx1:/usr/share/nginx/html/index.html ./index1.html

# Extraer index.html original del contenedor 2 hacia el directorio local
docker cp nginx2:/usr/share/nginx/html/index.html ./index2.html
```

### Paso 3: Personalización de Contenidos
Se editaron los archivos locales para crear:
- `index1.html`: Página institucional corporativa con paleta azul marino, tarjetas informativas de la carrera, módulo y campos editables.
- `index2.html`: Página personal elegante con temática oscura moderna, biografía, perfil tecnológico y aprendizajes clave.

### Paso 4: Inyección de Contenidos a los Contenedores
```bash
# Inyectar el index1.html personalizado en nginx1
docker cp index1.html nginx1:/usr/share/nginx/html/index.html

# Inyectar el index2.html personalizado en nginx2
docker cp index2.html nginx2:/usr/share/nginx/html/index.html
```
*Nota:* Nginx sirve los archivos estáticos directamente desde el disco en cada petición, por lo que no fue necesario reiniciar ni detener los contenedores para reflejar los cambios.

---

## 4. Verificación Automatizada

Para comprobar la salud de ambos servidores:
```bash
# En Linux/WSL:
./scripts/verify.sh

# En Windows PowerShell:
.\scripts\verify.ps1
```

El script verifica:
1. Que los contenedores `nginx1` y `nginx2` estén en estado `Up`.
2. Que una petición HTTP GET a `http://localhost:8089` devuelva código `200 OK`.
3. Que una petición HTTP GET a `http://localhost:8090` devuelva código `200 OK`.
4. Que el título HTML coincida con las páginas personalizadas.

---

## 5. Limpieza Segura (Opcional)

Si en el futuro se desea retirar los contenedores creados sin afectar otros servicios:
```bash
# En Linux/WSL (solicita confirmación interactiva):
./scripts/cleanup.sh

# En Windows PowerShell (solicita confirmación interactiva):
.\scripts\cleanup.ps1
```
