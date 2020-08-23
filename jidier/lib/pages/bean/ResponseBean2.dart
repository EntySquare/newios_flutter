class ResponseBean2 {
  int responseCode;
  String responseText;
  Object responseData;

  ResponseBean2({this.responseCode, this.responseText, this.responseData});

  ResponseBean2.fromJson(Map<String, dynamic> json) {
    responseCode = json['responseCode'];
    responseText = json['responseText'];
    responseData = json['responseData'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['responseCode'] = this.responseCode;
    data['responseText'] = this.responseText;
    data['responseData'] = this.responseData;
    return data;
  }
}