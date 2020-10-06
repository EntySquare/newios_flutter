import 'package:flutter/material.dart';
import 'package:myflutter/pages/bean/ItemPlanWayBean.dart';
import 'package:myflutter/pages/bean/LookPlanArgumentsBean.dart';
import 'package:base_mapview/base_mapview.dart';

/*查询计划两点的位置信息*/
class LookPlanPointsWidget extends StatefulWidget {
  LookPlanArgumentsBean lookPlanArgumentsBean;

  LookPlanPointsWidget({Key key, this.lookPlanArgumentsBean}) : super(key: key);

  @override
  _LookPlanPointsWidgetState createState() => _LookPlanPointsWidgetState(
      lookPlanArgumentsBean.startBean, lookPlanArgumentsBean.endBean);
}

class _LookPlanPointsWidgetState extends State<LookPlanPointsWidget> {
  ItemPlanWayBean _startItemBean;
  ItemPlanWayBean _endItemBean;

 // AMapController _controller;
  double _zoom = 17;

  _LookPlanPointsWidgetState(this._startItemBean, this._endItemBean);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
            child: AppBar(
              title: Text(
                "相距${_startItemBean.beTweenSpace}千米",
                style: TextStyle(color: Colors.white, fontSize: 18.0),
              ),
              backgroundColor: Color(0xff00afaf),
              centerTitle: true,
            ),
            preferredSize: Size.fromHeight(40.0)),
        body: Padding(
          padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[getMaps()],
          ),
        ));
  }

  Widget getMaps() {
    return Container();
  }
//    return AMapView(
//      onAMapViewCreated: (controller) {
//        this._controller = controller;
//        List<MarkerOptions> marks = List();
//        MarkerOptions markerOption1 = MarkerOptions(
//            position: LatLng(double.parse(_startItemBean.lng),
//                double.parse(_startItemBean.lat)),
//            icon: "images/ic_red_location.png",
//           snippet:_startItemBean.address,
//           enabled:false
//            );
//        MarkerOptions markerOption2 = MarkerOptions(
//            position: LatLng(
//                double.parse(_endItemBean.lng), double.parse(_endItemBean.lat)),
//            icon: "images/ic_red_location.png",
//        snippet: _endItemBean.address,
//        enabled: false);
//        marks.add(markerOption1);
//        marks.add(markerOption2);
//        this._controller.addMarkers(marks);
//        List<LatLng> latLngList=List();
//               LatLng   latl1= LatLng(double.parse(_startItemBean.lng),
//                       double.parse(_startItemBean.lat));
//        LatLng   latl2= LatLng(double.parse(_endItemBean.lng),
//            double.parse(_endItemBean.lat));
//        latLngList.add(latl1);
//        latLngList.add(latl2);
//      PolylineOptions   polyLine=PolylineOptions(latLngList:latLngList, width:20.0,color:Colors.red,isDottedLine:true);
//        this._controller.addPolyline(polyLine);
//        //this._controller.setZoomLevel(14);
//        this._controller.setPosition(target:latLngList[0]);
//      },
//      amapOptions: AMapOptions(
//        compassEnabled: false,
//        mapType: MAP_TYPE_NORMAL,
//        zoomControlsEnabled:false,
//        logoPosition: LOGO_POSITION_BOTTOM_CENTER,
////        camera: CameraPosition(
////          target: LatLng(double.parse(_startItemBean.lng),
////              double.parse(_startItemBean.lat)),
////          zoom: this._zoom,
////        ),
//      ),
//    );
//  }
}
