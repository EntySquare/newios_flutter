import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myflutter/pages/bean/AdressDataBean.dart';
import 'package:myflutter/pages/util/DataUtil.dart';
import 'package:myflutter/pages/util/HttpContent.dart';

Widget getListItem(int index, ResponseData responseData, callBack, context) {
  return Padding(
    padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
    child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        child: Padding(
          padding: EdgeInsets.fromLTRB(10.0, 5.0, 0.0, 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    flex: 6,
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        DataUtil.intDataToString(responseData.times),
                        style:
                            TextStyle(fontSize: 14.0, color: Color(0xff333333)),
                        //textScaleFactor:1,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        responseData.kind,
                        style: TextStyle(fontSize: 18.0, color: Colors.black),
                        textScaleFactor: 1,
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    width: 60.0,
                    height: 50.0,
                    child: IconButton(
                      icon: Image.asset("images/ico_way_planting.png"),
                      onPressed: () {
                        //点击停车场按钮
                        callBack(9, index, responseData);
                      },
                    ),
                  ),
                  Container(
                    width: 60.0,
                    alignment: Alignment.center,
                    child: IconButton(
                        icon: Padding(
                          padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                          child: Image.asset("images/ic_del.png"),
                        ),
                        onPressed: () {
                          callBack(0, index, responseData);
                        }),
                  ),
                ],
              ),
              getContentWidget(index, responseData, responseData.textSpan,
                  callBack, context),
              getBottomWidget(index, responseData, callBack)
            ],
          ),
        )),
  );
}

Widget getContentWidget(int index, ResponseData responseData, TextSpan textSpan,
    callBack, context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Padding(
        padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 5.0),
        child: Text(
          responseData.describe,
          style: TextStyle(
              color: Color(0xff000000),
              fontSize: 16.0,
              fontWeight: FontWeight.bold),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          //textScaleFactor: 1,
        ),
      ),
      isShowGaoDeAddress(index, responseData, callBack),
      Padding(
        padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
        child: getRechText(
            context,
            responseData.remark == null
                ? ""
                : responseData.remark == "0" ? "" : "${responseData.remark}",
            textSpan),
      ),
      ifShowPic(index, responseData, callBack)
    ],
  );
}

/*界面底部按钮*/
Widget getBottomWidget(int index, ResponseData responseData, callBack) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: <Widget>[
      Expanded(
        flex: 5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              child: Padding(
                padding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 0.0),
                child: Image.asset(
                  responseData.atendLocation == null
                      ? "images/ic_gray_merge.png"
                      : responseData.atendLocation == "0"
                          ? "images/ic_gray_merge.png"
                          : "images/ic_blue_merge.png",
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              onTap: () {
                if (responseData.atendLocation == null ||
                    responseData.atendLocation == "0") {
                } else {
                  callBack(3, index, responseData); //点击了合并按钮
                }
              },
            ),
            Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Color(0xff00afaf),
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0))),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(3.0, 8.0, 3.0, 8.0),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Text(
                            "导航记录地点",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold),
                            //textScaleFactor: 1,
                          ),
                        ),
                      ),
                    ),
                    onTap: () {
                      callBack(4, index, responseData); //点击了导航记录地点
                    },
                  ),
                ),
                Container(
                  width: 10.0,
                ),
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: responseData.atendLocation == null
                              ? Color(0xffe1e1e1)
                              : responseData.atendLocation == "0"
                                  ? Color(0xffe1e1e1)
                                  : Color(0xff00afaf),
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0))),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(3.0, 8.0, 3.0, 8.0),
                        child: SingleChildScrollView(
                          scrollDirection:Axis.horizontal,
                          child: Text(
                            responseData.atendLocation == null
                                ? "没有纠正地点"
                                : responseData.atendLocation == "0"
                                    ? "没有纠正地点"
                                    : "导航纠正地点",
                            style: TextStyle(
                                color: responseData.atendLocation == null
                                    ? Color(0xff333333)
                                    : responseData.atendLocation == "0"
                                        ? Color(0xff333333)
                                        : Colors.white,
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold),
                            //textScaleFactor: 1,
                            maxLines: 1,
                          ),
                        ),
                      ),
                    ),
                    onTap: () {
                      if (responseData.atendLocation == null ||
                          responseData.atendLocation == "0") return;
                      callBack(5, index, responseData); //点击了导航纠正地点
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
      Expanded(
        flex: 4,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //Image.asset("images/change_content.png")

            IconButton(
              icon: Image.asset("images/change_content.png"),
              onPressed: () {
                //print("点击修改内容");
                callBack(6, index, responseData);
              },
            ),
            IconButton(
              icon: Image.asset("images/ic_currect.png"),
              onPressed: () {
                //print("点击纠正位置");
                callBack(7, index, responseData);
              },
            ),
            IconButton(
              icon: Image.asset("images/ic_button_erweima.png"),
              onPressed: () {
                // print("点击二维码图标");
                callBack(8, index, responseData);
              },
            ),
          ],
        ),
      )
    ],
  );
}

Widget isShowGaoDeAddress(int index, ResponseData responseData, callBack) {
  if (responseData.address == null || responseData.address == "0") {
    return Container(
      height: 0.0,
    );
  } else {
    return Container(
      alignment: Alignment.centerLeft,
      child: GestureDetector(
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: <Widget>[
            Image.asset(
              "images/ic_arrow_navigathion.png",
              width: 26.0,
              height: 20.0,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(30.0, 0.0, 0.0, 0.0),
              child: Text(
                "周边-" + responseData.address,
                style: TextStyle(
                    fontSize: 14.0,
                    color: Color(0xff13a0e3),
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
                // textScaleFactor: 1,
                maxLines: 1,
              ),
            )
          ],
        ),
        onTap: () {
          callBack(1, index, responseData);
        },
      ),
    );
  }
}

/*判断是否显示照片*/
Widget ifShowPic(int index, ResponseData responseData, callBack) {
  if ((responseData.path1 == null || responseData.path1 == "0") &&
      (responseData.path2 == null || responseData.path2 == "0") &&
      (responseData.path3 == null || responseData.path3 == "0")) {
    return Container(
      height: 1.0,
    );
  } else {
    return Padding(
        padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
        child: GestureDetector(
          child: SizedBox(
            width: 200,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                showPic(index, responseData, callBack, 0),
                Container(
                  width: 5.0,
                ),
                showPic(index, responseData, callBack, 1),
                Container(
                  width: 5.0,
                ),
                showPic(index, responseData, callBack, 2),
              ],
            ),
          ),
          onTap: () {
            callBack(2, index, responseData);
          },
        ));
  }
}

Widget getRechText(context, text, TextSpan myTextSpan) {
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

Widget showPic(int index, ResponseData responseData, callBack, int postion) {
  if (postion == 0) {
    if (responseData.path1 == null || responseData.path1 == "0") {
      return Image.asset(
        "images/no_banner.png",
        width: 50.0,
        height: 50.0,
        fit: BoxFit.cover,
      );
    } else {
      return Image.network(
        IMAGE_URL + responseData.path1,
        width: 50.0,
        height: 50.0,
        fit: BoxFit.cover,
      );
    }
  } else if (postion == 1) {
    if (responseData.path2 == null || responseData.path2 == "0") {
      return Image.asset(
        "images/no_banner.png",
        width: 50.0,
        height: 50.0,
        fit: BoxFit.cover,
      );
    } else {
      return Image.network(
        IMAGE_URL + responseData.path2,
        width: 50.0,
        height: 50.0,
        fit: BoxFit.cover,
      );
    }
  } else if (postion == 2) {
    if (responseData.path3 == null || responseData.path3 == "0") {
      return Image.asset(
        "images/no_banner.png",
        width: 50.0,
        height: 50.0,
        fit: BoxFit.cover,
      );
    } else {
      return Image.network(
        IMAGE_URL + responseData.path3,
        width: 50.0,
        height: 50.0,
        fit: BoxFit.cover,
      );
    }
  }
}
