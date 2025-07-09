---
-- Trigger cho ràng buộc "Giảng viên và Học phần phải cùng khoa"
---
CREATE OR REPLACE FUNCTION check_giang_vien_hoc_phan_cung_khoa()
RETURNS TRIGGER AS $$
DECLARE
    giang_vien_khoa_id INT;
    hoc_phan_khoa_id INT;
BEGIN
    SELECT gv.ma_khoa INTO giang_vien_khoa_id
    FROM GiangVien gv
    WHERE gv.ma_giang_vien = NEW.ma_giang_vien;

    SELECT hp.ma_khoa INTO hoc_phan_khoa_id
    FROM LopHocPhan lhp
    JOIN HocPhan hp ON lhp.ma_hoc_phan = hp.ma_hoc_phan
    WHERE lhp.ma_lop_hoc_phan = NEW.ma_lop_hoc_phan;

    IF giang_vien_khoa_id IS DISTINCT FROM hoc_phan_khoa_id THEN
        RAISE EXCEPTION 'Giảng viên và học phần phải thuộc cùng một khoa. Giảng viên thuộc khoa ID %, Học phần thuộc khoa ID %.', giang_vien_khoa_id, hoc_phan_khoa_id;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER enforce_giang_vien_hoc_phan_cung_khoa
BEFORE INSERT OR UPDATE ON PhanCongGiangDay
FOR EACH ROW
EXECUTE FUNCTION check_giang_vien_hoc_phan_cung_khoa();