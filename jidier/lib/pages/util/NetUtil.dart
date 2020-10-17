import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:myflutter/pages/bean/AdressDataBean.dart';
import 'package:myflutter/pages/bean/AmbitusAdressBean.dart';
import 'package:myflutter/pages/bean/FindAdrBean.dart';
import 'package:myflutter/pages/bean/ImageBean.dart';
import 'package:myflutter/pages/bean/LoginBean.dart';
import 'package:myflutter/pages/bean/QrInfoBean.dart';
import 'package:myflutter/pages/bean/ResponseBean.dart';
import 'package:myflutter/pages/bean/ResponseBean2.dart';
import 'package:myflutter/pages/bean/UserBean.dart';
import 'package:myflutter/pages/bean/MessageBean.dart';

class NetUtil {
  static getBean(String json) {
    var map = jsonDecode(json);
    return map;
  }

  static LoginBean getLoginBean(String json) {
    return LoginBean.fromJson(getBean(json));
  }

  static ResponseBean getResponseBean(String json) {
    return ResponseBean.fromJson(getBean(json));
  }

  static UserBean getUserBean(String json) {
    return UserBean.fromJson(getBean(json));
  }

  static getAdressDataBean(String json) {
    return AdressDataBean.fromJson(getBean(json));
  }

  static getAmbitusAdressBean(String json) {
    return AmbitusAdreesBean.fromJson(getBean(json));
  }

  static getImageBean(String json) {
    return ImageBean.fromJson(getBean(json));
  }

  static getQrInfoBean(String json) {
    return QrInfoBean.fromJson(getBean(json));
  }

  static getFindAdrBean(String json) {
    return FindAdrBean.fromJson(getBean(json));
  }

  static getResponseBean2(String json) {
    return ResponseBean2.fromJson(getBean(json));
  }

  static getMessageBean(String json) {
    return MessagesBean.fromJson(getBean(json));
  }

  /*判断网络是否请求成功*/
  static void ifNetSuccessful(Response response,
      {successfull, faild, context}) {
    String json = response.toString();
    if (json.contains('code')&&!(json.contains("codeId"))) {
      ResponseBean responseBean = getResponseBean(json);
      if (responseBean.code == 200 && responseBean.data.responseCode == 10000) {
        successfull(responseBean);
      } else {
        faild(responseBean);
      }
    } else {
      ResponseBean2 response2 = getResponseBean2(json);
      if (response2.responseCode == 10000) {
        successfull(response2);
      } else {
        faild(response2);
      }
    }
  }
}
