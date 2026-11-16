ALTER TABLE "CauHinhHeThong" DROP CONSTRAINT "CauHinhHeThong_check";
ALTER TABLE "CauHinhHeThong" ADD CONSTRAINT "CauHinhHeThong_check" CHECK (CASE "KyHieu"
 WHEN 'BAT_CHATBOT' THEN jsonb_typeof("GiaTri") = 'boolean'
 WHEN 'PHI_GIAO_HANG_MAC_DINH' THEN CASE WHEN jsonb_typeof("GiaTri") = 'number' THEN ("GiaTri" #>> '{}')::numeric BETWEEN 0 AND 10000000 AND ("GiaTri" #>> '{}')::numeric = trunc(("GiaTri" #>> '{}')::numeric) ELSE false END
 WHEN 'THONG_BAO_TRANG_CHU' THEN jsonb_typeof("GiaTri") = 'string' AND char_length("GiaTri" #>> '{}') <= 300
 WHEN 'FOOTER_SLOGAN' THEN jsonb_typeof("GiaTri") = 'string' AND char_length("GiaTri" #>> '{}') BETWEEN 1 AND 120
 WHEN 'FOOTER_DIA_CHI' THEN jsonb_typeof("GiaTri") = 'string' AND char_length("GiaTri" #>> '{}') BETWEEN 1 AND 300
 WHEN 'FOOTER_LIEN_HE' THEN jsonb_typeof("GiaTri") = 'string' AND char_length("GiaTri" #>> '{}') BETWEEN 1 AND 30
 ELSE false END);
