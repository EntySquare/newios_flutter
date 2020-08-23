import 'package:flutter/material.dart';
import 'package:myflutter/pages/util/RegularUtil.dart';
import 'package:myflutter/pages/util/Toast.dart';

/*输入分享联系人弹窗*/
class InputSharePhoneDialog extends StatefulWidget {
  InputSharePhoneDialog({Key key}) : super(key: key);

  @override
  _InputSharePhoneDialogState createState() => _InputSharePhoneDialogState();
}

class _InputSharePhoneDialogState extends State<InputSharePhoneDialog> {
  String _phone = '';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Material(
        type: MaterialType.transparency,
        child: Padding(
            padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
            child: Center(
                child: GestureDetector(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: getContentWidget(context),
                        flex: 1,
                      )
                    ],
                  ),
                ],
              ),
              onTap: () {},
            ))),
      ),
      onTap: () {},
    );
  }

  Widget getContentWidget(context) {
    return Container(
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
                "请输入分享手机号",
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
          Padding(
            padding: EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                  child: Text(
                    '手机号：',
                    style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: TextField(
                    autofocus: false,
                    decoration: InputDecoration(
                        isDense: true,
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Color(0xff00afaf), width: 2.0)),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Color(0xff00afaf), width: 2.0))),
                    keyboardType: TextInputType.phone,
                    cursorColor: Color(0xff00afaf),
                    maxLength: 11,
                    maxLines: 1,
                    onChanged: (text) {
                      _phone = text;
                    },
                  ),
                  flex: 1,
                )
              ],
            ),
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
                      color: Colors.transparent,
                      height: 43.5,
                      alignment: Alignment.center,
                      child: Text(
                        "取消",
                        style: TextStyle(fontSize: 18.0, color: Colors.black),
                      ),
                    ),
                    onTap: () {
                      //点击了取消按钮
                      Navigator.pop(context);
                    }),
              ),
              Container(
                width: 0.5,
                height: 43.5,
                color: Colors.grey,
              ),
              Expanded(
                  flex: 1,
                  child: GestureDetector(
                    child: Container(
                      height: 43.5,
                      color: Colors.transparent,
                      alignment: Alignment.center,
                      child: Text(
                        "分享",
                        style: TextStyle(fontSize: 18.0, color: Colors.cyan),
                      ),
                    ),
                    onTap: () {
                      //确定按钮
                      if (!RegularUtil.isChinaPhoneLegal(this._phone)) {
                        Toast.toast(context, msg: '请输入中国手机号');
                        return;
                      }

                      Navigator.pop(context, this._phone);
                    },
                  ))
            ],
          )
        ],
      ),
    );
  }
}
