CREATE OR REPLACE VIEW lich_day_giang_vien AS
SELECT
    gv.ma_giang_vien,
    gv.ho_ten AS ten_giang_vien,
    gv.email,
    pcgd.vai_tro,
    lhp.ma_lop_hoc_phan,
    hp.ten_hoc_phan,
    lhp.hoc_ky,
    lhp.nam_hoc,
    lhp.ngay_trong_tuan,
    lhp.thoi_gian_bat_dau,
    lhp.thoi_gian_ket_thuc,
    lhp.phuong_thuc_giang_day,
    lhp.loai_lop,
    ph.ten_phong,
    ph.dia_chi AS dia_chi_phong
FROM PhanCongGiangDay pcgd
JOIN GiangVien gv ON pcgd.ma_giang_vien = gv.ma_giang_vien
JOIN LopHocPhan lhp ON pcgd.ma_lop_hoc_phan = lhp.ma_lop_hoc_phan
JOIN HocPhan hp ON lhp.ma_hoc_phan = hp.ma_hoc_phan
LEFT JOIN PhongHoc ph ON lhp.ma_phong = ph.ma_phong
ORDER BY gv.ma_giang_vien, lhp.ngay_trong_tuan, lhp.thoi_gian_bat_dau;
