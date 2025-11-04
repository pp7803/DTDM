# 🚀 MiniCloud - Hệ Thống Cloud Đầy Đủ Tính Năng

> **Dự án**: Thiết kế và triển khai hệ thống cloud hoàn chỉnh với Docker  
> **Sinh viên**: 52000054 - 52100098 - 52100989  
> **Môn học**: Điện toán đám mây

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

## � Mở Rộng Hệ Thống (5 Điểm)

### 1️⃣ Web Frontend Server - Blog Cá Nhân

**Mục tiêu:** Hiểu cách triển khai website tĩnh, quản lý nội dung, và cấu trúc thư mục web.

#### 📝 Nội Dung Mở Rộng

Đã tạo **blog cá nhân** với 3 bài viết chuyên nghiệp về công nghệ:

1. **🐳 Docker và Containerization** (`blog1.html`)

   - Giới thiệu về Docker và containerization
   - Lợi ích và best practices
   - Ứng dụng trong MiniCloud project

2. **🏗️ Kiến Trúc Microservices** (`blog2.html`)

   - Định nghĩa và đặc điểm microservices
   - Ưu điểm và thách thức
   - Kiến trúc MiniCloud với 10 services

3. **📊 Monitoring & Observability** (`blog3.html`)
   - Three pillars of observability
   - Prometheus + Grafana monitoring stack
   - Alerting best practices và SRE principles

#### ✨ Tính Năng

- ✅ Responsive design với gradient backgrounds
- ✅ Navigation links giữa các trang
- ✅ Featured icons và color themes riêng cho mỗi bài
- ✅ Tags và metadata (tác giả, ngày đăng, thời gian đọc)
- ✅ Highlight boxes cho nội dung quan trọng
- ✅ Code examples và architecture diagrams
- ✅ Footer với links quay lại

#### 🎨 Cấu Trúc Files

```
web-frontend-server/html/blog/
├── index.html          # Trang danh sách blog (đã cập nhật)
├── blog1.html          # Bài viết về Docker (mới)
├── blog2.html          # Bài viết về Microservices (mới)
└── blog3.html          # Bài viết về Monitoring (mới)
```

#### 🧪 Kiểm Thử

**1. Rebuild container với nội dung mới:**

```bash
cd 520000545210098552100989MiniCloud
docker compose build web-frontend-server
docker compose up -d web-frontend-server
```

**2. Truy cập blog:**

- Trang blog: http://localhost:8080/blog/
- Bài 1: http://localhost:8080/blog/blog1.html
- Bài 2: http://localhost:8080/blog/blog2.html
- Bài 3: http://localhost:8080/blog/blog3.html

**3. Test qua API Gateway:**

```bash
curl -I http://localhost/blog/
```

#### 🎓 Kiến Thức Đạt Được

✅ **Web Hosting:** Hiểu cách Nginx serve static content từ filesystem

✅ **Cấu Trúc Thư Mục:** Tổ chức files HTML trong directory structure

✅ **Nginx Alias:** Cấu hình location blocks để map URLs → filesystem paths

✅ **HTML/CSS:** Thiết kế responsive web pages với modern CSS (flexbox, grid)

✅ **Content Management:** Quản lý và liên kết nhiều pages trong một website

✅ **Docker Volumes:** Hiểu cách mount local files vào container

#### 📸 Screenshots

![Blog Post - Docker](image/25.png)
_Bài viết về Docker và Containerization_

![Blog Post - Microservices](image/26.png)
_Bài viết về Kiến trúc Microservices_

![Blog Post - Monitoring](image/27.png)
_Bài viết về Monitoring & Observability_

---

### 2️⃣ Application Backend Server - REST API Students

**Mục tiêu:** Làm quen với microservice, REST API, và HTTP JSON response.

#### 📝 Nội Dung Mở Rộng

Đã bổ sung **API endpoint mới** để quản lý thông tin sinh viên:

**Endpoint:** `GET /student`  
**Response:** JSON array chứa danh sách 5 sinh viên

#### 🎯 Implementation Details

**1. File `students.json` (5 sinh viên):**

```json
[
  {
    "id": "52000054",
    "name": "Nguyên Hạnh",
    "major": "Khoa học Máy tính",
    "gpa": 3.75,
    "email": "nguyenhanh@student.uit.edu.vn",
    "year": 3
  },
  {
    "id": "52100985",
    "name": "Duy Phát",
    "major": "Công nghệ Thông tin",
    "gpa": 3.82,
    "email": "duyphat@student.uit.edu.vn",
    "year": 3
  },
  {
    "id": "52100989",
    "name": "Văn Phú",
    "major": "Hệ thống Thông tin",
    "gpa": 3.68,
    "email": "vanphu@student.uit.edu.vn",
    "year": 3
  }
  // ... + 2 sinh viên khác
]
```

**2. Route trong `server.js` (Express/Node.js):**

```javascript
import { readFileSync } from "fs";

app.get("/student", (_req, res) => {
  try {
    const data = readFileSync("./students.json", "utf8");
    const students = JSON.parse(data);
    res.json({
      success: true,
      count: students.length,
      data: students,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      error: "Failed to read student data",
    });
  }
});
```

**3. Updated `Dockerfile`:**

```dockerfile
FROM node:20-alpine
WORKDIR /app
COPY package.json ./
RUN npm install --omit=dev
COPY server.js ./
COPY students.json ./    # ← Thêm dòng này
EXPOSE 8081
CMD ["node","server.js"]
```

#### 🧪 Kiểm Thử

**1. Rebuild container:**

```bash
cd 520000545210098552100989MiniCloud

# Build image mới
docker compose build application-backend-server

# Stop và remove container cũ
docker compose stop application-backend-server
docker compose rm -f application-backend-server

# Start lại
docker compose up -d application-backend-server

# Check logs
docker compose logs -f application-backend-server
```

**2. Test API endpoint:**

```bash
# Test trực tiếp (port 8085)
curl http://localhost:8085/student

# Test qua API Gateway (port 80)
curl http://localhost/api/student

# Test với pretty JSON
curl -s http://localhost/api/student | jq

# Test với headers
curl -i http://localhost/api/student
```

**3. Expected Response:**

```json
{
  "success": true,
  "count": 5,
  "data": [
    {
      "id": "52000054",
      "name": "Nguyên Hạnh",
      "major": "Khoa học Máy tính",
      "gpa": 3.75,
      "email": "nguyenhanh@student.uit.edu.vn",
      "year": 3
    }
    // ... 4 sinh viên khác
  ]
}
```

#### 🎓 Kiến Thức Đạt Được

✅ **REST API Design:** Hiểu cách thiết kế RESTful endpoints (GET, POST, PUT, DELETE)

✅ **HTTP Methods & Status Codes:** Phân biệt các HTTP methods và response codes (200, 404, 500)

✅ **JSON Data Format:** Serialize/deserialize JSON data trong Node.js

✅ **File System Operations:** Đọc file từ filesystem trong container

✅ **Error Handling:** Implement try-catch và trả về error responses

✅ **Microservice Communication:** Expose internal service qua reverse proxy

✅ **Docker Build Context:** Hiểu cách COPY files vào container image

#### � Screenshots

![API Student - Direct](image/28.png)
_Test endpoint trực tiếp qua port 8085_

![API Student - Gateway](image/29.png)
_Test endpoint qua API Gateway (port 80)_

#### 🔄 API Gateway Routing

API Gateway (Nginx) đã được cấu hình để route requests:

```nginx
location /api/ {
  proxy_pass http://application-backend-server:8081/;
}
```

---

### 3️⃣ Relational Database Server - Student Database & CRUD

**Mục tiêu:** Hiểu về lưu trữ quan hệ (RDBMS), thiết kế schema, và thực hiện CRUD operations.

#### 📝 Nội Dung Mở Rộng

Đã tạo **cơ sở dữ liệu studentdb** với bảng `students` đầy đủ thông tin sinh viên.

#### 🗄️ Database Schema

**Database:** `studentdb`  
**Table:** `students`

```sql
CREATE TABLE students (
    id INT PRIMARY KEY AUTO_INCREMENT,
    student_id VARCHAR(10) UNIQUE NOT NULL,
    fullname VARCHAR(100) NOT NULL,
    dob DATE NOT NULL,
    major VARCHAR(50) NOT NULL,
    gpa DECIMAL(3,2) DEFAULT 0.00,
    email VARCHAR(100),
    phone VARCHAR(15),
    address VARCHAR(200),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_student_id (student_id),
    INDEX idx_major (major)
);
```

#### 📊 Sample Data (5 sinh viên)

| ID  | Student ID | Fullname    | Major              | GPA  | Email                          |
| --- | ---------- | ----------- | ------------------ | ---- | ------------------------------ |
| 1   | 52000054   | Nguyên Hạnh | Khoa học Máy tính  | 3.75 | nguyenhanh@student.tdtu.edu.vn |
| 2   | 52100985   | Duy Phát    | Mạng Máy tính      | 3.82 | duyphat@student.tdtu.edu.vn    |
| 3   | 52100989   | Văn Phú     | Hệ thống Thông tin | 3.68 | vanphu@student.tdtu.edu.vn     |
| 4   | 52100123   | Minh Tuấn   | Kỹ thuật Phần mềm  | 3.90 | minhtuan@student.tdtu.edu.vn   |
| 5   | 52000456   | Thu Hà      | An toàn Thông tin  | 3.55 | thuha@student.tdtu.edu.vn      |

#### 🔧 CRUD Operations

**1. CREATE - Thêm sinh viên mới:**

```sql
INSERT INTO students (student_id, fullname, dob, major, gpa, email, phone, address)
VALUES ('52100999', 'Anh Khoa', '2002-09-15', 'Trí tuệ Nhân tạo', 3.65,
        'anhkhoa@student.tdtu.edu.vn', '0907890123', 'TP. Hồ Chí Minh');
```

**2. READ - Đọc dữ liệu:**

```sql
-- Lấy tất cả sinh viên
SELECT * FROM students;

-- Lấy sinh viên theo ID
SELECT * FROM students WHERE student_id = '52000054';

-- Lấy sinh viên theo major
SELECT * FROM students WHERE major = 'Khoa học Máy tính';

-- Lấy sinh viên có GPA > 3.7
SELECT * FROM students WHERE gpa > 3.7 ORDER BY gpa DESC;

-- Thống kê theo major
SELECT major, COUNT(*) as total, AVG(gpa) as avg_gpa
FROM students GROUP BY major;
```

**3. UPDATE - Cập nhật dữ liệu:**

```sql
-- Cập nhật GPA
UPDATE students SET gpa = 3.85 WHERE student_id = '52000054';

-- Cập nhật nhiều fields
UPDATE students
SET email = 'newemail@student.tdtu.edu.vn', phone = '0901111111'
WHERE student_id = '52100985';

-- Cập nhật major
UPDATE students SET major = 'Data Science' WHERE id = 4;
```

**4. DELETE - Xóa dữ liệu:**

```sql
-- Xóa theo student_id
DELETE FROM students WHERE student_id = '52100999';

-- Xóa sinh viên có GPA thấp (cẩn thận!)
DELETE FROM students WHERE gpa < 2.0;

-- Xóa tất cả (KHÔNG khuyến khích!)
-- DELETE FROM students;
```

#### 🧪 Kiểm Thử

**1. Database đã được tạo tự động khi start container:**

```bash
# File init được mount: relational-database-server/init/002_studentdb.sql
docker compose logs relational-database-server | grep studentdb
```

**2. Connect và test CRUD:**

```bash
# SELECT - Xem tất cả sinh viên
docker run -it --rm --network cloud-net -e MYSQL_PWD=root mysql:8 \
  sh -lc 'mysql -h relational-database-server -uroot -e "USE studentdb; SELECT * FROM students;"'

# INSERT - Thêm sinh viên mới
docker run -it --rm --network cloud-net -e MYSQL_PWD=root mysql:8 \
  sh -lc 'mysql -h relational-database-server -uroot -e "USE studentdb;
  INSERT INTO students (student_id, fullname, dob, major, gpa)
  VALUES (\"52100999\", \"Test Student\", \"2002-01-01\", \"Testing\", 3.50);"'

# UPDATE - Cập nhật GPA
docker run -it --rm --network cloud-net -e MYSQL_PWD=root mysql:8 \
  sh -lc 'mysql -h relational-database-server -uroot -e "USE studentdb;
  UPDATE students SET gpa = 3.95 WHERE student_id = \"52000054\";"'

# DELETE - Xóa sinh viên test
docker run -it --rm --network cloud-net -e MYSQL_PWD=root mysql:8 \
  sh -lc 'mysql -h relational-database-server -uroot -e "USE studentdb;
  DELETE FROM students WHERE student_id = \"52100999\";"'
```

**3. Interactive shell (MySQL CLI):**

```bash
# Connect vào MySQL shell
docker run -it --rm --network cloud-net -e MYSQL_PWD=root mysql:8 \
  mysql -h relational-database-server -uroot

# Trong shell:
USE studentdb;
SHOW TABLES;
DESCRIBE students;
SELECT * FROM students;
```

#### 🎓 Kiến Thức Đạt Được

✅ **Database Design:** Thiết kế schema với primary key, indexes, constraints

✅ **Data Types:** Hiểu các kiểu dữ liệu (INT, VARCHAR, DATE, DECIMAL, TIMESTAMP)

✅ **CRUD Operations:** Thực hành INSERT, SELECT, UPDATE, DELETE

✅ **SQL Queries:** Viết queries với WHERE, ORDER BY, GROUP BY, JOIN

✅ **Database Normalization:** Tổ chức dữ liệu theo chuẩn (1NF, 2NF, 3NF)

✅ **Docker Volumes:** Hiểu cách persist database data qua volumes

✅ **Init Scripts:** Tự động khởi tạo database khi container start

✅ **Connection String:** Connect từ application tới database server

#### 📸 Screenshots

![CRUD Select](image/30.png)
_Query SELECT lấy danh sách sinh viên_

![CRUD Insert](image/31.png)
_INSERT thêm sinh viên mới_

![CRUD Update](image/32.png)
_UPDATE cập nhật GPA sinh viên_

#### 🔗 Connect từ Backend

**Cài đặt MySQL driver cho Node.js:**

```bash
npm install mysql2
```

**Thêm vào `server.js`:**

```javascript
import mysql from "mysql2/promise";

// Create connection pool
const pool = mysql.createPool({
  host: "relational-database-server",
  user: "root",
  password: "root",
  database: "studentdb",
  waitForConnections: true,
  connectionLimit: 10,
});

// API endpoint to get students from DB
app.get("/students/db", async (_req, res) => {
  try {
    const [rows] = await pool.query("SELECT * FROM students ORDER BY gpa DESC");
    res.json({
      success: true,
      source: "database",
      count: rows.length,
      data: rows,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      error: error.message,
    });
  }
});
```

![Connect DB](image/33.png)
_UPDATE Kết nối + trả dữ liệu từ DB_

#### 💾 Data Persistence

Database data được lưu trong Docker volume, không bị mất khi restart container:

```bash
# Xem volumes
docker volume ls | grep database

# Inspect volume
docker volume inspect [volume-name]

# Backup database
docker compose exec relational-database-server \
  mysqldump -uroot -proot studentdb > backup.sql

# Restore database
docker compose exec -T relational-database-server \
  mysql -uroot -proot studentdb < backup.sql
```

---

### 4️⃣ Authentication Identity Server - Keycloak SSO & OIDC

**Mục tiêu:** Làm quen với Identity Provider (IdP), Single Sign-On (SSO), và OAuth2/OIDC flow.

#### 📝 Nội Dung Mở Rộng

Cấu hình **Keycloak** với Realm mới, users, và client application để implement authentication flow.

#### 🔐 Keycloak Configuration

**1. Truy cập Keycloak Admin Console:**

```
URL: http://localhost:8081
Username: admin
Password: admin
```

![Keycloak Login](image/11.png)
_Đăng nhập Keycloak Admin Console_

---

#### 🏰 Bước 1: Tạo Realm Mới

**1. Click dropdown "master" ở góc trên bên trái**

**2. Click "Create Realm"**

**3. Điền thông tin:**

- **Realm name:** `realm_520000545210098552100989` (theo mã sinh viên)
- **Enabled:** ON
- Click **Create**

![Create Realm](image/34.png)
_Tạo Realm mới theo mã sinh viên_

**Kết quả:** Realm `realm_520000545210098552100989` được tạo và active.

---

#### 👥 Bước 2: Tạo Users

**1. Trong Realm `realm_520000545210098552100989`, click menu "Users" (sidebar trái)**

**2. Click "Add user"**

**User 1: sv01**

- **Username:** `sv01`
- **Email:** `sv01@student.tdtu.edu.vn`
- **First name:** `Sinh viên`
- **Last name:** `01`
- **Email verified:** ON
- Click **Create**

**Sau khi tạo, set password:**

- Click tab "Credentials"
- Click "Set password"
- **Password:** `sv01password`
- **Password confirmation:** `sv01password`
- **Temporary:** OFF (để user không phải đổi password lần đầu)
- Click **Save**

![Create User sv01](image/35.png)

![Create User sv01](image/36.png)
_Tạo user sv01 với thông tin đầy đủ_

**User 2: sv02** (làm tương tự)

- **Username:** `sv02`
- **Email:** `sv02@student.tdtu.edu.vn`
- **First name:** `Sinh viên`
- **Last name:** `02`
- **Password:** `sv02password`
- **Temporary:** OFF

_Tạo user sv02_

**Kết quả:** 2 users (sv01, sv02) được tạo và có thể login.

---

#### 🔧 Bước 3: Tạo Client Application

**1. Click menu "Clients" (sidebar trái)**

**2. Click "Create client"**

**3. General Settings:**

- **Client type:** `OpenID Connect`
- **Client ID:** `nodejs-app`
- Click **Next**

**4. Capability config:**

- **Client authentication:** OFF (public client)
- **Authorization:** OFF
- **Authentication flow:**
  - ✅ Standard flow
  - ✅ Direct access grants
  - ❌ Implicit flow
- Click **Next**

**5. Login settings:**

- **Root URL:** `http://localhost:8085`
- **Home URL:** `http://localhost:8085`
- **Valid redirect URIs:**
  - `http://localhost:8085/*`
  - `http://localhost/api/*`
- **Web origins:** `*`
- Click **Save**

![Create Client](image/37.png)
_Tạo client nodejs-app với Access Type: public_

**Kết quả:** Client `nodejs-app` được tạo và có thể nhận tokens.

---

#### 🔑 Bước 4: Lấy Token và Test /secure Endpoint

**1. Lấy Token Endpoint URL:**

Trong client `nodejs-app`, click tab "Details" hoặc vào:

```
Realm Settings → General → Endpoints → OpenID Endpoint Configuration
```

**Token Endpoint:**

```
http://localhost:8081/realms/realm_520000545210098552100989/protocol/openid-connect/token
```

**2. Lấy Access Token (qua curl):**

```bash
# Lấy token với user sv01
curl -X POST http://localhost:8081/realms/realm_520000545210098552100989/protocol/openid-connect/token \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "client_id=nodejs-app" \
  -d "username=sv01" \
  -d "password=sv01password" \
  -d "grant_type=password"
```

**Response sẽ có:**

```json
{
  "access_token": "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9...",
  "token_type": "Bearer",
  "expires_in": 300,
  "refresh_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "scope": "profile email"
}
```

![Get Token](image/38.png)
_Lấy access token qua Password Grant flow_

## Cách Khắc Phục Lỗi Account is not fully set up (nếu có)

Bước 1: Truy cập Keycloak Admin
Bước 2: Kiểm tra và Fix User sv01

1. Vào realm realm_520000545210098552100989

2. Click menu "Users" → Tìm user sv01

3. Click vào user sv01

4. Trong tab "Details":

✅ Enabled: ON
✅ Email verified: ON
Click Save 5. Trong tab "Credentials":

Kiểm tra password đã được set
Temporary: phải là OFF
Nếu chưa có password, click "Set password" và set lại:
Password: sv01password
Password confirmation: sv01password
Temporary: OFF
Click Save password 6. Trong tab "Required actions":

Xóa tất cả required actions (nếu có)
List phải trống
Click Save nếu có thay đổi

**3. Test /secure endpoint với token:**

```bash
# Lưu token vào biến
TOKEN="eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9..."

# Test endpoint /secure
curl -H "Authorization: Bearer $TOKEN" \
  http://localhost:8085/secure
```

**Expected Response:**

```json
{
  "message": "Secure OK",
  "user": "sv01"
}
```

![Test Secure](image/39.png)
_Test /secure endpoint với Bearer token thành công_

**4. Test qua API Gateway:**

```bash
curl -H "Authorization: Bearer $TOKEN" \
  http://localhost/api/secure
```

![Test Secure](image/40.png)
_Test /secure endpoint với Bearer token thành công_

---

#### 🎓 Kiến Thức Đạt Được

✅ **Identity Provider (IdP):** Hiểu vai trò của Keycloak như centralized authentication service

✅ **Realm Concept:** Tổ chức users, clients, roles trong isolated realms

✅ **OAuth2/OIDC Flow:** Understand authorization code flow và password grant flow

✅ **Access Token:** JWT token chứa user claims, được verify bởi backend

✅ **Token Endpoint:** URL để request tokens với credentials

✅ **Client Types:** Public vs Confidential clients và use cases

✅ **Single Sign-On (SSO):** Một lần login → access nhiều applications

✅ **JWT Verification:** Backend verify token signature với JWKS endpoint

#### 🔄 Update Backend để sử dụng Realm mới

**Cập nhật `docker-compose.yml`:**

```yaml
application-backend-server:
  environment:
    OIDC_ISSUER: "http://authentication-identity-server:8080/realms/realm_520000545210098552100989"
    OIDC_AUDIENCE: "nodejs-app"
```

**Restart backend:**

```bash
docker compose restart application-backend-server
```

---

#### 🧪 Complete Test Flow

**1. Start Keycloak và Backend:**

```bash
docker compose up -d authentication-identity-server application-backend-server
```

**2. Get token:**

```bash
TOKEN=$(curl -s -X POST \
  http://localhost:8081/realms/realm_520000545210098552100989/protocol/openid-connect/token \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "client_id=nodejs-app" \
  -d "username=sv01" \
  -d "password=sv01password" \
  -d "grant_type=password" | jq -r .access_token)

echo "Token: $TOKEN"
```

**3. Test protected endpoint:**

```bash
curl -H "Authorization: Bearer $TOKEN" http://localhost:8085/secure
curl -H "Authorization: Bearer $TOKEN" http://localhost/api/secure
```

**4. Test với user sv02:**

```bash
TOKEN_SV02=$(curl -s -X POST \
  http://localhost:8081/realms/realm_520000545210098552100989/protocol/openid-connect/token \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "client_id=nodejs-app" \
  -d "username=sv02" \
  -d "password=sv02password" \
  -d "grant_type=password" | jq -r .access_token)

curl -H "Authorization: Bearer $TOKEN_SV02" http://localhost:8085/secure
```

---

#### 🔍 Debug & Troubleshooting

**1. Check Keycloak logs:**

```bash
docker compose logs -f authentication-identity-server
```

**2. Verify token (decode JWT):**

```bash
# Sử dụng jwt.io hoặc decode locally
echo $TOKEN | cut -d. -f2 | base64 -d 2>/dev/null | jq
```

**3. Check JWKS endpoint:**

```bash
curl http://localhost:8081/realms/realm_520000545210098552100989/protocol/openid-connect/certs
```

**4. Test without token (should fail):**

```bash
curl http://localhost:8085/secure
# Response: {"error":"Missing Bearer token"}
```

**5. Test with invalid token:**

```bash
curl -H "Authorization: Bearer invalid_token" http://localhost:8085/secure
# Response: 401 Unauthorized
```

---

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
- **52100985** - Duy Phát
- **52100989** - Văn Phú
