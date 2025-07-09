CREATE OR REPLACE FUNCTION tao_lop_hoc_phan(
    p_ma_hoc_phan VARCHAR,
    p_ma_phong INT,
    p_phuong_thuc_giang_day VARCHAR,
    p_loai_lop VARCHAR,
    p_thoi_gian_bat_dau TIME,
    p_thoi_gian_ket_thuc TIME,
    p_ngay_trong_tuan INT,
    p_hoc_ky VARCHAR,
    p_nam_hoc VARCHAR,
    p_ma_giang_vien VARCHAR,
    p_vai_tro VARCHAR DEFAULT 'Giảng viên chính'
) RETURNS TEXT AS $$
DECLARE
    v_ma_lop_hoc_phan INT;
BEGIN
    -- Kiểm tra phòng học có tồn tại
    IF NOT EXISTS (SELECT 1 FROM PhongHoc WHERE ma_phong = p_ma_phong) THEN
        RAISE EXCEPTION 'Phòng học không tồn tại.';
    END IF;

    -- Kiểm tra giảng viên và học phần cùng khoa (trigger đã kiểm tra rồi)
    -- Thêm mới lớp học phần
    INSERT INTO LopHocPhan(
        ma_hoc_phan, ma_phong, phuong_thuc_giang_day, loai_lop,
        thoi_gian_bat_dau, thoi_gian_ket_thuc, ngay_trong_tuan,
        hoc_ky, nam_hoc
    )
    VALUES (
        p_ma_hoc_phan, p_ma_phong, p_phuong_thuc_giang_day, p_loai_lop,
        p_thoi_gian_bat_dau, p_thoi_gian_ket_thuc, p_ngay_trong_tuan,
        p_hoc_ky, p_nam_hoc
    )
    RETURNING ma_lop_hoc_phan INTO v_ma_lop_hoc_phan;

    -- Gán giảng viên vào lớp học phần (trigger kiểm tra khoa)
    INSERT INTO PhanCongGiangDay(ma_giang_vien, ma_lop_hoc_phan, vai_tro)
    VALUES (p_ma_giang_vien, v_ma_lop_hoc_phan, p_vai_tro);

    RETURN 'Tạo lớp học phần thành công. Mã lớp học phần: ' || v_ma_lop_hoc_phan;
EXCEPTION
    WHEN OTHERS THEN
        RETURN 'Lỗi khi tạo lớp học phần: ' || SQLERRM;
END;
$$ LANGUAGE plpgsql;
