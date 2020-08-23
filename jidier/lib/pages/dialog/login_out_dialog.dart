import 'package:flutter/material.dart';

/*退出登录提示框*/
class LoginOutDialog extends StatelessWidget {
     Function confirCallBack;

   LoginOutDialog(this.confirCallBack);

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child:Column(
        mainAxisAlignment:MainAxisAlignment.center,
        crossAxisAlignment:CrossAxisAlignment.center,
        children: <Widget>[

          Row(
           children: <Widget>[

             Expanded(
               flex:1,
               child:Padding(padding: EdgeInsets.fromLTRB(10.0,0.0,10.0,0.0),
                 child:_getContent(context),
               )
             

             )
           ],
           
          )

        ],
      )
    );
  }
  
  Widget  _getContent(context){
    
    return Container(
      alignment:Alignment.center,

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
                "确定要退出登录吗？",
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
                      color: Colors.transparent,
                      height: 43.5,
                      alignment: Alignment.center,
                      child: Text(
                        "取消",
                        style: TextStyle(
                            fontSize: 16.0, color: Colors.black),
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
                      color:Colors.transparent,
                      alignment:Alignment.center,
                      child:Text(
                        "确定",
                        style: TextStyle(
                            fontSize: 16.0, color: Colors.cyan),
                      ),
                    ),
                    onTap: () { //确定按钮
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
