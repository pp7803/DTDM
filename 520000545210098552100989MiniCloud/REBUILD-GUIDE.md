# 🔄 Hướng Dẫn Rebuild Services

## 📦 Web Frontend Server (sau khi cập nhật blog)

### Các lệnh cần thiết:

```bash
# Di chuyển vào thư mục dự án
cd /Users/pp7803/Desktop/GithubDesktop/DTDM/520000545210098552100989MiniCloud

# Build lại image (không dùng cache để force rebuild)
docker compose build --no-cache web-frontend-server

# Hoặc build nhanh hơn (dùng cache)
docker compose build web-frontend-server

# Stop và remove container cũ
docker compose stop web-frontend-server
docker compose rm -f web-frontend-server

# Start lại service
docker compose up -d web-frontend-server

# Kiểm tra logs
docker compose logs -f web-frontend-server

# Kiểm tra status
docker compose ps web-frontend-server
```

### Test sau khi rebuild:

```bash
# Test blog index
curl -I http://localhost:8080/blog/

# Test blog posts
curl -I http://localhost:8080/blog/blog1.html
curl -I http://localhost:8080/blog/blog2.html
curl -I http://localhost:8080/blog/blog3.html

# Test qua API Gateway
curl -I http://localhost/blog/
```

---

## ⚙️ Application Backend Server (sau khi thêm API /student)

### Các lệnh cần thiết:

```bash
# Di chuyển vào thư mục dự án
cd /Users/pp7803/Desktop/GithubDesktop/DTDM/520000545210098552100989MiniCloud

# Build lại image
docker compose build --no-cache application-backend-server

# Stop và remove container cũ
docker compose stop application-backend-server
docker compose rm -f application-backend-server

# Start lại service
docker compose up -d application-backend-server

# Kiểm tra logs để verify startup
docker compose logs -f application-backend-server

# Kiểm tra status
docker compose ps application-backend-server
```

### Test API mới:

```bash
# Test endpoint trực tiếp (port 8085)
curl http://localhost:8085/student

# Test qua API Gateway (port 80)
curl http://localhost/api/student

# Test với pretty print (jq)
curl -s http://localhost/api/student | jq

# Test với headers
curl -i http://localhost/api/student
```

### Expected Response:

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
    },
    {
      "id": "52100985",
      "name": "Duy Phát",
      "major": "Công nghệ Thông tin",
      "gpa": 3.82,
      "email": "duyphat@student.uit.edu.vn",
      "year": 3
    }
    // ... 3 sinh viên khác
  ]
}
```

---

## 🔄 Rebuild Toàn Bộ Hệ Thống (nếu cần)

```bash
# Stop tất cả services
docker compose down

# Build lại tất cả images
docker compose build --no-cache

# Start tất cả services
docker compose up -d

# Kiểm tra status
docker compose ps

# Xem logs tất cả services
docker compose logs -f
```

---

## 🧹 Cleanup Commands (nếu gặp vấn đề)

```bash
# Stop và remove containers
docker compose down

# Remove volumes (cẩn thận: mất data!)
docker compose down -v

# Remove unused images
docker image prune -a

# Remove unused containers
docker container prune

# Remove everything
docker system prune -a --volumes
```

---

## 📊 Monitoring Commands

```bash
# Xem CPU/Memory usage
docker stats

# Xem logs real-time
docker compose logs -f [service-name]

# Xem logs với timestamp
docker compose logs -t [service-name]

# Xem N dòng logs cuối
docker compose logs --tail=50 [service-name]

# Exec vào container
docker compose exec [service-name] sh

# Inspect container
docker compose exec [service-name] ps aux
```

---

## 🚀 Quick Rebuild Script

Tạo file `rebuild.sh`:

```bash
#!/bin/bash

SERVICE=$1

if [ -z "$SERVICE" ]; then
    echo "Usage: ./rebuild.sh [service-name]"
    echo "Example: ./rebuild.sh web-frontend-server"
    exit 1
fi

echo "🔄 Rebuilding $SERVICE..."
docker compose build --no-cache $SERVICE
docker compose stop $SERVICE
docker compose rm -f $SERVICE
docker compose up -d $SERVICE
echo "✅ Done! Checking status..."
docker compose ps $SERVICE
docker compose logs --tail=20 $SERVICE
```

Sử dụng:

```bash
chmod +x rebuild.sh
./rebuild.sh web-frontend-server
./rebuild.sh application-backend-server
```

---

## 💡 Tips

1. **Cache:** Bỏ `--no-cache` để build nhanh hơn (dùng cache)
2. **Logs:** Luôn check logs sau khi rebuild: `docker compose logs -f [service]`
3. **Port Conflicts:** Nếu port bị chiếm, stop service cũ trước
4. **API Gateway:** Nhớ restart proxy nếu thay đổi backend: `docker compose restart api-gateway-proxy-server`
5. **Network:** Verify network connectivity: `docker network inspect cloud-net`

---

**© 2025 MiniCloud Project**
