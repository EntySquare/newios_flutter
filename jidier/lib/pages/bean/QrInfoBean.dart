class QrInfoBean {
  int code;
  String message;
  Data data;

  QrInfoBean({this.code, this.message, this.data});

  QrInfoBean.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  int responseCode;
  String responseText;
  ResponseData responseData;

  Data({this.responseCode, this.responseText, this.responseData});

  Data.fromJson(Map<String, dynamic> json) {
    responseCode = json['responseCode'];
    responseText = json['responseText'];
    responseData = json['responseData'] != null
        ? new ResponseData.fromJson(json['responseData'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['responseCode'] = this.responseCode;
    data['responseText'] = this.responseText;
    if (this.responseData != null) {
      data['responseData'] = this.responseData.toJson();
    }
    return data;
  }
}

class ResponseData {
  String kind;
  String codeId;
  String addressName;
  int buystate;

  ResponseData({this.kind, this.codeId, this.addressName, this.buystate});

  ResponseData.fromJson(Map<String, dynamic> json) {
    kind = json['kind'];
    codeId = json['codeId'];
    addressName = json['addressName'];
    buystate = json['buystate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['kind'] = this.kind;
    data['codeId'] = this.codeId;
    data['addressName'] = this.addressName;
    data['buystate'] = this.buystate;
    return data;
  }
}
