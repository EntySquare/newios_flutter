import 'package:myflutter/pages/bean/AdressDataBean.dart';

/*纠正地址实体类*/

class AtentAddressBean {
  int _position;
  ResponseData _responseData;
  var _callBack;

  set position(value) => this._position=value;

  get position=>this._position;

  set responseData(value) => this._responseData=value;

  get responseData => this._responseData;

  set callBack(value) => this._callBack=value;

  get callBack => this._callBack;
}
