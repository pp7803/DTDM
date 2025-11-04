## Tạo cây thư mục

mkdir -p 520000545210098552100989MiniCloud
cd 520000545210098552100989MiniCloud

# Tạo file rỗng như trong cây thư mục

touch web-frontend-server/{Dockerfile,conf.default}
touch web-frontend-server/html/{index.html,blog/index.html}

# 3️⃣ Application Backend Server (Node.js / Express)

touch application-backend-server/{Dockerfile,server.js,package.json}

# 4️⃣ Relational Database Server (MariaDB)

touch relational-database-server/init/001_init.sql

# 5️⃣ Authentication & Identity Server (Keycloak)

# Không cần file riêng – cấu hình qua docker-compose.yml

# 6️⃣ Object Storage Server (MinIO)

mkdir -p object-storage-server/data

# 7️⃣ Internal DNS Server (Bind9)

touch internal-dns-server/{db.cloud.local,named.conf.local,named.conf.options}

# 8️⃣ Monitoring (Prometheus & Grafana)

touch monitoring-prometheus-server/prometheus.yml
mkdir -p monitoring-grafana-dashboard-server

# 9️⃣ API Gateway / Reverse Proxy (Nginx)

touch api-gateway-proxy-server/nginx.conf

# 10️⃣ Docker Compose cấu hình chính

touch docker-compose.yml

# Chạy lệnh

docker compose build --no-cache
docker compose up -d
docker compose ps

# Kết quả(image/1,2,3,4 png)

# curl -I http://localhost:8080/ (terminal) (5 png)

# Mở link http://localhost:8080/ qua trình duyệt (6 png)

# Mở link http://localhost:8080/blog qua trình duyệt (7 png)

# curl http://localhost:8085/hello (terminal) (8 png)

# curl http://localhost/api/hello (terminal) (9 png)
