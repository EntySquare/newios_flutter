/*登录界面*/

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myflutter/pages/bean/JumpRegistetBean.dart';
import 'package:myflutter/pages/bean/LoginBean.dart';
import 'package:myflutter/pages/bean/RegisterResult.dart';
import 'package:myflutter/pages/bean/ResponseBean.dart';
import 'package:myflutter/pages/bean/UserBean.dart';
import 'package:myflutter/pages/dialog/NetLoadingDialog.dart';
import 'package:myflutter/pages/util/BlankToolBarModel.dart';
import 'package:myflutter/pages/util/HttpContent.dart';
import 'package:myflutter/pages/util/LoginUtil.dart';
import 'package:myflutter/pages/util/NetUtil.dart';
import 'package:myflutter/pages/util/Toast.dart';
import 'package:myflutter/pages/util/DataUtil.dart';

class LoginWidget extends StatefulWidget {
  String content = "";

  LoginWidget({Key key, this.content}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _loginWidgetState(content);
  }
}

class _loginWidgetState extends State<LoginWidget> {
  bool ifShowPassword = true;
  String wrongNotice = "";
  String phone = "";
  String password = "";
  String _content = "";

  // Step1: 响应空白处的焦点的Node
  BlankToolBarModel blankToolBarModel = BlankToolBarModel();

  _loginWidgetState(content) {
    this._content = content;
    LoginUtil.ifLogin(login: (LoginBean loginBean) {
      setState(() {
        this.phone = loginBean.phone;
      });
    }, unLogin: (LoginBean loginBean) {
      String inPhone = loginBean.phone;
      if (inPhone == null || inPhone == "") {
        setState(() {
          this.phone = "";
        });
      } else {
        setState(() {
          this.phone = loginBean.phone;
        });
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState

    blankToolBarModel.outSideCallback = focusNodeChange;
    super.initState();
  }

// Step2.2: 焦点变化时的响应操作
  void focusNodeChange() {
    setState(() {});
  }

  @override
  void dispose() {
    // TODO: implement dispose
    blankToolBarModel.removeFocusListeners();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: PreferredSize(
            child: AppBar(
              title: Text(
                "登录",
                style: TextStyle(color: Colors.white, fontSize: 18.0),
              ),
              backgroundColor: Color(0xff00afaf),
              centerTitle: true,
            ),
            preferredSize: Size.fromHeight(40.0)),
        body: BlankToolBarTool.blankToolBarWidget(context,
            model: blankToolBarModel, body: getContentWidget(context)));
  }

  Widget getContentWidget(context) {
    return Container(
      alignment: Alignment.center,
      color: Colors.white,
      child: ListView(
        children: <Widget>[
          Container(
            height: 20.0,
          ),
          Container(
            child: Image.asset(
              "images/ic_foot_step.png",
              fit: BoxFit.cover,
              width: 140.0,
            ),
            alignment: Alignment.center,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
            child: Text(
              wrongNotice,
              style: TextStyle(color: Colors.red, fontSize: 14.0),
            ),
          ),
          Padding(
              padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0),
              child: TextField(
                autofocus: false,
                decoration: InputDecoration(
                    hintText: "请输入手机号码",
                    icon: Image.asset(
                      "images/ic_phone.png",
                      width: 20.0,
                      height: 20.0,
                      fit: BoxFit.cover,
                    ),
                    isDense: true,
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xff00afaf))),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xff00afaf)))),
                keyboardType: TextInputType.phone,
                cursorColor: Color(0xff00afaf),
                maxLength: 11,
                maxLines: 1,
                onChanged: (text) {
                  // print(text);
                  phone = text;
                },
                controller: TextEditingController.fromValue(TextEditingValue(
                    text: this.phone,
                    selection: TextSelection.fromPosition(TextPosition(
                        affinity: TextAffinity.downstream,
                        offset: this.phone.length)))),
              )),
          Padding(
            padding: EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
            child: TextField(
              autofocus: false,
              decoration: InputDecoration(
                hintText: '请输入密码',
                isDense: true,
                icon: Image.asset(
                  "images/ic_password.png",
                  width: 25.0,
                  height: 25.0,
                  fit: BoxFit.cover,
                ),
                suffixIcon: IconButton(
                    icon: Image.asset(
                      ifShowPassword
                          ? "images/ic_hide_pwd_gray.png"
                          : "images/ic_show_pwd_gray.png",
                      width: 20.0,
                      fit: BoxFit.cover,
                    ),
                    onPressed: () {
                      if (ifShowPassword) {
                        setState(() {
                          ifShowPassword = false;
                        });
                      } else {
                        setState(() {
                          ifShowPassword = true;
                        });
                      }
                    }),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xff00afaf))),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xff00afaf))),
              ),
              obscureText: ifShowPassword,
              cursorColor: Color(0xff00afaf),
              onChanged: (text) {
                //print(text);
                password = text;
              },
              maxLength: 8,
              maxLines: 1,
              controller: TextEditingController.fromValue(
                TextEditingValue(
                    text: this.password,
                    selection: TextSelection.fromPosition(TextPosition(
                        affinity: TextAffinity.downstream,
                        offset: this.password.length))),
              ),
            ),
          ),
          Container(
            height: 20.0,
          ),
          Row(
            children: <Widget>[
              Container(
                width: 40.0,
              ),
              Expanded(
                  flex: 1,
                  child: Container(
                    height: 40.0,
                    child: RaisedButton(
                        child: Text(
                          "登录",
                          style: TextStyle(color: Colors.white, fontSize: 16.0),
                        ),
                        color: Color(0xff00afaf),
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0))),
                        onPressed: () {
                          _login(phone, password);
                        }),
                  )),
              Container(
                width: 40.0,
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  GestureDetector(
                    child: Text(
                      "还没有账号,",
                      style:
                          TextStyle(color: Color(0xff333333), fontSize: 14.0),
                    ),
                  ),
                  GestureDetector(
                    child: Text(
                      "去注册",
                      style:
                          TextStyle(color: Color(0xff00afaf), fontSize: 14.0),
                    ),
                    onTap: () {
                      // print("去注册");
                      _jumpRegisterWidget(phone);
                    },
                  ),
                  Container(
                    width: 30.0,
                  ),
                  GestureDetector(
                    child: Text(
                      "忘记密码?",
                      style:
                          TextStyle(color: Color(0xff00afaf), fontSize: 14.0),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onTap: () {
                      // print("忘记密码");
                      _jumpForgetPasswordWidget(phone);
                    },
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 0),
            child: Container(
              alignment: Alignment.center,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      child: Text('登录即视为同意',
                          style: TextStyle(
                              fontSize: 14.0, color: Color(0xff333333))),
                    ),
                    GestureDetector(
                      child: Text('记地儿用户协议,',
                          style: TextStyle(
                              color: Color(0xff13227a), fontSize: 14.0)),
                      onTap: () {
                        // print('跳转到用户协议界面');
                        _jumpProtocolWidget(0);
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(5.0, 0, 0, 0),
                      child: GestureDetector(
                        child: Text(
                          '隐私政策',
                          style: TextStyle(
                              color: Color(0xff13227a), fontSize: 14.0),
                        ),
                        onTap: () {
                          //print('跳转到隐私政策');
                          _jumpProtocolWidget(1);
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void _login(String phone, String password) {
    if (phone.isEmpty) {
      setState(() {
        wrongNotice = "电话号码不能为空";
      });
      return null;
    }
    if (phone.length < 11) {
      setState(() {
        wrongNotice = "电话号码必须为11位";
      });
      return null;
    }
    if (password.isEmpty) {
      setState(() {
        wrongNotice = "密码不能为空";
      });
      return null;
    }
    setState(() {
      wrongNotice = "";
    });

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return new NetLoadingDialog(
            requestCallBack: _netLogin(),
            outsideDismiss: false,
            loadingText: "登录中...",
          );
        });
  }

  _netLogin() async {
    try {
      Response response = await Dio().post(url + 'getToken',
          data: {"phone": phone, "pwd": password},
          options: Options(
              headers: {"AUTHORIZATION": "myjidiertokenmessage123456"}));

      NetUtil.ifNetSuccessful(response, successfull: (ResponseBean bean) async {
        LoginBean loginBean = NetUtil.getLoginBean(response.toString());
        loginBean.ifLogin = true;
        loginBean.token = loginBean.data.responseData;

        _netUser(loginBean);
      }, faild: (ResponseBean bean) {
        Navigator.pop(context);
        setState(() {
          wrongNotice = bean.data.responseText;
        });
      });
    } catch (e) {
      print(e);
      Navigator.pop(context);
      setState(() {
        wrongNotice = "网络请求异常,请检查网络连接";
      });
    }
  }

  /*登录成功请求 获取用户信息*/
  _netUser(LoginBean loginBean) async {
    try {
      Response response = await Dio().get(url + "users",
          queryParameters: {},
          options: Options(headers: {"AUTHORIZATION": loginBean.token}));
      NetUtil.ifNetSuccessful(response, successfull: (ResponseBean bean) async {
        UserBean userBean = NetUtil.getUserBean(response.toString());
        var userData = userBean.data.responseData;
        loginBean.id = userData.id;
        loginBean.pwd = userData.pwd;
        loginBean.nick = userData.nick;
        loginBean.phone = userData.phone;
        loginBean.times = userData.times;
        loginBean.score = userData.score;
        loginBean.idnumber = userData.idnumber;
        loginBean.openid = userData.openid;
         LoginUtil.SavaLogininfo(json.encode(loginBean));
        Toast.toast(context, msg: "登录成功....", position: ToastPostion.center);
         //Navigator.pop(context);
        if (this._content == "") {
           Navigator.popAndPushNamed(context,'/');
        } else {
          //Navigator.pop(context, this._content);
         // Navigator.popUntil(context, ModalRoute.withName('/'));
          DataUtil.mcMsg=this._content;
          Navigator.popAndPushNamed(context,'/');
        }
      }, faild: (ResponseBean bean) async {
        Navigator.pop(context);
        setState(() {
          wrongNotice = bean.data.responseText;
        });
      });
    } catch (e) {
      Navigator.pop(context);
      print(e);
      setState(() {
        wrongNotice = "网络请求异常,请检查网络连接";
      });
    }
  }

/*跳转到用户协议界面  state 0 表示用户协议,1 表示隐私政策 */
  _jumpProtocolWidget(int state) {
    Navigator.pushNamed(context, '/protocol', arguments: state);
  }

  _jumpRegisterWidget(var parames) {
    Navigator.pushNamed(context, '/register',
            arguments: JumpRegistetBean(phone))
        .then((result) {
      if (result != null) {
        RegisterResult myResult = result;
        setState(() {
          this.phone = myResult.phone;
          this.password = myResult.password;
        });
        _login(phone, password);
      }
    });
  }

  _jumpForgetPasswordWidget(var parames) async {
    Navigator.pushNamed(context, '/forget', arguments: JumpRegistetBean(phone))
        .then((result) {
      if (result != null) {
        RegisterResult myResult = result;
        setState(() {
          this.phone = myResult.phone;
          this.password = myResult.password;
        });
        _login(phone, password);
      }
    });
  }
}
