-- Giá và ảnh tham khảo từ CellphoneS ngày 2026-11-16; tồn kho giả lập phục vụ webtest.
DO $seed$
DECLARE r record; category_id bigint; brand_id bigint; product_id bigint; sku_id bigint;
BEGIN
 FOR r IN SELECT * FROM (VALUES
  ('POCO X8 Pro Max 12GB 512GB','dien-thoai-xiaomi-poco-x8-pro-max-12gb-512gb','dien-thoai','xiaomi','MediaTek Dimensity 9500s','Immortalis-G925 MC11',12,512,6.83,'Xiaomi HyperOS 3 (Android 16)',17490000,'dien-thoai-xiaomi-poco-x8-pro-max-12gb-512gb.jpg','https://cellphones.com.vn/dien-thoai-xiaomi-poco-x8-pro-max-12gb-512gb.html'),
  ('Laptop ASUS ExpertBook P1 P1403CVA-C5H16-63WS','laptop-asus-expertbook-p1-p1403cva-c5h16-63ws','laptop','asus','Intel Core 5 210H','Intel Graphics',16,512,14,'Windows 11 Home',24190000,'laptop-asus-expertbook-p1-p1403cva-c5h16-63ws.png','https://cellphones.com.vn/laptop-asus-expertbook-p1-p1403cva-c5h16-63ws.html'),
  ('Tai nghe Bluetooth True Wireless Anker Soundcore P40i','tai-nghe-bluetooth-anker-soundcore-p40i','tai-nghe','anker','Không áp dụng','',0,0,0,'Không áp dụng',970000,'tai-nghe-bluetooth-anker-soundcore-p40i.jpg','https://cellphones.com.vn/tai-nghe-bluetooth-anker-soundcore-p40i.html')
 ) AS v(ten,slug,category,brand,cpu,gpu,ram,storage,screen,os,price,image,source) LOOP
  SELECT "MaPhanLoai" INTO category_id FROM "PhanLoai" WHERE "DuongDan"=r.category;
  SELECT "MaThuongHieu" INTO brand_id FROM "ThuongHieu" WHERE "DuongDan"=r.brand;
  IF category_id IS NULL OR brand_id IS NULL THEN RAISE EXCEPTION 'Thiếu danh mục hoặc hãng cho %',r.slug; END IF;
  product_id := NULL;
  INSERT INTO "SanPham" ("MaPhanLoai","MaThuongHieu","TenSanPham","DuongDan","TenTimKiem","MoTaNgan","MoTaChiTiet","SoThangBaoHanh","ThongSoChung","DuongDanNguon","NgayThuThap","LaDuLieuMau","DangHienThi","NgayCapNhat")
  VALUES (category_id,brand_id,r.ten,r.slug,lower(r.ten),'Sản phẩm tham khảo từ CellphoneS.','Giá và ảnh tham khảo từ CellphoneS; tồn kho là dữ liệu thử nghiệm.',0,'{}'::jsonb,r.source,DATE '2026-11-16',true,true,now()) ON CONFLICT ("DuongDan") DO NOTHING RETURNING "MaSanPham" INTO product_id;
  IF product_id IS NULL THEN CONTINUE; END IF;
  INSERT INTO "BienTheSanPham" ("MaSanPham","MaHang","TenBienThe","MauSac","BoXuLy","BoXuLyDoHoa","DungLuongRam","DungLuongLuuTru","KichThuocManHinh","HeDieuHanh","ThongSoBoSung","GiaNiemYet","GiaBan","GiaVon","DangKinhDoanh","NgayCapNhat")
  VALUES (product_id,'CPS-'||upper(r.slug),'Phiên bản tham khảo','Theo ảnh',r.cpu,r.gpu,r.ram,r.storage,r.screen,r.os,'{}'::jsonb,r.price,r.price,0,true,now()) RETURNING "MaBienThe" INTO sku_id;
  INSERT INTO "TonKho" ("MaKhoHang","MaBienThe","SoLuongTon","SoLuongGiu","NgayCapNhat") VALUES (1,sku_id,10,0,now());
  INSERT INTO "TepSanPham" ("MaSanPham","MaBienThe","LoaiTep","DuongDanTep","MoTaThayThe","ThuTu","DuongDanNguon","ThongTinSuDung","NgayCapNhat") VALUES (product_id,sku_id,'ANH','/media/cellphones/'||r.image,r.ten,0,r.source,'Ảnh tham khảo từ CellphoneS',now());
 END LOOP;
END $seed$;

CREATE TEMP TABLE "CpsThongSo" (slug text, category text, code text, label text, value text) ON COMMIT DROP;
INSERT INTO "CpsThongSo" VALUES
  ('dien-thoai-xiaomi-poco-x8-pro-max-12gb-512gb','dien-thoai','CPS_EA49523D744C40BC','GPU','Immortalis-G925 MC11'),
  ('dien-thoai-xiaomi-poco-x8-pro-max-12gb-512gb','dien-thoai','CPS_13242CF608A18869','Công nghệ màn hình','AMOLED'),
  ('dien-thoai-xiaomi-poco-x8-pro-max-12gb-512gb','dien-thoai','CPS_6AD99369EBF0CEB0','Độ phân giải màn hình','2772 x 1280 pixels'),
  ('dien-thoai-xiaomi-poco-x8-pro-max-12gb-512gb','dien-thoai','CPS_177829035AD5CD47','Tính năng màn hình','Độ sáng tối đa 3.500 nits, PWM 3840Hz, 68 tỷ màu, dải màu DCI-P3, HDR10+'),
  ('dien-thoai-xiaomi-poco-x8-pro-max-12gb-512gb','dien-thoai','CPS_75E995D62B36E7A6','Camera sau','50 MP f/1.5 (cảm biến Light Hunter 600, OIS) + 8 MP (góc siêu rộng)'),
  ('dien-thoai-xiaomi-poco-x8-pro-max-12gb-512gb','dien-thoai','CPS_C0EEF589BC971393','Camera trước','20 MP'),
  ('dien-thoai-xiaomi-poco-x8-pro-max-12gb-512gb','dien-thoai','CPS_FF1CEE74414621D8','Pin','8.500 mAh'),
  ('dien-thoai-xiaomi-poco-x8-pro-max-12gb-512gb','dien-thoai','CPS_65CC7381F4CE673F','Thẻ SIM','Dual nano-SIM hoặc 1 nano-SIM + 1 eSIM'),
  ('dien-thoai-xiaomi-poco-x8-pro-max-12gb-512gb','dien-thoai','CPS_6078C9EDAA3396EF','Thời điểm ra mắt','03/2026'),
  ('laptop-asus-expertbook-p1-p1403cva-c5h16-63ws','laptop','CPS_B8EBF6419B619D37','Loại RAM','DDR5 SO-DIMM'),
  ('laptop-asus-expertbook-p1-p1403cva-c5h16-63ws','laptop','CPS_AF9B9202D5298B75','Số khe ram','Có thể nâng cấp; Cần tháo vỏ dưới/trên'),
  ('laptop-asus-expertbook-p1-p1403cva-c5h16-63ws','laptop','CPS_6DCC7DA7EFC7C920','Ổ cứng','512GB SSD M.2 2280 NVMe PCIe 4.0 Khe mở rộng lưu trữ SSD'),
  ('laptop-asus-expertbook-p1-p1403cva-c5h16-63ws','laptop','CPS_13242CF608A18869','Công nghệ màn hình','Màn hình chống chóiĐộ phủ màu NTSC 45% Độ sáng 300nits'),
  ('laptop-asus-expertbook-p1-p1403cva-c5h16-63ws','laptop','CPS_6AD99369EBF0CEB0','Độ phân giải màn hình','1920 x 1080 pixels (FullHD)'),
  ('laptop-asus-expertbook-p1-p1403cva-c5h16-63ws','laptop','CPS_FF1CEE74414621D8','Pin','63WHrs, 3S1P, 3-cell Li-ion'),
  ('laptop-asus-expertbook-p1-p1403cva-c5h16-63ws','laptop','CPS_1920C4F3BE935FFE','Cổng giao tiếp','2 x USB 3.2 Gen 1 Type-A 2 x USB 3.2 Gen 2 Type-C (hỗ trợ xuất hình & cấp nguồn) 1 x HDMI 1.4 1 x Jack tai nghe / micro 3.5 mm 1 x Cổng mạng RJ45 Gigabit Ethernet'),
  ('tai-nghe-bluetooth-anker-soundcore-p40i','tai-nghe','CPS_56DBA02965141ACB','Trọng lượng','58g'),
  ('tai-nghe-bluetooth-anker-soundcore-p40i','tai-nghe','CPS_4859174E5E91AC3D','Công nghệ âm thanh','Chống ồn chủ động ANC'),
  ('tai-nghe-bluetooth-anker-soundcore-p40i','tai-nghe','CPS_4153614ADB5EF479','Micro','Có6 micro'),
  ('tai-nghe-bluetooth-anker-soundcore-p40i','tai-nghe','CPS_FA83102CD4F784CA','Thời lượng sử dụng Pin','Tai nghe: Dùng 12 giờHộp sạc: 60 giờ'),
  ('tai-nghe-bluetooth-anker-soundcore-p40i','tai-nghe','CPS_49C173CC48EF8262','Phương thức điều khiển','Cảm ứng chạm'),
  ('tai-nghe-bluetooth-anker-soundcore-p40i','tai-nghe','CPS_99BDC054DB0A8AE5','Tính năng khác','Sạc nhanh Chống nước IPX5');
INSERT INTO "ThuocTinhDanhMuc" ("MaPhanLoai","KyHieu","TenThuocTinh","KieuDuLieu","ThuTu")
SELECT DISTINCT p."MaPhanLoai",c.code,c.label,'CHU',500 FROM "CpsThongSo" c JOIN "PhanLoai" p ON p."DuongDan"=c.category ON CONFLICT ("MaPhanLoai","KyHieu") DO NOTHING;
INSERT INTO "GiaTriThuocTinhBienThe" ("MaBienThe","MaSanPham","MaPhanLoai","MaThuocTinh","KieuDuLieu","GiaTriChu")
SELECT b."MaBienThe",s."MaSanPham",s."MaPhanLoai",t."MaThuocTinh",'CHU',c.value FROM "CpsThongSo" c JOIN "SanPham" s ON s."DuongDan"=c.slug JOIN "BienTheSanPham" b ON b."MaSanPham"=s."MaSanPham" AND b."MaHang"='CPS-'||upper(c.slug) JOIN "ThuocTinhDanhMuc" t ON t."MaPhanLoai"=s."MaPhanLoai" AND t."KyHieu"=c.code AND t."KieuDuLieu"='CHU' ON CONFLICT ("MaBienThe","MaThuocTinh") DO NOTHING;
