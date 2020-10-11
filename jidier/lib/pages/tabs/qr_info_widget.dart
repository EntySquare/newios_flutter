
import 'package:amap_map_fluttify/amap_map_fluttify.dart';
import 'package:flutter/material.dart';
import 'package:myflutter/pages/bean/AdressDataBean.dart';
import 'package:myflutter/pages/util/SystemUtil.dart';

/*二维码详情页面*/
class QrInfoWidget extends StatefulWidget {
  ResponseData responseData;

  QrInfoWidget({Key key, this.responseData}) : super(key: key);

  @override
  _QrInfoWidgetState createState() => _QrInfoWidgetState(responseData);
}

class _QrInfoWidgetState extends State<QrInfoWidget> {
  ResponseData _responseData;
    AmapController _controller;

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
              AmapView(
                onMapCreated:(controller){
                  this._controller=controller;
                  var latLnt= LatLng(double.parse(_responseData.lat),double.parse(_responseData.longs));
                  this._controller.setCenterCoordinate(latLnt);
                   this._controller.setZoomLevel(17);
                  this._controller.addMarker(MarkerOption(latLng: latLnt,iconProvider:AssetImage('images/2.0x/ic_red_location.png')));
                },
                showCompass:false,
              ),

               Padding(
                   padding: EdgeInsets.fromLTRB(0.0, 0.0, 30.0, 40.0),
                   child: IconButton(
                       onPressed: () {
                         var latLnt= LatLng(double.parse(_responseData.lat),double.parse(_responseData.longs));
                         this._controller.setCenterCoordinate(latLnt);
                         this._controller.setZoomLevel(17);
                       },
                       icon: Image.asset("images/locaiton1.png"))),
              ],
            )));
  }
}
