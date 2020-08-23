import 'dart:async';

import 'package:flutter/material.dart';
import 'package:myflutter/pages/bean/AdressDataBean.dart';
import 'package:amap_base/amap_base.dart';
import 'package:myflutter/pages/util/SystemUtil.dart';
import 'package:myflutter/pages/util/Toast.dart';

/*二维码详情页面*/
class QrInfoWidget extends StatefulWidget {
  ResponseData responseData;

  QrInfoWidget({Key key, this.responseData}) : super(key: key);

  @override
  _QrInfoWidgetState createState() => _QrInfoWidgetState(responseData);
}

class _QrInfoWidgetState extends State<QrInfoWidget> {
  ResponseData _responseData;
  AMapController _controller;

  _QrInfoWidgetState(ResponseData responseData) {
    this._responseData = responseData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
            child: AppBar(
              backgroundColor: Color(0xff00afaf),
              centerTitle: true,
              title: Text(
                "二维码详情-${this._responseData.describe}",
                style: TextStyle(color: Colors.white, fontSize:16.0,fontWeight:FontWeight.bold),

              ),
            ),
            preferredSize: Size.fromHeight(SystemUtil.getScreenSize(context).height*0.07)),
        body: Container(
            color: Colors.white,
            child: Stack(
              alignment: Alignment.bottomRight,
              children: <Widget>[
                AMapView(
                  onAMapViewCreated: (controller) {
                    this._controller = controller;
                    MarkerOptions markerOption = MarkerOptions(
                        position: LatLng(double.parse(_responseData.lat),
                            double.parse(_responseData.longs)),
                        icon: "images/2.0x/ic_red_location.png");

                    this._controller.addMarker(markerOption);
                    this._controller.setZoomLevel(17);
                  },
                  amapOptions: AMapOptions(
                    compassEnabled: false,
                    mapType: MAP_TYPE_NORMAL,
                    zoomControlsEnabled: true,
                    logoPosition: LOGO_POSITION_BOTTOM_CENTER,
                    camera: CameraPosition(
                      target: LatLng(double.parse(_responseData.lat),
                          double.parse(_responseData.longs)),
                    ),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.fromLTRB(0.0, 0.0, 30.0, 40.0),
                    child: IconButton(
                        onPressed: () {
                          this._controller.changeLatLng(LatLng(
                              double.parse(_responseData.lat),
                              double.parse(_responseData.longs)));
                          this._controller.setZoomLevel(17);
                        },
                        icon: Image.asset("images/locaiton1.png"))),
              ],
            )));
  }
}
