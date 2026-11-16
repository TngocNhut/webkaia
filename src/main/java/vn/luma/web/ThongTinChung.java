package vn.luma.web;
import java.security.Principal;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;
@ControllerAdvice
public class ThongTinChung {
 private final vn.luma.business.GioHangService carts; private final vn.luma.business.CauHinhHeThongService settings;
 public ThongTinChung(vn.luma.business.GioHangService carts,vn.luma.business.CauHinhHeThongService settings){this.carts=carts;this.settings=settings;}
 @ModelAttribute("soLuongGio") public int soLuongGio(Principal user,jakarta.servlet.http.HttpSession session){return carts.dem(user==null?null:user.getName(),GioHangController.guest(session));}
 @ModelAttribute("thongTinFooter") public CauHinhHeThongYeuCau thongTinFooter(){return settings.hienTai();}
 @Value("${app.support.email:}") private String supportEmail;
 @ModelAttribute("daDangNhap") public boolean daDangNhap(Principal user){return user!=null;}
 @ModelAttribute("emailHoTro") public String emailHoTro(){return supportEmail;}
}
