# =========================
# CONFIG
# =========================
PROD_FILE=docker-compose.prod.yml
TOOLS_FILE=docker-compose.tools.yml

# =========================
# DETECTAR IP REAL (Windows WiFi + Linux fallback)
# =========================

LOCAL_IP := $(shell powershell -NoProfile -Command "(Get-NetIPAddress -AddressFamily IPv4 | Where-Object {$_.InterfaceAlias -like '*Wi-Fi*' -and $_.IPAddress -notlike '169.*'} | Select-Object -ExpandProperty IPAddress -First 1)")

ifeq ($(LOCAL_IP),)
	LOCAL_IP := $(shell hostname -I 2>/dev/null | awk '{print $$1}')
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
	@echo "   API         -> http://$(LOCAL_IP)"
	@echo "   SEQ LOGS    -> http://$(LOCAL_IP):8083"
	@echo "   PORTAINER   -> http://$(LOCAL_IP):9000"
	@echo "   MONGO UI    -> http://$(LOCAL_IP):8081"
	@echo "   REDIS UI    -> http://$(LOCAL_IP):5540"
	@echo ""
	@echo " 🧰 COMANDOS:"
	@echo "   make up         -> levantar todo"
	@echo "   make prod       -> backend"
	@echo "   make tools      -> herramientas"
	@echo "   make down       -> apagar todo"
	@echo "   make restart    -> reiniciar"
	@echo "   make logs       -> logs en vivo"
	@echo "   make ps         -> contenedores"
	@echo "   make info       -> info servidor"
	@echo ""

# =========================
# UP / DOWN
# =========================
up:
	docker compose -f $(PROD_FILE) -f $(TOOLS_FILE) up -d

prod:
	docker compose -f $(PROD_FILE) up -d

tools:
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
	@echo " IP REAL     : $(LOCAL_IP)"
	@echo " USUARIO     : $(shell whoami)"
	@echo " FECHA       : $(shell date)"
	@echo ""
	@echo " DOCKER STATUS:"
	@docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
	@echo ""
	@echo " DISCO:"
	@df -h | head -5
	@echo ""
	@echo " MEMORIA:"
	@free -h 2>/dev/null || systeminfo | findstr "Memory"
	@echo ""
	@echo "======================================"
	@echo ""

# =========================
# REBUILD
# =========================
rebuild:
	docker compose -f $(PROD_FILE) -f $(TOOLS_FILE) up -d --build

# =========================
# CLEAN 
# =========================
clean:
	docker compose -f $(PROD_FILE) -f $(TOOLS_FILE) down -v
	docker system prune -af