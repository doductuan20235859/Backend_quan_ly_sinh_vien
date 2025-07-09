CREATE INDEX idx_sinhvien_ma_lop ON SinhVien(ma_lop);
CREATE INDEX idx_giangvien_ma_khoa ON GiangVien(ma_khoa);
CREATE INDEX idx_hocphan_ma_khoa ON HocPhan(ma_khoa);
CREATE INDEX idx_lophocphan_ma_hoc_phan ON LopHocPhan(ma_hoc_phan);
CREATE INDEX idx_lophocphan_ma_phong ON LopHocPhan(ma_phong);
CREATE INDEX idx_ketquahoctap_ma_sinh_vien ON KetQuaHocTap(ma_sinh_vien);


-- Index cho các trường tìm kiếm
CREATE INDEX idx_sinhvien_email ON SinhVien(email);
CREATE INDEX idx_sinhvien_so_can_cuoc_cong_dan ON SinhVien(so_can_cuoc_cong_dan);
