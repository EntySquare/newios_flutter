import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:myflutter/pages/bean/AdressDataBean.dart' as Adress;
import 'package:myflutter/pages/bean/LoginBean.dart';
import 'package:myflutter/pages/bean/QrInfoBean.dart';
import 'package:myflutter/pages/bean/ResponseBean.dart';
import 'package:myflutter/pages/dialog/NetLoadingDialog2.dart';
import 'package:myflutter/pages/dialog/share_dialog.dart';
import 'package:myflutter/pages/util/HttpContent.dart';
import 'package:myflutter/pages/util/LoginUtil.dart';
import 'package:myflutter/pages/util/NetUtil.dart';
import 'package:myflutter/pages/util/RegularUtil.dart';
import 'package:myflutter/pages/util/StringUtil.dart';
import 'package:myflutter/pages/util/SystemUtil.dart';
import 'package:myflutter/pages/util/Toast.dart';
import 'package:myflutter/pages/widget/QrImage.dart' as my;
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:ui' as ui;
import 'package:image_picker_saver/image_picker_saver.dart';
import 'package:path/path.dart' as path;
import 'package:myflutter/main.dart';

/*二维码界面*/
class QrCodeWidget extends StatefulWidget {
  Adress.ResponseData responseData;

  QrCodeWidget({Key key, this.responseData}) : super(key: key);

  @override
  _QrCodeWidgetState createState() => _QrCodeWidgetState(responseData);
}

class _QrCodeWidgetState extends State<QrCodeWidget> {
  Adress.ResponseData _responseData;
  String strQr = "";
  var _qrImage;
  String filePath = "";

  _QrCodeWidgetState(Adress.ResponseData responseData) {
    this._responseData = responseData;
  }

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if (strQr == "") {
      this._showGetQrInfo();
    }
  }

  @override
  Widget build(BuildContext context) {
    //this._showGetQrInfo();

    return Scaffold(
      appBar: PreferredSize(
          child: AppBar(
            title: Text(
              "地址二维码",
              style: TextStyle(color: Colors.white, fontSize: 16.0),
            ),
            backgroundColor: Color(0xff00afaf),
            centerTitle: true,
          ),
          preferredSize:
              Size.fromHeight(SystemUtil.getScreenSize(context).height * 0.07)),
      body: Container(
        alignment: Alignment.center,
        color: Color(0xffeeeeee),
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20.0))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: 5.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.fromLTRB(5.0, 5.0, 20.0, 0.0),
                          child: IconButton(
                              icon: Image.asset(
                                "images/ic_question.png",
                                height: 25.0,
                                width: 25.0,
                              ),
                              onPressed: () {
                                //print("点击跳转详情界面");
                                Navigator.pushNamed(context, "/qrInfoWidget",
                                    arguments: _responseData);
                              }),
                        )
                      ],
                    ),
                    getQrCodeWidget(),
                    getBottomButton(),
                    Container(
                      height: 10.0,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget getQrCodeWidget() {
    return Container(
        alignment: Alignment.center,
        height: 210.0,
        width: 220.0,
        decoration: BoxDecoration(
            color: Color(0xffeeeeee),
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        child: this.strQr == ""
            ? Container()
            : my.QrImage(
                padding: EdgeInsets.all(10.0),
                data: this.strQr,
                version: QrVersions.auto,
                gapless: true,
                size: 220.0,
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                errorStateBuilder: (ctx, err) {
                  return Center();
                },
                embeddedImage: AssetImage('images/jidier_erweima.png'),
                embeddedImageStyle: QrEmbeddedImageStyle(
                  size: Size(40, 40),
                ),
                imageCallBack: (image) {
                  this._qrImage = image;
                },
                address: this._responseData.describe,
              ));
  }

  Widget getBottomButton() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 0.0),
              child: RaisedButton(
                onPressed: () {
                  // print("保存二维码到手机相册");
                  // this._capturePng();
                  showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (_) {
                        return NetLoadingDialog2(
                          outsideDismiss: false,
                          loadingText: "图片保存中...",
                          requestCallBack: this._capturePng(),
                        );
                      });
                },
                color: Color(0xff009898),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0))),
                child: Text(
                  "保存二维码到手机相册",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w700),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            )
          ],
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
          child: GestureDetector(
            onTap: () {
              // print("点击转发第三方好友");
              this._showShareDialog();
            },
            child: Container(
              alignment: Alignment.center,
              // width: 140.0,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "转发第三方好友",
                    style: TextStyle(
                        fontSize: 14.0,
                        color: Color(0xff009898),
                        fontWeight: FontWeight.w700),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Icon(
                    Icons.share,
                    color: Color(0xff009898),
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  _showGetQrInfo() async {
    LoginBean loginBean = await LoginUtil.getLoginBean();

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return NetLoadingDialog2(
            outsideDismiss: false,
            loadingText: "二维码生成中...",
            requestCallBack: this._netGetQrInfo(loginBean),
          );
        });
  }

/*获得二维码信息接口*/
  _netGetQrInfo(LoginBean loginBean) async {
    try {
      Response response = await Dio().post(url + "getBuyAddrDate",
          data: {"id": this._responseData.id},
          options: Options(headers: {"AUTHORIZATION": loginBean.token}));

      NetUtil.ifNetSuccessful(response,
          successfull: (ResponseBean responseBean) {
        QrInfoBean qrInfoBean = NetUtil.getQrInfoBean(response.toString());
        Map<String, Object> map = Map<String, Object>();
        var uid = loginBean.id;
        map.addAll({
          "uid": "$uid",
          "id": this._responseData.id,
          "codeId": qrInfoBean.data.responseData.codeId,
          "jidier": ""
        });
        setState(() {
          strQr = StringUtil.getQrJsonStr(map);
        });
      }, faild: (ResponseBean responseBean) {
        Toast.toast(context, msg: responseBean.message, showTime: 1500);
      });
    } catch (e) {
      print(e);
      Toast.toast(context, msg: "生成二维码失败,请检查网络链接", showTime: 1500);
    }
  }

  Future<void> _capturePng() async {
    ByteData byteData =
        await this._qrImage.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData.buffer.asUint8List();
    //  print(pngBytes);

    var filePath = await ImagePickerSaver.saveFile(fileData: pngBytes);

    var savedFile = File.fromUri(Uri.file(filePath));
    setState(() {
      Future<File>.sync(() => savedFile);
    });

    // '保存成功'
    Toast.toast(context, msg: "保存成功", showTime: 1000);
    //NavigatorUtil.goBack(context);
  }

  _showShareDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return ShareDialog(
            shareCallBack: (int state) {
              switch (state) {
                case 0: //联系人分享
                  //Toast.toast(context, msg: '分享联系人');
                  Navigator.pushNamed(context, '/shareContactsWidget',
                      arguments: '${this._responseData.id}');
                  break;
                case 1: //微信分享
                  _wx();
                  break;
                case 2: //支付宝分享
                  _Alipay();
                  break;
                case 3: //qq分享
                  _qq();
                  break;
                default:
                  break;
              }
            },
          );
        });
  }

  /*分享到微信*/
  _share() async {
    ByteData finalByteData =
        await this._qrImage.toByteData(format: ui.ImageByteFormat.png);
    Uint8List finalPngBytes = finalByteData.buffer.asUint8List();
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    File tempFile = File(path.join(tempPath, 'dart.png'));
    await tempFile.writeAsBytes(finalPngBytes);
    return tempFile.path;
  }

  _wx() async {
    String path = await _share();
    var myresult = await MyApp.platform.invokeMethod("shareWx", path);
    var result = myresult ;
    switch (result) {
      case 0: //成功
        break;
      case 1: //失败
        break;
      case 2: //取消
        break;
    }
  }

  _Alipay() async {
    String path = await _share();
    int result = await MyApp.platform.invokeMethod("shareAlipay", path);
    switch (result) {
      case 0: //成功
        break;
      case 1: //失败
        break;
      case 2: //取消
        break;
    }
  }

  _qq() async {
    int result = await MyApp.platform
        .invokeMethod("shareQQ", [strQr, _responseData.describe]);
    switch (result) {
      case 0: //成功
        break;
      case 1: //失败
        break;
      case 2: //取消
        break;
    }
  }
}
