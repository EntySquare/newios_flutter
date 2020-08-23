

/*规划路径itemBean*/
class ItemPlanWayBean{
  String _address;
  String _lat;
  String  _lng;
  bool  _ifStart=false;
  bool _ifEnd=false;
  double _beTweenSpace=0.00;


  double get beTweenSpace => _beTweenSpace;

  set beTweenSpace(double value) {
    _beTweenSpace = value;
  }

  String get address => _address;

  set address(String value) {
    _address = value;
  }

  String get lat => _lat;

  set lat(String value) {
    _lat = value;
  }

  bool get ifEnd => _ifEnd;

  set ifEnd(bool value) {
    _ifEnd = value;
  }

  bool get ifStart => _ifStart;

  set ifStart(bool value) {
    _ifStart = value;
  }

  String get lng => _lng;

  set lng(String value) {
    _lng = value;
  }


}