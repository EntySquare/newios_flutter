import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

/*用户协议界面*/
class ProtocolWidget extends StatefulWidget {
  var state; //默认0 显示用户协议界面，1表示隐私政策界面
  ProtocolWidget({Key key, @required this.state}) : super(key: key);

  @override
  _ProtocolWidgetState createState() => _ProtocolWidgetState(this.state);
}

class _ProtocolWidgetState extends State<ProtocolWidget> {
  var _state = 0;

  _ProtocolWidgetState(int inState) {
    this._state = inState;
  }

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
        appBar: PreferredSize(
        child: AppBar(
        title: Text(this._state==0?"用户协议":"隐私政策"
       ,
        style: TextStyle(color: Colors.white, fontSize: 18.0),
    ),
    backgroundColor: Color(0xff00afaf),
    centerTitle: true,
    ),
    preferredSize: Size.fromHeight(40.0)),
    url:this._state==0?"http://www.jdr321.com/privacy":"http://www.jdr321.com/privacys" ,
    withZoom: true,
    withLocalStorage: true,
    hidden: true,
    initialChild: Container(
    color: Colors.grey,
    child: const Center(
    child: Text('加载中.....'),
    ),
    )
    );


  }
}
