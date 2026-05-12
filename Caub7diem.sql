/*7 câu truy vấn mẫu sử dụng các hàm gom nhóm (Aggregate Functions) như COUNT, SUM, AVG, MIN, MAX
Câu 1: Đếm tổng số bài học hiện có theo từng cấp độ (Sử dụng COUNT) */
SELECT CapDo, COUNT(Ma_BaiHoc) AS SoLuongBaiHoc
FROM BaiHoc
GROUP BY CapDo;
--Câu 2: Tính tổng thời lượng học dự kiến của toàn bộ chương trình (Sử dụng SUM)
SELECT SUM(ThoiLuongDuKien) AS TongPhutHoc
FROM BaiHoc;
--Câu 3: Tìm số lượng ký hiệu ít nhất và nhiều nhất trong các bài học (Sử dụng MIN, MAX)
SELECT 
    MIN(TongSoKyHieu) AS ItNhat, 
    MAX(TongSoKyHieu) AS NhieuNhat
FROM (
    SELECT COUNT(Ma_KyHieu) AS TongSoKyHieu
    FROM BaiHoc_KyHieu
    GROUP BY Ma_BaiHoc
) AS ThongKe;
--Câu 4: Tính thời lượng học trung bình của các bài học đã xuất bản (Sử dụng AVG)
SELECT AVG(ThoiLuongDuKien) AS ThoiLuongTrungBinh
FROM BaiHoc
WHERE TrangThai = N'DaXuatBan';
--Câu 5: Liệt kê các bài học có trên 5 ký hiệu (Sử dụng COUNT và HAVING)
IF EXISTS (
    SELECT b.TieuDe
    FROM BaiHoc b
    JOIN BaiHoc_KyHieu bk ON b.Ma_BaiHoc = bk.Ma_BaiHoc
    GROUP BY b.TieuDe
    HAVING COUNT(bk.Ma_KyHieu) > 5
)
BEGIN
    -- Nếu có bài thỏa mãn thì hiện bảng dữ liệu
    SELECT b.TieuDe, COUNT(bk.Ma_KyHieu) AS SoKyHieu
    FROM BaiHoc b
    JOIN BaiHoc_KyHieu bk ON b.Ma_BaiHoc = bk.Ma_BaiHoc
    GROUP BY b.TieuDe
    HAVING COUNT(bk.Ma_KyHieu) > 5;
END
ELSE
BEGIN
    -- Nếu không có bài nào > 5 ký hiệu thì hiện thông báo
    PRINT N'Tạm thời chưa có';
    -- Hoặc hiện dưới dạng 1 dòng bảng để đẹp báo cáo:
    SELECT N'Tạm thời chưa có' AS ThongBao;
END
--Câu 6: Thống kê số lượng ký hiệu theo độ khó (Sử dụng COUNT kết hợp bảng KyHieu)
SELECT DoKho, COUNT(Ma_KyHieu) AS SoLuong
FROM KyHieu
GROUP BY DoKho
ORDER BY SoLuong DESC;
--Câu 7: Liệt kê danh sách các Bài học kèm theo số lượng Ký hiệu tương ứng (Sử dụng COUNT và JOIN)
SELECT 
    b.Ma_BaiHoc,
    b.TieuDe, 
    COUNT(bk.Ma_KyHieu) AS TongSoKyHieu
FROM BaiHoc b
LEFT JOIN BaiHoc_KyHieu bk ON b.Ma_BaiHoc = bk.Ma_BaiHoc
GROUP BY b.Ma_BaiHoc, b.TieuDe
ORDER BY TongSoKyHieu DESC;