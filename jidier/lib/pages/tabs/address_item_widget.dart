import 'package:date_format/date_format.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:myflutter/pages/bean/AdressDataBean.dart';
import 'package:myflutter/pages/bean/AsKindBean.dart';
import 'package:myflutter/pages/bean/AtentAddressBean.dart';
import 'package:myflutter/pages/bean/LoginBean.dart';
import 'package:myflutter/pages/bean/NetAddressBean.dart';
import 'package:myflutter/pages/bean/ResponseBean.dart';
import 'package:myflutter/pages/dialog/NetLoadingDialog2.dart';
import 'package:myflutter/pages/dialog/SpeakerDialog.dart';
import 'package:myflutter/pages/dialog/clear_screening_dialog.dart';
import 'package:myflutter/pages/dialog/delet_address_dialog.dart';
import 'package:myflutter/pages/dialog/merge_dialog.dart';
import 'package:myflutter/pages/dialog/navigation_dialog.dart';
import 'package:myflutter/pages/dialog/packing_dialog.dart';
import 'package:myflutter/pages/dialog/update_address_dialog.dart';
import 'package:myflutter/pages/tabs/adress_list_item_widget.dart';
import 'package:myflutter/pages/util/DataUtil.dart';
import 'package:myflutter/pages/util/HttpContent.dart';
import 'package:myflutter/pages/util/LoginUtil.dart';
import 'package:myflutter/pages/util/NetUtil.dart';
import 'package:myflutter/pages/util/PrintUtil.dart';
import 'package:myflutter/pages/util/TextSpanUtil.dart';
import 'package:myflutter/pages/util/Toast.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart'; //刷新控件
import 'package:myflutter/pages/dialog/plan_way_dialog.dart';
import 'package:myflutter/pages/bean/PlanWayBean.dart';

import '../../main.dart';

/*地址列表的元素界面*/
class AddressItemWidget extends StatefulWidget {
  String kind = "";
  _AddressItemWidgetState addressItemWigetState;

  AddressItemWidget({Key key, this.kind}) : super(key: key);

  @override
  _AddressItemWidgetState createState() {
    this.addressItemWigetState = _AddressItemWidgetState(kind);
    return this.addressItemWigetState;
  }
}

class _AddressItemWidgetState extends State<AddressItemWidget>
    with AutomaticKeepAliveClientMixin {
  AsKindBean _askindBean = AsKindBean();
  List<AsKindBean> _selectItems = List<AsKindBean>();
  String _kind = "";
  String _searchContent = "";

  DateTime _dateStartTime;
  DateTime _dateEndTime;
  int _page = 1;
  int _pageSize = 20;
  List data = List();
  bool isHasData = true; //判断是否有数据界面
  bool _enableLoadMore = true; //判断是否可以加载更多数据
  TextStyle style = TextStyle(fontSize: 12.0, color: Color(0xffff0000));
  TextStyle linkStyle;
  static const platform = const MethodChannel("jidier");
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  _AddressItemWidgetState(String kind) {
    this._kind = kind;

    for (int i = 0; i < 3; i++) {
      if (i == 0) {
        AsKindBean asKindBean = AsKindBean();
        asKindBean.postion = 0;
        asKindBean.kind = "按名称";
        this._selectItems.add(asKindBean);
      } else if (i == 1) {
        AsKindBean asKindBean = AsKindBean();
        asKindBean.postion = 1;
        asKindBean.kind = "按周边";
        this._selectItems.add(asKindBean);
      } else if (i == 2) {
        AsKindBean asKindBean = AsKindBean();
        asKindBean.postion = 2;
        asKindBean.kind = "按备注";
        this._selectItems.add(asKindBean);
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    //print("切换界面");
  }

/*头部界面布局*/
  Widget getTitleWidget() {
    return Container(
        // height: 80.0,
        alignment: Alignment.center,
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
          child: Column(
            children: <Widget>[
              Container(
                height: 5.0,
              ),
              Container(
                  // height: 40.0,
                  decoration: BoxDecoration(
                      color: Color(0xffeeeeee),
                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.search,
                          color: Color(0xff949494),
                        ),
                        Expanded(
                          flex: 1,
                          child: TextField(
                            decoration: InputDecoration(
                                hintText: "搜索",
                                hintStyle: TextStyle(fontSize: 16.0),
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none),
                            onChanged: (value) {
                              this._searchContent = value;
                              this.data.clear();
                              this._page = 1;
                              this._initAddressNodialog();
                            },
                            style: TextStyle(fontSize: 16.0),
                            onSubmitted: (value) {
                              //点击确定按钮
                              this.data.clear();
                              this._page = 1;
                              this.initAddressList();
                            },
                            controller: TextEditingController.fromValue(
                                TextEditingValue(
                                    text: this._searchContent,
                                    selection: TextSelection.fromPosition(
                                        TextPosition(
                                            offset:
                                                this._searchContent.length)))),
                            maxLines: 1,
                          ),
                        ),
                        IconButton(
                            icon: Image.asset('images/ic_speaker.png'),
                            onPressed: () {
                              showSpeakerDialog();
                            }),
                        Text(
                          this._askindBean.kind,
                          style: TextStyle(
                              fontSize: 14.0,
                              color: Color(0xff00afaf),
                              fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.visible,
                        ),
                        PopupMenuButton<AsKindBean>(
                          onSelected: (value) {
                            setState(() {
                              this._askindBean = value;
                            });
                          },
                          itemBuilder: (BuildContext context) {
                            return this
                                ._selectItems
                                .map<PopupMenuItem<AsKindBean>>(
                                    (AsKindBean asKindBean) {
                              return PopupMenuItem(
                                value: asKindBean,
                                child: Text(asKindBean.kind,
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        color: Color(0xff000000),
                                        fontWeight: FontWeight.bold)),
                              );
                            }).toList();
                          },
                        )
                      ],
                    ),
                  )),
              Container(
                height: 5.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                      flex: 1,
                      child: GestureDetector(
                          child: Container(
                            height: 30.0,
                            alignment: Alignment.center,
                            child: Text(
                              this.dateTimeToString(this._dateStartTime) == ""
                                  ? "筛选开始日期"
                                  : this.dateTimeToString(this._dateStartTime),
                              style: TextStyle(
                                  fontSize: 14.0,
                                  color: Color(0xff00afaf),
                                  fontWeight: FontWeight.bold),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          onTap: () {
                            this.showSartDatePiker();
                          })),
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                        child: Container(
                          height: 30.0,
                          alignment: Alignment.center,
                          child: Text(
                            this.dateTimeToString(this._dateEndTime) == ""
                                ? "筛选结束日期"
                                : this.dateTimeToString(this._dateEndTime),
                            style: TextStyle(
                                fontSize: 14.0,
                                color: Color(0xff00afaf),
                                fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        onTap: () {
                          // print(2);
                          this.showEndDatePiker();
                        }),
                  ),
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                        child: Container(
                          height: 30.0,
                          alignment: Alignment.center,
                          child: Text(
                            "清空筛选条件",
                            style: TextStyle(
                                fontSize: 14.0,
                                color: Color(0xffff0000),
                                fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        onTap: () {
                          this.showClearScreeningConditional();
                        }),
                  )
                ],
              ),
              Container(
                height: 5.0,
              )
            ],
          ),
        ));
  }

  void showSpeakerDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return SpeakerDialog(
            loadingText: "请说话。。。",
            outsideDismiss: false,
            requestCallBack: _sepeaker(),
          );
        }).then((speakContent) {
      if (speakContent != null && speakContent != "") {
        setState(() {
          _searchContent = speakContent;
        });
        this.data.clear();
        this._page = 1;
        this._initAddressNodialog();
      }
    });
  }

  _sepeaker() async {
    var result = await MyApp.platform.invokeMethod("speaker");
    Navigator.pop(context, result);
  }

  Widget getListWidget() {
    return Container(
        alignment: Alignment.topCenter,
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
            onRefresh: _onRefresh,
            onLoading: _onLoading,
            child: isHasData
                ? ListView.builder(
                    padding: EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 10.0),
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      ResponseData databean = this.data[index];

                      return getListItem(
                          index, databean, _itemCallBack(), context);
                    })
                : getNoDataWidget()));
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
            "暂无数据，下拉刷新数据!",
            style: TextStyle(
                fontSize: 12.0,
                color: Color(0XFF00afaf),
                fontWeight: FontWeight.w700),
          )
        ],
      ),
    );
  }

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    print("刷新");
//    _refreshController.refreshCompleted();
    this._page = 1;
    this.data.clear();
    LoginBean loaginBean = await LoginUtil.getLoginBean();
    this.netGetAddressList(1, context, loaginBean);
  }

  void _onLoading() async {
    this._page++;
    LoginBean loginBean = await LoginUtil.getLoginBean();

    netGetAddressList(2, context, loginBean);
  }

  /*清空筛选条件弹出框*/
  void showClearScreeningConditional() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return ClearScreeningDialog(() {
            //点击确定按钮

            Navigator.pop(context);

            setState(() {
              this._searchContent = "";
              this._dateStartTime = null;
              this._dateEndTime = null;
            });
            this._page = 1;
            this.data.clear();
            this.initAddressList();
          });
        });
  }

  void showSartDatePiker() {
//    DatePicker.showDatePicker(context,
//        maxDateTime: this._dateEndTime ?? DateTime.now(),
//        initialDateTime: this._dateEndTime ?? DateTime.now(),
//        dateFormat: "yyyy-MM-dd",
//        pickerTheme: DateTimePickerTheme(
//          itemTextStyle: TextStyle(
//              fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
//          cancel: Text(
//            "取消",
//            style: TextStyle(
//                color: Colors.black,
//                fontSize: 18.0,
//                fontWeight: FontWeight.bold),
//          ),
//          confirm: Text(
//            "确定",
//            style: TextStyle(
//                color: Color(0xff009898),
//                fontSize: 18.0,
//                fontWeight: FontWeight.bold),
//          ),
//        ), onConfirm: (DateTime selectTime, List<int> selectList) {
//      setState(() {
//        this._dateStartTime = selectTime;
//      });
//
//      this._page = 1;
//      this.data.clear();
//      this.initAddressList();
//    });
  }

  String dateTimeToString(DateTime dateTime) {
    if (dateTime == null) {
      return "";
    } else {
      return formatDate(dateTime, [yyyy, '-', mm, '-', dd]);
    }
  }

  void showEndDatePiker() {
//    if (this._dateStartTime == null) {
//      Toast.toast(context, msg: "请选择开始时间");
//      return;
//    }
//
//    DatePicker.showDatePicker(context,
//        maxDateTime: DateTime.now(),
//        minDateTime: this._dateStartTime,
//        initialDateTime: DateTime.now(),
//        dateFormat: "yyyy-MM-dd",
//        pickerTheme: DateTimePickerTheme(
//          itemTextStyle: TextStyle(
//              fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
//          cancel: Text(
//            "取消",
//            style: TextStyle(
//                color: Colors.black,
//                fontSize: 18.0,
//                fontWeight: FontWeight.bold),
//          ),
//          confirm: Text(
//            "确定",
//            style: TextStyle(
//                color: Color(0xff009898),
//                fontSize: 18.0,
//                fontWeight: FontWeight.bold),
//          ),
//        ), onConfirm: (DateTime selectTime, List<int> selectList) {
//      setState(() {
//        this._dateEndTime = selectTime;
//      });
//      this._page = 1;
//      this.data.clear();
//      this.initAddressList();
//    });
  }

  /*初始化地址列表*/
  initAddressList() async {
    if (data.length != 0) {
      return;
    }

    LoginBean loginBean = await LoginUtil.getLoginBean();

    // Future.delayed(Duration(milliseconds: 200)).then((e) {
    NetLoadingDialog2 netLoadingDialog = NetLoadingDialog2(
      loadingText: "加载地址列表中....",
      outsideDismiss: false,
      requestCallBack: netGetAddressList(0, context, loginBean),
    );

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return netLoadingDialog;
        });
    // });
  }

  _initAddressNodialog() async {
    if (data.length != 0) {
      return;
    }

    LoginBean loginBean = await LoginUtil.getLoginBean();

    netGetAddressList(0, context, loginBean);
  }

/*网络加载地址列表   which 0  表示初始化地址，1，下拉刷新 2，表示上拉加载更多*/
  netGetAddressList(int which, context, LoginBean loginBean) async {
    try {
      Response response = await Dio().post(url + "findAdr",
          data: {
            "page": this._page,
            "pageSize": this._pageSize,
            "state": this._askindBean.postion,
            "kind": this._kind == "全部" ? "" : this._kind,
            "searchContent": this._searchContent,
            "startTime": this._dateStartTime == null
                ? ""
                : formatDate(this._dateStartTime, [yyyy, '-', mm, '-', dd]) +
                    " 23:59:59",
            "endTime": this._dateEndTime == null
                ? ""
                : formatDate(this._dateEndTime, [yyyy, '-', mm, '-', dd]) +
                    " 23:59:59"
          },
          options: Options(headers: {"AUTHORIZATION": loginBean.token}));
      PrintUtil.myPrint(this._kind);
      PrintUtil.myPrint(response);
      NetUtil.ifNetSuccessful(response,
          successfull: (ResponseBean responseBean) async {
        if (which == 1) {
          this._refreshController.refreshCompleted();
        } else if (which == 2) {
          this._refreshController.loadComplete();
        }

        AdressDataBean addressDataBean =
            NetUtil.getAdressDataBean(response.toString());
        List<ResponseData> dataList = addressDataBean.data.responseData;
        if (this._page == 1) {
          //刷新界面数据
          if (dataList == null || dataList.length == 0) {
            setState(() {
              this.isHasData = false;
              this._enableLoadMore = false;
            });
          } else {
            List<ResponseData> newData = getNewData(dataList);
            setState(() {
              this.isHasData = true;
              data = newData;
              this._enableLoadMore = true;
            });
          }
        } else {
          //加载更多数据

          if (dataList == null || dataList.length == 0) {
            //没有更多数据
            setState(() {
              this._enableLoadMore = false;
            });
            Toast.toast(context, msg: "没有更多数据...");
          } else {
            List<ResponseData> newData = getNewData(dataList);
            //有更多数据
            data.addAll(newData);
            setState(() {});
          }
        }
      }, faild: (ResponseBean responseBean) {
        if (which == 0) {
          //Navigator.pop(context);
        } else if (which == 1) {
          this._refreshController.refreshCompleted();
        } else if (which == 2) {
          this._refreshController.loadComplete();
          this._page--;
        }
        Toast.toast(context, msg: responseBean.message);
      });
    } catch (e) {
      if (which == 0) {
        // Navigator.pop(context);
      } else if (which == 1) {
        this._refreshController.refreshCompleted();
      } else if (which == 2) {
        this._refreshController.loadComplete();
        this._page--;
      }

      print(e);
    }
  }

  List<ResponseData> getNewData(List<ResponseData> data) {
    for (ResponseData rd in data) {
      rd.textSpan = TextSpanUtil.buildTextSpanNoasy(context,
          rd.remark == null ? "" : rd.remark == "0" ? "" : "${rd.remark}");
    }

    return data;
  }

  @override
  void deactivate() {
    // TODO: implement deactivate
    super.deactivate();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if (this._kind == "全部") {
      this.initAddressList();
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Container(
        color: Color(0xffe8e8e8),
        child: Padding(
          padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              getTitleWidget(),
              Expanded(
                flex: 1,
                child: getListWidget(),
              )
            ],
          ),
        ));
  }

  /*item点击回调方法
  * state 点击标志
  * index 是哪个位置的item被点击了,responseData 点击的数据 */
  _itemCallBack() {
    return (int state, int index, ResponseData responseData) {
      switch (state) {
        case 0: //删除按钮
          // print("我点击了删除按钮");
          this.deletAddress(index, responseData);

          break;
        case 1: //周边地址
          // print("我点击了周边地址");
          _netClickTop(index, responseData);
          String addressLocation = responseData.addressLocation;
          List list = addressLocation.split(',');

          this._showNavigationDialog(responseData.address,
              double.parse(list[1]), double.parse(list[0]));

          break;
        case 2: //点击了照片按钮
          // print("我点击了照片按钮");
          this.jumpToShowPicWidget(responseData);
          break;
        case 3: //点击了合并按钮
          // print("我点击了合并按钮");
          _showMergeDialog(index, responseData);

          break;
        case 4: //点击了记录地点按钮
          //print("我点击了导航记录地点按钮");
          _netClickTop(index, responseData);
          this._showNavigationDialog(responseData.describe,
              double.parse(responseData.lat), double.parse(responseData.longs));
          break;
        case 5: //点击了纠正地点按钮
          //print("我点击了导航纠正地点按钮");
          _netClickTop(index, responseData);
          String atendLocation = responseData.atendLocation;
          List list = atendLocation.split(',');
          this._showNavigationDialog(responseData.describe,
              double.parse(list[0]), double.parse(list[1]));

          break;
        case 6: //点击了编辑地点按钮
          // print("我点击了编辑地点按钮");
          this._reviseAddress(index, responseData);
          break;
        case 7: //点击了纠正经纬度按钮
          // print("我点击了纠正经纬度按钮");
          AtentAddressBean atentAddressBean = AtentAddressBean();
          atentAddressBean.position = index;
          atentAddressBean.responseData = responseData;
          atentAddressBean.callBack = (int position, String atendlocation) {
            setState(() {
              ResponseData responseData = this.data[position];
              responseData.atendLocation = atendlocation;
            });
          };
          Navigator.pushNamed(context, "/atentAddressWidget",
              arguments: atentAddressBean);

          break;
        case 8: //点击了纠二维码按钮
          // print("我点击了二维码按钮");

          Navigator.pushNamed(context, "/qrCodeWidget",
              arguments: responseData);
          break;
        case 9: //点击了停车按钮
          _netClickTop(index, responseData);
          // _showPackingDialog(responseData);
          _planWayDialog(responseData);
          break;
      }
    };
  }

/*点击跳转停车场dialog*/
  void _showPackingDialog(ResponseData responseData) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (_) {
          return PackingDialog(responseData: responseData);
        });
  }

  /*点击调整到规划路径弹窗*/

  void _planWayDialog(ResponseData responseData) {
    PlanWayBean planWayBean = new PlanWayBean();
    planWayBean.descrileTitle = "记录地址";
    planWayBean.describleAdress = responseData.describe;
    planWayBean.desCribleLocation = responseData.longs + "," + responseData.lat;
    planWayBean.ambutionTitle = "周边地址";
    planWayBean.ambutionAdress = responseData.address;
    planWayBean.ambutionLocation = responseData.addressLocation;
    planWayBean.atendTitle = "纠正地址";
    planWayBean.atendAdress = responseData.describe;
    planWayBean.atendLocation = responseData.atendLocation;
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (_) {
          return PlanWayDialog(planWayBean: planWayBean);
        });
  }

  /*点击跳转到照片显示界面*/
  void jumpToShowPicWidget(ResponseData responseData) {
    Navigator.pushNamed(context, "/showPicWidget", arguments: responseData);
  }

  /*删除地址按钮*/
  void deletAddress(int postion, ResponseData responseData) async {
    LoginBean loginBean = await LoginUtil.getLoginBean();
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return DeletAdressDialog(() {
            //确定按钮
            Navigator.pop(context);
            this._netDeletShowDialog(postion, responseData, loginBean);
          }, responseData);
        });
  }

  _netDeletShowDialog(
      int positon, ResponseData responseData, LoginBean loginBean) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return NetLoadingDialog2(
            outsideDismiss: false,
            requestCallBack: _netDeletAddress(positon, responseData, loginBean),
            loadingText: "删除地址中....",
          );
        });
  }

  /*网络请求删除地址*/
  _netDeletAddress(
      int positon, ResponseData responseData, LoginBean loginBean) async {
    try {
      Response reponse = await Dio().delete(url + "AdrData/${responseData.id}",
          data: {},
          options: Options(headers: {"AUTHORIZATION": loginBean.token}));

      print(reponse.toString());
      NetUtil.ifNetSuccessful(reponse,
          successfull: (ResponseBean responseBean) {
        Toast.toast(context, msg: "删除成功!");
        setState(() {
          this.data.removeAt(positon);
        });
      }, faild: (ResponseBean responseBean) {
        Toast.toast(context, msg: responseBean.message);
      });
    } catch (e) {
      print(e);
      Toast.toast(context, msg: "删除失败！");
    }
  }

  /*x显示导航弹窗*/
  _showNavigationDialog(String address, double lat, double long) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return NavigationDialog(
            address: address,
            lat: lat,
            long: long,
          );
        });
  }

/*显示合并经纬度弹窗提示*/
  _showMergeDialog(int position, ResponseData responseData) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (_) {
          return MergeDialog(() {
            Navigator.pop(context);
            this._netMerge(position, responseData);
          }, responseData);
        });
  }

  /*网络请求 合并接口*/
  _netMerge(int position, ResponseData responseData) async {
    LoginBean loginBean = await LoginUtil.getLoginBean();

    NetAddressBean netAddressBean = new NetAddressBean();
    netAddressBean.times = DataUtil.currentTimeMillis();
    netAddressBean.state = 0;
    netAddressBean.buydate = 0;
    netAddressBean.months = 0;
    netAddressBean.endtime = 1;
    //-----------------------------------
    netAddressBean.id = responseData.id;
    netAddressBean.uid = responseData.uid;
    netAddressBean.describe = responseData.describe;
    netAddressBean.remark = responseData.remark;
    netAddressBean.kind = responseData.kind;
    netAddressBean.address = responseData.address;
    netAddressBean.addressLocation = responseData.addressLocation;
    String atentLocation = responseData.atendLocation;
    List<String> list = atentLocation.split(",");
    netAddressBean.atendLocation = "0";
    netAddressBean.longs = list[0];
    netAddressBean.lat = list[1];
    netAddressBean.path1 = responseData.path1;
    netAddressBean.path2 = responseData.path2;
    netAddressBean.path3 = responseData.path3;

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return NetLoadingDialog2(
            outsideDismiss: false,
            loadingText: "合并中...",
            requestCallBack:
                this._netUpdateAdress(position, netAddressBean, loginBean),
          );
        });
  }

/*网络更新地址接口*/
  _netUpdateAdress(
      int position, NetAddressBean netAddressBean, LoginBean loginBean) async {
    try {
      Response response = await Dio().put(url + "AdrData/${netAddressBean.id}",
          data: {
            "describe": netAddressBean.describe,
            "remark": netAddressBean.remark,
            "kind": netAddressBean.kind,
            "address": netAddressBean.address,
            "addressLocation": netAddressBean.addressLocation,
            "atendLocation": netAddressBean.atendLocation,
            "path1": netAddressBean.path1,
            "path2": netAddressBean.path2,
            "path3": netAddressBean.path3,
            "longs": netAddressBean.longs,
            "lat": netAddressBean.lat,
            "time": netAddressBean.times,
            "buydate": netAddressBean.buydate,
            "months": netAddressBean.months,
            "state": netAddressBean.state,
            "endtime": netAddressBean.endtime
          },
          options: Options(headers: {"AUTHORIZATION": loginBean.token}));

      NetUtil.ifNetSuccessful(response,
          successfull: (ResponseBean responseBean) {
        ResponseData responseData = this.data[position];
        TextSpanUtil.buildTextSpan(
                context,
                netAddressBean.remark == null
                    ? ""
                    : netAddressBean.remark == "0"
                        ? ""
                        : "${netAddressBean.remark}")
            .then((TextSpan mytextSapn) {
          setState(() {
            responseData.describe = netAddressBean.describe;
            responseData.remark = netAddressBean.remark;
            responseData.kind = netAddressBean.kind;
            responseData.address = netAddressBean.address;
            responseData.addressLocation = netAddressBean.addressLocation;
            responseData.atendLocation = netAddressBean.atendLocation;
            responseData.path1 = netAddressBean.path1;
            responseData.path2 = netAddressBean.path2;
            responseData.path3 = netAddressBean.path3;
            responseData.longs = netAddressBean.longs;
            responseData.lat = netAddressBean.lat;
            responseData.times = netAddressBean.times;
            responseData.buydate = netAddressBean.buydate;
            responseData.months = netAddressBean.months;
            responseData.state = netAddressBean.state;
            responseData.endtime = netAddressBean.endtime;
            responseData.textSpan = mytextSapn;
          });
        });

        Toast.toast(context, msg: responseBean.data.responseText);
      }, faild: (ResponseBean responseBean) {
        Toast.toast(context, msg: responseBean.message);
      });
    } catch (e) {
      Toast.toast(context, msg: "合并失败");
      print(e);
    }
  }

/*修改地址接口*/
  _reviseAddress(int position, ResponseData responseData) {
    NetAddressBean netAddressBean = NetAddressBean();
    netAddressBean.id = responseData.id;
    netAddressBean.uid = responseData.uid;
    netAddressBean.address = responseData.address ?? "0";
    netAddressBean.addressLocation = responseData.addressLocation ?? "0";
    netAddressBean.describe = responseData.describe ?? "0";
    netAddressBean.remark = responseData.remark ?? "0";
    netAddressBean.path1 = responseData.path1 ?? "0";
    netAddressBean.path2 = responseData.path2 ?? "0";
    netAddressBean.path3 = responseData.path3 ?? "0";
    netAddressBean.longs = responseData.longs ?? "0";
    netAddressBean.lat = responseData.lat ?? "0";
    netAddressBean.kind = responseData.kind;
    netAddressBean.randomId = responseData.randomId;
    netAddressBean.atendLocation = responseData.atendLocation ?? "0";
    netAddressBean.buyId = responseData.buyId;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return UpdateAddressDialog(
            addressBean: netAddressBean,
            confirmCallBack: (NetAddressBean netAddressBean) async {
              ResponseData responseData = this.data[position];
              TextSpan newTextSan = await TextSpanUtil.buildTextSpan(
                  context,
                  netAddressBean.remark == null
                      ? ""
                      : netAddressBean.remark == "0"
                          ? ""
                          : "${netAddressBean.remark}");
              setState(() {
                responseData.describe = netAddressBean.describe;
                responseData.remark = netAddressBean.remark;
                responseData.kind = netAddressBean.kind;
                responseData.address = netAddressBean.address;
                responseData.addressLocation = netAddressBean.addressLocation;
                responseData.atendLocation = netAddressBean.atendLocation;
                responseData.path1 = netAddressBean.path1;
                responseData.path2 = netAddressBean.path2;
                responseData.path3 = netAddressBean.path3;
                responseData.longs = netAddressBean.longs;
                responseData.lat = netAddressBean.lat;
                responseData.times = netAddressBean.times;
                responseData.buydate = netAddressBean.buydate;
                responseData.months = netAddressBean.months;
                responseData.state = netAddressBean.state;
                responseData.endtime = netAddressBean.endtime;
                responseData.textSpan = newTextSan;
              });
            },
          );
        });
  }

  /*点击地址置顶网络接口*/
  _netClickTop(int postion, ResponseData responseData) async {
    LoginBean loginBean = await LoginUtil.getLoginBean();

    try {
      Response response = await Dio().post(url + "updateAdrTime",
          data: {"id": responseData.id},
          options: Options(headers: {"AUTHORIZATION": loginBean.token}));
    } catch (e) {
      print(e);
    }
  }

  @override
  bool get wantKeepAlive => true;
}
