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
      v_suc_chua INT;
      v_so_sinh_vien INT;
      v_count INT;
  BEGIN
      -- Kiểm tra thời gian hợp lệ
      IF p_thoi_gian_bat_dau >= p_thoi_gian_ket_thuc THEN
          RAISE EXCEPTION 'Thời gian bắt đầu phải nhỏ hơn thời gian kết thúc.';
      END IF;

      IF p_thoi_gian_bat_dau < '07:00:00' OR p_thoi_gian_ket_thuc > '22:00:00' THEN
          RAISE EXCEPTION 'Thời gian lớp học phải nằm trong khoảng 07:00 đến 22:00.';
      END IF;

      -- Kiểm tra phòng học có tồn tại
      IF NOT EXISTS (SELECT 1 FROM PhongHoc WHERE ma_phong = p_ma_phong) THEN
          RAISE EXCEPTION 'Phòng học không tồn tại.';
      END IF;

      -- Kiểm tra trùng lịch sử dụng phòng
      SELECT COUNT(*) INTO v_count
      FROM LopHocPhan
      WHERE ma_phong = p_ma_phong
        AND ngay_trong_tuan = p_ngay_trong_tuan
        AND hoc_ky = p_hoc_ky
        AND nam_hoc = p_nam_hoc
        AND (thoi_gian_bat_dau, thoi_gian_ket_thuc)
            OVERLAPS (p_thoi_gian_bat_dau, p_thoi_gian_ket_thuc);

      IF v_count > 0 THEN
          RAISE EXCEPTION 'Phòng học đã được sử dụng cho một lớp học phần khác cùng thời gian.';
      END IF;

      -- Kiểm tra sức chứa phòng học
      SELECT suc_chua INTO v_suc_chua
      FROM PhongHoc
      WHERE ma_phong = p_ma_phong;

      SELECT COUNT(*) INTO v_so_sinh_vien
      FROM DangKyNguyenVongHocPhan
      WHERE ma_hoc_phan = p_ma_hoc_phan
        AND hoc_ky = p_hoc_ky;

      IF v_so_sinh_vien > v_suc_chua THEN
          RAISE EXCEPTION 'Số sinh viên đăng ký (%s) vượt quá sức chứa của phòng học (%s).', v_so_sinh_vien, v_suc_chua;
      END IF;

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

      -- Gán giảng viên
      INSERT INTO PhanCongGiangDay(ma_giang_vien, ma_lop_hoc_phan, vai_tro)
      VALUES (p_ma_giang_vien, v_ma_lop_hoc_phan, p_vai_tro);

      RETURN 'Tạo lớp học phần thành công. Mã lớp học phần: ' || v_ma_lop_hoc_phan;
  EXCEPTION
      WHEN OTHERS THEN
          RETURN 'Lỗi khi tạo lớp học phần: ' || SQLERRM;
  END;
  $$ LANGUAGE plpgsql;