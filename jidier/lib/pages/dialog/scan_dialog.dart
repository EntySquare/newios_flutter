import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_qr_reader/flutter_qr_reader.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myflutter/pages/bean/FindAdrBean.dart';
import 'package:myflutter/pages/bean/ImageBean.dart';
import 'package:myflutter/pages/bean/LoginBean.dart';
import 'package:myflutter/pages/bean/NetAddressBean.dart';
import 'package:myflutter/pages/bean/ResponseBean.dart';
import 'package:myflutter/pages/dialog/NetLoadingDialog.dart';
import 'package:myflutter/pages/dialog/NetLoadingDialog2.dart';
import 'package:myflutter/pages/dialog/record_address_dialog.dart';
import 'package:myflutter/pages/util/LoginUtil.dart';
import 'package:myflutter/pages/util/NetUtil.dart';
import 'package:myflutter/pages/util/StringUtil.dart';
import 'package:myflutter/pages/util/Toast.dart';

import 'package:path_provider/path_provider.dart';
//import 'package:flutter_luban/flutter_luban.dart';
import 'package:myflutter/pages/util/HttpContent.dart';
import 'package:flutter_native_image/flutter_native_image.dart';

import 'notice_dialog.dart';
/*选择照片弹窗*/
class ScanDialog extends StatefulWidget {

  ScanDialog({Key key}) : super(key: key);

  @override
  _ScanDialogState createState() => _ScanDialogState();
}

class _ScanDialogState extends State<ScanDialog> {
 FindAdrBean findAdrBean;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Material(
          type: MaterialType.transparency,
          child: Padding(
            padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: RaisedButton(
                          onPressed: () {
                            this._selectPhoto();
                          },
                          child: Text(
                            "识别二维码图片",
                            style: TextStyle(
                                color: Color(0xff009898),
                                fontSize: 15.0,
                                fontWeight: FontWeight.w700),
                          ),
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0)))),
                    ),
                  ],
                ),
                Container(
                  height: 5.0,
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: RaisedButton(
                          onPressed: () {
                            this._scanQr();
                          },
                          child: Text(
                            "扫描二维码",
                            style: TextStyle(
                                color: Color(0xff009898),
                                fontSize: 15.0,
                                fontWeight: FontWeight.w700),
                          ),
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0)))),
                    ),
                  ],
                ),
                Container(
                  height: 5.0,
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: RaisedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            "取消",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 15.0,
                                fontWeight: FontWeight.w700),
                          ),
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0)))),
                    ),
                  ],
                )
              ],
            ),
          )),
    );
  }

  /*选择照片弹窗*/
  _selectPhoto() async {

    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    if (image != null) {
     var data = await FlutterQrReader.imgScan(image);

     if (data != null && data != "") {
       String result = StringUtil.getScanResultStr(data);
       try{
         var jsonMap = json.decode(result);
         if (jsonMap.containsKey("jidier")) { //扫描二维码成功

           //Toast.toast(context,msg:result);
           this._showFindAdrDialog(jsonMap);
         } else {
           //表示是无效二维码
            this._showIneffectively();

         }


       }catch (e){
         print(e);
          this._showIneffectively();
       }

     }else{//扫码失败
        this._showIneffectively();
     }
    }
  }
/*显示无效二维码弹窗*/
  _showIneffectively() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return NoticeDialog(
            content: "此二维码无效!",
          );
        });


  }
  /*扫描二维码弹窗*/
  _scanQr() async {
    Navigator.pushNamed(context, "/qrScanWidget",arguments:"0").then((state){
      switch(state){
        case 0:

          break;
        case 1 :
          Navigator.pop(context,1);

          break;


      }
    });


  }
/*网络请求 开始加载数据*/
  _showFindAdrDialog(jsonResult) async {
    LoginBean loginBean = await LoginUtil.getLoginBean();
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return NetLoadingDialog2(
            loadingText: "获取地址中...",
            outsideDismiss: false,
            requestCallBack: _netFindAdr(loginBean, jsonResult),
          );
        }).then((_) {
      if (findAdrBean != null) {
        var responseData = findAdrBean.data.responseData[0];
        //this._showQrRecordAddressDialog(responseData);
        _showQrRecordAddressDialog(responseData);
      }
    });
  }
  /*网络请求找到地址二维码*/
  _netFindAdr(LoginBean loginBean, jsonResult) async {
    try {
      Response response = await Dio().post(url + 'getAdr',
          data: {"codeId": jsonResult["codeId"], "id": jsonResult["id"]},
          options: Options(headers: {"AUTHORIZATION": loginBean.token}));
      NetUtil.ifNetSuccessful(response,
          successfull: (ResponseBean responseBean) {
            findAdrBean = NetUtil.getFindAdrBean(response.toString());
            // Navigator.pop(context, findAdrBean);

          }, faild: (ResponseBean responseBean) {
            Toast.toast(context, msg: responseBean.data.responseText);
            // Navigator.pop(context);

          });
    } catch (e) {
      print(e);
      Toast.toast(context, msg: "网络请求失败,请检查网络!", showTime: 2000);


    }
  }
  /*显示扫描二维码弹窗*/
  _showQrRecordAddressDialog(responseData) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          NetAddressBean netAddressBean = NetAddressBean();

          netAddressBean.describe = responseData.describe;
          netAddressBean.remark = responseData.remark;
          netAddressBean.kind = responseData.kind;
          netAddressBean.address = responseData.address;
          netAddressBean.addressLocation = responseData.addressLocation;
          netAddressBean.atendLocation = responseData.atendLocation;
          netAddressBean.path1 = responseData.path1;
          netAddressBean.path2 = responseData.path2;
          netAddressBean.path3 = responseData.path3;
          netAddressBean.longs = responseData.longs;
          netAddressBean.lat = responseData.lat;
          return RecordAddressDialog(
            addressBean: netAddressBean,
            state:1,
            confirmCallBack: (NetAddressBean myBean) {
              //记录地址成功界面
              Navigator.pop(context, 1);
              Navigator.pop(context, 1);
            },
          );
        }).then((state) {
      switch (state) {
        case 0:
          break;
        case 1:
         Navigator.pop(context,1);
          break;
      }
    });
  }



}
