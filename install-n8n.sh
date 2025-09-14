#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Display welcome message with channel info
echo -e "${GREEN}🚀 Добро пожаловать в установщик n8n!${NC}"
echo -e "${YELLOW}📢 Подписывайтесь на наш канал: https://t.me/NeuralExpedition${NC}"
echo ""

# Check if docker is installed
if ! command -v docker &> /dev/null
then
    print_error "Docker is not installed. Please install Docker first."
    exit 1
fi

# Check if docker-compose is installed
if ! command -v docker-compose &> /dev/null
then
    print_warning "docker-compose is not installed. Checking for docker compose plugin..."
    if ! docker compose version &> /dev/null
    then
        print_error "Docker Compose is not installed. Please install Docker Compose first."
        exit 1
    else
        DOCKER_COMPOSE_CMD="docker compose"
    fi
else
    DOCKER_COMPOSE_CMD="docker-compose"
fi

# Create directory for n8n
print_status "Creating directory for n8n..."
mkdir -p n8n-compose
cd n8n-compose

# Download docker-compose.yml
print_status "Downloading docker-compose.yml..."
curl -s -o docker-compose.yml https://raw.githubusercontent.com/jumble-ai/n8n-1clik-install/refs/heads/main/docker-compose.yml

# Create .env file
print_status "Creating .env file..."
cat > .env << EOF
# n8n specific environment variables
N8N_PORT=5678
N8N_PROTOCOL=http
N8N_HOST=localhost
N8N_ENCRYPTION_KEY=
N8N_USER_MANAGEMENT_JWT_SECRET=
N8N_USER_MANAGEMENT_JWT_EXPIRY_HOURS=168

# Database environment variables
DB_TYPE=postgresdb
DB_POSTGRESDB_HOST=postgres
DB_POSTGRESDB_PORT=5432
DB_POSTGRESDB_USER=n8n
DB_POSTGRESDB_PASSWORD=n8n
DB_POSTGRESDB_DATABASE=n8n

# Postgres environment variables
POSTGRES_USER=n8n
POSTGRES_PASSWORD=n8n
POSTGRES_DB=n8n

# Traefik environment variables
TRAEFIK_PORT=80
EOF

# Start n8n
print_status "Starting n8n..."
$DOCKER_COMPOSE_CMD up -d

print_status "n8n installation completed!"
echo -e "${GREEN}✅ You can access n8n at: http://localhost:5678${NC}"
echo -e "${YELLOW}📢 Не забудьте подписаться на наш канал: https://t.me/NeuralExpedition${NC}"
echo -e "${GREEN}⏹️  To stop n8n, run: $DOCKER_COMPOSE_CMD down${NC}"
echo -e "${BLUE}📋 To view logs, run: $DOCKER_COMPOSE_CMD logs -f${NC}"
