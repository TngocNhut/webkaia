package vn.luma.web;

import static org.junit.jupiter.api.Assertions.*;
import java.math.BigDecimal;
import java.util.List;
import java.util.Map;
import org.junit.jupiter.api.Test;
import vn.luma.model.BienThe;

class LuaChonBienTheTest {
    private BienThe variant(long id,String name,String color,int storage){
        return new BienThe(id,"Máy","may","sku-"+id,name,color,"Chip","GPU",8,storage,
            new BigDecimal("6.1"),"OS",BigDecimal.TEN,BigDecimal.TEN,BigDecimal.ZERO,5,0,true,BigDecimal.TEN,null);
    }
    @Test void groupsVersionsAndKeepsColorAndSkuTogether(){
        var black=variant(1,"8 GB / 256 GB · Đen","Đen",256);
        var pink=variant(2,"8GB/256GB · Hồng","Hồng",256);
        var black512=variant(3,"8GB/512GB · Đen","Đen",512);
        var pink512=variant(4,"8 GB / 512 GB · Hồng","Hồng",512);
        var result=LuaChonBienThe.tao(List.of(black,pink,black512,pink512),pink,Map.of(2L,"/pink.png"));
        assertEquals(2,result.versions().size());assertEquals(2,result.colors().size());
        assertEquals(4,result.versions().get(1).id());
        assertTrue(result.colors().get(1).selected());assertEquals("/pink.png",result.colors().get(1).image());
    }
    @Test void colorOnlyVariantsHaveAReadableDefaultVersion(){
        var v=variant(1,"Đen","Đen",256);
        assertEquals("8 GB / 256 GB",LuaChonBienThe.tao(List.of(v),v,Map.of()).versions().get(0).label());
    }
}
