CREATE TABLE LogHoatDong (
      id SERIAL PRIMARY KEY,
      nguoi_thuc_hien VARCHAR(100), -- Có thể là mã giảng viên, sinh viên, hoặc admin
      hanh_dong VARCHAR(100), -- Ví dụ: 'Nhập điểm', 'Phân công giảng viên'
      mo_ta TEXT, -- Chi tiết hành động
      thoi_gian TIMESTAMP DEFAULT CURRENT_TIMESTAMP
  );