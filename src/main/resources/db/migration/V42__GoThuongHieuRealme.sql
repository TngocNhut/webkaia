-- Preserve historical references when a product is already used in orders or other records.
DO $remove_realme$
DECLARE product record; brand_id bigint;
BEGIN
 SELECT "MaThuongHieu" INTO brand_id FROM "ThuongHieu" WHERE "DuongDan"='realme';
 IF brand_id IS NULL THEN RETURN; END IF;
 FOR product IN SELECT "MaSanPham" FROM "SanPham" WHERE "MaThuongHieu"=brand_id LOOP
  BEGIN
   DELETE FROM "GiaTriThuocTinhBienThe" WHERE "MaSanPham"=product."MaSanPham";
   DELETE FROM "TepSanPham" WHERE "MaSanPham"=product."MaSanPham";
   DELETE FROM "TonKho" WHERE "MaBienThe" IN (SELECT "MaBienThe" FROM "BienTheSanPham" WHERE "MaSanPham"=product."MaSanPham");
   DELETE FROM "BienTheSanPham" WHERE "MaSanPham"=product."MaSanPham";
   DELETE FROM "SanPham" WHERE "MaSanPham"=product."MaSanPham";
  EXCEPTION WHEN foreign_key_violation THEN
   UPDATE "SanPham" SET "DangHienThi"=false WHERE "MaSanPham"=product."MaSanPham";
  END;
 END LOOP;
 BEGIN
  DELETE FROM "DongSanPham" WHERE "MaThuongHieu"=brand_id;
  DELETE FROM "ThuongHieu" WHERE "MaThuongHieu"=brand_id;
 EXCEPTION WHEN foreign_key_violation THEN
  UPDATE "ThuongHieu" SET "DangHienThi"=false WHERE "MaThuongHieu"=brand_id;
 END;
END $remove_realme$;
