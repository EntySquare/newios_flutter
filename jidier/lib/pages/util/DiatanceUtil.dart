import 'dart:math' as Math;

class DiatanceUtil {
  static final double EATH_RADTUS = 6378.137;
  static final double PI = 3.1415926535897932;

  static double rad() {
    return PI / 180.0;
  }

  static double getDistance(double longitude1, double latitude1,
      double longitude2, double latitude2) {
//    longitude1=_let15To14(longitude1);
//    latitude1=_let15To14(latitude1);
//    longitude2=_let15To14(longitude2);
//    latitude2=_let15To14(latitude2);
    double dLat = (latitude1 - latitude2) * rad();
    double dlon = (longitude1 - longitude2) * rad();
    latitude1 = latitude1 * rad();
    latitude2 = latitude2 * rad();
    double sin1 = Math.sin(dLat / 2);
    double sin2 = Math.sin(dlon / 2);
    double a =
        sin1 * sin1 + sin2 * sin2 * Math.cos(latitude1) * Math.cos(latitude2);
    double distance =
        EATH_RADTUS * 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
    distance = formatNum(distance, 2);
    return distance;
  }

  static double formatNum(double num, int postion) {
    String result = "";
    if ((num.toString().length - num.toString().lastIndexOf(".") - 1) <
        postion) {
      //小数点后有几位小数
      result = num.toStringAsFixed(postion)
          .substring(0, num.toString().lastIndexOf(".") + postion + 1)
          .toString();
    } else {
      result = num.toString()
          .substring(0, num.toString().lastIndexOf(".") + postion + 1)
          .toString();
    }
    return double.parse(result);
  }

  /*将小数15位变更14位 四舍五入*/
  static double _let15To14(double data) {
    String strData = data.toString();
    List<String> splits = strData.split('.');
    if (splits[1].length < 15) {
      return data;
    } else {
      data = data + 0.000000000000005;
      splits = data.toString().split('.');
      String startStr = splits[0];
      String endStr = splits[1];
      endStr = endStr.substring(0, 14);
      data = double.parse("$startStr.$endStr");

      return data;
    }
  }
}
