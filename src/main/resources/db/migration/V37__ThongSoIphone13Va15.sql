-- Nguồn: https://support.apple.com/en-us/111872
-- Nguồn: https://support.apple.com/en-us/111831
-- Chỉ gán thông số được xác minh cho đúng model; không ghi đè dữ liệu quản trị.
INSERT INTO "ThuocTinhDanhMuc" ("MaPhanLoai", "KyHieu", "TenThuocTinh", "KieuDuLieu", "ThuTu")
SELECT DISTINCT s."MaPhanLoai", a.code, a.label, 'CHU', a.position
FROM "SanPham" s CROSS JOIN (VALUES
  ('CPU_CHI_TIET', 'Loại CPU', 10),
  ('GPU_CHI_TIET', 'GPU', 20),
  ('CONG_NGHE_MAN_HINH', 'Công nghệ màn hình', 30),
  ('DO_PHAN_GIAI_MAN_HINH', 'Độ phân giải màn hình', 40),
  ('TINH_NANG_MAN_HINH', 'Tính năng màn hình', 50),
  ('CAMERA_SAU', 'Camera sau', 60),
  ('CAMERA_TRUOC', 'Camera trước', 70),
  ('PIN_CHI_TIET', 'Pin', 80),
  ('HO_TRO_MANG', 'Hỗ trợ mạng', 90),
  ('THOI_DIEM_RA_MAT', 'Thời điểm ra mắt', 100)
) AS a(code, label, position)
WHERE s."DuongDan" IN ('iphone-13', 'iphone-15')
ON CONFLICT ("MaPhanLoai", "KyHieu") DO NOTHING;

INSERT INTO "GiaTriThuocTinhBienThe" ("MaBienThe", "MaSanPham", "MaPhanLoai", "MaThuocTinh", "KieuDuLieu", "GiaTriChu")
SELECT b."MaBienThe", s."MaSanPham", s."MaPhanLoai", t."MaThuocTinh", 'CHU', a.value
FROM (VALUES
  ('iphone-13','CPU_CHI_TIET','CPU 6 lõi: 2 lõi hiệu năng và 4 lõi tiết kiệm điện'),
  ('iphone-13','GPU_CHI_TIET','GPU 4 lõi'),
  ('iphone-13','CONG_NGHE_MAN_HINH','Super Retina XDR OLED'),
  ('iphone-13','DO_PHAN_GIAI_MAN_HINH','2532 × 1170 pixel'),
  ('iphone-13','TINH_NANG_MAN_HINH','HDR, True Tone, dải màu rộng P3, Haptic Touch; độ sáng tối đa 800 nit thông thường và 1200 nit HDR'),
  ('iphone-13','CAMERA_SAU','Camera kép 12 MP: chính f/1.6 và góc siêu rộng f/2.4'),
  ('iphone-13','CAMERA_TRUOC','TrueDepth 12 MP, f/2.2'),
  ('iphone-13','PIN_CHI_TIET','Pin lithium-ion sạc lại tích hợp; xem video tối đa 19 giờ theo Apple'),
  ('iphone-13','HO_TRO_MANG','5G; băng tần phụ thuộc phiên bản và nhà mạng'),
  ('iphone-13','THOI_DIEM_RA_MAT','2021'),
  ('iphone-15','CPU_CHI_TIET','CPU 6 lõi: 2 lõi hiệu năng và 4 lõi tiết kiệm điện'),
  ('iphone-15','GPU_CHI_TIET','GPU 5 lõi'),
  ('iphone-15','CONG_NGHE_MAN_HINH','Super Retina XDR OLED'),
  ('iphone-15','DO_PHAN_GIAI_MAN_HINH','2556 × 1179 pixel'),
  ('iphone-15','TINH_NANG_MAN_HINH','Dynamic Island, HDR, True Tone, dải màu rộng P3; tối đa 1000 nit thông thường, 1600 nit HDR và 2000 nit ngoài trời'),
  ('iphone-15','CAMERA_SAU','Camera chính 48 MP f/1.6; camera góc siêu rộng 12 MP f/2.4; zoom 2x chất lượng quang học'),
  ('iphone-15','CAMERA_TRUOC','TrueDepth 12 MP, f/1.9, tự động lấy nét Focus Pixels'),
  ('iphone-15','PIN_CHI_TIET','Pin lithium-ion sạc lại tích hợp; xem video tối đa 20 giờ theo Apple'),
  ('iphone-15','HO_TRO_MANG','5G; băng tần phụ thuộc phiên bản và nhà mạng'),
  ('iphone-15','THOI_DIEM_RA_MAT','2023')
) AS a(slug, code, value)
JOIN "SanPham" s ON s."DuongDan"=a.slug
JOIN "BienTheSanPham" b ON b."MaSanPham"=s."MaSanPham"
JOIN "ThuocTinhDanhMuc" t ON t."MaPhanLoai"=s."MaPhanLoai" AND t."KyHieu"=a.code AND t."KieuDuLieu"='CHU'
ON CONFLICT ("MaBienThe", "MaThuocTinh") DO NOTHING;
