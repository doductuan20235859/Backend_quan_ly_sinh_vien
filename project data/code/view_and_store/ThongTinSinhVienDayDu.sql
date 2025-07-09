CREATE OR REPLACE VIEW ThongTinSinhVienDayDu AS
SELECT
    sv.ma_sinh_vien,
    sv.ho_va_ten,
    sv.gioi_tinh,
    sv.ngay_sinh,
    sv.dia_chi AS dia_chi_sinh_vien,
    sv.email AS email_sinh_vien,
    sv.so_dien_thoai,
    sv.so_can_cuoc_cong_dan,
    l.ma_lop,
    l.ten_lop,
    l.nien_khoa,
    l.nganh,
    gv_cn.ho_ten AS giang_vien_chu_nhiem,
    khoa.ma_khoa,
    khoa.ten_khoa,
    khoa.dia_chi AS dia_chi_khoa
FROM
    SinhVien sv
LEFT JOIN
    Lop l ON sv.ma_lop = l.ma_lop
LEFT JOIN
    GiangVien gv_cn ON l.ma_giang_vien_chu_nhiem = gv_cn.ma_giang_vien
LEFT JOIN
    Khoa khoa ON gv_cn.ma_khoa = khoa.ma_khoa; -- Giả định khoa của lớp là khoa của GVCN


LEFT JOIN Khoa k ON gv.ma_khoa = k.ma_khoa;
