class ImageBean {
  int code;
  String message;
  Data data;

  ImageBean({this.code, this.message, this.data});

  ImageBean.fromJson(Map<String, dynamic> json) {
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
  List<String> responseData;

  Data({this.responseCode, this.responseText, this.responseData});

  Data.fromJson(Map<String, dynamic> json) {
    responseCode = json['responseCode'];
    responseText = json['responseText'];
    responseData = json['responseData'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['responseCode'] = this.responseCode;
    data['responseText'] = this.responseText;
    data['responseData'] = this.responseData;
    return data;
  }
}
