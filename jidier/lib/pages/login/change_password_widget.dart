import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:myflutter/pages/bean/LoginBean.dart';
import 'package:myflutter/pages/bean/ResponseBean.dart';
import 'package:myflutter/pages/dialog/NetLoadingDialog.dart';
import 'package:myflutter/pages/util/BlankToolBarModel.dart';
import 'package:myflutter/pages/util/HttpContent.dart';
import 'package:myflutter/pages/util/LoginUtil.dart';
import 'package:myflutter/pages/util/NetUtil.dart';
import 'package:myflutter/pages/util/Toast.dart';

/*修改密码界面*/
class ChangePasswordWidget extends StatefulWidget {
  ChangePasswordWidget({Key key}) : super(key: key);

  @override
  _ChangePasswordWidgetState createState() => _ChangePasswordWidgetState();
}

class _ChangePasswordWidgetState extends State<ChangePasswordWidget> {
  String _wrongNotice = "";
  bool ifShowPassword = true;
  String firstPassword = "";
  String secondPassword = "";
  BlankToolBarModel blankToolBarModel = BlankToolBarModel();
  /*第一次输入密码控件*/

  Widget getFirstPassword() {
    return Padding(
        padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
        child: TextField(
          decoration: InputDecoration(
            hintText: "请输入新密码",
            hintStyle: TextStyle(fontSize: 14.0, color: Colors.grey,fontWeight:FontWeight.bold),
            icon: Image.asset(
              "images/ic_password.png",
              width: 20.0,
              height: 20.0,
              fit: BoxFit.cover,
            ),
            isDense: true,
            contentPadding: EdgeInsets.fromLTRB(0.0, 0, 0, 0.0),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xff00afaf))),
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xff00afaf))),
            suffixIcon: IconButton(
              icon: Image.asset(
                ifShowPassword
                    ? "images/ic_hide_pwd_gray.png"
                    : "images/ic_show_pwd_gray.png",
                width: 20.0,
                fit: BoxFit.cover,
              ),
              onPressed: () {
                setState(() {
                  this.ifShowPassword = !this.ifShowPassword;
                });
              },
            ),
          ),
          maxLength: 8,
          maxLines:1,
          obscureText: ifShowPassword,
          cursorColor: Color(0xff00afaf),
          style:TextStyle(fontSize:14,color:Colors.black),
          onChanged: (text) {
            this.firstPassword = text;
          },
        ));
  }

  Widget getSecondPassword() {
    return Padding(
        padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 20.0),
        child: TextField(
          decoration: InputDecoration(
            hintText: "请再次输入新密码",
            hintStyle: TextStyle(fontSize: 14.0, color: Colors.grey,fontWeight:FontWeight.bold),
            icon: Image.asset(
              "images/ic_password.png",
              width: 20.0,
              height: 20.0,
              fit: BoxFit.cover,
            ),
            isDense: true,
            contentPadding: EdgeInsets.fromLTRB(0.0, 0, 0, 10.0),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xff00afaf))),
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xff00afaf))),
          ),
          maxLength: 8,
          maxLines:1,
          obscureText: true,
          cursorColor: Color(0xff00afaf),
          style:TextStyle(fontSize:14,color:Colors.black),
          onChanged: (text) {
            this.secondPassword = text;
          },
        ));
  }

  /*修改密码*/
  netChangePassword() {
    if (this.firstPassword == "") {
      setState(() {
        this._wrongNotice = "请输入新密码";
      });
      return;
    }

    if (this.secondPassword == "") {
      setState(() {
        this._wrongNotice = "请再次输入新密码";
      });
      return;
    }
    if (this.firstPassword != this.secondPassword) {
      setState(() {
        this._wrongNotice = "两次输入的密码不一致";
      });
      return;
    }
    setState(() {
      this._wrongNotice = "";
    });
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return NetLoadingDialog(
              requestCallBack: netStartChange(),
              outsideDismiss: false,
              loadingText: "修改中...");
        });
  }

  netStartChange() async {
    LoginBean loginBean = await LoginUtil.getLoginBean();

    try {
      Response response = await Dio().put(url + "users",
          data:{"pwd":this.firstPassword},
          options: Options(headers: {"AUTHORIZATION": loginBean.token},responseType:ResponseType.plain));

      NetUtil.ifNetSuccessful(response,
          successfull: (ResponseBean responseBean) {
            Navigator.pop(context);
           Toast.toast(context,msg:"修改成功...");
            Navigator.pop(context);

          },
          faild: (ResponseBean responseBean) {
               Navigator.pop(context);
               setState(() {
                 this._wrongNotice=responseBean.data.responseText;
               });


          });
    } catch (e) {
      print(e);
      Navigator.pop(context);
      setState(() {
        this._wrongNotice = "修改失败,请检查网络链接";
      });
    }
  }

  @override
  void initState() {
    blankToolBarModel.outSideCallback=focusNodeChange;
   super.initState();
  }
  void focusNodeChange(){
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
    return Scaffold(
      appBar: PreferredSize(
        child: AppBar(
          title: Text(
            "修改密码",
            style: TextStyle(color: Colors.white, fontSize: 18.0),
          ),
          backgroundColor: Color(0xff00afaf),
          centerTitle: true,
        ),
        preferredSize: Size.fromHeight(40.0),
      ),
      body:BlankToolBarTool.blankToolBarWidget(context,model:blankToolBarModel,body: Container(
        alignment: Alignment.center,
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
          child: ListView(
            children: <Widget>[
              Container(
                child: Image.asset(
                  "images/ic_foot_step.png",
                  fit: BoxFit.cover,
                  width: 140.0,
                ),
                alignment: Alignment.center,
              ),
              Text(
                _wrongNotice,
                style: TextStyle(color: Colors.red, fontSize: 14.0),
              ),
              getFirstPassword(),
              getSecondPassword(),
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
                              "修改",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 16.0),
                            ),
                            color: Color(0xff00afaf),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0))),
                            onPressed: () {
                              netChangePassword();
                            }),
                      )),
                  Container(
                    width: 40.0,
                  ),
                ],
              ),
            ],
          ),
        ),
      )),
    );
  }
}
