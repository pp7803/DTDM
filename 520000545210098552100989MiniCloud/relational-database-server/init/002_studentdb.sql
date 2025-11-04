-- ============================================
-- Script: 002_studentdb.sql
-- Purpose: Tạo database studentdb và bảng students
-- Author: MiniCloud Team (52000054, 52100985, 52100989)
-- Date: 5 Tháng 11, 2025
-- ============================================

-- Tạo database mới
CREATE DATABASE IF NOT EXISTS studentdb;
USE studentdb;

-- Tạo bảng students
CREATE TABLE IF NOT EXISTS students (
    id INT PRIMARY KEY AUTO_INCREMENT,
    student_id VARCHAR(10) NOT NULL UNIQUE,
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Chèn dữ liệu 3 thành viên nhóm
INSERT INTO students (student_id, fullname, dob, major, gpa, email, phone, address) VALUES
('52000054', 'Nguyên Hạnh', '2002-05-15', 'Khoa học Máy tính', 3.75, 'nguyenhanh@student.tdtu.edu.vn', '0901234567', 'TP. Hồ Chí Minh'),
('52100985', 'Duy Phát', '2002-08-20', 'Mạng Máy tính', 3.82, 'duyphat@student.tdtu.edu.vn', '0902345678', 'TP. Hồ Chí Minh'),
('52100989', 'Văn Phú', '2002-03-10', 'Hệ thống Thông tin', 3.68, 'vanphu@student.tdtu.edu.vn', '0903456789', 'TP. Hồ Chí Minh');

-- Chèn thêm 2 sinh viên khác
INSERT INTO students (student_id, fullname, dob, major, gpa, email, phone, address) VALUES
('52100123', 'Minh Tuấn', '2001-12-25', 'Kỹ thuật Phần mềm', 3.90, 'minhtuan@student.tdtu.edu.vn', '0904567890', 'Bình Dương'),
('52000456', 'Thu Hà', '2003-07-08', 'An toàn Thông tin', 3.55, 'thuha@student.tdtu.edu.vn', '0905678901', 'Đồng Nai');

-- ============================================
-- STORED PROCEDURES cho CRUD Operations
-- ============================================

-- Procedure: Lấy tất cả sinh viên
DELIMITER //
CREATE PROCEDURE GetAllStudents()
BEGIN
    SELECT 
        id,
        student_id,
        fullname,
        dob,
        major,
        gpa,
        email,
        phone,
        address,
        created_at,
        updated_at
    FROM students
    ORDER BY student_id;
END //
DELIMITER ;

-- Procedure: Lấy sinh viên theo ID
DELIMITER //
CREATE PROCEDURE GetStudentById(IN p_student_id VARCHAR(10))
BEGIN
    SELECT 
        id,
        student_id,
        fullname,
        dob,
        major,
        gpa,
        email,
        phone,
        address,
        created_at,
        updated_at
    FROM students
    WHERE student_id = p_student_id;
END //
DELIMITER ;

-- Procedure: Lấy sinh viên theo Major
DELIMITER //
CREATE PROCEDURE GetStudentsByMajor(IN p_major VARCHAR(50))
BEGIN
    SELECT 
        id,
        student_id,
        fullname,
        dob,
        major,
        gpa,
        email
    FROM students
    WHERE major = p_major
    ORDER BY gpa DESC;
END //
DELIMITER ;

-- Procedure: Thêm sinh viên mới
DELIMITER //
CREATE PROCEDURE InsertStudent(
    IN p_student_id VARCHAR(10),
    IN p_fullname VARCHAR(100),
    IN p_dob DATE,
    IN p_major VARCHAR(50),
    IN p_gpa DECIMAL(3,2),
    IN p_email VARCHAR(100),
    IN p_phone VARCHAR(15),
    IN p_address VARCHAR(200)
)
BEGIN
    INSERT INTO students (student_id, fullname, dob, major, gpa, email, phone, address)
    VALUES (p_student_id, p_fullname, p_dob, p_major, p_gpa, p_email, p_phone, p_address);
    
    SELECT LAST_INSERT_ID() as new_id;
END //
DELIMITER ;

-- Procedure: Cập nhật thông tin sinh viên
DELIMITER //
CREATE PROCEDURE UpdateStudent(
    IN p_student_id VARCHAR(10),
    IN p_fullname VARCHAR(100),
    IN p_major VARCHAR(50),
    IN p_gpa DECIMAL(3,2),
    IN p_email VARCHAR(100),
    IN p_phone VARCHAR(15),
    IN p_address VARCHAR(200)
)
BEGIN
    UPDATE students 
    SET 
        fullname = p_fullname,
        major = p_major,
        gpa = p_gpa,
        email = p_email,
        phone = p_phone,
        address = p_address
    WHERE student_id = p_student_id;
    
    SELECT ROW_COUNT() as affected_rows;
END //
DELIMITER ;

-- Procedure: Xóa sinh viên
DELIMITER //
CREATE PROCEDURE DeleteStudent(IN p_student_id VARCHAR(10))
BEGIN
    DELETE FROM students WHERE student_id = p_student_id;
    SELECT ROW_COUNT() as deleted_rows;
END //
DELIMITER ;

-- Procedure: Thống kê sinh viên theo major
DELIMITER //
CREATE PROCEDURE GetStudentStatsByMajor()
BEGIN
    SELECT 
        major,
        COUNT(*) as total_students,
        ROUND(AVG(gpa), 2) as avg_gpa,
        MAX(gpa) as max_gpa,
        MIN(gpa) as min_gpa
    FROM students
    GROUP BY major
    ORDER BY avg_gpa DESC;
END //
DELIMITER ;

-- ============================================
-- Views cho báo cáo
-- ============================================

-- View: Danh sách sinh viên xuất sắc (GPA >= 3.6)
CREATE OR REPLACE VIEW vw_excellent_students AS
SELECT 
    student_id,
    fullname,
    major,
    gpa,
    email
FROM students
WHERE gpa >= 3.60
ORDER BY gpa DESC;

-- View: Thống kê tổng quan
CREATE OR REPLACE VIEW vw_student_summary AS
SELECT 
    COUNT(*) as total_students,
    COUNT(DISTINCT major) as total_majors,
    ROUND(AVG(gpa), 2) as overall_avg_gpa,
    MAX(gpa) as highest_gpa,
    MIN(gpa) as lowest_gpa
FROM students;

-- ============================================
-- Test queries
-- ============================================

-- Hiển thị kết quả
SELECT '=== Danh sách tất cả sinh viên ===' as '';
SELECT student_id, fullname, major, gpa FROM students ORDER BY student_id;

SELECT '=== Sinh viên xuất sắc (GPA >= 3.6) ===' as '';
SELECT * FROM vw_excellent_students;

SELECT '=== Thống kê theo major ===' as '';
CALL GetStudentStatsByMajor();

SELECT '=== Tổng quan ===' as '';
SELECT * FROM vw_student_summary;

-- Thông báo hoàn thành
SELECT 'Database studentdb đã được tạo thành công!' as Message;
