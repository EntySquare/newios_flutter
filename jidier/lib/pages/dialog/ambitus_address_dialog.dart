import 'package:flutter/material.dart';
import 'package:myflutter/pages/bean/AmbitusAdressBean.dart';
import 'package:myflutter/pages/dialog/navigation_dialog.dart';
import 'package:myflutter/pages/util/HttpContent.dart';
import 'package:myflutter/pages/util/Toast.dart';
import 'package:wheel_chooser/wheel_chooser.dart';

/*选择地址种类弹窗*/
class AmbutisAddressDialog extends StatefulWidget {
  var confirCallBack;
  int defaltPosition;
  AmbitusAdreesBean ambitusAdreesBean;

  AmbutisAddressDialog(
      {Key key,
      this.confirCallBack,
      this.defaltPosition,
      this.ambitusAdreesBean})
      : super(key: key);

  @override
  _AmbutisAddressDialogState createState() => _AmbutisAddressDialogState(
      confirCallBack, defaltPosition, ambitusAdreesBean);
}

class _AmbutisAddressDialogState extends State<AmbutisAddressDialog> {
  var _confirCallBack;
  int _defaltPosition;
  AmbitusAdreesBean _ambitusAdreesBean;
  Pois _pois;

  _AmbutisAddressDialogState(
      confirCallBack, defaltPosition, ambitusAdreesBean) {
    this._confirCallBack = confirCallBack;
    this._defaltPosition = defaltPosition ?? 0;
    this._ambitusAdreesBean = ambitusAdreesBean;

    if (this._ambitusAdreesBean.regeocode.pois.length > 0) {
      this._pois = this._ambitusAdreesBean.regeocode.pois[this._defaltPosition];
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Material(
          type: MaterialType.transparency,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 10.0),
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                      alignment: Alignment.center,
                      height: 250.0,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.all(Radius.circular(20.0))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 0.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  flex: 1,
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      "取消",
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: GestureDetector(
                                    onTap: () {
                                      this._confirCallBack(this._pois);
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      "确定",
                                      style: TextStyle(
                                          color: Color(0xff009898),
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          this.getAdressInfo(),
                          Expanded(
                              flex: 1,
                              child: Stack(
                                alignment: Alignment.centerRight,
                                children: <Widget>[
                                  WheelChooser(
                                    onValueChanged: (content) {
                                      List<Pois> lPois = this
                                          ._ambitusAdreesBean
                                          .regeocode
                                          .pois;
                                      for (int i = 0; i < lPois.length; i++) {
                                        if (lPois[i].name == content) {
                                          this._pois = lPois[i];
                                          break;
                                        }
                                      }
                                    },
                                    datas: this
                                        ._ambitusAdreesBean
                                        .regeocode
                                        .pois
                                        .map((Pois pois) {
                                      return pois.name;
                                    }).toList(),
                                    startPosition: this._defaltPosition,
                                    unSelectTextStyle: TextStyle(
                                        color: Colors.black, fontSize: 16.0,fontWeight:FontWeight.bold),
                                    selectTextStyle: TextStyle(
                                        color: Color(0xff009898),
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  GestureDetector(
                                      onTap: () {
                                        // print("点击了导航按钮");
                                        if (this._pois == null) {
                                          Toast.toast(context,
                                              msg: "没有获取周边地址，无法导航",
                                              showTime: 1500);
                                        } else {
                                          this._showNavigationDialog();
                                        }
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.fromLTRB(
                                            0.0, 0.0, 10.0, 35.0),
                                        child: Container(
                                          alignment: Alignment.center,
                                          height: 30.0,
                                          width: 60.0,
                                          child: Text(
                                            "导航",
                                            style: TextStyle(
                                                fontSize: 18.0,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          decoration: BoxDecoration(
                                              color: Color(0xff009898),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10.0))),
                                        ),
                                      )),
                                ],
                              ))
                        ],
                      ),
                    ),
                  ))
            ],
          )),
    );
  }

  getListWidget() {
    var mykinds = kinds.map((content) {
      return Text(content);
    });
    return mykinds.toList();
  }

  Widget getAdressInfo() {
    AddressComponent addressComponent =
        this._ambitusAdreesBean.regeocode.addressComponent;

    String addressInfo = addressComponent.province +
        "-" +
        addressComponent.district +
        "-" +
        addressComponent.township;
    if (addressComponent.city != null) {
      addressInfo = addressComponent.province +
          "-" +
          addressComponent.city +
          "-" +
          addressComponent.district +
          "-" +
          addressComponent.township;
    }

    return Padding(
      padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
      child: Text(
        addressInfo,
        style: TextStyle(color: Colors.red, fontSize: 14.0),
        textAlign: TextAlign.center,
      ),
    );
  }

  /*显示导航弹窗*/
  _showNavigationDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          List<String> locations = this._pois.location.split(",");
          double long = double.parse(locations[0]);
          double lat = double.parse(locations[1]);
          return NavigationDialog(
            address: this._pois.name,
            long: long,
            lat: lat,
          );
        });
  }
}
