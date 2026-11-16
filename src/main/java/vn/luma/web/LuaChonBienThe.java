package vn.luma.web;

import java.text.Normalizer;
import java.util.*;
import java.util.regex.Pattern;
import vn.luma.model.BienThe;

/** Groups only variants with the same configuration; a color always links to its actual SKU. */
public final class LuaChonBienThe {
    public record Option(long id,String label,boolean selected,String image) { }
    public record Result(List<Option> versions,List<Option> colors) { }
    private LuaChonBienThe() { }

    private static String clean(String text){return text==null?"":text.strip();}
    private static String key(String text){return Normalizer.normalize(clean(text),Normalizer.Form.NFD).replaceAll("\\p{M}","").replace('đ','d').replace('Đ','D').toLowerCase(Locale.ROOT).replaceAll("[^a-z0-9]","");}
    private static String label(BienThe v){
        String label=clean(v.tenBienThe()),color=clean(v.mauSac());
        if(!color.isEmpty())label=Pattern.compile(Pattern.quote(color),Pattern.CASE_INSENSITIVE|Pattern.UNICODE_CASE).matcher(label).replaceFirst("");
        label=label.replaceAll("^[\\s·,;:/|–—-]+|[\\s·,;:/|–—-]+$","");
        if(label.isBlank()&&v.dungLuongRam()>0)label=v.dungLuongRam()+" GB / "+v.dungLuongLuuTru()+" GB";
        return label.isBlank()?"Tiêu chuẩn":label;
    }
    private static String group(BienThe v){return key(label(v))+"|"+v.dungLuongRam()+"|"+v.dungLuongLuuTru()+"|"+key(v.boXuLy());}
    public static Result tao(List<BienThe> variants,BienThe selected,Map<Long,String> images){
        var groups=new LinkedHashMap<String,List<BienThe>>();
        for(var v:variants)groups.computeIfAbsent(group(v),k->new ArrayList<>()).add(v);
        String active=group(selected);var versions=new ArrayList<Option>();
        for(var entry:groups.entrySet()){
            var sameColor=entry.getValue().stream().filter(v->key(v.mauSac()).equals(key(selected.mauSac()))).findFirst();
            var target=sameColor.orElseGet(()->entry.getValue().stream().filter(v->v.tonKhaDung()>0).findFirst().orElse(entry.getValue().get(0)));
            versions.add(new Option(target.maBienThe(),label(target),entry.getKey().equals(active),null));
        }
        var colors=new ArrayList<Option>();
        for(var v:groups.get(active))colors.add(new Option(v.maBienThe(),clean(v.mauSac()).isBlank()?"Mặc định":v.mauSac(),v.maBienThe()==selected.maBienThe(),images.get(v.maBienThe())));
        return new Result(List.copyOf(versions),List.copyOf(colors));
    }
}
