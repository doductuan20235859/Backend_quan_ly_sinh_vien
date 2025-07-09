CREATE OR REPLACE FUNCTION check_trung_lich_hoc()
RETURNS TRIGGER AS $$
DECLARE
    v_ma_hoc_phan VARCHAR(20);
    v_count INT;
BEGIN
    -- Lấy mã học phần của lớp học phần đang định đăng ký
    SELECT ma_hoc_phan INTO v_ma_hoc_phan
    FROM LopHocPhan
    WHERE ma_lop_hoc_phan = NEW.ma_lop_hoc_phan;


    -- Kiểm tra sinh viên đã đăng ký học phần này chưa
    IF EXISTS (
        SELECT 1
        FROM KetQuaHocTap
        WHERE ma_sinh_vien = NEW.ma_sinh_vien
          AND ma_hoc_phan = v_ma_hoc_phan
    ) THEN
        RAISE EXCEPTION 'Sinh viên đã đăng ký học phần này trước đó (mã: %)', v_ma_hoc_phan;
    END IF;


    -- Kiểm tra trùng lịch học với các lớp học phần đã đăng ký
    SELECT COUNT(*) INTO v_count
    FROM KetQuaHocTap kq
    JOIN LopHocPhan lhp1 ON kq.ma_lop_hoc_phan = lhp1.ma_lop_hoc_phan
    JOIN LopHocPhan lhp2 ON lhp2.ma_lop_hoc_phan = NEW.ma_lop_hoc_phan
    WHERE kq.ma_sinh_vien = NEW.ma_sinh_vien
      AND lhp1.ngay_trong_tuan = lhp2.ngay_trong_tuan
      AND (lhp1.thoi_gian_bat_dau, lhp1.thoi_gian_ket_thuc)
          OVERLAPS (lhp2.thoi_gian_bat_dau, lhp2.thoi_gian_ket_thuc);


    IF v_count > 0 THEN
        RAISE EXCEPTION 'Lịch học bị trùng với một lớp học phần khác đã đăng ký!';
    END IF;


    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
CREATE OR REPLACE TRIGGER trg_kiem_tra_trung_lich
BEFORE INSERT ON KetQuaHocTap
FOR EACH ROW
EXECUTE FUNCTION check_trung_lich_hoc();
