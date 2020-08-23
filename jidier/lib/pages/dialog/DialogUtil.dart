import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:myflutter/pages/dialog/NetLoadingDialog.dart';

showLogingNetRequest(contex, String loadingText, Function netRequest) {
  showDialog(
      context: contex,
      barrierDismissible: false,
      builder: (_) {
        return new NetLoadingDialog(
          requestCallBack: netRequest(),
          outsideDismiss: false,
        );
      });
}
