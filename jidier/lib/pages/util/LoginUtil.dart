import 'package:myflutter/pages/bean/LoginBean.dart';
import 'package:myflutter/pages/util/NetUtil.dart';
import 'package:myflutter/pages/util/SharedPreferencesUtil.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LoginUtil {
  static Future SavaLogininfo(String content) async {
    await SharedPreferencesUtil.saveString("Login", content);
  }

  static Future<LoginBean> getLoginBean() async {
    String loginResult = await SharedPreferencesUtil.getString("Login");
    LoginBean loginBean;
    if (loginResult == null || loginResult == "") {
      loginBean = new LoginBean();
      loginBean.ifLogin = false;
    } else {
      loginBean = LoginBean.fromJson(getBean(loginResult));
    }
    return loginBean;
  }

  static ifLogin({login, unLogin}) async {
    String loginInfo = await SharedPreferencesUtil.getString("Login");

    if (loginInfo == null || loginInfo == "") {
      LoginBean loginBean = new LoginBean();

      unLogin(loginBean);
    } else {
      LoginBean loginBean = LoginBean.fromJson(getBean(loginInfo));
      if (loginBean.ifLogin) {
        login(loginBean);
      } else {
        unLogin(loginBean);
      }
    }
  }

  static getBean(String loginInfo) {
    var map = jsonDecode(loginInfo);
    return map;
  }
}
