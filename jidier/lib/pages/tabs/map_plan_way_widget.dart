import 'package:amap_map_fluttify/amap_map_fluttify.dart';
import 'package:flutter/material.dart';
import 'package:myflutter/pages/bean/ItemPlanWayBean.dart';
import 'package:base_mapview/base_mapview.dart';

/*规划点路径地图*/
class MapPlanWayWidget extends StatefulWidget {
  List<ItemPlanWayBean> planData;

  MapPlanWayWidget({Key key, this.planData}) : super(key: key);

  @override
  _MapPlanWayWidgetState createState() => _MapPlanWayWidgetState(this.planData);
}

class _MapPlanWayWidgetState extends State<MapPlanWayWidget> {
  List<ItemPlanWayBean> _planData;

  AmapController _controller;

  _MapPlanWayWidgetState(this._planData);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          child: AppBar(
            title: Text(
              "规划点地图明细",
              style: TextStyle(color: Colors.white, fontSize: 18.0),
            ),
            backgroundColor: Color(0xff00afaf),
            centerTitle: true,
          ),
          preferredSize: Size.fromHeight(40.0)),
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[getMap()],
      ),
    );
  }

  Widget getMap() {
//    return AMapView(
//      onAMapViewCreated: (controller) {
//        this._controller = controller;
//        List<MarkerOptions> marks = List();
//        List<LatLng> latLngList = List();
//        for (ItemPlanWayBean itemBean in this._planData) {
//          double lat = double.parse(itemBean.lat);
//          double lng = double.parse(itemBean.lng);
//          LatLng latLng = LatLng(lng, lat);
//          latLngList.add(latLng);
//          MarkerOptions markOptions;
//          if (itemBean.ifStart) {
//            markOptions = MarkerOptions(
//                position: latLng,
//                icon: "images/ico_start.png",
//                snippet: itemBean.address,
//                enabled: false);
//          } else if (itemBean.ifEnd) {
//            markOptions = MarkerOptions(
//                position: latLng,
//                icon: "images/ico_end.png",
//                snippet: itemBean.address,
//                enabled: false);
//          } else {
//            markOptions = MarkerOptions(
//                position: latLng,
//                icon: "images/ico_green_location.png",
//                snippet: itemBean.address,
//                enabled: false);
//          }
//          marks.add(markOptions);
//        }
//
//        this._controller.addMarkers(marks);
//        PolylineOptions polyLine = PolylineOptions(
//            latLngList: latLngList,
//            width: 20.0,
//            color: Colors.red,
//            isDottedLine: true);
//        this._controller.addPolyline(polyLine);
//        //this._controller.setZoomLevel(14);
//        this._controller.setPosition(target: latLngList[0]);
//      },
//      amapOptions: AMapOptions(
//        compassEnabled: false,
//        mapType: MAP_TYPE_NORMAL,
//        zoomControlsEnabled: false,
//        logoPosition: LOGO_POSITION_BOTTOM_CENTER,
////        camera: CameraPosition(
////          target: LatLng(double.parse(_startItemBean.lng),
////              double.parse(_startItemBean.lat)),
////          zoom: this._zoom,
////        ),
//      ),
//    );
  return AmapView(
    onMapCreated:(controller) async{
      this._controller = controller;
             List<MarkerOption> marks = List();
       List<LatLng> latLngList = List();
       for (ItemPlanWayBean itemBean in this._planData) {
         double lat = double.parse(itemBean.lat);
         double lng = double.parse(itemBean.lng);
         LatLng latLng = LatLng(lng, lat);
         latLngList.add(latLng);
         MarkerOption markOptions;
         if (itemBean.ifStart) {
           markOptions = MarkerOption(
               latLng: latLng,
               iconProvider:AssetImage("images/ico_start.png"),
           );
         } else if (itemBean.ifEnd) {
           markOptions = MarkerOption(
               latLng: latLng,
               iconProvider:AssetImage("images/ico_end.png"));
         } else {
           markOptions =MarkerOption(
               latLng: latLng,
               iconProvider:AssetImage('images/ico_green_location.png'),
           );
         }
         marks.add(markOptions);
       }
  await  this._controller.setCenterCoordinate(latLngList[0]);
   await this._controller.setZoomLevel(14);
   await this._controller.addMarkers(marks);
       PolylineOption polyLine = PolylineOption(
           latLngList: latLngList,
           width: 20.0,
           strokeColor:Colors.red
       );
    await   this._controller.addPolyline(polyLine);
    },
    showCompass:false,
  );

  }
}
