CREATE OR REPLACE FUNCTION check_so_tin_chi_toi_da()
RETURNS TRIGGER AS $$
DECLARE
    tong_tin_chi INT := 0;
    tin_chi_moi INT := 0;
BEGIN
    -- Lấy số tín chỉ của học phần đang muốn đăng ký
    SELECT hp.so_tin_chi INTO tin_chi_moi
    FROM LopHocPhan lhp
    JOIN HocPhan hp ON lhp.ma_hoc_phan = hp.ma_hoc_phan
    WHERE lhp.ma_lop_hoc_phan = NEW.ma_lop_hoc_phan;


    -- Tính tổng số tín chỉ hiện tại của sinh viên trong học kỳ, chỉ tính các môn "Đang học"
    SELECT COALESCE(SUM(hp.so_tin_chi), 0) INTO tong_tin_chi
    FROM KetQuaHocTap kq
    JOIN HocPhan hp ON kq.ma_hoc_phan = hp.ma_hoc_phan
    WHERE kq.ma_sinh_vien = NEW.ma_sinh_vien
      AND kq.hoc_ky = NEW.hoc_ky
      AND kq.trang_thai_hoc_tap = 'Đang học';


    -- Kiểm tra nếu tổng sau khi thêm vượt quá 24 tín chỉ
    IF tong_tin_chi + tin_chi_moi >= 24 THEN
        RAISE EXCEPTION 
            'Tổng số tín chỉ đăng ký vượt quá giới hạn 24! Đã đăng ký: %, đăng ký thêm: %, tổng: %',
            tong_tin_chi, tin_chi_moi, tong_tin_chi + tin_chi_moi;
    END IF;


    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER trg_check_so_tin_chi
BEFORE INSERT ON KetQuaHocTap
FOR EACH ROW
EXECUTE FUNCTION check_so_tin_chi_toi_da();

