import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:myflutter/pages/bean/AtentAddressBean.dart';
import 'package:amap_base/amap_base.dart';
import 'package:myflutter/pages/bean/AdressDataBean.dart';
import 'package:myflutter/pages/bean/LoginBean.dart';
import 'package:myflutter/pages/bean/ResponseBean.dart';
import 'package:myflutter/pages/dialog/NetLoadingDialog.dart';
import 'package:myflutter/pages/util/HttpContent.dart';
import 'package:myflutter/pages/util/LoginUtil.dart';
import 'package:myflutter/pages/util/NetUtil.dart';
import 'package:myflutter/pages/util/SystemUtil.dart';
import 'package:myflutter/pages/util/Toast.dart';

/**糾正地址界面*/
class AtentAddressWidget extends StatefulWidget {
  AtentAddressBean atentAddressBean;

  AtentAddressWidget({Key key, this.atentAddressBean}) : super(key: key);

  @override
  _AtentAddressWidgetState createState() =>
      _AtentAddressWidgetState(atentAddressBean);
}

class _AtentAddressWidgetState extends State<AtentAddressWidget> {
  AtentAddressBean _atentAddressBean;
  AMapController _controller;
  List atendLoctions;
  double long;
  double lat;
   double _zoom=17;
  _AtentAddressWidgetState(atentAddressBean) {
    this._atentAddressBean = atentAddressBean;
  }

  @override
  Widget build(BuildContext context) {
    ResponseData responseData = this._atentAddressBean.responseData;
    if (responseData.atendLocation != null &&
        responseData.atendLocation != "0") {
      List atendLocations = responseData.atendLocation.split(",");
      lat = double.parse(atendLocations[1]);
      long = double.parse(atendLocations[0]);
    } else {
      long = double.parse(responseData.longs);
      lat = double.parse(responseData.lat);
    }

    return Scaffold(
      appBar: PreferredSize(
          child: AppBar(
            backgroundColor: Color(0xff00afaf),
            centerTitle: true,
            title: Text(
              "纠正地址-${this._atentAddressBean.responseData.describe}",
              style: TextStyle(color: Colors.white, fontSize: 14.0),
            ),
          ),
          preferredSize: Size.fromHeight(SystemUtil.getScreenSize(context).height*0.07)),
      body: Stack(
        alignment: Alignment.bottomCenter,
        // mainAxisAlignment: MainAxisAlignment.start,
        //  crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[getMapWidget(), getBottomWidget()],
      ),
    );
  }

  /*获得地图控件*/
  Widget getMapWidget() {
    ResponseData responseData = this._atentAddressBean.responseData;

    return Padding(
        padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 140.0),
        child: Listener(
          onPointerDown: (downPointerEvent) {
            print("触摸按下事件");
          },
          onPointerUp: (upPointerEvent) {
            print("触摸抬起");
          },
          child: Stack(
            alignment: Alignment.bottomRight,
            children: <Widget>[
              Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  AMapView(
                    onAMapViewCreated: (controller) {
                      this._controller = controller;
                      MarkerOptions markerOption = MarkerOptions(
                          position: LatLng(lat, long),
                          icon: "images/2.0x/ico_end_marker.png");

                      this._controller.addMarker(markerOption);
                    },
                    amapOptions: AMapOptions(
                      compassEnabled: false,
                      mapType: MAP_TYPE_NORMAL,
                      zoomControlsEnabled: true,
                      logoPosition: LOGO_POSITION_BOTTOM_CENTER,
                      camera: CameraPosition(
                        target: LatLng(lat, long),
                        zoom:this._zoom,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (this._controller != null) {
                        this._controller.getCenterLatlng().then((latLng) {
                          this._controller.clearMarkers();
                          MarkerOptions options = MarkerOptions(
                              position: latLng,
                              icon: "images/2.0x/ico_end_marker.png");
                          this._controller.addMarker(options);
                        });
                      }
                    },
                    child: Image.asset("images/ic_red_location.png"),
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0.0, 0.0, 40.0, 60.0),
                child: GestureDetector(
                  onTap: () {
                    // print("点击了定位按钮");
                    this._controller.changeLatLng(LatLng(lat, long));
                    this._controller.clearMarkers();
                    MarkerOptions options = MarkerOptions(
                        position: LatLng(lat, long),
                        icon: "images/2.0x/ico_end_marker.png");

                    this._controller.addMarker(options);
                    this._controller.setZoomLevel(int.parse("$_zoom"));
                  },
                  child: Image.asset(
                    "images/locaiton1.png",
                    width: 30.0,
                    height: 30.0,
                    fit: BoxFit.cover,
                  ),
                ),
              )
            ],
          ),
        ));
  }

  Widget getBottomWidget() {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Image.asset("images/map_bottom.png"),
        Container(
            alignment: Alignment.center,
            height: 200.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xff009898),
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
                      child: Text(
                        "纠正",
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  onTap: () {
                    this._updateAddressDialog("纠正中...", "1");
                  },
                )
              ],
            )),
        Container(
            alignment: Alignment.bottomRight,
            height: 200.0,
            child: Stack(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(0.0, 0.0, 30.0, 20.0),
                  child: GestureDetector(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xff009898),
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(15.0, 8.0, 15.0, 8.0),
                        child: Text(
                          "清除\n纠正",
                          style: TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    onTap: () {
                      this._updateAddressDialog("清除中......", "0");
                    },
                  ),
                )
              ],
            )),
      ],
    );

  }

  _updateAddressDialog(String target, String location) async {
    if (location != "0") {
      LatLng latLng = await this._controller.getCenterLatlng();
      location = "${latLng.longitude},${latLng.latitude}";

      if (this._controller != null) {
        this._controller.clearMarkers();
        MarkerOptions option = MarkerOptions(
            position: latLng, icon: "images/2.0x/ico_end_marker.png");
        this._controller.addMarker(option);
      }
    }

    LoginBean loginBean = await LoginUtil.getLoginBean();

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return NetLoadingDialog(
            outsideDismiss: false,
            loadingText: target,
            requestCallBack: _netUpdateAdress(location, loginBean),
          );
        });
  }

  /**网络更新地址接口*/
  _netUpdateAdress(String location, LoginBean loginBean) async {
    try {
      Response response = await Dio()
          .put(url + "AdrData/${this._atentAddressBean.responseData.id}",
              data: {
                "describe": this._atentAddressBean.responseData.describe,
                "remark": this._atentAddressBean.responseData.remark,
                "kind": this._atentAddressBean.responseData.kind,
                "address": this._atentAddressBean.responseData.address,
                "addressLocation":
                    this._atentAddressBean.responseData.addressLocation,
                "atendLocation": location,
                "path1": this._atentAddressBean.responseData.path1,
                "path2": this._atentAddressBean.responseData.path2,
                "path3": this._atentAddressBean.responseData.path3,
                "longs": this._atentAddressBean.responseData.longs,
                "lat": this._atentAddressBean.responseData.lat,
                "time": this._atentAddressBean.responseData.times,
                "buydate": this._atentAddressBean.responseData.buydate,
                "months": this._atentAddressBean.responseData.months,
                "state": this._atentAddressBean.responseData.state,
                "endtime": this._atentAddressBean.responseData.endtime
              },
              options: Options(headers: {"AUTHORIZATION": loginBean.token}));

      NetUtil.ifNetSuccessful(response,
          successfull: (ResponseBean responseBean) {
        if (location == "0") {
          Toast.toast(context, msg: "清除成功...");
        } else {
          Toast.toast(context, msg: "纠正成功...");
        }
        this
            ._atentAddressBean
            .callBack(this._atentAddressBean.position, location);
        Navigator.pop(context);
        Navigator.pop(context);
      }, faild: (ResponseBean responseBean) {
        Toast.toast(context, msg: responseBean.message);
      });
    } catch (e) {
      if (location == "0") {
        Toast.toast(context, msg: "清除失败...");
      } else {
        Toast.toast(context, msg: "纠正地址失败....");
      }
      print(e);
    }
  }
}
