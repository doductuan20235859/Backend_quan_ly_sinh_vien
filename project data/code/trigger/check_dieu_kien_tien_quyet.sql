CREATE OR REPLACE FUNCTION check_dieu_kien_tien_quyet()
RETURNS TRIGGER AS $$
DECLARE
    v_ten_hoc_phan VARCHAR(100);
    v_ds_tien_quyet TEXT := '';
BEGIN
    -- Lấy tên học phần đang đăng ký để hiển thị thông báo
    SELECT ten_hoc_phan INTO v_ten_hoc_phan
    FROM HocPhan
    WHERE ma_hoc_phan = NEW.ma_hoc_phan;


    -- Kiểm tra xem có bất kỳ học phần tiên quyết nào không
    IF NOT EXISTS (SELECT 1 FROM DieuKienTienQuyet WHERE ma_hoc_phan_bat_buoc = NEW.ma_hoc_phan) THEN
        RETURN NEW; -- Không có điều kiện tiên quyết, cho phép đăng ký
    END IF;


    -- Tìm tất cả các học phần tiên quyết mà sinh viên CHƯA HOÀN THÀNH
    SELECT STRING_AGG(
               E'- ' || hp.ten_hoc_phan || ' (mã: ' || dk.ma_hoc_phan_tien_quyet || ')',
               E'\n'
           ORDER BY hp.ten_hoc_phan
           )
    INTO v_ds_tien_quyet
    FROM DieuKienTienQuyet dk
    JOIN HocPhan hp ON dk.ma_hoc_phan_tien_quyet = hp.ma_hoc_phan
    WHERE dk.ma_hoc_phan_bat_buoc = NEW.ma_hoc_phan
      AND NOT EXISTS ( -- Kiểm tra xem sinh viên đã hoàn thành học phần tiên quyết này chưa
            SELECT 1
            FROM KetQuaHocTap
            WHERE ma_sinh_vien = NEW.ma_sinh_vien
              AND ma_hoc_phan = dk.ma_hoc_phan_tien_quyet
              AND diem_ket_thuc >= 4.0
          );
    -- Nếu có học phần tiên quyết chưa hoàn thành
    IF v_ds_tien_quyet IS NOT NULL THEN -- STRING_AGG sẽ trả về NULL nếu không có hàng nào
        RAISE EXCEPTION
            'Không thể đăng ký học phần "%" (mã: %). Sinh viên chưa hoàn thành các học phần tiên quyết sau:%',
            v_ten_hoc_phan, NEW.ma_hoc_phan, E'\n' || v_ds_tien_quyet; -- Thêm E'\n' để định dạng đẹp hơn
    END IF;


    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
---
-- Tạo trigger
CREATE OR REPLACE TRIGGER trg_kiem_tra_tien_quyet
BEFORE INSERT ON DangKyNguyenVongHocPhan
FOR EACH ROW
EXECUTE FUNCTION check_dieu_kien_tien_quyet();