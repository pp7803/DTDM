#!/bin/bash
# Script chi tiết để ping từng service riêng lẻ

echo "=========================================="
echo "  KIỂM TRA KẾT NỐI MẠNG CHI TIẾT"
echo "=========================================="
echo ""

echo "🌐 Web Frontend Server:"
ping -c 3 web-frontend-server
echo ""

echo "⚙️  Application Backend Server:"
ping -c 3 application-backend-server
echo ""

echo "🗄️  Relational Database Server (MariaDB):"
ping -c 3 relational-database-server
echo ""

echo "🔐 Authentication Identity Server (Keycloak):"
ping -c 3 authentication-identity-server
echo ""

echo "📦 Object Storage Server (MinIO):"
ping -c 3 object-storage-server
echo ""

echo "🌍 Internal DNS Server (BIND9):"
ping -c 3 internal-dns-server
echo ""

echo "📊 Monitoring Node Exporter:"
ping -c 3 monitoring-node-exporter-server
echo ""

echo "📈 Monitoring Prometheus Server:"
ping -c 3 monitoring-prometheus-server
echo ""

echo "📉 Monitoring Grafana Dashboard:"
ping -c 3 monitoring-grafana-dashboard-server
echo ""

echo "🚪 API Gateway Proxy Server (Nginx):"
ping -c 3 api-gateway-proxy-server
echo ""

echo "=========================================="
echo "✅ HOÀN THÀNH KIỂM TRA"
echo "=========================================="
