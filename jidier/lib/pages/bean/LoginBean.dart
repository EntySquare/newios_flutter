



class LoginBean  {
  int code;
  String message;
  bool  ifLogin=false;
  String token='';
  int id;
  String pwd;
  String nick;
  String phone;
  String times;
  int score;
  String idnumber;
  String openid;
  Data data;


  LoginBean({this.code, this.message,this.ifLogin ,this.data,this.token,this.id,this.pwd,this.nick,this.phone,this.times,this.score,
  this.idnumber,
  this.openid});

  LoginBean.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    ifLogin=json['ifLogin'];
    token=json['token'];
    id=json['id'];
    pwd=json['pwd'];
    nick=json['nick'];
    phone=json['phone'];
    times=json['times'];
    score=json['score'];
    idnumber=json['idnumber'];
    openid=json['openid'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['message'] = this.message;
    data['ifLogin'] = this.ifLogin;
    data['token']=this.token;
    data['id']=this.id;
    data['pwd']=this.pwd;
    data['nick']=this.nick;
    data['phone']=this.phone;
    data['times']=this.times;
    data['score']=this.score;
    data['idnumber']=this.idnumber;
    data['openid']=this.openid;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }




}

class Data {
  int responseCode;
  String responseText;
  Object responseData;

  Data({this.responseCode, this.responseText, this.responseData});

  Data.fromJson(Map<String, dynamic> json) {
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