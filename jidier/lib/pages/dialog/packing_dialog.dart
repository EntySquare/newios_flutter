import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:myflutter/pages/bean/AdressDataBean.dart';

import '../../main.dart';
import 'navigation_dialog.dart';

enum LoadState { State_Success, State_nodata, State_Loading }

/*停车场信息dialog*/
class PackingDialog extends StatefulWidget {
  ResponseData responseData;

  PackingDialog({Key key, this.responseData}) : super(key: key);

  @override
  _PackingDialogState createState() => _PackingDialogState(responseData);
}

class _PackingDialogState extends State<PackingDialog> {
  ResponseData _responseData;
  List _result = List();
  LoadState _state = LoadState.State_Loading;

  _PackingDialogState(ResponseData responseData) {
    this._responseData = responseData;
  }

  @override
  Widget build(BuildContext context) {
    this._search(this._responseData.lat, this._responseData.longs);
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Material(
        type: MaterialType.transparency,
        child: Padding(
          padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 5.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              GestureDetector(
                child: Container(
                  color: Colors.white,
                  height: 460.0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.fromLTRB(5.0, 10.0, 0.0, 10.0),
                        child: getTitleWidget(),
                      ),
                      Expanded(
                        child: getContentWidget(),
                        flex: 1,
                      ),
                    ],
                  ),
                ),
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getContentWidget() {
    switch (_state) {
      case LoadState.State_Success:
        return getListWidget();
        break;
      case LoadState.State_nodata:
        return getNoDataWidget();
        break;
      case LoadState.State_Loading:
        return getWhiteWidget();
        break;
    }
  }

  Widget getListWidget() {
    return Container(
      color: Color(0xffdedede),
      child: ListView.builder(
        itemBuilder: (context, index) {
          return getListItemWidget(context, index);
        },
        itemCount: _result.length,
      ),
    );
  }

  /*附近1000米范围类无停车场*/
  Widget getNoDataWidget() {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            "images/ico_no_data.png",
            width: 60,
            height: 60,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
            child: Text(
              "附近1000米内暂无停车场数据信息",
              style: TextStyle(
                  fontSize: 14.0,
                  color: Color(0xff333333),
                  fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }

  /*附近1000米范围类无停车场*/
  Widget getWhiteWidget() {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[],
      ),
    );
  }

  /*得到顶部界面*/
  Widget getTitleWidget() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: RichText(
              textAlign: TextAlign.center,
              textScaleFactor: MediaQuery.of(context).textScaleFactor,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "(${_responseData.describe})-",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xffff0000)),
                  ),
                  TextSpan(
                    text: "附近停车场",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff333333)),
                  )
                ],
              )



          ),
          flex: 1,
        ),
        Container(
          width: 60.0,
          child: IconButton(
              icon: Image.asset("images/ic_closed.png"),
              onPressed: () {
                Navigator.pop(context);
              }),
        )
      ],
    );
  }

  /*list item 界面*/
  Widget getListItemWidget(myContext, int index) {
    var poi = _result[index];
    return Column(
      children: <Widget>[
        Container(
          height: 10.0,
        ),
        Container(
          color: Color(0xffffffff),
          child: Padding(
            padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.fromLTRB(0.0, 0.0,5.0, 0.0),
                    child: getLeftIcoWidget("公共\n停车场")),
                Expanded(
                    flex: 1,
                    child: getMidContentWidget(
                        poi["name"], poi["distance"], poi["packingType"])),
                Padding(
                  padding: EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
                  child: IconButton(
                      icon: Image.asset("images/ic_blue_navigation.png"),
                      onPressed: () {
                        var myPoi = _result[index];
                        String lat = myPoi["lat"];
                        String lng = myPoi["lng"];
                        double dLat = double.parse(lat);
                        double dLng = double.parse(lng);
                        _showNavigationDialog(
                            myContext, poi["name"], dLat, dLng);
                      }),
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget getLeftIcoWidget(String kind) {
    return Container(
      decoration: BoxDecoration(
          color: Color(0xff009688),
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      child: Padding(
        padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
        child: Text(
          kind,
          style: TextStyle(
              fontSize: 14, color: Colors.white, fontWeight: FontWeight.w700),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget getMidContentWidget(String name, String distance, String packingType) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          name,
          style: TextStyle(
              fontSize: 14,
              color: Color(0xff000000),
              fontWeight: FontWeight.w700),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: RichText(
                text: TextSpan(children: [
                  TextSpan(
                      text: "距离记录地点",
                      style: TextStyle(fontSize: 14, color: Color(0xff333333))),
                  TextSpan(
                      text: "$distance米",
                      style: TextStyle(fontSize: 14, color: Color(0xffff0000)))
                ]),
                textAlign:TextAlign.center,
                textScaleFactor: MediaQuery.of(context).textScaleFactor,
              ),
              flex: 1,
            ),
            Padding(
                padding: EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Color(0xff009688),
                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(10.0, 3.0, 10.0, 3.0),
                    child: Text(
                      packingType == "" ? "未知" : packingType,
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ))
          ],
        )
      ],
    );
  }

  _search(String lat, String long) async {
    if (lat == null || long == null) {
      //if (mounted) {
      setState(() {
        this._result = List();
        this._state = LoadState.State_nodata;
      });
      // }
      return;
    }
    var result = await MyApp.platform.invokeMethod("searchNearBy", [lat, long]);
    if (result != null && result != "") {
      var jsonResult = jsonDecode(result);
      List myResult = jsonResult;
      LoadState myState = myResult.length == 0
          ? LoadState.State_nodata
          : LoadState.State_Success;
      //if (mounted) {
      setState(() {
        this._result = jsonResult;
        this._state = myState;
      });
      // }
    } else {
      // if (mounted) {
      setState(() {
        this._result = List();
        this._state = LoadState.State_nodata;
      });
      // }
    }
  }

  /*x显示导航弹窗*/
  _showNavigationDialog(myContext, String address, double lat, double long) {
    showDialog(
        context: myContext,
        barrierDismissible: false,
        builder: (context) {
          return NavigationDialog(
            address: address,
            lat: lat,
            long: long,
            isShowParking:false,
          );
        });
  }
}
