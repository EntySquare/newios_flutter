
import 'package:myflutter/pages/bean/ItemPlanWayBean.dart';


class LookPlanArgumentsBean {
  ItemPlanWayBean _startBean;
  ItemPlanWayBean _endBean;

  ItemPlanWayBean get startBean => _startBean;

  set startBean(ItemPlanWayBean value) {
    _startBean = value;
  }

  ItemPlanWayBean get endBean => _endBean;

  set endBean(ItemPlanWayBean value) {
    _endBean = value;
  }


}