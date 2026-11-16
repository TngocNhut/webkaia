package vn.luma.business;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;
import java.math.BigDecimal;
import java.util.Map;
import java.util.Optional;
import org.junit.jupiter.api.Test;
import vn.luma.data.TaiKhoanDAO;
import vn.luma.data.TheoDoiDAO;
import vn.luma.model.TaiKhoan;

class TheoDoiYeuThichTest {
    @Test void addingFavoriteDoesNotEnableOrCreateNotifications(){
        var dao=mock(TheoDoiDAO.class);var users=mock(TaiKhoanService.class);var accounts=mock(TaiKhoanDAO.class);var notifications=mock(ThongBaoService.class);var account=mock(TaiKhoan.class);
        when(users.hienTai("buyer@example.com")).thenReturn(account);when(account.maNguoiDung()).thenReturn(2L);
        var state=Map.<String,Object>of("gia",BigDecimal.TEN,"co_hang",true);
        when(dao.tinhTrang(5L)).thenReturn(state);when(dao.phienBanHopLe(5L,8L)).thenReturn(true);
        var service=new TheoDoiService(dao,users,accounts,notifications);
        assertTrue(service.batTatYeuThich("buyer@example.com",5L,8L));
        verify(dao).luu(2L,5L,false,false,state,8L);verifyNoInteractions(notifications);
    }
    @Test void removingFavoriteDoesNotCreateNotifications(){
        var dao=mock(TheoDoiDAO.class);var users=mock(TaiKhoanService.class);var accounts=mock(TaiKhoanDAO.class);var notifications=mock(ThongBaoService.class);var account=mock(TaiKhoan.class);
        when(users.hienTai("buyer@example.com")).thenReturn(account);when(account.maNguoiDung()).thenReturn(2L);
        when(dao.cuaToi(2L,5L)).thenReturn(Optional.of(Map.of("id",5L)));
        assertFalse(new TheoDoiService(dao,users,accounts,notifications).batTatYeuThich("buyer@example.com",5L,8L));
        verify(dao).xoa(2L,5L);verifyNoInteractions(notifications);
    }
}
