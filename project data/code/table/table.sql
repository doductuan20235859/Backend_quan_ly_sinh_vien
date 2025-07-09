-- 1. Bảng Khoa
---
CREATE TABLE Khoa (
    ma_khoa SERIAL PRIMARY KEY, -- SERIAL tự động tăng, phù hợp cho khóa chính số nguyên
    ten_khoa VARCHAR(100) NOT NULL UNIQUE, -- Tên khoa phải duy nhất
    dia_chi VARCHAR(255)
);

---
-- 2. Bảng PhongHoc
---
CREATE TABLE PhongHoc (
    ma_phong SERIAL PRIMARY KEY,
    ten_phong VARCHAR(50) NOT NULL UNIQUE, -- Thêm tên phòng để dễ quản lý hơn mã số
    dia_chi VARCHAR(255), -- Có thể là mô tả vị trí trong tòa nhà
    suc_chua INT NOT NULL CHECK (suc_chua > 0) -- Sức chứa phải là số dương
);

---
-- 3. Bảng SinhVien
---
CREATE TABLE SinhVien (
    ma_sinh_vien VARCHAR(20) PRIMARY KEY, -- Mã sinh viên có thể có cả chữ và số
    ho_va_ten VARCHAR(100) NOT NULL,
    gioi_tinh VARCHAR(10), -- Ví dụ: 'Nam', 'Nữ', 'Khác'
    ngay_sinh DATE,
    dia_chi VARCHAR(255),
    email VARCHAR(100) UNIQUE, -- Email phải duy nhất
    so_dien_thoai VARCHAR(15), -- VARCHAR cho số điện thoại để chứa các ký tự đặc biệt như '+'
    so_can_cuoc_cong_dan VARCHAR(12) UNIQUE -- VARCHAR cho CCCD, đảm bảo duy nhất
);

---
-- 4. Bảng GiangVien
---
CREATE TABLE GiangVien (
    ma_giang_vien VARCHAR(20) PRIMARY KEY, -- Mã giảng viên có thể có cả chữ và số
    ho_ten VARCHAR(100) NOT NULL,
    ngay_sinh DATE,
    trinh_do VARCHAR(50),
    email VARCHAR(100) UNIQUE,
    ma_khoa INT NOT NULL, -- Khóa ngoại liên kết với Khoa
    CONSTRAINT fk_giangvien_khoa FOREIGN KEY (ma_khoa) REFERENCES Khoa(ma_khoa)
);

---
-- 5. Bảng Lop (Lớp hành chính của sinh viên)
---
CREATE TABLE Lop (
    ma_lop VARCHAR(20) PRIMARY KEY, -- Mã lớp có thể có chữ và số (ví dụ: 'K65MT', 'K66HTTT')
    ten_lop VARCHAR(100) NOT NULL UNIQUE, -- Tên lớp phải duy nhất
    nien_khoa VARCHAR(20), -- Ví dụ: '2021-2025'
    nganh VARCHAR(100),
    ma_giang_vien_chu_nhiem VARCHAR(20), -- Khóa ngoại liên kết với GiangVien
    CONSTRAINT fk_lop_giangvien FOREIGN KEY (ma_giang_vien_chu_nhiem) REFERENCES GiangVien(ma_giang_vien)
);

-- Cập nhật bảng SinhVien để thêm khóa ngoại đến Lop
ALTER TABLE SinhVien
ADD COLUMN ma_lop VARCHAR(20),
ADD CONSTRAINT fk_sinhvien_lop FOREIGN KEY (ma_lop) REFERENCES Lop(ma_lop);


---
-- 6. Bảng HocPhan
---
CREATE TABLE HocPhan (
    ma_hoc_phan VARCHAR(20) PRIMARY KEY,
    ten_hoc_phan VARCHAR(100) NOT NULL UNIQUE,
    so_tin_chi NUMERIC(2,0) NOT NULL CHECK (so_tin_chi > 0),
    trong_so_qua_trinh NUMERIC(3,2) NOT NULL DEFAULT 0.4, -- Ví dụ: 0.4 (40%)
    trong_so_cuoi_ky NUMERIC(3,2) NOT NULL DEFAULT 0.6, -- Ví dụ: 0.6 (60%)
    CONSTRAINT chk_trong_so_tong CHECK ((trong_so_qua_trinh + trong_so_cuoi_ky) = 1.0),
    ma_khoa INT NOT NULL, -- Khóa ngoại liên kết với Khoa
    CONSTRAINT fk_hocphan_khoa FOREIGN KEY (ma_khoa) REFERENCES Khoa(ma_khoa)
);

---
-- 7. Bảng DieuKienTienQuyet (Mối quan hệ Học phần - Học phần N-N)
---
CREATE TABLE DieuKienTienQuyet (
    ma_hoc_phan_bat_buoc VARCHAR(20) NOT NULL,
    ma_hoc_phan_tien_quyet VARCHAR(20) NOT NULL,
    PRIMARY KEY (ma_hoc_phan_bat_buoc, ma_hoc_phan_tien_quyet),
    CONSTRAINT fk_dk_batbuoc FOREIGN KEY (ma_hoc_phan_bat_buoc) REFERENCES HocPhan(ma_hoc_phan),
    CONSTRAINT fk_dk_tienquyet FOREIGN KEY (ma_hoc_phan_tien_quyet) REFERENCES HocPhan(ma_hoc_phan),
    CONSTRAINT chk_hocphan_khac_nhau CHECK (ma_hoc_phan_bat_buoc <> ma_hoc_phan_tien_quyet) -- Học phần không thể là điều kiện của chính nó
);

---
-- 8. Bảng DangKyNguyenVongHocPhan (Giai đoạn đăng ký nguyện vọng)
---
CREATE TABLE DangKyNguyenVongHocPhan (
    ma_sinh_vien VARCHAR(20) NOT NULL,
    ma_hoc_phan VARCHAR(20) NOT NULL,
    hoc_ky VARCHAR(10) NOT NULL, -- Ví dụ: 'HK1_2024', 'HK2_2025'
    ngay_dang_ky TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (ma_sinh_vien, ma_hoc_phan, hoc_ky),
    CONSTRAINT fk_dknguyenvong_sinhvien FOREIGN KEY (ma_sinh_vien) REFERENCES SinhVien(ma_sinh_vien),
    CONSTRAINT fk_dknguyenvong_hocphan FOREIGN KEY (ma_hoc_phan) REFERENCES HocPhan(ma_hoc_phan)
);

---
-- 9. Bảng LopHocPhan (Mở lớp dựa trên nguyện vọng)
---
CREATE TABLE LopHocPhan (
    ma_lop_hoc_phan SERIAL PRIMARY KEY,
    ma_hoc_phan VARCHAR(20) NOT NULL, -- Khóa ngoại đến Học phần
    ma_phong INT, -- Khóa ngoại đến Phòng học
    phuong_thuc_giang_day VARCHAR(50), -- Ví dụ: 'Trực tiếp', 'Online'
    loai_lop VARCHAR(50), -- Ví dụ: 'Lý thuyết', 'Thực hành'
    thoi_gian_bat_dau TIME, -- Ví dụ: '07:00:00'
    thoi_gian_ket_thuc TIME, -- Ví dụ: '09:00:00'
    ngay_trong_tuan INT CHECK (ngay_trong_tuan >= 2 AND ngay_trong_tuan <= 7), -- 2=Thứ Hai, 7=Chủ Nhật
    hoc_ky VARCHAR(10) NOT NULL, -- Học kỳ mà lớp học phần này diễn ra
    nam_hoc VARCHAR(9) NOT NULL, -- Ví dụ: '2024-2025'
    CONSTRAINT fk_lhp_hocphan FOREIGN KEY (ma_hoc_phan) REFERENCES HocPhan(ma_hoc_phan),
    CONSTRAINT fk_lhp_phonghoc FOREIGN KEY (ma_phong) REFERENCES PhongHoc(ma_phong)
);

---
-- 10. Bảng PhanCongGiangDay (Giảng viên dạy lớp học phần N-N)
---
CREATE TABLE PhanCongGiangDay (
    ma_giang_vien VARCHAR(20) NOT NULL,
    ma_lop_hoc_phan INT NOT NULL,
    vai_tro VARCHAR(50), -- Ví dụ: 'Giảng viên chính', 'Trợ giảng'
    PRIMARY KEY (ma_giang_vien, ma_lop_hoc_phan),
    CONSTRAINT fk_pcgd_giangvien FOREIGN KEY (ma_giang_vien) REFERENCES GiangVien(ma_giang_vien),
    CONSTRAINT fk_pcgd_lophocphan FOREIGN KEY (ma_lop_hoc_phan) REFERENCES LopHocPhan(ma_lop_hoc_phan)
);

---
-- 11. Bảng KetQuaHocTap (Đăng ký lớp học phần chính thức và quản lý điểm)
---
CREATE TABLE KetQuaHocTap (
    ma_sinh_vien VARCHAR(20) NOT NULL,
    ma_lop_hoc_phan INT NOT NULL,
    ma_hoc_phan VARCHAR(20) NOT NULL,
    hoc_ky VARCHAR(10) NOT NULL,
    diem_qua_trinh NUMERIC(4,2),
    diem_cuoi_ky NUMERIC(4,2),
    diem_ket_thuc NUMERIC(4,2), -- Không phải generated column nữa
    trang_thai_hoc_tap VARCHAR(50),
    PRIMARY KEY (ma_sinh_vien, ma_lop_hoc_phan),
    CONSTRAINT fk_kqht_sinhvien FOREIGN KEY (ma_sinh_vien) REFERENCES SinhVien(ma_sinh_vien),
    CONSTRAINT fk_kqht_lophocphan FOREIGN KEY (ma_lop_hoc_phan) REFERENCES LopHocPhan(ma_lop_hoc_phan),
    CONSTRAINT chk_diem_qua_trinh_range CHECK (diem_qua_trinh >= 0 AND diem_qua_trinh <= 10.00),
    CONSTRAINT chk_diem_cuoi_ky_range CHECK (diem_cuoi_ky >= 0 AND diem_cuoi_ky <= 10.00)
);

