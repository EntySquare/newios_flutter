import 'dart:convert';
import "package:myflutter/pages/util/HttpContent.dart";
class StringUtil {
  static String getQrJsonStr(Map map) {
    String strMap = json.encode(map);

    strMap = strMap.replaceAll("{", "%7B");
    strMap = strMap.replaceAll("}", "%7D");
    strMap = strMap.replaceAll("\"", "%22");
    strMap = strMap.replaceAll(":", "%3A");
    strMap = "$QR_URL/openapp?id=" + strMap;
    return strMap;
  }

  static String getScanResultStr(String data) {
    data = data.replaceAll("%7B", "{");
    data = data.replaceAll("%7D", "}");
    data = data.replaceAll("%22", "\"");
    data = data.replaceAll("%3A", ":");
    data= data.replaceAll("$QR_URL/openapp?id=", "");
    return data;
  }
  static String getWeakResultStr(String data){

    data = data.replaceAll("%7B", "{");
    data = data.replaceAll("%7D", "}");
    data = data.replaceAll("%22", "\"");
    data = data.replaceAll("%3A", ":");
    data= data.replaceAll("id=", "");
    return data;
  }

}
