//import 'package:amap_location/amap_location.dart';
import 'package:amap_map_fluttify/amap_map_fluttify.dart';
import 'package:amap_location_fluttify/amap_location_fluttify.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myflutter/pages/bean/LoginBean.dart';
import 'package:myflutter/pages/router/Router.dart';
import 'package:myflutter/pages/tabs/AddressListWidget.dart';
import 'package:myflutter/pages/tabs/LocationWidget.dart';
import 'package:myflutter/pages/util/ContactsUtil.dart';
import 'package:myflutter/pages/util/HttpContent.dart';
import 'package:myflutter/pages/util/LoginUtil.dart';

Future<void> main() async {
  runApp(MyApp());
  await enableFluttifyLog(false);
  await AmapService.instance.init(
      iosKey: '30451939c0a123dfb05d9ae6b7c00b1f',
      androidKey: 'c409d30dd9625529f6317632d8c48dff');

}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  static const platform = const MethodChannel("jidier");

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Color(0xff00afaf), //or set color with: Color(0xFF0000FF)
    ));
    ContactsUtil.getContacts(); //获得联系人

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: myBottomBarWidget(),
      onGenerateRoute: onGenerateRoute, //命名路由设置
    );
  }
}

class myBottomBarWidget extends StatefulWidget {
  myBottomBarWidget({Key key}) : super(key: key);

  _myBottomBarWidgetState createState() => _myBottomBarWidgetState();
}

class _myBottomBarWidgetState extends State<myBottomBarWidget>
    with WidgetsBindingObserver {
  int _currentIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    // super.didChangeAppLifecycleState(state);
    print("---" + state.toString());
    switch (state) {
      case AppLifecycleState.inactive: //处于这种状态的应用程序应该假设他们可能再任何时候暂停
        break;
      case AppLifecycleState.resumed: //应用程序可见，前台
        // TODO: Handle this case.
        break;
      case AppLifecycleState.paused: //应用程序不可见，后台
        // TODO: Handle this case.
        _netUploadLunchNum();
        break;
      //case AppLifecycleState.suspending: //申请将暂时暂停
      // TODO: Handle this case.
      // break;
    }
  }

  /*用户打开手机次数上报*/
  void _netUploadLunchNum() async {
    LoginBean loginBean = await LoginUtil.getLoginBean();
    try {
      Response response = await Dio().post(url + 'setUsersTodayCount',
          data: {},
          options: Options(headers: {"AUTHORIZATION": loginBean.token}));
      String res = response.toString();
      print(res);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> tabsWidget = List<Widget>();

    tabsWidget.add(LocationWidget(
      mm: (value) {
        if (value == 1) {
          //state为1的时候,表示要切换到地址列表界面
          setState(() {
            this._currentIndex = 1;
          });
        }
      },
    ));
    tabsWidget.add(AddressListWidget());
    if (_currentIndex == 0) {
      if (LocationWidget.locationWidgetState != null) {
        LocationWidget.locationWidgetState.updateData();
      }
    }

    // TODO: implement build
    return Scaffold(
      appBar: null,
      body: tabsWidget[this._currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: this._currentIndex,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.location_on),
              title: Text(
                "定位",
                style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
              )),
          BottomNavigationBarItem(
              icon: Icon(Icons.list),
              title: Text(
                "地址记录",
                style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
              ))
        ],
        onTap: (int index) {
          LoginUtil.ifLogin(login: (LoginBean loginBean) {
            setState(() {
              this._currentIndex = index;
            });
          }, unLogin: (LoginBean loginBean) {
            setState(() {
              this._currentIndex = 0;
            });

            Navigator.pushNamed(context, "/login");
          });
        },
        fixedColor: Color(0xff00afaf),
        unselectedItemColor: Color(0xff000000),
      ),
    );
  }
}
