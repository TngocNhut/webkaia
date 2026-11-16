-- Xiaomi: giá và ảnh tham khảo từ cửa hàng chính thức; tồn kho chưa xác nhận.
DO $seed$
DECLARE r record; category_id bigint; brand_id bigint; product_id bigint; sku_id bigint;
BEGIN
 SELECT "MaPhanLoai" INTO category_id FROM "PhanLoai" WHERE "DuongDan"='dien-thoai';
 SELECT "MaThuongHieu" INTO brand_id FROM "ThuongHieu" WHERE "DuongDan"='xiaomi';
 IF category_id IS NULL OR brand_id IS NULL THEN RAISE EXCEPTION 'Thiếu danh mục hoặc thương hiệu Xiaomi'; END IF;
 FOR r IN SELECT * FROM (VALUES
  ('REDMI A7 Pro','redmi-a7-pro',3990000,'redmi-a7-pro.png','https://www.mi.com/vn/product/redmi-a7-pro/'),
  ('POCO X8 Pro','poco-x8-pro',9490000,'poco-x8-pro.png','https://www.mi.com/vn/product/poco-x8-pro/'),
  ('Xiaomi 17','xiaomi-17',21190000,'xiaomi-17.png','https://www.mi.com/vn/product/xiaomi-17/'),
  ('POCO M8 5G','poco-m8-5g',6590000,'poco-m8-5g.png','https://www.mi.com/vn/product/poco-m8-5g/'),
  ('POCO C85','poco-c85',3890000,'poco-c85.png','https://www.mi.com/vn/product/poco-c85/')
 ) AS v(ten,slug,gia,anh,nguon) LOOP
   product_id := NULL;
   INSERT INTO "SanPham" ("MaPhanLoai","MaThuongHieu","TenSanPham","DuongDan","TenTimKiem","MoTaNgan","MoTaChiTiet","SoThangBaoHanh","ThongSoChung","DuongDanNguon","NgayThuThap","LaDuLieuMau","DangHienThi","NgayCapNhat")
   VALUES (category_id,brand_id,r.ten,r.slug,lower(r.ten)||' xiaomi','Giá và ảnh tham khảo từ Xiaomi. Chưa xác nhận tồn kho hoặc cấu hình.','Giá được ghi nhận từ danh mục Xiaomi Việt Nam và có thể thay đổi theo phiên bản, thời điểm và ưu đãi.',0,'{}'::jsonb,r.nguon,current_date,true,true,now())
   ON CONFLICT ("DuongDan") DO NOTHING RETURNING "MaSanPham" INTO product_id;
   IF product_id IS NULL THEN CONTINUE; END IF;
   INSERT INTO "BienTheSanPham" ("MaSanPham","MaHang","TenBienThe","MauSac","BoXuLy","BoXuLyDoHoa","DungLuongRam","DungLuongLuuTru","KichThuocManHinh","HeDieuHanh","ThongSoBoSung","GiaNiemYet","GiaBan","GiaVon","DangKinhDoanh","NgayCapNhat")
   VALUES (product_id,'KAIA-'||upper(r.slug),'Phiên bản tham khảo','Chưa cập nhật','Chưa cập nhật','',0,0,0,'Android','{}'::jsonb,r.gia,r.gia,0,true,now()) RETURNING "MaBienThe" INTO sku_id;
   INSERT INTO "TonKho" ("MaKhoHang","MaBienThe","SoLuongTon","SoLuongGiu","NgayCapNhat") VALUES (1,sku_id,0,0,now()) ON CONFLICT DO NOTHING;
   INSERT INTO "TepSanPham" ("MaSanPham","MaBienThe","LoaiTep","DuongDanTep","MoTaThayThe","ThuTu","DuongDanNguon","ThongTinSuDung","NgayCapNhat") VALUES (product_id,sku_id,'ANH','/media/xiaomi/'||r.anh,r.ten||' · ảnh tham khảo',0,r.nguon,'Ảnh tham khảo từ Xiaomi Việt Nam.',now());
 END LOOP;
END $seed$;
