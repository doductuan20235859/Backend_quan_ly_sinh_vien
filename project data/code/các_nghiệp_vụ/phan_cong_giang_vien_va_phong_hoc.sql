
CREATE OR REPLACE FUNCTION phan_cong_giang_vien_va_phong_hoc(
    p_ma_lop_hoc_phan INT,
    p_ma_giang_vien VARCHAR,
    p_ma_phong INT,
    p_vai_tro VARCHAR DEFAULT 'Giảng viên chính'
) RETURNS TEXT AS $$
DECLARE
    v_ton_tai INT;
BEGIN
    -- Kiểm tra lớp học phần có tồn tại không
    SELECT COUNT(*) INTO v_ton_tai
    FROM LopHocPhan
    WHERE ma_lop_hoc_phan = p_ma_lop_hoc_phan;


    IF v_ton_tai = 0 THEN
        RETURN 'Lỗi: Lớp học phần không tồn tại.';
    END IF;


    -- Kiểm tra phòng học có tồn tại không
    SELECT COUNT(*) INTO v_ton_tai
    FROM PhongHoc
    WHERE ma_phong = p_ma_phong;


    IF v_ton_tai = 0 THEN
        RETURN ' Lỗi: Phòng học không tồn tại.';
    END IF;


    -- Gán phòng học cho lớp học phần
    UPDATE LopHocPhan
    SET ma_phong = p_ma_phong
    WHERE ma_lop_hoc_phan = p_ma_lop_hoc_phan;


    -- Thêm phân công giảng viên (trigger sẽ tự động kiểm tra cùng khoa)
    INSERT INTO PhanCongGiangDay(ma_giang_vien, ma_lop_hoc_phan, vai_tro)
    VALUES (p_ma_giang_vien, p_ma_lop_hoc_phan, p_vai_tro);


    RETURN FORMAT(
        ' Phân công giảng viên %s cho lớp học phần %s thành công. Gán phòng học %s.',
        p_ma_giang_vien, p_ma_lop_hoc_phan, p_ma_phong
    );


EXCEPTION
    WHEN unique_violation THEN
        RETURN ' Giảng viên đã được phân công lớp học phần này.';
    WHEN OTHERS THEN
        RETURN ' Lỗi khác: ' || SQLERRM;
END;
$$ LANGUAGE plpgsql;


