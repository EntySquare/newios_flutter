import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myflutter/pages/login/LoginWidget.dart';
import 'package:myflutter/pages/tabs/LocationWidget.dart';
import 'package:myflutter/pages/login/protocol_widget.dart';
import '../../main.dart';
import 'package:myflutter/pages/login/register_widget.dart';
import 'package:myflutter/pages/login/forget_password_widget.dart';
import 'package:myflutter/pages/login/change_password_widget.dart';
import 'package:myflutter/pages/tabs/show_pic_widget.dart';
import 'package:myflutter/pages/tabs/qr_code_widget.dart';
import 'package:myflutter/pages/tabs/qr_info_widget.dart';
import 'package:myflutter/pages/tabs/atent_address_widget.dart';
import 'package:myflutter/pages/tabs/qr_scan_widget.dart';
import 'package:myflutter/pages/tabs/search_map_widget.dart';
import 'package:myflutter/pages/tabs/search_content_widget.dart';
import 'package:myflutter/pages/tabs/navigation_history_widget.dart';
import 'package:myflutter/pages/tabs/add_point_info_widget.dart';
import 'package:myflutter/pages/tabs/plan_way_result_widget.dart';
import 'package:myflutter/pages/tabs/look_plan_points_widget.dart';
import 'package:myflutter/pages/tabs/map_plan_way_widget.dart';
import 'package:myflutter/pages/tabs/history_plan_way_widget.dart';
import 'package:myflutter/pages/tabs/share/share_contacts_widget.dart';
import 'package:myflutter/pages/tabs/message_widget.dart';
import 'package:myflutter/pages/tabs/setting_widget.dart';

final routers = {
  '/': (context) => myBottomBarWidget(),
  '/login': (context, {arguments}) => LoginWidget(
        content: arguments,
      ),
  //'/location':(context,{arguments})=>LocationWidget(arguments:arguments),
  '/protocol': (context, {arguments}) => ProtocolWidget(state: arguments),
  '/register': (context, {arguments}) => RegisterWidget(
        parameter: arguments,
      ),
  '/forget': (context, {arguments}) => ForgetPasswordWidget(
        parameter: arguments,
      ),
  '/changePassword': (context, {arguments}) => ChangePasswordWidget(),
  '/showPicWidget': (context, {arguments}) => ShowPicWidget(
        responseData: arguments,
      ),
  '/qrCodeWidget': (context, {arguments}) => QrCodeWidget(
        responseData: arguments,
      ),
  '/qrInfoWidget': (context, {arguments}) => QrInfoWidget(
        responseData: arguments,
      ),
  '/atentAddressWidget': (context, {arguments}) => AtentAddressWidget(
        atentAddressBean: arguments,
      ),
  '/qrScanWidget': (context, {arguments}) => QrScanWidget(),
  '/searchMapWidget': (context, {arguments}) => SearchMapWidget(
       // latLng: arguments,
      ),
  '/searchContentWidget': (context, {arguments}) => SearchContentWidget(),
  '/navigationHistory': (context, {arguments}) => NavigationHistoryWidget(),
  '/addPointInfoWidget': (context, {arguments}) => AddPointInfoWidget(),
  '/planWayResultWidget': (context, {arguments}) =>
      PlanWayResultWidget(planWayArgumentsBean: arguments),
  '/lookPlanPointsWidget': (context, {arguments}) =>
      LookPlanPointsWidget(lookPlanArgumentsBean: arguments),
  '/mapPlanWayWidget': (context, {arguments}) =>
      MapPlanWayWidget(planData: arguments),
  '/historyPlanWayWidget': (context, {arguments}) =>
      HistoryPlanWayWidget(historyData: arguments),
  '/shareContactsWidget': (context, {arguments}) => ShareContactsWIdget(
        id: arguments,
      ),
  '/messageWidget': (context) => MessageWidget(),
  '/settingWidget': (context) => SettingWidget(),
};

var onGenerateRoute = (RouteSettings settings) {
  //统一处理
  final String name = settings.name;
  final Function pageContentBuilder = routers[name];
  if (pageContentBuilder != null) {
    if (settings.arguments != null) {
      final Route route = MaterialPageRoute(
          builder: (context) =>
              pageContentBuilder(context, arguments: settings.arguments));
      return route;
    } else {
      final Route route =
          MaterialPageRoute(builder: (context) => pageContentBuilder(context));
      return route;
    }
  }
};
