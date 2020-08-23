import 'package:flutter/material.dart';
import 'package:myflutter/pages/bean/ItemPlanWayBean.dart';
import 'package:myflutter/pages/bean/PlanWayArgumentsBean.dart';

/*历史规划路径*/
class HistoryPlanWayWidget extends StatefulWidget {
  List<List<Map>> historyData;

  HistoryPlanWayWidget({Key key, this.historyData}) : super(key: key);

  @override
  _HistoryPlanWayWidgetState createState() =>
      _HistoryPlanWayWidgetState(historyData);
}

class _HistoryPlanWayWidgetState extends State<HistoryPlanWayWidget> {
  List<List<Map>> _historyData;

  _HistoryPlanWayWidgetState(this._historyData);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          child: AppBar(
            title: Text(
              "历史规划路径",
              style: TextStyle(color: Colors.white, fontSize: 18.0),
            ),
            backgroundColor: Color(0xff00afaf),
            centerTitle: true,
          ),
          preferredSize: Size.fromHeight(40.0)),
      body: Container(
        color: Color(0xffeeeeee),
        child: Padding(
          padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
          child: ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  List<Map> itemMaps = _historyData[index];
                  List<ItemPlanWayBean> tempList = List<ItemPlanWayBean>();
                  for (Map map in itemMaps) {
                    ItemPlanWayBean itemPlanWayBean = ItemPlanWayBean();
                    itemPlanWayBean.address = map['address'];
                    itemPlanWayBean.ifEnd = map['ifEnd'];
                    itemPlanWayBean.ifStart = map['ifStart'];
                    itemPlanWayBean.lat = map['lat'];
                    itemPlanWayBean.lng = map['lng'];
                    itemPlanWayBean.beTweenSpace = map['beTweenSpace'];
                    tempList.add(itemPlanWayBean);
                  }
                  PlanWayArgumentsBean planWayArgumentsBean =
                      PlanWayArgumentsBean();
                  planWayArgumentsBean.pointsData = tempList;
                  Navigator.pushNamed(context, '/planWayResultWidget',
                      arguments: planWayArgumentsBean);
                },
                child: _getItemWidget(context, index),
              );

              //return _getItemWidget(context, index);
            },
            itemCount: _historyData.length,
          ),
        ),
      ),
    );
  }

  Widget _getItemWidget(BuildContext context, int index) {
    List<Map> itemMaps = _historyData[index];
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
      child: Container(
        color: Colors.white,
        height: 60.0,
        child: ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return _getItemChildWidget(context, index, itemMaps);
          },
          scrollDirection: Axis.horizontal,
          itemCount: itemMaps.length,
        ),
      ),
    );
  }

  Widget _getItemChildWidget(
      BuildContext context, int index, List<Map> itemMap) {
    Map map = itemMap[index];
    if (index == 0) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            "images/ico_start.png",
            width: 30.0,
            height: 30.0,
          ),
          Text(
            map['address'],
            style: TextStyle(
                fontSize: 16.0,
                color: Colors.black,
                fontWeight: FontWeight.w700),
          ),
          Text(
            '-->',
            style: TextStyle(
                fontSize: 18.0,
                color: Color(0xff00afaf),
                fontWeight: FontWeight.w700),
          )
        ],
      );
    } else if (index == itemMap.length - 1) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            "images/ico_end.png",
            width: 30.0,
            height: 30.0,
          ),
          Text(
            map['address'],
            style: TextStyle(
                fontSize: 16.0,
                color: Colors.black,
                fontWeight: FontWeight.w700),
          )
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            map['address'],
            style: TextStyle(
                fontSize: 16.0,
                color: Colors.black,
                fontWeight: FontWeight.w700),
          ),
          Text(
            '-->',
            style: TextStyle(
                fontSize: 18.0,
                color: Color(0xff00afaf),
                fontWeight: FontWeight.w700),
          )
        ],
      );
    }
  }
}
