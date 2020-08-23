import 'package:flutter/cupertino.dart';
import 'package:package_info/package_info.dart';

class SystemUtil {
  static PackageInfo packageInfo;

  static Size getScreenSize(context) {
    return MediaQuery.of(context).size;
  }

  static Future<PackageInfo> getPackageInfo() async {
    if (packageInfo == null) {
      packageInfo = await PackageInfo.fromPlatform();
      return packageInfo;
    } else {
      return packageInfo;
    }
  }

  static DateTime lastPopTime;

  //是否市快速点击
  static bool iffaskClick() {
    if (lastPopTime == null ||
        DateTime.now().difference(lastPopTime) > Duration(seconds: 2)) {
      return false;
    } else {
      lastPopTime = DateTime.now();
      return true; //是快速点击
    }
  }
}
