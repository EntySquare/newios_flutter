import 'package:flutter/material.dart';
import 'package:myflutter/pages/bean/NowLatLng.dart';
import 'package:myflutter/pages/dialog/packing_dialog.dart';
import 'package:myflutter/pages/util/DiatanceUtil.dart';
import 'package:myflutter/pages/util/GoWaysUtil.dart';
import 'package:myflutter/pages/util/LocationDataUtil.dart';
import 'package:myflutter/pages/util/SharedPreferencesUtil.dart';
import 'package:myflutter/pages/util/Toast.dart';
import 'package:myflutter/pages/widget/MyFlutterRadioButtonGroup.dart';
import 'package:myflutter/main.dart';
import 'package:myflutter/pages/bean/AdressDataBean.dart';
/*导航弹窗*/

class NavigationDialog extends StatefulWidget {
  String address;
  double lat;
  double long;
  bool isShowParking;

  NavigationDialog(
      {Key key, this.address, this.lat, this.long, this.isShowParking})
      : super(key: key);

  @override
  _NavigationDialogState createState() =>
      _NavigationDialogState(address, lat, long, isShowParking);
}

class _NavigationDialogState extends State<NavigationDialog> {
  String _address;
  double _lat;
  double _long;
  int defaultWay; //默认出行方式
  bool _isInstallGaode = false;

  // bool _isInstallBaidu = false;
  bool _isInstallTenxun = false;
  bool _isInstallGoogle = true;
  bool _isShowParking = true;

  _NavigationDialogState(
      String address, double lat, double long, bool isShowParking) {
    this._address = address;
    this._lat = lat;
    this._long = long;
    this._initMapsData();
    if (isShowParking != null) {
      this._isShowParking = isShowParking;
    }
  }

  /*实例化地图数据*/
  _initMapsData() async {
    var gaode = await MyApp.platform.invokeMethod("installGaoDe");
    //var baidu = await MyApp.platform.invokeMethod("installBaiDu");
    var tenxun = await MyApp.platform.invokeMethod("installTenXun");
    var google = await MyApp.platform.invokeMethod("installGoogle");

    setState(() {
      this._isInstallGaode = gaode == "true" ? true : false;
      //this._isInstallBaidu = baidu=="true"?true:false;
      this._isInstallTenxun = tenxun == "true" ? true : false;
      this._isInstallGoogle = google == "true" ? true : false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Future<int> future = GoWaysUtil.getGoWay();
    future.then((way) {
      this.defaultWay = way ?? 0;
    });
    double distance = -1;
    if (LocationDataUtil.nowlocation != null) {
      distance = DiatanceUtil.getDistance(LocationDataUtil.nowlocation.lng,
          LocationDataUtil.nowlocation.lat, this._long, this._lat);
    }
    return GestureDetector(
      child: Material(
          type: MaterialType.transparency,
          child: Padding(
            padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                GestureDetector(
                  child: Container(
                    alignment: Alignment.center,
                    child: Container(
                      alignment: Alignment.center,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 0.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  width: 30.0,
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    "导航至--$_address",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                                GestureDetector(
                                  child: Padding(
                                    padding:
                                        EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),
                                    child: Image.asset(
                                      "images/ic_closed.png",
                                      width: 25.0,
                                      height: 25.0,
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            ),
                          ),

                          Text(
                            distance == -1 ? "距离您-未知" : "距离您-$distance千米",
                            style: TextStyle(color: Colors.red, fontSize: 14.0),
                          ),
                          Container(
                            height: 3.0,
                          ),
                          MyFlutterRadioButtonGroup(
                            items: ["驾车", "公交", "步行"],
                            onSelected: (select) {
                              if (select == "驾车") {
                                GoWaysUtil.saveGoWay(0);
                                this.defaultWay = 0;
                              } else if (select == "公交") {
                                GoWaysUtil.saveGoWay(1);
                                this.defaultWay = 1;
                              } else if (select == "步行") {
                                GoWaysUtil.saveGoWay(2);
                                this.defaultWay = 2;
                              }
                            },
                            defaultIndex: this.defaultWay,
                          ),
                          this._getNearbyPacking(),
                          Padding(
                            padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 0.0),
                            child: this._getMapItem(0),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 0.0),
                            child: this._getMapItem(1),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 20.0),
                            child: this._getMapItem(2),
                          ),
//                          Padding(
//                            padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 20.0),
//                            child: this._getMapItem(3),
//                          ),
                        ],
                      ),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.all(Radius.circular(20.0))),
                    ),
                  ),
                  onTap: () {},
                ),
              ],
            ),
          )),
      onTap: () {
        Navigator.pop(context);
      },
    );
  }

  /*获得附近停车场功能*/
  Widget _getNearbyPacking() {
    if (!this._isShowParking) {
      return Container(
        width: 0,
        height: 0,
      );
    }

    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          GestureDetector(
            child: Image.asset(
              "images/ico_packing.png",
              width: 30.0,
              height: 30.0,
            ),
            onTap: this._showParkingDialog,
          ),
          Container(
            width: 8.0,
            height: 2.0,
            color: Color(0xff099688),
          ),
          GestureDetector(
            child: Text(
              "查看附近1000米内停车场",
              style: TextStyle(
                color: Color(0xff099688),
                fontSize: 14.0,
              ),
            ),
            onTap: this._showParkingDialog,
          )
        ],
      ),
    );
  }

  /*显示附近停车场弹窗*/
  void _showParkingDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          ResponseData responseData = ResponseData(
            describe: this._address,
            lat: "$_lat",
            longs: "$_long",
          );
          return PackingDialog(
            responseData: responseData,
          );
        });
  }

  /*state 表示是那种地图 0 高德，1 腾讯 ，2 map*/
  Widget _getMapItem(int state) {
    String icPath = ""; //地图图标
    bool isInit = false; //是否安装此地图
    String mapName = ""; //地图名字
    switch (state) {
      case 0:
        icPath = "images/ic_gaode.png";
        mapName = "高德地图";
        isInit = this._isInstallGaode;
        break;
//      case 1:
//        icPath = "images/ic_baidu.png";
//        mapName = "百度地图";
//        isInit = this._isInstallBaidu;
//        break;
      case 1:
        icPath = "images/ic_tengxun.png";
        mapName = "腾讯地图";
        isInit = this._isInstallTenxun;
        break;
      case 2:
        icPath = "images/ios_ico.png";
        mapName = "地图";
        isInit = this._isInstallGoogle;
        break;
    }
    return Container(
      alignment: Alignment.center,
      color: isInit ? Color(0xffffffff) : Color(0xffeeeeee),
      child: Padding(
        padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Image.asset(
                  icPath,
                  height: 40.0,
                  width: 40.0,
                  fit: BoxFit.cover,
                ),
                Container(
                  width: 5.0,
                ),
                Text(
                  isInit ? "" : "未安装",
                  style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.red,
                      fontWeight: FontWeight.w700),
                )
              ],
            ),
            Expanded(
              flex: 1,
              child: Text(
                mapName,
                style: TextStyle(color: Colors.black, fontSize: 16.0),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
//            GestureDetector(
//              child: Container(
//                alignment: Alignment.center,
//                child: Padding(
//                  padding: EdgeInsets.fromLTRB(10.0, 3.0, 10.0, 3.0),
//                  child: Text(
//                    "导航",
//                    style: TextStyle(
//                        fontSize: 14.0,
//                        color: Colors.white,
//                        fontWeight: FontWeight.w700),
//                  ),
//                ),
//                decoration: BoxDecoration(
//                    color: isInit ? Color(0xff00afaf) : Colors.grey,
//                    borderRadius: BorderRadius.all(Radius.circular(20.0))),
//              ),
//              onTap: () {
//                if (isInit) {
//                  //如果安装了地图 就执行相关操作
//                  _navigater(state);
//                } else {
//                  Toast.toast(context, msg: "请先安装-$mapName");
//                }
//              },
//            ),

            Container(
              child: RaisedButton(
                  onPressed: () {
                    if (isInit) {
                      //如果安装了地图 就执行相关操作
                      _navigater(state);
                    } else {
                      Toast.toast(context, msg: "请先安装-$mapName");
                    }
                  },
                  child: Text(
                    "导航",
                    style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  color: Color(0xff00afaf),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)))),
            )
          ],
        ),
      ),
    );
  }

  _navigater(int wichMap) {
    _saveNagitonHistroty();
    switch (wichMap) {
      case 0: //高德地图
        if (NowLatLng.lat != 0) {
          MyApp.platform.invokeMethod("openGaode", [
            defaultWay,
            this._address,
            NowLatLng.lat,
            NowLatLng.lng,
            this._lat,
            this._long
          ]);
        } else {
          Toast.toast(context, msg: "请打开GPS定位权限", showTime: 1500);
        }
        break;
//      case 1: //百度地图
//        if (NowLatLng.lat != 0) {
//          MyApp.platform.invokeMethod("openBaidu", [
//            defaultWay,
//            this._address,
//            NowLatLng.lat,
//            NowLatLng.lng,
//            this._lat,
//            this._long
//          ]);
//        } else {
//          Toast.toast(context, msg: "请打开GPS定位权限", showTime: 1500);
//        }
//        break;
      case 1: //腾讯地图
        MyApp.platform.invokeMethod("openTenxun", [
          defaultWay,
          this._address,
          NowLatLng.lat,
          NowLatLng.lng,
          this._lat,
          this._long
        ]);
        break;
      case 2: //苹果 地图
        MyApp.platform.invokeMethod("openMap", [
          defaultWay,
          this._address,
          NowLatLng.lat,
          NowLatLng.lng,
          this._lat,
          this._long
        ]);
        break;
    }
  }

  /*保存导航历史记录*/
  _saveNagitonHistroty() {
    SharedPreferencesUtil.saveNavigationHistory(
        this._address, "$_lat", "$_long");
  }
}
