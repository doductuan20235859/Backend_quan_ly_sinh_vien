CREATE OR REPLACE FUNCTION dang_ky_lop_hoc_phan(
    p_ma_sinh_vien VARCHAR,
    p_ma_lop_hoc_phan INT
) RETURNS TEXT AS $$
DECLARE
    v_ma_hoc_phan VARCHAR;
    v_hoc_ky VARCHAR;
BEGIN
    -- Lấy mã học phần và học kỳ của lớp học phần
    SELECT ma_hoc_phan, hoc_ky
    INTO v_ma_hoc_phan, v_hoc_ky
    FROM LopHocPhan
    WHERE ma_lop_hoc_phan = p_ma_lop_hoc_phan;

    -- Thêm vào bảng KetQuaHocTap (trigger sẽ kiểm tra tất cả các ràng buộc nghiệp vụ)
    INSERT INTO KetQuaHocTap (
        ma_sinh_vien, ma_lop_hoc_phan, ma_hoc_phan, hoc_ky
    ) VALUES (
        p_ma_sinh_vien, p_ma_lop_hoc_phan, v_ma_hoc_phan, v_hoc_ky
    );

    RETURN ' Đăng ký lớp học phần thành công.';
EXCEPTION
    WHEN OTHERS THEN
        RETURN ' Lỗi khi đăng ký: ' || SQLERRM;
END;
$$ LANGUAGE plpgsql;

