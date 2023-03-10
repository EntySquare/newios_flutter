/*
 * QR.Flutter
 * Copyright (c) 2019 the QR.Flutter authors.
 * See LICENSE for distribution and usage details.
 */

import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:myflutter/pages/widget/QrPainter.dart'as my ;
import 'package:qr/qr.dart';
import 'package:qr_flutter/qr_flutter.dart';

/// A widget that shows a QR code.
class QrImage extends StatefulWidget {
  /// Create a new QR code using the [String] data and the passed options (or
  /// using the default options).
  QrImage({
    @required String data,
    Key key,
    this.size,
    this.padding = const EdgeInsets.all(10.0),
    this.backgroundColor = const Color(0x00FFFFFF),
    this.foregroundColor = const Color(0xFF000000),
    this.version = QrVersions.auto,
    this.errorCorrectionLevel = QrErrorCorrectLevel.L,
    this.errorStateBuilder,
    this.constrainErrorBounds = true,
    this.gapless = true,
    this.embeddedImage,
    this.embeddedImageStyle,
    this.embeddedImageEmitsError = false,
    this.imageCallBack,
    this.address,
  })  : assert(QrVersions.isSupportedVersion(version)),
        _data = data,
        qrCode = null,
        super(key: key);
  var imageCallBack;
  String address;

  /// Create a new QR code using the [QrCode] data and the passed options (or
  /// using the default options).
  QrImage.withQr({
    @required QrCode qr,
    Key key,
    this.size,
    this.padding = const EdgeInsets.all(10.0),
    this.backgroundColor = const Color(0x00FFFFFF),
    this.foregroundColor = const Color(0xFF000000),
    this.version = QrVersions.auto,
    this.errorCorrectionLevel = QrErrorCorrectLevel.L,
    this.errorStateBuilder,
    this.constrainErrorBounds = true,
    this.gapless = true,
    this.embeddedImage,
    this.embeddedImageStyle,
    this.embeddedImageEmitsError = false,
    this.imageCallBack,
  })  : assert(QrVersions.isSupportedVersion(version)),
        _data = null,
        qrCode = qr,
        super(key: key);

  // The data passed to the widget
  final String _data;

  // The QR code data passed to the widget
  final QrCode qrCode;

  /// The background color of the final QR code widget.
  final Color backgroundColor;

  /// The foreground color of the final QR code widget.
  final Color foregroundColor;

  /// The QR code version to use.
  final int version;

  /// The QR code error correction level to use.
  final int errorCorrectionLevel;

  /// The external padding between the edge of the widget and the content.
  final EdgeInsets padding;

  /// The intended size of the widget.
  final double size;

  /// The callback that is executed in the event of an error so that you can
  /// interrogate the exception and construct an alternative view to present
  /// to your user.
  final QrErrorBuilder errorStateBuilder;

  /// If `true` then the error widget will be constrained to the boundary of the
  /// QR widget if it had been valid. If `false` the error widget will grow to
  /// the size it needs. If the error widget is allowed to grow, your layout may
  /// jump around (depending on specifics).
  ///
  /// NOTE: Setting a [size] value will override this setting and both the
  /// content widget and error widget will adhere to the size value.
  final bool constrainErrorBounds;

  /// If set to false, each of the squares in the QR code will have a small
  /// gap. Default is true.
  final bool gapless;

  /// The image data to embed (as an overlay) in the QR code. The image will
  /// be added to the center of the QR code.
  final ImageProvider embeddedImage;

  /// Styling options for the image overlay.
  final QrEmbeddedImageStyle embeddedImageStyle;

  /// If set to true and there is an error loading the embedded image, the
  /// [errorStateBuilder] callback will be called (if it is defined). If false,
  /// the widget will ignore the embedded image and just display the QR code.
  /// The default is false.
  final bool embeddedImageEmitsError;

  @override
  _QrImageState createState() => _QrImageState(imageCallBack, address);
}

class _QrImageState extends State<QrImage> {
  /// The QR code string data.
  QrCode _qr;

  /// The current validation status.
  QrValidationResult _validationResult;
  var _imagCallBack;
  String _address;

  _QrImageState(imageCallBack, address) {
    this._imagCallBack = imageCallBack;
    this._address = address;
  }

  @override
  Widget build(BuildContext context) {
    if (widget._data != null) {
      _validationResult = QrValidator.validate(
        data: widget._data,
        version: widget.version,
        errorCorrectionLevel: widget.errorCorrectionLevel,
      );
      if (_validationResult.isValid) {
        _qr = _validationResult.qrCode;
      } else {
        _qr = null;
      }
    } else if (widget.qrCode != null) {
      _qr = widget.qrCode;
      _validationResult =
          QrValidationResult(status: QrValidationStatus.valid, qrCode: _qr);
    }
    return LayoutBuilder(builder: (context, constraints) {
      // validation failed, show an error state widget if builder is present.
      if (!_validationResult.isValid) {
        return _errorWidget(context, constraints, _validationResult.error);
      }
      // no error, build the regular widget
      final widgetSize = widget.size ?? constraints.biggest.shortestSide;
      if (widget.embeddedImage != null) {
        // if requesting to embed an image then we need to load via a
        // FutureBuilder because the image provider will be async.
        var loadQrImage = _loadQrImage(context, widget.embeddedImageStyle);
        loadQrImage.then((image) {});

        return FutureBuilder(
          future: loadQrImage,
          builder: (ctx, snapshot) {
            if (snapshot.error != null) {
              if (widget.embeddedImageEmitsError) {
                return _errorWidget(context, constraints, snapshot.error);
              } else {
                return _qrWidget(context, null, widgetSize);
              }
            }
            if (snapshot.hasData) {
              final ui.Image loadedImage = snapshot.data;
              return _qrWidget(context, loadedImage, widgetSize);
            } else {
              return Container();
            }
          },
        );
      } else {
        return _qrWidget(context, null, widgetSize);
      }
    });
  }

  Widget _qrWidget(BuildContext context, ui.Image image, double edgeLength) {
    final painter = my.QrPainter.withQr(
      qr: _qr,
      color: widget.foregroundColor,
      gapless: widget.gapless,
      embeddedImageStyle: widget.embeddedImageStyle,
      embeddedImage: image,
      address: this._address,
    );
    painter.toImage(220).then((myImage) {
      this._imagCallBack(myImage);
    });

    return _QrContentView(
      edgeLength: edgeLength,
      backgroundColor: widget.backgroundColor,
      padding: widget.padding,
      child: CustomPaint(painter: painter),
    );
  }

  Widget _errorWidget(
      BuildContext context, BoxConstraints constraints, Object error) {
    final errorWidget = widget.errorStateBuilder == null
        ? Container()
        : widget.errorStateBuilder(context, error) ?? Container();
    final errorSideLength = (widget.constrainErrorBounds
        ? widget.size ?? constraints.biggest.shortestSide
        : constraints.biggest.longestSide);
    return _QrContentView(
      edgeLength: errorSideLength,
      backgroundColor: widget.backgroundColor,
      padding: widget.padding,
      child: errorWidget,
    );
  }

  Future<ui.Image> _loadQrImage(
      BuildContext buildContext, QrEmbeddedImageStyle style) async {
    if (style != null) {}

    final mq = MediaQuery.of(buildContext);
    final completer = Completer<ui.Image>();
    final stream = widget.embeddedImage.resolve(ImageConfiguration(
      devicePixelRatio: mq.devicePixelRatio,
    ));
    stream.addListener(ImageStreamListener((info, err) {
      completer.complete(info.image);
    }, onError: (dynamic err, _) {
      completer.completeError(err);
    }));
    return completer.future;
  }
}

typedef QrErrorBuilder = Widget Function(BuildContext context, Object error);

class _QrContentView extends StatelessWidget {
  _QrContentView({
    @required this.edgeLength,
    @required this.child,
    this.backgroundColor,
    this.padding,
  });

  /// The length of both edges (because it has to be a square).
  final double edgeLength;

  /// The background color of the containing widget.
  final Color backgroundColor;

  /// The padding that surrounds the child widget.
  final EdgeInsets padding;

  /// The child widget.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: edgeLength,
      height: edgeLength,
      color: backgroundColor,
      child: Padding(
        padding: padding,
        child: child,
      ),
    );
  }
}
