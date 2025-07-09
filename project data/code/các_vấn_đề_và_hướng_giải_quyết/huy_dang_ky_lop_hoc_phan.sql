CREATE OR REPLACE FUNCTION huy_dang_ky_lop_hoc_phan(
      p_ma_sinh_vien VARCHAR,
      p_ma_lop_hoc_phan INT
  ) RETURNS TEXT AS $$
  DECLARE
      v_count INT;
  BEGIN
      -- Kiểm tra xem sinh viên có đăng ký lớp học phần này không
      SELECT COUNT(*) INTO v_count
      FROM KetQuaHocTap
      WHERE ma_sinh_vien = p_ma_sinh_vien
        AND ma_lop_hoc_phan = p_ma_lop_hoc_phan;

      IF v_count = 0 THEN
          RETURN 'Sinh viên chưa đăng ký lớp học phần này.';
      END IF;

      -- Xóa đăng ký lớp học phần
      DELETE FROM KetQuaHocTap
      WHERE ma_sinh_vien = p_ma_sinh_vien
        AND ma_lop_hoc_phan = p_ma_lop_hoc_phan;

      RETURN 'Hủy đăng ký lớp học phần thành công.';
  EXCEPTION
      WHEN OTHERS THEN
          RETURN 'Lỗi khi hủy đăng ký: ' || SQLERRM;
  END;
  $$ LANGUAGE plpgsql;