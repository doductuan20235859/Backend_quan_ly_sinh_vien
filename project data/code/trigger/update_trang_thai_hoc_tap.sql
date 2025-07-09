CREATE OR REPLACE FUNCTION auto_update_trang_thai_hoc_tap()
RETURNS TRIGGER AS $$
BEGIN
    -- Nếu là INSERT (sinh viên đăng ký lớp học phần)
    IF TG_OP = 'INSERT' THEN
        NEW.trang_thai_hoc_tap := 'Đang học';


    -- Nếu là UPDATE (giáo viên nhập điểm)
    ELSIF TG_OP = 'UPDATE' AND NEW.diem_ket_thuc IS DISTINCT FROM OLD.diem_ket_thuc THEN
        IF NEW.diem_ket_thuc IS NULL THEN
            NEW.trang_thai_hoc_tap := 'Đang học';
        ELSIF NEW.diem_ket_thuc >= 4.0 THEN
            NEW.trang_thai_hoc_tap := 'Hoàn thành';
        ELSE
            NEW.trang_thai_hoc_tap := 'Trượt';
        END IF;
    END IF;


    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
CREATE OR REPLACE TRIGGER trg_auto_update_trang_thai
BEFORE INSERT OR UPDATE ON KetQuaHocTap
FOR EACH ROW
EXECUTE FUNCTION auto_update_trang_thai_hoc_tap();