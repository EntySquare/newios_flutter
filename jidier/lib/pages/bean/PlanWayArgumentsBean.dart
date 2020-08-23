import 'package:myflutter/pages/bean/AdressDataBean.dart';
import 'package:myflutter/pages/bean/ItemPlanWayBean.dart';
/*纠正地址实体类*/

class PlanWayArgumentsBean {
  ItemPlanWayBean _startBean;
  ItemPlanWayBean  _endBean;
  List<ItemPlanWayBean> _pointsData;

  ItemPlanWayBean get startBean => _startBean;

  set startBean(ItemPlanWayBean value) {
    _startBean = value;
  }

  ItemPlanWayBean get endBean => _endBean;

  set endBean(ItemPlanWayBean value) {
    _endBean = value;
  }

  List<ItemPlanWayBean> get pointsData => _pointsData;

  set pointsData(List<ItemPlanWayBean> value) {
    _pointsData = value;
  }

}
