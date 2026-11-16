package vn.luma.business;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;
import java.math.BigDecimal;
import java.util.Map;
import java.util.UUID;
import org.junit.jupiter.api.Test;
import vn.luma.config.ThanhToanCauHinh;
import vn.luma.data.*;
import vn.luma.model.TaiKhoan;
import vn.luma.web.DatHangYeuCau;

class MuaNgayTest {
    @Test void quoteValidatesSelectedStockAndNeverReadsOrChangesCart(){
        var orders=mock(DonHangDAO.class);var carts=mock(GioHangDAO.class);var accounts=mock(TaiKhoanService.class);var promotions=mock(KhuyenMaiDAO.class);var user=mock(TaiKhoan.class);
        when(accounts.hienTai("buyer@example.com")).thenReturn(user);when(user.maNguoiDung()).thenReturn(1L);
        when(orders.khoaSku(7L)).thenReturn(Map.of("SoLuongTon",5,"SoLuongGiu",1,"cho_mua",true));
        when(promotions.gia(anyCollection())).thenReturn(Map.of(7L,new KhuyenMaiDAO.Gia(7L,new BigDecimal("100000"),new BigDecimal("100000"),null,null,true)));
        when(orders.phiGiao()).thenReturn(new BigDecimal("30000"));
        var service=new DonHangService(orders,carts,mock(TaiKhoanDAO.class),accounts,mock(ThanhToanDAO.class),mock(ThanhToanCauHinh.class),promotions,mock(ThongBaoService.class),mock(DiaChiDAO.class));
        var request=new DatHangYeuCau(UUID.randomUUID().toString(),"7:2","",null,"COD");
        assertEquals(new BigDecimal("230000"),service.baoGia("buyer@example.com",request,true).tongThanhToan());
        verifyNoInteractions(carts);
        var tooMany=new DatHangYeuCau(UUID.randomUUID().toString(),"7:5","",null,"COD");
        assertThrows(IllegalArgumentException.class,()->service.baoGia("buyer@example.com",tooMany,true));
        verifyNoInteractions(carts);
    }
}
