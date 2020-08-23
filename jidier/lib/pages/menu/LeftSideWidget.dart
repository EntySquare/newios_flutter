/*左边侧滑菜单*/
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:myflutter/pages/bean/LoginBean.dart';
import 'package:myflutter/pages/bean/ResponseBean2.dart';
import 'package:myflutter/pages/util/HttpContent.dart';
import 'package:myflutter/pages/util/LoginUtil.dart';
import 'package:myflutter/pages/util/NetUtil.dart';
import 'package:myflutter/pages/util/SharedPreferencesUtil.dart';
import 'package:myflutter/pages/util/Toast.dart';
import 'dart:convert';
import 'package:myflutter/pages/dialog/NetLoadingDialog.dart';
import 'package:myflutter/pages/dialog/login_out_dialog.dart';

class LeftSideWidget extends StatefulWidget {
  String phone = "";
  Function jump;

  LeftSideWidget({Key key, this.phone, this.jump}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState

    return _leftSideWidgetState(phone, jump);
  }
}

class _leftSideWidgetState extends State<LeftSideWidget> {
  String _phone = "";
  Function _jump;
  int messageNum = 0;

  _leftSideWidgetState(String phone, Function jump) {
    _jump = jump;
  }

  @override
  Future initState() {
    // TODO: implement initState
    super.initState();
    LoginUtil.getLoginBean().then((LoginBean loginBean) {
      String phone = loginBean.phone;

      if (phone == null || phone == "") {
        setState(() {
          this._phone = "";
        });
      } else {
        setState(() {
          this._phone = phone.replaceRange(3, 7, "****");
        });
      }
    });

    LoginUtil.ifLogin(
        login: (LoginBean loginBean) {},
        unLogin: (LoginBean loginBean) {
          Navigator.pushNamed(context, '/login');
        });

    _netGetMessageNum();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: <Widget>[
          Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(0.0, 80.0, 0.0, 0.0),
                child: Container(
                  width: 60.0,
                  height: 60.0,
                  child: Image.asset(
                    "images/ic_head_blue.png",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                height: 10.0,
              ),
              Text(
                this._phone,
                style: TextStyle(
                    color: Color(0xff009688),
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          Divider(
            height: 20.0,
          ),
          Container(
            //height: 50.0,
            alignment: Alignment.center,
            child: ListTile(
              leading: Image.asset(
                "images/ic_blue_message.png",
                width: 25.0,
                height: 25.0,
              ),
              title: Text(
                "消息",
                style: TextStyle(fontSize: 16.0, color: Color(0xff333333)),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: Container(
                width: 80.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Visibility(
                      child: Container(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                          child: Text(
                            '$messageNum',
                            style: TextStyle(
                                fontSize: 10.0,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10.0)),
                      ),
                      visible: messageNum == 0 ? false : true,
                    ),
                    Icon(Icons.arrow_forward, color: Color(0xff00afaf))
                  ],
                ),
              ),
              onTap: () {
                Navigator.pushNamed(context, '/messageWidget').then((state) {
                  _netGetMessageNum();
                });
              },
            ),
          ),
          Container(
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
              child: ListTile(
                leading: Image.asset(
                  "images/address_record1.png",
                  width: 35.0,
                  height: 35.0,
                  fit: BoxFit.cover,
                ),
                title: Text(
                  "导航历史记录",
                  style: TextStyle(fontSize: 16.0, color: Color(0xff333333)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Icon(Icons.arrow_forward, color: Color(0xff00afaf)),
                onTap: () {
                  Navigator.pushNamed(context, '/navigationHistory')
                      .then((state) {
                    _jump(state);
                  });
                },
              ),
            ),
          ),
          Container(
            //height: 50.0,
            alignment: Alignment.center,
            child: ListTile(
              leading: Image.asset(
                "images/ico_history_plan.png",
                width: 25.0,
                height: 25.0,
              ),
              title: Text(
                "历史规划路径",
                style: TextStyle(fontSize: 16.0, color: Color(0xff333333)),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: Icon(Icons.arrow_forward, color: Color(0xff00afaf)),
              onTap: () {
                //点击查看添加点信息
                SharedPreferencesUtil.getHistoryPlanWay().then((historyData) {
                  Navigator.pushNamed(context, '/historyPlanWayWidget',
                      arguments: historyData);
                });
              },
            ),
          ),
          Container(
            //height: 50.0,
            alignment: Alignment.center,
            child: ListTile(
              leading: Image.asset(
                "images/ic_time_out.png",
                width: 25.0,
                height: 25.0,
              ),
              title: Text(
                "修改密码",
                style: TextStyle(fontSize: 16.0, color: Color(0xff333333)),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: Icon(Icons.arrow_forward, color: Color(0xff00afaf)),
              onTap: () {
                LoginUtil.ifLogin(login: (LoginBean loginBean) {
                  Navigator.pushNamed(context, '/changePassword');
                }, unLogin: (LoginBean loginBean) {
                  Navigator.pushNamed(context, '/login');
                });
              },
            ),
          ),
          Container(
            //height: 50.0,
            alignment: Alignment.center,
            child: ListTile(
              leading: Image.asset(
                "images/ico_setting.png",
                width: 25.0,
                height: 25.0,
              ),
              title: Text(
                "设置",
                style: TextStyle(fontSize: 16.0, color: Color(0xff333333)),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: Icon(Icons.arrow_forward, color: Color(0xff00afaf)),
              onTap: () {
                Navigator.pushNamed(context, '/settingWidget');
              },
            ),
          ),
          Container(
            height: 60.0,
          ),
          RaisedButton(
            child: Text(
              "退出登录",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            color: Color(0xff00afaf),
            shape: RoundedRectangleBorder(
                side: BorderSide.none, borderRadius: BorderRadius.circular(10)),
            onPressed: () {
              showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) {
                    return LoginOutDialog(() {
                      Navigator.pop(context);

                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (_) {
                            return NetLoadingDialog(
                              requestCallBack: LoginUtil.ifLogin(
                                  login: (LoginBean loginBean) {
                                loginBean.ifLogin = false;
                                loginBean.token = '';
                                String loginInfo = json.encode(loginBean);
                                LoginUtil.SavaLogininfo(loginInfo).then((_) {
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  Navigator.pushNamed(context, '/login');
                                });
                              }, unLogin: (LoginBean loginBean) {
                                Navigator.pop(context);
                                Toast.toast(context, msg: "你并没登录!");
                              }),
                              outsideDismiss: false,
                              loadingText: "退出登录中...",
                            );
                          });
                    });
                  });
            },
          ),
        ],
      ),
    );
  }

  _netGetMessageNum() async {
    LoginBean loginBean = await LoginUtil.getLoginBean();
    try {
      Response response = await Dio().post(url + 'getNoReadAlert',
          data: {'phone': loginBean.phone},
          options: Options(headers: {"AUTHORIZATION": loginBean.token}));
      NetUtil.ifNetSuccessful(response, successfull: (ResponseBean2 result) {
        Map map = result.responseData;
        int number = map['countMessage'];
        //return number;
        setState(() {
          this.messageNum = number;
        });
      }, faild: (result) {});
    } catch (e) {
      print(e);
    }
  }
}
