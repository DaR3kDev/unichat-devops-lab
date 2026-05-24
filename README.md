<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
</head>
<body>

  <h1>unichat-devops-lab</h1>

  <p>
    Laboratorio DevOps para desplegar el stack completo de <strong>UNI-CHAT</strong> con Docker Compose:
    API, MongoDB, Redis, RabbitMQ, Nginx, Portainer, Seq, Dozzle y más,
    todo controlado desde un <code>Makefile</code>.
  </p>

  <hr />

  <h2>Índice</h2>
  <ul>
    <li><a href="#inicio-rapido">Inicio rápido</a></li>
    <li><a href="#requisitos">Requisitos previos</a></li>
    <li><a href="#instalar-make">Instalación de Make</a></li>
    <li><a href="#clonar">Clonar el repositorio</a></li>
    <li><a href="#env">Configuración del .env</a></li>
    <li><a href="#makefile">Makefile — Comandos disponibles</a></li>
    <li><a href="#servicios">Servicios disponibles</a></li>
    <li><a href="#problemas">Solución de problemas</a></li>
  </ul>

  <hr />

  <h2 id="inicio-rapido">Inicio rápido</h2>

  <pre><code># 1. Instalar Make
sudo apt update &amp;&amp; sudo apt upgrade -y
sudo apt install make -y

# 2. Clonar el repositorio
git clone https://github.com/DaR3kDev/unichat-devops-lab.git
cd unichat-devops-lab

# 3. Crear el archivo .env (ver sección de configuración)
nano .env

# 4. Levantar todo el stack
make up
</code></pre>

  <p>Una vez corriendo, ejecuta <code>make help</code> para ver el panel de control con todas las URLs y comandos disponibles.</p>

  <hr />

  <h2 id="requisitos">Requisitos previos</h2>

  <table border="1" cellpadding="6" cellspacing="0">
    <thead>
      <tr>
        <th>Herramienta</th>
        <th>Linux / WSL</th>
        <th>Notas</th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <td>Docker + Compose v2</td>
        <td>Docker Engine</td>
        <td>Obligatorio</td>
      </tr>
      <tr>
        <td>GNU Make</td>
        <td><code>apt install make</code></td>
        <td>Ver sección de instalación</td>
      </tr>
      <tr>
        <td>Git</td>
        <td><code>apt install git</code></td>
        <td>Para clonar el repo</td>
      </tr>
      <tr>
        <td>Bash</td>
        <td>Incluido en Linux / WSL2</td>
        <td>Requerido por el Makefile</td>
      </tr>
    </tbody>
  </table>

  <p><strong>Nota:</strong> En Windows se recomienda usar <strong>WSL2</strong> para ejecutar todos los comandos sin inconvenientes.</p>

  <hr />

  <h2 id="instalar-make">Instalación de Make</h2>

  <p>Antes de usar el <code>Makefile</code>, asegúrate de tener <code>make</code> instalado en tu sistema.</p>

  <h3>Paso 1 — Actualizar paquetes del sistema</h3>
  <pre><code>sudo apt update &amp;&amp; sudo apt upgrade -y</code></pre>

  <h3>Paso 2 — Instalar Make</h3>
  <pre><code>sudo apt install make -y</code></pre>

  <h3>Paso 3 — Verificar instalación</h3>
  <pre><code>make --version</code></pre>

  <p>Deberías ver algo como:</p>
  <pre><code>GNU Make 4.3
Built for x86_64-pc-linux-gnu</code></pre>

  <hr />

  <h2 id="clonar">Clonar el repositorio</h2>

  <pre><code># Clonar desde GitHub
git clone https://github.com/DaR3kDev/unichat-devops-lab.git

# Ingresar a la carpeta del proyecto
cd unichat-devops-lab</code></pre>

  <hr />

  <h2 id="env">Configuración del .env</h2>

  <p>Crea un archivo <code>.env</code> en la raíz del proyecto con el siguiente contenido:</p>

  <pre><code># =========================
# CONFIG
# =========================
PROD_FILE=docker-compose.prod.yml
TOOLS_FILE=docker-compose.tools.yml</code></pre>

  <p><strong>⚠️ Importante:</strong> No subas este archivo a Git. Asegúrate de que <code>.env</code> esté en tu <code>.gitignore</code>.</p>

  <h3>¿Cómo detecta la IP el Makefile?</h3>

  <p>El <code>Makefile</code> detecta automáticamente tu IP local real según el sistema operativo:</p>

  <table border="1" cellpadding="6" cellspacing="0">
    <thead>
      <tr>
        <th>Sistema</th>
        <th>Método de detección</th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <td>Linux / WSL2</td>
        <td><code>hostname -I</code> → primer resultado</td>
      </tr>
      <tr>
        <td>Windows (PowerShell)</td>
        <td>Interfaz Wi-Fi activa sin IP <code>169.x.x.x</code></td>
      </tr>
      <tr>
        <td>Sin detección</td>
        <td>Fallback a <code>127.0.0.1</code></td>
      </tr>
    </tbody>
  </table>

  <hr />

  <h2 id="makefile">Makefile — Comandos disponibles</h2>

  <p>Ejecuta <code>make help</code> desde la raíz del proyecto para ver el panel de control completo:</p>

  <pre><code>======================================
 🚀 UNI-CHAT SERVER CONTROL PANEL
======================================

 🌐 IP LOCAL (RED REAL): http://&lt;TU_IP&gt;

 📡 SERVICIOS DISPONIBLES:
 🔥 API:
   SCALAR API    -&gt; http://&lt;TU_IP&gt;/scalar
 🐇 RABBITMQ:
   RABBIT UI     -&gt; http://&lt;TU_IP&gt;:15672
 🍃 MONGODB:
   MONGO EXPRESS -&gt; http://&lt;TU_IP&gt;:8081
 ⚡ REDIS:
   REDIS UI      -&gt; http://&lt;TU_IP&gt;:5540
 📜 LOGS:
   SEQ LOGS      -&gt; http://&lt;TU_IP&gt;:8083
   DOZZLE        -&gt; http://&lt;TU_IP&gt;:8082
 🐳 DOCKER:
   PORTAINER     -&gt; http://&lt;TU_IP&gt;:9000

 🧰 COMANDOS:
   make up         -&gt; levantar todo
   make prod       -&gt; backend
   make tools      -&gt; herramientas
   make down       -&gt; apagar todo
   make restart    -&gt; reiniciar
   make logs       -&gt; logs en vivo
   make ps         -&gt; contenedores
   make info       -&gt; info servidor
   make rebuild    -&gt; reconstruir
   make clean      -&gt; limpiar todo</code></pre>

  <h3>Comandos principales</h3>

  <table border="1" cellpadding="6" cellspacing="0">
    <thead>
      <tr>
        <th>Comando</th>
        <th>Descripción</th>
      </tr>
    </thead>
    <tbody>
      <tr><td><code>make up</code></td><td>Levanta todo el stack (prod + tools)</td></tr>
      <tr><td><code>make prod</code></td><td>Solo levanta los servicios de backend</td></tr>
      <tr><td><code>make tools</code></td><td>Solo levanta las herramientas (Portainer, Seq, etc.)</td></tr>
      <tr><td><code>make down</code></td><td>Apaga todos los contenedores</td></tr>
      <tr><td><code>make restart</code></td><td>Reinicia todos los contenedores</td></tr>
      <tr><td><code>make rebuild</code></td><td>Reconstruye y vuelve a levantar todas las imágenes</td></tr>
      <tr><td><code>make clean</code></td><td>Apaga todo y elimina volúmenes e imágenes</td></tr>
    </tbody>
  </table>

  <h3>Logs</h3>

  <table border="1" cellpadding="6" cellspacing="0">
    <thead>
      <tr>
        <th>Comando</th>
        <th>Descripción</th>
      </tr>
    </thead>
    <tbody>
      <tr><td><code>make logs</code></td><td>Logs en vivo de todos los servicios</td></tr>
      <tr><td><code>make logs-api</code></td><td>Logs del contenedor <code>uni-chat-api</code></td></tr>
      <tr><td><code>make logs-nginx</code></td><td>Logs del contenedor <code>uni-chat-nginx</code></td></tr>
      <tr><td><code>make logs-mongo</code></td><td>Logs del contenedor <code>mongodb</code></td></tr>
      <tr><td><code>make logs-redis</code></td><td>Logs del contenedor <code>redis</code></td></tr>
      <tr><td><code>make logs-rabbit</code></td><td>Logs del contenedor <code>rabbitmq</code></td></tr>
    </tbody>
  </table>

  <h3>Estado e información</h3>

  <table border="1" cellpadding="6" cellspacing="0">
    <thead>
      <tr>
        <th>Comando</th>
        <th>Descripción</th>
      </tr>
    </thead>
    <tbody>
      <tr><td><code>make ps</code></td><td>Lista los contenedores activos</td></tr>
      <tr><td><code>make info</code></td><td>Muestra IP, usuario, fecha, estado Docker, disco y RAM</td></tr>
    </tbody>
  </table>

  <hr />

  <h2 id="servicios">Servicios disponibles</h2>

  <p>Una vez que el stack esté corriendo con <code>make up</code>, puedes acceder a cada servicio desde tu red local:</p>

  <table border="1" cellpadding="6" cellspacing="0">
    <thead>
      <tr>
        <th>Servicio</th>
        <th>URL</th>
        <th>Descripción</th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <td>🔥 API — Scalar</td>
        <td><code>http://&lt;TU_IP&gt;/scalar</code></td>
        <td>Documentación interactiva de la API (OpenAPI)</td>
      </tr>
      <tr>
        <td>🐇 RabbitMQ UI</td>
        <td><code>http://&lt;TU_IP&gt;:15672</code></td>
        <td>Panel de administración de colas RabbitMQ</td>
      </tr>
      <tr>
        <td>🍃 Mongo Express</td>
        <td><code>http://&lt;TU_IP&gt;:8081</code></td>
        <td>Interfaz web para explorar MongoDB</td>
      </tr>
      <tr>
        <td>⚡ Redis UI</td>
        <td><code>http://&lt;TU_IP&gt;:5540</code></td>
        <td>Interfaz web para inspeccionar Redis</td>
      </tr>
      <tr>
        <td>📜 Seq Logs</td>
        <td><code>http://&lt;TU_IP&gt;:8083</code></td>
        <td>Visor de logs estructurados con filtros</td>
      </tr>
      <tr>
        <td>📜 Dozzle</td>
        <td><code>http://&lt;TU_IP&gt;:8082</code></td>
        <td>Logs en tiempo real de todos los contenedores</td>
      </tr>
      <tr>
        <td>🐳 Portainer</td>
        <td><code>http://&lt;TU_IP&gt;:9000</code></td>
        <td>Panel visual para administrar Docker</td>
      </tr>
    </tbody>
  </table>

  <p><strong>Nota:</strong> Reemplaza <code>&lt;TU_IP&gt;</code> con tu IP real en la red local. Usa <code>make help</code> o <code>make info</code> para verla automáticamente en tu terminal.</p>

  <hr />

  <h2 id="problemas">Solución de problemas</h2>

  <table border="1" cellpadding="6" cellspacing="0">
    <thead>
      <tr>
        <th>Problema</th>
        <th>Solución</th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <td><code>make: command not found</code></td>
        <td>Ejecuta <code>sudo apt install make -y</code></td>
      </tr>
      <tr>
        <td><code>docker: command not found</code></td>
        <td>Instala Docker Engine desde <a href="https://docs.docker.com/engine/install/">docs.docker.com/engine/install</a></td>
      </tr>
      <tr>
        <td>Puerto ya en uso</td>
        <td>Ejecuta <code>make down</code> y luego <code>make up</code> de nuevo</td>
      </tr>
      <tr>
        <td>IP muestra <code>127.0.0.1</code></td>
        <td>Verifica tu conexión de red; en WSL2 asegúrate de estar en la red correcta</td>
      </tr>
      <tr>
        <td>Contenedor no inicia</td>
        <td>Revisa los logs con <code>make logs</code> o <code>make logs-&lt;servicio&gt;</code></td>
      </tr>
      <tr>
        <td>Cambios en compose no aplicados</td>
        <td>Usa <code>make rebuild</code> para forzar reconstrucción de imágenes</td>
      </tr>
      <tr>
        <td>Quiero limpiar todo desde cero</td>
        <td><code>make clean</code> elimina contenedores, volúmenes e imágenes</td>
      </tr>
    </tbody>
  </table>

</body>
</html>
