class MessagesBean {
  int responseCode;
  String responseText;
  ResponseData responseData;

  MessagesBean({this.responseCode, this.responseText, this.responseData});

  MessagesBean.fromJson(Map<String, dynamic> json) {
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
  Messages messages;

  ResponseData({this.messages});

  ResponseData.fromJson(Map<String, dynamic> json) {
    messages = json['Messages'] != null
        ? new Messages.fromJson(json['Messages'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.messages != null) {
      data['Messages'] = this.messages.toJson();
    }
    return data;
  }
}

class Messages {
  List<Data> data;
  int page;
  int pageSize;
  int count;

  Messages({this.data, this.page, this.pageSize, this.count});

  Messages.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
    page = json['page'];
    pageSize = json['pageSize'];
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    data['page'] = this.page;
    data['pageSize'] = this.pageSize;
    data['count'] = this.count;
    return data;
  }
}

class Data {
  int id;
  String sendid;
  String getid;
  String addid;
  String title;
  String phone;
  int createTime;
  String alertType;
  int isRead;
  String sendPhone;
  Address address;

  Data(
      {this.id,
      this.sendid,
      this.getid,
      this.addid,
      this.title,
      this.phone,
      this.createTime,
      this.alertType,
      this.isRead,
      this.sendPhone,
      this.address});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    sendid = json['sendid'];
    getid = json['getid'];
    addid = json['addid'];
    title = json['title'];
    phone = json['phone'];
    createTime = json['create_time'];
    alertType = json['alert_type'];
    isRead = json['is_read'];
    sendPhone = json['sendPhone'];
    address =
        json['address'] != null ? new Address.fromJson(json['address']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['sendid'] = this.sendid;
    data['getid'] = this.getid;
    data['addid'] = this.addid;
    data['title'] = this.title;
    data['phone'] = this.phone;
    data['create_time'] = this.createTime;
    data['alert_type'] = this.alertType;
    data['is_read'] = this.isRead;
    data['sendPhone'] = this.sendPhone;
    if (this.address != null) {
      data['address'] = this.address.toJson();
    }
    return data;
  }
}

class Address {
  int id;
  String address;
  int uid;
  String addressLocation;
  String describe;
  String remark;
  String path1;
  String path2;
  String path3;
  String longs;
  String kind;
  String lat;
  int times;
  int endtime;
  int state;
  int months;
  int buydate;
  String atendLocation;
  String buyId;
  int buyIdEndTime;
  String randomId;

  Address(
      {this.id,
      this.address,
      this.uid,
      this.addressLocation,
      this.describe,
      this.remark,
      this.path1,
      this.path2,
      this.path3,
      this.longs,
      this.kind,
      this.lat,
      this.times,
      this.endtime,
      this.state,
      this.months,
      this.buydate,
      this.atendLocation,
      this.buyId,
      this.buyIdEndTime,
      this.randomId});

  Address.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    address = json['address'];
    uid = json['uid'];
    addressLocation = json['addressLocation'];
    describe = json['describe'];
    remark = json['remark'];
    path1 = json['path1'];
    path2 = json['path2'];
    path3 = json['path3'];
    longs = json['longs'];
    kind = json['kind'];
    lat = json['lat'];
    times = json['times'];
    endtime = json['endtime'];
    state = json['state'];
    months = json['months'];
    buydate = json['buydate'];
    atendLocation = json['atendLocation'];
    buyId = json['buyId'];
    buyIdEndTime = json['buyIdEndTime'];
    randomId = json['randomId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['address'] = this.address;
    data['uid'] = this.uid;
    data['addressLocation'] = this.addressLocation;
    data['describe'] = this.describe;
    data['remark'] = this.remark;
    data['path1'] = this.path1;
    data['path2'] = this.path2;
    data['path3'] = this.path3;
    data['longs'] = this.longs;
    data['kind'] = this.kind;
    data['lat'] = this.lat;
    data['times'] = this.times;
    data['endtime'] = this.endtime;
    data['state'] = this.state;
    data['months'] = this.months;
    data['buydate'] = this.buydate;
    data['atendLocation'] = this.atendLocation;
    data['buyId'] = this.buyId;
    data['buyIdEndTime'] = this.buyIdEndTime;
    data['randomId'] = this.randomId;
    return data;
  }
}
