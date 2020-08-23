class ResponseBean {
  int _code;
  String _message;
  Data _data;

  ResponseBean({int code, String message, Data data}) {
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

  ResponseBean.fromJson(Map<String, dynamic> json) {
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

  Data({int responseCode, String responseText}) {
    this._responseCode = responseCode;
    this._responseText = responseText;
  }

  int get responseCode => _responseCode;
  set responseCode(int responseCode) => _responseCode = responseCode;
  String get responseText => _responseText;
  set responseText(String responseText) => _responseText = responseText;

  Data.fromJson(Map<String, dynamic> json) {
    _responseCode = json['responseCode'];
    _responseText = json['responseText'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['responseCode'] = this._responseCode;
    data['responseText'] = this._responseText;
    return data;
  }
}