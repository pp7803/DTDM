# Weather Prediction using Historical Data

## Tổng quan dự án

Dự án này sử dụng dữ liệu lịch sử từ **Weatherbit API** để dự đoán thời tiết, bao gồm nhiệt độ và độ ẩm cho **3 giờ tiếp theo**. Dự án tuân theo quy trình **CRISP-DM Framework** và triển khai cả **Classification** và **Regression models**.

## Mục tiêu

- 🌡️ Dự đoán nhiệt độ (Temperature) cho 3 giờ tiếp theo
- 💧 Dự đoán độ ẩm tương đối (Relative Humidity) cho 3 giờ tiếp theo  
- 🌤️ Phân loại điều kiện thời tiết (Weather Classification)
- 📊 So sánh hiệu suất giữa các mô hình Machine Learning

## Công nghệ sử dụng

### Thư viện chính
- **pandas**: Xử lý và phân tích dữ liệu
- **numpy**: Tính toán số học
- **scikit-learn**: Machine Learning models
- **xgboost**: Gradient Boosting model
- **matplotlib & seaborn**: Trực quan hóa dữ liệu
- **plotly**: Biểu đồ tương tác
- **requests**: Gọi API

### API
- **Weatherbit API**: Thu thập dữ liệu thời tiết lịch sử và hiện tại

## Cấu trúc dự án

```
DM/
├── update0812.ipynb          # Jupyter Notebook chính
├── README.md                 # File hướng dẫn này
├── QUESTIONS.md              # Bộ câu hỏi về dự án
└── weather_historical_data.json  # Dữ liệu thời tiết (được tạo tự động)
```

## Quy trình thực hiện (CRISP-DM)

### 1. Business Understanding
Hiểu rõ mục tiêu: Dự đoán chính xác nhiệt độ và độ ẩm trong tương lai gần để hỗ trợ hoạt động lập kế hoạch hàng ngày.

### 2. Data Understanding

#### Thu thập dữ liệu
- **Nguồn**: Weatherbit API
- **Thời gian**: 01/01/2024 - 01/01/2025 (1 năm)
- **Tần suất**: Dữ liệu theo giờ (hourly)
- **Địa điểm**: Hà Nội

#### Các features quan trọng
- `temp`: Nhiệt độ (°C)
- `rh`: Độ ẩm tương đối (%)
- `wind_spd`: Tốc độ gió (m/s)
- `clouds`: Độ phủ mây (%)
- `uv`: Chỉ số UV
- `precip`: Lượng mưa (mm)
- `pres`: Áp suất (millibars)
- `weather.description`: Mô tả điều kiện thời tiết

### 3. Data Preparation

#### Xử lý dữ liệu
1. **Loại bỏ features dư thừa**:
   - `weather.code`, `weather.icon` (đã có `weather.description`)
   - `snow` (tất cả giá trị = 0)
   - `azimuth` (không ảnh hưởng nhiều đến nhiệt độ)
   - Các cột datetime không cần thiết
   - `revision_status` (không đóng góp vào prediction)

2. **Feature Selection với Correlation Matrix**:
   - Loại bỏ features có correlation > 0.8
   - Dropped: `app_temp`, `dhi`, `dni`, `elev_angle`, `ghi`, `solar_rad`

3. **Encoding**:
   - `pod` (day/night): Label encoding (d=0, n=1)
   - `weather.description`: Label encoding

4. **Datetime handling**:
   - Chuyển đổi `timestamp_local` thành datetime index

### 4. Modeling

#### Classification Models (Dự đoán điều kiện thời tiết)

**Models được sử dụng**:
1. **Random Forest Classifier**
   - n_estimators=100
   - Hiệu suất: Accuracy cao nhất

2. **Gaussian Naive Bayes**
   - Model xác suất đơn giản
   - Nhanh nhưng accuracy thấp hơn

3. **Support Vector Machine (SVM)**
   - Kernel mặc định
   - Hiệu suất trung bình

4. **XGBoost Classifier**
   - Gradient boosting
   - Cân bằng tốt giữa accuracy và tốc độ

**Metrics đánh giá**:
- Accuracy Score
- F1 Score
- Precision Score
- Recall Score
- Confusion Matrix

#### Regression Models (Dự đoán Temperature & Humidity)

**Multi-output Regression**:
- Dự đoán 3 giá trị tương lai: 1h, 2h, 3h tiếp theo
- Target variables: `target_1`, `target_2`, `target_3`

**Models được sử dụng**:
1. **Random Forest Regressor**
   - n_estimators=100
   - Robust với outliers

2. **XGBoost Regressor**
   - learning_rate=0.1
   - max_depth=5
   - Hiệu suất tốt nhất

3. **Linear Regression**
   - Baseline model đơn giản
   - Nhanh nhưng accuracy thấp

4. **MLPRegressor (Neural Network)**
   - hidden_layers=(64, 32, 16)
   - activation='relu'
   - Phức tạp, cần nhiều data

**Metrics đánh giá**:
- Mean Squared Error (MSE)
- Mean Absolute Error (MAE)
- Root Mean Squared Error (RMSE)
- R-squared (R²)

### 5. Evaluation

#### Kiểm tra với dữ liệu thực tế
- Fetch dữ liệu thời tiết hiện tại từ API
- Sử dụng model XGBoost (tốt nhất) để dự đoán
- Output: Temperature và Humidity cho 3 giờ tiếp theo

## Cách chạy dự án

### Yêu cầu
```bash
pip install pandas numpy scikit-learn xgboost matplotlib seaborn plotly requests
```

### API Key
1. Đăng ký tài khoản tại [Weatherbit.io](https://www.weatherbit.io/)
2. Lấy API key
3. Thay thế trong code: `key: "YOUR_API_KEY"`

### Chạy Notebook
```bash
jupyter notebook update0812.ipynb
```

## Kết quả

### Classification Performance
- **Random Forest**: Accuracy cao nhất (~95%+)
- **XGBoost**: Cân bằng tốt, F1-score cao
- **Naive Bayes**: Nhanh nhưng accuracy thấp (~70%)
- **SVM**: Hiệu suất trung bình

### Regression Performance
- **XGBoost**: R² cao nhất, MSE thấp nhất
- **Random Forest**: Hiệu suất tốt, ổn định
- **MLPRegressor**: Tốt nhưng cần nhiều data hơn
- **Linear Regression**: Baseline, không phù hợp với dữ liệu phi tuyến

### Độ chính xác dự đoán
- **1 giờ tiếp theo**: Độ chính xác cao nhất
- **2-3 giờ tiếp theo**: Độ chính xác giảm dần nhưng vẫn chấp nhận được

## Hạn chế và cải tiến

### Hạn chế
- Chỉ dự đoán được 3 giờ tiếp theo
- Phụ thuộc vào chất lượng API data
- Chưa xử lý dữ liệu thiếu (missing values)
- Chưa implement time series models (LSTM, ARIMA)

### Cải tiến trong tương lai
- [ ] Mở rộng dự đoán lên 24 giờ
- [ ] Thêm LSTM/GRU models cho time series
- [ ] Deploy lên web application
- [ ] Thêm visualizations tương tác
- [ ] Xử lý multiple locations
- [ ] Implement ensemble methods
- [ ] Thêm feature engineering nâng cao

## Đóng góp

Mọi đóng góp đều được hoan nghênh! Vui lòng tạo Pull Request hoặc Issue.

## Tác giả

- Student ID: 52100985
- Course: Data Mining (DM)

## License

This project is for educational purposes only.

---

📧 Contact: [Your Email]
🔗 GitHub: [Your GitHub]
