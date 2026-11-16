-- Thông tin tham khảo: ảnh từ Nothing; giá từ nhà bán lẻ tại thời điểm đối chiếu.
-- Không có tồn kho mẫu: tránh tạo giao dịch dựa trên giá hoặc hàng chưa xác nhận.
DO $seed$
DECLARE r record; category_id bigint; brand_id bigint; product_id bigint; sku_id bigint;
BEGIN
 SELECT "MaPhanLoai" INTO category_id FROM "PhanLoai" WHERE "DuongDan"='dien-thoai';
 IF category_id IS NULL THEN RAISE EXCEPTION 'Thiếu danh mục điện thoại'; END IF;
 INSERT INTO "ThuongHieu" ("TenThuongHieu","DuongDan","DangHienThi","NgayCapNhat") VALUES ('Nothing','nothing',true,now()) ON CONFLICT ("DuongDan") DO NOTHING;
 SELECT "MaThuongHieu" INTO brand_id FROM "ThuongHieu" WHERE "DuongDan"='nothing';
 FOR r IN SELECT * FROM (VALUES
  ('Nothing Phone (4a)','nothing-phone-4a','Trắng',8,128,11990000,'phone-4a.png','https://www.thegioididong.com/tin-tuc/su-kien-ra-mat-nothing-phone-4a-4a-pro-4b-tai-viet-nam-1597428'),
  ('Nothing Phone (4a) Pro','nothing-phone-4a-pro','Hồng',12,256,15990000,'phone-4a-pro.png','https://www.thegioididong.com/tin-tuc/su-kien-ra-mat-nothing-phone-4a-4a-pro-4b-tai-viet-nam-1597428'),
  ('Nothing Phone (4b)','nothing-phone-4b','Xanh dương',8,128,9090000,'phone-4b.webp','https://www.thegioididong.com/dtdd/nothing-phone-4b-8gb-128gb'),
  ('Nothing Phone (3)','nothing-phone-3','Trắng',12,256,24399000,'phone-3.png','https://www.viettablet.com/nothing-phone-3'),
  ('Nothing Phone (3a) Pro','nothing-phone-3a-pro','Xám',12,256,9499000,'phone-3a-pro.png','https://www.viettablet.com/nothing-phone-3a-pro'),
  ('Nothing Phone (2a)','nothing-phone-2a','Trắng',8,128,7190000,'phone-2a.png','https://cellphones.com.vn/mobile/nothing-phone.html'),
  ('Nothing Phone (2a) Plus','nothing-phone-2a-plus','Xám',12,256,7990000,'phone-2a-plus.png','https://www.91mobiles.com/vn/bang-gia-dien-thoai-nothing')
 ) AS v(ten,slug,mau,ram,luu_tru,gia,anh,nguon_gia) LOOP
   product_id := NULL;
   INSERT INTO "SanPham" ("MaPhanLoai","MaThuongHieu","TenSanPham","DuongDan","TenTimKiem","MoTaNgan","MoTaChiTiet","SoThangBaoHanh","ThongSoChung","DuongDanNguon","NgayThuThap","LaDuLieuMau","DangHienThi","NgayCapNhat")
   VALUES (category_id,brand_id,r.ten,r.slug,lower(r.ten),'Dữ liệu tham khảo, giá có thể thay đổi. Hiện chưa xác nhận tồn kho.', 'Giá tham khảo từ nguồn tại thời điểm đối chiếu; hình minh họa từ nhà sản xuất. Không biểu thị hàng đang sẵn bán.',0,'{}'::jsonb,r.nguon_gia,current_date,true,true,now())
   ON CONFLICT ("DuongDan") DO NOTHING RETURNING "MaSanPham" INTO product_id;
   IF product_id IS NULL THEN CONTINUE; END IF;
   INSERT INTO "BienTheSanPham" ("MaSanPham","MaHang","TenBienThe","MauSac","BoXuLy","BoXuLyDoHoa","DungLuongRam","DungLuongLuuTru","KichThuocManHinh","HeDieuHanh","ThongSoBoSung","GiaNiemYet","GiaBan","GiaVon","DangKinhDoanh","NgayCapNhat")
   VALUES (product_id,'KAIA-'||upper(r.slug),r.ram||' GB / '||r.luu_tru||' GB · '||r.mau,r.mau,'Chưa cập nhật','',r.ram,r.luu_tru,0,'Android','{}'::jsonb,r.gia,r.gia,0,true,now()) RETURNING "MaBienThe" INTO sku_id;
   INSERT INTO "TonKho" ("MaKhoHang","MaBienThe","SoLuongTon","SoLuongGiu","NgayCapNhat") VALUES (1,sku_id,0,0,now()) ON CONFLICT DO NOTHING;
   INSERT INTO "TepSanPham" ("MaSanPham","MaBienThe","LoaiTep","DuongDanTep","MoTaThayThe","ThuTu","DuongDanNguon","ThongTinSuDung","NgayCapNhat") VALUES (product_id,sku_id,'ANH','/media/nothing/'||r.anh,r.ten||' · '||r.mau,0,'https://intl.nothing.tech/collections/phones','Ảnh tham khảo từ nhà sản xuất Nothing.',now());
 END LOOP;
 -- Ẩn khỏi các danh sách; không xóa sản phẩm, phiên bản hoặc lịch sử đơn.
 UPDATE "ThuongHieu" SET "DangHienThi"=false,"NgayCapNhat"=now() WHERE "DuongDan"='tecno';
END $seed$;
