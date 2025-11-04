# 🚀 MiniCloud - Hệ Thống Cloud Đầy Đủ Tính Năng

> **Dự án**: Thiết kế và triển khai hệ thống cloud hoàn chỉnh với Docker  
> **Sinh viên**: 52000054 - 52100098 - 52100989  
> **Môn học**: Distributed & Decentralized Management (DTDM)

---

## 📋 Mục Lục

- [Tổng Quan](#-tổng-quan)
- [Kiến Trúc Hệ Thống](#-kiến-trúc-hệ-thống)
- [Cài Đặt và Triển Khai](#-cài-đặt-và-triển-khai)
- [Kiểm Thử Hệ Thống](#-kiểm-thử-hệ-thống)
- [Kết Quả](#-kết-quả)
- [Tài Liệu Tham Khảo](#-tài-liệu-tham-khảo)

---

## 🌟 Tổng Quan

**MiniCloud** là một hệ thống cloud infrastructure hoàn chỉnh được triển khai bằng Docker, bao gồm đầy đủ các thành phần:

- ✅ **Web Frontend** - Nginx static site
- ✅ **Application Backend** - Node.js/Express API
- ✅ **Database** - MariaDB relational database
- ✅ **Authentication** - Keycloak identity provider
- ✅ **Object Storage** - MinIO S3-compatible storage
- ✅ **DNS Server** - BIND9 internal DNS
- ✅ **Monitoring** - Prometheus + Grafana + Node Exporter
- ✅ **API Gateway** - Nginx reverse proxy

---

## 🏗️ Kiến Trúc Hệ Thống

### Sơ Đồ Kiến Trúc

```
                         ┌─────────────────────────┐
                         │   API Gateway (Port 80) │
                         │    Nginx Reverse Proxy  │
                         └───────────┬─────────────┘
                                     │
            ┌────────────────────────┼────────────────────────┐
            │                        │                        │
    ┌───────▼────────┐    ┌─────────▼────────┐    ┌─────────▼────────┐
    │  Web Frontend  │    │  App Backend API │    │   Keycloak Auth  │
    │  (Port 8080)   │    │   (Port 8085)    │    │   (Port 8081)    │
    └────────────────┘    └──────────────────┘    └──────────────────┘
                                     │
            ┌────────────────────────┼────────────────────────┐
            │                        │                        │
    ┌───────▼────────┐    ┌─────────▼────────┐    ┌─────────▼────────┐
    │   MariaDB      │    │     MinIO        │    │    BIND9 DNS     │
    │  (Port 3306)   │    │  (Port 9000/1)   │    │   (Port 1053)    │
    └────────────────┘    └──────────────────┘    └──────────────────┘

    ┌──────────────────────────────────────────────────────────────────┐
    │                 Monitoring Stack                                 │
    │  Node Exporter (9100) → Prometheus (9090) → Grafana (3000)      │
    └──────────────────────────────────────────────────────────────────┘
```

### Cấu Trúc Thư Mục

```
520000545210098552100989MiniCloud/
├── docker-compose.yml                      # Cấu hình chính
├── web-frontend-server/                    # Web tĩnh
│   ├── Dockerfile
│   ├── conf.default
│   └── html/
│       ├── index.html
│       └── blog/index.html
├── application-backend-server/             # API Backend
│   ├── Dockerfile
│   ├── package.json
│   └── server.js
├── relational-database-server/             # Database
│   └── init/001_init.sql
├── authentication-identity-server/         # Keycloak (image-based)
├── object-storage-server/                  # MinIO
│   └── data/
├── internal-dns-server/                    # BIND9
│   ├── db.cloud.local
│   ├── named.conf
│   ├── named.conf.local
│   └── named.conf.options
├── monitoring-prometheus-server/           # Prometheus
│   └── prometheus.yml
├── monitoring-grafana-dashboard-server/    # Grafana
├── monitoring-node-exporter-server/        # Node Exporter
├── api-gateway-proxy-server/               # Nginx Proxy
│   └── nginx.conf
├── test-network-connectivity.sh            # Script test mạng
└── test-network-detailed.sh                # Script test chi tiết
```

---

## 🚀 Cài Đặt và Triển Khai

### Yêu Cầu Hệ Thống

- Docker Engine 20.10+
- Docker Compose 2.0+
- RAM: Tối thiểu 4GB (khuyến nghị 8GB)
- Disk: Tối thiểu 10GB trống

### Bước 1: Clone Repository

```bash
git clone https://github.com/pp7803/DTDM.git
cd DTDM/520000545210098552100989MiniCloud
```

### Bước 2: Build và Khởi Động

```bash
# Build images (không dùng cache)
docker compose build --no-cache

# Khởi động tất cả services
docker compose up -d

# Kiểm tra trạng thái
docker compose ps
```

![Build và Deploy](image/1.png)
![Container Status](image/2.png)
![Docker Compose Up](image/3.png)
![Services Running](image/4.png)

### Bước 3: Xác Minh Triển Khai

```bash
# Kiểm tra logs
docker compose logs -f

# Kiểm tra network
docker network inspect cloud-net
```

---

## 🧪 Kiểm Thử Hệ Thống

### 1️⃣ Web Frontend Server (Nginx)

**Kiểm tra qua Terminal:**

```bash
curl -I http://localhost:8080/
```

![Web Frontend - Terminal](image/5.png)

**Kiểm tra qua Trình duyệt:**

- Trang chủ: http://localhost:8080/

![Web Frontend - Homepage](image/6.png)

- Blog: http://localhost:8080/blog

![Web Frontend - Blog](image/7.png)

---

### 2️⃣ Application Backend Server (Node.js)

**Endpoint trực tiếp:**

```bash
curl http://localhost:8085/hello
```

![Backend - Direct](image/8.png)

**Endpoint qua API Gateway:**

```bash
curl http://localhost/api/hello
```

![Backend - Via Gateway](image/9.png)

---

### 3️⃣ Relational Database Server (MariaDB)

**Kiểm tra kết nối và dữ liệu:**

```bash
docker run -it --rm --network cloud-net -e MYSQL_PWD=root mysql:8 \
  sh -lc 'mysql -h relational-database-server -uroot -e "USE minicloud; SHOW TABLES; SELECT * FROM notes;"'
```

![Database Query](image/10.png)

---

### 4️⃣ Authentication Identity Server (Keycloak)

**Truy cập Keycloak Admin Console:**

- URL: http://localhost:8081
- Username: `admin`
- Password: `admin`

![Keycloak Login](image/11.png)

**Tạo User Mới (SvTest01):**

![Keycloak - Create User](image/12.png)

---

### 5️⃣ Object Storage Server (MinIO)

**Truy cập MinIO Console:**

- URL: http://localhost:9001
- Username: `minioadmin`
- Password: `minioadmin`

![MinIO Login](image/13.png)

**Tạo Bucket:**

![MinIO - Create Bucket](image/14.png)

**Upload File:**

![MinIO - Upload File](image/15.png)

---

### 6️⃣ Internal DNS Server (BIND9)

**Kiểm tra DNS resolution:**

```bash
dig @127.0.0.1 -p 1053 web-frontend-server.cloud.local +short
```

**Kỳ vọng:** Trả về IP `10.10.10.10`

![DNS Resolution](image/16.png)

---

### 7️⃣ Monitoring - Prometheus

**Truy cập Prometheus:**

- URL: http://localhost:9090
- Kiểm tra: Status → Targets

![Prometheus Targets](image/17.png)

**Thử Query:**

Query: `node_cpu_seconds_total`

![Prometheus Query](image/19.png)

---

### 8️⃣ Monitoring - Grafana Dashboard

**Đăng nhập Grafana:**

- URL: http://localhost:3000
- Username: `admin`
- Password: `admin`

![Grafana Login](image/20.png)

**Thêm Data Source:**

- Type: Prometheus
- URL: `http://prometheus:9090`

![Grafana - Add Prometheus](image/21.png)

**Import Dashboard (Node Exporter Full - ID: 1860):**

![Grafana Dashboard](image/22.png)

---

### 9️⃣ API Gateway Proxy Server (Nginx)

**Kiểm tra routing qua proxy:**

```bash
# Web route
curl -I http://localhost/

# API route
curl -s http://localhost/api/hello

# Auth route
curl -I http://localhost/auth/
```

**Kỳ vọng:**

- `/` → 200 OK (web)
- `/api/hello` → JSON từ backend
- `/auth/` → 302 redirect đến Keycloak

![API Gateway Routing](image/23.png)

---

### 🔟 Kiểm Tra Kết Nối Mạng (Network Connectivity)

**Ping tất cả services trong mạng:**

```bash
docker run --rm --network cloud-net \
  -v "$(pwd)/test-network-detailed.sh:/test.sh:ro" \
  alpine:latest sh /test.sh 2>&1 | head -50
```

**Hoặc dùng script tổng hợp:**

```bash
docker run --rm --network cloud-net \
  -v "$(pwd)/test-network-connectivity.sh:/test.sh:ro" \
  busybox:latest sh /test.sh
```

![Network Connectivity Test](image/24.png)

---

## 📊 Kết Quả

### Bảng Tổng Hợp Services

| Service             | Port      | Status     | URL                               |
| ------------------- | --------- | ---------- | --------------------------------- |
| Web Frontend        | 8080      | ✅ Running | http://localhost:8080             |
| Application Backend | 8085      | ✅ Running | http://localhost:8085             |
| MariaDB             | 3306      | ✅ Running | `relational-database-server:3306` |
| Keycloak            | 8081      | ✅ Running | http://localhost:8081             |
| MinIO               | 9000/9001 | ✅ Running | http://localhost:9001             |
| BIND9 DNS           | 1053      | ✅ Running | `127.0.0.1:1053`                  |
| Node Exporter       | 9100      | ✅ Running | http://localhost:9100             |
| Prometheus          | 9090      | ✅ Running | http://localhost:9090             |
| Grafana             | 3000      | ✅ Running | http://localhost:3000             |
| API Gateway         | 80        | ✅ Running | http://localhost                  |

### Các Tính Năng Đã Triển Khai

✅ **Frontend & Backend API**

- Web tĩnh với Nginx
- RESTful API với Node.js/Express
- JWT authentication support

✅ **Database & Storage**

- Relational database (MariaDB)
- Object storage (MinIO S3-compatible)
- Database initialization scripts

✅ **Security & Identity**

- Keycloak OIDC authentication
- User management
- JWT token verification

✅ **Infrastructure**

- Internal DNS resolution (BIND9)
- API Gateway with routing
- Docker network isolation

✅ **Monitoring & Observability**

- Metrics collection (Prometheus)
- Visualization (Grafana)
- System metrics (Node Exporter)

---

## 📚 Tài Liệu Tham Khảo

### Scripts Hữu Ích

**Script kiểm tra mạng chi tiết:**

```bash
./test-network-detailed.sh
```

**Xem logs của service cụ thể:**

```bash
docker compose logs -f [service-name]
```

**Restart một service:**

```bash
docker compose restart [service-name]
```

**Stop và cleanup:**

```bash
docker compose down -v
```

### Thông Tin Đăng Nhập Mặc Định

| Service  | Username   | Password   |
| -------- | ---------- | ---------- |
| Keycloak | admin      | admin      |
| MinIO    | minioadmin | minioadmin |
| Grafana  | admin      | admin      |
| MariaDB  | root       | root       |

---

## 👥 Nhóm Thực Hiện

- **52000054** - Nguyên Hạnh
- **521000985** - Duy Phát
- **521000989** - Văn Phú

**© 2025 MiniCloud Project - DTDM Course**
