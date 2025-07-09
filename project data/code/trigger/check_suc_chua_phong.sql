CREATE OR REPLACE FUNCTION check_suc_chua_phong_on_enrollment()
RETURNS TRIGGER AS $$
DECLARE
    suc_chua_phong INT;
    so_sv_hien_tai INT;
    ma_phong_cua_lop INT;
BEGIN
    -- Lấy mã phòng của lớp học phần mà sinh viên đang cố gắng đăng ký
    SELECT ma_phong INTO ma_phong_cua_lop
    FROM LopHocPhan
    WHERE ma_lop_hoc_phan = NEW.ma_lop_hoc_phan;


    -- Nếu lớp học phần không có phòng được chỉ định, không cần kiểm tra sức chứa
    IF ma_phong_cua_lop IS NULL THEN
        RETURN NEW;
    END IF;


    -- Lấy sức chứa của phòng học
    SELECT suc_chua INTO suc_chua_phong
    FROM PhongHoc
    WHERE ma_phong = ma_phong_cua_lop;


    -- Đếm số sinh viên HIỆN TẠI đã đăng ký chính thức vào lớp học phần này
    -- (Trừ bản ghi đang được INSERT/UPDATE để tránh đếm hai lần hoặc lỗi nếu là UPDATE)
    SELECT COUNT(*) INTO so_sv_hien_tai
    FROM KetQuaHocTap
    WHERE ma_lop_hoc_phan = NEW.ma_lop_hoc_phan
      AND ma_sinh_vien <> NEW.ma_sinh_vien; -- Loại trừ bản ghi hiện tại nếu là UPDATE


    -- Kiểm tra nếu số sinh viên hiện tại + 1 (cho sinh viên đang đăng ký) vượt quá sức chứa
    IF so_sv_hien_tai + 1 > suc_chua_phong THEN
        RAISE EXCEPTION 'Phòng học của lớp học phần % (phòng %) đã đủ sức chứa (sức chứa: %, hiện có: % sinh viên). Không thể thêm sinh viên %.',
                        NEW.ma_lop_hoc_phan, ma_phong_cua_lop, suc_chua_phong, so_sv_hien_tai, NEW.ma_sinh_vien;
    END IF;


    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


-- Tạo trigger trên bảng KetQuaHocTap
-- Kích hoạt TRƯỚC khi INSERT hoặc UPDATE trên KetQuaHocTap
CREATE TRIGGER trg_check_suc_chua_on_enrollment
BEFORE INSERT ON KetQuaHocTap -- Chỉ cần BEFORE INSERT vì UPDATE không làm tăng số lượng sinh viên
FOR EACH ROW
EXECUTE FUNCTION check_suc_chua_phong_on_enrollment();