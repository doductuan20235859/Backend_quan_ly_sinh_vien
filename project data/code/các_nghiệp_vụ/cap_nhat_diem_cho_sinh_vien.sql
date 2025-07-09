CREATE OR REPLACE FUNCTION cap_nhat_diem_cho_sinh_vien(
    p_ma_sinh_vien VARCHAR,
    p_ma_lop_hoc_phan INT,
    p_diem_qua_trinh NUMERIC,
    p_diem_cuoi_ky NUMERIC
) RETURNS TEXT AS $$
BEGIN
    -- Cập nhật điểm quá trình và cuối kỳ
    UPDATE KetQuaHocTap
    SET diem_qua_trinh = p_diem_qua_trinh,
        diem_cuoi_ky = p_diem_cuoi_ky
    WHERE ma_sinh_vien = p_ma_sinh_vien
      AND ma_lop_hoc_phan = p_ma_lop_hoc_phan;


    -- Trigger sẽ tự tính diem_ket_thuc và cập nhật trạng_thai_hoc_tap


    RETURN 'Cập nhật điểm thành công.';
EXCEPTION
    WHEN OTHERS THEN
        RETURN 'Lỗi khi cập nhật điểm: ' || SQLERRM;
END;
$$ LANGUAGE plpgsql;






