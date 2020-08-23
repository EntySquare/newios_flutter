import 'package:flutter/material.dart';
import 'package:myflutter/pages/bean/NetAddressBean.dart';
import 'package:myflutter/pages/bean/PlanWayBean.dart';
import 'package:myflutter/pages/dialog/navigation_dialog.dart';
import 'package:myflutter/pages/dialog/plan_way_dialog.dart';
import 'package:myflutter/pages/dialog/record_address_dialog.dart';
import 'package:myflutter/pages/dialog/record_sucessful_dialog.dart';
import 'package:myflutter/pages/util/DataUtil.dart';
import 'package:myflutter/pages/util/SharedPreferencesUtil.dart';
import 'package:myflutter/pages/util/Toast.dart';

/*导航历史记录*/
class NavigationHistoryWidget extends StatefulWidget {
  NavigationHistoryWidget({Key key}) : super(key: key);

  @override
  _NavigationHistoryWidgetState createState() =>
      _NavigationHistoryWidgetState();
}

class _NavigationHistoryWidgetState extends State<NavigationHistoryWidget> {
  List _resultList = List();

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    SharedPreferencesUtil.getNavigationHistory().then((result) {
      setState(() {
        _resultList = result;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          child: AppBar(
            backgroundColor: Color(0xff00afaf),
            centerTitle: true,
            title: Text(
              "导航历史记录",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold),
            ),
          ),
          preferredSize: Size.fromHeight(40.0)),
      body: Container(
        color: Color(0xffdedede),
        child: Padding(
          padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
          child: ListView.builder(
            itemBuilder: getListWidget,
            itemCount: _resultList.length,
          ),
        ),
      ),
    );
  }

  Widget getListWidget(context, indext) {
    var bean = _resultList[indext];
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        child: Padding(
          padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 0.0),
                  child: Image.asset(
                    "images/ic_ji.png",
                    width: 40.0,
                    height: 40.0,
                  ),
                ),
                onTap: () {
                  _showRecordAddressDialog(bean);
                },
              ),
              Expanded(
                child: Text(
                  bean["address"],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 16.0,
                      color: Color(0xff000000),
                      fontWeight: FontWeight.w700),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                flex: 1,
              ),
              IconButton(
                  icon: Image.asset('images/ico_way_planting.png'),
                  onPressed: () {
                    _planWayDialog(bean);
                  }),
              GestureDetector(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(5.0, 5.0, 20.0, 5.0),
                  child: Image.asset(
                    "images/ic_blue_navigation.png",
                    width: 30.0,
                    height: 30.0,
                    fit: BoxFit.cover,
                  ),
                ),
                onTap: () {
                  //点击导航事件
                  var navgationBean = _resultList[indext];
                  String lat = navgationBean["lat"];
                  String lng = navgationBean["lng"];
                  double dLat = double.parse(lat);
                  double dlng = double.parse(lng);
                  _showNavigationDialog(
                      context, navgationBean["address"], dLat, dlng);
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  void _planWayDialog(bean) {
    PlanWayBean planWayBean = new PlanWayBean();
    planWayBean.descrileTitle ='记录地址';
    planWayBean.describleAdress = bean['address'];
    planWayBean.desCribleLocation = bean['lng'] + "," + bean['lat'];
    planWayBean.ambutionTitle = "周边地址";
    planWayBean.ambutionAdress = '';
    planWayBean.ambutionLocation = '';
    planWayBean.atendTitle = "纠正地址";
    planWayBean.atendAdress = '';
    planWayBean.atendLocation = '';
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (_) {
          return PlanWayDialog(planWayBean: planWayBean);
        });
  }

  /*记录地址弹窗*/
  _showRecordAddressDialog(bean) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          NetAddressBean netAddressBean = NetAddressBean();
          int nowTime = DataUtil.currentTimeMillis();
          netAddressBean.describe = bean["address"];
          netAddressBean.remark = "0";
          netAddressBean.kind = "随心记";
          netAddressBean.address = "0";
          netAddressBean.addressLocation = "0";
          netAddressBean.atendLocation = "0";
          netAddressBean.path1 = "0";
          netAddressBean.path2 = "0";
          netAddressBean.path3 = "0";
          netAddressBean.longs = bean["lng"];
          netAddressBean.lat = bean["lat"];
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
          _showRecordSuccessfulDialog();
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
          // print("开始弹窗");

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
          );
        });
  }
}
