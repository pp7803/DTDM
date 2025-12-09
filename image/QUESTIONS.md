# Bộ câu hỏi về Weather Prediction Project

## Phần 1: Hiểu biết về dự án (Business Understanding)

### Câu hỏi cơ bản

**Q1: Mục tiêu chính của dự án này là gì?**
<details>
<summary>Đáp án</summary>

Dự án có 3 mục tiêu chính:
1. Dự đoán nhiệt độ (Temperature) cho 3 giờ tiếp theo
2. Dự đoán độ ẩm tương đối (Relative Humidity) cho 3 giờ tiếp theo
3. Phân loại điều kiện thời tiết (Weather Classification)

Dự án sử dụng dữ liệu lịch sử từ Weatherbit API và áp dụng cả Classification và Regression models.
</details>

**Q2: Tại sao dự án lại chọn dự đoán cho 3 giờ tiếp theo thay vì nhiều hơn?**
<details>
<summary>Đáp án</summary>

- Độ chính xác giảm dần theo thời gian dự đoán
- Dữ liệu theo giờ (hourly) phù hợp cho dự đoán ngắn hạn
- 3 giờ là khoảng thời gian hợp lý cho hoạt động lập kế hoạch hàng ngày
- Với dữ liệu hiện tại, dự đoán xa hơn có thể không đáng tin cậy
</details>

**Q3: CRISP-DM Framework là gì? Các bước trong framework này?**
<details>
<summary>Đáp án</summary>

CRISP-DM (Cross-Industry Standard Process for Data Mining) gồm 6 bước:
1. **Business Understanding**: Hiểu mục tiêu và yêu cầu
2. **Data Understanding**: Thu thập và khám phá dữ liệu
3. **Data Preparation**: Làm sạch và biến đổi dữ liệu
4. **Modeling**: Xây dựng và huấn luyện models
5. **Evaluation**: Đánh giá hiệu suất models
6. **Deployment**: Triển khai model vào production

Dự án này thực hiện đầy đủ 5 bước đầu tiên.
</details>

## Phần 2: Thu thập và hiểu dữ liệu (Data Understanding)

### Câu hỏi về API và Data Collection

**Q4: Weatherbit API là gì? Tại sao chọn API này?**
<details>
<summary>Đáp án</summary>

Weatherbit API là một dịch vụ cung cấp dữ liệu thời tiết toàn cầu, bao gồm:
- Dữ liệu lịch sử (historical)
- Dữ liệu hiện tại (current)
- Dự báo thời tiết (forecast)

Lý do chọn:
- Dữ liệu chi tiết theo giờ
- Miễn phí với giới hạn hợp lý
- Dễ sử dụng, tài liệu rõ ràng
- Nhiều features quan trọng (temp, humidity, wind, UV, etc.)
</details>

**Q5: Dữ liệu được thu thập trong khoảng thời gian nào? Tại sao?**
<details>
<summary>Đáp án</summary>

- **Khoảng thời gian**: 01/01/2024 - 01/01/2025 (1 năm)
- **Tần suất**: Hourly (theo giờ)
- **Địa điểm**: Hà Nội

Lý do:
- 1 năm dữ liệu đủ để model học được các pattern theo mùa
- Dữ liệu theo giờ phù hợp cho dự đoán ngắn hạn
- Tổng cộng có khoảng 8760 records (365 × 24)
</details>

**Q6: Liệt kê 10 features quan trọng nhất trong dataset và ý nghĩa của chúng?**
<details>
<summary>Đáp án</summary>

1. **temp**: Nhiệt độ (°C) - Target variable chính
2. **rh**: Độ ẩm tương đối (%) - Target variable thứ hai
3. **wind_spd**: Tốc độ gió (m/s) - Ảnh hưởng đến cảm giác nhiệt độ
4. **clouds**: Độ phủ mây (%) - Ảnh hưởng đến nhiệt độ và nắng
5. **uv**: Chỉ số UV - Độ mạnh bức xạ mặt trời
6. **precip**: Lượng mưa (mm) - Lượng mưa tích lũy
7. **pres**: Áp suất (millibars) - Áp suất khí quyển
8. **dewpt**: Điểm sương (°C) - Nhiệt độ ngưng tụ hơi nước
9. **vis**: Tầm nhìn (km) - Khả năng nhìn xa
10. **weather.description**: Mô tả thời tiết - Điều kiện thời tiết tổng quát
</details>

### Câu hỏi về EDA (Exploratory Data Analysis)

**Q7: Dataset có bao nhiêu records và features ban đầu?**
<details>
<summary>Đáp án</summary>

Có thể xem bằng lệnh `raw_df.shape`:
- Số records: ~8760 (365 ngày × 24 giờ)
- Số features ban đầu: ~30 features (bao gồm cả metadata)
</details>

**Q8: Các điều kiện thời tiết phổ biến nhất ở Hà Nội là gì?**
<details>
<summary>Đáp án</summary>

Dựa vào biểu đồ và value_counts, các điều kiện phổ biến là:
1. Clear sky (Trời quang)
2. Few clouds (Ít mây)
3. Scattered clouds (Mây rải rác)
4. Overcast clouds (Mây phủ kín)
5. Light rain (Mưa nhẹ)

Có thể thay đổi tùy theo dữ liệu thực tế.
</details>

**Q9: Giải thích ý nghĩa của Correlation Matrix và tại sao phải sử dụng nó?**
<details>
<summary>Đáp án</summary>

**Correlation Matrix** là ma trận hiển thị mức độ tương quan giữa các biến số:
- Giá trị từ -1 đến 1
- Gần 1: Tương quan dương mạnh
- Gần -1: Tương quan âm mạnh
- Gần 0: Không tương quan

**Lý do sử dụng**:
- Phát hiện multicollinearity (đa cộng tuyến)
- Loại bỏ features dư thừa (correlation > 0.8)
- Giảm overfitting
- Tăng hiệu suất model
- Giảm computational cost

Ví dụ: `temp` và `app_temp` (nhiệt độ cảm nhận) có correlation rất cao, nên chỉ giữ 1 trong 2.
</details>

**Q10: Feature `pod` là gì? Tại sao nó quan trọng?**
<details>
<summary>Đáp án</summary>

**pod** = "Part of Day"
- `d` = day (ban ngày)
- `n` = night (ban đêm)

**Tầm quan trọng**:
- Nhiệt độ ban ngày cao hơn ban đêm
- UV index chỉ có ban ngày
- Độ ẩm thường cao hơn vào buổi sáng sớm
- Giúp model hiểu được chu kỳ ngày/đêm

Được encode thành: d=0, n=1
</details>

## Phần 3: Chuẩn bị dữ liệu (Data Preparation)

### Câu hỏi về Data Cleaning

**Q11: Tại sao phải loại bỏ features như `weather.code` và `weather.icon`?**
<details>
<summary>Đáp án</summary>

Vì chúng là **redundant features** (dư thừa):
- `weather.description` đã mô tả đầy đủ điều kiện thời tiết bằng text
- `weather.code` chỉ là mã số tương ứng
- `weather.icon` chỉ dùng để hiển thị icon trên UI

Giữ lại cả 3 features này sẽ:
- Tăng số chiều không cần thiết
- Gây overfitting
- Tăng computational cost
- Không cải thiện accuracy

Nguyên tắc: **Một thông tin chỉ nên được biểu diễn bằng một feature**
</details>

**Q12: Feature `snow` có giá trị như thế nào? Tại sao phải loại bỏ?**
<details>
<summary>Đáp án</summary>

- Tất cả giá trị của `snow` đều = 0
- Hà Nội không có tuyết rơi

**Lý do loại bỏ**:
- Zero variance (không có sự thay đổi)
- Không đóng góp thông tin gì cho model
- Chiếm bộ nhớ và computational resources
- Có thể gây lỗi trong một số algorithms

Nguyên tắc: **Loại bỏ features có zero hoặc near-zero variance**
</details>

**Q13: Giải thích quá trình Feature Selection với ngưỡng correlation > 0.8?**
<details>
<summary>Đáp án</summary>

**Quá trình**:
1. Tính correlation matrix cho tất cả numeric features
2. Tìm các cặp features có |correlation| > 0.8
3. Trong mỗi cặp, loại bỏ feature ít quan trọng hơn

**Features bị loại bỏ**:
- `app_temp`: Tương quan cao với `temp`
- `dhi`, `dni`, `ghi`: Tương quan cao với nhau (các loại bức xạ mặt trời)
- `solar_rad`: Tương quan cao với `uv`
- `elev_angle`: Góc cao mặt trời (tương quan với thời gian trong ngày)

**Ngưỡng 0.8** được chọn vì:
- Đủ cao để giữ lại features có ý nghĩa khác nhau
- Đủ thấp để loại bỏ redundancy nghiêm trọng
</details>

### Câu hỏi về Encoding

**Q14: Label Encoding là gì? Khi nào nên sử dụng?**
<details>
<summary>Đáp án</summary>

**Label Encoding**: Chuyển đổi categorical values thành số
- Ví dụ: {"Clear sky": 0, "Few clouds": 1, "Rain": 2}

**Khi nên dùng**:
- Biến có thứ tự tự nhiên (ordinal)
- Tree-based models (Decision Tree, Random Forest, XGBoost)
- Target variable trong classification

**Khi KHÔNG nên dùng**:
- Biến không có thứ tự (nominal) với Linear Regression
- Khi cần One-Hot Encoding để tránh ordinal relationship giả

Trong dự án:
- `pod`: d→0, n→1 (có thứ tự)
- `weather.description`: Dùng LabelEncoder cho nhiều categories
</details>

**Q15: Tại sao phải chuyển `timestamp_local` thành datetime index?**
<details>
<summary>Đáp án</summary>

**Lý do**:
1. **Time series analysis**: Pandas hiểu được dữ liệu theo thời gian
2. **Resampling**: Dễ dàng tổng hợp theo ngày/tuần/tháng
3. **Shift operations**: Tạo lag features dễ dàng
4. **Plotting**: Trục x tự động format đẹp
5. **Missing data handling**: Phát hiện gaps trong time series

**Ví dụ sử dụng**:
```python
# Tạo target variables cho regression
data['target_1'] = data.shift(-1)['temp']  # 1h sau
data['target_2'] = data.shift(-2)['temp']  # 2h sau
```
</details>

## Phần 4: Modeling - Classification

### Câu hỏi về Classification Models

**Q16: Giải thích 4 Classification Models được sử dụng trong dự án?**
<details>
<summary>Đáp án</summary>

**1. Random Forest Classifier**
- Ensemble của nhiều Decision Trees
- Voting để quyết định class
- Ưu: Robust, chống overfitting, chính xác cao
- Nhược: Chậm, khó interpret

**2. Naive Bayes (Gaussian)**
- Dựa trên Bayes' theorem
- Giả định features độc lập
- Ưu: Nhanh, đơn giản, ít data
- Nhược: Giả định độc lập thường sai

**3. Support Vector Machine (SVM)**
- Tìm hyperplane tách classes
- Sử dụng kernel trick
- Ưu: Hiệu quả với high-dimensional data
- Nhược: Chậm với dataset lớn

**4. XGBoost Classifier**
- Gradient Boosting với optimization
- Cải tiến từ Gradient Boosting
- Ưu: Accuracy cao, nhanh, regularization
- Nhược: Nhiều hyperparameters
</details>

**Q17: Accuracy, Precision, Recall, F1-score là gì? Khi nào dùng metric nào?**
<details>
<summary>Đáp án</summary>

**Accuracy** = (TP + TN) / Total
- Tỷ lệ dự đoán đúng tổng thể
- Dùng khi: Classes balanced

**Precision** = TP / (TP + FP)
- Trong các dự đoán Positive, bao nhiêu đúng?
- Dùng khi: Chi phí False Positive cao (spam detection)

**Recall** = TP / (TP + FN)
- Trong các thực tế Positive, bao nhiêu được tìm ra?
- Dùng khi: Chi phí False Negative cao (cancer detection)

**F1-score** = 2 × (Precision × Recall) / (Precision + Recall)
- Trung bình điều hòa của Precision và Recall
- Dùng khi: Cần balance giữa Precision và Recall

**Trong dự án này**: Dùng cả 4 metrics vì classes tương đối balanced
</details>

**Q18: Confusion Matrix là gì? Cách đọc Confusion Matrix?**
<details>
<summary>Đáp án</summary>

**Confusion Matrix**: Ma trận hiển thị kết quả classification

```
                Predicted
              Pos    Neg
Actual  Pos   TP     FN
        Neg   FP     TN
```

- **TP (True Positive)**: Dự đoán Pos, thực tế Pos ✓
- **TN (True Negative)**: Dự đoán Neg, thực tế Neg ✓
- **FP (False Positive)**: Dự đoán Pos, thực tế Neg ✗ (Type I Error)
- **FN (False Negative)**: Dự đoán Neg, thực tế Pos ✗ (Type II Error)

**Cách đọc**:
- Đường chéo chính (TP, TN): Dự đoán đúng
- Ngoài đường chéo: Dự đoán sai
- Heatmap màu đậm ở đường chéo = model tốt
</details>

**Q19: Tại sao Random Forest thường cho accuracy cao nhất trong Classification?**
<details>
<summary>Đáp án</summary>

**Lý do**:
1. **Ensemble Learning**: Kết hợp nhiều Decision Trees → giảm variance
2. **Bootstrap Aggregating**: Mỗi tree học từ random subset → diversity
3. **Feature Randomness**: Mỗi split chỉ xét random subset features
4. **Robust to Overfitting**: Averaging giảm overfitting
5. **Handle Non-linearity**: Captures complex relationships
6. **No Feature Scaling Required**: Hoạt động tốt với raw data

**So với các models khác**:
- Naive Bayes: Giả định independence quá đơn giản
- SVM: Khó optimize với multi-class, non-linear data
- XGBoost: Tốt nhưng cần tuning nhiều hơn
</details>

**Q20: Test size = 0.2 nghĩa là gì? Tại sao chọn tỷ lệ này?**
<details>
<summary>Đáp án</summary>

**Test size = 0.2**:
- 80% data cho training
- 20% data cho testing

**Lý do chọn 80/20**:
- **Rule of thumb**: 80/20 là tỷ lệ phổ biến
- **Training data đủ lớn**: 80% để model học tốt
- **Test data đủ**: 20% để đánh giá tin cậy
- **Computational cost**: Không quá lớn

**Tùy trường hợp**:
- Dataset nhỏ: 70/30 hoặc dùng Cross-Validation
- Dataset lớn: 90/10 hoặc 95/5
- Dự án này: ~7000 training, ~1700 testing

**shuffle=False**: Giữ thứ tự thời gian (time series)
</details>

## Phần 5: Modeling - Regression

### Câu hỏi về Regression Models

**Q21: Multi-output Regression là gì? Khác gì với Single-output?**
<details>
<summary>Đáp án</summary>

**Single-output Regression**:
- Dự đoán 1 giá trị: y = f(X)
- Ví dụ: Dự đoán nhiệt độ 1 giờ sau

**Multi-output Regression**:
- Dự đoán nhiều giá trị cùng lúc: [y1, y2, y3] = f(X)
- Ví dụ: Dự đoán [temp_1h, temp_2h, temp_3h]

**Trong dự án**:
```python
target_1 = data.shift(-1)['temp']  # 1h sau
target_2 = data.shift(-2)['temp']  # 2h sau
target_3 = data.shift(-3)['temp']  # 3h sau
```

**Ưu điểm**:
- Học correlation giữa các outputs
- Efficient hơn training 3 models riêng
- Consistent predictions

**Nhược điểm**:
- Phức tạp hơn single-output
- Accuracy giảm ở outputs xa
</details>

**Q22: Giải thích hàm `prepare_regression_data()` trong code?**
<details>
<summary>Đáp án</summary>

```python
def prepare_regression_data(df, feature):
    data = df.copy()
    
    # Tạo target variables
    data['target_1'] = data.shift(-1)[feature]  # 1h sau
    data['target_2'] = data.shift(-2)[feature]  # 2h sau
    data['target_3'] = data.shift(-3)[feature]  # 3h sau
    
    # Loại bỏ NaN (3 rows cuối)
    data.dropna(inplace=True)
    
    # Split X và y
    y = data[['target_1', 'target_2', 'target_3']]
    X = data.drop(['target_1', 'target_2', 'target_3'], axis=1)
    
    return X, y
```

**Cách hoạt động**:
1. `shift(-1)`: Dịch data lên 1 row → giá trị tiếp theo
2. `shift(-2)`: Dịch lên 2 rows → giá trị sau 2h
3. `shift(-3)`: Dịch lên 3 rows → giá trị sau 3h
4. `dropna()`: Loại bỏ 3 rows cuối (không có target)

**Ví dụ**:
```
Time    temp    target_1    target_2    target_3
10:00   25      26          27          28
11:00   26      27          28          29
12:00   27      28          29          NaN
```
</details>

**Q23: So sánh 4 Regression Models: RF, XGBoost, Linear Regression, MLP?**
<details>
<summary>Đáp án</summary>

**Random Forest Regressor**:
- Ensemble of Decision Trees
- Ưu: Robust, không cần scaling, handle non-linearity
- Nhược: Slow prediction, memory intensive
- Performance: R² cao, stable

**XGBoost Regressor**:
- Gradient Boosting với optimization
- Ưu: Accuracy cao nhất, regularization tốt
- Nhược: Cần tuning hyperparameters
- Performance: R² cao nhất, MSE thấp nhất

**Linear Regression**:
- Simple linear model: y = wx + b
- Ưu: Fast, interpretable, baseline
- Nhược: Chỉ capture linear relationships
- Performance: Thấp (data phi tuyến)

**MLPRegressor (Neural Network)**:
- Multi-layer perceptron
- Ưu: Powerful, flexible, universal approximator
- Nhược: Cần nhiều data, slow training, overfitting
- Performance: Tốt nhưng cần data lớn hơn
</details>

**Q24: MSE, MAE, RMSE, R² là gì? Metric nào quan trọng nhất?**
<details>
<summary>Đáp án</summary>

**Mean Squared Error (MSE)**:
- MSE = Σ(y_true - y_pred)² / n
- Penalize lỗi lớn nhiều hơn (bình phương)
- Đơn vị: squared units

**Mean Absolute Error (MAE)**:
- MAE = Σ|y_true - y_pred| / n
- Lỗi trung bình tuyệt đối
- Đơn vị: same as target
- Dễ hiểu hơn MSE

**Root Mean Squared Error (RMSE)**:
- RMSE = √MSE
- Đơn vị: same as target
- Cân bằng giữa MSE và MAE

**R-squared (R²)**:
- R² = 1 - (SS_res / SS_tot)
- Tỷ lệ variance được giải thích
- Range: 0 đến 1 (1 = perfect)

**Metric quan trọng nhất**: **R²**
- Dễ interpret (0.95 = 95% variance explained)
- Scale-independent
- Comparison across models

**Trong practice**: Xem cả R² và MAE
</details>

**Q25: Tại sao accuracy giảm dần từ target_1 → target_3?**
<details>
<summary>Đáp án</summary>

**Lý do**:
1. **Uncertainty tăng theo thời gian**:
   - 1h sau: Dữ liệu gần, pattern rõ ràng
   - 3h sau: Xa hơn, nhiều biến đổi

2. **Error propagation**:
   - Lỗi dự đoán tích lũy qua thời gian
   - target_3 phụ thuộc vào target_2, target_1

3. **Information decay**:
   - Current features ít relevant cho future xa
   - Weather changes unpredictably

4. **Chaos theory**:
   - Butterfly effect trong weather
   - Small changes → large impacts

**Giải pháp**:
- Thêm lagged features
- Use sequence models (LSTM, GRU)
- External data (radar, satellite)
- Ensemble predictions
</details>

## Phần 6: Evaluation & Deployment

### Câu hỏi về Model Evaluation

**Q26: Giải thích hàm `get_current_weather()` và cách nó hoạt động?**
<details>
<summary>Đáp án</summary>

```python
def get_current_weather(city):
    # 1. Fetch current data từ API
    response = requests.get(baseURL, query_string).json()
    
    # 2. Extract features cần thiết
    features = ['clouds', 'dewpt', 'pod', 'precip', ...]
    current_data = raw[features]
    
    # 3. Transform giống training data
    - Rename columns
    - Encode categorical (pod, summary)
    - Fill missing values
    
    return current_data, additional_data
```

**Quan trọng**: Data phải được transform **GIỐNG HỆT** training data:
- Same features
- Same encoding
- Same scaling (nếu có)
- Same column order

**Lỗi thường gặp**:
- Missing features
- Different encoding
- Different order
- Different data types
</details>

**Q27: Tại sao phải kiểm tra `if (current_data['summary'] == 'Clear sky')`?**
<details>
<summary>Đáp án</summary>

**Vấn đề**: LabelEncoder chỉ biết các labels đã thấy trong training data

**Trường hợp**:
- Training data: ["Rain", "Clouds", "Fog", ...]
- Test data có "Clear sky" → LabelEncoder không biết

**Giải pháp trong code**:
```python
if (current_data['summary'] == 'Clear sky').any():
    current_data['summary'] = 1  # Assign manually
else:
    current_data['summary'] = le.transform(current_data['summary'])
```

**Cách tốt hơn**:
- Save LabelEncoder với model
- Handle unknown categories:
  ```python
  from sklearn.preprocessing import LabelEncoder
  le.fit(all_possible_values)  # Fit với tất cả values có thể
  ```
- Use OrdinalEncoder với handle_unknown='use_encoded_value'
</details>

**Q28: Làm thế nào để deploy model này thành web application?**
<details>
<summary>Đáp án</summary>

**Các bước deploy**:

**1. Save trained models**:
```python
import joblib
joblib.dump(temp_model, 'temp_model.pkl')
joblib.dump(rh_model, 'rh_model.pkl')
joblib.dump(scaler, 'scaler.pkl')
joblib.dump(le, 'label_encoder.pkl')
```

**2. Create Flask/FastAPI backend**:
```python
from flask import Flask, request, jsonify
app = Flask(__name__)

@app.route('/predict', methods=['POST'])
def predict():
    data = request.json
    current_data = get_current_weather(data['city'])
    temp_pred = temp_model.predict(current_data)
    rh_pred = rh_model.predict(current_data)
    return jsonify({
        'temperature': temp_pred.tolist(),
        'humidity': rh_pred.tolist()
    })
```

**3. Create Frontend** (HTML/React/Vue):
- Input: City name
- Display: Current weather + Predictions
- Charts: Plotly/Chart.js

**4. Deploy**:
- Backend: Heroku, AWS, Google Cloud
- Frontend: Netlify, Vercel
- Docker: Containerize cả stack
</details>

**Q29: Model overfitting là gì? Làm sao phát hiện và xử lý?**
<details>
<summary>Đáp án</summary>

**Overfitting**: Model học quá kỹ training data, không generalize tốt

**Dấu hiệu**:
- Training accuracy rất cao (>99%)
- Test accuracy thấp hơn nhiều
- Large gap giữa train và test error

**Cách phát hiện**:
```python
train_score = model.score(X_train, y_train)
test_score = model.score(X_test, y_test)
if train_score - test_score > 0.1:  # Gap > 10%
    print("Overfitting!")
```

**Cách xử lý**:
1. **More data**: Collect thêm training data
2. **Regularization**: L1, L2, Dropout
3. **Reduce complexity**: Fewer features, shallower trees
4. **Cross-validation**: K-fold CV
5. **Early stopping**: Stop training khi validation error tăng
6. **Ensemble methods**: Random Forest, Bagging

**Trong dự án**:
- Random Forest: n_estimators=100 (không quá nhiều)
- Test set riêng biệt (20%)
- Feature selection (loại bỏ redundant)
</details>

**Q30: Nếu muốn cải thiện model, bạn sẽ làm gì?**
<details>
<summary>Đáp án</summary>

**1. Feature Engineering**:
```python
# Lagged features
df['temp_lag1'] = df['temp'].shift(1)
df['temp_lag24'] = df['temp'].shift(24)  # Same hour yesterday

# Rolling statistics
df['temp_rolling_mean'] = df['temp'].rolling(24).mean()
df['temp_rolling_std'] = df['temp'].rolling(24).std()

# Temporal features
df['hour'] = df.index.hour
df['day_of_week'] = df.index.dayofweek
df['month'] = df.index.month
df['is_weekend'] = df.index.dayofweek >= 5
```

**2. Advanced Models**:
```python
# LSTM for time series
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import LSTM, Dense

model = Sequential([
    LSTM(64, return_sequences=True, input_shape=(24, n_features)),
    LSTM(32),
    Dense(3)  # 3 outputs
])
```

**3. Hyperparameter Tuning**:
```python
from sklearn.model_selection import GridSearchCV

param_grid = {
    'n_estimators': [100, 200, 300],
    'max_depth': [5, 10, 15],
    'min_samples_split': [2, 5, 10]
}

grid_search = GridSearchCV(RandomForestRegressor(), param_grid, cv=5)
grid_search.fit(X_train, y_train)
```

**4. Ensemble Multiple Models**:
```python
# Stacking
from sklearn.ensemble import StackingRegressor

estimators = [
    ('rf', RandomForestRegressor()),
    ('xgb', XGBRegressor()),
    ('mlp', MLPRegressor())
]

stacking = StackingRegressor(
    estimators=estimators,
    final_estimator=LinearRegression()
)
```

**5. More Data**:
- Nhiều năm dữ liệu hơn
- Nhiều locations
- External data (satellite, radar)

**6. Cross-Validation**:
```python
from sklearn.model_selection import TimeSeriesSplit

tscv = TimeSeriesSplit(n_splits=5)
scores = cross_val_score(model, X, y, cv=tscv)
```
</details>

## Phần 7: Câu hỏi nâng cao

**Q31: Time Series Cross-Validation khác gì với regular Cross-Validation?**
<details>
<summary>Đáp án</summary>

**Regular K-Fold CV**:
- Random split data thành K folds
- Train on K-1, test on 1
- **Vấn đề**: Data leakage với time series!

**Time Series CV**:
- Giữ temporal order
- Train on past, test on future
- Growing window hoặc sliding window

```python
from sklearn.model_selection import TimeSeriesSplit

# Regular CV - WRONG for time series
cv = KFold(n_splits=5, shuffle=True)

# Time Series CV - CORRECT
tscv = TimeSeriesSplit(n_splits=5)

# Example splits:
# Fold 1: Train [0:100], Test [100:120]
# Fold 2: Train [0:120], Test [120:140]
# Fold 3: Train [0:140], Test [140:160]
```

**Tại sao quan trọng**:
- Tránh "looking into future"
- Realistic evaluation
- Detect overfitting tốt hơn
</details>

**Q32: Giải thích về Gradient Boosting và tại sao XGBoost tốt?**
<details>
<summary>Đáp án</summary>

**Gradient Boosting**:
1. Train weak learner (shallow tree) on data
2. Calculate residuals (errors)
3. Train next learner on residuals
4. Repeat, combining all learners

```
Final_prediction = learner1 + learner2 + learner3 + ...
```

**XGBoost improvements**:
1. **Regularization**: L1, L2 prevent overfitting
2. **Parallel Processing**: Fast training
3. **Tree Pruning**: Max_depth limitation
4. **Handling Missing Values**: Built-in
5. **Cross-Validation**: Built-in CV
6. **Column Subsampling**: Like Random Forest

**Hyperparameters**:
- `learning_rate`: Shrinkage (0.01-0.3)
- `n_estimators`: Number of trees (100-1000)
- `max_depth`: Tree depth (3-10)
- `subsample`: Row sampling (0.5-1.0)
- `colsample_bytree`: Column sampling (0.5-1.0)

**So với Random Forest**:
- XGBoost: Sequential, focuses on errors
- RF: Parallel, independent trees
- XGBoost usually better but needs tuning
</details>

**Q33: LSTM là gì? Khi nào nên dùng LSTM thay vì XGBoost?**
<details>
<summary>Đáp án</summary>

**LSTM (Long Short-Term Memory)**:
- Loại Recurrent Neural Network (RNN)
- "Nhớ" được long-term dependencies
- Có gates: forget, input, output

**Kiến trúc**:
```
Input → LSTM Layer → LSTM Layer → Dense → Output
```

**Dùng LSTM khi**:
- Long-term patterns quan trọng
- Sequential dependencies phức tạp
- Có nhiều data (>10k samples)
- Need to model temporal dynamics

**Dùng XGBoost khi**:
- Tabular data with features
- Faster training needed
- Interpretability quan trọng
- Less data available

**Trong dự án này**:
- Có thể thử LSTM với input shape (n_timesteps, n_features)
- Ví dụ: 24h history → predict 3h future

**Code example**:
```python
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import LSTM, Dense

model = Sequential([
    LSTM(64, return_sequences=True, input_shape=(24, 14)),
    LSTM(32),
    Dense(3, activation='linear')  # 3 outputs
])

model.compile(optimizer='adam', loss='mse')
model.fit(X_train, y_train, epochs=50, batch_size=32)
```
</details>

**Q34: Seasonality và Trend trong Time Series là gì? Cách handle?**
<details>
<summary>Đáp án</summary>

**Seasonality**: Patterns lặp lại theo chu kỳ
- Daily: Nhiệt độ cao ban ngày, thấp ban đêm
- Weekly: Weekend vs weekday patterns
- Yearly: Mùa hè nóng, mùa đông lạnh

**Trend**: Xu hướng dài hạn
- Upward: Nhiệt độ tăng do climate change
- Downward: Giảm
- No trend: Stable

**Decomposition**:
```python
from statsmodels.tsa.seasonal import seasonal_decompose

result = seasonal_decompose(df['temp'], model='additive', period=24)
result.plot()

# Separate components
trend = result.trend
seasonal = result.seasonal
residual = result.resid
```

**Handling strategies**:
1. **Differencing**:
```python
df['temp_diff'] = df['temp'].diff()  # Remove trend
df['temp_seasonal_diff'] = df['temp'].diff(24)  # Remove daily seasonality
```

2. **Feature Engineering**:
```python
df['hour'] = df.index.hour  # Capture daily seasonality
df['month'] = df.index.month  # Capture yearly seasonality
df['day_of_year'] = df.index.dayofyear
```

3. **Detrending**:
```python
from scipy import signal
detrended = signal.detrend(df['temp'])
```

4. **Models that handle seasonality**:
- SARIMA (Seasonal ARIMA)
- Prophet (Facebook)
- Neural Networks with temporal features
</details>

**Q35: Explain Bias-Variance Tradeoff trong Machine Learning?**
<details>
<summary>Đáp án</summary>

**Bias**: Error từ assumptions sai
- High bias = Underfitting
- Model quá đơn giản
- Ví dụ: Linear model cho non-linear data

**Variance**: Error từ sensitivity to training data
- High variance = Overfitting
- Model quá phức tạp
- Ví dụ: Deep tree memorizes training data

**Total Error** = Bias² + Variance + Irreducible Error

**Tradeoff**:
```
Simple Model → High Bias, Low Variance
Complex Model → Low Bias, High Variance
```

**Sweet Spot**: Balance giữa hai

**Trong các models**:
- **Linear Regression**: High bias, low variance
- **Decision Tree (deep)**: Low bias, high variance
- **Random Forest**: Balanced (ensemble reduces variance)
- **XGBoost**: Balanced (regularization controls complexity)

**Cách handle**:
- High bias: Increase model complexity, add features
- High variance: Regularization, more data, ensemble

**Visualization**:
```
Model Complexity →
                    ↓ Training Error
                    ↑↓ Test Error (U-shape)
                       
Optimal: Minimum test error
```
</details>

---

## Câu hỏi tổng hợp

**Q36: Trình bày end-to-end pipeline của dự án này?**
<details>
<summary>Đáp án</summary>

**Step-by-step**:

1. **Data Collection** (Cells 7-11):
   - Fetch từ Weatherbit API
   - Save JSON file
   - Convert to DataFrame

2. **EDA** (Cells 17-45):
   - Check data info, shape
   - Visualize distributions
   - Correlation analysis
   - Identify patterns

3. **Data Preparation** (Cells 47-69):
   - Remove redundant features
   - Feature selection (correlation > 0.8)
   - Handle datetime
   - Label encoding

4. **Classification** (Cells 72-102):
   - Train/test split (80/20)
   - Standardize features
   - Train 4 models (RF, NB, SVM, XGB)
   - Evaluate metrics
   - Compare performance

5. **Regression** (Cells 103-130):
   - Prepare multi-output data
   - Train 4 models (RF, XGB, LR, MLP)
   - Evaluate MSE, MAE, RMSE, R²
   - Compare temperature & humidity predictions

6. **Deployment** (Cells 132-140):
   - Fetch current weather
   - Predict future 3 hours
   - Display results

**Key decisions**:
- XGBoost chosen as best model
- Multi-output regression for efficiency
- Time series aware splitting (shuffle=False)
</details>

**Q37: Nếu bạn phải present dự án này, bạn sẽ highlight điểm gì?**
<details>
<summary>Đáp án</summary>

**Key Highlights**:

1. **Comprehensive Framework**:
   - Followed CRISP-DM methodology
   - Both Classification & Regression
   - Multiple model comparison

2. **Strong Results**:
   - Classification: 95%+ accuracy với Random Forest
   - Regression: R² > 0.9 với XGBoost
   - Multi-output prediction (3h future)

3. **Best Practices**:
   - Feature engineering & selection
   - Proper train/test split
   - Multiple evaluation metrics
   - Visualization for insights

4. **Technical Skills**:
   - API integration
   - Time series handling
   - Multiple ML algorithms
   - Data visualization

5. **Real-world Application**:
   - Fetch live data
   - Make predictions
   - Ready for deployment

**Demo Flow**:
1. Show EDA visualizations
2. Compare model performance charts
3. Live prediction demo
4. Discuss improvements

**Q&A Preparation**:
- Why XGBoost performs best?
- How to handle different cities?
- Scalability considerations
- Future enhancements
</details>

---

## Tài liệu tham khảo

- [Weatherbit API Documentation](https://www.weatherbit.io/api)
- [Scikit-learn Documentation](https://scikit-learn.org/)
- [XGBoost Documentation](https://xgboost.readthedocs.io/)
- [Pandas Time Series](https://pandas.pydata.org/docs/user_guide/timeseries.html)
- CRISP-DM Methodology

---

**Lưu ý**: Đây là bộ câu hỏi toàn diện. Trong thực tế, tùy vào level và mục đích (phỏng vấn, thi cử, presentation), bạn có thể chọn lọc câu hỏi phù hợp.
