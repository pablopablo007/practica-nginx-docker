# Guion de Reflexión y Aprendizajes: Práctica Nginx con Docker

## Información del Audio
- **Archivo de destino:** `reflexion.mp3` (en esta misma carpeta `audio/`)
- **Estado:** Pendiente de grabación por parte del estudiante con su propia voz.
- **Formato sugerido:** MPEG Audio Layer 3 (MP3) o audio grabado en smartphone/computadora.
- **Duración objetivo:** Aproximadamente 60 segundos (~50 a 65 segundos).
- **Conteo de palabras del texto:** ~130 palabras (lectura fluida a ritmo natural).

---

## Texto del Guion (Lectura en Primera Persona)

> "Hola. En esta práctica académica aprendí a implementar y personalizar dos servidores web independientes con Docker y Nginx.
> 
> El concepto central fue comprender la tecnología de contenedores: a diferencia de una máquina virtual tradicional, los contenedores comparten el núcleo del sistema operativo anfitrión, iniciando en segundos y con un uso muy eficiente de memoria.
> 
> Desplegué dos instancias aisladas de Nginx: el servidor institucional en el puerto 8089 y mi página personal en el puerto 8090. Aprendí cómo el mapeo de puertos redirige las peticiones externas hacia el puerto 80 interno de cada contenedor.
> 
> Mediante el comando `docker cp`, transferí mis archivos HTML personalizados a cada contenedor sin necesidad de reiniciar los servicios.
> 
> Esta experiencia práctica demostró la gran eficiencia, modularidad y aislamiento que ofrece Docker para la administración moderna de servidores web."

---

## Estructura Temática del Guion
1. **Introducción (0-10s):** Presentación del contexto de la práctica académica con Docker y servidores web Nginx.
2. **Concepto Clave de Contenedores (10-25s):** Diferenciación entre virtualización pesada (máquinas virtuales) y virtualización ligera a nivel de sistema operativo (contenedores compartiendo kernel).
3. **Despliegue y Mapeo de Puertos (25-42s):** Aislamiento de dos instancias (`nginx1` en puerto `8089:80` e `nginx2` en puerto `8090:80`).
4. **Manipulación de Archivos en Caliente (42-52s):** Uso del comando `docker cp` para inyección de páginas HTML5 personalizadas sin detener los contenedores.
5. **Conclusión y Reflexión (52-60s):** Valor de Docker en la industria moderna de TI, microservicios y DevOps.

---

## Instrucciones para Grabar tu Propia Voz (Opcional)

Si deseas entregar el audio con tu propia voz grabada en lugar de la voz generada automáticamente:

### Opción A: Grabadora de Sonido de Windows
1. Presiona `Inicio` y escribe **Grabadora de sonido**.
2. Conecta tu micrófono o usa el del portátil/auriculares.
3. Lee el guion anterior en voz alta de forma pausada y natural (toma aproximadamente 60 segundos).
4. Guarda la grabación. En la configuración de la grabadora puedes elegir formato MP3, o convertir el archivo `.m4a` a `.mp3`.
5. Sobrescribe el archivo [`audio/reflexion.mp3`](reflexion.mp3) con tu archivo grabado.

### Opción B: Celular (Smartphone)
1. Abre la aplicación de notas de voz en tu teléfono móvil.
2. Graba la lectura del guion asegurándote de no tener ruido de fondo.
3. Envía el archivo de audio a tu computadora (por correo, cable USB o WhatsApp Web).
4. Conviértelo a formato MP3 si tu celular lo guardó en `.m4a` o `.aac` (usando una herramienta como Audacity o el conversor nativo).
5. Guarda el archivo resultante como `practica-nginx-docker/audio/reflexion.mp3`.
