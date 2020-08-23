import 'package:flutter/material.dart';

/*地址记录成功弹窗*/
class RecordSucessfulDialog extends StatefulWidget {
  RecordSucessfulDialog({Key key}) : super(key: key);

  @override
  _RecordSucessfulDialogState createState() => _RecordSucessfulDialogState();
}

class _RecordSucessfulDialogState extends State<RecordSucessfulDialog> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context, 0);
      },
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
                padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                child: GestureDetector(
                  onTap: () {},
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(20.0))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.fromLTRB(10.0, 10.0, 5.0, 0.0),
                          child: Text(
                            "记录地址成功",
                            style: TextStyle(
                                color: Color(0xff333333),
                                fontSize: 16.0,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(5.0, 10.0, 10.0, 10.0),
                          child: Image.asset(
                            "images/ic_shorter.png",
                            width: 100.0,
                            height: 70.0,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Divider(
                          color: Colors.grey,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                                flex: 1,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context, 1);
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        10.0, 10.0, 5.0, 20.0),
                                    child: Text(
                                      "跳转地址列表",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xff009898),
                                          fontSize: 14.0),
                                      textAlign: TextAlign.center,
                                     // maxLines:1,
                                      //overflow:TextOverflow.ellipsis,
                                    ),
                                  ),
                                )),
                            Container(
                              alignment: Alignment.center,
                              width: 1.0,
                              color: Colors.grey,
                            ),
                            Expanded(
                                flex: 1,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context, 0);
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        5.0, 10.0, 10.0, 20.0),
                                    child: Text(
                                      "留在当前页面",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xff009898),
                                          fontSize: 14.0),
                                      textAlign: TextAlign.center,
                                     // maxLines:1,
                                     // overflow:TextOverflow.ellipsis,
                                    ),
                                  ),
                                ))
                          ],
                        )
                      ],
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
