
import 'package:flutter/material.dart';
import 'dart:io';

class SmartDrawer extends StatefulWidget {
  final double elevation;
  final Widget child;
  final String semanticLabel;
  final double widthPercent;
  ///add start
  final DrawerCallback callback;
  ///add end

  const SmartDrawer({
    Key key,
    this.elevation = 16.0,
    this.child,
    this.semanticLabel,
    this.widthPercent,
    ///add start
    this.callback,
    ///add end
  })  :super(key: key);
  @override
  _SmartDrawerState createState() => _SmartDrawerState();
}

class _SmartDrawerState extends State<SmartDrawer> {

  @override
  void initState() {
    ///add start
    if(widget.callback!=null){
      widget.callback(true);

    }
    ///add end
    super.initState();
  }
  @override
  void dispose() {
    ///add start
    if(widget.callback!=null){
      widget.callback(false);
    }
    ///add end
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterialLocalizations(context));
    String label = widget.semanticLabel;

    if(Platform.isIOS){
      label = widget.semanticLabel;
    }else if(Platform.isAndroid){
      label = widget.semanticLabel ?? MaterialLocalizations.of(context)?.drawerLabel;
    }else if(Platform.isFuchsia){
      label = widget.semanticLabel ?? MaterialLocalizations.of(context)?.drawerLabel;
    }


    return Semantics(
      scopesRoute: true,
      namesRoute: true,
      explicitChildNodes: true,
      label: label,
      child: ConstrainedBox(
        constraints: BoxConstraints.expand(width:250.0),
        child: Material(
          elevation: widget.elevation,
          child: widget.child,
        ),
      ),
    );
  }
}