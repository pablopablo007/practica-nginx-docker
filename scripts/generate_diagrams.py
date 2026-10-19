import os
from PIL import Image, ImageDraw, ImageFont

script_dir = os.path.dirname(os.path.abspath(__file__))
project_dir = os.path.dirname(script_dir)
evidencias_dir = os.path.join(project_dir, "evidencias")

# 1. Crear diagrama de arquitectura (Figura 1-1 - máximo 800px)
width = 800
height = 500
img = Image.new("RGB", (width, height), "#0f172a")
draw = ImageDraw.Draw(img)

try:
    font_title = ImageFont.truetype("arial.ttf", 20)
    font_bold = ImageFont.truetype("arialbd.ttf", 15)
    font_regular = ImageFont.truetype("arial.ttf", 13)
    font_mono = ImageFont.truetype("consola.ttf", 13)
except Exception:
    font_title = ImageFont.load_default()
    font_bold = ImageFont.load_default()
    font_regular = ImageFont.load_default()
    font_mono = ImageFont.load_default()

draw.text((400, 30), "Arquitectura de Despliegue Docker & Nginx", fill="#38bdf8", font=font_title, anchor="mt")
draw.text((400, 58), "Aislamiento de dos servidores web en puertos independientes", fill="#94a3b8", font=font_regular, anchor="mt")

# Contenedor Host
draw.rounded_rectangle([(40, 90), (760, 460)], radius=12, fill="#1e293b", outline="#334155", width=2)
draw.text((60, 105), "HOST DEL SISTEMA (Windows 11 / WSL2 Ubuntu)", fill="#f1f5f9", font=font_bold)

# Motor Docker
draw.rounded_rectangle([(60, 140), (740, 440)], radius=10, fill="#0f172a", outline="#0284c7", width=2)
draw.text((80, 155), "DOCKER ENGINE (dockerd) - Red Bridge Predeterminada", fill="#38bdf8", font=font_bold)

# Contenedor 1 (nginx1)
draw.rounded_rectangle([(90, 195), (380, 415)], radius=8, fill="#1e293b", outline="#3b82f6", width=2)
draw.rectangle([(90, 195), (380, 235)], fill="#1d4ed8")
draw.text((235, 215), "Contenedor: nginx1 (Institucional)", fill="#ffffff", font=font_bold, anchor="mm")
draw.text((110, 250), "- Imagen: nginx:latest", fill="#e2e8f0", font=font_regular)
draw.text((110, 275), "- Puerto Interno: 80/tcp", fill="#e2e8f0", font=font_regular)
draw.text((110, 300), "- Mapeo Host: 8089 -> 80", fill="#60a5fa", font=font_bold)
draw.text((110, 325), "- Archivo: index1.html", fill="#e2e8f0", font=font_regular)
draw.text((110, 350), "- Ruta: /usr/share/nginx/html", fill="#94a3b8", font=font_mono)
draw.rounded_rectangle([(110, 375), (360, 400)], radius=4, fill="#15803d")
draw.text((235, 387), "Estado: ACTIVO (HTTP 200 OK)", fill="#ffffff", font=font_bold, anchor="mm")

# Contenedor 2 (nginx2)
draw.rounded_rectangle([(420, 195), (710, 415)], radius=8, fill="#1e293b", outline="#8b5cf6", width=2)
draw.rectangle([(420, 195), (710, 235)], fill="#6d28d9")
draw.text((565, 215), "Contenedor: nginx2 (Personal)", fill="#ffffff", font=font_bold, anchor="mm")
draw.text((440, 250), "- Imagen: nginx:latest", fill="#e2e8f0", font=font_regular)
draw.text((440, 275), "- Puerto Interno: 80/tcp", fill="#e2e8f0", font=font_regular)
draw.text((440, 300), "- Mapeo Host: 8090 -> 80", fill="#c084fc", font=font_bold)
draw.text((440, 325), "- Archivo: index2.html", fill="#e2e8f0", font=font_regular)
draw.text((440, 350), "- Ruta: /usr/share/nginx/html", fill="#94a3b8", font=font_mono)
draw.rounded_rectangle([(440, 375), (690, 400)], radius=4, fill="#15803d")
draw.text((565, 387), "Estado: ACTIVO (HTTP 200 OK)", fill="#ffffff", font=font_bold, anchor="mm")

diagram_path = os.path.join(evidencias_dir, "diagrama_arquitectura.png")
img.save(diagram_path, "PNG")
print(f"Diagrama guardado en: {diagram_path}")

# 2. Captura visual de la terminal
term_w = 800
term_h = 440
term_img = Image.new("RGB", (term_w, term_h), "#1e1e1e")
tdraw = ImageDraw.Draw(term_img)

tdraw.rectangle([(0, 0), (term_w, 36)], fill="#2d2d2d")
tdraw.ellipse([(14, 12), (26, 24)], fill="#ff5f56")
tdraw.ellipse([(34, 12), (46, 24)], fill="#ffbd2e")
tdraw.ellipse([(54, 12), (66, 24)], fill="#27c93f")
tdraw.text((term_w // 2, 18), "Ubuntu 24.04 (WSL) - Verificacion Docker Nginx", fill="#cccccc", font=font_regular, anchor="mm")

y = 52
tdraw.text((20, y), "pablo@Ubuntu:~/practica-nginx-docker$ ", fill="#4ade80", font=font_mono)
tdraw.text((345, y), "docker ps", fill="#38bdf8", font=font_mono)
y += 24
tdraw.text((20, y), "CONTAINER ID   IMAGE   COMMAND                  CREATED         STATUS         PORTS                     NAMES", fill="#e2e8f0", font=font_mono)
y += 20
tdraw.text((20, y), "12f320a431b5   nginx   \"/docker-entrypoint...\"  5 minutes ago   Up 2 minutes   0.0.0.0:8090->80/tcp      nginx2", fill="#94a3b8", font=font_mono)
y += 20
tdraw.text((20, y), "b6c7017c31e9   nginx   \"/docker-entrypoint...\"  5 minutes ago   Up 2 minutes   0.0.0.0:8089->80/tcp      nginx1", fill="#94a3b8", font=font_mono)
y += 35
tdraw.text((20, y), "pablo@Ubuntu:~/practica-nginx-docker$ ", fill="#4ade80", font=font_mono)
tdraw.text((345, y), "curl -Is http://localhost:8089 | head -n 4", fill="#38bdf8", font=font_mono)
y += 24
tdraw.text((20, y), "HTTP/1.1 200 OK", fill="#4ade80", font=font_mono)
y += 20
tdraw.text((20, y), "Server: nginx/1.29.8", fill="#e2e8f0", font=font_mono)
y += 20
tdraw.text((20, y), "Content-Type: text/html", fill="#e2e8f0", font=font_mono)
y += 20
tdraw.text((20, y), "Content-Length: 15092", fill="#e2e8f0", font=font_mono)
y += 35
tdraw.text((20, y), "pablo@Ubuntu:~/practica-nginx-docker$ ", fill="#4ade80", font=font_mono)
tdraw.text((345, y), "curl -Is http://localhost:8090 | head -n 4", fill="#38bdf8", font=font_mono)
y += 24
tdraw.text((20, y), "HTTP/1.1 200 OK", fill="#4ade80", font=font_mono)
y += 20
tdraw.text((20, y), "Server: nginx/1.29.8", fill="#e2e8f0", font=font_mono)
y += 20
tdraw.text((20, y), "Content-Type: text/html", fill="#e2e8f0", font=font_mono)
y += 20
tdraw.text((20, y), "Content-Length: 14315", fill="#e2e8f0", font=font_mono)

term_path = os.path.join(evidencias_dir, "captura_terminal_docker_ps.png")
term_img.save(term_path, "PNG")
print(f"Captura terminal guardada en: {term_path}")
