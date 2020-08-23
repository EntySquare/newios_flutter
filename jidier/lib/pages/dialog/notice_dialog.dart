import 'package:flutter/material.dart';

/*错误提示框*/
class NoticeDialog extends StatelessWidget {
  String content;

  NoticeDialog({this.content});

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Padding(
          padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
          child: Center(
              child: SizedBox(
            height: 120.0,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              child: Column(
                children: <Widget>[
                  Container(
                    height: 10.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "提示",
                        style: TextStyle(
                            fontSize: 18.0,
                            color: Color(0xffff0000),
                            fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  Container(
                    height: 20.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        content,
                        style: TextStyle(fontSize: 14.0),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                    child: Container(
                      color: Colors.grey,
                      height: 0.5,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                          flex: 1,
                          child: GestureDetector(
                            child: Container(
                              height: 43.5,
                              color: Colors.transparent,
                              alignment: Alignment.center,
                              child: Text(
                                "确定",
                                style: TextStyle(
                                    fontSize: 18.0, color: Colors.cyan),
                              ),
                            ),
                            onTap: () {
                              //确定按钮
                              Navigator.pop(context);
                            },
                          ))
                    ],
                  )
                ],
              ),
            ),
          ))),
    );
  }
}
