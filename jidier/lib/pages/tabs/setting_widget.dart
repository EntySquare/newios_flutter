import 'package:flutter/material.dart';
import 'package:myflutter/pages/util/SharedPreferencesUtil.dart';
import 'package:myflutter/pages/util/SystemUtil.dart';
import 'package:package_info/package_info.dart';

/*设置界面*/
class SettingWidget extends StatefulWidget {
  SettingWidget({Key key}) : super(key: key);

  @override
  _SettingWidgetState createState() => _SettingWidgetState();
}

class _SettingWidgetState extends State<SettingWidget> {
  String vesonNumber = '';
  int soundState = 0;

  @override
  Widget build(BuildContext context) {
    SystemUtil.getPackageInfo().then((PackageInfo packageInfo) {
      setState(() {
        this.vesonNumber = packageInfo.version;
      });
    });
    SharedPreferencesUtil.getSoundState().then((state) {
      if (state != null) {
        setState(() {
          soundState = state;
        });
      }
    });
    return Scaffold(
      appBar: PreferredSize(
          child: AppBar(
            title: Text(
              "设置",
              style: TextStyle(color: Colors.white, fontSize: 18.0),
            ),
            backgroundColor: Color(0xff00afaf),
            centerTitle: true,
          ),
          preferredSize: Size.fromHeight(40.0)),
      body: Container(
        color: Color(0xffeeeeee),
        child: Padding(
          padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                child: Container(
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Image.asset(
                          "images/ic_system_notice.png",
                          width: 30.0,
                          height: 30.0,
                        ),
                        Container(
                          width: 5.0,
                        ),
                        Text(
                          "声音",
                          style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        Expanded(
                          child: Container(),
                          flex: 1,
                        ),
                        Checkbox(
                          value: soundState == 0 ? true : false,
                          onChanged: (state) {
                            if (state) {
                              SharedPreferencesUtil.saveOpenSound(0);
                              setState(() {
                                soundState = 0;
                              });
                            } else {
                              SharedPreferencesUtil.saveOpenSound(1);
                              setState(() {
                                soundState = 1;
                              });
                            }
                          },
                          activeColor: Colors.red,
                        ),
                        Text(
                          soundState == 0 ? "关闭" : "打开",
                          style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                child: Container(
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Image.asset(
                          "images/ico_version.png",
                          width: 30.0,
                          height: 30.0,
                        ),
                        Container(
                          width: 5.0,
                        ),
                        Text(
                          "系统当前版本",
                          style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        Expanded(
                          child: Container(),
                          flex: 1,
                        ),
                        Text(
                          vesonNumber,
                          style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.red,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
