CREATE DATABASE QLHOCNGONNGUKYHIEU;
GO
USE QLHOCNGONNGUKYHIEU;
GO

DROP TABLE IF EXISTS BaoCaoLoi;
DROP TABLE IF EXISTS LichSuHoc;
DROP TABLE IF EXISTS KetQuaBaiHoc;
DROP TABLE IF EXISTS TienDo;
DROP TABLE IF EXISTS PhuongAnTraLoi;

DROP TABLE IF EXISTS CauHoi;
DROP TABLE IF EXISTS DangKyHoc;
DROP TABLE IF EXISTS DaPhuongTien;

DROP TABLE IF EXISTS BaiHoc_KyHieu;

DROP TABLE IF EXISTS KyHieu;
DROP TABLE IF EXISTS BaiHoc;
DROP TABLE IF EXISTS NguoiDung;
DROP TABLE IF EXISTS DanhMucBaiHoc;

DROP TABLE IF EXISTS VaiTro;
GO

CREATE TABLE VaiTro(
	Ma_VaiTro INT PRIMARY KEY IDENTITY(1,1),
	Ten_VaiTro NVARCHAR(30) NOT NULL,
	MoTa NVARCHAR(500) NOT NULL
);
GO

CREATE TABLE NguoiDung(
	Ma_NguoiDung INT PRIMARY KEY IDENTITY(1,1),
	Ho NVARCHAR(30) NOT NULL,
	Ten NVARCHAR(30) NOT NULL,
	Email NVARCHAR(30) NOT NULL,
	MatKhau NVARCHAR(50) NOT NULL,
	Ma_VaiTro INT NOT NULL,
	IsDeaf BIT NOT NULL DEFAULT 0,
	NgayLap DATETIME NOT NULL DEFAULT GETDATE(),
	SoDienThoai NVARCHAR(30),
	AnhDaiDien NVARCHAR(500),
	TrangThai NVARCHAR(30) NOT NULL DEFAULT N'HoatDong' CHECK (TrangThai IN (N'HoatDong',N'KhoaTaiKhoan',N'ChoXacNhan')),
	NgayCapNhat DATETIME NOT NULL DEFAULT GETDATE(),
	CONSTRAINT FK_NguoiDung_VaiTro FOREIGN KEY (Ma_VaiTro) REFERENCES VaiTro(Ma_VaiTro)
);
GO

CREATE TABLE BaiHoc(
	Ma_BaiHoc INT PRIMARY KEY IDENTITY(1,1),
	TieuDe NVARCHAR(200) NOT NULL,
	MoTa NVARCHAR(500),
	CapDo NVARCHAR(20) NOT NULL CHECK(CapDo IN ('Beginner','Intermediate','Advance')),
	Ma_NguoiTao INT NOT NULL,
	NgayTaoBai DATETIME NOT NULL DEFAULT GETDATE(),
	TrangThai NVARCHAR(30) NOT NULL DEFAULT N'NhapBai' CHECK (TrangThai IN (N'NhapBai', N'DaXuatBan',N'TamAn')),
	ThuTu INT NOT NULL DEFAULT 1,
	ThoiLuongDuKien INT,
	AnhDaiDien NVARCHAR(500),
	CONSTRAINT FK_BaiHoc_NguoiDung FOREIGN KEY (Ma_NguoiTao) REFERENCES NguoiDung(Ma_NguoiDung)
);
GO

CREATE TABLE KyHieu(
	Ma_KyHieu INT PRIMARY KEY IDENTITY(1,1),
	TuVung NVARCHAR(100) NOT NULL,
	MoTa NVARCHAR(500),
	TrangThai NVARCHAR(30) NOT NULL DEFAULT N'HoatDong' CHECK (TrangThai IN (N'HoatDong',N'KhongHoatDong')),
	ThuTuHienThi INT NOT NULL DEFAULT 1,
	DoKho NVARCHAR(20) NOT NULL DEFAULT N'De' CHECK (DoKho IN(N'De',N'TrungBinh',N'Kho'))
);
GO

CREATE TABLE BaiHoc_KyHieu(
	Ma_BaiHoc INT NOT NULL,
	Ma_KyHieu INT NOT NULL,
	ThuTu INT NOT NULL DEFAULT 1,
	CONSTRAINT PK_BaiHoc_KyHieu PRIMARY KEY (Ma_BaiHoc,Ma_KyHieu),
	CONSTRAINT FK_BHKH_BaiHoc FOREIGN KEY (Ma_BaiHoc) REFERENCES BaiHoc(Ma_BaiHoc),
	CONSTRAINT FK_BHKH_KyHieu FOREIGN KEY (Ma_KyHieu) REFERENCES KyHieu(Ma_KyHieu)
);
GO

CREATE TABLE DaPhuongTien(
	Ma_DaPhuongTien INT PRIMARY KEY IDENTITY(1,1),
	Ma_KyHieu INT NOT NULL,
	LoaiTep NVARCHAR(30) NOT NULL CHECK(LoaiTep IN ('Video','Anh')),
	LaChinh BIT NOT NULL DEFAULT 0,
	NgayTaiLen DATETIME NOT NULL DEFAULT GETDATE(),
	DuongDanTep NVARCHAR(30) NOT NULL,
	TenTep NVARCHAR(30) NOT NULL,
	MoTa NVARCHAR(500),
	ThoiLuong INT,
	KichThuocTep BIGINT NOT NULL,
	CONSTRAINT FK_DaPhuongTien_KyHieu FOREIGN KEY (Ma_KyHieu) REFERENCES KyHieu(Ma_KyHieu)
);
GO

CREATE TABLE DangKyHoc(
	Ma_DangKy INT PRIMARY KEY IDENTITY(1,1),
	Ma_NguoiDung INT NOT NULL,
	Ma_BaiHoc INT NOT NULL,
	NgayDangKy DATETIME NOT NULL DEFAULT GETDATE(),
	TrangThaiHoc NVARCHAR(30) NOT NULL DEFAULT N'ChuaBatDau' CHECK (TrangThaiHoc IN (N'ChuaBatDau',N'DangHoc',N'HoanThanh')),
	NgayHoanThanh DATETIME,
	PhanTramHoanThanh FLOAT NOT NULL DEFAULT 0 CHECK (PhanTramHoanThanh BETWEEN 0 AND 100),
	CONSTRAINT FK_DangKyHoc_NguoiDung FOREIGN KEY (Ma_NguoiDung) REFERENCES NguoiDung(Ma_NguoiDung),
	CONSTRAINT FK_DangKyHoc_BaiHoc FOREIGN KEY (Ma_BaiHoc) REFERENCES BaiHoc(Ma_BaiHoc),
	CONSTRAINT UNQ_DangKy UNIQUE (Ma_NguoiDung,Ma_BaiHoc)
);
GO

CREATE TABLE CauHoi(
	Ma_CauHoi INT PRIMARY KEY IDENTITY(1,1),
	Ma_BaiHoc INT NOT NULL,
	NoiDungCauHoi NVARCHAR(100) NOT NULL,
	Ma_KyHieuDung INT NOT NULL,
	LoaiCauHoi NVARCHAR(30) NOT NULL DEFAULT N'TracNghiem' CHECK( LoaiCauHoi IN (N'TracNghiem',N'DienKhuyet',N'NhanBiet')),
	DiemMacDinh FLOAT NOT NULL DEFAULT 10,
	GiaiThich NVARCHAR(300),
	CONSTRAINT FK_CauHoi_BaiHoc FOREIGN KEY (Ma_BaiHoc) REFERENCES BaiHoc(Ma_BaiHoc),
	CONSTRAINT FL_CauHoi_KyHieu FOREIGN KEY (Ma_KyHieuDung) REFERENCES KyHieu(Ma_KyHieu)
);
GO

CREATE TABLE TienDo(
	Ma_TienDo INT PRIMARY KEY IDENTITY(1,1),
	Ma_NguoiDung INT NOT NULL,
	Ma_CauHoi INT NOT NULL,
	DapAnDung BIT NOT NULL DEFAULT 0,
	DiemSo FLOAT NOT NULL DEFAULT 0,
	ThoiDiemThucHien DATETIME NOT NULL DEFAULT GETDATE(),
	SoLanThu INT NOT NULL DEFAULT 1,
	ThoiGianLam INT NOT NULL DEFAULT 0,
	TrangThai NVARCHAR(30) NOT NULL DEFAULT N'HoanThanh' CHECK (TrangThai IN(N'HoanThanh',N'ChuaDat',N'DangLam')),	
	CONSTRAINT FK_TienDo_NguoiDung FOREIGN KEY (Ma_NguoiDung) REFERENCES NguoiDung(Ma_NguoiDung),
	CONSTRAINT FK_TienDo_CauHoi FOREIGN KEY (Ma_CauHoi) REFERENCES CauHoi(Ma_CauHoi)
);
GO

CREATE TABLE DanhMucBaiHoc(
	Ma_DanhMuc INT PRIMARY KEY IDENTITY(1,1),
	Ten_DanhMuc NVARCHAR(100) NOT NULL,
	MoTa NVARCHAR(300),
	TrangThai NVARCHAR(30) NOT NULL DEFAULT N'HoatDong' CHECK (TrangThai IN(N'HoatDong',N'KhongHoatDong')),
);
GO

CREATE TABLE PhuongAnTraLoi(
	Ma_PhuongAn INT PRIMARY KEY IDENTITY(1,1),
	Ma_CauHoi INT,
	NoiDung NVARCHAR(500) NOT NULL,
	LaDapAnDung BIT NOT NULL DEFAULT 0,
	ThuTu INT NOT NULL DEFAULT 1,
	CONSTRAINT FK_PhuongAnTraLoi_CauHoi FOREIGN KEY (Ma_CauHoi) REFERENCES CauHoi(Ma_CauHoi)
);
GO

CREATE TABLE KetQuaBaiHoc(
	Ma_KetQua INT PRIMARY KEY IDENTITY(1,1),
	Ma_NguoiDung INT NOT NULL,
	Ma_BaiHoc INT NOT NULL,
	DiemTong FLOAT NOT NULL DEFAULT 0,
	PhanTramDung FLOAT NOT NULL DEFAULT 0 CHECK (PhanTramDung BETWEEN 0 AND 100),
	NgayHoanThanh DATETIME,
	TrangThai NVARCHAR(20) NOT NULL DEFAULT N'Dat' CHECK (TrangThai IN(N'Dat',N'KhongDat')),
	CONSTRAINT FK_KetQuaBaiHoc_NguoiDung FOREIGN KEY (Ma_NguoiDung) REFERENCES NguoiDung(Ma_NguoiDung),
	CONSTRAINT FK_KetQuaBaiHoc_BaiHoc FOREIGN KEY (Ma_BaiHoc) REFERENCES BaiHoc(Ma_BaiHoc)
);
GO

CREATE TABLE LichSuHoc(
	Ma_LichSu INT PRIMARY KEY IDENTITY(1,1),
	Ma_NguoiDung INT NOT NULL,
	Ma_BaiHoc INT NOT NULL,
	ThoiGianBatDau DATETIME NOT NULL DEFAULT GETDATE(),
	ThoiGianKetThuc DATETIME NOT NULL,
	GhiChu NVARCHAR(500) NOT NULL,
	CONSTRAINT FK_LichSuHoc_NguoiDung FOREIGN KEY (Ma_NguoiDung) REFERENCES NguoiDung(Ma_NguoiDung),
	CONSTRAINT FK_LichSuHoc_BaiHoc FOREIGN KEY (Ma_BaiHoc) REFERENCES BaiHoc(Ma_BaiHoc)
);
GO

CREATE TABLE BaoCaoLoi(
	Ma_BaoCao INT PRIMARY KEY IDENTITY(1,1),
	Ma_KyHieu INT NOT NULL,
	Ma_NguoiDung INT NOT NULL,
	NoiDungLoi NVARCHAR(500) NOT NULL,
	NgayBaoCao DATETIME NOT NULL DEFAULT GETDATE(),
	TrangThai NVARCHAR(30) NOT NULL DEFAULT N'DaXuLy' CHECK(TrangThai IN(N'DaXuLy',N'ChuaXuLy',N'DangXuLy')),
	CONSTRAINT FK_BaoCaoLoi_KyHieu FOREIGN KEY (Ma_KyHieu) REFERENCES KyHieu(Ma_KyHieu),
	CONSTRAINT FK_BaoCaoLoi_NguoiDung FOREIGN KEY (Ma_NguoiDung) REFERENCES NguoiDung(Ma_NguoiDung)
);
GO

/*Nhập dữ liệu cho hệ thống*/

--------------------VaiTro---------------------
INSERT INTO VaiTro(Ten_VaiTro,MoTa) VALUES
(N'Admin',			N'Quản trị toàn bộ hệ thống, có tất cả quyền hạn'),
(N'Giảng viên',		N'Soạn thảo bài học, quản lý ký hiệu và câu hỏi'),
(N'Học Viên',		N'Người tham gia các khóa học ký hiệu'),
(N'Kiểm duyệt',		N'Kiểm duyệt nội dung trước khi xuất bản'),
(N'Chuyên gia',		N'Hỗ trợ kiểm duyệt nội dung');
GO
-----------------------------------------------

--------------------NguoiDung------------------
INSERT INTO NguoiDung(Ho,Ten,Email,MatKhau,Ma_VaiTro,IsDeaf,SoDienThoai,TrangThai) VALUES
(N'Nguyễn',		N'A',	N'A@gmail.com',	N'A123',	1,	0,	0901234561,	N'HoatDong'),
(N'Nguyễn',		N'B',	N'B@gmail.com',	N'B123',	2,	0,	0901234562,	N'HoatDong'),
(N'Nguyễn',		N'C',	N'C@gmail.com',	N'C123',	2,	0,	0901234563,	N'HoatDong'),
(N'Nguyễn',		N'D',	N'D@gmail.com',	N'D123',	3,	0,	0901234564,	N'HoatDong'),
(N'Nguyễn',		N'E',	N'E@gmail.com',	N'E123',	3,	1,	0901234565,	N'HoatDong'),
(N'Nguyễn',		N'F',	N'F@gmail.com',	N'F123',	3,	0,	0901234566,	N'ChoXacNhan'),
(N'Nguyễn',		N'G',	N'G@gmail.com',	N'G123',	2,	0,	0901234567,	N'HoatDong'),
(N'Nguyễn',		N'H',	N'H@gmail.com',	N'H123',	3,	1,	0901234568,	N'HoatDong'),
(N'Nguyễn',		N'I',	N'I@gmail.com',	N'I123',	3,	0,	0901234569,	N'KhoaTaiKhoan'),
(N'Nguyễn',		N'J',	N'J@gmail.com',	N'J123',	3,	0,	0901234570,	N'HoatDong'),
(N'Nguyễn',		N'K',	N'K@gmail.com',	N'K123',	3,	1,	0901234571,	N'ChoXacNhan'),
(N'Nguyễn',		N'L',	N'L@gmail.com',	N'L123',	3,	0,	0901234572,	N'HoatDong'),
(N'Nguyễn',		N'M',	N'M@gmail.com',	N'M123',	4,	0,	0901234573,	N'HoatDong'),
(N'Nguyễn',		N'N',	N'N@gmail.com',	N'N123',	3,	0,	0901234574,	N'KhoaTaiKhoan'),
(N'Nguyễn',		N'O',	N'O@gmail.com',	N'O123',	2,	0,	0901234575,	N'HoatDong'),
(N'Nguyễn',		N'P',	N'P@gmail.com',	N'P123',	2,	0,	0901234576,	N'HoatDong'),
(N'Nguyễn',		N'Q',	N'Q@gmail.com',	N'Q123',	3,	1,	0901234577,	N'HoatDong'),
(N'Nguyễn',		N'R',	N'R@gmail.com',	N'R123',	3,	0,	0901234578,	N'ChoXacNhan'),
(N'Nguyễn',		N'S',	N'S@gmail.com',	N'S123',	2,	0,	0901234579,	N'HoatDong'),
(N'Nguyễn',		N'T',	N'T@gmail.com',	N'T123',	5,	0,	0901234580,	N'HoatDong'),
(N'Nguyễn',		N'U',	N'U@gmail.com',	N'U123',	3,	0,	0901234581,	N'HoatDong');
GO
-----------------------------------------------

---------------DanhMucMonHoc-------------------
INSERT INTO DanhMucBaiHoc (Ten_DanhMuc, MoTa, TrangThai) VALUES
(N'Chào hỏi cơ bản',		N'Các ký hiệu chào hỏi thông dụng hàng ngày',			N'HoatDong'),
(N'Gia đình',				N'Ký hiệu về các thành viên trong gia đình',            N'HoatDong'),
(N'Màu sắc',				N'Ký hiệu biểu thị các màu sắc phổ biến',               N'HoatDong'),
(N'Số đếm',					N'Ký hiệu số từ 0 đến 100',                             N'HoatDong'),
(N'Thức ăn và đồ uống',		N'Ký hiệu về các loại thức ăn và đồ uống',              N'HoatDong'),
(N'Động vật',				N'Ký hiệu về các con vật quen thuộc',                   N'HoatDong'),
(N'Nghề nghiệp',			N'Ký hiệu về các ngành nghề trong xã hội',              N'HoatDong'),
(N'Giao thông',				N'Ký hiệu về phương tiện và giao thông',                N'HoatDong'),
(N'Cảm xúc',				N'Ký hiệu biểu đạt cảm xúc và trạng thái tâm lý',       N'HoatDong'),
(N'Thời tiết',				N'Ký hiệu mô tả các hiện tượng thời tiết',              N'HoatDong'),
(N'Trường học',				N'Ký hiệu liên quan đến môi trường học đường',          N'HoatDong'),
(N'Sức khỏe và y tế',		N'Ký hiệu về bệnh tật và chăm sóc sức khỏe',            N'HoatDong'),
(N'Thể thao',				N'Ký hiệu về các môn thể thao phổ biến',                N'HoatDong'),
(N'Thiên nhiên',			N'Ký hiệu về cây cối, hoa lá và thiên nhiên',           N'HoatDong'),
(N'Thời gian',				N'Ký hiệu về ngày tháng năm và thời điểm',              N'HoatDong'),
(N'Nhà cửa',				N'Ký hiệu về đồ vật và không gian trong nhà',           N'HoatDong'),
(N'Công nghệ',              N'Ký hiệu về thiết bị và công nghệ hiện đại',           N'HoatDong'),
(N'Du lịch',                N'Ký hiệu về địa điểm và hoạt động du lịch',            N'HoatDong'),
(N'Mua sắm',                N'Ký hiệu về hoạt động mua bán và trao đổi',            N'HoatDong'),
(N'Nâng cao',               N'Tổng hợp ký hiệu nâng cao cho người học lâu năm',     N'KhongHoatDong');
GO
-----------------------------------------------

--------------------BaiHoc---------------------
INSERT INTO BaiHoc (TieuDe,MoTa,CapDo,Ma_NguoiTao,TrangThai,ThuTu,ThoiLuongDuKien) VALUES 
(N'Chào hỏi cơ bản',			N'Học cách chào hỏi bằng ngôn ngữ ký hiệu',		'Beginner',		2,	N'DaXuatBan',	1,	30),
(N'Gia đình thân yêu',			N'Ký hiệu về các thành viên trong gia đình',	'Beginner',		2,  N'DaXuatBan',	2,  45),
(N'Màu sắc',					N'Nhận biết và ký hiệu màu sắc',				'Beginner',		3,  N'DaXuatBan',	3,  30),
(N'Đếm số từ 1 đến 20',			N'Học ký hiệu số đếm',							'Beginner',		2,	N'DaXuatBan',	4,  40),
(N'Đồ ăn',						N'Ký hiệu về các món ăn phổ biến',				'Beginner',		3,	N'DaXuatBan',	5,  50),
(N' Các loài động vật',			N'Ký hiệu tên các loài động vật',				'Beginner',		7,	N'DaXuatBan',	6,  35),
(N'Nghề nghiệp ',				N'Học ký hiệu về các nghề nghiệp',				'Intermediate', 16, N'DaXuatBan',	7,  60),
(N'Giao thông và phương tiện',	N'Ký hiệu về xe cộ và đường phố',				'Intermediate', 15, N'DaXuatBan',	8,  55),
(N'Biểu đạt cảm xúc',			N'Ký hiệu cảm xúc vui buồn giận hờn',			'Intermediate', 19, N'DaXuatBan',	9,  45),
(N'Thời tiết và khí hậu',		N'Ký hiệu mô tả thời tiết',						'Beginner',		7,	N'DaXuatBan',	10, 30),
(N'Trường học ',				N'Ký hiệu về môi trường giáo dục',				'Beginner',		15, N'DaXuatBan',	11, 40),
(N'Chăm sóc sức khỏe',			N'Ký hiệu y tế và chăm sóc sức khỏe',			'Intermediate', 16, N'DaXuatBan',	12, 70),
(N'Các môn thể thao',			N'Ký hiệu các môn thể thao',					'Intermediate', 19, N'DaXuatBan',	13, 60),
(N'Thiên nhiên',				N'Ký hiệu về cây cối thiên nhiên',				'Beginner',		3,  N'NhapBai',		14, 35),
(N'Ngày tháng và thời gian',	N'Ký hiệu thời gian ngày tháng năm',			'Beginner',		16, N'DaXuatBan',	15, 45),
(N'Trong nhà của bạn',			N'Ký hiệu đồ vật trong nhà',					'Beginner',		19, N'DaXuatBan',	16, 40),
(N'Công nghệ hiện đại',			N'Ký hiệu về thiết bị công nghệ',				'Advance',		7,  N'TamAn',		17, 80),
(N'Du lịch',					N'Ký hiệu phục vụ du lịch',						'Intermediate', 2,  N'DaXuatBan',	18, 65),
(N'Mua sắm và trao đổi',		N'Ký hiệu cho hoạt động mua bán',				'Intermediate', 15, N'DaXuatBan',	19, 55),
(N'Ôn tập nâng cao',			N'Bài học tổng hợp trình độ nâng cao',			'Advance',		3,  N'NhapBai',		20, 120);
GO
-----------------------------------------------

----------------KyHieu-------------------------
INSERT INTO KyHieu (TuVung, MoTa, TrangThai, ThuTuHienThi, DoKho) VALUES
(N'Xin chào',       N'Ký hiệu chào hỏi thông thường',                  N'HoatDong', 1,  N'De'),
(N'Cảm ơn',         N'Ký hiệu bày tỏ lòng biết ơn',                    N'HoatDong', 2,  N'De'),
(N'Xin lỗi',        N'Ký hiệu xin lỗi và xin phép',                    N'HoatDong', 3,  N'De'),
(N'Bố',             N'Ký hiệu chỉ người cha trong gia đình',           N'HoatDong', 4,  N'De'),
(N'Mẹ',             N'Ký hiệu chỉ người mẹ trong gia đình',            N'HoatDong', 5,  N'De'),
(N'Anh',            N'Ký hiệu chỉ người anh trai',                     N'HoatDong', 6,  N'De'),
(N'Em',             N'Ký hiệu chỉ em trai hoặc em gái nhỏ hơn',        N'HoatDong', 7,  N'De'),
(N'Màu đỏ',         N'Ký hiệu biểu thị màu đỏ',                        N'HoatDong', 8,  N'De'),
(N'Màu xanh',       N'Ký hiệu biểu thị màu xanh lá và xanh dương',     N'HoatDong', 9,  N'De'),
(N'Một',            N'Ký hiệu số 1',                                   N'HoatDong', 10, N'De'),
(N'Mười',           N'Ký hiệu số 10',                                  N'HoatDong', 11, N'De'),
(N'Cơm',            N'Ký hiệu chỉ cơm – món ăn chủ yếu',               N'HoatDong', 12, N'De'),
(N'Nước',           N'Ký hiệu chỉ nước uống',                          N'HoatDong', 13, N'De'),
(N'Mèo',            N'Ký hiệu con mèo',                                N'HoatDong', 14, N'De'),
(N'Chó',            N'Ký hiệu con chó',                                N'HoatDong', 15, N'De'),
(N'Bác sĩ',         N'Ký hiệu nghề bác sĩ',                            N'HoatDong', 16, N'TrungBinh'),
(N'Giáo viên',      N'Ký hiệu nghề giáo viên',                         N'HoatDong', 17, N'TrungBinh'),
(N'Xe máy',         N'Ký hiệu phương tiện xe máy',                     N'HoatDong',	18, N'TrungBinh'),
(N'Vui vẻ',         N'Ký hiệu biểu lộ cảm xúc vui vẻ hạnh phúc',		N'HoatDong', 19, N'De'),
(N'Buồn',           N'Ký hiệu biểu lộ cảm xúc buồn bã',					N'HoatDong', 20, N'TrungBinh');
GO
-----------------------------------------------

------------------BaiHoc_KyHieu----------------
INSERT INTO BaiHoc_KyHieu (Ma_BaiHoc, Ma_KyHieu, ThuTu) VALUES
(1,  1,  1),
(1,  2,  2),
(1,  3,  3),
(2,  4,  1),
(2,  5,  2),
(2,  6,  3),
(2,  7,  4),
(3,  8,  1),
(3,  9,  2),
(4,  10, 1),
(4,  11, 2),
(5,  12, 1),
(5,  13, 2),
(6,  14, 1),
(6,  15, 2),
(7,  16, 1),
(7,  17, 2),
(8,  18, 1),
(9,  19, 1),
(9,  20, 2);
GO
-----------------------------------------------

--------------DaPhuongTien---------------------
INSERT INTO DaPhuongTien (Ma_KyHieu, LoaiTep, LaChinh, DuongDanTep, TenTep, MoTa, ThoiLuong, KichThuocTep) VALUES
(1,  'Video', 1, '/media/video/',  'xin_chao.mp4',    N'Video minh họa ký hiệu Xin chào',    8,   2048000),
(1,  'Anh',   0, '/media/image/',  'xin_chao.jpg',   N'Ảnh minh họa ký hiệu Xin chào',     NULL, 102400),
(2,  'Video', 1, '/media/video/',  'cam_on.mp4',      N'Video minh họa ký hiệu Cảm ơn',     7,   1920000),
(3,  'Video', 1, '/media/video/',  'xin_loi.mp4',     N'Video minh họa ký hiệu Xin lỗi',    6,   1800000),
(4,  'Video', 1, '/media/video/',  'bo.mp4',          N'Video minh họa ký hiệu Bố',         5,   1500000),
(4,  'Anh',   0, '/media/image/',  'bo.jpg',         N'Ảnh minh họa ký hiệu Bố',           NULL, 89600),
(5,  'Video', 1, '/media/video/',  'me.mp4',          N'Video minh họa ký hiệu Mẹ',         5,   1500000),
(6,  'Video', 1, '/media/video/',  'anh.mp4',         N'Video minh họa ký hiệu Anh',        6,   1600000),
(7,  'Video', 1, '/media/video/',  'em.mp4',          N'Video minh họa ký hiệu Em',         5,   1450000),
(8,  'Video', 1, '/media/video/',  'do.mp4',          N'Video minh họa ký hiệu Màu đỏ',     4,   1200000),
(8,  'Anh',   0, '/media/image/',  'do.jpg',		 N'Ảnh màu đỏ minh họa',               NULL, 75000),
(9,  'Video', 1, '/media/video/',  'xanh.mp4',        N'Video minh họa ký hiệu Màu xanh',   4,   1200000),
(10, 'Video', 1, '/media/video/',  'mot.mp4',         N'Video minh họa ký hiệu số Một',     3,   900000),
(11, 'Video', 1, '/media/video/',  'muoi.mp4',        N'Video minh họa ký hiệu số Mười',    4,   1100000),
(12, 'Video', 1, '/media/video/',  'com.mp4',         N'Video minh họa ký hiệu Cơm',        5,   1400000),
(13, 'Video', 1, '/media/video/',  'nuoc.mp4',        N'Video minh họa ký hiệu Nước',       4,   1100000),
(14, 'Video', 1, '/media/video/',  'meo.mp4',         N'Video minh họa ký hiệu Mèo',        5,   1350000),
(15, 'Video', 1, '/media/video/',  'cho.mp4',         N'Video minh họa ký hiệu Chó',        5,   1380000),
(19, 'Video', 1, '/media/video/',  'vui.mp4',         N'Video minh họa ký hiệu Vui vẻ',     6,   1600000),
(20, 'Video', 1, '/media/video/',  'buon.mp4',        N'Video minh họa ký hiệu Buồn',       6,   1600000);
GO
-----------------------------------------------

------------------DangKyHoc--------------------
INSERT INTO DangKyHoc (Ma_NguoiDung, Ma_BaiHoc, TrangThaiHoc, PhanTramHoanThanh, NgayHoanThanh) VALUES
(4,  1,  N'HoanThanh', 100, '2025-01-15'),
(4,  2,  N'HoanThanh', 100, '2025-01-20'),
(5,  1,  N'HoanThanh', 100, '2025-02-10'),
(5,  3,  N'DangHoc',   60,  NULL),
(6,  1,  N'HoanThanh', 100, '2025-01-25'),
(6,  2,  N'DangHoc',   45,  NULL),
(12, 1,  N'DangHoc',   70,  NULL),
(12, 4,  N'ChuaBatDau',0,   NULL),
(8,  2,  N'HoanThanh', 100, '2025-03-05'),
(8,  5,  N'DangHoc',   30,  NULL),
(10, 1,  N'HoanThanh', 100, '2025-02-28'),
(10, 6,  N'DangHoc',   55,  NULL),
(11, 3,  N'ChuaBatDau',0,   NULL),
(11, 7,  N'DangHoc',   40,  NULL),
(14, 1,  N'HoanThanh', 100, '2025-03-12'),
(14, 8,  N'DangHoc',   20,  NULL),
(17, 2,  N'HoanThanh', 100, '2025-04-01'),
(17, 9,  N'ChuaBatDau',0,   NULL),
(18, 1,  N'DangHoc',   80,  NULL),
(21, 5,  N'DangHoc',   50,  NULL);
GO
-----------------------------------------------

-------------------CauHoi----------------------
INSERT INTO CauHoi (Ma_BaiHoc, NoiDungCauHoi, Ma_KyHieuDung, LoaiCauHoi, DiemMacDinh, GiaiThich) VALUES
(1, N'Ký hiệu nào biểu thị lời chào "Xin chào"?',           1,   N'TracNghiem',  10,  N'Đưa tay lên vẫy nhẹ trước mặt'),
(1, N'Điền vào chỗ trống: ___ là cách cảm ơn bằng ký hiệu', 2,   N'DienKhuyet',  10,  N'Đặt tay lên ngực và cúi nhẹ'),
(1, N'Nhận biết ký hiệu "Xin lỗi" trong video',             3,   N'NhanBiet',    10,  N'Xoay tay tròn trước ngực'),
(2, N'Ký hiệu nào biểu thị "Bố"?',                          4,   N'TracNghiem',  10,  N'Chạm ngón cái vào trán'),
(2, N'Ký hiệu nào biểu thị "Mẹ"?',                          5,   N'TracNghiem',  10,  N'Chạm ngón cái vào cằm'),
(2, N'Nhận biết ký hiệu "Anh" trong các ký hiệu sau',       6,   N'NhanBiet',    10,  N'Tay trái nắm, tay phải chỉ'),
(3, N'Ký hiệu nào biểu thị màu đỏ?',                        8,   N'TracNghiem',  10,  N'Chỉ vào môi hoặc vật màu đỏ'),
(3, N'Điền ký hiệu còn thiếu: Màu ___ (ký hiệu xanh lá)',   9,   N'DienKhuyet',  10,  N'Chuyển động tay từ dưới lên'),
(4, N'Ký hiệu nào là số "Một"?',                            10,  N'TracNghiem',  10,  N'Giơ một ngón trỏ lên'),
(4, N'Nhận biết ký hiệu số Mười trong video',               11,  N'NhanBiet',    10,  N'Gõ ngón cái vào tay'),
(5, N'Ký hiệu nào biểu thị "Cơm"?',                         12,  N'TracNghiem',  10,  N'Giả vờ đưa cơm vào miệng'),
(5, N'Điền ký hiệu: ___ là đồ uống cơ bản nhất',            13,  N'DienKhuyet',  10,  N'Giả vờ uống từ ly'),
(6, N'Ký hiệu nào là con "Mèo"?',                           14,  N'TracNghiem',  10,  N'Vẽ ria mèo ở má'),
(6, N'Nhận biết ký hiệu "Chó" qua hình ảnh',                15,  N'NhanBiet',    10,  N'Vỗ đùi gọi chó'),
(7, N'Ký hiệu nào biểu thị nghề "Bác sĩ"?',                 16,  N'TracNghiem',  10,  N'Đặt hai ngón vào cổ tay'),
(7, N'Điền ký hiệu nghề: ___ là người dạy học',             17,  N'DienKhuyet',  10,  N'Mở rộng hai tay từ đầu ra'),
(8, N'Ký hiệu nào là "Xe máy"?',                            18,  N'TracNghiem',  10,  N'Giả vờ cầm tay lái xe máy'),
(9, N'Ký hiệu nào biểu thị cảm xúc "Vui vẻ"?',              19,  N'TracNghiem',  10,  N'Chuyển động tay tròn trước ngực hướng lên'),
(9, N'Nhận biết ký hiệu "Buồn" qua video',                  20,  N'NhanBiet',    10,  N'Kéo tay từ mắt xuống má'),
(1, N'Chọn ký hiệu đúng cho lời tạm biệt',                  1,   N'TracNghiem',  10,  N'Vẫy tay tạm biệt');
GO 
-----------------------------------------------

------------PhuongAnTraLoi---------------------
INSERT INTO PhuongAnTraLoi (Ma_CauHoi, NoiDung, LaDapAnDung, ThuTu) VALUES
(1, N'Vẫy tay nhẹ trước mặt',            1, 1),
(1, N'Gõ đầu ngón tay vào trán',         0, 2),
(1, N'Khoanh tay trước ngực',            0, 3),
(1, N'Chỉ tay về phía trước',            0, 4),
(2, N'Cảm ơn',                           0, 2),
(2, N'Chào hỏi',                         0, 3),
(4, N'Chạm ngón cái vào trán',           1, 1),
(4, N'Chạm ngón cái vào cằm',            0, 2),
(4, N'Xoay tay vòng tròn',               0, 3),
(5, N'Chạm ngón cái vào cằm',            1, 1),
(5, N'Chạm ngón cái vào trán',           0, 2),
(5, N'Vỗ đầu nhẹ',                       0, 3),
(9, N'Giơ một ngón trỏ lên',             1, 1),
(9, N'Giơ hai ngón lên',                 0, 2),
(9, N'Nắm tay lại',                      0, 3),
(11, N'Giả vờ đưa cơm vào miệng',        1, 1),
(11, N'Xoa bụng tròn',                   0, 2),
(11, N'Giả vờ uống nước',                0, 3),
(18, N'Chuyển động tay tròn trước ngực', 1, 1),
(18, N'Giả vờ cầm tay lái xe máy',       0, 2),
(18, N'Vỗ hai tay vào nhau',             0, 3),
(18, N'Chỉ tay ra đường',                0, 4);
GO
-----------------------------------------------

----------------TienDo-------------------------
INSERT INTO TienDo (Ma_NguoiDung, Ma_CauHoi, DapAnDung, DiemSo, SoLanThu, ThoiGianLam, TrangThai) VALUES
(4,  1,  1, 10, 1, 25,  N'HoanThanh'),
(4,  2,  1, 10, 1, 30,  N'HoanThanh'),
(4,  3,  0, 0,  1, 20,  N'ChuaDat'),
(4,  3,  1, 10, 2, 35,  N'HoanThanh'),
(4,  4,  1, 10, 1, 28,  N'HoanThanh'),
(5,  1,  1, 10, 1, 22,  N'HoanThanh'),
(5,  2,  0, 0,  1, 40,  N'ChuaDat'),
(5,  9,  1, 10, 1, 18,  N'HoanThanh'),
(6,  1,  1, 10, 1, 15,  N'HoanThanh'),
(6,  4,  1, 10, 1, 27,  N'HoanThanh'),
(6,  5,  0, 0,  1, 33,  N'ChuaDat'),
(12,  1,  1, 10, 1, 20,  N'HoanThanh'),
(12,  9,  1, 10, 1, 19,  N'HoanThanh'),
(8,  4,  1, 10, 1, 24,  N'HoanThanh'),
(8,  5,  1, 10, 1, 26,  N'HoanThanh'),
(8,  11, 1, 10, 1, 21,  N'HoanThanh'),
(10, 1,  1, 10, 1, 17,  N'HoanThanh'),
(10, 2,  1, 10, 1, 23,  N'HoanThanh'),
(14, 1,  1, 10, 1, 16,  N'HoanThanh'),
(17, 4,  1, 10, 1, 29,  N'HoanThanh');
GO
-----------------------------------------------

-------------KetQuaBaiHoc----------------------
INSERT INTO KetQuaBaiHoc (Ma_NguoiDung, Ma_BaiHoc, DiemTong, PhanTramDung, NgayHoanThanh, TrangThai) VALUES
(4,  1,  30,  100, '2025-01-15', N'Dat'),
(4,  2,  28,  93,  '2025-01-20', N'Dat'),
(5,  1,  25,  83,  '2025-02-10', N'Dat'),
(6,  1,  30,  100, '2025-01-25', N'Dat'),
(8,  2,  27,  90,  '2025-03-05', N'Dat'),
(10, 1,  30,  100, '2025-02-28', N'Dat'),
(14, 1,  29,  97,  '2025-03-12', N'Dat'),
(17, 2,  26,  87,  '2025-04-01', N'Dat'),
(4,  3,  18,  60,  '2025-05-01', N'KhongDat'),
(5,  2,  22,  73,  '2025-05-05', N'Dat'),
(6,  3,  20,  67,  '2025-04-10', N'Dat'),
(9,  1,  15,  50,  '2025-04-15', N'KhongDat'),
(8,  5,  28,  93,  '2025-03-20', N'Dat'),
(10, 6,  24,  80,  '2025-04-25', N'Dat'),
(11, 7,  19,  63,  '2025-05-10', N'Dat'),
(14, 8,  21,  70,  '2025-05-08', N'Dat'),
(17, 9,  16,  53,  '2025-04-30', N'KhongDat'),
(14, 1,  27,  90,  '2025-05-12', N'Dat'),
(18, 5,  23,  77,  '2025-05-11', N'Dat'),
(18, 1,  30,  100, '2025-05-09', N'Dat');
GO
-----------------------------------------------

--------------LichSuHoc------------------------
INSERT INTO LichSuHoc (Ma_NguoiDung, Ma_BaiHoc, ThoiGianBatDau, ThoiGianKetThuc, GhiChu) VALUES
(4,  1, '2025-01-10 08:00', '2025-01-10 08:30', N'Học buổi sáng, hoàn thành phần chào hỏi'),
(4,  1, '2025-01-11 09:00', '2025-01-11 09:25', N'Ôn tập lại bài chào hỏi'),
(4,  2, '2025-01-15 14:00', '2025-01-15 14:50', N'Học bài gia đình lần đầu'),
(5,  1, '2025-02-05 07:30', '2025-02-05 08:00', N'Buổi học đầu tiên'),
(5,  3, '2025-03-01 10:00', '2025-03-01 10:35', N'Học màu sắc cơ bản'),
(6,  1, '2025-01-20 15:00', '2025-01-20 15:30', N'Học chào hỏi buổi chiều'),
(6,  2, '2025-01-22 08:00', '2025-01-22 08:45', N'Học về gia đình'),
(12,  1, '2025-02-01 09:00', '2025-02-01 09:30', N'Bắt đầu học hệ thống'),
(8,  2, '2025-02-20 20:00', '2025-02-20 20:45', N'Học buổi tối sau giờ làm'),
(8,  5, '2025-03-10 07:00', '2025-03-10 07:50', N'Học bài thức ăn buổi sáng sớm'),
(10, 1, '2025-02-15 11:00', '2025-02-15 11:30', N'Học nhanh giờ nghỉ trưa'),
(10, 6, '2025-03-05 16:00', '2025-03-05 16:55', N'Học về động vật buổi chiều'),
(11, 7, '2025-04-01 08:30', '2025-04-01 09:30', N'Học nghề nghiệp lần đầu'),
(14, 1, '2025-03-08 07:00', '2025-03-08 07:30', N'Học buổi sáng sớm'),
(14, 8, '2025-04-10 14:00', '2025-04-10 14:55', N'Học giao thông và phương tiện'),
(17, 2, '2025-03-25 09:00', '2025-03-25 09:45', N'Học gia đình lần đầu'),
(17, 9, '2025-04-20 10:00', '2025-04-20 10:45', N'Học biểu đạt cảm xúc'),
(18, 1, '2025-05-01 08:00', '2025-05-01 08:30', N'Bắt đầu học lần đầu tiên'),
(18, 5, '2025-05-03 09:30', '2025-05-03 10:20', N'Học bài thức ăn'),
(21, 1, '2025-05-05 14:00', '2025-05-05 14:30', N'Học chào hỏi cơ bản');
GO
-----------------------------------------------

--------------BaoCaoLoi------------------------
INSERT INTO BaoCaoLoi (Ma_KyHieu, Ma_NguoiDung, NoiDungLoi, TrangThai) VALUES
(1,  4,  N'Video bị giật, khó theo dõi ký hiệu',                        N'DaXuLy'),
(2,  5,  N'Âm thanh trong video bị nhiễu',                              N'DaXuLy'),
(3,  6,  N'Mô tả ký hiệu chưa đủ chi tiết',                             N'DangXuLy'),
(4,  7,  N'Video bị mờ không rõ ký hiệu bàn tay',                       N'ChuaXuLy'),
(5,  8,  N'Thiếu ảnh minh họa cho ký hiệu Mẹ',                          N'DaXuLy'),
(6,  10, N'Ký hiệu Anh và Anh họ bị nhầm lẫn',                          N'DangXuLy'),
(7,  11, N'Cần thêm ví dụ trong câu cho ký hiệu Em',                    N'ChuaXuLy'),
(8,  14, N'Màu sắc trong video không chính xác so với thực tế',         N'DaXuLy'),
(9,  15, N'Phân biệt xanh lá và xanh dương chưa rõ',                    N'DangXuLy'),
(10, 18, N'Video quá ngắn không đủ thời gian quan sát',                  N'DaXuLy'),
(11, 19, N'Ký hiệu số 10 dễ nhầm với số 6',                             N'ChuaXuLy'),
(12, 4,  N'Thiếu phụ đề giải thích trong video Cơm',                    N'DaXuLy'),
(13, 5,  N'Video Nước bị thiếu góc quay tay',                           N'DangXuLy'),
(14, 6,  N'Cần thêm góc quay khác cho ký hiệu Mèo',                     N'ChuaXuLy'),
(15, 7,  N'Tốc độ thực hiện ký hiệu Chó quá nhanh',                     N'DaXuLy'),
(16, 8,  N'Mô tả nghề bác sĩ chưa chuẩn với ký hiệu chuẩn quốc gia',    N'DangXuLy'),
(17, 10, N'Thiếu video cho ký hiệu Giáo viên',                          N'ChuaXuLy'),
(18, 11, N'Video Xe máy cần thêm góc quay từ phía bên',                 N'DaXuLy'),
(19, 14, N'Cần làm chậm video ký hiệu Vui vẻ để dễ học',                N'DangXuLy'),
(20, 15, N'Ký hiệu Buồn chưa phân biệt rõ với ký hiệu Mệt mỏi',        N'ChuaXuLy');
GO
-----------------------------------------------

