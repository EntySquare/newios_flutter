import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:myflutter/pages/bean/AmbitusAdressBean.dart';
import 'package:myflutter/pages/bean/LoginBean.dart';
import 'package:myflutter/pages/bean/NetAddressBean.dart';
import 'package:myflutter/pages/bean/NowLatLng.dart';
import 'package:myflutter/pages/bean/SelectAddressBean.dart';
import 'package:myflutter/pages/dialog/NetLoadingDialog3.dart';
import 'package:myflutter/pages/dialog/navigation_dialog.dart';
import 'package:myflutter/pages/dialog/record_address_dialog.dart';
import 'package:myflutter/pages/dialog/record_sucessful_dialog.dart';
import 'package:myflutter/pages/util/DataUtil.dart';
import 'package:myflutter/pages/util/HttpContent.dart';
import 'package:myflutter/pages/util/LocationDataUtil.dart';
import 'package:myflutter/pages/util/LoginUtil.dart';
import 'package:myflutter/pages/util/NetUtil.dart';
import 'package:myflutter/pages/util/PlayUtil.dart';
import 'package:myflutter/pages/util/SharedPreferencesUtil.dart';
import 'package:myflutter/pages/util/SystemUtil.dart';
import 'package:myflutter/pages/util/Toast.dart';
import 'package:sensors/sensors.dart';
import 'package:amap_map_fluttify/amap_map_fluttify.dart';

/*搜索地图界面*/
class SearchMapWidget extends StatefulWidget {
  LatLng latLng;

  SearchMapWidget({Key key, this.latLng}) : super(key: key);

  @override
  _SearchMapWidgetState createState() => _SearchMapWidgetState(latLng);
}

class _SearchMapWidgetState extends State<SearchMapWidget> {
  LatLng _latLng;
  LatLng _newLatLng;
  LatLng _centerLatLng;
  AmapController _controller;
  String _searchContent = "请输入地址搜索";
  bool isCanShake = false;
  bool isHasSound = true;
  List<Marker> marks = List();

  _SearchMapWidgetState(latLng) {
    this._latLng = latLng;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
  }

  /*摇晃手机没有声音记录地址*/
  _shakeRecordAddressNoSoun() {
    _shakeGetNowAddressInfo();
  }

  _shakeGetNowAddressInfo() {
    if(NowLatLng.lat==null||NowLatLng.lat==0){
      Toast.toast(context,msg:"未获得当前位置信息，请检查是否开启定位权限!",showTime:2000);
      return;
    }
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
    //LatLng centerLat = await this._controller.getCenterLatlng();

    NetAddressBean netAddressBean = NetAddressBean();
    int nowTime = DataUtil.currentTimeMillis();
    netAddressBean.describe =
        _searchContent == "请输入地址搜索" ? "新建地址$nowTime" : _searchContent;
    netAddressBean.remark = "0";
    netAddressBean.kind = "摇摇记";
    netAddressBean.address = address;
//    netAddressBean.addressLocation =
//        "${centerLat.longitude}" + "," + "${centerLat.latitude}";
    netAddressBean.atendLocation = "0";
    netAddressBean.path1 = "0";
    netAddressBean.path2 = "0";
    netAddressBean.path3 = "0";
//    netAddressBean.longs = "${centerLat.longitude}";
//    netAddressBean.lat = "${centerLat.latitude}";
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
          PlayUtil.playStart("faild.mp3");
        }
      } else {
        NetUtil.ifNetSuccessful(response, successfull: (responseBean) {
          Toast.toast(context, msg: "记录成功");
          if (isHasSound) {
            PlayUtil.playStart("successful.mp3");
          }
        }, faild: (responseBean) {
          Toast.toast(context, msg: "记录失败");
          if (isHasSound) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          child: AppBar(
            title: Text(
              "搜索记录",
              style: TextStyle(color: Colors.white, fontSize: 16.0),
            ),
            backgroundColor: Color(0xff00afaf),
            centerTitle: true,
          ),
          preferredSize:
              Size.fromHeight(SystemUtil.getScreenSize(context).height * 0.07)),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[getMapWidget(), getBottomWidget()],
      ),
    );
  }

  /*获得地图控件*/
  Widget getMapWidget() {
    return Padding(
        padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 110.0),
        child: Listener(
            onPointerDown: (downPointerEvent) {
              print("触摸按下事件");
            },
            onPointerUp: (upPointerEvent) {
              print("触摸抬起");
            },
            child: Stack(alignment: Alignment.topCenter, children: <Widget>[
              Stack(
                alignment: Alignment.bottomRight,
                children: <Widget>[
                  Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      // AMapView(
                      //   onAMapViewCreated: (controller) {
                      //     this._controller = controller;
                      //   },
                      //   amapOptions: AMapOptions(
                      //     compassEnabled: false,
                      //     mapType: MAP_TYPE_NORMAL,
                      //     zoomControlsEnabled: true,
                      //     logoPosition: LOGO_POSITION_BOTTOM_CENTER,
                      //     camera: CameraPosition(
                      //         target: _newLatLng == null ? _latLng : _newLatLng,
                      //         zoom: 17),
                      //   ),
                      // ),
                      AmapView(
                        onMapCreated: (controller) async {
                          this._controller = controller;
                          if (_latLng != null) {
                            await this
                                ._controller
                                .setCenterCoordinate(this._latLng);
                            await this._controller.setZoomLevel(17);
                          }
                          this._controller.setMapMoveListener(
                              onMapMoveEnd: (mapMove) {
                            this._centerLatLng = mapMove.latLng;
                            if (marks.length != 0) {
                              this._controller.clearMarkers(marks);
                            }
                            this
                                ._controller
                                .addMarker(MarkerOption(
                                    latLng: _centerLatLng,
                                    iconProvider: AssetImage(
                                        'images/2.0x/ico_end_marker.png')))
                                .then((marker) {
                              marks.add(marker);
                            });
                          });
                        },
                        showCompass: false,
                      ),
                      Image.asset("images/ic_red_location.png"),

                      Positioned(
                        bottom: 40.0,
                        right: 30.0,
                        child: GestureDetector(
                          onTap: () {
                            if (_newLatLng != null) {
                              this
                                  ._controller
                                  .setCenterCoordinate(this._newLatLng);
                            } else {
                              this
                                  ._controller
                                  .setCenterCoordinate(this._latLng);
                            }
                            this._controller.setZoomLevel(17);
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
                        top: 20.0,
                        left: 10.0,
                        right: 10.0,
                        child: GestureDetector(
                          onTap: () {
                            // print("点击跳转搜索界面");
                            this._jumpSearchContentWidget();
                            // ImagePicker.pickImage(source: ImageSource.gallery);
                          },
                          child: Container(
                            height: 40.0,
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(10.0, 0.0, 5.0, 0.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Icon(
                                    Icons.search,
                                    color: Color(0xff333333),
                                  ),
                                  Expanded(
                                      flex: 1,
                                      child: Text(
                                        this._searchContent,
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            color: Color(0xff333333),
                                            fontWeight: FontWeight.bold),
                                      )),
                                  IconButton(
                                      icon: Icon(
                                        Icons.cancel,
                                        color: Color(0xff333333),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          this._searchContent = "请输入地址搜索";
                                          this._newLatLng = null;
                                        });
                                        this
                                            ._controller
                                            .setCenterCoordinate(_latLng);
                                        this._controller.setZoomLevel(17);
                                      })
                                ],
                              ),
                            ),
                            decoration: BoxDecoration(
                                color: Color(0x99888888),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0))),
                          ),
                        ),
                      )
                    ],
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
                //  ),
              )
            ])));
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
          onTap: () {
            LoginUtil.ifLogin(login: (LoginBean loginBean) {
              //如果已登录 ，弹出记录地址弹出
              //this._showRecordAddressDialog();
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
        Positioned(
          child: GestureDetector(
            child: Padding(
              padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
              child: Image.asset(
                "images/ic_blue_navigation.png",
                width: 40.0,
                height: 40.0,
              ),
            ),
            onTap: this._jumpNavigation,
          ),
          right: 30.0,
          bottom: 20.0,
        )
      ],
    );
  }

/*跳转到导航地址界面*/
  _jumpNavigation() async {
    String address =
        this._searchContent.contains("请输入地址") ? "当前地址" : this._searchContent;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return NavigationDialog(
            address: address,
           lat: _centerLatLng.latitude,
           long: _centerLatLng.longitude,
            isShowParking: true,
          );
        });
  }

  /*点击跳转到搜索内容界面*/
  _jumpSearchContentWidget() {
   Navigator.pushNamed(context, '/searchContentWidget', arguments: _latLng)
       .then((tap) {
     if (tap != null) {
       SelectAddressBean bean = tap;
       //Toast.toast(context, msg: bean.name);
       setState(() {
         this._searchContent = bean.name;
         this._newLatLng = LatLng(bean.lat, bean.lng);
       });
       this._controller.setCenterCoordinate(_newLatLng);
       this._controller.setZoomLevel(17);
     }
   });
  }

  _netGetNowAddressInfo() {
    if(NowLatLng.lat==null||NowLatLng.lat==0){
      Toast.toast(context,msg:"未获得当前位置信息，请检查是否开启定位权限!",showTime:2000);
      return;
    }
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

    try {
      Response response =
          await Dio().get(MAP_URL + "v3/geocode/regeo?", queryParameters: {
        "output": "json",
         "location": "${_centerLatLng.longitude}" + "," + "${_centerLatLng.latitude}",
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
  _showRecordAddressDialog(String address) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          NetAddressBean netAddressBean = NetAddressBean();
          int nowTime = DataUtil.currentTimeMillis();
          netAddressBean.describe =
              _searchContent == "请输入地址搜索" ? "新建地址$nowTime" : _searchContent;
          netAddressBean.remark = "0";
          netAddressBean.kind = "随心记";
          netAddressBean.address = address;
         netAddressBean.addressLocation =
             "${_centerLatLng.longitude}" + "," + "${_centerLatLng.latitude}";
          netAddressBean.atendLocation = "0";
          netAddressBean.path1 = "0";
          netAddressBean.path2 = "0";
          netAddressBean.path3 = "0";
         netAddressBean.longs = "${_centerLatLng.longitude}";
         netAddressBean.lat = "${_centerLatLng.latitude}";
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
          break;
        case 1: //跳转到地址列表界面
          Navigator.pop(context, 1);
          break;
      }
    });
  }
}
