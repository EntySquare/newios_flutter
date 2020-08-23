import 'package:myflutter/pages/bean/ItemPlanWayBean.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../main.dart';
import 'package:myflutter/pages/util/Toast.dart';

/*偏好设置类*/
class SharedPreferencesUtil {
  /*储存数据*/
  static saveString(String key, String content) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(key, content);
  }

  static saveInt(String key, int content) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setInt(key, content);
  }

  static Future<int> getInt(String key) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    int loginInfo = sharedPreferences.getInt(key);
    // print(loginInfo);
    return loginInfo;
  }

  /**
   * 获取存在SharedPreferences中的数据
   */
  static Future<String> getString(String key) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    String loginInfo = sharedPreferences.getString(key);
    // print(loginInfo);
    return loginInfo;
  }

  /*保存导航历史记录*/
  static saveNavigationHistory(String address, String lat, String lng) async {
    List list = await getNavigationHistory();
    if (list.length != 0) {
      var first = list[0];
      String firstAddress = first["address"];
      if (address == firstAddress) {
        return list;
      }
    }

    Map map = Map<String, String>();
    map["address"] = address;
    map["lat"] = lat;
    map["lng"] = lng;

    if (list.length == 50) {
      list.removeLast();
      list.insert(0, map);
    } else {
      list.insert(0, map);
    }

    String result = jsonEncode(list);
    saveString("navigationHistory", result);
  }

  /*获得导航历史记录列表*/
  static Future<List> getNavigationHistory() async {
    List resultList = List();
    String result = await getString("navigationHistory");
    if (result == null || result == "") {
      resultList = List();
    } else {
      resultList = jsonDecode(result);
    }
    return resultList;
  }

  /*保存临时规划路径*/
  static savePlanWay(context, String address, String lat, String lng) async {
    List list = await getPlanWay();
    list = list == null ? List() : list;
    bool flag = false;
    for (Map map in list) {
      String mylat = map["lat"];
      String mylng = map["lng"];
      if (lat == mylat && lng == mylng) {
        flag = true;
        break;
      }
    }

    if (flag) {
      Toast.toast(context, msg: "请不要添加重复地址");
      return;
    }

    Map map = Map<String, String>();
    map["address"] = address;
    map["lat"] = lat;
    map["lng"] = lng;

    if (list.length == 50) {
      list.removeLast();
      list.insert(0, map);
    } else {
      list.insert(0, map);
    }

    String result = jsonEncode(list);
    saveString("planWay", result);
    Toast.toast(context, msg: "成功！");
  }

  /*删除规划路径*/
  static deletPlanWay(context, ItemPlanWayBean itemPlanWayBean) async {
    List list = await getPlanWay();
    list = list == null ? List() : list;
    for (Map map in list) {
      String mylat = map["lat"];
      String mylng = map["lng"];
      if (itemPlanWayBean.address == map["address"] &&
          itemPlanWayBean.lat == mylat &&
          itemPlanWayBean.lng == mylng) {
        list.remove(map);
        break;
      }
    }

    String result = jsonEncode(list);
    saveString("planWay", result);
  }

  /*删除所有规划路径点*/
  static deletAllPlanWay(context) async {
    List list = List();
    String result = jsonEncode(list);
    saveString("planWay", result);
  }

  /*获得临时规划路径*/
  static Future<List> getPlanWay() async {
    List resultList = List();
    String result = await getString("planWay");
    if (result == null || result == "") {
      resultList = List();
    } else {
      resultList = jsonDecode(result);
    }
    return resultList;
  }

  /*保存规划路径历史*/
  static saveHistoryPlanWay(List<Map> maps) async {
    List<List<Map>> list = await getHistoryPlanWay();
    list = list == null ? List<List<Map>>() : list;
    if (list.length > 50) {
      list.removeAt(49);
      list.insert(0, maps);
    } else {
      list.insert(0, maps);
    }
    String result = jsonEncode(list);
    saveString("historyplanway", result);
  }

  /*获得历史规划路径*/
  static Future<List<List<Map>>> getHistoryPlanWay() async {
    List<List<Map>> resultList = List<List<Map>>();
    String result = await getString("historyplanway");
    if (result == null || result == "") {
      resultList = List<List<Map>>();
    } else {
      var myResult = jsonDecode(result);
      for (var item in myResult) {
        List<Map> maps = List<Map>();
        for (var inItem in item) {
          Map map = Map();
          map['address'] = inItem['address'];
          map['lat'] = inItem['lat'];
          map['lng'] = inItem['lng'];
          map['ifStart'] = inItem['ifStart'];
          map['ifEnd'] = inItem['ifEnd'];
          map['beTweenSpace'] = inItem['beTweenSpace'];
          maps.add(map);
        }
        resultList.add(maps);
      }
    }
    return resultList;
  }

  /*保存是否打开声音开关,state 0 关闭声音 1打开声音*/
  static saveOpenSound(int state) async {
    saveInt("sound", state);
  }

  static Future<int> getSoundState() async {
    int state = await getInt("sound");
    return state;
  }
}
