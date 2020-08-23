import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'RegularUtil.dart';
import 'Toast.dart';

class TextSpanUtil {
  static const platform = const MethodChannel("jidier");

  static Future<TextSpan> buildTextSpan(context, String text) async {
    TextStyle style = TextStyle(fontSize: 14.0, color: Color(0xff333333));
    TextStyle linkStyle;
    linkStyle = Theme.of(context)
        .textTheme
        .body1
        .merge(style)
        .copyWith(
          color: Colors.blueAccent,
          fontSize: 16.0,
          decoration: TextDecoration.underline,
        )
        .merge(linkStyle);
    if (text.isEmpty) {
      return TextSpan(text: "", style: style);
    }

    if (!RegularUtil.isContainPhoneNum(text) && (!RegularUtil.isUrl(text))) {
      List<TextSpan> spans = List<TextSpan>();
      TextSpan remark = TextSpan(
          text: "备注：",
          style: TextStyle(
              fontSize: 14, color: Colors.red, fontWeight: FontWeight.bold));
      spans.add(remark);
      spans.add(TextSpan(text: text, style: style));
      return TextSpan(children: spans);
    }

    List result = RegularUtil.getCutPhoneList(
        text); // platform.invokeListMethod("phone", text);

    if (result == null || result.length == 0) {
      return TextSpan(text: "", style: style);
    }

    return TextSpan(children: getPans(result, style, linkStyle, context));
  }

  static TextSpan buildTextSpanNoasy(context, String text) {
    TextStyle style = TextStyle(fontSize: 14.0, color: Color(0xff333333));
    TextStyle linkStyle;
    linkStyle = Theme.of(context)
        .textTheme
        .body1
        .merge(style)
        .copyWith(
          color: Colors.blueAccent,
          fontSize: 16.0,
          decoration: TextDecoration.underline,
        )
        .merge(linkStyle);
    if (text.isEmpty) {
      return TextSpan(text: "", style: style);
    }

    if (!RegularUtil.isContainPhoneNum(text) && (!RegularUtil.isUrl(text))) {
      List<TextSpan> spans = List<TextSpan>();
      spans.add(TextSpan(text: text, style: style));
      return TextSpan(children: spans);
    }
    List result = RegularUtil.getCutPhoneList(
        text); // platform.invokeListMethod("phone", text);

    if (result == null || result.length == 0) {
      return TextSpan(text: "", style: style);
    }
    List<TextSpan> spans = getPans(result, style, linkStyle, context);
    spans.removeAt(0);
    return TextSpan(children: spans);
  }

  static List<TextSpan> getPans(
      List result, TextStyle style, TextStyle linkStyle, context) {
    List<TextSpan> spans = List<TextSpan>();
    TextSpan remark = TextSpan(
        text: "备注：",
        style: TextStyle(
            fontSize: 14, color: Colors.red, fontWeight: FontWeight.bold));
    spans.add(remark);
    for (String content in result) {
      if (RegularUtil.isCallnum(content)) {
        spans.add(TextSpan(
            text: content,
            style: linkStyle,
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                //Toast.toast(context,msg:content);
                String numStr = content.replaceAll("-", "");
                numStr = numStr.replaceAll("转", "");
                numStr = numStr.replaceAll("|", "");
                platform.invokeMethod("callPhone", numStr);
              }));
      } else if (RegularUtil.isUrl(content)) {
        spans.add(TextSpan(
            text: content,
            style: linkStyle,
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                //Toast.toast(context, msg: "url$content");
                platform.invokeListMethod("openUrl", content);
              }));
      } else {
        spans.add(TextSpan(text: content, style: style));
      }
    }
    return spans;
  }
}
