import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:myflutter/pages/bean/NowLatLng.dart';

import 'package:myflutter/pages/bean/RegisterResult.dart';
import 'package:myflutter/pages/bean/JumpRegistetBean.dart';
import 'package:flutter/services.dart';
import 'package:myflutter/pages/bean/ResponseBean.dart';
import 'package:myflutter/pages/dialog/NetLoadingDialog.dart';
import 'package:myflutter/pages/dialog/NetLoadingDialog2.dart';
import 'package:myflutter/pages/util/BlankToolBarModel.dart';
import 'package:myflutter/pages/util/RegularUtil.dart';
import 'package:mobsms/mobsms.dart';
import 'package:myflutter/pages/util/Toast.dart';
import 'package:myflutter/pages/util/NetUtil.dart';
import 'package:myflutter/pages/util/HttpContent.dart';

import '../../main.dart';

/* 注册界面*/
class RegisterWidget extends StatefulWidget {
  var parameter;

  RegisterWidget({Key key, @required this.parameter}) : super(key: key);

  @override
  _RegisterWidgetState createState() => _RegisterWidgetState(this.parameter);
}

class _RegisterWidgetState extends State<RegisterWidget> {
  JumpRegistetBean _parameter;
  bool _isShowPssword = false;
  String _strWrong = "";
  String _phone = "";
  String _identifyCode = "";
  String _firstPassword = "";
  String _secondPassword = "";
  Timer _countdownTimer;
  String _codeCountdownStr = '获取验证码';
  int _countdownNum = 59;
  BlankToolBarModel blankToolBarModel = BlankToolBarModel();

  _RegisterWidgetState(parameter) {
    this._parameter = parameter;
    this._phone = _parameter.phone;
  }

  void initState() {
    // TODO: implement initState

    blankToolBarModel.outSideCallback = focusNodeChange;
    super.initState();
  }

  void focusNodeChange() {
    setState(() {});
  }

  @override
  void dispose() {
    // TODO: implement dispose
    blankToolBarModel.removeFocusListeners();
    super.dispose();
  }

  Widget _getPhoneWidget() {
    return Column(children: <Widget>[
      Text(
        _strWrong,
        style: TextStyle(fontSize: 14.0, color: Color(0xffff0000)),
      ),
      Row(
        children: <Widget>[
          Image.asset("images/ic_phone.png",
              width: 20.0, height: 20.0, fit: BoxFit.cover),
          Container(
            width: 5.0,
          ),
          Text(
            "中国(86)",
            style: TextStyle(
                fontSize: 14.0,
                color: Colors.black,
                fontWeight: FontWeight.w700),
            maxLines: 1,
          ),
          Container(
            width: 3.0,
          ),
          Expanded(
            flex: 1,
            child: TextField(
              autofocus: true,
              decoration: InputDecoration(
                hintText: "请输入手机号码",
                hintStyle: TextStyle(fontSize: 15.0, color: Colors.grey),
                border: InputBorder.none,
                contentPadding: EdgeInsets.fromLTRB(0.0, 0, 0, 0),
                isDense: true,
              ),
              cursorColor: Color(0xff00afaf),
              style: TextStyle(fontSize: 16.0, color: Colors.black),
              onChanged: (text) {
                this._phone = text;
              },
              keyboardType: TextInputType.phone,
              inputFormatters: <TextInputFormatter>[
                LengthLimitingTextInputFormatter(11)
              ],
              maxLines: 1,
              controller: TextEditingController.fromValue(TextEditingValue(
                  text: this._phone,
                  selection: TextSelection.fromPosition(TextPosition(
                      affinity: TextAffinity.downstream,
                      offset: this._phone.length)))),
            ),
          )
        ],
        crossAxisAlignment: CrossAxisAlignment.center,
      ),
      Padding(
          padding: EdgeInsets.fromLTRB(30.0, 5.0, 0.0, 0),
          child: Container(
            height: 1.0,
            color: Color(0xff00afaf),
          )),
    ]);
  }

  /*验证码控件*/
  Widget _getIndetifyCode() {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 0.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Row(
            children: <Widget>[
              Image.asset("images/ic_identify.png",
                  width: 20.0, height: 20.0, fit: BoxFit.cover),
              Container(width: 5.0),
              Expanded(
                flex: 1,
                child: TextField(
                  autofocus: false,
                  decoration: InputDecoration(
                      hintText: "请输入四位手机短信验证码",
                      hintStyle: TextStyle(fontSize: 14.0, color: Colors.grey),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                      isDense: true),
                  cursorColor: Color(0xff00afaf),
                  inputFormatters: <TextInputFormatter>[
                    LengthLimitingTextInputFormatter(4)
                  ],
                  maxLines: 1,
                  style: TextStyle(fontSize: 15.0, color: Colors.black),
                  keyboardType: TextInputType.phone,
                  onChanged: (text) {
                    this._identifyCode = text;
                  },
                ),
              ),
              GestureDetector(
                child: Container(
                    height: 30.0,
                    child: Center(
                        child: Padding(
                      padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                      child: Text(
                        this._codeCountdownStr,
                        style: TextStyle(fontSize: 14.0, color: Colors.white),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )),
                    decoration: BoxDecoration(
                        color: Color(0xff00afaf),
                        borderRadius: BorderRadius.all(Radius.circular(10.0)))),
                onTap: () {
                  if (this._countdownNum == 59) {
                    _submitIndetifyCode();
                  }
                },
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(30.0, 5.0, 0, 0),
            child: Container(
              height: 1.0,
              color: Color(0xff00afaf),
            ),
          )
        ],
      ),
    );
  }

  /*输入第一次密码*/
  Widget _getFirstPassword() {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 0.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Row(
            children: <Widget>[
              Image.asset("images/ic_password.png",
                  width: 20.0, height: 20.0, fit: BoxFit.cover),
              Container(width: 5.0),
              Expanded(
                flex: 1,
                child: TextField(
                    autofocus: false,
                    decoration: InputDecoration(
                        hintText: "请输入密码",
                        hintStyle:
                            TextStyle(fontSize: 14.0, color: Colors.grey),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                        isDense: true),
                    cursorColor: Color(0xff00afaf),
                    inputFormatters: <TextInputFormatter>[
                      LengthLimitingTextInputFormatter(8)
                    ],
                    maxLines: 1,
                    style: TextStyle(fontSize: 15.0, color: Colors.black),
                    keyboardType: TextInputType.text,
                    onChanged: (text) {
                      this._firstPassword = text;
                    },
                    obscureText: !this._isShowPssword),
              ),
              GestureDetector(
                child: Image.asset(this._isShowPssword
                    ? "images/ic_show_pwd_gray.png"
                    : "images/ic_hide_pwd_gray.png"),
                onTap: () {
                  if (this._isShowPssword) {
                    setState(() {
                      this._isShowPssword = false;
                    });
                  } else {
                    setState(() {
                      this._isShowPssword = true;
                    });
                  }
                },
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(30.0, 5.0, 0, 0),
            child: Container(
              height: 1.0,
              color: Color(0xff00afaf),
            ),
          )
        ],
      ),
    );
  }

  /*输入第一次密码*/
  Widget _getSecondPassword() {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 0.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Row(
            children: <Widget>[
              Image.asset("images/ic_password.png",
                  width: 20.0, height: 20.0, fit: BoxFit.cover),
              Container(width: 5.0),
              Expanded(
                  flex: 1,
                  child: TextField(
                    autofocus: false,
                    decoration: InputDecoration(
                        hintText: "请再次输入密码",
                        hintStyle:
                            TextStyle(fontSize: 14.0, color: Colors.grey),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                        isDense: true),
                    cursorColor: Color(0xff00afaf),
                    inputFormatters: <TextInputFormatter>[
                      LengthLimitingTextInputFormatter(8)
                    ],
                    maxLines: 1,
                    style: TextStyle(fontSize: 15.0, color: Colors.black),
                    keyboardType: TextInputType.text,
                    onChanged: (text) {
                      this._secondPassword = text;
                    },
                    obscureText: true,
                  ))
            ],
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(30.0, 5.0, 0, 0),
            child: Container(
              height: 1.0,
              color: Color(0xff00afaf),
            ),
          )
        ],
      ),
    );
  }

  /*获取提交按钮*/
  Widget _getRegisterButton() {
    return Padding(
      padding: EdgeInsets.fromLTRB(40.0, 20.0, 30.0, 0.0),
      child: RaisedButton(
        onPressed: () {
          _submitRegister();
        },
        color: Color(0xff00afaf),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        child: Text(
          "注册",
          style: TextStyle(color: Colors.white, fontSize: 18.0),
        ),
      ),
    );
  }

  /*获取验证码点击事件*/
  void _submitIndetifyCode() {
    if (_phone.isEmpty) {
      setState(() {
        this._strWrong = "请输入手机号码";
      });

      return;
    }

    if (!RegularUtil.isChinaPhoneLegal(_phone)) {
      setState(() {
        this._strWrong = "手机号码格式不正确";
      });

      return;
    }

    setState(() {
      this._strWrong = "";
    });

    getPhoneCode(); //发送手机验证码
  }

  /*获取手机验证码*/
  void getPhoneCode() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return NetLoadingDialog(
            requestCallBack: null,
            outsideDismiss: false,
            loadingText: "发送中",
          );
        }).then((err) {
      if (err != null) {
        //获取验证码失败
        Toast.toast(context, msg: "获取验证码失败", position: ToastPostion.center);
      } else {
        reGetCountdown();
      }
    });
    sendCode();
  }

  sendCode() {
    Smssdk.getTextCode(this._phone, "86", "", (dynamic ret, Map err) {
      Navigator.pop(context, err);
    });
  }

  void reGetCountdown() {
    setState(() {
      if (_countdownTimer != null) {
        return;
      }
      // Timer的第一秒倒计时是有一点延迟的，为了立刻显示效果可以添加下一行。
      _codeCountdownStr = '${_countdownNum--}s后重新获取';
      _countdownTimer = new Timer.periodic(new Duration(seconds: 1), (timer) {
        setState(() {
          if (_countdownNum > 0) {
            _codeCountdownStr = '${_countdownNum--}s后重新获取';
          } else {
            _codeCountdownStr = '重新获取';
            _countdownNum = 59;
            _countdownTimer.cancel();
            _countdownTimer = null;
          }
        });
      });
    });
  }

  /*注册提交按钮*/
  void _submitRegister() {
    if (this._phone.isEmpty) {
      setState(() {
        this._strWrong = "请输入手机号码";
      });

      return;
    }
    if (!RegularUtil.isChinaPhoneLegal(this._phone)) {
      setState(() {
        this._strWrong = "手机号码格式不正确";
      });
      return;
    }

    if (this._identifyCode.isEmpty) {
      setState(() {
        this._strWrong = "请输入四位手机短信验证码";
      });
      return;
    }
    if (this._identifyCode.length != 4) {
      setState(() {
        this._strWrong = "手机短信验证码应该为四位";
      });
      return;
    }
    if (this._firstPassword.isEmpty) {
      setState(() {
        this._strWrong = "密码不能为空";
      });
      return;
    }
    if (this._secondPassword.isEmpty) {
      setState(() {
        this._strWrong = "重复密码不能为空";
      });
      return;
    }
    if (this._firstPassword != this._secondPassword) {
      setState(() {
        this._strWrong = "两次输入的密码不一致";
      });
      return;
    }
    setState(() {
      this._strWrong = "";
    });

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return NetLoadingDialog(
            outsideDismiss: false,
            requestCallBack: _verifyCode(),
            loadingText: "数据提交中...",
          );
        });
  }

  /*验证验证码*/
  _verifyCode() {
    Smssdk.commitCode(this._phone, "86", this._identifyCode,
        (dynamic ret, Map err) {
      if (err != null) {
        //验证码失败
        Navigator.pop(context);
        setState(() {
          this._strWrong = "手机验证码不正确";
        });
      } else {
        //验证成功
        _netRigister();
      }
    });
  }

  /*网络注册接口*/
  _netRigister() async {
    var city = await MyApp.platform.invokeMethod("getCity",[NowLatLng.lat,NowLatLng.lng]);
     NowLatLng.city= city==null ? "成都":city;
    try {
       var   city=NowLatLng.city;
      Response response = await Dio().post(url + 'createUsers',
          data: {"phone": this._phone, "pwd": this._firstPassword,"city":city},
          options: Options(
              headers: {"AUTHORIZATION": "myjidiertokenmessage123456"},responseType:ResponseType.plain));
      NetUtil.ifNetSuccessful(response, successfull: (ResponseBean bean) {
        // Navigator.pop(context);ß
        Toast.toast(context, msg: bean.data.responseText, showTime: 1000);

        RegisterResult registResult = new RegisterResult();
        registResult.phone = this._phone;
        registResult.password = this._firstPassword;
        Navigator.pop(context, registResult);
        Navigator.pop(context, registResult);
      }, faild: (ResponseBean bean) {
        Navigator.pop(context, null);
        setState(() {
          this._strWrong = bean.data.responseText;
        });
      });
    } catch (e) {
      print(e);
      Navigator.pop(context, null);
      setState(() {
        this._strWrong = "注册失败";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
            child: AppBar(
              title: Text(
                "注册",
                style: TextStyle(color: Colors.white, fontSize: 18.0),
              ),
              backgroundColor: Color(0xff00afaf),
              centerTitle: true,
            ),
            preferredSize: Size.fromHeight(40.0)),
        body: BlankToolBarTool.blankToolBarWidget(context,
            model: blankToolBarModel,
            body: Container(
              alignment: Alignment.center,
              color: Colors.white,
              child: ListView(children: <Widget>[
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
                    padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0),
                    child: _getPhoneWidget()),
                _getIndetifyCode(),
                _getFirstPassword(),
                _getSecondPassword(),
                _getRegisterButton()
              ]),
            )));
  }
}
