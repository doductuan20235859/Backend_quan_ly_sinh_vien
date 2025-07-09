CREATE OR REPLACE FUNCTION huy_dang_ky_hoc_phan(
      p_ma_sinh_vien VARCHAR,
      p_ma_hoc_phan VARCHAR,
      p_hoc_ky VARCHAR
  ) RETURNS TEXT AS $$
  DECLARE
      v_count INT;
  BEGIN
      -- Kiểm tra xem sinh viên có đăng ký học phần này không
      SELECT COUNT(*) INTO v_count
      FROM DangKyNguyenVongHocPhan
      WHERE ma_sinh_vien = p_ma_sinh_vien
        AND ma_hoc_phan = p_ma_hoc_phan
        AND hoc_ky = p_hoc_ky;

      IF v_count = 0 THEN
          RETURN 'Sinh viên chưa đăng ký học phần này trong học kỳ.';
      END IF;

      -- Xóa đăng ký học phần
      DELETE FROM DangKyNguyenVongHocPhan
      WHERE ma_sinh_vien = p_ma_sinh_vien
        AND ma_hoc_phan = p_ma_hoc_phan
        AND hoc_ky = p_hoc_ky;

      RETURN 'Hủy đăng ký học phần thành công.';
  EXCEPTION
      WHEN OTHERS THEN
          RETURN 'Lỗi khi hủy đăng ký: ' || SQLERRM;
  END;
  $$ LANGUAGE plpgsql;