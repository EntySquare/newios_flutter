import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myflutter/pages/bean/LoginBean.dart';
import 'package:myflutter/pages/bean/MessageBean.dart' as ms;
import 'package:myflutter/pages/bean/NetAddressBean.dart';
import 'package:myflutter/pages/bean/PlanWayBean.dart';
import 'package:myflutter/pages/bean/ResponseBean2.dart';
import 'package:myflutter/pages/dialog/NetLoadingDialog2.dart';
import 'package:myflutter/pages/dialog/delet_address_dialog.dart';
import 'package:myflutter/pages/dialog/navigation_dialog.dart';
import 'package:myflutter/pages/dialog/plan_way_dialog.dart';
import 'package:myflutter/pages/dialog/record_address_dialog.dart';
import 'package:myflutter/pages/util/ContactsUtil.dart';
import 'package:myflutter/pages/util/HttpContent.dart';
import 'package:myflutter/pages/util/LoginUtil.dart';
import 'package:myflutter/pages/util/NetUtil.dart';
import 'package:myflutter/pages/util/TextSpanUtil.dart';
import 'package:myflutter/pages/util/Toast.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:myflutter/pages/dialog/mark_all_message_read_dialog.dart';

/*消息列表界面*/
class MessageWidget extends StatefulWidget {
  MessageWidget({Key key}) : super(key: key);

  @override
  _MessageWidgetState createState() => _MessageWidgetState();
}

class _MessageWidgetState extends State<MessageWidget> {
  int _messageNum = 0;
  int _page = 1;
  int _pageSize = 20;
  List<ms.Data> messages = List();
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  bool isHasData = true;
  bool _enableLoadMore = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _netGetMessageNum();
    //_showLoadingMessageListDialog();
    Future.delayed(Duration(milliseconds: 500), () {
      _showLoadingMessageListDialog();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          child: AppBar(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  "消息中心",
                  style: TextStyle(color: Colors.white, fontSize: 18.0),
                ),
                Visibility(
                  child: Container(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(8.0, 5.0, 8.0, 5.0),
                      child: Text(
                        '$_messageNum',
                        style: TextStyle(
                            fontSize: 10.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10.0)),
                  ),
                  visible: _messageNum == 0 ? false : true,
                )
              ],
            ),
            backgroundColor: Color(0xff00afaf),
            centerTitle: true,
            actions: <Widget>[
              RaisedButton(
                onPressed: () async {
                  //标记所有消息可读
                  _markAllMessageRead();
                },
                child: Text(
                  "全部已读",
                  style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w700),
                ),
                color: Color(0xff00afaf),
              )
            ],
          ),
          preferredSize: Size.fromHeight(40.0)),
      body: Container(
        color: Color(0xffeeeeee),
        child: Padding(
          padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
          child: SmartRefresher(
            controller: this._refreshController,
            enablePullDown: true,
            enablePullUp: _enableLoadMore,
            header: WaterDropHeader(),
            footer:
                CustomFooter(builder: (BuildContext context, LoadStatus mode) {
              Widget body;
              if (mode == LoadStatus.idle) {
                body = Text("上拉加载...");
              } else if (mode == LoadStatus.loading) {
                body = CupertinoActivityIndicator();
              } else if (mode == LoadStatus.failed) {
                body = Text("加载失败,点击重载!");
              } else if (mode == LoadStatus.canLoading) {
                body = Text("松开加载更多");
              } else {
                body = Text("没有更多数据");
              }

              return Container(
                height: 55.0,
                child: Center(
                  child: body,
                ),
              );
            }),
            onRefresh: _onRefrash,
            onLoading: _loading,
            child: isHasData
                ? ListView.builder(
                    itemBuilder: (BuildContext context, int index) {
                      return getItemWidget(context, index);
                    },
                    itemCount: messages.length,
                  )
                : getNoDataWidget(),
          ),
        ),
      ),
    );
  }

  void _onRefrash() {
    //下拉刷新
    _page = 1;

    netGetMessageListNetTask();
    _netGetMessageNum();
  }

  void _loading() {
    //上拉加载

    _page++;
    netGetMessageListNetTask();
  }

  Widget getItemWidget(BuildContext context, int index) {
    ms.Data itemBean = messages[index];
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 20.0),
      child: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            getTopWidget(context, index, itemBean),
            Container(
              color: Color(0Xff00afaf),
              height: 2,
            ),
            getButtomWidget(context, index, itemBean)
          ],
        ),
      ),
    );
  }

  Widget getTopWidget(BuildContext context, int index, ms.Data bean) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                bean.isRead == 0
                    ? 'images/ic_speak_red.png'
                    : 'images/ic_speak_gray.png',
                height: 30.0,
                width: 30.0,
              ),
              Text(
                '地址信息来自--',
                style: TextStyle(
                    fontSize: 14.0,
                    color: bean.isRead == 0 ? Colors.red : Colors.black54,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                ContactsUtil.getNameFromPhoneNamber(bean.sendPhone),
                style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
              getRechText(context,
                  TextSpanUtil.buildTextSpanNoasy(context, bean.sendPhone))
            ],
          ),
          IconButton(
              icon: Image.asset(
                'images/ic_del.png',
                height: 35.0,
                width: 35.0,
              ),
              onPressed: () {
                //删除消息
                _netMessageRead("${bean.id}", index);
                deletMessage(index, bean);
              })
        ],
      ),
    );
  }

  Widget getButtomWidget(BuildContext context, int index, ms.Data bean) {
    return Padding(
      padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 10.0,
                ),
                Text(
                  bean.address.describe,
                  style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                Visibility(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              _netMessageRead("${bean.id}", index);
                              List<String> locations =
                                  bean.address.addressLocation.split(",");
                              _showNavigationDialog(
                                  bean.address.address,
                                  double.parse(locations[1]),
                                  double.parse(locations[0]));
                            },
                            child: Image.asset(
                              'images/ic_arrow_navigathion.png',
                              width: 30.0,
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                _netMessageRead("${bean.id}", index);
                                List<String> locations =
                                    bean.address.addressLocation.split(",");
                                _showNavigationDialog(
                                    bean.address.address,
                                    double.parse(locations[1]),
                                    double.parse(locations[0]));
                              },
                              child: Text(
                                '${bean.address.address != null ? bean.address.address : ''}',
                                style: TextStyle(
                                    fontSize: 14.0,
                                    color: Color(0xff00afaf),
                                    fontWeight: FontWeight.bold),
                                maxLines: 100,
                              ),
                            ),
                            flex: 1,
                          )
                        ],
                      ),
                    ),
                    visible:
                        bean.address.addressLocation == '0' ? false : true),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: RaisedButton(
                        onPressed: () {
                          _netMessageRead("${bean.id}", index);
                          _showNavigationDialog(
                              bean.address.describe,
                              double.parse(bean.address.lat),
                              double.parse(bean.address.longs));
                        },
                        child: Text(
                          '导航记录地点',
                          style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0))),
                        color: Color(0xff00afaf),
                      ),
                      flex: 1,
                    ),
                    Container(
                      width: 5.0,
                    ),
                    Expanded(
                      child: RaisedButton(
                        onPressed: () {
                          _netMessageRead("${bean.id}", index);
                          if (bean.address.atendLocation != "0") {
                            List<String> locations =
                                bean.address.atendLocation.split(",");
                            _showNavigationDialog(
                                bean.address.describe,
                                double.parse(locations[1]),
                                double.parse(locations[0]));
                          }
                        },
                        child: Text(
                          '导航纠正地点',
                          style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0))),
                        color: bean.address.atendLocation == '0'
                            ? Colors.grey
                            : Color(0xff00afaf),
                      ),
                      flex: 1,
                    )
                  ],
                ),
                Container(
                  height: 10.0,
                ),
              ],
            ),
            flex: 1,
          ),
          IconButton(
              icon: Image.asset(
                'images/ic_ji.png',
                height: 60.0,
                width: 60.0,
                fit: BoxFit.cover,
              ),
              onPressed: () {
                _netMessageRead("${bean.id}", index);
                _showRecordAddressDialog(bean, index);
              }),
          Container(
            width: 10.0,
          ),
          IconButton(
              icon: Image.asset('images/ico_way_planting.png'),
              onPressed: () {
                _netMessageRead("${bean.id}", index);
                _planWayDialog(bean, index);
              }),
        ],
      ),
    );
  }

  _netGetMessageNum() async {
    LoginBean loginBean = await LoginUtil.getLoginBean();
    try {
      Response response = await Dio().post(url + 'getNoReadAlert',
          data: {'phone': loginBean.phone},
          options: Options(
              headers: {"AUTHORIZATION": loginBean.token},
              responseType: ResponseType.plain));
      NetUtil.ifNetSuccessful(response, successfull: (ResponseBean2 result) {
        Map map = result.responseData;
        int number = map['countMessage'];
        //return number;
        setState(() {
          _messageNum = number;
        });
      }, faild: (result) {});
    } catch (e) {
      print(e);
    }
  }

  _showLoadingMessageListDialog() {
    NetLoadingDialog2 netLoadingDialog = NetLoadingDialog2(
      loadingText: "加载中。。。",
      outsideDismiss: false,
      requestCallBack: netGetMessageListNetTask(),
    );
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return netLoadingDialog;
        });
  }

  /*获取消息列表接口*/
  netGetMessageListNetTask() async {
    LoginBean loginBean = await LoginUtil.getLoginBean();
    var myurl = url + 'getAlertList';
    try {
      Response response = await Dio().post(url + 'getAlertList',
          data: {
            'phone': loginBean.phone,
            'page': _page,
            'pageSize': _pageSize
          },
          options: Options(
              headers: {"AUTHORIZATION": loginBean.token},
              responseType: ResponseType.plain));
      NetUtil.ifNetSuccessful(response, successfull: (responseBean) {
        String responseStr = response.toString();
        ms.MessagesBean messageBean = NetUtil.getMessageBean(responseStr);
        List<ms.Data> getData = messageBean.responseData.messages.data;
        if (_page == 1) {
          messages.clear();
          _enableLoadMore = true;
          if (getData.length == 0) {
            isHasData = false;
          } else {
            isHasData = true;
            messages.addAll(getData);
          }
          _refreshController.refreshCompleted();
        } else {
          _refreshController.loadComplete();
          if (getData.length == 0) {
            _enableLoadMore = false;
            Toast.toast(context, msg: '没有更多数据了');
          } else {
            messages.addAll(getData);
            _enableLoadMore = true;
          }
        }
        setState(() {});
      }, faild: (responseBean) {
        if (_page == 1) {
          _refreshController.refreshCompleted();
        } else {
          _refreshController.loadComplete();
        }
      });
    } catch (e) {
      if (_page == 1) {
        _refreshController.refreshCompleted();
      } else {
        _refreshController.loadComplete();
      }
      print(e);
    }
  }

  /*获得无数据界面*/
  Widget getNoDataWidget() {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            "images/ic_no_data.png",
            height: 80.0,
            width: 80.0,
            fit: BoxFit.cover,
          ),
          Text(
            "暂无消息，下拉刷新!",
            style: TextStyle(
                fontSize: 12.0,
                color: Color(0XFF00afaf),
                fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }

  Widget getRechText(context, TextSpan myTextSpan) {
    TextStyle style = TextStyle(fontSize: 14.0, color: Color(0xffff0000));
    TextStyle linkStyle;
    linkStyle = Theme.of(context)
        .textTheme
        .body1
        .merge(style)
        .copyWith(
          color: Colors.blueAccent,
          decoration: TextDecoration.underline,
        )
        .merge(linkStyle);
    RichText richText = RichText(
      textAlign: TextAlign.left,
      //textDirection: textDirection,
      //maxLines: maxLines,H
      // overflow: overflow,
      softWrap: true,
      textScaleFactor: MediaQuery.of(context).textScaleFactor,
      text: myTextSpan,
    );

    return richText;
  }

  void _showNavigationDialog(String address, double lat, double long) {
    /*x显示导航弹窗*/
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return NavigationDialog(
            address: address,
            lat: lat,
            long: long,
            isShowParking: true,
          );
        });
  }

  /*标记消息已读接口*/
  Future _netMessageRead(String id, int index) async {
    ms.Data bean = messages[index];
    if (bean.isRead == 1) {
      return;
    }
    LoginBean loginBean = await LoginUtil.getLoginBean();
    try {
      Response response = await Dio().post(url + 'updateAlert',
          data: {
            'id': id,
            'is_read': "1",
          },
          options: Options(
              headers: {"AUTHORIZATION": loginBean.token},
              responseType: ResponseType.plain));
      NetUtil.ifNetSuccessful(response, successfull: (responseBean) {
        setState(() {
          messages[index].isRead = 1;
          this._messageNum--;
        });
      }, faild: (responseBean) {});
    } catch (e) {
      print(e);
    }
  }

  /*记录地址弹窗*/
  _showRecordAddressDialog(ms.Data bean, int index) {
    ms.Address adressBean = bean.address;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          NetAddressBean netAddressBean = NetAddressBean();
          netAddressBean.describe = adressBean.describe;
          netAddressBean.remark = adressBean.remark;
          netAddressBean.kind = adressBean.kind;
          netAddressBean.address = adressBean.address;
          netAddressBean.addressLocation = adressBean.addressLocation;
          netAddressBean.atendLocation = adressBean.atendLocation;
          netAddressBean.path1 = adressBean.path1;
          netAddressBean.path2 = adressBean.path2;
          netAddressBean.path3 = adressBean.path3;
          netAddressBean.longs = adressBean.longs;
          netAddressBean.lat = adressBean.lat;
          return RecordAddressDialog(
            addressBean: netAddressBean,
            state: 1,
            confirmCallBack: (NetAddressBean myBean) {
              //记录地址成功界面
              Navigator.pop(context, 1);
              Navigator.pop(context, 1);
            },
          );
        }).then((state) {
      switch (state) {
        case 0:
          break;
        case 1:
          Toast.toast(context, msg: "记录成功。。。");
          break;
      }
    });
  }

  /*点击调整到规划路径弹窗*/

  void _planWayDialog(ms.Data bean, int index) {
    ms.Address adressBean = bean.address;
    PlanWayBean planWayBean = new PlanWayBean();
    planWayBean.descrileTitle = "记录地址";
    planWayBean.describleAdress = adressBean.describe;
    planWayBean.desCribleLocation = adressBean.longs + "," + adressBean.lat;
    planWayBean.ambutionTitle = "周边地址";
    planWayBean.ambutionAdress = adressBean.address;
    planWayBean.ambutionLocation = adressBean.addressLocation;
    planWayBean.atendTitle = "纠正地址";
    planWayBean.atendAdress = adressBean.describe;
    planWayBean.atendLocation = adressBean.atendLocation;
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (_) {
          return PlanWayDialog(planWayBean: planWayBean);
        });
  }

  /*删除消息弹窗弹窗*/
  void deletMessage(int index, ms.Data bean) async {
    LoginBean loginBean = await LoginUtil.getLoginBean();
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return DeletAdressDialog(() {
            //确定按钮
            Navigator.pop(context);
            this._netDeletShowDialog(index, bean, loginBean);
          }, null);
        });
  }

  _netDeletShowDialog(int index, ms.Data bean, LoginBean loginBean) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return NetLoadingDialog2(
            outsideDismiss: false,
            requestCallBack: _netDelectMessage(index, bean, loginBean),
            loadingText: "删除消息中....",
          );
        });
  }

  /*删除消息*/
  _netDelectMessage(int index, ms.Data bean, LoginBean loginBean) async {
    try {
      Response response = await Dio().post(url + 'delAlert',
          data: {
            'id': bean.id,
          },
          options: Options(headers: {"AUTHORIZATION": loginBean.token}));
      NetUtil.ifNetSuccessful(response, successfull: (responseBean) {
        setState(() {
          messages.removeAt(index);
        });
      }, faild: (responseBean) {});
    } catch (e) {
      print(e);
    }
  }

  /*标记所有消息已读*/
  void _markAllMessageRead() async {
    LoginBean loginBean = await LoginUtil.getLoginBean();
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return MarkAllMessageReadDialog(() {
            //确定按钮
            Navigator.pop(context);
            this._netAllMessageRedShowDialog(loginBean);
          });
        });
  }

  _netAllMessageRedShowDialog(LoginBean loginBean) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return NetLoadingDialog2(
            outsideDismiss: false,
            requestCallBack: _netMarKAllMessageRead(loginBean),
            loadingText: "标记中中....",
          );
        });
  }

  /*删除消息*/
  _netMarKAllMessageRead(LoginBean loginBean) async {
    try {
      Response response = await Dio().post(url + 'updateReadAll',
          data: {
            'phone': loginBean.phone,
          },
          options: Options(headers: {"AUTHORIZATION": loginBean.token},responseType:ResponseType.plain));
      NetUtil.ifNetSuccessful(response, successfull: (responseBean) {
        for (ms.Data itemBean in messages) {
          itemBean.isRead = 1;
        }
        setState(() {
          _messageNum = 0;
        });
      }, faild: (responseBean) {});
    } catch (e) {
      print(e);
    }
  }
}
