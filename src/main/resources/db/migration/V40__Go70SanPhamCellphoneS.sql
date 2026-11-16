-- Undo only the demo products introduced by V39; preserve products referenced by other records.
DO $revoke$
DECLARE p record;
BEGIN
 FOR p IN SELECT s."MaSanPham" FROM "SanPham" s JOIN "BienTheSanPham" b USING ("MaSanPham")
 WHERE s."DuongDan" IN (
  'iphone-15-256gb',
  'dien-thoai-samsung-galaxy-a56',
  'dien-thoai-samsung-galaxy-a17-5g',
  'dien-thoai-samsung-galaxy-a07',
  'dien-thoai-samsung-galaxy-z-fold-8-512gb',
  'dien-thoai-samsung-galaxy-z-fold-7',
  'dien-thoai-xiaomi-15-ultra-1tb',
  'dien-thoai-xiaomi-redmi-note-15-pro-5g',
  'dien-thoai-xiaomi-redmi-note-15-5g',
  'dien-thoai-xiaomi-redmi-17-5g',
  'dien-thoai-oppo-reno15-f',
  'dien-thoai-oppo-reno14',
  'dien-thoai-oppo-a6c',
  'dien-thoai-oppo-a6c-4gb-128gb',
  'dien-thoai-oppo-a6t',
  'dien-thoai-honor-x7d-8gb-128gb',
  'dien-thoai-honor-x9d-8gb-256gb',
  'dien-thoai-honor-x9d',
  'dien-thoai-honor-400-5g',
  'dien-thoai-honor-x7d-5g-8gb-256gb',
  'dien-thoai-honor-400-5g-12gb-512gb',
  'dien-thoai-honor-play-10-4gb-128gb',
  'macbook-air-13-m5-10-cpu-8-gpu-16gb-512gb',
  'macbook-air-15-m5-10-cpu-10-gpu-24gb-512gb-sac-70w',
  'macbook-air-13-m5-10-cpu-10-gpu-16gb-1tb',
  'macbook-pro-14-inch-m5-16gb-1tb',
  'macbook-air-15-m5-10-cpu-10-gpu-16gb-512gb-sac-70w',
  'macbook-pro-m4-pro-14-inch-14cpu-20gpu-24gb-512gb-nano',
  'macbook-pro-16-m5-max-18cpu-40-gpu-48gb-2tb',
  'laptop-asus-zenbook-a16-ux3607oa-sq137ws-snapdragon-x2-elite',
  'laptop-asus-tuf-gaming-a15-fa506ncg-hn329w',
  'laptop-asus-vivobook-go-15-e1504fa-bq5943w',
  'laptop-asus-vivobook-14-x1404va-eb609w',
  'laptop-asus-tuf-gaming-a15-fa506ncg-hn390w',
  'laptop-asus-rog-strix-g16-g614ph-ts118w',
  'laptop-asus-expertbook-p3-pm3406cha-ly0089w',
  'laptop-asus-vivobook-s16-s3607ca-sh080w',
  'laptop-acer-gaming-nitro-lite-16-nl16-71g-71uj',
  'laptop-acer-gaming-nitro-propanel-anv15-52-50rb',
  'laptop-acer-gaming-nitro-v-15-propanel-anv15-52-50va',
  'laptop-acer-swift-air-14-sfa14-i31-55nr',
  'laptop-acer-aspire-lite-15-al15-53p-56ec',
  'tai-nghe-anker-soundcore-aeroclip-2',
  'tai-nghe-khong-day-anker-soundcore-liberty-5-pro',
  'tai-nghe-khong-day-anker-soundcore-r50i-a3949',
  'tai-nghe-khong-day-anker-soundcore-r50i-nc',
  'tai-nghe-bluetooth-anker-soundcore-c50i',
  'tai-nghe-khong-day-anker-soundcore-k20i-a3994',
  'tai-nghe-khong-day-anker-soundcore-liberty-5',
  'tai-nghe-bluetooth-anker-soundcore-liberty-4',
  'iphone-16-plus',
  'dien-thoai-samsung-galaxy-a07-5g',
  'dien-thoai-samsung-galaxy-s26-ultra-12gb-512gb',
  'dien-thoai-samsung-galaxy-s26-plus',
  'dien-thoai-samsung-galaxy-s26-12gb-512gb',
  'dien-thoai-samsung-galaxy-s25-edge',
  'dien-thoai-samsung-galaxy-s25-ultra-512gb',
  'dien-thoai-samsung-galaxy-s26-plus-12gb-512gb',
  'chuot-gaming-khong-day-asus-rog-strix-impact-iii-wl',
  'chuot-khong-day-bluetooth-logitech-m196',
  'chuot-gaming-co-day-asus-tuf-m3-gen-2',
  'chuot-khong-day-rapoo-m330',
  'chuot-khong-day-rapoo-mt760m-mini',
  'chuot-khong-day-dareu-lm106g',
  'chuot-gaming-khong-day-mchose-g3-v2-tri-mode',
  'chuot-khong-day-lenovo-thinkpad-essential',
  'chuot-khong-day-ugreen-silent-mu006',
  'chuot-khong-day-dareu-lm115g',
  'chuot-gaming-khong-day-logitech-g304-x-superlight',
  'chuot-gaming-logitech-pro-x-superlight-2-lightspeed'
 ) AND s."LaDuLieuMau" AND b."MaHang"='CPS-'||upper(s."DuongDan") LOOP
  BEGIN
   IF (SELECT count(*) FROM "BienTheSanPham" WHERE "MaSanPham"=p."MaSanPham") <> 1 THEN
     UPDATE "SanPham" SET "DangHienThi"=false WHERE "MaSanPham"=p."MaSanPham";
     CONTINUE;
   END IF;
   DELETE FROM "GiaTriThuocTinhBienThe" WHERE "MaSanPham"=p."MaSanPham";
   DELETE FROM "TepSanPham" WHERE "MaSanPham"=p."MaSanPham";
   DELETE FROM "TonKho" WHERE "MaBienThe" IN (SELECT "MaBienThe" FROM "BienTheSanPham" WHERE "MaSanPham"=p."MaSanPham");
   DELETE FROM "BienTheSanPham" WHERE "MaSanPham"=p."MaSanPham";
   DELETE FROM "SanPham" WHERE "MaSanPham"=p."MaSanPham";
  EXCEPTION WHEN foreign_key_violation THEN
   UPDATE "SanPham" SET "DangHienThi"=false WHERE "MaSanPham"=p."MaSanPham";
  END;
 END LOOP;
END $revoke$;
