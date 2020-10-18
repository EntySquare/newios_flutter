import 'dart:async';
import 'dart:convert';
import 'package:amap_map_fluttify/amap_map_fluttify.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myflutter/main.dart';
import 'package:myflutter/pages/bean/AdressDataBean.dart' as addressBean;
import 'package:myflutter/pages/bean/AmbitusAdressBean.dart';
import 'package:myflutter/pages/bean/FindAdrBean.dart';
import 'package:myflutter/pages/bean/LoginBean.dart';
import 'package:myflutter/pages/bean/NetAddressBean.dart';
import 'package:myflutter/pages/bean/NowLatLng.dart';
import 'package:myflutter/pages/bean/ResponseBean.dart';
import 'package:myflutter/pages/bean/ResponseBean2.dart';
import 'package:myflutter/pages/dialog/NetLoadingDialog.dart';
import 'package:myflutter/pages/dialog/NetLoadingDialog3.dart';
import 'package:myflutter/pages/dialog/mc_notice_dialog.dart';
import 'package:myflutter/pages/dialog/packing_dialog.dart';
import 'package:myflutter/pages/dialog/record_address_dialog.dart';
import 'package:myflutter/pages/dialog/record_sucessful_dialog.dart';
import 'package:myflutter/pages/dialog/scan_dialog.dart';
import 'package:myflutter/pages/drawer/SmartDrawer.dart';
import 'package:myflutter/pages/menu/LeftSideWidget.dart';
import 'package:myflutter/pages/util/DataUtil.dart';
import 'package:myflutter/pages/util/HttpContent.dart';
import 'package:myflutter/pages/util/LocationDataUtil.dart';
import 'package:myflutter/pages/util/LoginUtil.dart';
import 'package:myflutter/pages/util/NetUtil.dart';
import 'package:myflutter/pages/util/PlayUtil.dart';
import 'package:myflutter/pages/util/SharedPreferencesUtil.dart';
import 'package:myflutter/pages/util/StringUtil.dart';
import 'package:myflutter/pages/util/Toast.dart';
import 'package:permission_handler/permission_handler.dart' as mypermission;
import 'package:sensors/sensors.dart';
import 'NowLocation.dart';
import 'package:location/location.dart'as mylocation;
class LocationWidget extends StatefulWidget {
  Function mm;
  static _locationWidgetState locationWidgetState;

  LocationWidget({Key key, this.mm}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    locationWidgetState = _locationWidgetState(mm);
    return locationWidgetState;
  }
}

class _locationWidgetState extends State<LocationWidget>
    with AutomaticKeepAliveClientMixin {
  Function mm1;
  String _phone = "";

  // AMapController _controller;
  AmapController _controller;
  LeftSideWidget _leftSideWidget;
  double lat = 0;
  double lng = 0;
  bool ifFirstIn = true;
  bool isCanShake = false;
  bool isHasSound = true;

  //final _amapLoction = AMapLocation(); //定位
  EventChannel _eventChannel;
  String strParkingNotice = "当\n前\n位\n置\n一\n千\n米\n内\n停\n车\n场";
  int _messageNum = 0;
   List<Marker> markers= List<Marker>();
  _locationWidgetState(this.mm1) {
    _leftSideWidget = new LeftSideWidget(
      phone: this._phone,
      jump: (state) {
        switch (state) {
          case 0:
            this.mm1(0);
            break;
          case 1:
            this.mm1(1);
            break;
        }
      },
    );
    lat= NowLatLng.lat;
    lng= NowLatLng.lng;
  }

  @override
  void initState() {
    // TODO: implement initState
    _eventChannel = EventChannel('mc');
    // AMap.init('30451939c0a123dfb05d9ae6b7c00b1f');
   // this._getLocation();
    _eventChannel.receiveBroadcastStream().listen((msg) {
      if (msg == null) {
        String content = "0";
        DataUtil.mcMsg = content;
        this.setState(() {});
      } else {
        String content = msg;
        if (content.contains("id=")) {
          content = StringUtil.getWeakResultStr(content);
          DataUtil.mcMsg = content;
          this.setState(() {});
        }
      }

//      String content = msg;
//      print("--mlink--" + content);
//      if (content != null) {
//        if (content.contains("id=")) {
//          content = StringUtil.getWeakResultStr(content);
//          DataUtil.mcMsg = content;
//          this.setState(() {});
//        }
//      }
    }, onError: (err) {
      print("错误消息$err");
    });
    updateData();
    //手机添加摇一摇检测
    accelerometerEvents.listen((AccelerometerEvent event) async {
      int value = 20;
      if (event.x >= value ||
          event.x <= -value ||
          event.y >= value ||
          event.y <= -value ||
          event.z >= value ||
          event.z <= -value) {
        if (isCanShake) {
          int stateSound = await SharedPreferencesUtil.getSoundState();
          if (stateSound == null || stateSound == 0) {
            isHasSound = true;
          } else {
            isHasSound = false;
          }

          if (isHasSound) {
            // print("------------------------要啊摇");
            if (isCanShake) {
              setState(() {
                isCanShake = false;
              });
              LoginUtil.ifLogin(login: (LoginBean loginBean) {
                if (LocationDataUtil.nowlocation == null) {
                  PlayUtil.playStart("nolocation.mp3");
                  return;
                }

                PlayUtil.playStart("start.mp3");
                _shakeGetNowAddressInfo();
              }, unLogin: (LoginBean loginBean) {
                PlayUtil.playStart("firstlogin.mp3");
              });
            }
          } else {
            //没有声音
            LoginUtil.ifLogin(login: (LoginBean loginBean) {
              setState(() {
                isCanShake = false;
              });
              _shakeRecordAddressNoSoun();
            }, unLogin: (LoginBean loginBean) {
              setState(() {
                isCanShake = false;
              });
              Navigator.pushNamed(context, "/login");
            });
          }
        }
      }
    });
    this._netGetIpaddress(0);
    super.initState();
  }
  var locationData;
  var location=  new mylocation.Location();
  @override
  /*定位 获取当前位置*/
  getLocation() async {
    if (await requestPermission()) {
      bool _serviceEnabled;
      _serviceEnabled = await location.serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await location.requestService();
        if (!_serviceEnabled) {
          return;
        }
      }
      if(locationData==null){
       locationData= await location.getLocation();
       this.lat=locationData.latitude;
       this.lng=locationData.longitude;
      }
      await this._controller.setCenterCoordinate(LatLng(lat,lng));
      await this._controller.setZoomLevel(17);
      location.onLocationChanged.listen((mylocation.LocationData currentLocation) async {
        this.lat=currentLocation.latitude;
        this.lng=currentLocation.longitude;
        NowLatLng.lat=currentLocation.latitude;
        NowLatLng.lng=currentLocation.longitude;
         this._controller.clearMarkers(markers);
          markers.clear();
        this._controller.addMarker(MarkerOption(latLng:LatLng(lat,lng),iconProvider:AssetImage('images/ico_red_location.png')))
            .then((marker) =>markers.add(marker));
      });

    }

  }
  updatePosition1(inLat,inLng) async{
    this.lat=inLat;
    this.lng=inLng;
    await this._controller.setCenterCoordinate(LatLng(lat,lng));
    await this._controller.setZoomLevel(17);
    if(LocationDataUtil.nowlocation==null){
    LocationDataUtil.nowlocation= NowLocation();}
    LocationDataUtil.nowlocation.lat=this.lat;
    LocationDataUtil.nowlocation.lng=this.lng;
  }
  updatePosition2(inLat,inLng) async{
    this.lat=inLat;
    this.lng=inLng;
    NowLatLng.lat=inLat;
    NowLatLng.lng=inLng;
    if(markers.length!=0&&context!=null){
    this._controller.clearMarkers(markers);
    markers.clear();
    this._controller.addMarker(MarkerOption(latLng:LatLng(lat,lng),iconProvider:AssetImage('images/ico_red_location.png')))
        .then((marker) =>markers.add(marker));
    }
    if(LocationDataUtil.nowlocation==null){
      LocationDataUtil.nowlocation= NowLocation();
    }
    LocationDataUtil.nowlocation.lat=this.lat;
    LocationDataUtil.nowlocation.lng=this.lng;
  }


  Future<bool> requestPermission() async {
    final permissions = await mypermission.PermissionHandler()
        .requestPermissions([mypermission.PermissionGroup.location]);

    if (permissions[mypermission.PermissionGroup.location] ==mypermission.PermissionStatus.granted) {
      return true;
    } else {
      Toast.toast(context, msg: '需要定位权限');
      return false;
    }
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    // if (DataUtil.mcMsg != "") {
    //   if (DataUtil.mcMsg == "0") {
    //     Timer(Duration(milliseconds: 500), () {
    //       _showMcNoticeDialog();
    //     });
    //   } else {
    //     String myMsg = DataUtil.mcMsg;
    //     Timer(Duration(milliseconds: 500), () {
    //       _showMcFindAdrDialog(jsonDecode(myMsg), myMsg);
    //     });
    //   }
    //   DataUtil.mcMsg = "";
    // }
    SharedPreferencesUtil.getSoundState().then((state) {
      if (state == null || state == 0) {
        isHasSound = true;
      } else {
        isHasSound = false;
      }
    });

    return Scaffold(
      appBar: PreferredSize(
        child: AppBar(
          title: Image.asset(
            'images/main_title.png',
            height: 25.0,
          ),
          backgroundColor: Colors.white,
          leading: Builder(builder: (context) {
            return GestureDetector(
              onTap: () {
                LoginUtil.ifLogin(login: (LoginBean loginBean) {
                  Scaffold.of(context).openDrawer();
                }, unLogin: (LoginBean loginBean) {
                  Navigator.pushNamed(context, '/login');
                });
              },
              child: Stack(
                alignment: Alignment.topLeft,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
                    child: Image.asset(
                      "images/ic_my_head.png",
                      height: 35.0,
                      width: 35.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Visibility(
                    child: ifShowRedPoit(),
                    visible: _messageNum == 0 ? false : true,
                  )
                ],
              ),
            );
          }),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.grey,
                size: 35.0,
              ),
              onPressed: () {
                // print("点击了搜索");
                this._jumpSearchMapWidget();
              },
            ),
          ],
        ),
        preferredSize: Size.fromHeight(50),
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          getMapWidget(),
          getBottomWidget(),
          Positioned(
              top: 40.0,
              left: 5.0,
              child: Container(
                  alignment: Alignment.topCenter,
                  child: GestureDetector(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                      child: Column(
                        children: <Widget>[
                          Image.asset(
                            "images/mark_adress.png",
                            width: 25.0,
                            height: 25.0,
                          ),
                          Container(
                            color: Colors.red,
                            width: 2,
                            height: 10,
                          ),
                          Text(
                            strParkingNotice,
                            style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.red,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                    onTap: this._showParkingDialog,
                  ))),
        ],
      ),
      drawer: Container(
        width: 280.0,
        child: SmartDrawer(
          child: LeftSideWidget(
            phone: this._phone,
            jump: (state) {
              switch (state) {
                case 0:
                  this.mm1(0);
                  break;

                case 1:
                  this.mm1(1);
                  break;
              }
            },
          ), //_leftSideWidget,
          callback: (isOpen) {
            //监听侧滑菜单 是否打开
            //updateData();
            if (!isOpen) {
              updateData();
            }
          },
        ),
      ),
    );
  }

  _setNumberMessage() {
    setState(() {
      this._messageNum = 3;
    });
//    updateData();
  }

  Widget ifShowRedPoit() {
    return Padding(
      padding: EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 0.0),
      child: Container(
        child: Padding(
          padding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
          child: Text(
            '$_messageNum',
            style: TextStyle(fontSize: 10.0, color: Colors.white),
          ),
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0), color: Colors.red),
      ),
    );
  }

  void _showParkingDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          addressBean.ResponseData responseData = addressBean.ResponseData(
              describe: "当前位置", lat: "$lat", longs: "$lng");
          return PackingDialog(
            responseData: responseData,
          );
        });
  }

  Widget getMapWidget() {
    return Padding(
        padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 110.0),
        child: Listener(
          onPointerDown: (downPointerEvent) {
            // print("触摸按下事件");
          },
          onPointerUp: (upPointerEvent) {
            // print("触摸抬起");
          },
          child: Stack(
            alignment: Alignment.bottomRight,
            children: <Widget>[
              Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  AmapView(
                    onMapCreated: (controller) async {
                      this._controller = controller;
                      await this._controller.showCompass(false);
                      if(lat!=0){
                      await this._controller.setCenterCoordinate(LatLng(lat,lng));
                      await this._controller.setZoomLevel(17);
                     this._controller.addMarker(MarkerOption(latLng:LatLng(lat,lng),iconProvider:AssetImage('images/ico_red_location.png')))
                          .then((marker) =>markers.add(marker));
                      }
                    },
                  )

//                  AMapView(
//                    onAMapViewCreated: (controller) {
//                      this._controller = controller;
//                    },
//                    amapOptions: AMapOptions(
// //                      compassEnabled: false,
// //                      mapType: MAP_TYPE_NORMAL,
// //                      zoomControlsEnabled: true,
// //                      logoPosition: LOGO_POSITION_BOTTOM_CENTER,
// ////                      camera: CameraPosition(
// ////                        target: LatLng(lat,lng),
// ////                        zoom: 17,
// ////                      ),
//                    ),
//                  ),
//                  GestureDetector(
//                    onTap: () {
//                      if (this._controller != null) {
//                        this._controller.getCenterLatlng().then((latLng) {
//                          this._controller.clearMarkers();
//                          MarkerOptions options = MarkerOptions(
//                              position: latLng,
//                              icon: "images/2.0x/ico_end_marker.png");
//                          this._controller.addMarker(options);
//                        });
//                      }
//                    },
//                    child: Image.asset("images/ic_red_location.png"),
//                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0.0, 0.0, 30.0, 40.0),
                child: GestureDetector(
                  onTap: () async {
                    await this._controller.setCenterCoordinate(LatLng(lat,lng));
                    await this._controller.setZoomLevel(17);
                  },
                  child: Image.asset(
                    "images/locaiton1.png",
                    width: 30.0,
                    height: 30.0,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                  bottom: 30.0,
                  right: 130.0,
                  child: GestureDetector(
                    onTapUp: (_) {
                      setState(() {
                        this.isCanShake = false;
                      });
                    },
                    onTapDown: (_) {
                      setState(() {
                        this.isCanShake = true;
                      });
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "按住摇一摇 记地儿",
                          style: TextStyle(
                              fontSize: 16.0,
                              color: isCanShake ? Colors.grey : Colors.red,
                              fontWeight: FontWeight.bold),
                        ),
                        Image.asset(
                          isCanShake
                              ? "images/ic_shake_gry.png"
                              : "images/ic_shake_red.png",
                          width: 50,
                          height: 50,
                        )
                      ],
                    ),
                  ))
            ],
          ),
        ));
  }

  Widget getBottomWidget() {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Container(
          alignment: Alignment.center,
          height: 140.0,
          child: Image.asset(
            "images/map_bottom.png",
            fit: BoxFit.fill,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
        GestureDetector(
          onTap: () async{
            //记录地址按钮
            LoginUtil.ifLogin(login: (LoginBean loginBean) {
              // this._showRecordAddressDialog();
              this._netGetNowAddressInfo();
            }, unLogin: (LoginBean loginBean) {
              Navigator.pushNamed(context, "/login");
            });



          },
          child: Image.asset(
            "images/ic_ji.png",
            width: 60.0,
            height: 60.0,
            fit: BoxFit.cover,
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(200.0, 60.0, 0.0, 0.0),
          child: GestureDetector(
            onTap: () {
              //点击跳转扫描二维码
              LoginUtil.ifLogin(login: (LoginBean loginBean) {
                this._jumpQrcodeWidget(); //跳转到二维码界面
              }, unLogin: (LoginBean loginBean) {
                Navigator.pushNamed(context, "/login");
              });
            },
            child: Image.asset(
              "images/ic_scan_erweima.png",
              width: 35.0,
              height: 35.0,
              fit: BoxFit.cover,
            ),
          ),
        )
      ],
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    // _controller.dispose();
    // AMapLocationClient.shutdown();
    PlayUtil.playRealse();
    super.dispose();
  }

  _netGetNowAddressInfo() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return NetLoadingDialog3(
            loadingText: '请稍后',
            outsideDismiss: true,
            requestCallBack: _netAmbitusAddressByLocation(),
          );
        }).then((response) {
      if (response == null) {
        Toast.toast(context, msg: '网络请求异常，请稍后再试!');
      } else {
        String mm = response.toString();
        AmbitusAdreesBean ambitusAdressBean =
            NetUtil.getAmbitusAdressBean(response.toString());
        _showRecordAddressDialog(ambitusAdressBean.regeocode.formattedAddress);
      }
    });
  }

  Future<Response> _netAmbitusAddressByLocation() async {
    NowLocation nowLocation = LocationDataUtil.nowlocation;
    if (nowLocation == null) {
      Toast.toast(context, msg: '没有获得当前位置信息，请稍后再试!');
      return null;
    }
    try {
      Response response =
          await Dio().get(MAP_URL + "v3/geocode/regeo?", queryParameters: {
        "output": "json",
        "location": "${nowLocation.lng}" + "," + "${nowLocation.lat}",
        "key": "1f3da247686bd27e50db1502dfff7916",
        "radius": "500",
        "extensions": "all"
      });
      return response;
    } catch (e) {
      print(e);
      return null;
    }
  }

  /*记录地址弹窗*/
  _showRecordAddressDialog(String address) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          NetAddressBean netAddressBean = NetAddressBean();
          int nowTime = DataUtil.currentTimeMillis();
          netAddressBean.describe = "新建地址$nowTime";
          netAddressBean.remark = "0";
          netAddressBean.kind = "随心记";
          netAddressBean.address = address;
          netAddressBean.addressLocation = "$lng" + "," + "$lat";
          netAddressBean.atendLocation = "0";
          netAddressBean.path1 = "0";
          netAddressBean.path2 = "0";
          netAddressBean.path3 = "0";
          netAddressBean.longs = "$lng";
          netAddressBean.lat = "$lat";
          return RecordAddressDialog(
            addressBean: netAddressBean,
            confirmCallBack: (NetAddressBean myBean) {
              //记录地址成功界面
              Navigator.pop(context, 1);
              Navigator.pop(context, 1);
            },
          );
        }).then((state) {
      switch (state) {
        case 0:
          break;
        case 1:
          this._showRecordSuccessfulDialog();
          break;
      }
    });
  }

  /*摇晃手机没有声音记录地址*/
  _shakeRecordAddressNoSoun() {
    _shakeGetNowAddressInfo();
  }

  _shakeGetNowAddressInfo() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return NetLoadingDialog3(
            loadingText: '请稍后',
            outsideDismiss: true,
            requestCallBack: _netAmbitusAddressByLocation(),
          );
        }).then((response) {
      if (response == null) {
        Toast.toast(context, msg: '网络请求异常，请稍后再试!');
        if (isHasSound) {
          PlayUtil.playRealse();
          PlayUtil.playStart("faild.mp3");
        }
      } else {
        String mm = response.toString();
        AmbitusAdreesBean ambitusAdressBean =
            NetUtil.getAmbitusAdressBean(response.toString());
        // _showRecordAddressDialog(ambitusAdressBean.regeocode.formattedAddress);

        _shakeRecordAddressDialog(ambitusAdressBean.regeocode.formattedAddress);
      }
    });
  }

  _shakeRecordAddressDialog(String address) async {
    NetAddressBean netAddressBean = NetAddressBean();
    int nowTime = DataUtil.currentTimeMillis();
    netAddressBean.describe = "新建地址$nowTime";
    netAddressBean.remark = "0";
    netAddressBean.kind = "摇摇记";
    netAddressBean.address = address;
    netAddressBean.addressLocation = "$lng" + "," + "$lat";
    netAddressBean.atendLocation = "0";
    netAddressBean.path1 = "0";
    netAddressBean.path2 = "0";
    netAddressBean.path3 = "0";
    netAddressBean.longs = "$lng";
    netAddressBean.lat = "$lat";

    LoginBean loginBean = await LoginUtil.getLoginBean();
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return NetLoadingDialog3(
            loadingText: "请稍后",
            outsideDismiss: false,
            requestCallBack: _netRecordAdress(netAddressBean, loginBean),
          );
        }).then((response) {
      if (response == null) {
        Toast.toast(context, msg: "网络请求超时");
        if (isHasSound) {
          PlayUtil.playRealse();
          PlayUtil.playStart("faild.mp3");
        }
      } else {
        NetUtil.ifNetSuccessful(response, successfull: (responseBean) {
          // Toast.toast(context, msg: "记录成功");
          if (isHasSound) {
            PlayUtil.playRealse();
            PlayUtil.playStart("successful.mp3");
          }
          this.mm1(1);
        }, faild: (responseBean) {
          Toast.toast(context, msg: "记录失败");
          if (isHasSound) {
            PlayUtil.playRealse();
            PlayUtil.playStart("faild.mp3");
          }
        });
      }
    });
  }

  /*网络请求修改地址接口*/
  Future<Response> _netRecordAdress(
      NetAddressBean netAddressBean, LoginBean loginBean) async {
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
      return response;
    } catch (e) {
      return null;
      print(e);
    }
  }

  /*显示扫描二维码弹窗*/
  _showQrRecordAddressDialog(ResponseData responseData) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          NetAddressBean netAddressBean = NetAddressBean();

          netAddressBean.describe = responseData.describe;
          netAddressBean.remark = responseData.remark;
          netAddressBean.kind = responseData.kind;
          netAddressBean.address = responseData.address;
          netAddressBean.addressLocation = responseData.addressLocation;
          netAddressBean.atendLocation = responseData.atendLocation;
          netAddressBean.path1 = responseData.path1;
          netAddressBean.path2 = responseData.path2;
          netAddressBean.path3 = responseData.path3;
          netAddressBean.longs = responseData.longs;
          netAddressBean.lat = responseData.lat;
          return RecordAddressDialog(
            addressBean: netAddressBean,
            state: 1,
            confirmCallBack: (NetAddressBean myBean) {
              //记录地址成功界面
              Navigator.pop(context, 1);
              Navigator.pop(context, 1);
            },
          );
        }).then((state) {
      switch (state) {
        case 0:
          break;
        case 1:
          this._showRecordSuccessfulDialog();
          break;
      }
    });
  }

  /*显示记录成功选择弹窗*/
  _showRecordSuccessfulDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          print("开始弹窗");

          return RecordSucessfulDialog();
        }).then((state) {
      switch (state) {
        case 0: //留在当前页面
          this.mm1(0);
          break;
        case 1: //跳转到地址列表界面
          this.mm1(1);
          break;
      }
    });
  }

  /*跳转到二维码界面，进行扫码*/
  _jumpQrcodeWidget() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return ScanDialog();
        }).then((state) {
      switch (state) {
        case 0:
          break;
        case 1: //显示扫描成功弹窗
          this._showRecordSuccessfulDialog();
          break;
      }
    });
  }

  /*如果唤起魔炼没有获得地址*/
  _showMcNoticeDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return McNoticeDialog(
            content:
                "如需获得二维码地址信息，可通过以下方式\n1,保证记地儿处于登陆状态，并运行在后台,通过微信，支付宝识别二维码唤起记地儿\n2在微信或支付宝中 保存二维码图片到手机本地，通过记地儿识别手机相册中的二维码图片来获得地址信息",
          );
        });
  }

  /*网络请求 开始加载数据*/
  _showMcFindAdrDialog(jsonResult, content) async {
    LoginBean loginBean = await LoginUtil.getLoginBean();
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return NetLoadingDialog(
            loadingText: "获取地址中...",
            outsideDismiss: false,
            requestCallBack: _netMcFindAdr(loginBean, jsonResult),
          );
        }).then((findAdrBean) {
      if (findAdrBean == null) {
        return;
      }
      if (findAdrBean is FindAdrBean) {
        //Toast.toast(context,msg:"有数据了");
        ResponseData responseData = findAdrBean.data.responseData[0];
        this._showQrRecordAddressDialog(responseData);
      }
      if (findAdrBean is ResponseBean) {
        //错误数据
        if (findAdrBean.code == 200 && findAdrBean.data.responseCode == 10001) {
          Navigator.pushNamed(context, "/login", arguments: content)
              .then((content) {
            if (content != null && content != "") {
//              setState(() {
//                this._mcMsg = content;
//              });
            }
          });
        }
      }
    });
  }

  /*网络请求 开始加载数据*/
  _showFindAdrDialog(jsonResult, content) async {
    LoginBean loginBean = await LoginUtil.getLoginBean();
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return NetLoadingDialog(
            loadingText: "获取地址中...",
            outsideDismiss: false,
            requestCallBack: _netFindAdr(loginBean, jsonResult),
          );
        }).then((findAdrBean) {
      if (findAdrBean == null) {
        return;
      }

      if (findAdrBean is FindAdrBean) {
        //Toast.toast(context,msg:"有数据了");
        ResponseData responseData = findAdrBean.data.responseData[0];
        this._showQrRecordAddressDialog(responseData);
      }
      if (findAdrBean is ResponseBean) {
        //错误数据
        if (findAdrBean.code == 200 && findAdrBean.data.responseCode == 10001) {
          Navigator.pushNamed(context, "/login", arguments: content)
              .then((content) {
            if (content != null && content != "") {
//              setState(() {
//                this._mcMsg = content;
//              });
            }
          });
        }
      }
    });
  }

  /*网络请求找到地址二维码*/
  _netMcFindAdr(LoginBean loginBean, jsonResult) async {
    try {
      Response response = await Dio().post(url + 'getAdr',
          data: {"codeId": jsonResult["codeId"], "id": jsonResult["id"]},
          options: Options(headers: {"AUTHORIZATION": loginBean.token}));
      NetUtil.ifNetSuccessful(response,
          successfull: (ResponseBean responseBean) {
        FindAdrBean findAdrBean = NetUtil.getFindAdrBean(response.toString());
        Navigator.pop(context, findAdrBean);
      }, faild: (ResponseBean responseBean) {
        Toast.toast(context, msg: responseBean.data.responseText);
        Navigator.pop(context, responseBean);
      }, context: context);
    } catch (e) {
      print(e);
      Toast.toast(context, msg: "网络请求失败,请检查网络!", showTime: 2000);
      Navigator.pop(context);
    }
  }

  /*网络请求找到地址二维码*/
  _netFindAdr(LoginBean loginBean, jsonResult) async {
    try {
      Response response = await Dio().post(url + 'getAdr',
          data: {"codeId": jsonResult["codeId"], "id": jsonResult["id"]},
          options: Options(headers: {"AUTHORIZATION": loginBean.token}));
      NetUtil.ifNetSuccessful(response,
          successfull: (ResponseBean responseBean) {
        FindAdrBean findAdrBean = NetUtil.getFindAdrBean(response.toString());
        Navigator.pop(context, findAdrBean);
      }, faild: (ResponseBean responseBean) {
        Navigator.pop(context, responseBean);
      });
    } catch (e) {
      print(e);
      Toast.toast(context, msg: "网络请求失败,请检查网络!", showTime: 2000);
      Navigator.pop(context);
    }
  }

  /*跳转到搜索地址记录界面*/
  _jumpSearchMapWidget() {
    LoginUtil.ifLogin(login: (LoginBean loginBean) {
      LatLng jumpLatLng = LatLng(this.lat, this.lng);
     Navigator.pushNamed(context, '/searchMapWidget', arguments: jumpLatLng)
         .then((state) {
       switch (state) {
         case 0:
           this.mm1(0);
           break;
         case 1:
           this.mm1(1);
           break;
       }
     });
    }, unLogin: (LoginBean loginBean) {
      Navigator.pushNamed(context, "/login");
    });
  }

  /*更新数据*/
  updateData() async {
    LoginBean loginBean = await LoginUtil.getLoginBean();
    var myThis = this;
    try {
      Response response = await Dio().post(url + 'getNoReadAlert',
          data: {'phone': loginBean.phone},
          options: Options(headers: {"AUTHORIZATION": loginBean.token},responseType:ResponseType.plain));
      NetUtil.ifNetSuccessful(response, successfull: (ResponseBean2 result) {
        Map map = result.responseData;
        int number = map['countMessage'];
        myThis.setState(() {
          myThis._messageNum = number;
        });
      }, faild: (result) {});
    } catch (e) {
      print(e);
    }
  }

  /*网络请求获取消息数量*/
  _netGetMessageNum() async {
    LoginBean loginBean = await LoginUtil.getLoginBean();
    try {
      Response response = await Dio().post(url + 'getNoReadAlert',
          data: {'phone': loginBean.phone},
          options: Options(headers: {"AUTHORIZATION": loginBean.token},responseType:ResponseType.plain));
      NetUtil.ifNetSuccessful(response, successfull: (ResponseBean2 result) {
        Map map = result.responseData;
        int number = map['countMessage'];
        return number;
      }, faild: (result) {
        return 0;
      });
    } catch (e) {
      print(e);
      return 0;
    }
  }

  var platforms =["http://pv.sohu.com/cityjson","http://pv.sohu.com/cityjson?ie=utf-8","http://ip.chinaz.com/getip.aspx"];

  /**获得当前公网的ip地址{\"cip\": \"221.237.81.198\", \"cid\": \"510100\", \"cname\": \"�Ĵ�ʡ�ɶ���\"};*/
  _netGetIpaddress(int positon) async{
    Response response = await Dio().get(platforms[0], queryParameters: {},options:Options(responseType:ResponseType.plain));
    var result = response;
    String  data= result.data;
      data = data.replaceAll("var returnCitySN = ","");
      data = data.replaceAll(';','');
      var ss = data.split(",");
      data=ss[0];
      ss = data.split(":");
      data = ss[1];
      String ip = jsonDecode(data);
      String phoneName =  await  MyApp.platform.invokeMethod("getPhoneModel");
        phoneName= phoneName.toLowerCase();
       var nameAndIp = "$phoneName|$ip";
      this._netGetWeekData(nameAndIp);
  }

  _netGetWeekData(String nameAndIp) async{
    try {
      Response response = await Dio().post(url + 'notoken/findByIpAdd',
          data: {'ipFilter': nameAndIp},
          options: Options(responseType:ResponseType.plain));
      NetUtil.ifNetWeakSuccessful(response, successfull: (ResponseBean2 result) {
        Map map = result.responseData;
        _showMcFindAdrDialog(map,map.toString());
      }, faild: (result) {

      });
    } catch (e) {
      print(e);

    }


  }


  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
