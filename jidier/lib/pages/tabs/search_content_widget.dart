import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:myflutter/main.dart';
import 'package:myflutter/pages/bean/SelectAddressBean.dart';
import 'package:myflutter/pages/dialog/NetLoadingDialog.dart';
import 'package:myflutter/pages/util/BlankToolBarModel.dart';
import 'package:myflutter/pages/util/DiatanceUtil.dart';
import 'package:myflutter/pages/util/LocationDataUtil.dart';
import 'package:myflutter/pages/util/SystemUtil.dart';
import 'package:myflutter/pages/util/Toast.dart';
import 'package:myflutter/pages/dialog/SpeakerDialog.dart';

/*搜索内容弹窗*/
class SearchContentWidget extends StatefulWidget {
  SearchContentWidget({Key key}) : super(key: key);

  @override
  _SearchContentWidgetState createState() => _SearchContentWidgetState();
}

class _SearchContentWidgetState extends State<SearchContentWidget> {
  List _result = List();
  BlankToolBarModel blankToolBarModel = BlankToolBarModel();
  String _searchContent = "";
  int selecttionController = 0;

  @override
  void initState() {
    // TODO: implement initState
    blankToolBarModel.outSideCallback = focusNodeChange;
    super.initState();
    // AmapCore.init('30451939c0a123dfb05d9ae6b7c00b1f');
  }

  void focusNodeChange() {
    setState(() {});
  }

  @override
  void dispose() {
    blankToolBarModel.removeFocusListeners();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          child: AppBar(
            title: Text(
              "输入地址搜索",
              style: TextStyle(color: Colors.white, fontSize: 16.0),
            ),
            backgroundColor: Color(0xff00afaf),
            centerTitle: true,
          ),
          preferredSize:
              Size.fromHeight(SystemUtil.getScreenSize(context).height * 0.07)),
      body: BlankToolBarTool.blankToolBarWidget(context,
          model: blankToolBarModel,
          body: Container(
            alignment: Alignment.topCenter,
            color: Color(0xffeeeeee),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[this._getTopEnter(), this._getContentWidget()],
            ),
          )),
    );
  }

  Widget _getTopEnter() {
    return Container(
      alignment: Alignment.center,
      color: Colors.white,
      child: Padding(
          padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
          child: Container(
            alignment: Alignment.center,
            // height: 40.0,
            decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            child: Padding(
              padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.search,
                    color: Color(0xff333333),
                  ),
                  Expanded(
                    flex: 1,
                    child: TextField(
                      onTap: () {},
                      autofocus: true,
                      decoration: InputDecoration(
                          hintText: "请输入关键字",
                          hintStyle: TextStyle(
                              fontSize: 16.0,
                              color: Color(0xff333333),
                              fontWeight: FontWeight.bold),
                          isDense: true,
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black12)),
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black12))),
                      cursorColor: Color(0xff00afaf),
                      onChanged: (text) {
                        this._searchContent = text;
                      },
                      style: TextStyle(
                          fontSize: 16.0,
                          color: Color(0xff000000),
                          fontWeight: FontWeight.bold),
                      controller: TextEditingController.fromValue(
                          TextEditingValue(
                              text: _searchContent,
                              selection: TextSelection.fromPosition(
                                  TextPosition(
                                      affinity: TextAffinity.upstream,
                                      offset: _searchContent.length)))),
                      onSubmitted: (text) {
                        this._searchDialog(this._searchContent);
                      },
                    ),
                  ),
                  IconButton(
                      icon: Image.asset(
                        "images/ic_closed.png",
                        height: 25.0,
                        width: 25.0,
                      ),
                      onPressed: () {
                        this._searchContent = "";
                        this._searchDialog(this._searchContent);
                      }),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0.0, 0.0, 5.0, 0.0),
                    child: IconButton(
                        icon: Image.asset("images/ic_speaker.png"),
                        onPressed: () {
                          showSpeakerDialog();
                        }),
                  )
                ],
              ),
            ),
          )),
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
      if (speakContent != null && speakContent != "") {
        setState(() {
          _searchContent = speakContent;
        });
        this._searchDialog(speakContent);
      }
    });
  }

  _sepeaker() async {
    var result = await MyApp.platform.invokeMethod("speaker");
    Navigator.pop(context, result);
  }

  TextEditingController getTextController() {
    switch (selecttionController) {
      case 0: //等于零  不管光标
        break;

      case 1: //等于1 设置光标在最后
        break;
    }
  }

  /*获得地址列表界面*/
  Widget _getContentWidget() {
    return Expanded(
      child: ListView.builder(
        itemBuilder: (context, index) {
          return getItem(index);
        },
        itemCount: _result.length,
      ),
      flex: 1,
    );
  }

  /*显示搜索弹窗*/
  _searchDialog(content) {
    if (content == null || content == "") {
      setState(() {
        this._result = List();
      });
    } else {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) {
            return new NetLoadingDialog(
              loadingText: "获取中...",
              outsideDismiss: false,
              requestCallBack: _search(content),
            );
          });
    }
  }

  _search(content) async {
    String city = "北京市";
    var lng;
    var lat;
    if (LocationDataUtil.nowlocation != null) {
      city = LocationDataUtil.nowlocation.city;
      lng = LocationDataUtil.nowlocation.lng;
      lat = LocationDataUtil.nowlocation.lat;
    }

    var result = await MyApp.platform
        .invokeMethod("search", [content, city, "$lng", "$lat"]);
    if (result != null && result != "") {
      var jsonResult = jsonDecode(result);

      setState(() {
        this._result = jsonResult;
        this._searchContent = content;
      });
      Navigator.pop(context);
    }
  }

  Widget getItem(int index) {
    var _tap = this._result[index];
    double distance = 0.0;
    if (LocationDataUtil.nowlocation != null) {
      distance = DiatanceUtil.getDistance(
          LocationDataUtil.nowlocation.lng,
          LocationDataUtil.nowlocation.lat,
          double.parse(_tap["lng"]),
          double.parse(_tap["lat"]));
    }

    return Padding(
      padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 0.0),
      child: GestureDetector(
        onTap: () {
          var lat = _tap["lat"];
          if (lat == null || lat == "") {
            Toast.toast(context, msg: "没有获得此地址的经纬度，请选择其它地址！！", showTime: 1500);
          } else {
            SelectAddressBean bean = SelectAddressBean();
            bean.name = _tap["name"];
            bean.describle = _tap["describle"];
            bean.city = _tap["city"];
            bean.lat = double.parse(_tap["lat"]);
            bean.lng = double.parse(_tap["lng"]);
            Navigator.pop(context, bean);
          }
        },
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          child: Column(
            children: <Widget>[
              Container(
                height: 5.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 20.0,
                  ),
                  Expanded(
                    child: Text(
                      _tap["name"],
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold),
                    ),
                    flex: 1,
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 20.0,
                  ),
                  Expanded(
                    child: Text.rich(TextSpan(children: [
                      TextSpan(
                          text: _tap["city"] + "-",
                          style: TextStyle(
                              fontSize: 16.0, color: Color(0xff009688))),
                      TextSpan(
                          text: _tap["describle"],
                          style:
                              TextStyle(fontSize: 14.0, color: Colors.black54))
                    ])),
                    flex: 1,
                  )
                ],
              ),
              Padding(
                  padding: EdgeInsets.fromLTRB(20.0, 0.0, 10.0, 10.0),
                  child: Row(
                    children: <Widget>[
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                                text: "距离您:",
                                style: TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700)),
                            TextSpan(
                                text: "$distance千米",
                                style: TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.red,
                                    fontWeight: FontWeight.w700))
                          ],
                        ),
                        textAlign: TextAlign.left,
                      )
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
