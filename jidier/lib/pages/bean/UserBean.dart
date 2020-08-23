class UserBean {
  int _code;
  String _message;
  Data _data;

  UserBean({int code, String message, Data data}) {
    this._code = code;
    this._message = message;
    this._data = data;
  }

  int get code => _code;
  set code(int code) => _code = code;
  String get message => _message;
  set message(String message) => _message = message;
  Data get data => _data;
  set data(Data data) => _data = data;

  UserBean.fromJson(Map<String, dynamic> json) {
    _code = json['code'];
    _message = json['message'];
    _data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this._code;
    data['message'] = this._message;
    if (this._data != null) {
      data['data'] = this._data.toJson();
    }
    return data;
  }
}

class Data {
  int _responseCode;
  String _responseText;
  ResponseData _responseData;

  Data({int responseCode, String responseText, ResponseData responseData}) {
    this._responseCode = responseCode;
    this._responseText = responseText;
    this._responseData = responseData;
  }

  int get responseCode => _responseCode;
  set responseCode(int responseCode) => _responseCode = responseCode;
  String get responseText => _responseText;
  set responseText(String responseText) => _responseText = responseText;
  ResponseData get responseData => _responseData;
  set responseData(ResponseData responseData) => _responseData = responseData;

  Data.fromJson(Map<String, dynamic> json) {
    _responseCode = json['responseCode'];
    _responseText = json['responseText'];
    _responseData = json['responseData'] != null
        ? new ResponseData.fromJson(json['responseData'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['responseCode'] = this._responseCode;
    data['responseText'] = this._responseText;
    if (this._responseData != null) {
      data['responseData'] = this._responseData.toJson();
    }
    return data;
  }
}

class ResponseData {
  int _id;
  String _pwd;
  String _nick;
  String _phone;
  String _times;
  int _score;
  String _idnumber;
  String _openid;

  ResponseData(
      {int id,
        String pwd,
        String nick,
        String phone,
        String times,
        int score,
        String idnumber,
        String openid}) {
    this._id = id;
    this._pwd = pwd;
    this._nick = nick;
    this._phone = phone;
    this._times = times;
    this._score = score;
    this._idnumber = idnumber;
    this._openid = openid;
  }

  int get id => _id;
  set id(int id) => _id = id;
  String get pwd => _pwd;
  set pwd(String pwd) => _pwd = pwd;
  String get nick => _nick;
  set nick(String nick) => _nick = nick;
  String get phone => _phone;
  set phone(String phone) => _phone = phone;
  String get times => _times;
  set times(String times) => _times = times;
  int get score => _score;
  set score(int score) => _score = score;
  String get idnumber => _idnumber;
  set idnumber(String idnumber) => _idnumber = idnumber;
  String get openid => _openid;
  set openid(String openid) => _openid = openid;

  ResponseData.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _pwd = json['pwd'];
    _nick = json['nick'];
    _phone = json['phone'];
    _times = json['times'];
    _score = json['score'];
    _idnumber = json['idnumber'];
    _openid = json['openid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['pwd'] = this._pwd;
    data['nick'] = this._nick;
    data['phone'] = this._phone;
    data['times'] = this._times;
    data['score'] = this._score;
    data['idnumber'] = this._idnumber;
    data['openid'] = this._openid;
    return data;
  }
}