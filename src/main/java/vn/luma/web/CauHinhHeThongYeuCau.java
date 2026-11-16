package vn.luma.web;
import java.math.BigDecimal;
import jakarta.validation.constraints.*;
public record CauHinhHeThongYeuCau(boolean batChatbot,@NotNull @DecimalMin("0") @DecimalMax("10000000") @Digits(integer=8,fraction=0) BigDecimal phiGiaoHang,@NotNull @Size(max=300) String thongBao,@NotBlank @Size(max=120) String slogan,@NotBlank @Size(max=300) String diaChi,@NotBlank @Size(max=30) String soLienHe) { }
