import 'package:flutter/material.dart';

class AdressDataBean {
  int code;
  String message;
  Data data;

  AdressDataBean({this.code, this.message, this.data});

  AdressDataBean.fromJson(Map<String, dynamic> json) {
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
  List<ResponseData> responseData;

  Data({this.responseCode, this.responseText, this.responseData});

  Data.fromJson(Map<String, dynamic> json) {
    responseCode = json['responseCode'];
    responseText = json['responseText'];
    if (json['responseData'] != null) {
      responseData = new List<ResponseData>();
      json['responseData'].forEach((v) {
        responseData.add(new ResponseData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['responseCode'] = this.responseCode;
    data['responseText'] = this.responseText;
    if (this.responseData != null) {
      data['responseData'] = this.responseData.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ResponseData {
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
  String buyIdEndTime;
  String randomId;
  TextSpan textSpan=TextSpan(text:"",style:TextStyle(fontSize: 12.0, color: Color(0xffff0000)));
  ResponseData(
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

  ResponseData.fromJson(Map<String, dynamic> json) {
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