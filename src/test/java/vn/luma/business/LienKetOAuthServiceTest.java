package vn.luma.business;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

import java.time.Instant;
import java.util.Optional;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.security.crypto.password.PasswordEncoder;
import vn.luma.data.LienKetOAuthDAO;
import vn.luma.data.QuanLySanPhamDAO;
import vn.luma.data.TaiKhoanDAO;
import vn.luma.model.TaiKhoan;

class LienKetOAuthServiceTest {
    private LienKetOAuthDAO links;
    private TaiKhoanDAO accounts;
    private TaiKhoanService users;
    private LienKetOAuthService service;

    @BeforeEach void setUp() {
        links=mock(LienKetOAuthDAO.class);accounts=mock(TaiKhoanDAO.class);users=mock(TaiKhoanService.class);
        service=new LienKetOAuthService(links,accounts,users,mock(PasswordEncoder.class),mock(QuanLySanPhamDAO.class));
    }
    private LienKetOAuthService.DanhTinh identity(String provider,String email) {
        return new LienKetOAuthService.DanhTinh(provider,"provider-id",email,Instant.now().plusSeconds(60));
    }
    @Test void googleRequiresVerifiedEmail() {
        assertTrue(service.taoGoogleMoi(identity("GOOGLE","test@example.com"),"Test",false).isEmpty());
        verifyNoInteractions(accounts,links);
    }
    @Test void existingEmailIsNeverAutomaticallyLinked() {
        when(accounts.tim("existing@example.com")).thenReturn(Optional.of(mock(TaiKhoan.class)));
        assertTrue(service.taoFacebookMoi(identity("FACEBOOK","existing@example.com"),"Test").isEmpty());
        verify(links,never()).gan(anyLong(),anyString(),anyString());
        verify(accounts,never()).tao(anyString(),anyString(),any(),anyString(),anyBoolean());
    }
    @Test void facebookCreatesCustomerWithoutClaimingEmailVerified() {
        var account=mock(TaiKhoan.class);
        when(accounts.tao("Test","new@example.com",null,"KhachHang",false)).thenReturn(42L);
        when(users.hienTai("new@example.com")).thenReturn(account);
        assertSame(account,service.taoFacebookMoi(identity("FACEBOOK","new@example.com"),"Test").orElseThrow());
        verify(links).gan(42L,"FACEBOOK","provider-id");
    }
    @Test void facebookWithoutEmailDoesNotCreateAccount() {
        assertTrue(service.taoFacebookMoi(identity("FACEBOOK",""),"Test").isEmpty());
        verifyNoInteractions(accounts,links);
    }
}
