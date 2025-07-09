CREATE OR REPLACE VIEW KetQuaHocTapChiTiet AS
SELECT
    sv.ma_sinh_vien,
    sv.ho_va_ten AS ten_sinh_vien,
    sv.ngay_sinh AS ngay_sinh_sinh_vien,
    sv.email AS email_sinh_vien,
    l.ten_lop,
    hp.ma_hoc_phan,
    hp.ten_hoc_phan,
    hp.so_tin_chi,
    lhp.ma_lop_hoc_phan,
    lhp.hoc_ky,
    lhp.nam_hoc,
    kqht.diem_qua_trinh,
    kqht.diem_cuoi_ky,
    kqht.diem_ket_thuc,
    kqht.trang_thai_hoc_tap,
    ph.ten_phong AS ten_phong_hoc,
    lhp.thoi_gian_bat_dau,
    lhp.thoi_gian_ket_thuc,
    lhp.ngay_trong_tuan,
    khoa.ten_khoa
FROM
    KetQuaHocTap kqht
JOIN
    SinhVien sv ON kqht.ma_sinh_vien = sv.ma_sinh_vien
JOIN
    HocPhan hp ON kqht.ma_hoc_phan = hp.ma_hoc_phan -- Sử dụng cột ma_hoc_phan mới trong KetQuaHocTap
JOIN
    LopHocPhan lhp ON kqht.ma_lop_hoc_phan = lhp.ma_lop_hoc_phan
LEFT JOIN
    Lop l ON sv.ma_lop = l.ma_lop -- Để lấy tên lớp hành chính của sinh viên (có thể null)
LEFT JOIN
    PhongHoc ph ON lhp.ma_phong = ph.ma_phong -- Thông tin phòng học (có thể null nếu lớp chưa có phòng)
LEFT JOIN
    Khoa khoa ON hp.ma_khoa = khoa.ma_khoa; -- Khoa quản lý học phần
