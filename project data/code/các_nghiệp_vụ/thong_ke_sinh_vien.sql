c. Thủ tục thống kê số lượng sinh viên theo khoa/ngành/lớp
sql
CREATE OR REPLACE FUNCTION thong_ke_sinh_vien(p_theo TEXT DEFAULT 'khoa')
RETURNS TABLE (
    nhom TEXT,
    so_luong INT
) AS $$
BEGIN
    IF LOWER(p_theo) = 'khoa' THEN
        RETURN QUERY
        SELECT k.ten_khoa AS nhom, COUNT(sv.ma_sinh_vien) AS so_luong
        FROM SinhVien sv
        JOIN Lop l ON sv.ma_lop = l.ma_lop
        JOIN GiangVien gv ON l.ma_giang_vien_chu_nhiem = gv.ma_giang_vien
        JOIN Khoa k ON gv.ma_khoa = k.ma_khoa
        GROUP BY k.ten_khoa
        ORDER BY k.ten_khoa;


    ELSIF LOWER(p_theo) = 'nganh' THEN
        RETURN QUERY
        SELECT l.nganh AS nhom, COUNT(sv.ma_sinh_vien) AS so_luong
        FROM SinhVien sv
        JOIN Lop l ON sv.ma_lop = l.ma_lop
        GROUP BY l.nganh
        ORDER BY l.nganh;


    ELSIF LOWER(p_theo) = 'lop' THEN
        RETURN QUERY
        SELECT l.ten_lop AS nhom, COUNT(sv.ma_sinh_vien) AS so_luong
        FROM SinhVien sv
        JOIN Lop l ON sv.ma_lop = l.ma_lop
        GROUP BY l.ten_lop
        ORDER BY l.ten_lop;


    ELSE
        RAISE EXCEPTION 'Tham số không hợp lệ. Chỉ chấp nhận: khoa, nganh, lop.';
    END IF;
END;
$$ LANGUAGE plpgsql;
