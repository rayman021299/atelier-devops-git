#!/usr/bin/env bash
set -euo pipefail

COMPOSE_FILE="docker-compose.deploy.yml"
STATE_FILE="deploy/active_color"
NGINX_CONF="deploy/active.conf"

PYTHON_BIN="python3"
command -v python3 >/dev/null 2>&1 || PYTHON_BIN="python"

export COMMIT_SHA="${COMMIT_SHA:-dev}"
EXPECTED_SHA="${EXPECTED_SHA:-$COMMIT_SHA}"

if [ -f "$STATE_FILE" ]; then
    ACTIVE=$(tr -d '[:space:]' < "$STATE_FILE")
else
    ACTIVE="blue"
fi

if [ "$ACTIVE" = "blue" ]; then
    IDLE="green"
    IDLE_PORT=5002
else
    IDLE="blue"
    IDLE_PORT=5001
fi

echo "Actif: $ACTIVE | Cible: $IDLE (port $IDLE_PORT)"


docker compose -f "$COMPOSE_FILE" up -d redis


echo "Demarrage de app-$IDLE..."
docker compose -f "$COMPOSE_FILE" --profile "$IDLE" up -d --build "app-$IDLE"


echo "Verification healthcheck..."
READY=0
for _ in $(seq 1 15); do
    if curl -sf "http://localhost:${IDLE_PORT}/health" > /dev/null 2>&1; then
        READY=1
        break
    fi
    sleep 2
done

if [ "$READY" -ne 1 ]; then
    echo "ECHEC: app-$IDLE ne repond pas sur /health"
    echo "ROLLBACK: arret de app-$IDLE, $ACTIVE reste actif"
    docker compose -f "$COMPOSE_FILE" --profile "$IDLE" stop "app-$IDLE"
    exit 1
fi


echo "Verification smoke test..."
if ! curl -sf "http://localhost:${IDLE_PORT}/status" | $PYTHON_BIN -c "import sys, json; d = json.load(sys.stdin); sys.exit(0 if d.get('deploy_color') == '$IDLE' and d.get('commit_sha') == '$EXPECTED_SHA' else 1)"; then
    echo "ECHEC: smoke test invalide pour app-$IDLE (couleur ou SHA incorrect)"
    echo "ROLLBACK: arret de app-$IDLE, $ACTIVE reste actif"
    docker compose -f "$COMPOSE_FILE" --profile "$IDLE" stop "app-$IDLE"
    exit 1
fi


echo "Bascule Nginx vers app-$IDLE..."
cat > "$NGINX_CONF" <<EOF
server {
    listen 80;

    location / {
        proxy_pass http://app-${IDLE}:5000;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
    }
}
EOF



docker compose -f "$COMPOSE_FILE" up -d nginx
docker compose -f "$COMPOSE_FILE" exec -T nginx nginx -s reload
echo "$IDLE" > "$STATE_FILE"


echo "Arret de app-$ACTIVE..."
docker compose -f "$COMPOSE_FILE" --profile "$ACTIVE" stop "app-$ACTIVE"

echo "Deploiement reussi ! Couleur active: $IDLE"
