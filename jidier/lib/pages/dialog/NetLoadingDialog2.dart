import 'dart:async';

import 'package:flutter/material.dart';

class NetLoadingDialog2 extends StatefulWidget {
  String loadingText;
  bool outsideDismiss;


  Function dismissCallback;

  Future<dynamic> requestCallBack;

  NetLoadingDialog2(
      {Key key,
      this.loadingText = "加载中...",
      this.outsideDismiss = true,
      this.dismissCallback,
      this.requestCallBack})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {


     return  _LoadingDialog2();

  }
}


class _LoadingDialog2 extends State<NetLoadingDialog2> {



  _dismissDialog() {
    if (widget.dismissCallback != null) {
      widget.dismissCallback();
    }
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (widget.requestCallBack != null) {
      widget.requestCallBack.then((_) {
        Navigator.pop(context);
      });
    }



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
      onTap: widget.outsideDismiss ? _dismissDialog: null,

      child: Material(
        type:MaterialType.transparency,
        child: Center(

          child: SizedBox(
            width: 120.0,
            height: 120.0,
            child: Container(

              decoration: ShapeDecoration(
                  color:Colors.white,
                  shape: RoundedRectangleBorder(

                      borderRadius: BorderRadius.all(Radius.circular(8.0)
                      )
                  )
              ),
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                   new CircularProgressIndicator(),
                  new Padding(padding: EdgeInsets.only(top: 20.0),
                    child: Text(widget.loadingText,
                    style: new TextStyle(fontSize:14.0) ,
                    textScaleFactor:1,),
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
