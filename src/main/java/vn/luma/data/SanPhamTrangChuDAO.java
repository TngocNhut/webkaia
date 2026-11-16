package vn.luma.data;

import java.util.List;
import java.util.Map;
import org.springframework.jdbc.core.simple.JdbcClient;
import org.springframework.stereotype.Repository;

@Repository
public class SanPhamTrangChuDAO {
    private final JdbcClient jdbc;
    public SanPhamTrangChuDAO(JdbcClient jdbc){this.jdbc=jdbc;}
    public List<Map<String,Object>> tuongTu(long product,long sku){
        return jdbc.sql("""
            WITH hien_tai AS (
              SELECT s."MaPhanLoai",s."MaThuongHieu",s."MaDongSanPham",b."DungLuongRam",b."DungLuongLuuTru",b."BoXuLy",g."GiaHieuLuc" AS gia
              FROM "SanPham" s JOIN "BienTheSanPham" b USING("MaSanPham") JOIN "GiaKhuyenMaiBienThe" g USING("MaBienThe")
              WHERE s."MaSanPham"=:product AND b."MaBienThe"=:sku
            )
            SELECT s."TenSanPham" AS ten,s."DuongDan" AS slug,h."TenThuongHieu" AS hang,chon.gia,chon.sku,
              (SELECT t."DuongDanTep" FROM "TepSanPham" t WHERE t."MaSanPham"=s."MaSanPham" AND t."LoaiTep"='ANH' AND t."DangHienThi" AND (t."MaBienThe"=chon.sku OR t."MaBienThe" IS NULL) ORDER BY CASE WHEN t."MaBienThe"=chon.sku THEN 0 ELSE 1 END,t."ThuTu",t."MaTep" LIMIT 1) AS anh
            FROM hien_tai cur JOIN "SanPham" s ON s."MaPhanLoai"=cur."MaPhanLoai" AND s."MaSanPham"<>:product
            JOIN "PhanLoai" p ON p."MaPhanLoai"=s."MaPhanLoai" JOIN "ThuongHieu" h ON h."MaThuongHieu"=s."MaThuongHieu"
            JOIN LATERAL (
              SELECT b."MaBienThe" AS sku,g."GiaHieuLuc" AS gia,b."DungLuongRam" AS ram,b."DungLuongLuuTru" AS luu_tru,b."BoXuLy" AS cpu
              FROM "BienTheSanPham" b JOIN "GiaKhuyenMaiBienThe" g USING("MaBienThe")
              WHERE b."MaSanPham"=s."MaSanPham" AND b."DangKinhDoanh"
              ORDER BY abs(g."GiaHieuLuc"-cur.gia),abs(b."DungLuongRam"-cur."DungLuongRam"),abs(b."DungLuongLuuTru"-cur."DungLuongLuuTru"),b."MaBienThe" LIMIT 1
            ) chon ON true
            WHERE s."DangHienThi" AND p."DangHienThi" AND h."DangHienThi"
            ORDER BY (s."MaThuongHieu"=cur."MaThuongHieu") DESC,
                     (cur."MaDongSanPham" IS NOT NULL AND s."MaDongSanPham"=cur."MaDongSanPham") DESC NULLS LAST,
                     abs(chon.gia-cur.gia),abs(chon.ram-cur."DungLuongRam"),abs(chon.luu_tru-cur."DungLuongLuuTru"),
                     (nullif(chon.cpu,'')=nullif(cur."BoXuLy",'')) DESC NULLS LAST,s."MaSanPham" DESC LIMIT 8
            """).param("product",product).param("sku",sku).query().listOfRows();
    }
    public List<Map<String,Object>> lay(boolean banChay){
        String first=banChay?"chuot-ban-phim":"dien-thoai";
        String second=banChay?"dien-thoai":"laptop";
        String order=banChay?"sold DESC, ngay_tao DESC, ma DESC":"ngay_tao DESC, ma DESC";
        return jdbc.sql("""
            WITH san_pham AS (
              SELECT s."MaSanPham" AS ma,s."TenSanPham" AS ten,s."DuongDan" AS slug,h."TenThuongHieu" AS hang,p."DuongDan" AS loai,s."NgayTao" AS ngay_tao,
                     min(g."GiaHieuLuc") AS gia,
                     (SELECT t."DuongDanTep" FROM "TepSanPham" t WHERE t."MaSanPham"=s."MaSanPham" AND t."LoaiTep"='ANH' AND t."DangHienThi" ORDER BY t."ThuTu",t."MaTep" LIMIT 1) AS anh,
                     coalesce((SELECT sum(c."SoLuong") FROM "ChiTietDonHang" c JOIN "DonHang" d USING ("MaDonHang") JOIN "BienTheSanPham" sold_sku ON sold_sku."MaBienThe"=c."MaBienThe" WHERE sold_sku."MaSanPham"=s."MaSanPham" AND d."TrangThaiDon"='HOAN_THANH'),0) AS sold
              FROM "SanPham" s JOIN "PhanLoai" p USING ("MaPhanLoai") JOIN "ThuongHieu" h USING ("MaThuongHieu")
              JOIN "BienTheSanPham" b USING ("MaSanPham") JOIN "GiaKhuyenMaiBienThe" g USING ("MaBienThe")
              WHERE s."DangHienThi" AND p."DangHienThi" AND h."DangHienThi" AND b."DangKinhDoanh" AND p."DuongDan" IN (:first,:second)
              GROUP BY s."MaSanPham",h."TenThuongHieu",p."DuongDan"
            ), xep_hang AS (
              SELECT *,row_number() OVER(PARTITION BY loai ORDER BY %s) AS hang_nhom FROM san_pham
            )
            SELECT ten,slug,hang,gia,anh,sold FROM xep_hang WHERE hang_nhom<=5
            ORDER BY CASE WHEN loai=:first THEN 0 ELSE 1 END,hang_nhom
            """.formatted(order)).param("first",first).param("second",second).query().listOfRows();
    }
}
