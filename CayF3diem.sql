/*1. Phép Hợp (UNION) - Lấy danh sách tất cả các tiêu đề
Mục tiêu: Tạo ra một danh sách tổng hợp bao gồm cả tên của các "Danh mục" và tên của các "Bài học" để làm dữ liệu cho thanh tìm kiếm (Search bar) trong ứng dụng.*/
-- Lấy tên tất cả danh mục
SELECT Ten_DanhMuc AS TenHienThi, N'Danh mục' AS Loai
FROM DanhMucBaiHoc

UNION

-- Lấy tên tất cả bài học
SELECT TieuDe AS TenHienThi, N'Bài học' AS Loai
FROM BaiHoc;
--2. Phép Giao (INTERSECT) - Tìm các ký hiệu xuất hiện ở cả hai bài học
-- Lấy mã các ký hiệu có trong bài 16
SELECT Ma_KyHieu
FROM BaiHoc_KyHieu
WHERE Ma_BaiHoc = 16

INTERSECT

-- Lấy mã các ký hiệu có trong bài 17
SELECT Ma_KyHieu
FROM BaiHoc_KyHieu
WHERE Ma_BaiHoc = 17;
/*3. Phép Trừ (EXCEPT) - Tìm các bài học "Advance" nhưng chưa được xuất bản
Mục tiêu: Kiểm tra xem bạn có bài học nâng cao nào vẫn đang ở trạng thái NhapBai hay TamAn mà quên chưa đưa lên hệ thống không.*/
-- Lấy tất cả bài học có cấp độ Advance
SELECT TieuDe FROM BaiHoc WHERE CapDo = 'Advance'

EXCEPT

-- Lấy các bài học đã được xuất bản (DaXuatBan)
SELECT TieuDe FROM BaiHoc WHERE TrangThai = N'DaXuatBan';