library flutter_radio_button_group;

import 'package:flutter/material.dart';
import 'package:myflutter/pages/util/GoWaysUtil.dart';

class MyFlutterRadioButtonGroup extends StatefulWidget {
  final List<String> items;
  final double size;
  final Color activeColor;
  final Color checkColor;
  final double distanceToNextItem;
  final double distanceToCheckBox;
  final Color borderColor;
  final double borderSize;
  final IconData checkIcon;
  final double checkIconSize;
  final Color checkIconColor;
  final TextStyle textStyle;
  final Color uncheckedFillColor;
  final double uncheckedIconSize;
  final Color uncheckedIconColor;
  final IconData uncheckedIcon;
  final int defaultIndex;
  final void Function(String selected) onSelected;

  MyFlutterRadioButtonGroup(
      {@required this.items,
      @required this.onSelected,
      this.size,
      this.activeColor,
      this.checkColor,
      this.distanceToNextItem,
      this.borderColor,
      this.distanceToCheckBox,
      this.borderSize,
      this.checkIcon,
      this.checkIconColor,
      this.checkIconSize,
      this.textStyle,
      this.uncheckedFillColor,
      this.uncheckedIcon,
      this.uncheckedIconColor,
      this.uncheckedIconSize,
      this.defaultIndex});

  @override
  _MyFlutterRadioButtonGroupState createState() =>
      _MyFlutterRadioButtonGroupState(
          this.items,
          this.onSelected,
          this.size,
          this.activeColor,
          this.checkColor,
          this.distanceToNextItem,
          this.borderColor,
          this.distanceToCheckBox,
          this.borderSize,
          this.checkIcon,
          this.checkIconColor,
          this.checkIconSize,
          this.textStyle,
          this.uncheckedFillColor,
          this.uncheckedIcon,
          this.uncheckedIconColor,
          this.uncheckedIconSize,
          this.defaultIndex);
}

class _MyFlutterRadioButtonGroupState extends State<MyFlutterRadioButtonGroup> {
  int checked = 0;

  final List<String> items;
  final double size;
  final Color activeColor;
  final Color checkColor;
  final double distanceToNextItem;
  final double distanceToCheckBox;
  final Color borderColor;
  final double borderSize;
  final IconData checkIcon;
  final double checkIconSize;
  final Color checkIconColor;
  final TextStyle textStyle;
  final Color uncheckedFillColor;
  final double uncheckedIconSize;
  final Color uncheckedIconColor;
  final IconData uncheckedIcon;

  final void Function(String selected) onSelected;

  _MyFlutterRadioButtonGroupState(
      this.items,
      this.onSelected,
      this.size,
      this.activeColor,
      this.checkColor,
      this.distanceToNextItem,
      this.borderColor,
      this.distanceToCheckBox,
      this.borderSize,
      this.checkIcon,
      this.checkIconColor,
      this.checkIconSize,
      this.textStyle,
      this.uncheckedFillColor,
      this.uncheckedIcon,
      this.uncheckedIconColor,
      this.uncheckedIconSize,
      this.checked);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  List<Widget> returnWidgets() {
    List<Widget> result = List();
    for (int i = 0; i < items.length; i++) {
      result.add(Padding(
        padding: EdgeInsets.only(
            bottom: i == items.length - 1 ? 0.0 : 8.0, right: 20.0),
        child: GestureDetector(
          onTap: () {
            setState(() {
              checked = i;
            });
            onSelected(items[i].toString());
          },
          child: Row(
            children: <Widget>[
              ClipOval(
                child: SizedBox(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: borderSize == null ? 1.0 : borderSize,
                        color: borderColor == null
                            ? Colors.grey[500]
                            : borderColor ?? Colors.transparent,
                      ),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    width: size == null ? 25.0 : size,
                    height: size == null ? 25.0 : size,
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: checked == i
                            ? activeColor == null ? Colors.green : activeColor
                            : uncheckedFillColor,
                      ),
                      child: Center(
                        child: checked == i
                            ? Icon(
                                checkIcon == null ? Icons.check : checkIcon,
                                color: checkIconColor == null
                                    ? Colors.white
                                    : checkIconColor,
                                size: checkIconSize == null
                                    ? 20.0
                                    : checkIconSize,
                              )
                            : uncheckedIcon == null
                                ? Container()
                                : Center(
                                    child: Icon(
                                      uncheckedIcon,
                                      color: uncheckedIconColor == null
                                          ? Colors.grey
                                          : uncheckedIconColor,
                                      size: uncheckedIconSize == null
                                          ? 20.0
                                          : uncheckedIconSize,
                                    ),
                                  ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                  padding: EdgeInsets.all(
                      distanceToCheckBox == null ? 4.0 : distanceToCheckBox)),
              Text(
                "${items[i]}",
                style: textStyle,
              )
            ],
          ),
        ),
      ));
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    Future<int> future = GoWaysUtil.getGoWay();
    future.then((way) {
      setState(() {
        this.checked = way ?? 0;
      });
    });

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: returnWidgets(),
    );
  }
}
