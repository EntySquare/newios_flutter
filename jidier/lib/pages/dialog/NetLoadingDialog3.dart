import 'dart:async';

import 'package:flutter/material.dart';

class NetLoadingDialog3 extends StatefulWidget {
  String loadingText;
  bool outsideDismiss;
  Future<dynamic> requestCallBack;

  NetLoadingDialog3(
      {Key key,
      this.loadingText = "加载中...",
      this.outsideDismiss = true,
      this.requestCallBack})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _LoadingDialog3();
  }
}

class _LoadingDialog3 extends State<NetLoadingDialog3> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //if(_requestCallBack!=null){
    widget.requestCallBack.then((responseBean) {
      Navigator.pop(context, responseBean);
    });
    // }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GestureDetector(
      onTap: () {},
      child: Material(
        type: MaterialType.transparency,
        child: Center(
          child: SizedBox(
            width: 120.0,
            height: 120.0,
            child: Container(
              decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)))),
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  new CircularProgressIndicator(),
                  new Padding(
                    padding: EdgeInsets.only(top: 20.0),
                    child: Text(
                      widget.loadingText,
                      style: new TextStyle(fontSize: 14.0),
                      textScaleFactor: 1,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
