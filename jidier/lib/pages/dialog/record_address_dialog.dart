import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:myflutter/pages/bean/AdressDataBean.dart';
import 'package:myflutter/pages/bean/AmbitusAdressBean.dart';
import 'package:myflutter/pages/bean/LoginBean.dart';

import 'package:myflutter/pages/bean/NetAddressBean.dart';
import 'package:myflutter/pages/bean/ResponseBean.dart';
import 'package:myflutter/pages/dialog/NetLoadingDialog.dart';
import 'package:myflutter/pages/dialog/NetLoadingDialog2.dart';
import 'package:myflutter/pages/dialog/ambitus_address_dialog.dart';
import 'package:myflutter/pages/dialog/image_dialog.dart';
import 'package:myflutter/pages/dialog/navigation_dialog.dart';
import 'package:myflutter/pages/dialog/record_sucessful_dialog.dart';
import 'package:myflutter/pages/dialog/select_kind_dialog.dart';
import 'package:myflutter/pages/util/BlankToolBarModel.dart';
import 'package:myflutter/pages/util/DataUtil.dart';
import 'package:myflutter/pages/util/HttpContent.dart';
import 'package:myflutter/pages/util/LoginUtil.dart';
import 'package:myflutter/pages/util/NetUtil.dart';
import 'package:myflutter/pages/util/TextSpanUtil.dart';
import 'package:myflutter/pages/util/Toast.dart';
import 'dart:convert';

import 'package:myflutter/pages/widget/MyFlutterRadioButtonGroup.dart';

import '../../main.dart';
import 'SpeakerDialog.dart';

/*记录地址弹窗地址弹窗*/
class RecordAddressDialog extends StatefulWidget {
  var confirmCallBack;
  NetAddressBean addressBean;
  int state;

  RecordAddressDialog({this.addressBean, this.state, this.confirmCallBack})
      : super();

  @override
  _RecordAddressDialogState createState() =>
      _RecordAddressDialogState(addressBean, this.state, confirmCallBack);
}

class _RecordAddressDialogState extends State<RecordAddressDialog>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  NetAddressBean _addressBean;
  var _confirmCallBack;

  // Step1: 响应空白处的焦点的Node
  BlankToolBarModel blankToolBarModel = BlankToolBarModel();
  int _state;

  TextSpan textSpan = TextSpan(
      text: "", style: TextStyle(fontSize: 14.0, color: Color(0xffff0000)));

  _RecordAddressDialogState(
      NetAddressBean addressBean, myState, confirmCallBack) {
    this._addressBean = addressBean;
    this._confirmCallBack = confirmCallBack;
    this._state = myState == null ? 0 : myState;
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    blankToolBarModel.outSideCallback = focusNodeChange;
  }

// Step2.2: 焦点变化时的响应操作
  void focusNodeChange() {
    setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    blankToolBarModel.removeFocusListeners();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {


    return GestureDetector(
      onTap: () {},
      child: Material(
        type: MaterialType.transparency,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: BlankToolBarTool.blankToolBarWidget(context,
              model: blankToolBarModel,
              body: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(10.0, 40.0, 10.0, 0.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 10.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              this._getTopWidget(),
                              this.getMidPicWidget(),
                              this.getBottomWidget()
                            ],
                          ),
                        ),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0))),
                      ),
                    ],
                  ),
                ),
              )),
        ),
      ),
    );
  }

  Widget _getTopWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          alignment: Alignment.centerLeft,
          // height: 40.0,
          decoration: BoxDecoration(
              color: Color(0xffeeeeee),
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          child: Padding(
            padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  child: Image.asset(
                    "images/ic_blue_navigation.png",
                    width: 30.0,
                    height: 30.0,
                  ),
                  onTap: () {
                    //导航到记录地点
                    _showDiscribleNavigationDialog();
                  },
                ),
                Expanded(
                  flex: 1,
                  child: TextField(
                    autofocus:true,
                    keyboardType: TextInputType.text,
                    controller: TextEditingController.fromValue(
                        TextEditingValue(
                            text: this._addressBean.describe,
                            selection: TextSelection.fromPosition(TextPosition(
                                offset: this._addressBean.describe.length,
                               affinity: TextAffinity.upstream
                            )))),
                    decoration: InputDecoration(
                        hintText: "请输入地址描述(必填)",
                        hintStyle:
                            TextStyle(fontSize: 16.0, color: Color(0xff7e7e7e)),
                        isDense: true,
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xffeeeeee))),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xffeeeeee)))),
                    onChanged: (text) {
                      this._addressBean.describe = text;
                    },
                    style: TextStyle(fontSize: 16.0, color: Color(0XFF000000)),
                  ),
                ),
                IconButton(
                    icon: Image.asset(
                      "images/ic_closed.png",
                      height: 25.0,
                      width: 25.0,
                    ),
                    onPressed: () {
                      setState(() {
                        this._addressBean.describe = "";
                      });
                    }),
                IconButton(
                    icon: Image.asset("images/ic_speaker.png"),
                    onPressed: () {

                      showSpeakerDialog();

                    })
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            // print("点击了类别选择");
            this._showSelectKindDialog();
          },
          child: Padding(
            padding: EdgeInsets.fromLTRB(5.0, 8.0, 0.0, 0.0),
            child: Container(
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "类别:",
                    style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.black,
                        fontWeight: FontWeight.w700),
                  ),
                  Text(
                    this._addressBean.kind,
                    style: TextStyle(
                        fontSize: 14.0,
                        color: Color(0xff009898),
                        fontWeight: FontWeight.bold),
                  ),
                  Icon(
                    Icons.more_vert,
                    color: Color(0xff009898),
                  )
                ],
              ),
            ),
          ),
        ),
        Padding(
            padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
            child: GestureDetector(
              onTap: () {
                // print("点击了获取周边地址按钮");
                this._getAmbitusAddressByLocation();
              },
              child: Container(
                  alignment: Alignment.centerLeft,
                  //height: 40.0,
                  decoration: BoxDecoration(
                      color: Color(0xffeeeeee),
                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "获取周边地址:",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14.0,
                              fontWeight: FontWeight.w700),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            this._addressBean.address == null
                                ? "(不必填)"
                                : this._addressBean.address == "0"
                                    ? "(不必填)"
                                    : this._addressBean.address,
                            style: TextStyle(
                              fontSize: 12.0,
                              color: Colors.black,
                            ),
                            // overflow: TextOverflow.ellipsis,
                            // maxLines:1,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            if (this._addressBean.addressLocation == null ||
                                this._addressBean.addressLocation == "0") {
                              Toast.toast(context,
                                  msg: "请先点击获取周边地址，才能导航", showTime: 1500);
                              return;
                            } else {
                              //print("点击了导航按钮");
                              this._showNavigationDialog();
                            }
                          },
                          child: Image.asset(
                            "images/ic_blue_navigation.png",
                            width: 25.0,
                            height: 25.0,
                          ),
                        ),
                      ],
                    ),
                  )),
            )),
        Padding(
            padding: EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                GestureDetector(
                  child: Container(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                      child: Text(
                        "编辑备注",
                        style: TextStyle(
                            fontSize: 14.0,
                            color: _state == 0 ? Colors.white : Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    decoration: BoxDecoration(
                        border:
                            Border.all(width: 2.0, color: Color(0xff009688)),
                        color: _state == 0 ? Color(0xff009688) : Colors.white),
                  ),
                  onTap: () {
                    setState(() {
                      this._state = 0;
                    });
                  },
                ),
                GestureDetector(
                  child: Container(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                      child: Text(
                        "查看备注",
                        style: TextStyle(
                            fontSize: 14.0,
                            color: _state == 0 ? Colors.black : Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    decoration: BoxDecoration(
                        border:
                            Border.all(width: 2.0, color: Color(0xff009688)),
                        color: _state == 0 ? Colors.white : Color(0xff009688)),
                  ),
                  onTap: () {
                    TextSpanUtil.buildTextSpan(context, this._addressBean.remark)
                        .then((textSpan) {
                      setState(() {
                        this.textSpan = textSpan;
                        this._state = 1;
                      });
                    });
                  },
                )
              ],
            )),
        Padding(
            padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
            child: getRemarkEditText(_state))
      ],
    );
  }

  void showSpeakerDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return SpeakerDialog(
            loadingText: "请说话。。。",
            outsideDismiss: false,
            requestCallBack: _sepeaker(),
          );
        }).then((speakContent) {
      if (speakContent != null&&speakContent!="") {
        setState(() {
          _addressBean.describe = speakContent;
        });
      }
    });
  }

  _sepeaker() async {
    var result = await MyApp.platform.invokeMethod("speaker");
    Navigator.pop(context, result);
  }



  Widget getRemarkEditText(int state) {
    if (state == 0) {
      return Container(
        alignment: Alignment.center,
        child: Padding(
            padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
            child: TextField(
              autofocus: false,
              decoration: InputDecoration(
                hintText: "请输入地址备注(不必填)",
                hintStyle: TextStyle(fontSize: 16.0, color: Color(0xff7e7e7e)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xffeeeeee))),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xffeeeeee))),
              ),
              maxLines: 3,
              controller: TextEditingController.fromValue(TextEditingValue(
                  text: this._addressBean.remark == null
                      ? ""
                      : this._addressBean.remark == "0"
                          ? ""
                          : this._addressBean.remark,
                  selection: TextSelection.fromPosition(TextPosition(
                      offset: this._addressBean.remark == null
                          ? 0
                          : this._addressBean.remark.length)))),
              onChanged: (text) {
                if (text == "") {
                  this._addressBean.remark = "0";
                } else {
                  this._addressBean.remark = text;
                }
              },
              style: TextStyle(fontSize: 14.0, color: Color(0xff333333)),
            )),
        decoration: BoxDecoration(
            color: Color(0xffeeeeee),
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
      );
    } else {
      return Container(
        alignment: Alignment.topLeft,
        child: Padding(
          padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 5.0),
          child: getRechText(context, textSpan),
        ),
      );
    }
  }

  Widget getRechText(context, textSpan) {
    TextStyle style = TextStyle(fontSize: 14.0, color: Color(0xffff0000));
    TextStyle linkStyle;
    linkStyle = Theme.of(context)
        .textTheme
        .body1
        .merge(style)
        .copyWith(
          color: Colors.blueAccent,
          decoration: TextDecoration.underline,
        )
        .merge(linkStyle);
    RichText richText = RichText(
      textAlign: TextAlign.left,
      //textDirection: textDirection,
      //maxLines: maxLines,H
      // overflow: overflow,
      softWrap: true,
      textScaleFactor: MediaQuery.of(context).textScaleFactor,
      text: textSpan,
    );
    return richText;
  }

  Widget getMidPicWidget() {
    return Padding(
      padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              //print("点击了第一个位置");
              this._showPictureDialog(0);
            },
            child: getPicWidget(0),
          ),
          Container(
            width: 5.0,
          ),
          GestureDetector(
            onTap: () {
              //print("点击了第二个位置");
              this._showPictureDialog(1);
            },
            child: getPicWidget(1),
          ),
          Container(
            width: 5.0,
          ),
          GestureDetector(
            onTap: () {
              // print("点击了第三个位置");
              this._showPictureDialog(2);
            },
            child: getPicWidget(2),
          ),
          Container(
            width: 20.0,
          ),
          GestureDetector(
            onTap: () {
              // print("点击了放大按钮");
              if ((this._addressBean.path1 == null ||
                      this._addressBean.path1 == "0") &&
                  (this._addressBean.path2 == null ||
                      this._addressBean.path2 == "0") &&
                  (this._addressBean.path3 == null ||
                      this._addressBean.path3 == "0")) {
                Toast.toast(context, msg: "你没添加图片,请先添加!", showTime: 1500);
              } else {
                ResponseData responseData = ResponseData();
                responseData.path1 = this._addressBean.path1;
                responseData.path2 = this._addressBean.path2;
                responseData.path3 = this._addressBean.path3;
                Navigator.pushNamed(context, "/showPicWidget",
                    arguments: responseData);
              }
            },
            child: Image.asset(
              "images/ic_amplify.png",
              width: 25.0,
              height: 25.0,
              fit: BoxFit.cover,
            ),
          )
        ],
      ),
    );
  }

  /*positon 位置，0表第一个位置，1，表第二个位置 ，2，表第三个位置*/
  Widget getPicWidget(int postion) {
    String path = "";
    switch (postion) {
      case 0:
        path = this._addressBean.path1;
        break;
      case 1:
        path = this._addressBean.path2;
        break;
      case 2:
        path = this._addressBean.path3;
        break;
    }

    if (path == null || path == "0") {
      return Image.asset(
        "images/ic_order_photo.png",
        width: 60.0,
        height: 60.0,
        fit: BoxFit.cover,
      );
    } else {
      return Image.network(
        IMAGE_URL + path,
        width: 60.0,
        height: 60.0,
        fit: BoxFit.cover,
      );
    }
  }

  Widget getBottomWidget() {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: RaisedButton(
                  onPressed: () {
                    //print("点击了修改按钮");
                    if (this._addressBean.describe == null ||
                        this._addressBean.describe == "0" ||
                        this._addressBean.describe == "") {
                      Toast.toast(context, msg: "地址描述不能為空", showTime: 1500);
                    } else {
                      _reviseAddress();
                    }
                  },
                  color: Color(0xff00afaf),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
                  child: Text(
                    "记录",
                    style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              )
            ],
          ),
          Container(
            height: 5.0,
          ),
          Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: MaterialButton(
                  onPressed: () {
                    // print("点击了修改按钮");
                    Navigator.pop(context, 0);
                  },
                  color: Colors.white,
                  child: Text(
                    "取消",
                    style: TextStyle(
                        fontSize: 16.0,
                        color: Color(0xff009898),
                        fontWeight: FontWeight.bold),
                  ),
                  shape: RoundedRectangleBorder(
                      side: BorderSide(color: Color(0xff009898), width: 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  _showSelectKindDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return SelectKindDialog(
            confirCallBack: (String kind) {
              setState(() {
                this._addressBean.kind = kind;
              });
            },
            defaltPosition: getDefaultKindPositon(),
          );
        });
  }

  getDefaultKindPositon() {
    for (int i = 0; i < kinds.length; i++) {
      if (kinds[i] == this._addressBean.kind) {
        return i;
      }
    }
  }

  /*通过经纬度获取周边地址*/
  _getAmbitusAddressByLocation() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return NetLoadingDialog(
            outsideDismiss: false,
            loadingText: "地址获取中....",
          );
        });
    _netAmbitusAddressByLocation();
  }

  _netAmbitusAddressByLocation() async {
    try {
      Response response =
          await Dio().get(MAP_URL + "v3/geocode/regeo?", queryParameters: {
        "output": "json",
        "location": this._addressBean.longs + "," + this._addressBean.lat,
        "key": "1f3da247686bd27e50db1502dfff7916",
        "radius": "500",
        "extensions": "all"
      });
      AmbitusAdreesBean ambitusAdressBean =
          NetUtil.getAmbitusAdressBean(response.toString());
      Navigator.pop(context);
      // print(response.toString());
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) {
            return AmbutisAddressDialog(
              confirCallBack: (Pois pois) {
                setState(() {
                  this._addressBean.address = pois.name;
                  this._addressBean.addressLocation = pois.location;
                });
              },
              defaltPosition:
                  this._getAmbitusDefalutPosition(ambitusAdressBean),
              ambitusAdreesBean: ambitusAdressBean,
            );
          });
    } catch (e) {
      print(e);
    }
  }

  _getAmbitusDefalutPosition(AmbitusAdreesBean ambitusBean) {
    List<Pois> lpois = ambitusBean.regeocode.pois;
    if (this._addressBean.addressLocation == null ||
        this._addressBean.addressLocation == "0") {
      return 0;
    }

    for (int i = 0; i < lpois.length; i++) {
      if (lpois[i].name == this._addressBean.address) {
        return i;
      }
    }
  }

  /*导航地址弹窗  */
  _showNavigationDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          List<String> locations = this._addressBean.addressLocation.split(",");

          double long = double.parse(locations[0]);
          double lat = double.parse(locations[1]);

          return NavigationDialog(
            address: this._addressBean.address,
            long: long,
            lat: lat,
          );
        });
  }

  /*导航地址弹窗  */
  _showDiscribleNavigationDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          double long = double.parse(this._addressBean.longs);
          double lat = double.parse(this._addressBean.lat);

          return NavigationDialog(
            address: this._addressBean.describe.isEmpty
                ? "未知地址"
                : this._addressBean.describe,
            long: long,
            lat: lat,
          );
        });
  }

  /*显示拍照弹窗
  * state  0 表示第一个位置的，1表示第二个位置，2表示第三个位置*/
  _showPictureDialog(int state) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return ImageDialog(
            imageCallBack: (String path) {
              switch (state) {
                case 0:
                  setState(() {
                    this._addressBean.path1 = path;
                  });

                  break;
                case 1:
                  setState(() {
                    this._addressBean.path2 = path;
                  });
                  break;
                case 2:
                  setState(() {
                    this._addressBean.path3 = path;
                  });
                  break;
              }
            },
          );
        });
  }

  _reviseAddress() async {
    LoginBean loginBean = await LoginUtil.getLoginBean();

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return NetLoadingDialog(
            outsideDismiss: false,
            loadingText: "记录中...",
            requestCallBack:
                this._netRecordAdress(this._addressBean, loginBean),
          );
        });
  }

  /*网络请求修改地址接口*/
  _netRecordAdress(NetAddressBean netAddressBean, LoginBean loginBean) async {
    netAddressBean.times = DataUtil.currentTimeMillis();
    netAddressBean.state = 0;
    netAddressBean.buydate = 0;
    netAddressBean.months = 0;
    netAddressBean.endtime = 1;

    try {
      Response response = await Dio().post(url + "createAdr",
          data: {
            "describe": netAddressBean.describe,
            "remark": netAddressBean.remark,
            "kind": netAddressBean.kind,
            "address": netAddressBean.address,
            "addressLocation": netAddressBean.addressLocation,
            "atendLocation": netAddressBean.atendLocation,
            "path1": netAddressBean.path1,
            "path2": netAddressBean.path2,
            "path3": netAddressBean.path3,
            "longs": netAddressBean.longs,
            "lat": netAddressBean.lat,
            "time": netAddressBean.times,
            "buydate": netAddressBean.buydate,
            "months": netAddressBean.months,
            "state": netAddressBean.state,
            "endtime": netAddressBean.endtime
          },
          options: Options(headers: {"AUTHORIZATION": loginBean.token}));

      NetUtil.ifNetSuccessful(response,
          successfull: (ResponseBean responseBean) {
        this._confirmCallBack(this._addressBean);
      }, faild: (ResponseBean responseBean) {
        Navigator.pop(context, 0);
        Toast.toast(context, msg: responseBean.message);
      });
    } catch (e) {
      Navigator.pop(context, 0);
      Toast.toast(context, msg: "记录失败,请检查网络链接");
      print(e);
    }
  }
}
