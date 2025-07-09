CREATE OR REPLACE FUNCTION cap_nhat_diem_cho_sinh_vien(
      p_ma_sinh_vien VARCHAR,
      p_ma_lop_hoc_phan INT,
      p_diem_qua_trinh NUMERIC,
      p_diem_cuoi_ky NUMERIC,
      p_nguoi_thuc_hien VARCHAR -- Thêm tham số người thực hiện
  ) RETURNS TEXT AS $$
  DECLARE
      v_trong_so_qt NUMERIC(3,2);
      v_trong_so_ck NUMERIC(3,2);
      v_diem_ket_thuc NUMERIC(4,2);
  BEGIN
      -- Lấy trọng số của học phần
      SELECT hp.trong_so_qua_trinh, hp.trong_so_cuoi_ky
      INTO v_trong_so_qt, v_trong_so_ck
      FROM LopHocPhan lhp
      JOIN HocPhan hp ON lhp.ma_hoc_phan = hp.ma_hoc_phan
      WHERE lhp.ma_lop_hoc_phan = p_ma_lop_hoc_phan;

      -- Tính điểm kết thúc
      v_diem_ket_thuc := ROUND(p_diem_qua_trinh * v_trong_so_qt + p_diem_cuoi_ky * v_trong_so_ck, 2);

      -- Cập nhật điểm
      UPDATE KetQuaHocTap
      SET
          diem_qua_trinh = p_diem_qua_trinh,
          diem_cuoi_ky = p_diem_cuoi_ky,
          diem_ket_thuc = v_diem_ket_thuc
      WHERE ma_sinh_vien = p_ma_sinh_vien
        AND ma_lop_hoc_phan = p_ma_lop_hoc_phan;

      -- Ghi log
      INSERT INTO LogHoatDong (nguoi_thuc_hien, hanh_dong, mo_ta)
      VALUES (
          p_nguoi_thuc_hien,
          'Nhập điểm',
          FORMAT('Cập nhật điểm cho sinh viên %s, lớp học phần %s: QT = %.2f, CK = %.2f, Kết thúc = %.2f',
                 p_ma_sinh_vien, p_ma_lop_hoc_phan, p_diem_qua_trinh, p_diem_cuoi_ky, v_diem_ket_thuc)
      );

      RETURN FORMAT(
          'Cập nhật điểm thành công cho sinh viên %s trong lớp học phần %s: QT = %.2f, CK = %.2f, Kết thúc = %.2f',
          p_ma_sinh_vien, p_ma_lop_hoc_phan, p_diem_qua_trinh, p_diem_cuoi_ky, v_diem_ket_thuc
      );
  EXCEPTION
      WHEN OTHERS THEN
          RETURN 'Lỗi khi cập nhật điểm: ' || SQLERRM;
  END;
  $$ LANGUAGE plpgsql;