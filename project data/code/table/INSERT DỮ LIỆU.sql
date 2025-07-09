-- Xóa dữ liệu cũ và reset trình tự SERIAL
TRUNCATE TABLE KetQuaHocTap, PhanCongGiangDay, LopHocPhan, DangKyNguyenVongHocPhan, DieuKienTienQuyet, HocPhan, Lop, GiangVien, SinhVien, PhongHoc, Khoa RESTART IDENTITY CASCADE;

-- 1. Chèn dữ liệu vào bảng Khoa
INSERT INTO Khoa (ten_khoa, dia_chi) VALUES
('Công nghệ Thông tin', 'Tòa A, 1 Đại Cồ Việt, Hà Nội'),
('Kỹ thuật Điện tử', 'Tòa B, 1 Đại Cồ Việt, Hà Nội'),
('Quản trị Kinh doanh', 'Tòa C, 1 Đại Cồ Việt, Hà Nội');

-- 2. Chèn dữ liệu vào bảng PhongHoc
INSERT INTO PhongHoc (ten_phong, dia_chi, suc_chua) VALUES
('A101', 'Tầng 1, Tòa A', 50),
('B203', 'Tầng 2, Tòa B', 40),
('C305', 'Tầng 3, Tòa C', 60);

-- 3. Chèn dữ liệu vào bảng SinhVien
INSERT INTO SinhVien (ma_sinh_vien, ho_va_ten, gioi_tinh, ngay_sinh, dia_chi, email, so_dien_thoai, so_can_cuoc_cong_dan) VALUES
('SV001', 'Nguyễn Văn An', 'Nam', '2003-05-15', 'Hà Nội', 'an.nguyen@gmail.com', '0912345678', '123456789012'),
('SV002', 'Trần Thị Bình', 'Nữ', '2004-03-22', 'TP.HCM', 'binh.tran@gmail.com', '0987654321', '234567890123'),
('SV003', 'Lê Văn Cường', 'Nam', '2003-11-10', 'Đà Nẵng', 'cuong.le@gmail.com', '0931234567', '345678901234');

-- 4. Chèn dữ liệu vào bảng GiangVien
INSERT INTO GiangVien (ma_giang_vien, ho_ten, ngay_sinh, trinh_do, email, ma_khoa) VALUES
('GV001', 'Phạm Văn Đức', '1975-08-20', 'Tiến sĩ', 'duc.pham@gmail.com', 1),
('GV002', 'Nguyễn Thị Hoa', '1980-04-15', 'Thạc sĩ', 'hoa.nguyen@gmail.com', 2),
('GV003', 'Trần Văn Hùng', '1978-06-30', 'Tiến sĩ', 'hung.tran@gmail.com', 1);

-- 5. Chèn dữ liệu vào bảng Lop
INSERT INTO Lop (ma_lop, ten_lop, nien_khoa, nganh, ma_giang_vien_chu_nhiem) VALUES
('L001', 'K65CNTT', '2023-2027', 'Công nghệ Thông tin', 'GV001'),
('L002', 'K65DT', '2023-2027', 'Điện tử Viễn thông', 'GV002'),
('L003', 'K65QTKD', '2023-2027', 'Quản trị Kinh doanh', 'GV003');

-- Cập nhật ma_lop cho SinhVien
UPDATE SinhVien SET ma_lop = 'L001' WHERE ma_sinh_vien = 'SV001';
UPDATE SinhVien SET ma_lop = 'L001' WHERE ma_sinh_vien = 'SV002';
UPDATE SinhVien SET ma_lop = 'L002' WHERE ma_sinh_vien = 'SV003';

-- 6. Chèn dữ liệu vào bảng HocPhan
INSERT INTO HocPhan (ma_hoc_phan, ten_hoc_phan, so_tin_chi, trong_so_qua_trinh, trong_so_cuoi_ky, ma_khoa) VALUES
('HP001', 'Lập trình C', 3, 0.4, 0.6, 1),
('HP002', 'Vi mạch điện tử', 4, 0.3, 0.7, 2),
('HP003', 'Quản trị Marketing', 3, 0.5, 0.5, 3);

-- Cập nhật ma_khoa cho HP003 trước khi chèn vào PhanCongGiangDay
UPDATE HocPhan
SET ma_khoa = 1
WHERE ma_hoc_phan = 'HP003';

-- 7. Chèn dữ liệu vào bảng DieuKienTienQuyet
INSERT INTO DieuKienTienQuyet (ma_hoc_phan_bat_buoc, ma_hoc_phan_tien_quyet) VALUES
('HP001', 'HP003'); -- Lập trình C yêu cầu Quản trị Marketing (ví dụ minh họa)

-- 8. Chèn dữ liệu vào bảng DangKyNguyenVongHocPhan
INSERT INTO DangKyNguyenVongHocPhan (ma_sinh_vien, ma_hoc_phan, hoc_ky, ngay_dang_ky) VALUES
('SV001', 'HP001', 'HK1_2024', '2024-09-01 10:00:00'),
('SV002', 'HP001', 'HK1_2024', '2024-09-01 11:00:00'),
('SV003', 'HP002', 'HK1_2024', '2024-09-02 09:00:00');

-- 9. Chèn dữ liệu vào bảng LopHocPhan
INSERT INTO LopHocPhan (ma_hoc_phan, ma_phong, phuong_thuc_giang_day, loai_lop, thoi_gian_bat_dau, thoi_gian_ket_thuc, ngay_trong_tuan, hoc_ky, nam_hoc) VALUES
('HP001', 1, 'Trực tiếp', 'Lý thuyết', '07:00:00', '09:00:00', 2, 'HK1_2024', '2024-2025'),
('HP002', 2, 'Trực tiếp', 'Thực hành', '13:00:00', '15:00:00', 3, 'HK1_2024', '2024-2025'),
('HP003', 3, 'Online', 'Lý thuyết', '09:00:00', '11:00:00', 4, 'HK1_2024', '2024-2025');

-- 10. Chèn dữ liệu vào bảng PhanCongGiangDay
INSERT INTO PhanCongGiangDay (ma_giang_vien, ma_lop_hoc_phan, vai_tro) VALUES
('GV001', 1, 'Giảng viên chính'),
('GV002', 2, 'Giảng viên chính'),
('GV003', 3, 'Trợ giảng');

-- 11. Chèn dữ liệu vào bảng KetQuaHocTap
INSERT INTO KetQuaHocTap (ma_sinh_vien, ma_lop_hoc_phan,ma_hoc_phan, hoc_ky, diem_qua_trinh, diem_cuoi_ky, diem_ket_thuc, trang_thai_hoc_tap) VALUES
('SV001','HP001', 1, 'HK1_2024', 8.5, 7.5, 7.9, 'Đạt'),
('SV002','HP001', 1, 'HK1_2024', 9.0, 8.0, 8.4, 'Đạt'),
('SV003','HP002', 2, 'HK1_2024', 7.0, 6.5, 6.7, 'Đạt');

-- Thêm 7 sinh viên vào bảng SinhVien
INSERT INTO SinhVien (ma_sinh_vien, ho_va_ten, gioi_tinh, ngay_sinh, dia_chi, email, so_dien_thoai, so_can_cuoc_cong_dan, ma_lop) VALUES
('SV004', 'Phạm Thị Duyên', 'Nữ', '2003-07-12', 'Hà Nội', 'duyen.pham@gmail.com', '0913456789', '456789012345', 'L001'),
('SV005', 'Hoàng Văn E', 'Nam', '2004-01-25', 'TP.HCM', 'e.hoang@gmail.com', '0923456789', '567890123456', 'L001'),
('SV006', 'Nguyễn Thị F', 'Nữ', '2003-09-30', 'Đà Nẵng', 'f.nguyen@gmail.com', '0933456789', '678901234567', 'L002'),
('SV007', 'Trần Văn G', 'Nam', '2004-02-14', 'Hà Nội', 'g.tran@gmail.com', '0943456789', '789012345678', 'L002'),
('SV008', 'Lê Thị H', 'Nữ', '2003-12-05', 'TP.HCM', 'h.le@gmail.com', '0953456789', '890123456789', 'L003'),
('SV009', 'Đỗ Văn I', 'Nam', '2004-03-18', 'Đà Nẵng', 'i.do@gmail.com', '0963456789', '901234567890', 'L003'),
('SV010', 'Vũ Thị K', 'Nữ', '2003-11-22', 'Hà Nội', 'k.vu@gmail.com', '0973456789', '012345678901', 'L001');

-- Thêm bản ghi KetQuaHocTap cho HP003 để đáp ứng điều kiện tiên quyết cho HP001
INSERT INTO KetQuaHocTap (ma_sinh_vien, ma_lop_hoc_phan, hoc_ky, diem_qua_trinh, diem_cuoi_ky, diem_ket_thuc, trang_thai_hoc_tap) VALUES
('SV004', 3, 'HK1_2024', 8.0, 7.0, 7.4, 'Hoàn thành'),
('SV005', 3, 'HK1_2024', 7.5, 8.0, 7.8, 'Hoàn thành'),
('SV009', 3, 'HK1_2024', 7.0, 6.5, 6.7, 'Hoàn thành');

-- Đăng ký học phần
INSERT INTO DangKyNguyenVongHocPhan (ma_sinh_vien, ma_hoc_phan, hoc_ky, ngay_dang_ky) VALUES
('SV004', 'HP001', 'HK1_2024', '2024-09-03 10:00:00'),
('SV005', 'HP001', 'HK1_2024', '2024-09-03 11:00:00'),
('SV006', 'HP002', 'HK1_2024', '2024-09-03 12:00:00'),
('SV007', 'HP002', 'HK1_2024', '2024-09-03 13:00:00'),
('SV008', 'HP003', 'HK1_2024', '2024-09-03 14:00:00'),
('SV009', 'HP001', 'HK1_2024', '2024-09-03 15:00:00'),
('SV010', 'HP003', 'HK1_2024', '2024-09-03 16:00:00');

-- Thêm kết quả học tập
INSERT INTO KetQuaHocTap (ma_sinh_vien, ma_lop_hoc_phan, hoc_ky, diem_qua_trinh, diem_cuoi_ky, diem_ket_thuc, trang_thai_hoc_tap) VALUES
('SV004', 1, 'HK1_2024', 8.0, 7.0, 7.4, 'Đang học'),
('SV005', 1, 'HK1_2024', 7.5, 8.0, 7.8, 'Đang học'),
('SV006', 2, 'HK1_2024', 6.5, 6.0, 6.2, 'Đang học'),
('SV007', 2, 'HK1_2024', 8.5, 7.5, 7.9, 'Đang học'),
('SV008', 3, 'HK1_2024', 9.0, 8.5, 8.7, 'Đang học'),
('SV009', 1, 'HK1_2024', 7.0, 6.5, 6.7, 'Đang học'),
('SV010', 3, 'HK1_2024', 8.0, 7.5, 7.7, 'Đang học');
