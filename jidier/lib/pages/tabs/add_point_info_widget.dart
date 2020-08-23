import 'package:flutter/material.dart';
import 'package:myflutter/pages/bean/ItemPlanWayBean.dart';
import 'package:myflutter/pages/bean/PlanWayArgumentsBean.dart';
import 'package:myflutter/pages/tabs/NowLocation.dart';
import 'package:myflutter/pages/util/LocationDataUtil.dart';
import 'package:myflutter/pages/util/SharedPreferencesUtil.dart';
import 'package:myflutter/pages/dialog/delet_planitem_dialog.dart';
import 'package:myflutter/pages/dialog/delet_allplanitem_dialog.dart';
import 'package:myflutter/pages/util/Toast.dart';

/*添加点信息*/
class AddPointInfoWidget extends StatefulWidget {
  AddPointInfoWidget({Key key}) : super(key: key);

  @override
  _AddPointInfoWidgetState createState() => _AddPointInfoWidgetState();
}

class _AddPointInfoWidgetState extends State<AddPointInfoWidget> {
  NowLocation _nowlocation;
  bool ifCurrentStart = false;
  bool ifCurrentEnd = false;
  List<ItemPlanWayBean> beanData = new List();
  List getMapData = new List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this._nowlocation = LocationDataUtil.nowlocation;

    SharedPreferencesUtil.getPlanWay().then((List datas) {
      if (datas.length == 0) {
        return;
      }
      this.getMapData = datas;
      List<ItemPlanWayBean> tempData = List();
      for (Map<String, dynamic> itemMap in this.getMapData) {
        ItemPlanWayBean itemPlanBean = ItemPlanWayBean();
        itemPlanBean.address = itemMap["address"];
        itemPlanBean.lat = itemMap["lat"];
        itemPlanBean.lng = itemMap["lng"];
        tempData.add(itemPlanBean);
      }
      this.setState(() {
        this.beanData.addAll(tempData);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          child: AppBar(
            title: Text(
              "添加点信息",
              style: TextStyle(color: Colors.white, fontSize: 18.0),
            ),
            backgroundColor: Color(0xff00afaf),
            centerTitle: true,
            actions: <Widget>[
              RaisedButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (_) {
                        return DeletAllPlanItemDialog();
                      }).then((state) {
                    if (state != null && state == 1) {
                      SharedPreferencesUtil.deletAllPlanWay(context);
                      setState(() {
                        beanData.clear();
                      });
                    }
                  });
                },
                child: Text(
                  "清除",
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            getCurrentLocation(),
            Container(
              height: 10.0,
            ),
            getContentList(),
            getPlanWayButton(),
          ],
        ),
      ),
    );
  }

  /*获得顶部当前位置弹窗*/
  Widget getCurrentLocation() {
    return Container(
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Checkbox(
            value: this.ifCurrentStart,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            onChanged: (value) {
              if (value) {
                for (ItemPlanWayBean itemBean in beanData) {
                  itemBean.ifStart = false;
                }
              }
              this.setState(() {
                this.ifCurrentStart = value;
              });
            },
            activeColor: Colors.red,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
            child: Image.asset(
              "images/ico_start.png",
              width: 30.0,
              height: 30.0,
            ),
          ),
          Checkbox(
            value: this.ifCurrentEnd,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            onChanged: (value) {
              if (value) {
                for (ItemPlanWayBean itemBean in beanData) {
                  itemBean.ifEnd = false;
                }
              }
              this.setState(() {
                this.ifCurrentEnd = value;
              });
            },
            activeColor: Colors.red,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
            child: Image.asset(
              "images/ico_end.png",
              width: 30.0,
              height: 30.0,
            ),
          ),
          Container(
            width: 20.0,
          ),
          Text(
            "当前位置",
            style: TextStyle(
                fontSize: 14.0,
                color: Color(0xff333333),
                fontWeight: FontWeight.w700),
          )
        ],
      ),
    );
  }

  Widget getContentList() {
    return Expanded(
        child: ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        return getItemView(context, index);
      },
      physics: new AlwaysScrollableScrollPhysics(),
      itemCount: beanData.length,
    ));
  }

  Widget getItemView(BuildContext context, int index) {
    ItemPlanWayBean itemBean = beanData[index];
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Checkbox(
                value: itemBean.ifStart,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                onChanged: (value) {
                  if (value) {
                    this.ifCurrentStart = false;
                    for (ItemPlanWayBean itemBean in beanData) {
                      itemBean.ifStart = false;
                    }
                  }
                  this.setState(() {
                    itemBean.ifStart = value;
                  });
                },
                activeColor: Colors.red,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                child: Image.asset(
                  "images/ico_start.png",
                  width: 30.0,
                  height: 30.0,
                ),
              ),
              Checkbox(
                value: itemBean.ifEnd,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                onChanged: (value) {
                  if (value) {
                    this.ifCurrentEnd = false;
                    for (ItemPlanWayBean itemBean in beanData) {
                      itemBean.ifEnd = false;
                    }
                  }
                  this.setState(() {
                    itemBean.ifEnd = value;
                  });
                },
                activeColor: Colors.red,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                child: Image.asset(
                  "images/ico_end.png",
                  width: 30.0,
                  height: 30.0,
                ),
              ),
              Container(
                width: 20.0,
              ),
              Expanded(
                child: Text(
                  itemBean.address,
                  style: TextStyle(
                      fontSize: 14.0,
                      color: Color(0xff333333),
                      fontWeight: FontWeight.w700),
                ),
                flex: 1,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                child: IconButton(
                    icon: Image.asset("images/ic_del.png"),
                    onPressed: () {
                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (_) {
                            return DeletAdressDialog(itemBean.address, index);
                          }).then((state) {
                        if (state != null && state == 1) {
                          SharedPreferencesUtil.deletPlanWay(context, itemBean);
                          setState(() {
                            beanData.removeAt(index);
                          });
                        }
                      });
                      //删除按钮
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget getPlanWayButton() {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 10.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: RaisedButton(
              onPressed: () {
                btnPlanWay();
              },
              child: Text(
                "规划路径",
                style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.white,
                    fontWeight: FontWeight.w700),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              color: Color(0xff00afaf),
            ),
            flex: 1,
          )
        ],
      ),
    );
  }

  /*规划路径*/
  void btnPlanWay() {
    if (cheackCrrect()) {
      ItemPlanWayBean startBean = getStartBean();
      ItemPlanWayBean endBean = getEndBean();
      PlanWayArgumentsBean planWayArgumentsBean = PlanWayArgumentsBean();
      planWayArgumentsBean.startBean = startBean;
      planWayArgumentsBean.endBean = endBean;
      planWayArgumentsBean.pointsData = beanData;
     // Navigator.popAndPushNamed(context, '/planWayResultWidget',arguments:planWayArgumentsBean);
      Navigator.pop(context);
      Navigator.pushNamed(context, '/planWayResultWidget',
          arguments: planWayArgumentsBean);
      SharedPreferencesUtil.deletAllPlanWay(context);

    }
  }

/*检测是否正确*/
  bool cheackCrrect() {
    bool flag = false;
    if (beanData.length < 2) {
      Toast.toast(context, msg: "请至少添加两个地点规划");
      return false;
    }
    if (ifCurrentStart) {
      return true;
    }
    for (ItemPlanWayBean itemBean in beanData) {
      if (itemBean.ifStart) {
        return true;
      }
    }
    if (!flag) {
      Toast.toast(context, msg: "请选择开始点");
    }

    return flag;
  }

  /*获得开始实体类*/
  ItemPlanWayBean getStartBean() {
    ItemPlanWayBean startBean;
    if (ifCurrentStart) {
      startBean = ItemPlanWayBean();
      startBean.address = "当前位置";
      var lat = _nowlocation.lat;
      var lng = _nowlocation.lng;
      startBean.lat = "$lng";
      startBean.lng = "$lat";
      startBean.ifStart = true;
    } else {
      for (ItemPlanWayBean itemBean in beanData) {
        if (itemBean.ifStart) {
          startBean = itemBean;
          if (!itemBean.ifEnd) {
            beanData.remove(itemBean);
          }
          break;
        }
      }
    }
    return startBean;
  }

  /*获得结束实体类*/
  ItemPlanWayBean getEndBean() {
    ItemPlanWayBean endBean;
    if (ifCurrentEnd) {
      endBean = ItemPlanWayBean();
      endBean.address = "当前位置";
      var lat = _nowlocation.lat;
      var lng = _nowlocation.lng;
      endBean.lat = "$lng";
      endBean.lng = "$lat";
      endBean.ifEnd = true;
    } else {
      for (ItemPlanWayBean itemBean in beanData) {
        if (itemBean.ifEnd) {
          endBean = itemBean;
          beanData.remove(itemBean);
          break;
        }
      }
    }

    return endBean;
  }
}
