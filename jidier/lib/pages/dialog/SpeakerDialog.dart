import 'dart:async';
import 'dart:math';
import 'package:wave_progress_bars/wave_progress_bars.dart';
import 'package:flutter/material.dart';

import '../../main.dart';

class SpeakerDialog extends StatefulWidget {
  String loadingText;
  bool outsideDismiss;
  Future<dynamic> requestCallBack;

  SpeakerDialog(
      {Key key,
      this.loadingText = "加载中...",
      this.outsideDismiss = true,
      this.requestCallBack})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SpeakerDialog();
  }
}

class _SpeakerDialog extends State<SpeakerDialog> {
  final List<double> values = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //if(_requestCallBack!=null){
//    widget.requestCallBack.then((speakContent) {
//      Navigator.pop(context, speakContent);
//    });
    // }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var rng = new Random();
    for (var i = 0; i < 100; i++) {
      values.add(rng.nextInt(70) * 1.0);
    }

    // TODO: implement build
    return GestureDetector(
      onTap: () {},
      child: Material(
        type: MaterialType.transparency,
        child: Center(
          child: SizedBox(
            width: 200.0,
            height: 200.0,
            child: Container(
              decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)))),
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Row(
                   mainAxisAlignment:MainAxisAlignment.end,
                   crossAxisAlignment:CrossAxisAlignment.center,
                   children: <Widget>[
                     IconButton(icon:Image.asset("images/ic_closed.png"), onPressed:(){
                        MyApp.platform.invokeMethod("stopSpeaker");
                     })
                   ],


                  ),


                  Padding(
                    padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                    child: WaveProgressBar(
                      width: 100.0,
                      progressPercentage: 20,
                      listOfHeights: values,
                      initalColor: Colors.grey,
                      progressColor: Color(0xff00afaf),
                      backgroundColor: Colors.white,
                      timeInMilliSeconds: 1000,
                      isHorizontallyAnimated: true,
                      isVerticallyAnimated: true,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20.0),
                    child: Text(
                      widget.loadingText,
                      style: new TextStyle(
                          fontSize: 18.0,
                          color: Color(0xff00afaf),
                          fontWeight: FontWeight.bold),
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
