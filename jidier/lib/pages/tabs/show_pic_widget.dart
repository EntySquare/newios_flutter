import 'package:flutter/material.dart';
import 'package:myflutter/pages/bean/AdressDataBean.dart';

import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:myflutter/pages/util/HttpContent.dart';

class ShowPicWidget extends StatelessWidget {
  ResponseData responseData;
  List images = List();

  ShowPicWidget({this.responseData}) : super();

  @override
  Widget build(BuildContext context) {
    this._initPages();

    return Container(
      alignment: Alignment.topLeft,
      color: Colors.black54,
      child: Stack(
        alignment: Alignment.topLeft,
        children: <Widget>[
          Swiper(
            itemCount: images.length,
            itemBuilder: (BuildContext context, int index) {
              return Image.network(
                IMAGE_URL + images[index],
                fit: BoxFit.fill,
              );
            },
            pagination: SwiperPagination(),
          ),
          GestureDetector(
            child: Padding(
                padding: EdgeInsets.fromLTRB(10.0, 40.0, 10.0, 10.0),
                child: Container(
                  color:Colors.blueGrey,
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                )),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void _initPages() {
    if (responseData.path1 != null && responseData.path1 != "0") {
      images.add(responseData.path1);
    }
    if (responseData.path2 != null && responseData.path2 != "0") {
      images.add(responseData.path2);
    }

    if (responseData.path3 != null && responseData.path3 != "0") {
      images.add(responseData.path3);
    }
  }
}
