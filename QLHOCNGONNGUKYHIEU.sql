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

CREATE TABLE DanhMucBaiHoc(
	Ma_DanhMuc INT PRIMARY KEY IDENTITY(1,1),
	Ten_DanhMuc NVARCHAR(100) NOT NULL,
	MoTa NVARCHAR(300),
	TrangThai NVARCHAR(30) NOT NULL DEFAULT N'HoatDong' CHECK (TrangThai IN(N'HoatDong',N'KhongHoatDong')),
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
	Ma_DanhMuc INT NOT NULL,
	CONSTRAINT FK_BaiHoc_NguoiDung FOREIGN KEY (Ma_NguoiTao) REFERENCES NguoiDung(Ma_NguoiDung),
	CONSTRAINT FK_BaiHoc_DanhMucBaiHoc FOREIGN KEY (Ma_DanhMuc) REFERENCES DanhMucBaiHoc(Ma_DanhMuc)
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
(N'Nguyễn',		N'U',	N'U@gmail.com',	N'U123',	3,	0,	0901234581,	N'HoatDong'),
(N'Nguyễn',		N'V',	N'V@gmail.com',	N'V123',	3,	1,	0901234582,	N'HoatDong'),
(N'Nguyễn',		N'W',	N'W@gmail.com',	N'W123',	3,	0,	0901234583,	N'HoatDong'),
(N'Nguyễn',		N'X',	N'X@gmail.com',	N'X123',	3,	0,	0901234584,	N'HoatDong'),
(N'Nguyễn',		N'Y',	N'Y@gmail.com',	N'Y123',	3,	0,	0901234585,	N'HoatDong'),
(N'Nguyễn',		N'Z',	N'Z@gmail.com',	N'Z123',	3,	0,	0901234586,	N'HoatDong');
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
(N'Khí hậu',				N'Ký hiệu mô tả các khí hậu',							N'HoatDong'),
(N'Trường học',				N'Ký hiệu liên quan đến môi trường học đường',          N'HoatDong'),
(N'Sức khỏe và y tế',		N'Ký hiệu về bệnh tật và chăm sóc sức khỏe',            N'HoatDong'),
(N'Thể thao',				N'Ký hiệu về các môn thể thao phổ biến',                N'HoatDong'),
(N'Thiên nhiên',			N'Ký hiệu về cây cối, hoa lá và thiên nhiên',           N'HoatDong'),
(N'Thời gian',				N'Ký hiệu về ngày tháng năm và thời điểm',              N'HoatDong'),
(N'Nhà cửa',				N'Ký hiệu về đồ vật và không gian trong nhà',           N'HoatDong'),
(N'Công nghệ',              N'Ký hiệu về thiết bị và công nghệ hiện đại',           N'HoatDong'),
(N'Du lịch',                N'Ký hiệu về địa điểm và hoạt động du lịch',            N'HoatDong'),
(N'Mua sắm',                N'Ký hiệu về hoạt động mua bán và trao đổi',            N'HoatDong'),
(N'Cảm giác',               N'Ký hiệu về cảm giác của cơ thể',						N'HoatDong'),
(N'Nâng cao',               N'Tổng hợp ký hiệu nâng cao cho người học lâu năm',     N'KhongHoatDong');
GO
-----------------------------------------------

--------------------BaiHoc---------------------
INSERT INTO BaiHoc (TieuDe,MoTa,CapDo,Ma_NguoiTao,TrangThai,ThuTu,ThoiLuongDuKien,Ma_DanhMuc) VALUES 
(N'Chào hỏi cơ bản',			N'Học cách chào hỏi bằng ngôn ngữ ký hiệu',		'Beginner',		2,	N'DaXuatBan',	1,	30, 1),
(N'Gia đình thân yêu',			N'Ký hiệu về các thành viên trong gia đình',	'Beginner',		2,  N'DaXuatBan',	2,  45, 2 ),
(N'Màu sắc',					N'Nhận biết và ký hiệu màu sắc',				'Beginner',		3,  N'DaXuatBan',	3,  30, 3),
(N'Đếm số từ 1 đến 20',			N'Học ký hiệu số đếm',							'Beginner',		2,	N'DaXuatBan',	4,  40, 4),
(N'Đồ ăn',						N'Ký hiệu về các món ăn phổ biến',				'Beginner',		3,	N'DaXuatBan',	5,  50, 5),
(N'Các loài động vật',			N'Ký hiệu tên các loài động vật',				'Beginner',		7,	N'DaXuatBan',	6,  35, 6),
(N'Nghề nghiệp ',				N'Học ký hiệu về các nghề nghiệp',				'Intermediate', 16, N'DaXuatBan',	7,  60, 7),
(N'Giao thông và phương tiện',	N'Ký hiệu về xe cộ và đường phố',				'Intermediate', 15, N'DaXuatBan',	8,  55, 8),
(N'Biểu đạt cảm xúc',			N'Ký hiệu cảm xúc vui buồn giận hờn',			'Intermediate', 19, N'DaXuatBan',	9,  45, 9),
(N'Thời tiết',					N'Ký hiệu mô tả thời tiết',						'Beginner',		7,	N'DaXuatBan',	10, 30, 10),
(N'Khí hậu',					N'Ký hiệu mô tả khí hậu',						'Beginner',		7,	N'DaXuatBan',	11, 30, 11),
(N'Trường học ',				N'Ký hiệu về môi trường giáo dục',				'Beginner',		15, N'DaXuatBan',	12, 40, 12),
(N'Chăm sóc sức khỏe',			N'Ký hiệu y tế và chăm sóc sức khỏe',			'Intermediate', 16, N'DaXuatBan',	13, 70, 13),
(N'Các môn thể thao',			N'Ký hiệu các môn thể thao',					'Intermediate', 19, N'DaXuatBan',	14, 60, 14),
(N'Thiên nhiên',				N'Ký hiệu về cây cối thiên nhiên',				'Beginner',		3,  N'DaXuatBan',	15, 35, 15),
(N'Ngày tháng và thời gian',	N'Ký hiệu thời gian ngày tháng năm',			'Beginner',		16, N'DaXuatBan',	16, 45, 16),
(N'Trong nhà của bạn',			N'Ký hiệu đồ vật trong nhà',					'Beginner',		19, N'DaXuatBan',	17, 40, 17),
(N'Công nghệ hiện đại',			N'Ký hiệu về thiết bị công nghệ',				'Advance',		7,  N'TamAn',		18, 80, 18),
(N'Du lịch',					N'Ký hiệu phục vụ du lịch',						'Intermediate', 2,  N'NhapBai',		19, 65, 19),
(N'Mua sắm và trao đổi',		N'Ký hiệu cho hoạt động mua bán',				'Intermediate', 15, N'DaXuatBan',	20, 55, 20),
(N'Cảm giác cơ thể',			N'Ký hiệu cảm giác của con người',				'Intermediate', 16, N'DaXuatBan',	21, 55, 21),
(N'Ôn tập nâng cao',			N'Bài học tổng hợp trình độ nâng cao',			'Advance',		3,  N'NhapBai',		22, 120, 22);
GO
-----------------------------------------------

----------------KyHieu-------------------------
INSERT INTO KyHieu (TuVung, MoTa, TrangThai, ThuTuHienThi, DoKho) VALUES
(N'Xin chào',       N'Ký hiệu chào hỏi thông thường',					N'HoatDong', 1,  N'De'),
(N'Cảm ơn',         N'Ký hiệu bày tỏ lòng biết ơn',						N'HoatDong', 2,  N'De'),
(N'Xin lỗi',        N'Ký hiệu xin lỗi và xin phép',						N'HoatDong', 3,  N'De'),
(N'Bố',             N'Ký hiệu chỉ người cha trong gia đình',			N'HoatDong', 4,  N'De'),
(N'Mẹ',             N'Ký hiệu chỉ người mẹ trong gia đình',				N'HoatDong', 5,  N'De'),
(N'Anh',            N'Ký hiệu chỉ người anh trai',						N'HoatDong', 6,  N'De'),
(N'Em',             N'Ký hiệu chỉ em trai hoặc em gái nhỏ hơn',			N'HoatDong', 7,  N'De'),
(N'Màu đỏ',         N'Ký hiệu biểu thị màu đỏ',							N'HoatDong', 8,  N'De'),
(N'Màu xanh',       N'Ký hiệu biểu thị màu xanh lá và xanh dương',		N'HoatDong', 9,  N'De'),
(N'Một',            N'Ký hiệu số 1',									N'HoatDong', 10, N'De'),
(N'Mười',           N'Ký hiệu số 10',									N'HoatDong', 11, N'De'),
(N'Cơm',            N'Ký hiệu chỉ cơm – món ăn chủ yếu',				N'HoatDong', 12, N'De'),
(N'Nước',           N'Ký hiệu chỉ nước uống',							N'HoatDong', 13, N'De'),
(N'Mèo',            N'Ký hiệu con mèo',									N'HoatDong', 14, N'De'),
(N'Chó',            N'Ký hiệu con chó',									N'HoatDong', 15, N'De'),
(N'Bác sĩ',         N'Ký hiệu nghề bác sĩ',								N'HoatDong', 16, N'TrungBinh'),
(N'Giáo viên',      N'Ký hiệu nghề giáo viên',							N'HoatDong', 17, N'TrungBinh'),
(N'Xe máy',         N'Ký hiệu phương tiện xe máy',						N'HoatDong', 18, N'TrungBinh'),
(N'Vui vẻ',         N'Ký hiệu biểu lộ cảm xúc vui vẻ hạnh phúc',		N'HoatDong', 19, N'De'),
(N'Buồn',           N'Ký hiệu biểu lộ cảm xúc buồn bã',					N'HoatDong', 20, N'TrungBinh'),
(N'Nắng',           N'Ký hiệu chỉ về thời tiết nắng',					N'HoatDong', 21, N'TrungBinh'),
(N'Mưa',			N'Ký hiệu chỉ về thời tiết mưa',					N'HoatDong', 22, N'TrungBinh'),
(N'Gió',			N'Ký hiệu chỉ về khí hậu',							N'HoatDong', 23, N'De'),
(N'Lạnh',           N'Ký hiệu chỉ về khí hậu',							N'HoatDong', 24, N'De'),
(N'Nóng',           N'Ký hiệu chỉ về khí hậu',							N'HoatDong', 25, N'De'),
(N'Sách',           N'Ký hiệu chỉ về vật dụng có ở trường học',			N'HoatDong', 26, N'De'),
(N'Bút',			N'Ký hiệu chỉ về vật dụng có ở trường học',			N'HoatDong', 27, N'De'),
(N'Thầy',			N'Ký hiệu chỉ người thầy',							N'HoatDong', 28, N'TrungBinh'),
(N'Cô',				N'Ký hiệu chỉ người cô',							N'HoatDong', 29, N'TrungBinh'),
(N'Đau',			N'Ký hiệu chỉ cảm giác đau',						N'HoatDong', 30, N'De'),
(N'Thuốc',			N'Ký hiệu chỉ thuốc men',							N'HoatDong', 31, N'TrungBinh'),
(N'Bệnh viện',		N'Ký hiệu chỉ bệnh viện',							N'HoatDong', 32, N'Kho'),
(N'Bóng đá',		N'Ký hiệu chỉ môn bóng đá',							N'HoatDong', 33, N'De'),
(N'Bơi lội',		N'Ký hiệu chỉ môn bơi',								N'HoatDong', 34, N'De'),
(N'Cầu lông',		N'Ký hiệu chỉ môn cầu lông',						N'HoatDong', 35, N'TrungBinh'),
(N'Núi',			N'Ký hiệu chỉ thiên nhiên',							N'HoatDong', 36, N'De'),
(N'Rừng',			N'Ký hiệu chỉ thiên nhiên',							N'HoatDong', 37, N'TrungBinh'),
(N'Hôm nay',			N'Ký hiệu chỉ thời gian',						N'HoatDong', 38, N'De');
GO
-----------------------------------------------

------------------BaiHoc_KyHieu----------------
INSERT INTO BaiHoc_KyHieu (Ma_BaiHoc, Ma_KyHieu, ThuTu) VALUES
(1,1,1),
(1,2,2),
(1,3,3),
(2,4,1),
(2,5,2),
(2,6,3),
(2,7,4),
(3,8,1),
(3,9,2),
(4,10,1),
(4,11,2),
(5,12,1),
(5,13,2),
(6,14,1),
(6,15,2),
(7,16,1),
(7,17,2),
(8,18,1),
(9,19,1),
(9,20,2),
(10,21,1),
(10,22,2),
(11,23,1),
(11,24,2),
(11,25,3),
(12,26,1),
(12,27,2),
(12,28,3),
(12,29,4),
(13,31,1),
(13,32,2),
(14,33,1),
(14,34,2),
(14,35,3),
(15,36,1),
(15,37,2),
(16,38,1),
(21,30,1);
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
(20, 'Video', 1, '/media/video/',  'buon.mp4',        N'Video minh họa ký hiệu Buồn',       6,   1600000),
(21, 'Video', 1, '/media/video/',  'nang.mp4',		  N'Video minh họa ký hiệu Nắng',		3,   1100000),
(22, 'Video', 1, '/media/video/',  'mua.mp4',		  N'Video minh họa ký hiệu Mưa',		3,   1100000),
(23, 'Video', 1, '/media/video/',  'gio.mp4',		  N'Video minh họa ký hiệu Gió',		4,   1280000),
(24, 'Video', 1, '/media/video/',  'lanh.mp4',		  N'Video minh họa ký hiệu Lạnh',		4,   1300000),
(25, 'Video', 1, '/media/video/',  'nong.mp4',		  N'Video minh họa ký hiệu Nóng',		5,   14500000),
(26, 'Video', 1, '/media/video/',  'sach.mp4',		  N'Video minh họa ký hiệu Sách',		4,   120000),
(27, 'Video', 1, '/media/video/',  'but.mp4',		  N'Video minh họa ký hiệu Bút',		3,   100000),
(28, 'Video', 1, '/media/video/',  'thay.mp4',		  N'Video minh họa ký hiệu Thầy',		5,   1500000),
(29, 'Video', 1, '/media/video/',  'co.mp4',		  N'Video minh họa ký hiệu Cô',			5,   1600000),
(30, 'Video', 1, '/media/video/',  'dau.mp4',		  N'Video minh họa ký hiệu Đau',		3,   1000000),
(31, 'Video', 1, '/media/video/',  'thuoc.mp4',		  N'Video minh họa ký hiệu Thuốc',		5,   1380000),
(32, 'Video', 1, '/media/video/',  'benh_vien.mp4',	  N'Video minh họa ký hiệu Bệnh viện',	8,   2100000),
(33, 'Video', 1, '/media/video/',  'bong_da.mp4',	  N'Video minh họa ký hiệu Bóng đá',	4,   1200000),
(34, 'Video', 1, '/media/video/',  'boi_loi.mp4',	  N'Video minh họa ký hiệu Bơi lội',	4,   1200000),
(35, 'Video', 1, '/media/video/',  'cau_long.mp4',	  N'Video minh họa ký hiệu Cầu lông',	5,   1500000),
(36, 'Video', 1, '/media/video/',  'nui.mp4',		  N'Video minh họa ký hiệu Núi',		3,   1100000),
(37, 'Video', 1, '/media/video/',  'rung.mp4',		  N'Video minh họa ký hiệu Rừng',		5,   1400000),
(38, 'Video', 1, '/media/video/',  'hom_nay.mp4',	  N'Video minh họa ký hiệu Hôm nay',	3,   1100000);
GO
-----------------------------------------------

------------------DangKyHoc-------------------- ---1,2,3,7,9,14,15,16,19,20-- --18,19,22---
INSERT INTO DangKyHoc (Ma_NguoiDung, Ma_BaiHoc, TrangThaiHoc, PhanTramHoanThanh, NgayHoanThanh) VALUES
(4,  1,  N'HoanThanh', 100, '2025-01-15'),
(4,  2,  N'HoanThanh', 100, '2025-02-23'),
(5,  1,  N'HoanThanh', 100, '2024-12-26'),
(5,  4,  N'DangHoc', 74, NULL),
(5,  3,  N'DangHoc', 88, NULL),
(6,  9,  N'ChuaBatDau', 0, NULL),
(6,  7,  N'DangHoc', 34, NULL),
(6,  4,  N'DangHoc', 89, NULL),
(8,  1,  N'HoanThanh', 100, '2025-01-15'),
(8,  3,  N'HoanThanh', 100, '2025-03-24'),
(8,  6,  N'HoanThanh', 100, '2025-06-04'),
(17, 1,  N'HoanThanh', 100, '2025-01-15'),
(17, 5,  N'DangHoc', 57, NULL),
(17, 8,  N'DangHoc', 82, NULL),
(17, 10, N'DangHoc', 33, NULL),
(17, 2,  N'HoanThanh', 100, '2025-02-23'),
(17, 3,  N'HoanThanh', 100, '2025-03-30'),
(10, 11, N'DangHoc', 67, NULL),
(10, 1,	 N'HoanThanh', 100, '2025-01-15'),
(10, 13, N'DangHoc', 82, NULL),
(11, 12, N'DangHoc', 73, NULL),
(11, 6,	 N'DangHoc', 93, NULL),
(11, 10, N'DangHoc', 66, NULL),
(12, 1,  N'HoanThanh', 100, '2025-01-15'),
(12, 14, N'ChuaBatDau', 0, NULL),
(12, 8,  N'DangHoc', 78, NULL),
(12, 7,  N'HoanThanh', 100, '2025-03-31'),
(13, 14, N'DangHoc', 10, NULL),
(13, 9,  N'DangHoc', 92, NULL),
(18, 1,  N'HoanThanh', 100, '2025-01-15'),
(18, 15, N'DangHoc', 23, NULL),
(18, 16, N'DangHoc', 12, NULL),
(18, 11, N'HoanThanh', 100, '2025-06-13'),
(21, 1,	 N'HoanThanh', 100, '2025-01-15'),
(22, 17, N'DangHoc', 33, NULL),
(22, 12, N'DangHoc', 83, NULL),
(23, 20, N'DangHoc', 13, NULL),
(23, 1,  N'HoanThanh', 100, '2025-01-15'),
(23, 21, N'ChuaBatDau', 0, NULL),
(24, 20, N'DangHoc', 60, NULL),
(25, 1,  N'HoanThanh', 100, '2025-01-15'),
(25, 4,  N'HoanThanh', 100, '2025-04-08'),
(26, 1,  N'HoanThanh', 100, '2025-01-15'),
(26, 20, N'DangHoc', 96, NULL);
GO
-----------------------------------------------

-------------------CauHoi----------------------
INSERT INTO CauHoi (Ma_BaiHoc, NoiDungCauHoi, Ma_KyHieuDung, LoaiCauHoi, DiemMacDinh, GiaiThich) VALUES
(1, N'Ký hiệu nào biểu thị lời chào "Xin chào"?',				  1,  N'TracNghiem', 10, N'Đưa tay lên vẫy nhẹ trước mặt'),
(1, N'Điền vào chỗ trống: ___ là cách bày tỏ lòng biết ơn',		  2,  N'DienKhuyet', 10, N'Đặt tay lên ngực và cúi nhẹ'),
(1, N'Nhận biết ký hiệu "Xin lỗi" trong video',					  3,  N'NhanBiet',   10, N'Xoay tay tròn trước ngực'),
(2, N'Ký hiệu nào biểu thị "Bố"?',								  4,  N'TracNghiem', 10, N'Chạm ngón cái vào trán'),
(2, N'Ký hiệu nào biểu thị "Mẹ"?',								  5,  N'TracNghiem', 10, N'Chạm ngón cái vào cằm'),
(2, N'Nhận biết ký hiệu "Anh" trong các ký hiệu sau',			  6,  N'NhanBiet',   10, N'Tay trái nắm, tay phải chỉ'),
(2, N'Điền ký hiệu: ___ chỉ người nhỏ tuổi hơn trong nhà',		  7,  N'DienKhuyet', 10, N'Tay chỉ xuống thấp'),
(3, N'Ký hiệu nào biểu thị màu đỏ?',							  8,  N'TracNghiem', 10, N'Chỉ vào môi hoặc vật màu đỏ'),
(3, N'Điền ký hiệu còn thiếu: Màu ___ (xanh lá hoặc xanh dương)', 9, N'DienKhuyet',  10, N'Chuyển động tay từ dưới lên'),
(4, N'Ký hiệu nào là số "Một"?',								  10, N'TracNghiem', 10, N'Giơ một ngón trỏ lên'),
(4, N'Nhận biết ký hiệu số Mười trong video',					  11, N'NhanBiet',   10, N'Gõ ngón cái vào tay'),
(5, N'Ký hiệu nào biểu thị "Cơm"?',								  12, N'TracNghiem', 10, N'Giả vờ đưa cơm vào miệng'),
(5, N'Điền ký hiệu: ___ là đồ uống cơ bản nhất',				  13, N'DienKhuyet', 10, N'Giả vờ uống từ ly'),
(6, N'Ký hiệu nào là con "Mèo"?',								  14, N'TracNghiem', 10, N'Vẽ ria mèo ở má'),
(6, N'Nhận biết ký hiệu "Chó" qua hình ảnh',					  15, N'NhanBiet',   10, N'Vỗ đùi gọi chó'),
(7, N'Ký hiệu nào biểu thị nghề "Bác sĩ"?',						  16, N'TracNghiem', 10, N'Đặt hai ngón vào cổ tay'),
(7, N'Điền ký hiệu nghề: ___ là người dạy học',                   17, N'DienKhuyet', 10, N'Mở rộng hai tay từ đầu ra'),
(8, N'Ký hiệu nào là "Xe máy"?',								  18, N'TracNghiem', 10, N'Giả vờ cầm tay lái xe máy'),
(9, N'Ký hiệu nào biểu thị cảm xúc "Vui vẻ"?',					  19, N'TracNghiem', 10, N'Chuyển động tay tròn trước ngực hướng lên'),
(9, N'Nhận biết ký hiệu "Buồn" qua video',						  20, N'NhanBiet',   10, N'Kéo tay từ mắt xuống má'),
(10, N'Ký hiệu nào chỉ thời tiết "Nắng"?',						  21, N'TracNghiem', 10, N'Xòe tay như tia nắng'),
(10, N'Nhận biết ký hiệu "Mưa" qua video',						  22, N'NhanBiet',   10, N'Vẫy ngón tay từ trên xuống'),
(11, N'Ký hiệu nào biểu thị "Gió"?',							  23, N'TracNghiem', 10, N'Thổi và vẫy tay ngang'),
(11, N'Điền ký hiệu: ___ là trạng thái nhiệt độ thấp',			  24, N'DienKhuyet', 10, N'Hai tay ôm người run rẩy'),
(11, N'Nhận biết ký hiệu "Nóng" qua video',						  25, N'NhanBiet',   10, N'Quạt tay trước mặt'),
(12, N'Ký hiệu nào chỉ "Sách"?',							      26, N'TracNghiem', 10, N'Mở hai lòng bàn tay như mở sách'),
(12, N'Điền ký hiệu: ___ là vật dụng để viết',					  27, N'DienKhuyet', 10, N'Giả vờ cầm bút viết'),
(12, N'Nhận biết ký hiệu "Thầy" qua video',						  28, N'NhanBiet',   10, N'Kính cẩn đưa tay lên đầu'),
(12, N'Ký hiệu nào chỉ người "Cô"?',							  29, N'TracNghiem', 10, N'Chạm ngón vào má rồi đưa ra'),
(13, N'Ký hiệu nào biểu thị "Thuốc"?',							  31, N'TracNghiem', 10, N'Giả vờ uống thuốc'),
(13, N'Nhận biết ký hiệu "Bệnh viện" qua video',				  32, N'NhanBiet',   10, N'Vẽ chữ thập trên ngực'),
(14, N'Ký hiệu nào biểu thị "Bóng đá"?',						  33, N'TracNghiem', 10, N'Giả vờ đá bóng bằng chân'),
(14, N'Điền ký hiệu: ___ là môn vận động dưới nước',			  34, N'DienKhuyet', 10, N'Hai tay bơi trước ngực'),
(14, N'Nhận biết ký hiệu "Cầu lông" qua video',					  35, N'NhanBiet',   10, N'Giả vờ cầm vợt đánh cầu'),
(15, N'Ký hiệu nào chỉ "Núi"?',									  36, N'TracNghiem', 10, N'Hai tay tạo hình tam giác lên trên'),
(15, N'Nhận biết ký hiệu "Rừng" qua video',						  37, N'NhanBiet',   10, N'Giả vờ nhiều cây cối xung quanh'),
(16, N'Ký hiệu nào biểu thị "Hôm nay"?',						  38, N'TracNghiem', 10, N'Chỉ xuống đất biểu thị hiện tại'),
(21, N'Ký hiệu nào biểu thị cảm giác "Đau"?',					  30, N'TracNghiem', 10, N'Chỉ hai ngón trỏ vào nhau');
GO
-----------------------------------------------

------------PhuongAnTraLoi---------------------
INSERT INTO PhuongAnTraLoi (Ma_CauHoi, NoiDung, LaDapAnDung, ThuTu) VALUES
-- CauHoi 1: Xin chào (TracNghiem)
(1, N'Vẫy tay nhẹ trước mặt',        1, 1),
(1, N'Gõ đầu ngón tay vào trán',     0, 2),
(1, N'Khoanh tay trước ngực',        0, 3),
(1, N'Chỉ tay về phía trước',        0, 4),

-- CauHoi 2: Cảm ơn (DienKhuyet)
(2, N'Cảm ơn',                        1, 1),
(2, N'Xin lỗi',                       0, 2),
(2, N'Xin chào',                      0, 3),

-- CauHoi 4: Bố (TracNghiem)
(4, N'Chạm ngón cái vào trán',        1, 1),
(4, N'Chạm ngón cái vào cằm',        0, 2),
(4, N'Xoay tay vòng tròn',           0, 3),
(4, N'Vỗ đầu nhẹ',                   0, 4),

-- CauHoi 5: Mẹ (TracNghiem)
(5, N'Chạm ngón cái vào cằm',        1, 1),
(5, N'Chạm ngón cái vào trán',       0, 2),
(5, N'Vỗ đầu nhẹ',                   0, 3),

-- CauHoi 7: Em (DienKhuyet)
(7, N'Em',                            1, 1),
(7, N'Anh',                           0, 2),
(7, N'Chị',                           0, 3),

-- CauHoi 8: Màu đỏ (TracNghiem)
(8, N'Chỉ vào môi hoặc vật màu đỏ',  1, 1),
(8, N'Chuyển động tay từ dưới lên',  0, 2),
(8, N'Khoanh tay trước ngực',        0, 3),

-- CauHoi 9: Màu xanh (DienKhuyet)
(9, N'Xanh',                          1, 1),
(9, N'Vàng',                          0, 2),
(9, N'Tím',                           0, 3),

-- CauHoi 10: Số Một (TracNghiem)
(10, N'Giơ một ngón trỏ lên',         1, 1),
(10, N'Giơ hai ngón lên',             0, 2),
(10, N'Nắm tay lại',                  0, 3),

-- CauHoi 12: Cơm (TracNghiem)
(12, N'Giả vờ đưa cơm vào miệng',    1, 1),
(12, N'Xoa bụng tròn',               0, 2),
(12, N'Giả vờ uống nước',            0, 3),

-- CauHoi 13: Nước (DienKhuyet)
(13, N'Nước',                         1, 1),
(13, N'Sữa',                          0, 2),
(13, N'Trà',                          0, 3),

-- CauHoi 14: Mèo (TracNghiem)
(14, N'Vẽ ria mèo ở má',             1, 1),
(14, N'Vỗ đùi gọi chó',              0, 2),
(14, N'Giả vờ vẫy đuôi',             0, 3),

-- CauHoi 16: Bác sĩ (TracNghiem)
(16, N'Đặt hai ngón vào cổ tay',      1, 1),
(16, N'Mở rộng hai tay từ đầu ra',   0, 2),
(16, N'Chỉ vào ngực áo',             0, 3),

-- CauHoi 17: Giáo viên (DienKhuyet)
(17, N'Giáo viên',                    1, 1),
(17, N'Bác sĩ',                       0, 2),
(17, N'Kỹ sư',                        0, 3),

-- CauHoi 18: Xe máy (TracNghiem)
(18, N'Giả vờ cầm tay lái xe máy',   1, 1),
(18, N'Vỗ hai tay vào nhau',         0, 2),
(18, N'Chỉ tay ra đường',            0, 3),
(18, N'Giả vờ đạp xe đạp',          0, 4),

-- CauHoi 19: Vui vẻ (TracNghiem)
(19, N'Chuyển động tay tròn trước ngực hướng lên', 1, 1),
(19, N'Kéo tay từ mắt xuống má',     0, 2),
(19, N'Nắm tay đấm vào lòng bàn tay',0, 3),

-- CauHoi 21: Nắng (TracNghiem)
(21, N'Xòe tay như tia nắng',         1, 1),
(21, N'Vẫy ngón tay từ trên xuống',  0, 2),
(21, N'Thổi và vẫy tay ngang',       0, 3),

-- CauHoi 23: Gió (TracNghiem)
(23, N'Thổi và vẫy tay ngang',        1, 1),
(23, N'Hai tay ôm người run rẩy',    0, 2),
(23, N'Quạt tay trước mặt',          0, 3),

-- CauHoi 24: Lạnh (DienKhuyet)
(24, N'Lạnh',                         1, 1),
(24, N'Nóng',                         0, 2),
(24, N'Mát',                          0, 3),

-- CauHoi 26: Sách (TracNghiem)
(26, N'Mở hai lòng bàn tay như mở sách', 1, 1),
(26, N'Giả vờ cầm bút viết',         0, 2),
(26, N'Kính cẩn đưa tay lên đầu',    0, 3),

-- CauHoi 27: Bút (DienKhuyet)
(27, N'Bút',                          1, 1),
(27, N'Sách',                         0, 2),
(27, N'Thước',                        0, 3),

-- CauHoi 29: Cô (TracNghiem)
(29, N'Chạm ngón vào má rồi đưa ra', 1, 1),
(29, N'Kính cẩn đưa tay lên đầu',    0, 2),
(29, N'Mở hai lòng bàn tay',         0, 3),

-- CauHoi 30: Thuốc (TracNghiem)
(30, N'Giả vờ uống thuốc',            1, 1),
(30, N'Vẽ chữ thập trên ngực',       0, 2),
(30, N'Chỉ hai ngón trỏ vào nhau',   0, 3),

-- CauHoi 32: Bóng đá (TracNghiem)
(32, N'Giả vờ đá bóng bằng chân',    1, 1),
(32, N'Hai tay bơi trước ngực',      0, 2),
(32, N'Giả vờ cầm vợt đánh cầu',    0, 3),

-- CauHoi 33: Bơi lội (DienKhuyet)
(33, N'Bơi lội',                      1, 1),
(33, N'Bóng đá',                      0, 2),
(33, N'Chạy bộ',                      0, 3),

-- CauHoi 35: Núi (TracNghiem)
(35, N'Hai tay tạo hình tam giác lên trên', 1, 1),
(35, N'Giả vờ nhiều cây cối xung quanh', 0, 2),
(35, N'Chỉ tay xuống đất',           0, 3),

-- CauHoi 37: Hôm nay (TracNghiem)
(37, N'Chỉ xuống đất biểu thị hiện tại', 1, 1),
(37, N'Chỉ ra phía sau',             0, 2),
(37, N'Chỉ ra phía trước',           0, 3),

-- CauHoi 38: Đau (TracNghiem)
(38, N'Chỉ hai ngón trỏ vào nhau',   1, 1),
(38, N'Xoa bụng tròn',               0, 2),
(38, N'Vỗ nhẹ vào đầu',             0, 3);
GO
-----------------------------------------------

----------------TienDo-------------------------
INSERT INTO TienDo (Ma_NguoiDung, Ma_CauHoi, DapAnDung, DiemSo, SoLanThu, ThoiGianLam, TrangThai) VALUES
(4,  1,  1, 10, 1, 25,  N'HoanThanh'),
(4,  2,  1, 10, 1, 30,  N'HoanThanh'),
(4,  3,  0,  0, 1, 35,  N'ChuaDat'),
(4,  3,  1, 10, 2, 35,  N'HoanThanh'),
(4,  4,  1, 10, 1, 28,  N'HoanThanh'),
(4,  5,  1, 10, 1, 22,  N'HoanThanh'),
(4,  6,  0,  0, 1, 38,  N'ChuaDat'),
(4,  6,  1, 10, 2, 38,  N'HoanThanh'),
(4,  7,  1, 10, 1, 18,  N'HoanThanh'),
(5,  1,  1, 10, 1, 22,  N'HoanThanh'),
(5,  2,  0,  0, 1, 40,  N'ChuaDat'),
(5,  2,  1, 10, 2, 32,  N'HoanThanh'),
(5,  3,  1, 10, 1, 27,  N'HoanThanh'),
(5,  8,  1, 10, 1, 24,  N'HoanThanh'),
(5,  9,  0,  0, 1, 20,  N'ChuaDat'),
(5,  10, 1, 10, 1, 18,  N'HoanThanh'),
(6,  19, 1, 10, 1, 15,  N'HoanThanh'),
(6,  20, 0,  0, 1, 33,  N'ChuaDat'),
(6,  16, 1, 10, 1, 27,  N'HoanThanh'),
(6,  10, 1, 10, 1, 21,  N'HoanThanh'),
(6,  11, 0,  0, 1, 35,  N'ChuaDat'),
(8,  1,  1, 10, 1, 20,  N'HoanThanh'),
(8,  2,  1, 10, 1, 18,  N'HoanThanh'),
(8,  3,  1, 10, 1, 22,  N'HoanThanh'),
(8,  8,  1, 10, 1, 19,  N'HoanThanh'),
(8,  9,  1, 10, 1, 25,  N'HoanThanh'),
(8,  14, 1, 10, 1, 23,  N'HoanThanh'),
(8,  15, 1, 10, 1, 26,  N'HoanThanh'),
(10, 1,  1, 10, 1, 17,  N'HoanThanh'),
(10, 2,  1, 10, 1, 23,  N'HoanThanh'),
(10, 3,  1, 10, 1, 19,  N'HoanThanh'),
(10, 23, 1, 10, 1, 21,  N'HoanThanh'),
(10, 24, 0,  0, 1, 40,  N'ChuaDat'),
(10, 30, 1, 10, 1, 28,  N'HoanThanh'),
(10, 31, 0,  0, 1, 35,  N'ChuaDat'),
(11, 26, 1, 10, 1, 20,  N'HoanThanh'),
(11, 27, 0,  0, 1, 30,  N'ChuaDat'),
(11, 28, 1, 10, 1, 22,  N'HoanThanh'),
(11, 14, 1, 10, 1, 18,  N'HoanThanh'),
(11, 21, 1, 10, 1, 24,  N'HoanThanh'),
(11, 22, 0,  0, 1, 38,  N'ChuaDat'),
(12, 1,  1, 10, 1, 20,  N'HoanThanh'),
(12, 2,  1, 10, 1, 18,  N'HoanThanh'),
(12, 3,  1, 10, 1, 15,  N'HoanThanh'),
(12, 16, 1, 10, 1, 29,  N'HoanThanh'),
(12, 17, 1, 10, 1, 25,  N'HoanThanh'),
(12, 18, 0,  0, 1, 40,  N'ChuaDat'),
(12, 18, 1, 10, 2, 35,  N'HoanThanh'),
(17, 1,  1, 10, 1, 16,  N'HoanThanh'),
(17, 2,  1, 10, 1, 20,  N'HoanThanh'),
(17, 3,  1, 10, 1, 18,  N'HoanThanh'),
(17, 4,  1, 10, 1, 29,  N'HoanThanh'),
(17, 5,  1, 10, 1, 22,  N'HoanThanh'),
(17, 8,  1, 10, 1, 19,  N'HoanThanh'),
(17, 12, 1, 10, 1, 25,  N'HoanThanh'),
(17, 19, 1, 10, 1, 21,  N'HoanThanh'),
(17, 20, 0,  0, 1, 38,  N'ChuaDat'),
(18, 1,  1, 10, 1, 15,  N'HoanThanh'),
(18, 2,  1, 10, 1, 20,  N'HoanThanh'),
(18, 3,  1, 10, 1, 22,  N'HoanThanh'),
(18, 23, 1, 10, 1, 18,  N'HoanThanh'),
(18, 24, 1, 10, 1, 25,  N'HoanThanh'),
(18, 25, 0,  0, 1, 35,  N'ChuaDat'),
(18, 35, 1, 10, 1, 28,  N'HoanThanh'),
(18, 37, 0,  0, 1, 40,  N'ChuaDat'),
(21, 1,  1, 10, 1, 14,  N'HoanThanh'),
(21, 2,  1, 10, 1, 19,  N'HoanThanh'),
(21, 3,  0,  0, 1, 30,  N'ChuaDat'),
(22, 26, 0,  0, 1, 35,  N'ChuaDat'),
(22, 26, 1, 10, 2, 28,  N'HoanThanh'),
(22, 27, 1, 10, 1, 22,  N'HoanThanh'),
(23, 1,  1, 10, 1, 20,  N'HoanThanh'),
(23, 2,  1, 10, 1, 17,  N'HoanThanh'),
(23, 3,  1, 10, 1, 22,  N'HoanThanh'),
(25, 1,  1, 10, 1, 18,  N'HoanThanh'),
(25, 2,  1, 10, 1, 22,  N'HoanThanh'),
(25, 3,  1, 10, 1, 20,  N'HoanThanh'),
(25, 10, 1, 10, 1, 15,  N'HoanThanh'),
(25, 11, 1, 10, 1, 28,  N'HoanThanh'),
(26, 1,  1, 10, 1, 19,  N'HoanThanh'),
(26, 2,  1, 10, 1, 24,  N'HoanThanh'),
(26, 3,  0,  0, 1, 28,  N'ChuaDat');
GO
-----------------------------------------------

-------------KetQuaBaiHoc----------------------
INSERT INTO KetQuaBaiHoc (Ma_NguoiDung, Ma_BaiHoc, DiemTong, PhanTramDung, NgayHoanThanh, TrangThai) VALUES
(4,  1,  30, 100, '2025-01-15', N'Dat'),
(4,  2,  28,  93, '2025-02-23', N'Dat'),
(5,  1,  25,  83, '2024-12-26', N'Dat'),
(8,  1,  30, 100, '2025-01-15', N'Dat'),
(8,  3,  27,  90, '2025-03-24', N'Dat'),
(8,  6,  20,  67, '2025-06-04', N'Dat'),
(10, 1,  30, 100, '2025-01-15', N'Dat'),
(12, 1,  30, 100, '2025-01-15', N'Dat'),
(12, 7,  28,  93, '2025-03-31', N'Dat'),
(17, 1,  30, 100, '2025-01-15', N'Dat'),
(17, 2,  26,  87, '2025-02-23', N'Dat'),
(17, 3,  28,  93, '2025-03-30', N'Dat'),
(18, 1,  30, 100, '2025-05-09', N'Dat'),
(18, 11, 22,  73, '2025-06-13', N'Dat'),
(21, 1,  20,  67, '2025-01-15', N'Dat'),
(23, 1,  30, 100, '2025-01-15', N'Dat'),
(25, 1,  30, 100, '2025-01-15', N'Dat'),
(25, 4,  20,  67, '2025-04-08', N'Dat'),
(26, 1,  30, 100, '2025-01-15', N'Dat');
GO
-----------------------------------------------

--------------LichSuHoc------------------------
INSERT INTO LichSuHoc (Ma_NguoiDung, Ma_BaiHoc, ThoiGianBatDau, ThoiGianKetThuc, GhiChu) VALUES
(4,  1, '2025-01-10 08:00', '2025-01-10 08:30', N'Học buổi sáng, hoàn thành phần chào hỏi'),
(4,  1, '2025-01-11 09:00', '2025-01-11 09:25', N'Ôn tập lại bài chào hỏi'),
(4,  2, '2025-01-15 14:00', '2025-01-15 14:50', N'Học bài gia đình lần đầu'),
(5,  1, '2024-12-20 07:30', '2024-12-20 08:00', N'Buổi học đầu tiên'),
(5,  3, '2025-03-01 10:00', '2025-03-01 10:35', N'Học màu sắc cơ bản'),
(5,  4, '2025-03-10 14:00', '2025-03-10 14:40', N'Bắt đầu học số đếm'),
(6,  7, '2025-02-05 15:00', '2025-02-05 15:34', N'Học nghề nghiệp buổi chiều'),
(6,  4, '2025-02-10 08:00', '2025-02-10 08:45', N'Học số đếm buổi sáng'),
(8,  1, '2025-01-12 09:00', '2025-01-12 09:30', N'Học chào hỏi lần đầu'),
(8,  3, '2025-03-18 20:00', '2025-03-18 20:45', N'Học màu sắc buổi tối'),
(8,  6, '2025-05-25 07:00', '2025-05-25 07:50', N'Học bài động vật buổi sáng'),
(10, 1, '2025-01-10 11:00', '2025-01-10 11:30', N'Học nhanh giờ nghỉ trưa'),
(10, 11,'2025-04-05 16:00', '2025-04-05 16:55', N'Học về khí hậu buổi chiều'),
(10, 13,'2025-04-20 09:00', '2025-04-20 09:55', N'Học sức khỏe buổi sáng'),
(11, 12,'2025-04-01 08:30', '2025-04-01 09:10', N'Học trường học lần đầu'),
(11, 6, '2025-04-08 14:00', '2025-04-08 14:35', N'Học các loài động vật'),
(11, 10,'2025-04-15 10:00', '2025-04-15 10:40', N'Học thời tiết buổi sáng'),
(12, 1, '2025-01-08 09:00', '2025-01-08 09:30', N'Bắt đầu học hệ thống'),
(12, 7, '2025-03-20 14:00', '2025-03-20 15:00', N'Học nghề nghiệp lần đầu'),
(12, 8, '2025-04-05 10:00', '2025-04-05 10:55', N'Học giao thông'),
(17, 1, '2025-01-10 08:00', '2025-01-10 08:30', N'Học chào hỏi buổi sáng'),
(17, 2, '2025-02-15 09:00', '2025-02-15 09:45', N'Học gia đình lần đầu'),
(17, 3, '2025-03-05 10:00', '2025-03-05 10:40', N'Học màu sắc'),
(17, 5, '2025-04-01 07:30', '2025-04-01 08:20', N'Học đồ ăn buổi sáng sớm'),
(17, 8, '2025-04-15 14:00', '2025-04-15 14:55', N'Học giao thông'),
(17, 10,'2025-05-01 09:00', '2025-05-01 09:30', N'Học thời tiết'),
(18, 1, '2025-05-01 08:00', '2025-05-01 08:30', N'Bắt đầu học lần đầu tiên'),
(18, 11,'2025-05-10 09:30', '2025-05-10 10:10', N'Học bài khí hậu'),
(18, 15,'2025-05-15 14:00', '2025-05-15 14:35', N'Học thiên nhiên'),
(18, 16,'2025-05-20 10:00', '2025-05-20 10:45', N'Học thời gian'),
(21, 1, '2025-05-05 14:00', '2025-05-05 14:30', N'Học chào hỏi cơ bản'),
(22, 17,'2025-04-10 08:00', '2025-04-10 08:40', N'Học đồ vật trong nhà'),
(22, 12,'2025-04-18 15:00', '2025-04-18 15:50', N'Học bài trường học'),
(23, 1, '2025-01-12 09:00', '2025-01-12 09:30', N'Học chào hỏi buổi sáng'),
(23, 20,'2025-04-20 14:00', '2025-04-20 14:55', N'Học bài mua sắm'),
(24, 20,'2025-05-01 10:00', '2025-05-01 10:55', N'Học mua sắm lần đầu'),
(25, 1, '2025-01-08 08:00', '2025-01-08 08:30', N'Học chào hỏi buổi sáng'),
(25, 4, '2025-03-20 09:00', '2025-03-20 09:45', N'Học số đếm'),
(26, 1, '2025-01-09 08:00', '2025-01-09 08:30', N'Học chào hỏi buổi sáng'),
(26, 20,'2025-04-25 14:00', '2025-04-25 14:55', N'Học mua sắm buổi chiều');
GO
-----------------------------------------------

--------------BaoCaoLoi------------------------
INSERT INTO BaoCaoLoi (Ma_KyHieu, Ma_NguoiDung, NoiDungLoi, TrangThai) VALUES
(1,  4,  N'Video bị giật, khó theo dõi ký hiệu',                      N'DaXuLy'),
(2,  5,  N'Âm thanh trong video bị nhiễu',                            N'DaXuLy'),
(3,  6,  N'Mô tả ký hiệu chưa đủ chi tiết',                           N'DangXuLy'),
(4,  8,  N'Video bị mờ không rõ ký hiệu bàn tay',                     N'ChuaXuLy'),
(5,  10, N'Thiếu ảnh minh họa cho ký hiệu Mẹ',                        N'DaXuLy'),
(6,  11, N'Ký hiệu Anh và Anh họ dễ bị nhầm lẫn',                     N'DangXuLy'),
(7,  12, N'Cần thêm ví dụ trong câu cho ký hiệu Em',                  N'ChuaXuLy'),
(8,  17, N'Màu sắc trong video không chính xác so với thực tế',       N'DaXuLy'),
(9,  18, N'Phân biệt xanh lá và xanh dương chưa rõ',                  N'DangXuLy'),
(10, 21, N'Video quá ngắn không đủ thời gian quan sát',               N'DaXuLy'),
(11, 22, N'Ký hiệu số 10 dễ nhầm với số 6',                           N'ChuaXuLy'),
(12, 4,  N'Thiếu phụ đề giải thích trong video Cơm',                  N'DaXuLy'),
(13, 5,  N'Video Nước bị thiếu góc quay tay',                         N'DangXuLy'),
(14, 6,  N'Cần thêm góc quay khác cho ký hiệu Mèo',                   N'ChuaXuLy'),
(15, 8,  N'Tốc độ thực hiện ký hiệu Chó quá nhanh',                   N'DaXuLy'),
(16, 10, N'Mô tả nghề bác sĩ chưa chuẩn với ký hiệu chuẩn quốc gia', N'DangXuLy'),
(17, 11, N'Thiếu video cho ký hiệu Giáo viên',                        N'ChuaXuLy'),
(18, 12, N'Video Xe máy cần thêm góc quay từ phía bên',               N'DaXuLy'),
(19, 17, N'Cần làm chậm video ký hiệu Vui vẻ để dễ học',              N'DangXuLy'),
(20, 18, N'Ký hiệu Buồn chưa phân biệt rõ với ký hiệu Mệt mỏi',      N'ChuaXuLy'),
(21, 21, N'Video Nắng bị lóa sáng khó quan sát bàn tay',              N'DaXuLy'),
(23, 22, N'Ký hiệu Gió chưa có ảnh minh họa kèm theo',               N'DangXuLy'),
(26, 23, N'Chuyển động trong video Sách hơi nhanh',                   N'ChuaXuLy'),
(30, 24, N'Ký hiệu Đau dễ nhầm với ký hiệu Mệt',                     N'DaXuLy'),
(33, 25, N'Video Bóng đá thiếu góc quay toàn thân',                   N'DangXuLy'),
(36, 26, N'Ký hiệu Núi cần thêm ví dụ câu sử dụng',                  N'ChuaXuLy');
GO
-----------------------------------------------


------------------------------------------------------------- 40 CÂU TRUY VẤN ------------------------------------------------------------------------------------------------------
-------------------- Truy vấn đơn giản: 5 câu --------------------

--1 Lấy danh sách tất cả người dùng và vai trò của họ-- 
SELECT nd.Ho + ' ' + nd.Ten AS HoTen, nd.Email, vt.Ten_VaiTro, nd.TrangThai
FROM NguoiDung nd
JOIN VaiTro vt ON nd.Ma_VaiTro = vt.Ma_VaiTro
ORDER BY vt.Ma_VaiTro;

--2. Đếm số học viên đăng ký mỗi bài học
SELECT bh.TieuDe, COUNT(dk.Ma_NguoiDung) AS SoHocVien
FROM BaiHoc bh
LEFT JOIN DangKyHoc dk ON bh.Ma_BaiHoc = dk.Ma_BaiHoc
GROUP BY bh.Ma_BaiHoc, bh.TieuDe
ORDER BY SoHocVien DESC;

--3. Lấy các báo cáo lỗi chưa xử lý kèm tên ký hiệu và người báo cáo
SELECT bcl.Ma_BaoCao, kh.TuVung AS TenKyHieu,
       nd.Ho + ' ' + nd.Ten AS NguoiBaoCao,
       bcl.NoiDungLoi, bcl.NgayBaoCao, bcl.TrangThai
FROM BaoCaoLoi bcl
JOIN KyHieu kh ON bcl.Ma_KyHieu = kh.Ma_KyHieu
JOIN NguoiDung nd ON bcl.Ma_NguoiDung = nd.Ma_NguoiDung
WHERE bcl.TrangThai = N'ChuaXuLy'
ORDER BY bcl.NgayBaoCao;

--4. Thống kê kết quả học tập theo từng học viên (điểm trung bình, số bài đạt/không đạt)
SELECT nd.Ho + ' ' + nd.Ten AS HoTen,
       COUNT(kq.Ma_KetQua)  AS TongBaiLam,
       AVG(kq.PhanTramDung) AS DiemTrungBinh,
       SUM(CASE WHEN kq.TrangThai = N'Dat' THEN 1 ELSE 0 END) AS SoBaiDat,
       SUM(CASE WHEN kq.TrangThai = N'KhongDat' THEN 1 ELSE 0 END) AS SoBaiKhongDat
FROM KetQuaBaiHoc kq
JOIN NguoiDung nd ON kq.Ma_NguoiDung = nd.Ma_NguoiDung
GROUP BY kq.Ma_NguoiDung, nd.Ho, nd.Ten
ORDER BY DiemTrungBinh DESC;

--5. Tìm các bài học có ký hiệu khó (DoKho = 'Kho')
SELECT DISTINCT bh.TieuDe, bh.CapDo, kh.TuVung AS KyHieuKho, kh.DoKho
FROM BaiHoc bh
JOIN BaiHoc_KyHieu bhkh ON bh.Ma_BaiHoc = bhkh.Ma_BaiHoc
JOIN KyHieu kh ON bhkh.Ma_KyHieu = kh.Ma_KyHieu
WHERE kh.DoKho = N'Kho'
ORDER BY bh.TieuDe;
------------------------------------------------------------------

----------- Truy vấn với Aggregate Functions: 7 câu --------------

--Câu 1: Đếm tổng số bài học hiện có theo từng cấp độ (Sử dụng COUNT) 
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
------------------------------------------------------------------

-------------- Truy vấn với mệnh đề having: 5 câu ----------------

--1. Tìm bài học có hơn 3 học viên đăng ký
SELECT bh.TieuDe, COUNT(dk.Ma_NguoiDung) AS SoHocVien
FROM BaiHoc bh
JOIN DangKyHoc dk ON bh.Ma_BaiHoc = dk.Ma_BaiHoc
GROUP BY bh.Ma_BaiHoc, bh.TieuDe
HAVING COUNT(dk.Ma_NguoiDung) > 3
ORDER BY SoHocVien DESC;

--2. Tìm học viên có điểm trung bình các bài thi >= 80%
SELECT nd.Ho + ' ' + nd.Ten AS HoTen,
       COUNT(kq.Ma_KetQua) AS SoBaiLam,
       AVG(kq.PhanTramDung) AS DiemTrungBinh
FROM KetQuaBaiHoc kq
JOIN NguoiDung nd ON kq.Ma_NguoiDung = nd.Ma_NguoiDung
GROUP BY kq.Ma_NguoiDung, nd.Ho, nd.Ten
HAVING AVG(kq.PhanTramDung) >= 80
ORDER BY DiemTrungBinh DESC;

--3. Tìm ký hiệu bị báo cáo lỗi từ 2 lần trở lên
SELECT kh.TuVung AS TenKyHieu,
       COUNT(bcl.Ma_BaoCao) AS SoLanBaoCao
FROM BaoCaoLoi bcl
JOIN KyHieu kh ON bcl.Ma_KyHieu = kh.Ma_KyHieu
GROUP BY bcl.Ma_KyHieu, kh.TuVung
HAVING COUNT(bcl.Ma_BaoCao) >= 2
ORDER BY SoLanBaoCao DESC;

--4. Tìm danh mục bài học có tổng thời lượng dự kiến hơn 50 phút
SELECT dm.Ten_DanhMuc,
       COUNT(bh.Ma_BaiHoc) AS SoBaiHoc,
       SUM(bh.ThoiLuongDuKien) AS TongThoiLuong
FROM DanhMucBaiHoc dm
JOIN BaiHoc bh ON dm.Ma_DanhMuc = bh.Ma_DanhMuc
GROUP BY dm.Ma_DanhMuc, dm.Ten_DanhMuc
HAVING SUM(bh.ThoiLuongDuKien) > 50
ORDER BY TongThoiLuong DESC;

--5. Tìm học viên có ít nhất 2 lần trả lời sai (DapAnDung = 0)
SELECT nd.Ho + ' ' + nd.Ten AS HoTen,
       COUNT(td.Ma_TienDo) AS SoLanSai
FROM TienDo td
JOIN NguoiDung nd ON td.Ma_NguoiDung = nd.Ma_NguoiDung
WHERE td.DapAnDung = 0
GROUP BY td.Ma_NguoiDung, nd.Ho, nd.Ten
HAVING COUNT(td.Ma_TienDo) >= 2
ORDER BY SoLanSai DESC;

------------------------------------------------------------------

-------------- Truy vấn lớn nhất, nhỏ nhất: 4 câu ----------------

--1. Tìm Ký hiệu có độ dài từ vựng (số ký tự) lớn nhất
--Mục tiêu: Tìm từ vựng dài nhất trong hệ thống (Ví dụ: "Trường Đại học Nha Trang"). Việc này giúp bạn kiểm tra xem giao diện hiển thị trên App có bị tràn chữ hay không..
SELECT TOP 1 TuVung, LEN(TuVung) AS SoKyTu
FROM KyHieu
ORDER BY LEN(TuVung) DESC;

--2. Tìm ký hiệu có thứ tự hiển thị nhỏ nhất trong một bài học (Sử dụng MIN)
--Mục tiêu: Xác định ký hiệu đầu tiên (khởi đầu) của một bài học cụ thể (ví dụ bài số 5)
SELECT MIN(ThuTuHienThi) AS KyHieuDauTien
FROM KyHieu
WHERE Ma_KyHieu IN (SELECT Ma_KyHieu FROM BaiHoc_KyHieu WHERE Ma_BaiHoc = 5);

--3. Tìm bài học mới nhất vừa được thêm vào hệ thống (Sử dụng MAX trên ID hoặc Ngày)
--Mục tiêu: Hiển thị bài học mới lên trang chủ của ứng dụng
SELECT * FROM BaiHoc 
WHERE Ma_BaiHoc = (SELECT MAX(Ma_BaiHoc) FROM BaiHoc);

--4.Tìm Danh mục có tên dài nhất
--Mục tiêu: Tìm danh mục có tiêu đề chiếm nhiều không gian nhất trên thanh menu
SELECT TOP 1 Ten_DanhMuc, LEN(Ten_DanhMuc) AS DoDaiTen
FROM DanhMucBaiHoc
ORDER BY DoDaiTen DESC;

------------------------------------------------------------------

--- Truy vấn Không/chưa có: (Not In và left/right join): 5 câu ---

--1. Tìm học viên chưa đăng ký bất kỳ bài học nào (LEFT JOIN)
SELECT nd.Ho + ' ' + nd.Ten AS HoTen, 
       nd.Email, 
       nd.TrangThai
FROM NguoiDung nd
LEFT JOIN DangKyHoc dk ON nd.Ma_NguoiDung = dk.Ma_NguoiDung
WHERE dk.Ma_DangKy IS NULL
  AND nd.Ma_VaiTro = 3  -- chỉ lấy Học Viên
ORDER BY nd.Ho;

--2. Tìm bài học chưa có câu hỏi nào (NOT IN)
SELECT bh.Ma_BaiHoc, 
       bh.TieuDe, 
       bh.CapDo, 
       bh.TrangThai
FROM BaiHoc bh
WHERE bh.Ma_BaiHoc NOT IN (
    SELECT DISTINCT Ma_BaiHoc 
    FROM CauHoi
)
ORDER BY bh.Ma_BaiHoc;

--3. Tìm ký hiệu chưa được thêm vào bài học nào (RIGHT JOIN)
SELECT kh.Ma_KyHieu, 
       kh.TuVung, 
       kh.DoKho, 
       kh.TrangThai
FROM BaiHoc_KyHieu bhkh
RIGHT JOIN KyHieu kh ON bhkh.Ma_KyHieu = kh.Ma_KyHieu
WHERE bhkh.Ma_BaiHoc IS NULL
ORDER BY kh.ThuTuHienThi;

--4. Tìm học viên chưa có kết quả thi ở bài học mà họ đã đăng ký (LEFT JOIN)
SELECT nd.Ho + ' ' + nd.Ten AS HoTen,
       bh.TieuDe AS BaiHocDaDangKy,
       dk.TrangThaiHoc
FROM DangKyHoc dk
JOIN NguoiDung nd ON dk.Ma_NguoiDung = nd.Ma_NguoiDung
JOIN BaiHoc bh ON dk.Ma_BaiHoc = bh.Ma_BaiHoc
LEFT JOIN KetQuaBaiHoc kq 
       ON dk.Ma_NguoiDung = kq.Ma_NguoiDung 
      AND dk.Ma_BaiHoc = kq.Ma_BaiHoc
WHERE kq.Ma_KetQua IS NULL
ORDER BY nd.Ho;

--5. Tìm câu hỏi chưa có học viên nào làm (NOT IN)
SELECT ch.Ma_CauHoi,
       ch.NoiDungCauHoi,
       ch.LoaiCauHoi,
       bh.TieuDe AS ThuocBaiHoc
FROM CauHoi ch
JOIN BaiHoc bh ON ch.Ma_BaiHoc = bh.Ma_BaiHoc
WHERE ch.Ma_CauHoi NOT IN (
    SELECT DISTINCT Ma_CauHoi 
    FROM TienDo
)
ORDER BY ch.Ma_CauHoi;

------------------------------------------------------------------

----------------- Truy vấn Hợp/Giao/Trừ: 3 câu -------------------

--1. Phép Hợp (UNION) - Lấy danh sách tất cả các tiêu đề
--Mục tiêu: Tạo ra một danh sách tổng hợp bao gồm cả tên của các "Danh mục" và tên của các "Bài học" để làm dữ liệu cho thanh tìm kiếm (Search bar) trong ứng dụng
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

--3. Phép Trừ (EXCEPT) - Tìm các bài học "Advance" nhưng chưa được xuất bản
--Mục tiêu: Kiểm tra xem bạn có bài học nâng cao nào vẫn đang ở trạng thái NhapBai hay TamAn mà quên chưa đưa lên hệ thống không.
-- Lấy tất cả bài học có cấp độ Advance
SELECT TieuDe FROM BaiHoc WHERE CapDo = 'Advance'

EXCEPT

-- Lấy các bài học đã được xuất bản (DaXuatBan)
SELECT TieuDe FROM BaiHoc WHERE TrangThai = N'DaXuatBan';

------------------------------------------------------------------

-------------- Truy vấn Update, Delete:  7 câu -------------------
BEGIN TRANSACTION;

Select Ma_NguoiDung, TrangThai
From NguoiDung;

--1. Cập nhật trạng thái tài khoản người dùng đang chờ xác nhận sang hoạt động.
UPDATE NguoiDung
SET    TrangThai    = N'HoatDong',
       NgayCapNhat  = GETDATE()
WHERE  TrangThai = N'ChoXacNhan';

Select Ma_NguoiDung, TrangThai
From NguoiDung;

ROLLBACK TRANSACTION;
--2. Đổi trạng thái bài học cấp độ Advance chưa xuất bản sang TamAn.
UPDATE BaiHoc
SET    TrangThai = N'TamAn'
WHERE  CapDo     = 'Advance'
  AND  TrangThai = N'NhapBai';

--3. Cập nhật trạng thái báo cáo lỗi đã xử lý xong.
UPDATE BaoCaoLoi
SET    TrangThai = N'DaXuLy'
WHERE  TrangThai = N'DangXuLy'
  AND  Ma_KyHieu BETWEEN 1 AND 10;

--4. Xóa các phương án trả lời sai thuộc câu hỏi điền khuyết.
DELETE PhuongAnTraLoi
WHERE  LaDapAnDung = 0
  AND  Ma_CauHoi IN (
       SELECT Ma_CauHoi FROM CauHoi
       WHERE  LoaiCauHoi = N'DienKhuyet'
  );

--5. Xóa đăng ký học chưa bắt đầu của bài học đang bị ẩn.
DELETE DangKyHoc
WHERE  TrangThaiHoc = N'ChuaBatDau'
  AND  Ma_BaiHoc IN (
       SELECT Ma_BaiHoc FROM BaiHoc
       WHERE  TrangThai = N'TamAn'
  );

--6. Xóa đa phương tiện ảnh trùng (không phải file chính) của cùng một ký hiệu.
DELETE DaPhuongTien
WHERE  LoaiTep  = 'Anh'
  AND  LaChinh = 0;

--7. Cập nhật thứ tự hiển thị ký hiệu theo độ khó tăng dần.
BEGIN TRANSACTION;

select Ma_KyHieu,ThuTuHienThi,DoKho,TrangThai
from KyHieu;

UPDATE KyHieu
SET    ThuTuHienThi = CASE DoKho
         WHEN N'De'       THEN 1
         WHEN N'TrungBinh' THEN 2
         WHEN N'Kho'      THEN 3
       END
WHERE  TrangThai = N'HoatDong';

select Ma_KyHieu,ThuTuHienThi,DoKho,TrangThai
from KyHieu;

ROLLBACK TRANSACTION;
------------------------------------------------------------------

------------- Truy vấn sử dụng phép Chia: 4 câu ------------------

--1. Học viên đã hoàn thành TẤT CẢ bài học thuộc danh mục "Chào hỏi cơ bản".
SELECT nd.Ma_NguoiDung, nd.Ho + N' ' + nd.Ten AS HoTen
FROM   NguoiDung nd
WHERE NOT EXISTS (
    -- Tìm bài học trong danh mục mà học viên CHƯA hoàn thành
    SELECT 1 FROM BaiHoc bh
    WHERE  bh.Ma_DanhMuc = 1
      AND  bh.TrangThai  = N'DaXuatBan'
      AND NOT EXISTS (
          SELECT 1 FROM DangKyHoc dk
          WHERE  dk.Ma_NguoiDung  = nd.Ma_NguoiDung
            AND  dk.Ma_BaiHoc     = bh.Ma_BaiHoc
            AND  dk.TrangThaiHoc = N'HoanThanh'
      )
)
  AND nd.Ma_VaiTro = 3;

 --2. Học viên đã trả lời đúng TẤT CẢ câu hỏi của bài học số 1.
 SELECT nd.Ma_NguoiDung, nd.Ho + N' ' + nd.Ten AS HoTen
FROM   NguoiDung nd
WHERE NOT EXISTS (
    -- Tìm câu hỏi bài 1 mà học viên CHƯA trả lời đúng
    SELECT 1 FROM CauHoi ch
    WHERE  ch.Ma_BaiHoc = 1
      AND NOT EXISTS (
          SELECT 1 FROM TienDo td
          WHERE  td.Ma_NguoiDung = nd.Ma_NguoiDung
            AND  td.Ma_CauHoi   = ch.Ma_CauHoi
            AND  td.DapAnDung   = 1
      )
)
  AND nd.Ma_VaiTro = 3;

--3. Ký hiệu nào xuất hiện trong TẤT CẢ bài học cấp độ Beginner đã xuất bản.
SELECT kh.Ma_KyHieu, kh.TuVung
FROM   KyHieu kh
WHERE NOT EXISTS (
    -- Tìm bài Beginner mà ký hiệu này CHƯA có mặt
    SELECT 1 FROM BaiHoc bh
    WHERE  bh.CapDo    = 'Beginner'
      AND  bh.TrangThai = N'DaXuatBan'
      AND NOT EXISTS (
          SELECT 1 FROM BaiHoc_KyHieu bkh
          WHERE  bkh.Ma_BaiHoc = bh.Ma_BaiHoc
            AND  bkh.Ma_KyHieu = kh.Ma_KyHieu
      )
);

--4. Giảng viên đã tạo bài học ở TẤT CẢ cấp độ: Beginner, Intermediate, Advance
SELECT nd.Ma_NguoiDung, nd.Ho + N' ' + nd.Ten AS HoTen
FROM   NguoiDung nd
WHERE  nd.Ma_VaiTro = 2
  AND NOT EXISTS (
    -- Tìm cấp độ nào mà giảng viên CHƯA tạo bài
    SELECT 1
    FROM  (VALUES ('Beginner'),('Intermediate'),('Advance')) AS CapDo(Ten)
    WHERE NOT EXISTS (
        SELECT 1 FROM BaiHoc bh
        WHERE  bh.Ma_NguoiTao = nd.Ma_NguoiDung
          AND  bh.CapDo       = CapDo.Ten
    )
);
GO
------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------- 7 THỦ TỤC ---------------------------------------------------------------------------------------------------------

--1. Đăng ký học viên vào bài học
CREATE PROC sp_DangKyHoc
    @Ma_NguoiDung INT,
    @Ma_BaiHoc    INT
AS 
BEGIN
    IF NOT EXISTS (SELECT 1 FROM NguoiDung WHERE Ma_NguoiDung = @Ma_NguoiDung)
    BEGIN
        RAISERROR(N'Học viên không tồn tại.', 16, 1); RETURN;
    END
    IF NOT EXISTS (SELECT 1 FROM BaiHoc WHERE Ma_BaiHoc = @Ma_BaiHoc AND TrangThai = N'DaXuatBan')
    BEGIN
        RAISERROR(N'Bài học không tồn tại hoặc chưa xuất bản.', 16, 1); RETURN;
    END
    IF EXISTS (SELECT 1 FROM DangKyHoc WHERE Ma_NguoiDung = @Ma_NguoiDung AND Ma_BaiHoc = @Ma_BaiHoc)
    BEGIN
        RAISERROR(N'Học viên đã đăng ký bài học này rồi.', 16, 1); RETURN;
    END
    INSERT INTO DangKyHoc (Ma_NguoiDung, Ma_BaiHoc)
    VALUES (@Ma_NguoiDung, @Ma_BaiHoc);
    PRINT N'Đăng ký thành công.';
END
GO
--Vi du
EXEC sp_DangKyHoc @Ma_NguoiDung = 4, @Ma_BaiHoc = 5;
GO

SELECT Ma_NguoiDung,Ma_BaiHoc
FROM DangKyHoc;

DROP PROCEDURE sp_DangKyHoc;
GO

--2. Lấy danh sách bài học kèm số học viên đang học
CREATE PROCEDURE sp_DanhSachBaiHoc
    @CapDo NVARCHAR(20) = NULL
AS BEGIN
    SELECT
        bh.Ma_BaiHoc,
        bh.TieuDe,
        bh.CapDo,
        bh.TrangThai,
        bh.ThuTu,
        COUNT(dk.Ma_DangKy)                                        AS TongDangKy,
        SUM(CASE WHEN dk.TrangThaiHoc = N'DangHoc'   THEN 1 ELSE 0 END) AS SoDangHoc,
        SUM(CASE WHEN dk.TrangThaiHoc = N'HoanThanh' THEN 1 ELSE 0 END) AS SoHoanThanh
    FROM      BaiHoc   bh
    LEFT JOIN DangKyHoc dk ON dk.Ma_BaiHoc = bh.Ma_BaiHoc
    WHERE (@CapDo IS NULL OR bh.CapDo = @CapDo)
    GROUP BY bh.Ma_BaiHoc, bh.TieuDe, bh.CapDo, bh.TrangThai,bh.ThuTu
    ORDER BY bh.ThuTu;
END
GO

EXEC sp_DanhSachBaiHoc;             
GO

DROP PROC sp_DanhSachBaiHoc;
GO

--3. Ghi nhận kết quả làm bài của học viên
CREATE PROCEDURE sp_GhiTienDo
    @Ma_NguoiDung INT,
    @Ma_CauHoi    INT,
    @DapAnDung    BIT,
    @ThoiGianLam  INT
AS BEGIN
    DECLARE @Diem    FLOAT = 0;
    DECLARE @SoLan   INT;
    DECLARE @TrangThai NVARCHAR(30);

    SELECT @Diem = CASE WHEN @DapAnDung = 1 THEN DiemMacDinh ELSE 0 END
    FROM CauHoi WHERE Ma_CauHoi = @Ma_CauHoi;

    SELECT @SoLan = ISNULL(COUNT(*), 0) + 1
    FROM TienDo
    WHERE Ma_NguoiDung = @Ma_NguoiDung AND Ma_CauHoi = @Ma_CauHoi;

    SET @TrangThai = CASE WHEN @DapAnDung = 1 THEN N'HoanThanh' ELSE N'ChuaDat' END;

    INSERT INTO TienDo (Ma_NguoiDung, Ma_CauHoi, DapAnDung, DiemSo, SoLanThu, ThoiGianLam, TrangThai)
    VALUES (@Ma_NguoiDung, @Ma_CauHoi, @DapAnDung, @Diem, @SoLan, @ThoiGianLam, @TrangThai);
END
GO

EXEC sp_GhiTienDo @Ma_NguoiDung=4, @Ma_CauHoi=5, @DapAnDung=1, @ThoiGianLam=25;
GO

SELECT * FROM TienDo;

DROP PROC sp_GhiTienDo;
GO

--4. Thống kê tiến độ học của một học viên
CREATE PROCEDURE sp_TienDoHocVien
    @Ma_NguoiDung INT
AS BEGIN
    SELECT
        bh.TieuDe,
        bh.CapDo,
        dk.TrangThaiHoc,
        dk.PhanTramHoanThanh,
        dk.NgayDangKy,
        dk.NgayHoanThanh,
        ISNULL(kq.DiemTong, 0)       AS DiemTong,
        ISNULL(kq.PhanTramDung, 0)   AS PhanTramDung
    FROM      DangKyHoc       dk
    JOIN      BaiHoc          bh ON bh.Ma_BaiHoc    = dk.Ma_BaiHoc
    LEFT JOIN KetQuaBaiHoc    kq ON kq.Ma_NguoiDung = dk.Ma_NguoiDung
                                AND kq.Ma_BaiHoc    = dk.Ma_BaiHoc
    WHERE dk.Ma_NguoiDung = @Ma_NguoiDung
    ORDER BY dk.NgayDangKy;
END
GO

EXEC sp_TienDoHocVien @Ma_NguoiDung = 17;
GO

DROP PROC sp_TienDoHocVien;
GO
--5. Tìm kiếm ký hiệu theo từ khóa và độ khó
CREATE PROCEDURE sp_TimKiemKyHieu
    @TuKhoa NVARCHAR(100),
    @DoKho  NVARCHAR(20) = NULL
AS BEGIN
    SELECT
        kh.Ma_KyHieu,
        kh.TuVung,
        kh.DoKho,
        kh.TrangThai,
        kh.ThuTuHienThi,
        COUNT(dpt.Ma_DaPhuongTien) AS SoLuongMedia
    FROM      KyHieu       kh
    LEFT JOIN DaPhuongTien dpt ON dpt.Ma_KyHieu = kh.Ma_KyHieu
    WHERE kh.TuVung LIKE N'%' + @TuKhoa + N'%'
      AND (@DoKho IS NULL OR kh.DoKho = @DoKho)
    GROUP BY kh.Ma_KyHieu, kh.TuVung, kh.DoKho, kh.TrangThai,kh.ThuTuHienThi
    ORDER BY kh.ThuTuHienThi;
END
GO

EXEC sp_TimKiemKyHieu @TuKhoa = N'b', @DoKho = N'De';
GO

DROP PROC sp_TimKiemKyHieu;
GO

--6. Xuất bản bài học sau khi kiểm tra đủ điều kiện
CREATE PROCEDURE sp_XuatBanBaiHoc
    @Ma_BaiHoc INT
AS BEGIN
    IF NOT EXISTS (SELECT 1 FROM BaiHoc_KyHieu WHERE Ma_BaiHoc = @Ma_BaiHoc)
    BEGIN
        RAISERROR(N'Bài học chưa có ký hiệu nào.', 16, 1); RETURN;
    END
    IF NOT EXISTS (SELECT 1 FROM CauHoi WHERE Ma_BaiHoc = @Ma_BaiHoc)
    BEGIN
        RAISERROR(N'Bài học chưa có câu hỏi nào.', 16, 1); RETURN;
    END
    UPDATE BaiHoc
    SET    TrangThai = N'DaXuatBan'
    WHERE  Ma_BaiHoc = @Ma_BaiHoc;
    PRINT N'Xuất bản thành công.';
END
GO

EXEC sp_XuatBanBaiHoc @Ma_BaiHoc = 19;
GO

DROP PROC sp_XuatBanBaiHoc;
GO

--7. Báo cáo tổng quan hệ thống theo vai trò
CREATE PROCEDURE sp_BaoCaoNguoiDung
AS BEGIN
    SELECT
        vt.Ten_VaiTro,
        COUNT(*)                                                           AS TongSo,
        SUM(CASE WHEN nd.TrangThai = N'HoatDong'    THEN 1 ELSE 0 END)  AS HoatDong,
        SUM(CASE WHEN nd.TrangThai = N'KhoaTaiKhoan'THEN 1 ELSE 0 END)  AS BiKhoa,
        SUM(CASE WHEN nd.TrangThai = N'ChoXacNhan'  THEN 1 ELSE 0 END)  AS ChoXacNhan,
        SUM(CASE WHEN nd.IsDeaf = 1                 THEN 1 ELSE 0 END)  AS NguoiKhiemThinh
    FROM NguoiDung nd
    JOIN VaiTro    vt ON vt.Ma_VaiTro = nd.Ma_VaiTro
    GROUP BY vt.Ten_VaiTro
    ORDER BY vt.Ten_VaiTro;
END
GO

EXEC sp_BaoCaoNguoiDung;
GO

DROP PROC sp_BaoCaoNguoiDung;
GO
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------ 8 HÀM -----------------------------------------------------------------------------------------------------------

--1. Tính phần trăm hoàn thành thực tế của học viên trong một bài

DROP FUNCTION IF EXISTS fn_PhamTramHoanThanh;
GO

CREATE FUNCTION fn_PhanTramHoanThanh (
    @Ma_NguoiDung INT,
    @Ma_BaiHoc    INT
) RETURNS FLOAT
AS BEGIN
    DECLARE @SoCauDung INT, @TongCau INT;
    SELECT @TongCau = COUNT(*) FROM CauHoi WHERE Ma_BaiHoc = @Ma_BaiHoc;
    SELECT @SoCauDung = COUNT(*)
    FROM TienDo td JOIN CauHoi ch ON ch.Ma_CauHoi = td.Ma_CauHoi
    WHERE td.Ma_NguoiDung = @Ma_NguoiDung
      AND ch.Ma_BaiHoc    = @Ma_BaiHoc
      AND td.DapAnDung    = 1;
    RETURN CASE WHEN @TongCau = 0 THEN 0
               ELSE ROUND(CAST(@SoCauDung AS FLOAT) / @TongCau * 100, 2) END;
END
GO

SELECT dbo.fn_PhanTramHoanThanh(4, 1) AS PhanTram;
GO

--2. Xếp loại học viên dựa trên phần trăm đúng
DROP FUNCTION IF EXISTS fn_XepLoai;
GO

CREATE FUNCTION fn_XepLoai (@PhanTram FLOAT)
RETURNS NVARCHAR(20)
AS BEGIN
    RETURN CASE
        WHEN @PhanTram >= 90 THEN N'Xuất sắc'
        WHEN @PhanTram >= 80 THEN N'Giỏi'
        WHEN @PhanTram >= 65 THEN N'Khá'
        WHEN @PhanTram >= 50 THEN N'Trung bình'
        ELSE                       N'Yếu'
    END;
END
GO

SELECT Ma_NguoiDung, PhanTramDung,
       dbo.fn_XepLoai(PhanTramDung) AS XepLoai
FROM   KetQuaBaiHoc;
GO

--3. Đếm số bài học đã hoàn thành của một học viên
DROP FUNCTION IF EXISTS fn_SoBaiHoanThanh;
GO

CREATE FUNCTION fn_SoBaiHoanThanh (@Ma_NguoiDung INT)
RETURNS INT
AS BEGIN
    DECLARE @SoBai INT;
    SELECT @SoBai = COUNT(*)
    FROM   DangKyHoc
    WHERE  Ma_NguoiDung  = @Ma_NguoiDung
      AND  TrangThaiHoc  = N'HoanThanh';
    RETURN ISNULL(@SoBai, 0);
END
GO

SELECT Ma_NguoiDung, Ho + N' ' + Ten AS HoTen,
       dbo.fn_SoBaiHoanThanh(Ma_NguoiDung) AS SoBaiDat
FROM   NguoiDung WHERE Ma_VaiTro = 3;
GO

--4. Kiểm tra học viên có đủ điều kiện nhận chứng chỉ không

DROP FUNCTION IF EXISTS fn_DuDieuKienChungChi;
GO

CREATE FUNCTION fn_DuDieuKienChungChi (@Ma_NguoiDung INT)
RETURNS BIT
AS BEGIN
    DECLARE @KetQua BIT = 0;
    IF NOT EXISTS (
        SELECT 1 FROM KetQuaBaiHoc
        WHERE  Ma_NguoiDung = @Ma_NguoiDung
          AND  PhanTramDung < 80
    )
    AND EXISTS (
        SELECT 1 FROM KetQuaBaiHoc
        WHERE  Ma_NguoiDung = @Ma_NguoiDung
    )
        SET @KetQua = 1;
    RETURN @KetQua;
END
GO

SELECT Ma_NguoiDung, Ho + N' ' + Ten AS HoTen,
       dbo.fn_DuDieuKienChungChi(Ma_NguoiDung) AS DuDieuKien
FROM   NguoiDung WHERE Ma_VaiTro = 3;
GO

--5. Tính tổng thời gian học (phút) của học viên

DROP FUNCTION IF EXISTS fn_TongThoiGianHoc;
GO

CREATE FUNCTION fn_TongThoiGianHoc (@Ma_NguoiDung INT)
RETURNS INT
AS BEGIN
    DECLARE @TongPhut INT;
    SELECT @TongPhut = SUM(
        DATEDIFF(MINUTE, ThoiGianBatDau, ThoiGianKetThuc)
    )
    FROM  LichSuHoc
    WHERE Ma_NguoiDung = @Ma_NguoiDung;
    RETURN ISNULL(@TongPhut, 0);
END
GO

SELECT Ma_NguoiDung,
       dbo.fn_TongThoiGianHoc(Ma_NguoiDung) AS TongPhutHoc
FROM   NguoiDung WHERE Ma_VaiTro = 3
ORDER BY TongPhutHoc DESC;
GO

--6. Lấy tên đầy đủ của người dùng theo mã

DROP FUNCTION IF EXISTS fn_HoTen;
GO

CREATE FUNCTION fn_HoTen (@Ma_NguoiDung INT)
RETURNS NVARCHAR(60)
AS BEGIN
    DECLARE @HoTen NVARCHAR(60);
    SELECT @HoTen = Ho + N' ' + Ten
    FROM   NguoiDung WHERE Ma_NguoiDung = @Ma_NguoiDung;
    RETURN ISNULL(@HoTen, N'Không xác định');
END
GO

SELECT dbo.fn_HoTen(17) AS HoTen;
-- Kết quả: 'Nguyễn Q'

SELECT dbo.fn_HoTen(Ma_NguoiDung) AS HoTen, TrangThai
FROM   NguoiDung;

--7. Lấy danh sách câu hỏi kèm đáp án của một bài học

DROP FUNCTION IF EXISTS fn_CauHoiVaDapAn;
GO

CREATE FUNCTION fn_CauHoiVaDapAn (@Ma_BaiHoc INT)
RETURNS TABLE
AS RETURN (
    SELECT
        ch.Ma_CauHoi,
        ch.NoiDungCauHoi,
        ch.LoaiCauHoi,
        ch.DiemMacDinh,
        pa.Ma_PhuongAn,
        pa.NoiDung   AS PhuongAn,
        pa.LaDapAnDung,
        pa.ThuTu
    FROM      CauHoi          ch
    JOIN      PhuongAnTraLoi  pa ON pa.Ma_CauHoi = ch.Ma_CauHoi
    WHERE     ch.Ma_BaiHoc = @Ma_BaiHoc
    ORDER BY  ch.Ma_CauHoi, pa.ThuTu OFFSET 0 ROWS
);
GO

SELECT * FROM dbo.fn_CauHoiVaDapAn(1);

SELECT * FROM dbo.fn_CauHoiVaDapAn(2)
WHERE LoaiCauHoi = N'TracNghiem';
--8. Lấy lịch sử học của học viên trong khoảng thời gian
DROP FUNCTION IF EXISTS fn_LichSuHocTheoNgay;
GO

CREATE FUNCTION fn_LichSuHocTheoNgay (
    @Ma_NguoiDung INT,
    @TuNgay       DATE,
    @DenNgay      DATE
) RETURNS TABLE
AS RETURN (
    SELECT
        lsh.Ma_LichSu,
        bh.TieuDe         AS TenBaiHoc,
        bh.CapDo,
        lsh.ThoiGianBatDau,
        lsh.ThoiGianKetThuc,
        DATEDIFF(MINUTE, lsh.ThoiGianBatDau, lsh.ThoiGianKetThuc) AS ThoiLuongPhut,
        lsh.GhiChu
    FROM  LichSuHoc lsh
    JOIN  BaiHoc    bh  ON bh.Ma_BaiHoc = lsh.Ma_BaiHoc
    WHERE lsh.Ma_NguoiDung  = @Ma_NguoiDung
      AND CAST(lsh.ThoiGianBatDau AS DATE) BETWEEN @TuNgay AND @DenNgay
);
GO

SELECT * FROM dbo.fn_LichSuHocTheoNgay(17, '2025-01-01', '2025-06-30');

SELECT TenBaiHoc, SUM(ThoiLuongPhut) AS TongPhut
FROM   dbo.fn_LichSuHocTheoNgay(17, '2025-01-01', '2025-06-30')
GROUP BY TenBaiHoc;

GO
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------ 5 TRIGGER -------------------------------------------------------------------------------------------------------

-- TRIGGER 1: Tự động cập nhật NgayCapNhat trong NguoiDung

DROP TRIGGER IF EXISTS trg_CapNhatNguoiDung;
GO

CREATE OR ALTER TRIGGER trg_CapNhatNguoiDung
ON NguoiDung
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE NguoiDung
    SET NgayCapNhat = GETDATE()
    FROM NguoiDung nd
    INNER JOIN inserted i ON nd.Ma_NguoiDung = i.Ma_NguoiDung;
END;
GO

-- Ví dụ: Sửa số điện thoại của Nguyễn A (Ma_NguoiDung = 1)
-- Trước: NgayCapNhat = 2025-01-01 (ngày tạo tài khoản cũ)
UPDATE NguoiDung
SET SoDienThoai = N'0999999999'
WHERE Ma_NguoiDung = 1;
-- Sau: NgayCapNhat tự động = thời điểm vừa chạy lệnh UPDATE
-- Kiểm tra:
SELECT Ma_NguoiDung, Ho, Ten, SoDienThoai, NgayCapNhat
FROM NguoiDung
WHERE Ma_NguoiDung = 1;
GO


-- TRIGGER 2: Không cho đăng ký bài học đang bị ẩn hoặc nháp
DROP TRIGGER IF EXISTS trg_KiemTraDangKyHoc;
GO

CREATE OR ALTER TRIGGER trg_KiemTraDangKyHoc
ON DangKyHoc
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (
        SELECT 1 FROM inserted i
        INNER JOIN BaiHoc b ON b.Ma_BaiHoc = i.Ma_BaiHoc
        WHERE b.TrangThai IN (N'NhapBai', N'TamAn')
    )
    BEGIN
        RAISERROR(N'Không thể đăng ký bài học chưa được xuất bản!', 16, 1);
        ROLLBACK;
    END;
END;
GO

-- Ví dụ: Thử đăng ký bài học số 18 (Công nghệ hiện đại - đang TamAn)
-- và bài 19 (Du lịch - đang NhapBai) → cả 2 đều bị chặn

-- Trường hợp 1: Bài đang TamAn → bị chặn
INSERT INTO DangKyHoc (Ma_NguoiDung, Ma_BaiHoc)
VALUES (4, 18);
-- Kết quả: Msg "Không thể đăng ký bài học chưa được xuất bản!"

-- Trường hợp 2: Bài đang NhapBai → bị chặn
INSERT INTO DangKyHoc (Ma_NguoiDung, Ma_BaiHoc)
VALUES (4, 19);
-- Kết quả: Msg "Không thể đăng ký bài học chưa được xuất bản!"

-- Trường hợp 3: Bài đang DaXuatBan → thành công bình thường
INSERT INTO DangKyHoc (Ma_NguoiDung, Ma_BaiHoc)
VALUES (4, 3);
-- Kết quả: Insert thành công
-- Dọn dữ liệu test:
DELETE FROM DangKyHoc WHERE Ma_NguoiDung = 4 AND Ma_BaiHoc = 3;
GO


-- TRIGGER 3: Tự động đặt NgayHoanThanh khi chuyển sang HoanThanh
DROP TRIGGER IF EXISTS trg_GhiNgayHoanThanh;
GO

CREATE OR ALTER TRIGGER trg_GhiNgayHoanThanh
ON DangKyHoc
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE DangKyHoc
    SET NgayHoanThanh = GETDATE()
    FROM DangKyHoc dk
    INNER JOIN inserted i ON dk.Ma_DangKy = i.Ma_DangKy
    INNER JOIN deleted  d ON dk.Ma_DangKy = d.Ma_DangKy
    WHERE i.TrangThaiHoc = N'HoanThanh'
      AND d.TrangThaiHoc <> N'HoanThanh';
END;
GO

-- Ví dụ: Học viên Nguyễn Q (Ma_NguoiDung = 17) đang học bài số 5
-- TrangThaiHoc hiện tại = 'DangHoc', NgayHoanThanh = NULL
-- Kiểm tra trước:
SELECT Ma_NguoiDung, Ma_BaiHoc, TrangThaiHoc, NgayHoanThanh
FROM DangKyHoc
WHERE Ma_NguoiDung = 17 AND Ma_BaiHoc = 5;

-- Học viên hoàn thành bài → cập nhật trạng thái
UPDATE DangKyHoc
SET TrangThaiHoc = N'HoanThanh', PhanTramHoanThanh = 100
WHERE Ma_NguoiDung = 17 AND Ma_BaiHoc = 5;

-- Kiểm tra sau: NgayHoanThanh tự động được điền
SELECT Ma_NguoiDung, Ma_BaiHoc, TrangThaiHoc, NgayHoanThanh
FROM DangKyHoc
WHERE Ma_NguoiDung = 17 AND Ma_BaiHoc = 5;
-- Kết quả: NgayHoanThanh = thời điểm vừa update, không cần nhập tay
GO


-- TRIGGER 4: Không cho xóa NguoiDung đang có dữ liệu học
DROP TRIGGER IF EXISTS trg_KiemTraXoaNguoiDung;
GO

CREATE OR ALTER TRIGGER trg_KiemTraXoaNguoiDung
ON NguoiDung
INSTEAD OF DELETE
AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (
        SELECT 1 FROM deleted d
        WHERE EXISTS (SELECT 1 FROM DangKyHoc WHERE Ma_NguoiDung = d.Ma_NguoiDung)
           OR EXISTS (SELECT 1 FROM TienDo     WHERE Ma_NguoiDung = d.Ma_NguoiDung)
           OR EXISTS (SELECT 1 FROM LichSuHoc  WHERE Ma_NguoiDung = d.Ma_NguoiDung)
    )
    BEGIN
        RAISERROR(N'Không thể xóa người dùng đang có dữ liệu học!', 16, 1);
        RETURN;
    END;

    DELETE FROM NguoiDung
    WHERE Ma_NguoiDung IN (SELECT Ma_NguoiDung FROM deleted);
END;
GO

-- Ví dụ 1: Xóa Nguyễn D (Ma_NguoiDung = 4) → có DangKyHoc, TienDo, LichSuHoc → bị chặn
DELETE FROM NguoiDung WHERE Ma_NguoiDung = 4;
-- Kết quả: Msg "Không thể xóa người dùng đang có dữ liệu học!"

-- Ví dụ 2: Thêm người dùng mới chưa có dữ liệu học rồi xóa → thành công
INSERT INTO NguoiDung (Ho, Ten, Email, MatKhau, Ma_VaiTro, IsDeaf)
VALUES (N'Test', N'User', N'test@gmail.com', N'123', 3, 0);

DELETE FROM NguoiDung WHERE Email = 'test@gmail.com';
-- Kết quả: Xóa thành công vì chưa có dữ liệu liên quan
GO


-- TRIGGER 5: Tự động chuyển BaoCaoLoi sang DangXuLy khi có người sửa
DROP TRIGGER IF EXISTS trg_CapNhatBaoCaoLoi;
GO

CREATE OR ALTER TRIGGER trg_CapNhatBaoCaoLoi
ON BaoCaoLoi
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE BaoCaoLoi
    SET TrangThai = N'DangXuLy'
    FROM BaoCaoLoi bc
    INNER JOIN inserted i ON bc.Ma_BaoCao = i.Ma_BaoCao
    INNER JOIN deleted  d ON bc.Ma_BaoCao = d.Ma_BaoCao
    WHERE d.TrangThai = N'ChuaXuLy'
      AND i.TrangThai = N'ChuaXuLy';
END;
GO

-- Ví dụ: Báo cáo lỗi số 7 (ký hiệu "Em", đang ChuaXuLy)
-- Admin mở ra sửa nội dung nhưng quên đổi trạng thái
-- Kiểm tra trước:
SELECT Ma_BaoCao, NoiDungLoi, TrangThai
FROM BaoCaoLoi
WHERE Ma_BaoCao = 7;
-- TrangThai = 'ChuaXuLy'

-- Admin cập nhật nội dung lỗi nhưng không đổi TrangThai
UPDATE BaoCaoLoi
SET NoiDungLoi = N'Cần thêm ví dụ trong câu cho ký hiệu Em - đã xem xét'
WHERE Ma_BaoCao = 7;

-- Kiểm tra sau: trigger tự chuyển sang DangXuLy
SELECT Ma_BaoCao, NoiDungLoi, TrangThai
FROM BaoCaoLoi
WHERE Ma_BaoCao = 7;
-- Kết quả: TrangThai = 'DangXuLy' (tự động đổi dù admin không set)
GO
 
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------- TẠO USER -------------------------------------------------------------------------------------------------------
CREATE LOGIN login_admin       WITH PASSWORD = N'Admin@123';
CREATE LOGIN login_giangvien   WITH PASSWORD = N'GiangVien@123';
CREATE LOGIN login_hocvien     WITH PASSWORD = N'HocVien@123';
CREATE LOGIN login_kiemduyệt  WITH PASSWORD = N'KiemDuyet@123';
CREATE LOGIN login_chuyengia   WITH PASSWORD = N'ChuyenGia@123';
GO

CREATE USER user_admin      FOR LOGIN login_admin;
CREATE USER user_giangvien  FOR LOGIN login_giangvien;
CREATE USER user_hocvien    FOR LOGIN login_hocvien;
CREATE USER user_kiemduyệt FOR LOGIN login_kiemduyệt;
CREATE USER user_chuyengia  FOR LOGIN login_chuyengia;
GO

------------------- user_admin -------------------
GRANT SELECT, INSERT, UPDATE, DELETE ON NguoiDung      TO user_admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON BaiHoc         TO user_admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON KyHieu         TO user_admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON DangKyHoc      TO user_admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON CauHoi         TO user_admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON TienDo         TO user_admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON KetQuaBaiHoc   TO user_admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON BaoCaoLoi      TO user_admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON LichSuHoc      TO user_admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON DaPhuongTien   TO user_admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON PhuongAnTraLoi TO user_admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON VaiTro         TO user_admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON DanhMucBaiHoc  TO user_admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON BaiHoc_KyHieu  TO user_admin;
GRANT CREATE TABLE TO user_admin;
GO
--------------------------------------------------

----------------- user_giangvien -----------------
GRANT SELECT, INSERT, UPDATE, DELETE ON BaiHoc         TO user_giangvien;
GRANT SELECT, INSERT, UPDATE, DELETE ON KyHieu         TO user_giangvien;
GRANT SELECT, INSERT, UPDATE, DELETE ON BaiHoc_KyHieu  TO user_giangvien;
GRANT SELECT, INSERT, UPDATE, DELETE ON CauHoi         TO user_giangvien;
GRANT SELECT, INSERT, UPDATE, DELETE ON PhuongAnTraLoi TO user_giangvien;
GRANT SELECT, INSERT, UPDATE, DELETE ON DaPhuongTien   TO user_giangvien;
GRANT SELECT, INSERT, UPDATE, DELETE ON DanhMucBaiHoc  TO user_giangvien;
GRANT SELECT                         ON NguoiDung      TO user_giangvien;
GRANT SELECT                         ON DangKyHoc      TO user_giangvien;

DENY DELETE ON BaiHoc TO user_giangvien;
GO
--------------------------------------------------

------------------ user_hocvien ------------------
GRANT SELECT          ON BaiHoc         TO user_hocvien;
GRANT SELECT          ON KyHieu         TO user_hocvien;
GRANT SELECT          ON BaiHoc_KyHieu  TO user_hocvien;
GRANT SELECT          ON CauHoi         TO user_hocvien;
GRANT SELECT          ON PhuongAnTraLoi TO user_hocvien;
GRANT SELECT          ON DaPhuongTien   TO user_hocvien;
GRANT SELECT          ON DanhMucBaiHoc  TO user_hocvien;
GRANT SELECT          ON KetQuaBaiHoc   TO user_hocvien;
GRANT SELECT, INSERT  ON DangKyHoc      TO user_hocvien;
GRANT SELECT, INSERT, UPDATE ON TienDo  TO user_hocvien;
GRANT INSERT          ON BaoCaoLoi      TO user_hocvien;


DENY SELECT, INSERT, UPDATE, DELETE ON NguoiDung TO user_hocvien;
GO
--------------------------------------------------

----------------- user_kiemduyet -----------------
GRANT SELECT, INSERT, UPDATE ON BaiHoc         TO user_kiemduyệt;
GRANT SELECT, UPDATE         ON KyHieu         TO user_kiemduyệt;
GRANT SELECT, UPDATE         ON DaPhuongTien   TO user_kiemduyệt;
GRANT SELECT, UPDATE         ON BaoCaoLoi      TO user_kiemduyệt;
GRANT SELECT                 ON NguoiDung      TO user_kiemduyệt;
GRANT SELECT                 ON DangKyHoc      TO user_kiemduyệt;
GRANT SELECT                 ON CauHoi         TO user_kiemduyệt;

REVOKE INSERT ON BaiHoc FROM user_kiemduyệt;

DENY DELETE ON BaiHoc        TO user_kiemduyệt;
DENY DELETE ON KyHieu        TO user_kiemduyệt;
DENY DELETE ON DaPhuongTien  TO user_kiemduyệt;
DENY DELETE ON BaoCaoLoi     TO user_kiemduyệt;
GO
--------------------------------------------------

----------------- user_chuyengia -----------------
GRANT SELECT          ON BaiHoc         TO user_chuyengia;
GRANT SELECT          ON DanhMucBaiHoc  TO user_chuyengia;
GRANT SELECT, UPDATE  ON KyHieu         TO user_chuyengia;
GRANT SELECT          ON BaiHoc_KyHieu  TO user_chuyengia;
GRANT SELECT          ON CauHoi         TO user_chuyengia;
GRANT SELECT          ON PhuongAnTraLoi TO user_chuyengia;
GRANT SELECT          ON DaPhuongTien   TO user_chuyengia;
GRANT SELECT, UPDATE  ON BaoCaoLoi      TO user_chuyengia;
GRANT SELECT          ON KetQuaBaiHoc   TO user_chuyengia;


DENY INSERT, UPDATE, DELETE ON NguoiDung  TO user_chuyengia;
DENY INSERT, UPDATE, DELETE ON DangKyHoc  TO user_chuyengia;
DENY INSERT, UPDATE, DELETE ON TienDo     TO user_chuyengia;
DENY INSERT, UPDATE, DELETE ON LichSuHoc  TO user_chuyengia;
GO
--------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
