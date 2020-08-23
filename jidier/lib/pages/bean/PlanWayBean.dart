class PlanWayBean{
  String _descrileTitle;
  String _describleAdress;
  String _desCribleLocation;
  String _ambutionTitle;
  String _ambutionAdress;
  String  _ambutionLocation;
  String _atendTitle;
  String _atendAdress;
  String  _atendLocation;
  set describleAdress(describleAdress)=>this._describleAdress=describleAdress;
  get describleAdress=>this._describleAdress;
  set desCribleLocation(desCribleLocation)=>this._desCribleLocation=desCribleLocation;
  get desCribleLocation=>this._desCribleLocation;

  String get atendLocation => _atendLocation;


  String get descrileTitle => _descrileTitle;

  set descrileTitle(String value) {
    _descrileTitle = value;
  }

  set atendLocation(String value) {
    _atendLocation = value;
  }

  String get atendAdress => _atendAdress;

  set atendAdress(String value) {
    _atendAdress = value;
  }

  String get ambutionLocation => _ambutionLocation;

  set ambutionLocation(String value) {
    _ambutionLocation = value;
  }

  String get ambutionAdress => _ambutionAdress;

  set ambutionAdress(String value) {
    _ambutionAdress = value;
  }

  String get ambutionTitle => _ambutionTitle;

  set ambutionTitle(String value) {
    _ambutionTitle = value;
  }

  String get atendTitle => _atendTitle;

  set atendTitle(String value) {
    _atendTitle = value;
  }


}