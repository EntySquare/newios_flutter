import 'package:flutter/material.dart';

/*分享弹窗*/
class ShareDialog extends StatefulWidget {
  var shareCallBack;

  ShareDialog({Key key, this.shareCallBack}) : super(key: key);

  @override
  _ShareDialogState createState() => _ShareDialogState(shareCallBack);
}

class _ShareDialogState extends State<ShareDialog> {
  var _shareCallBack;

  _ShareDialogState(shareCallBack) {
    this._shareCallBack = shareCallBack;
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
          padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                onTap: () {},
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: 50.0,
                          ),
                          Expanded(
                              flex: 1,
                              child: Text(
                                "转发好友",
                                style: TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700),
                                textAlign: TextAlign.center,
                              )),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0.0, 0.0, 20.0, 0.0),
                            child: IconButton(
                                icon: Image.asset(
                                  "images/ic_closed.png",
                                  height: 25.0,
                                  width: 25.0,
                                  fit: BoxFit.cover,
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                }),
                          )
                        ],
                      ),
                      Container(
                        height: 5.0,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Container(),
                          ),
                          getIcoButton(0),
                          Expanded(
                            flex: 1,
                            child: Container(),
                          ),
                          getIcoButton(1),
                          Expanded(
                            flex: 1,
                            child: Container(),
                          ),
                          getIcoButton(2),
                          Expanded(
                            flex: 1,
                            child: Container(),
                          )
                        ],
                      ),
                      Row(
                        crossAxisAlignment:CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Container(),
                          ),
                          getIcoButton(3),
                          Expanded(
                            flex: 1,
                            child: Container(),
                          ),
                          getIcoButton(4),
                          Expanded(
                            flex: 1,
                            child: Container(),
                          ),
                          getIcoButton(4),
                          Expanded(
                            flex: 1,
                            child: Container(),
                          )

                        ],



                      )

                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  /*state 0 表示 微信，1 表示支付宝  2,表示qq 好友*/
  Widget getIcoButton(int state) {
    String imagePath = "";
    String title = "";
    switch (state) {
      case 0:
        imagePath = "images/ico_contacts.png";
        title = "手机联系人";
        break;
      case 1:
        imagePath = "images/ic_wei_chat.png";
        title = "微信好友";
        break;
      case 2:
        imagePath = "images/ic_zhifubao.png";
        title = "支付宝好友";
        break;
      case 3:
        imagePath = "images/ic_qq.png";
        title = "QQ好友";
        break;
      default:
        imagePath = "";
        title = "";
        break;
    }

    return SizedBox(
      width: 80.0,
      //height: 80.0,
      child: GestureDetector(
        onTap: () {
          this._shareCallBack(state);
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              imagePath,
              width: 40.0,
              height: 40.0,
              fit: BoxFit.cover,
            ),
            Container(
              height: 5.0,
            ),
            Text(
              title,
              style: TextStyle(fontSize: 12.0, color: Colors.black),
              maxLines:1,
              overflow:TextOverflow.ellipsis,
            )
          ],
        ),
      ),
    );
  }
}
