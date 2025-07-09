CREATE OR REPLACE FUNCTION dang_ky_hoc_phan(
    p_ma_sinh_vien VARCHAR,
    p_ma_hoc_phan VARCHAR,
    p_hoc_ky VARCHAR
) RETURNS TEXT AS $$
DECLARE
    v_count INT;
BEGIN
    -- 1. Kiểm tra sinh viên đã đăng ký học phần này trong cùng học kỳ chưa
    SELECT COUNT(*) INTO v_count
    FROM DangKyNguyenVongHocPhan
    WHERE ma_sinh_vien = p_ma_sinh_vien
      AND ma_hoc_phan = p_ma_hoc_phan
      AND hoc_ky = p_hoc_ky;


    IF v_count > 0 THEN
        RETURN 'Sinh viên đã đăng ký học phần này trong học kỳ.';
    END IF;


    -- 2. Thực hiện đăng ký (trigger sẽ tự kiểm tra điều kiện tiên quyết)
    INSERT INTO DangKyNguyenVongHocPhan (ma_sinh_vien, ma_hoc_phan, hoc_ky)
    VALUES (p_ma_sinh_vien, p_ma_hoc_phan, p_hoc_ky);


    RETURN 'Đăng ký thành công.';
EXCEPTION
    WHEN OTHERS THEN
        RETURN 'Đăng ký thất bại: ' || SQLERRM;
END;
$$ LANGUAGE plpgsql;
