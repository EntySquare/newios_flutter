import 'package:flutter/material.dart';
import 'package:myflutter/pages/bean/AdressDataBean.dart';

/*删除地址提示框*/
class DeletAdressDialog extends StatelessWidget {
  Function confirCallBack;
  ResponseData responseData;
  DeletAdressDialog(this.confirCallBack,this.responseData);

  @override
  Widget build(BuildContext context) {



    return GestureDetector(
      child: Material(
        type: MaterialType.transparency,
        child: Padding(
            padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
            child: Center(
                child: GestureDetector(
              child:Column(
                mainAxisAlignment:MainAxisAlignment.center,
                children: <Widget>[

                  Row(
                    children: <Widget>[
                      Expanded(child: getContentWidget(context),flex:1,)
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
  Widget getContentWidget(context){

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
          Container(
            alignment: Alignment.center,
            child: Text(
              responseData==null?"确定要删除此地址消息吗?":"确定要删除<<${responseData.describe}>>吗?\n删除后与此地址相关的二维码将失效!",
              style: TextStyle(
                  fontSize: 14.0, fontWeight: FontWeight.w700),
              textAlign: TextAlign.center,
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
                        style: TextStyle(
                            fontSize: 18.0, color: Colors.black),
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
                        "确定",
                        style: TextStyle(
                            fontSize: 18.0, color: Colors.cyan),
                      ),
                    ),
                    onTap: () {
                      //确定按钮
                      confirCallBack();
                    },
                  ))
            ],
          )
        ],
      ),
    );


  }



}
