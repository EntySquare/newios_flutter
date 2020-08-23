import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';

class DataUtil {
  static String mcMsg="";

  static String intDataToString(int times) {
    DateTime date = new DateTime.fromMillisecondsSinceEpoch(times * 1000);

    return formatDate(date, [yyyy, '-', mm, '-', dd,"\t\t",hh,":",mm,":",ss]);
  }

  /** 返回当前时间戳 */
  static int currentTimeMillis() {
    return new DateTime.now().millisecondsSinceEpoch;
  }


}