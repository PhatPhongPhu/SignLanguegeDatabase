/*1. Tìm Ký hiệu có độ dài từ vựng (số ký tự) lớn nhất
Mục tiêu: Tìm từ vựng dài nhất trong hệ thống (Ví dụ: "Trường Đại học Nha Trang"). Việc này giúp bạn kiểm tra xem giao diện hiển thị trên App có bị tràn chữ hay không..*/
SELECT TOP 1 TuVung, LEN(TuVung) AS SoKyTu
FROM KyHieu
ORDER BY LEN(TuVung) DESC;
/*2. Tìm ký hiệu có thứ tự hiển thị nhỏ nhất trong một bài học (Sử dụng MIN)
Mục tiêu: Xác định ký hiệu đầu tiên (khởi đầu) của một bài học cụ thể (ví dụ bài số 5)*/
SELECT MIN(ThuTuHienThi) AS KyHieuDauTien
FROM KyHieu
WHERE Ma_KyHieu IN (SELECT Ma_KyHieu FROM BaiHoc_KyHieu WHERE Ma_BaiHoc = 5);
/*3. Tìm bài học mới nhất vừa được thêm vào hệ thống (Sử dụng MAX trên ID hoặc Ngày)
Mục tiêu: Hiển thị bài học mới lên trang chủ của ứng dụng*/
SELECT * FROM BaiHoc 
WHERE Ma_BaiHoc = (SELECT MAX(Ma_BaiHoc) FROM BaiHoc);
/*4.Tìm Danh mục có tên dài nhất
Mục tiêu: Tìm danh mục có tiêu đề chiếm nhiều không gian nhất trên thanh menu*/
SELECT TOP 1 Ten_DanhMuc, LEN(Ten_DanhMuc) AS DoDaiTen
FROM DanhMucBaiHoc
ORDER BY DoDaiTen DESC;