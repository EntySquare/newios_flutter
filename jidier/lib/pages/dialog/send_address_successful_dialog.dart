import 'package:flutter/material.dart';

/*发送地址成功弹窗*/
class SendAddressSuccessfulDialog extends StatelessWidget {
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
      onTap: () {
        Navigator.pop(context);
      },
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
                "分享成功",
                style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Container(
            height: 20.0,
          ),
          Container(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Image.asset('images/ic_shorter.png'),
                Container(
                  height: 10,
                ),
                Text(
                  '请好友在记地儿-我的-消息-查看分享地址',
                  style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.red,
                      fontWeight: FontWeight.bold),
                ),
                Container(
                  height: 10,
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
                        "继续分享",
                        style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
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
                        "返回上一页面",
                        style: TextStyle(
                            fontSize: 18.0,
                            color: Color(0xff00afaf),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    onTap: () {
                      //确定按钮
                      Navigator.pop(context, 1);
                    },
                  ))
            ],
          )
        ],
      ),
    );
  }
}
