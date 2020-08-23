import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_qr_reader/flutter_qr_reader.dart';
import 'package:flutter_qr_reader/qrcode_reader_view.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myflutter/pages/bean/AdressDataBean.dart';
import 'package:myflutter/pages/bean/FindAdrBean.dart' as findBean;
import 'package:myflutter/pages/bean/LoginBean.dart';
import 'package:myflutter/pages/bean/NetAddressBean.dart';
import 'package:myflutter/pages/bean/ResponseBean.dart';
import 'package:myflutter/pages/dialog/NetLoadingDialog.dart';
import 'package:myflutter/pages/dialog/NetLoadingDialog2.dart';
import 'package:myflutter/pages/dialog/notice_dialog.dart';
import 'package:myflutter/pages/dialog/record_address_dialog.dart';
import 'package:myflutter/pages/util/HttpContent.dart';
import 'package:myflutter/pages/util/LoginUtil.dart';
import 'package:myflutter/pages/util/NetUtil.dart';
import 'package:myflutter/pages/util/StringUtil.dart';
import 'package:myflutter/pages/util/Toast.dart';
/*二维码扫码*/
class QrScanWidget extends StatefulWidget {
  QrScanWidget({Key key}) : super(key: key);

  @override
  _QrScanWidgetState createState() => _QrScanWidgetState();
}

class _QrScanWidgetState extends State<QrScanWidget> {
  GlobalKey<QrcodeReaderViewState> qrViewKey = GlobalKey();
  findBean.FindAdrBean findAdrBean;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:Stack(
          alignment:Alignment.topLeft,
          children: <Widget>[
            QrcodeReaderView(
              key: qrViewKey,
              onScan: _onScan,
            ),
            Padding(
              padding:EdgeInsets.fromLTRB(0.0,20.0, 10.0,10.0),

              child:IconButton(icon:Icon(Icons.close,color:Colors.white,),onPressed:(){
               // Navigator.pop(context);
                // Navigator.pop(context);
                _returnNext();
              }),
            )

          ],
        )

    );
  }

  Future _returnNext() async{
   //ImagePicker.pickImage(source: ImageSource.gallery);
    Navigator.pop(context);
  }

  Future _onScan(String data) async {
   // qrViewKey.currentState.startScan();
    if(data=='image'){ //假如是选择二维码图片；
      var image=   await ImagePicker.pickImage(source: ImageSource.gallery);
      if(image==null){
        qrViewKey.currentState.startScan();
        Navigator.pop(context);
        return null ;
      }
       data = await FlutterQrReader.imgScan(image);
    }




    if (data != null && data != "") {
      String result = StringUtil.getScanResultStr(data);
      try{
        var jsonMap = json.decode(result);
        if (jsonMap.containsKey("jidier")) { //扫描二维码成功

          //Toast.toast(context,msg:result);
          this._showFindAdrDialog(jsonMap);
        } else {
          //表示是无效二维码
         await this._showIneffectively();

        }


      }catch (e){
        print(e);
       await this._showIneffectively();
      }



    }else{//扫码失败
      await this._showIneffectively();
    }

  }
  /*显示无效二维码弹窗*/
   _showIneffectively() async{
   await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return NoticeDialog(
            content: "此二维码无效!",
          );
        });
   qrViewKey.currentState.startScan();

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
      }else {
        qrViewKey.currentState.startScan();
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
            qrViewKey.currentState.startScan();
          });
    } catch (e) {
      print(e);
      Toast.toast(context, msg: "网络请求失败,请检查网络!", showTime: 2000);
     // Navigator.pop(context);
      qrViewKey.currentState.startScan();
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
            state: 1,
            confirmCallBack: (NetAddressBean myBean) {
              //记录地址成功界面
              Navigator.pop(context, 1);
              Navigator.pop(context, 1);
            },
          );
        }).then((state) {
      switch (state) {
        case 0:
         // Toast.toast(context,msg:"quxiao");
        qrViewKey.currentState.startScan();
          break;
        case 1:
         Navigator.pop(context,1);
          break;
      }
    });
  }




}
