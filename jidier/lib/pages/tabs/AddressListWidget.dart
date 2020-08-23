import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'address_item_widget.dart';
import 'package:myflutter/pages/util/BlankToolBarModel.dart';

class AddressListWidget extends StatefulWidget {
  AddressListWidget({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _addressListWidgetState();
  }
}

class _addressListWidgetState extends State<AddressListWidget>
    with TickerProviderStateMixin {
  List titels = <String>[
    "全部",
    "摇摇记",
    "随心记",
    "停车记",
    "住宅记",
    "景点记",
    "商店记",
    "公司记",
    "其它",
  ];
  List<Widget> widgets;
  TabController _controller;

  // Step1: 响应空白处的焦点的Node
  BlankToolBarModel blankToolBarModel = BlankToolBarModel();
  Size _screenSize;

  @override
  void initState() {
    // TODO: implement initState
    blankToolBarModel.outSideCallback = focusNodeChange;

    super.initState();
    // widgets=this._getTabs(titels);

    _controller = TabController(
        vsync: this,
        length: titels.length); //TabController(length: titels.length, vsync:);
    _controller.addListener(() {
      //  print(_controller.index);

      if (_controller.index.toDouble() == _controller.animation.value) {
        if (widgets != null) {
          AddressItemWidget widget = widgets[_controller.index];
          widget.addressItemWigetState.initAddressList();
        }
      }
    });
  }

// Step2.2: 焦点变化时的响应操作
  void focusNodeChange() {
    setState(() {});
  }

  @override
  void dispose() {
    // TODO: implement dispose
    blankToolBarModel.removeFocusListeners();
    super.dispose();
    this._controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _screenSize = MediaQuery.of(context).size;

    widgets = this._getTabViews(titels);
    // TODO: implement build
    return DefaultTabController(
      length: titels.length,
      child: Scaffold(
        appBar: PreferredSize(
            child: AppBar(
              elevation: 0,
              backgroundColor: Colors.white,
              title: Row(
                crossAxisAlignment:CrossAxisAlignment.center,
                mainAxisAlignment:MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: TabBar(
                      indicatorColor: Color(0xff00afaf),
                      indicatorWeight: 3,
                      isScrollable: true,
                      indicatorSize: TabBarIndicatorSize.label,
                      labelColor: Color(0xff00afaf),
                      unselectedLabelColor: Color(0xff333333),
                      tabs: this._getTabs(this.titels),
                      labelStyle: TextStyle(
                          fontSize: 14.0, fontWeight: FontWeight.bold),
                      unselectedLabelStyle: TextStyle(
                          fontSize: 14.0, fontWeight: FontWeight.bold),
                      controller: this._controller,
                    ),
                    flex: 1,
                  ),
                ],
              ),
            ),
            preferredSize: Size.fromHeight(_screenSize.height * 0.07)),
        body: BlankToolBarTool.blankToolBarWidget(context,
            model: blankToolBarModel,
            body: TabBarView(children: widgets, controller: this._controller)),
      ),
    );
  }

  List<Widget> _getTabs(List<String> titles) {
    List<Widget> widgets = List<Widget>();

    for (int i = 0; i < titles.length; i++) {
      widgets.add(Tab(
        text: titles[i],
      ));
    }
    return widgets;
  }

  List<Widget> _getTabViews(List<String> titles) {
    List<Widget> widgets = List<Widget>();

    for (int i = 0; i < titles.length; i++) {
      widgets.add(AddressItemWidget(
        kind: titles[i],
      ));
    }

    return widgets;
  }
}
