import 'package:flutter/material.dart';
import 'package:myflutter/pages/bean/ItemPlanWayBean.dart';
import 'package:myflutter/pages/bean/PlanWayArgumentsBean.dart';
import 'package:myflutter/pages/dialog/navigation_dialog.dart';
import 'package:myflutter/pages/util/DiatanceUtil.dart';
import 'package:myflutter/pages/bean/LookPlanArgumentsBean.dart';
import 'package:myflutter/pages/util/SharedPreferencesUtil.dart';

/*规划路径结果界面*/
class PlanWayResultWidget extends StatefulWidget {
  PlanWayArgumentsBean planWayArgumentsBean;

  PlanWayResultWidget({Key key, this.planWayArgumentsBean}) : super(key: key);

  @override
  _PlanWayResultWidgetState createState() => _PlanWayResultWidgetState(
      planWayArgumentsBean.startBean,
      planWayArgumentsBean.endBean,
      planWayArgumentsBean.pointsData);
}

class _PlanWayResultWidgetState extends State<PlanWayResultWidget> {
  ItemPlanWayBean _startBean;
  ItemPlanWayBean _endBean;
  List<ItemPlanWayBean> _pointsBean;
  List<ItemPlanWayBean> _resultPoins = List();

  _PlanWayResultWidgetState(this._startBean, this._endBean, this._pointsBean);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _planPoints();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          child: AppBar(
            title: Text(
              "规划结果",
              style: TextStyle(color: Colors.white, fontSize: 18.0),
            ),
            backgroundColor: Color(0xff00afaf),
            centerTitle: true,
            actions: <Widget>[
              RaisedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/mapPlanWayWidget',
                      arguments: _resultPoins);
                },
                child: Text(
                  "地图",
                  style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w700),
                ),
                color: Color(0xff00afaf),
              )
            ],
          ),
          preferredSize: Size.fromHeight(40.0)),
      body: Container(
        color: Color(0xffeeeeee),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 10.0,
            ),
            getMidList(),
            Container(
              height: 10.0,
            )
          ],
        ),
      ),
    );
  }

/*排序路径*/
  void _planPoints() {
    if (_startBean == null) {
      _resultPoins.addAll(_pointsBean);
    } else {
      _resultPoins.add(_startBean);
      _getNearbyPoint(_startBean);
      if (_endBean != null) {
        int lastIndex = _resultPoins.length - 1;
        ItemPlanWayBean lastBean = _resultPoins[lastIndex];
        double tempDistance = DiatanceUtil.getDistance(
            double.parse(lastBean.lng),
            double.parse(lastBean.lat),
            double.parse(_endBean.lng),
            double.parse(_endBean.lat));
        lastBean.beTweenSpace = tempDistance;

        _resultPoins.add(_endBean);
      }
    }
    if (_startBean != null) {
      SharedPreferencesUtil.saveHistoryPlanWay(getResultMaps());
    }
  }

  List<Map> getResultMaps() {
    List<Map> tempMapList = List();
    for (ItemPlanWayBean itemBean in _resultPoins) {
      Map map = Map();
      map['address'] = itemBean.address;
      map['lat'] = itemBean.lat;
      map['lng'] = itemBean.lng;
      map['ifStart'] = itemBean.ifStart;
      map['ifEnd'] = itemBean.ifEnd;
      map['beTweenSpace'] = itemBean.beTweenSpace;
      tempMapList.add(map);
    }

    return tempMapList;
  }

  /*将点排序*/
  void _getNearbyPoint(ItemPlanWayBean inBean) {
    if (_pointsBean.length == 0) {
      return;
    }
    double tempDistance = 0.0;
    ItemPlanWayBean tempBean;
    for (ItemPlanWayBean itemBean in _pointsBean) {
      double countDistacnce = DiatanceUtil.getDistance(
          double.parse(inBean.lng),
          double.parse(inBean.lat),
          double.parse(itemBean.lng),
          double.parse(itemBean.lat));
      if (tempDistance == 0) {
        tempDistance = countDistacnce;
        tempBean = itemBean;
      } else {
        if (countDistacnce < tempDistance) {
          tempDistance = countDistacnce;
          tempBean = itemBean;
        }
      }
    }
    inBean.beTweenSpace = tempDistance;
    _resultPoins.add(tempBean);
    _pointsBean.remove(tempBean);
    _getNearbyPoint(tempBean);
  }

  Widget getMidList() {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
        child: ListView.builder(
          itemBuilder: (BuildContext cotext, int index) {
            return getItem(cotext, index);
          },
          itemCount: _resultPoins.length,
          physics: new AlwaysScrollableScrollPhysics(),
        ),
      ),
      flex: 1,
    );
  }

  Widget getItem(BuildContext context, int indext) {
    ItemPlanWayBean itemBean = _resultPoins[indext];
    if (indext == _resultPoins.length - 1) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10.0)),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 20.0),
                        child: Text(
                          itemBean.address,
                          style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.black,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                      Positioned(
                          right: 0.0,
                          child: IconButton(
                              icon:
                                  Image.asset("images/ic_blue_navigation.png"),
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    barrierDismissible: true,
                                    builder: (_) {
                                      return NavigationDialog(
                                        address: itemBean.address,
                                        lat: double.parse(itemBean.lng),
                                        long: double.parse(itemBean.lat),
                                        isShowParking: true,
                                      );
                                    });
                              }))
                    ],
                  ),
                  flex: 1,
                )
              ],
            ),
          )
        ],
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10.0)),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 20.0),
                        child: Text(
                          itemBean.address,
                          style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.black,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                      Positioned(
                          right: 0.0,
                          child: IconButton(
                              icon:
                                  Image.asset("images/ic_blue_navigation.png"),
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    barrierDismissible: true,
                                    builder: (_) {
                                      return NavigationDialog(
                                        address: itemBean.address,
                                        lat: double.parse(itemBean.lng),
                                        long: double.parse(itemBean.lat),
                                        isShowParking: true,
                                      );
                                    });
                              }))
                    ],
                  ),
                  flex: 1,
                )
              ],
            ),
          ),
          Container(
            color: Color(0xff00afaf),
            height: 20.0,
            width: 2.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0)),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                  child: Row(
                    children: <Widget>[
                      Text(
                        "相距${itemBean.beTweenSpace}千米",
                        style: TextStyle(fontSize: 14.0, color: Colors.black),
                      ),
                      IconButton(
                          icon: Image.asset("images/ico_eye.png"),
                          onPressed: () {
                            LookPlanArgumentsBean lookPlanArgumentsBean =
                                LookPlanArgumentsBean();
                            lookPlanArgumentsBean.startBean =
                                _resultPoins[indext];
                            lookPlanArgumentsBean.endBean =
                                _resultPoins[indext + 1];
                            Navigator.pushNamed(
                                context, '/lookPlanPointsWidget',
                                arguments: lookPlanArgumentsBean);
                          })
                    ],
                  ),
                ),
              )
            ],
          ),
          Container(
            color: Color(0xff00afaf),
            height: 20.0,
            width: 2.0,
          ),
        ],
      );
    }
  }
}
