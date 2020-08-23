import 'package:contact_picker/contact_picker.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:myflutter/pages/bean/LoginBean.dart';
import 'package:myflutter/pages/bean/ResponseBean2.dart';
import 'package:myflutter/pages/dialog/NetLoadingDialog3.dart';
import 'package:myflutter/pages/dialog/delet_share_contact.dart';
import 'package:myflutter/pages/dialog/input_share_phone_dialog.dart';
import 'package:myflutter/pages/dialog/send_address_successful_dialog.dart';
import 'package:myflutter/pages/util/HttpContent.dart';
import 'package:myflutter/pages/util/LoginUtil.dart';
import 'package:myflutter/pages/util/NetUtil.dart';
import 'package:myflutter/pages/util/SystemUtil.dart';
import 'package:myflutter/pages/util/Toast.dart';

/*发消息给联系人界面*/
class ShareContactsWIdget extends StatefulWidget {
  String id;

  ShareContactsWIdget({Key key, this.id}) : super(key: key);

  @override
  _ShareContactsWIdgetState createState() => _ShareContactsWIdgetState(id);
}

class _ShareContactsWIdgetState extends State<ShareContactsWIdget> {
  final ContactPicker _contactPicker = ContactPicker();
  List<Contact> selectContacts = List<Contact>();
  String _id;

  _ShareContactsWIdgetState(this._id);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        child: AppBar(
          title: Text(
            "手机联系人",
            style: TextStyle(color: Colors.white, fontSize: 16.0),
          ),
          backgroundColor: Color(0xff00afaf),
          centerTitle: true,
          actions: <Widget>[
            RaisedButton(
              onPressed: () {
                showDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (_) {
                      return DeletShareContactDialog();
                    }).then((state) {
                  if (state != null) {
                    setState(() {
                      selectContacts.clear();
                    });
                  }
                });
              },
              child: Text(
                "清空",
                style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.white,
                    fontWeight: FontWeight.w700),
              ),
              color: Color(0xff00afaf),
            )
          ],
        ),
        preferredSize:
            Size.fromHeight(SystemUtil.getScreenSize(context).height * 0.07),
      ),
      body: Container(
        color: Color(0xffeeeeee),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[getContentWidget(), getBottomWidget()],
        ),
      ),
    );
  }

  Widget getContentWidget() {
    return Expanded(
      child: Container(
        color: Color(0xffeeeeee),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(),
            Padding(
              padding: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 0.0),
              child: RaisedButton(
                onPressed: () async {
                  Contact contact = await _contactPicker.selectContact();

                  if (contact != null) {
                    if (_checkAddContactIfHave(contact)) {
                      Toast.toast(context, msg: '请不要重复添加同一联系人', showTime: 2000);
                      return;
                    }
                    setState(() {
                      selectContacts.insert(0, contact);
                    });
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    Text(
                      '添加分享联系人',
                      style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                color: Color(0xff00afaf),
              ),
            ),
            Expanded(
                child: ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return getItemContactWidget(context, index);
              },
              itemCount: selectContacts.length,
            ))
          ],
        ),
      ),
      flex: 1,
    );
  }

  bool _checkAddContactIfHave(Contact contact) {
    bool flag = false;
    for (Contact itemContact in selectContacts) {
      if (contact.fullName == itemContact.fullName &&
          contact.phoneNumber.number == itemContact.phoneNumber.number) {
        flag = true;
        break;
      }
    }

    return flag;
  }

  Widget getItemContactWidget(BuildContext context, int index) {
    Contact itemContact = selectContacts[index];
    //String phoneNum = itemContact.phoneNumber.number.replaceAll(' ', '');

    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 2.0),
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'images/ic_contact_pic.png',
                height: 40.0,
                width: 40.0,
                fit: BoxFit.cover,
              ),
              Expanded(
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: 10.0,
                          ),
                          Text(
                            itemContact.fullName,
                            style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Container(
                        height: 5.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: 10.0,
                          ),
                          Text(
                            '电话号码:',
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            itemContact.phoneNumber.number,
                            style: TextStyle(
                                fontSize: 16.0,
                                color: Color(0xff00afaf),
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                flex: 1,
              ),
              IconButton(
                  icon: Image.asset('images/ic_del.png'),
                  onPressed: () {
                    selectContacts.remove(itemContact);
                    setState(() {});
                  })
            ],
          ),
        ),
      ),
    );
  }

  /*底部按钮控件*/
  Widget getBottomWidget() {
    var Mythis = this;
    return Container(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.fromLTRB(0.0, 5.0, 20.0, 5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              onPressed: () async {
                var phone = await showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) {
                      return InputSharePhoneDialog();
                    });
                if (phone != null) {
                  _netShowSendAdressDialog(phone);
                }
              },
              color: Colors.white,
              child: Text(
                '输入手机号分享',
                style: TextStyle(
                    fontSize: 14.0,
                    color: Color(0xff00afaf),
                    fontWeight: FontWeight.bold),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  side: BorderSide(color: Color(0xff00afaf), width: 2.0)),
            ),
            Container(
              width: 30.0,
            ),
            RaisedButton(
              onPressed: () async {
                _getPhonesAndSend();
              },
              color: Color(0xff00afaf),
              child: Text(
                '点击分享',
                style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            )
          ],
        ),
      ),
    );
  }

  /*得到电话号码并分享*/
  _getPhonesAndSend() {
    String phones = '';
    if (selectContacts.length == 0) {
      Toast.toast(context, msg: '请添加分享联系人', showTime: 2000);
      return;
    } else if (selectContacts.length == 1) {
       String number=selectContacts[0].phoneNumber.number;
        number=number.trim();
         number.replaceAll(" ","");
      phones = selectContacts[0].phoneNumber.number.replaceAll(' ', '');
      if (phones.length > 11) {
        phones = phones.substring(phones.length - 11, phones.length);
      }
    } else {
      for (int i = 0; i < selectContacts.length; i++) {
        Contact contact = selectContacts[i];
        String number = contact.phoneNumber.number;
        number=number.trim();
        number = number.replaceAll(" ","");
        if (number.length > 11) {
          number = number.substring(number.length - 11, number.length);
        }
        if (i == 0) {
          phones = phones + number + ',';
        } else if (i == selectContacts.length - 1) {
          phones = phones + number;
        } else {
          phones = phones + number + ',';
        }
      }
    }
    _netShowSendAdressDialog(phones);
  }

  _netShowSendAdressDialog(String phones) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return NetLoadingDialog3(
            loadingText: '发送地址中.....',
            outsideDismiss: false,
            requestCallBack: _sendAddress(phones),
          );
        }).then((response) {
      if (response == null) {
        // Toast.toast(context, msg: '网络请求异常', showTime: 2000);
      } else {
        NetUtil.ifNetSuccessful(response, successfull: (ResponseBean2 bean) {
          _showSendAddressSuccessfulDialog();
        }, faild: (ResponseBean2 bean) {
          Toast.toast(context, msg: bean.responseData);
        });
      }
    });
  }

  bool isNet = true;

  Future<Response> _sendAddress(String phones) async {
    if (!isNet) {
      return null;
    }
    isNet = false;
    LoginBean loginBean = await LoginUtil.getLoginBean();
    try {
      Response response = await Dio().post(url + 'setAlert',
          data: {"addid": _id, "sendid": loginBean.id, 'phone': phones},
          options: Options(headers: {"AUTHORIZATION": loginBean.token}));
      isNet = true;
      return response;
    } catch (e) {
      return null;
    }
  }

  _showSendAddressSuccessfulDialog() {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (_) {
          return SendAddressSuccessfulDialog();
        }).then((state) {
      if (state != null) {
        Navigator.pop(context);
      }
    });
  }
}
