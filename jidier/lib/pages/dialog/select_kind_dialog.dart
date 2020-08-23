import 'package:flutter/material.dart';
import 'package:myflutter/pages/util/HttpContent.dart';
import 'package:wheel_chooser/wheel_chooser.dart';

/*选择地址种类弹窗*/
class SelectKindDialog extends StatefulWidget {
  var confirCallBack;
  int defaltPosition;

  SelectKindDialog({Key key, this.confirCallBack, this.defaltPosition})
      : super(key: key);

  @override
  _SelectKindDialogState createState() =>
      _SelectKindDialogState(confirCallBack, defaltPosition);
}

class _SelectKindDialogState extends State<SelectKindDialog> {
  var _confirCallBack;
  int _defaltPosition;
  String content="";
  _SelectKindDialogState(confirCallBack, defaltPosition) {
    this._confirCallBack = confirCallBack;
    this._defaltPosition = defaltPosition;
    this.content=kinds[this._defaltPosition];
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Material(
          type: MaterialType.transparency,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 10.0),
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                      alignment: Alignment.center,
                      height: 200.0,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.all(Radius.circular(20.0))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 0.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  flex: 1,
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      "取消",
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: GestureDetector(
                                    onTap: () {
                                      this._confirCallBack(this.content);
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      "确定",
                                      style: TextStyle(
                                          color: Color(0xff009898),
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: WheelChooser(
                              onValueChanged: (content) {
                                this.content=content;

                              },
                              datas: kinds,
                              startPosition: this._defaltPosition,
                              unSelectTextStyle: TextStyle(
                                  color: Colors.black, fontSize: 16.0,fontWeight:FontWeight.bold),
                              selectTextStyle: TextStyle(
                                  color: Color(0xff009898),
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      ),
                    ),
                  ))
            ],
          )),
    );
  }

  getListWidget() {
    var mykinds = kinds.map((content) {
      return Text(content);
    });
    return mykinds.toList();
  }
}
