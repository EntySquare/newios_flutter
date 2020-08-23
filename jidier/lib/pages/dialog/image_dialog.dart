import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myflutter/pages/bean/ImageBean.dart';
import 'package:myflutter/pages/bean/ResponseBean.dart';
import 'package:myflutter/pages/dialog/NetLoadingDialog.dart';
import 'package:myflutter/pages/dialog/NetLoadingDialog2.dart';
import 'package:myflutter/pages/util/NetUtil.dart';
import 'package:myflutter/pages/util/Toast.dart';

import 'package:path_provider/path_provider.dart';
//import 'package:flutter_luban/flutter_luban.dart';
import 'package:myflutter/pages/util/HttpContent.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
/*选择照片弹窗*/
class ImageDialog extends StatefulWidget {
  var imageCallBack;

  ImageDialog({Key key, this.imageCallBack}) : super(key: key);

  @override
  _ImageDialogState createState() => _ImageDialogState(imageCallBack);
}

class _ImageDialogState extends State<ImageDialog> {
  var _imageCallBack;

  _ImageDialogState(imageCallBack) {
    this._imageCallBack = imageCallBack;
  }

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
                            this._takePhoto();
                          },
                          child: Text(
                            "拍照",
                            style: TextStyle(
                                color: Color(0xff009898),
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold),
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
                            this._openGalley();
                          },
                          child: Text(
                            "从相册选择",
                            style: TextStyle(
                                color: Color(0xff009898),
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold),
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
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold),
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

  /*拍照*/
  _takePhoto() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return NetLoadingDialog(
            outsideDismiss: true,
            loadingText: "照片压缩中...",
          );
        });
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    if (image != null) {
      Directory tempDir = await getTemporaryDirectory();
      testCompressAndGetFile(image, tempDir);
    } else {
      Navigator.pop(context);
    }
  }

  /*相册*/
  _openGalley() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return NetLoadingDialog(
            outsideDismiss: true,
            loadingText: "照片压缩中...",
          );
        });

    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      Directory tempDir = await getTemporaryDirectory();
      testCompressAndGetFile(image, tempDir);
    } else {
      Navigator.pop(context);
    }
  }

  testCompressAndGetFile(File file, tempDir) async {
//    CompressObject compressObject = CompressObject(
//      imageFile: file,
//      //image
//      path: tempDir.path,
//      //compress to path
//      quality: 90,
//      //first compress quality, default 80
//      step: 9,
//      //compress quality step, The bigger the fast, Smaller is more accurate, default 6
//      mode: CompressMode.AUTO, //default AUTO
//    );
//
//    Luban.compressImage(compressObject).then((_path) {
//      Navigator.pop(context);
//      var name = _path.substring(_path.lastIndexOf("/") + 1, _path.length);
//
//      FormData formData =
//          FormData.from({"file": UploadFileInfo(File(_path), name)});
           ImageProperties properties=await FlutterNativeImage.getImageProperties(file.path);
           File  croppedFile= await FlutterNativeImage.compressImage(file.path,quality:80,targetWidth: 600,targetHeight:(properties.height*600/properties.width).round());
           String cropPath=croppedFile.path;
           var name = cropPath.substring(cropPath.lastIndexOf("/") + 1, cropPath.length);
           //FormData formData = FormData.from({"file": UploadFileInfo(croppedFile, name)});
           Navigator.pop(context);

      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) {
            return NetLoadingDialog2(
              outsideDismiss: false,
              loadingText: "图片上传中.....",
              //requestCallBack: this._netUploadeImage(formData),
            );
          }).then((_){
            Navigator.pop(context);
      });
   // });
  }

  /*上传图片接口*/
  _netUploadeImage(FormData formData) async {
    try {
      Response response =
          await Dio().post(url+ "uploadAdrImg", data: formData);
       print(response.toString());

      NetUtil.ifNetSuccessful(response,
          successfull: (ResponseBean responseBean) {

            //Toast.toast(context,msg:"上传图片成功",showTime:1000);
            ImageBean  imageBean= NetUtil.getImageBean(response.toString());
            this._imageCallBack(imageBean.data.responseData[0]);
             // Navigator.pop(context);
             // Navigator.pop(context);
          },
          faild: (ResponseBean responseBean) {
        Toast.toast(context,msg:responseBean.message,showTime:1500);


          });
    } catch (e) {
      print(e);
      //Toast.toast(context,msg:"上传图片失败，请检查网络链接",showTime:1500);
    }
  }
}
