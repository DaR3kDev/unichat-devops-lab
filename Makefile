# =========================
# CONFIG
# =========================
PROD_FILE=docker-compose.prod.yml
TOOLS_FILE=docker-compose.tools.yml

# =========================
# DETECTAR IP (Linux + Windows)
# =========================
UNAME_S := $(shell uname -s)

ifeq ($(UNAME_S),Linux)
	LOCAL_IP := $(shell hostname -I 2>/dev/null | awk '{print $$1}')
else
	LOCAL_IP := $(shell powershell -NoProfile -Command "(Get-NetIPAddress -AddressFamily IPv4 | Where-Object {$_.InterfaceAlias -like '*Wi-Fi*' -and $_.IPAddress -notlike '169.*'} | Select-Object -ExpandProperty IPAddress -First 1)")
endif

ifeq ($(LOCAL_IP),)
	LOCAL_IP := 127.0.0.1
endif

# =========================
# HELP / PANEL
# =========================
help:
	@echo ""
	@echo "======================================"
	@echo " 🚀 UNI-CHAT SERVER CONTROL PANEL"
	@echo "======================================"
	@echo ""
	@echo " 🌐 IP LOCAL (RED REAL): http://$(LOCAL_IP)"
	@echo ""
	@echo " 📡 SERVICIOS DISPONIBLES:"
	@echo ""
	@echo " 🔥 API:"
	@echo "   SCALAR API    -> http://$(LOCAL_IP)/scalar"
	@echo ""
	@echo " 🐇 RABBITMQ:"
	@echo "   RABBIT UI     -> http://$(LOCAL_IP):15672"
	@echo ""
	@echo " 🍃 MONGODB:"
	@echo "   MONGO EXPRESS -> http://$(LOCAL_IP):8081"
	@echo ""
	@echo " ⚡ REDIS:"
	@echo "   REDIS UI      -> http://$(LOCAL_IP):5540"
	@echo ""
	@echo " 📜 LOGS:"
	@echo "   SEQ LOGS      -> http://$(LOCAL_IP):8083"
	@echo "   DOZZLE        -> http://$(LOCAL_IP):8082"
	@echo ""
	@echo " 🐳 DOCKER:"
	@echo "   PORTAINER     -> http://$(LOCAL_IP):9000"
	@echo ""
	@echo " 🧰 COMANDOS:"
	@echo ""
	@echo "   make up         -> levantar todo"
	@echo "   make prod       -> backend"
	@echo "   make tools      -> herramientas"
	@echo "   make down       -> apagar todo"
	@echo "   make restart    -> reiniciar"
	@echo "   make logs       -> logs en vivo"
	@echo "   make ps         -> contenedores"
	@echo "   make info       -> info servidor"
	@echo "   make rebuild    -> reconstruir"
	@echo "   make clean      -> limpiar todo"
	@echo ""

# =========================
# CREAR RED SI NO EXISTE
# =========================
network:
	@docker network inspect backend >/dev/null 2>&1 || docker network create backend

# =========================
# UP / DOWN
# =========================
up: network
	docker compose -f $(PROD_FILE) -f $(TOOLS_FILE) up -d

prod: network
	docker compose -f $(PROD_FILE) up -d

tools: network
	docker compose -f $(TOOLS_FILE) up -d

down:
	docker compose -f $(PROD_FILE) -f $(TOOLS_FILE) down

restart:
	docker compose -f $(PROD_FILE) -f $(TOOLS_FILE) restart

# =========================
# LOGS
# =========================
logs:
	docker compose -f $(PROD_FILE) -f $(TOOLS_FILE) logs -f

logs-api:
	docker logs -f uni-chat-api

logs-nginx:
	docker logs -f uni-chat-nginx

logs-mongo:
	docker logs -f mongodb

logs-redis:
	docker logs -f redis

logs-rabbit:
	docker logs -f rabbitmq

logs-seq:
	docker logs -f seq

logs-dozzle:
	docker logs -f dozzle

logs-portainer:
	docker logs -f portainer

# =========================
# ESTADO
# =========================
ps:
	docker ps

# =========================
# INFO DEL SERVIDOR
# =========================
info:
	@echo ""
	@echo "======================================"
	@echo " 🖥 SERVER INFO"
	@echo "======================================"
	@echo ""
	@echo " 🌐 IP REAL     : $(LOCAL_IP)"
	@echo " 👤 USUARIO     : $(shell whoami)"
	@echo " 📅 FECHA       : $(shell date)"
	@echo ""
	@echo "======================================"
	@echo " 🌍 URLS"
	@echo "======================================"
	@echo ""
	@echo " SCALAR API       : http://$(LOCAL_IP)/scalar" 
	@echo ""
	@echo " RABBITMQ UI      : http://$(LOCAL_IP):15672"
	@echo " RABBITMQ AMQP    : $(LOCAL_IP):5672"
	@echo ""
	@echo " MONGO EXPRESS    : http://$(LOCAL_IP):8081"
	@echo ""
	@echo " REDIS INSIGHT    : http://$(LOCAL_IP):5540"
	@echo ""
	@echo " DOZZLE LOGS      : http://$(LOCAL_IP):8082"
	@echo " SEQ LOGS         : http://$(LOCAL_IP):8083"
	@echo ""
	@echo " PORTAINER        : http://$(LOCAL_IP):9000"
	@echo ""
	@echo "======================================"
	@echo " 🐳 DOCKER STATUS"
	@echo "======================================"
	@docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
	@echo ""
	@echo "======================================"
	@echo " 💾 DISCO"
	@echo "======================================"
	@df -h | head -5
	@echo ""
	@echo "======================================"
	@echo " 🧠 MEMORIA"
	@echo "======================================"
	@free -h 2>/dev/null || systeminfo | findstr "Memory"
	@echo ""
	@echo "======================================"

# =========================
# REBUILD
# =========================
rebuild: network
	docker compose -f $(PROD_FILE) -f $(TOOLS_FILE) up -d --build

# =========================
# CLEAN
# =========================
clean:
	docker compose -f $(PROD_FILE) -f $(TOOLS_FILE) down -v
	docker system prune -af
