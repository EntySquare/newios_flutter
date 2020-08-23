import 'package:flutter/material.dart';
import 'package:myflutter/pages/bean/PlanWayBean.dart';
import 'package:myflutter/pages/util/SharedPreferencesUtil.dart';

class PlanWayDialog extends StatefulWidget {
  PlanWayBean planWayBean;

  PlanWayDialog({Key key, this.planWayBean}) : super(key: key);

  @override
  _PlanWayDialogState createState() => _PlanWayDialogState(planWayBean);
}

class _PlanWayDialogState extends State<PlanWayDialog> {
  PlanWayBean _planwayBean;

  _PlanWayDialogState(PlanWayBean planWayBean) {
    this._planwayBean = planWayBean;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigator.pop(context);
      },
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20.0))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0),
                      child: getTopTitle(),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0),
                      child: getContent(),
                    ),
                    getBottomItem(
                        _planwayBean.descrileTitle,
                        _planwayBean.describleAdress,
                        _planwayBean.desCribleLocation),
                    getBottomItem(
                        _planwayBean.ambutionTitle,
                        _planwayBean.ambutionAdress,
                        _planwayBean.ambutionLocation),
                    getBottomItem(_planwayBean.atendTitle,
                        _planwayBean.atendAdress, _planwayBean.atendLocation)
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget getTopTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Container(),
        ),
        Text(
          "规划路径添加点",
          style: TextStyle(
              fontSize: 18.0,
              color: Color(0xff000000),
              fontWeight: FontWeight.w700),
        ),
        Expanded(
          flex: 1,
          child: Container(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: EdgeInsets.fromLTRB(5.0, 5.0, 20.0, 5.0),
                  child: Image.asset(
                    "images/ic_closed.png",
                    height: 30.0,
                    width: 30.0,
                  ),
                ),
              )),
        ),
      ],
    );
  }

  Widget getContent() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        GestureDetector(
          onTap: () {
            //点击查看添加点信息
            Navigator.pushNamed(context, '/addPointInfoWidget');
          },
          child: Padding(
            padding: EdgeInsets.fromLTRB(0.0, 0.0, 40.0, 0.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  "images/ico_eye.png",
                  height: 40.0,
                  width: 40.0,
                ),
                Text(
                  "添加点信息",
                  style: TextStyle(fontSize: 14.0, color: Color(0xff000000)),
                )
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            //点击查看添加点信息
            SharedPreferencesUtil.getHistoryPlanWay().then((historyData) {
              Navigator.pushNamed(context, '/historyPlanWayWidget',
                  arguments: historyData);
            });
          },
          child: Padding(
            padding: EdgeInsets.fromLTRB(0.0, 0.0, 20.0, 0.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  "images/ico_history_plan.png",
                  height: 30.0,
                  width: 30.0,
                ),
                Text(
                  "历史规划路径",
                  style: TextStyle(fontSize: 14.0, color: Color(0xff000000)),
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget getBottomItem(String title, String address, String location) {
    if (location == null || location.isEmpty || location == "0") {
      return Container();
    } else {
      return Padding(
        padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              "images/ico_location.png",
              width: 30.0,
              height: 30.0,
            ),
            Text(
              title + ":",
              style: TextStyle(
                  fontSize: 16.0,
                  color: Color(0xffff0000),
                  fontWeight: FontWeight.w700),
            ),
            Container(
              width: 5.0,
            ),
            Expanded(
              child: Text(
                address,
                style: TextStyle(fontSize: 14.0, color: Color(0xff000000)),
                textAlign: TextAlign.start,
              ),
              flex: 1,
            ),
            Container(
              alignment: Alignment.centerRight,
              width: 60.0,
              height: 30.0,
              child: RaisedButton(
                child: Text(
                  "添加",
                  style: TextStyle(color: Colors.white, fontSize: 14.0),
                ),
                color: Color(0xff00afaf),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                onPressed: () {
                  //添加到
                  List latlng = location.split(",");

                  SharedPreferencesUtil.savePlanWay(
                      context, address, latlng[0], latlng[1]);
                },
              ),
            )
          ],
        ),
      );
    }
  }
}
