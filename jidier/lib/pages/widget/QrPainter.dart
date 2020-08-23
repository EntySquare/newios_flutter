/*
 * QR.Flutter
 * Copyright (c) 2019 the QR.Flutter authors.
 * See LICENSE for distribution and usage details.
 */

import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:qr/qr.dart';
import 'package:qr_flutter/qr_flutter.dart';


// ignore_for_file: deprecated_member_use_from_same_package

const _finderPatternLimit = 7;

// default color for the qr code pixels
const _qrDefaultColor = Color(0xff111111);

/// A [CustomPainter] object that you can use to paint a QR code.
class QrPainter extends CustomPainter {
  /// Create a new QRPainter with passed options (or defaults).
  QrPainter({
    @required String data,
    @required this.version,
    this.errorCorrectionLevel = QrErrorCorrectLevel.L,
    this.color = _qrDefaultColor,
    this.emptyColor,
    this.gapless = false,
    this.embeddedImage,
    this.embeddedImageStyle,
  }) : assert(QrVersions.isSupportedVersion(version)) {
    _init(data);
  }

  /// Create a new QrPainter with a pre-validated/created [QrCode] object. This
  /// constructor is useful when you have a custom validation / error handling
  /// flow or for when you need to pre-validate the QR data.
  QrPainter.withQr({
    QrCode qr,
    String address,
    this.color = _qrDefaultColor,
    this.emptyColor,
    this.gapless = false,
    this.embeddedImage,
    this.embeddedImageStyle,

  })
      : _qr = qr,
        version = qr.typeNumber,
        errorCorrectionLevel = qr.errorCorrectLevel {
    _calcVersion = version;
    _address=address;
    _initPaints();
  }

  /// The QR code version.
  final int version; // the qr code version

  /// The error correction level of the QR code.
  final int errorCorrectionLevel; // the qr code error correction level

  /// The color of the squares.
  final Color color; // the color of the dark squares

  /// The color of the non-squares (background).
  @Deprecated(
      'You should us the background color value of your container widget')
  final Color emptyColor; // the other color
  /// If set to false, the painter will leave a 1px gap between each of the
  /// squares.
  final bool gapless;

  /// The image data to embed (as an overlay) in the QR code. The image will
  /// be added to the center of the QR code.
  final ui.Image embeddedImage;

  /// Styling options for the image overlay.
  final QrEmbeddedImageStyle embeddedImageStyle;

  /// The base QR code data
  QrCode _qr;
  String _address;
  /// This is the version (after calculating) that we will use if the user has
  /// requested the 'auto' version.
  int _calcVersion;

  /// The size of the 'gap' between the pixels
  final double _gapSize = 0.25;

  /// Cache for all of the [Paint] objects.
  final _paintCache = PaintCache();

  void _init(String data) {
    if (!QrVersions.isSupportedVersion(version)) {
      throw QrUnsupportedVersionException(version);
    }
    // configure and make the QR code data
    final validationResult = QrValidator.validate(
      data: data,
      version: version,
      errorCorrectionLevel: errorCorrectionLevel,
    );
    if (!validationResult.isValid) {
      throw validationResult.error;
    }
    _qr = validationResult.qrCode;
    _calcVersion = _qr.typeNumber;
    _initPaints();
  }

  void _initPaints() {
    // Cache the pixel paint object. For now there is only one but we might
    // expand it to multiple later (e.g.: different colours).
    _paintCache.cache(
        Paint()
          ..style = PaintingStyle.fill, QrCodeElement.codePixel);
    // Cache the finder pattern painters. We'll keep one for each one in case
    // we want to provide customization options later.
    for (final position in FinderPatternPosition.values) {
      _paintCache.cache(Paint()
        ..style = PaintingStyle.stroke,
          QrCodeElement.finderPatternOuter,
          position: position);
      _paintCache.cache(
          Paint()
            ..style = PaintingStyle.fill, QrCodeElement.finderPatternInner,
          position: position);
    }
  }

  @override
  void paint(Canvas canvas, Size mysize) {
    Size size = Size(190.0, 190.0);

    // if the widget has a zero size side then we cannot continue painting.
    if (size.shortestSide == 0) {
      print("[QR] WARN: width or height is zero. You should set a 'size' value "
          "or nest this painter in a Widget that defines a non-zero size");
      return;
    }
    // DEPRECATED: the `emptyColor` property will be removed soon
    if (emptyColor != null) {
      canvas.drawColor(emptyColor, BlendMode.color);
    }

    final paintMetrics = _PaintMetrics(
      containerSize: size.shortestSide,
      moduleCount: _qr.moduleCount,
      gapSize: (gapless ? 0 : _gapSize),
    );

    // 矩形的长宽
    // Size size = Size(200, 300);
// 矩形左上角的坐标
    Offset offset = Offset(0, 0);
// 合成Rect，为什么可以这样合成？ 官方给的！看下边---> 
    Rect rect = offset & mysize;
    canvas.drawRect(
        rect,
        Paint()
          ..color = Colors.white
          ..strokeWidth = 3.0);

    drawText("", canvas);

    drawAdressText(this._address, canvas);
     paintMetrics._inset=paintMetrics.inset+10.0;

    // draw the finder pattern elements
    _drawFinderPatternItem(FinderPatternPosition.topLeft, canvas, paintMetrics);
    _drawFinderPatternItem(
        FinderPatternPosition.bottomLeft, canvas, paintMetrics);
    _drawFinderPatternItem(
        FinderPatternPosition.topRight, canvas, paintMetrics);

    // DEBUG: draw the inner content boundary
//    final paint = Paint()..style = ui.PaintingStyle.stroke;
//    paint.strokeWidth = 1;
//    paint.color = const Color(0x55222222);
//    canvas.drawRect(
//        Rect.fromLTWH(paintMetrics.inset, paintMetrics.inset,
//            paintMetrics.innerContentSize, paintMetrics.innerContentSize),
//        paint);

    double left;
    double top;
    final gap = !gapless ? _gapSize : 0;
    final pixelPaint = _paintCache.firstPaint(QrCodeElement.codePixel);
    pixelPaint.color = color;
    for (var x = 0; x < _qr.moduleCount; x++) {
      for (var y = 0; y < _qr.moduleCount; y++) {
        // draw the finder patterns independently
        if (_isFinderPatternPosition(x, y)) continue;
        // paint an 'on' pixel
        if (_qr.isDark(y, x)) {
          left = paintMetrics.inset + (x * (paintMetrics.pixelSize + gap));
          top = paintMetrics.inset + (y * (paintMetrics.pixelSize + gap));
          var pixelHTweak = 0.0;
          var pixelVTweak = 0.0;
          if (gapless && _hasAdjacentHorizontalPixel(x, y, _qr.moduleCount)) {
            pixelHTweak = 0.5;
          }
          if (gapless && _hasAdjacentVerticalPixel(x, y, _qr.moduleCount)) {
            pixelVTweak = 0.5;
          }
          final squareRect = Rect.fromLTWH(
            left,
            top,
            paintMetrics.pixelSize + pixelHTweak,
            paintMetrics.pixelSize + pixelVTweak,
          );
          canvas.drawRect(squareRect, pixelPaint);
        }
      }
    }

    if (embeddedImage != null) {
      final originalSize = Size(
        embeddedImage.width.toDouble(),
        embeddedImage.height.toDouble(),
      );
      final requestedSize =
      embeddedImageStyle != null ? embeddedImageStyle.size : null;
      final imageSize = _scaledAspectSize(size, originalSize, requestedSize);
      final position = Offset(
        (size.width - imageSize.width) / 2.0,
        (size.height - imageSize.height) / 2.0,
      );
      // draw the image overlay.
      _drawImageOverlay(canvas, position, imageSize, embeddedImageStyle);
    }
  }

  bool _hasAdjacentVerticalPixel(int x, int y, int moduleCount) {
    if (y + 1 >= moduleCount) return false;
    return _qr.isDark(y + 1, x);
  }

  bool _hasAdjacentHorizontalPixel(int x, int y, int moduleCount) {
    if (x + 1 >= moduleCount) return false;
    return _qr.isDark(y, x + 1);
  }

  bool _isFinderPatternPosition(int x, int y) {
    final isTopLeft = (y < _finderPatternLimit && x < _finderPatternLimit);
    final isBottomLeft = (y < _finderPatternLimit &&
        (x >= _qr.moduleCount - _finderPatternLimit));
    final isTopRight = (y >= _qr.moduleCount - _finderPatternLimit &&
        (x < _finderPatternLimit));
    return isTopLeft || isBottomLeft || isTopRight;
  }

  void _drawFinderPatternItem(FinderPatternPosition position,
      Canvas canvas,
      _PaintMetrics metrics,) {
    final totalGap = (_finderPatternLimit - 1) * metrics.gapSize;
    final radius = ((_finderPatternLimit * metrics.pixelSize) + totalGap) -
        metrics.pixelSize;
    final strokeAdjust = (metrics.pixelSize / 2.0);
    final edgePos =
        (metrics.inset + metrics.innerContentSize) - (radius + strokeAdjust);

    Offset offset;
    if (position == FinderPatternPosition.topLeft) {
      offset =
          Offset(metrics.inset + strokeAdjust, metrics.inset + strokeAdjust);
    } else if (position == FinderPatternPosition.bottomLeft) {
      offset = Offset(metrics.inset + strokeAdjust, edgePos);
    } else {
      offset = Offset(edgePos, metrics.inset + strokeAdjust);
    }

    // configure the paints
    final outerPaint = _paintCache.firstPaint(QrCodeElement.finderPatternOuter,
        position: position);
    outerPaint.strokeWidth = metrics.pixelSize;
    outerPaint.color = color;

    final innerPaint = _paintCache.firstPaint(QrCodeElement.finderPatternInner,
        position: position);
    innerPaint.color = color;

    final strokeRect = Rect.fromLTWH(offset.dx, offset.dy, radius, radius);
    canvas.drawRect(strokeRect, outerPaint);
    final gapHalf = metrics.pixelSize;
    final gap = gapHalf * 2;
    final innerSize = radius - gap - (2 * strokeAdjust);
    final innerRect = Rect.fromLTWH(offset.dx + gapHalf + strokeAdjust,
        offset.dy + gapHalf + strokeAdjust, innerSize, innerSize);
    canvas.drawRect(innerRect, innerPaint);
  }

  drawText(text, canvas) {
    ParagraphBuilder pb = ParagraphBuilder(ParagraphStyle(
      textAlign: TextAlign.center, // 对齐方式
      fontWeight: FontWeight.w700, // 粗体fontStyle: FontStyle.normal, // 正常 or 斜体
      fontSize: 14.0,
    ))
      ..pushStyle(ui.TextStyle(color: Colors.black))
      ..addText('''
     扫
     码
     导
     航''');
// 绘制的宽度
    ParagraphConstraints pc =
    ParagraphConstraints(width:20.0);
    Paragraph paragraph = pb.build()
      ..layout(pc);
    canvas.drawParagraph(paragraph, Offset(202, 20));
  }


  drawAdressText(String text, canvas) {
      if(text.length>16){
        text=text.substring(0,16)+"...";
      }
    ParagraphBuilder pb = ParagraphBuilder(ParagraphStyle(
      textAlign: TextAlign.start, // 对齐方式
      fontWeight: FontWeight.w600, // 粗体fontStyle: FontStyle.normal, // 正常 or 斜体
      fontSize: 12.0,
    ))
      ..pushStyle(ui.TextStyle(color: Colors.black,))
      ..addText(text);
// 绘制的宽度
    ParagraphConstraints pc =
    ParagraphConstraints(width:300);
    Paragraph paragraph = pb.build()
      ..layout(pc);
    canvas.drawParagraph(paragraph, Offset(2.0,205.0));
  }


  bool _hasOneNonZeroSide(Size size) => size.longestSide > 0;

  Size _scaledAspectSize(Size widgetSize, Size originalSize,
      Size requestedSize) {
    if (requestedSize != null && !requestedSize.isEmpty) {
      return requestedSize;
    } else if (requestedSize != null && _hasOneNonZeroSide(requestedSize)) {
      final maxSide = requestedSize.longestSide;
      final ratio = maxSide / originalSize.longestSide;
      return Size(ratio * originalSize.width, ratio * originalSize.height);
    } else {
      final maxSide = 0.25 * widgetSize.shortestSide;
      final ratio = maxSide / originalSize.longestSide;
      return Size(ratio * originalSize.width, ratio * originalSize.height);
    }
  }

  void _drawImageOverlay(Canvas canvas, Offset position, Size size,
      QrEmbeddedImageStyle style) {
    final paint = Paint()
      ..isAntiAlias = true
      ..filterQuality = FilterQuality.high;
    if (style != null) {
      if (style.color != null) {
        paint.colorFilter = ColorFilter.mode(style.color, BlendMode.srcATop);
      }
    }
    final srcSize =
    Size(embeddedImage.width.toDouble(), embeddedImage.height.toDouble());
    final src = Alignment.center.inscribe(srcSize, Offset.zero & srcSize);
    final dst = Alignment.center.inscribe(size, position & size);
    canvas.drawImageRect(embeddedImage, src, dst, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldPainter) {
    if (oldPainter is QrPainter) {
      return color != oldPainter.color ||
          errorCorrectionLevel != oldPainter.errorCorrectionLevel ||
          _calcVersion != oldPainter._calcVersion ||
          _qr != oldPainter._qr ||
          gapless != oldPainter.gapless ||
          embeddedImage != oldPainter.embeddedImage ||
          embeddedImageStyle != oldPainter.embeddedImageStyle;
    }
    return true;
  }

  /// Returns a [ui.Picture] object containing the QR code data.
  ui.Picture toPicture(double size) {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    paint(canvas, Size(size, size));
    return recorder.endRecording();
  }

  /// Returns the raw QR code [ui.Image] object.
  Future<ui.Image> toImage(double size,
      {ui.ImageByteFormat format = ui.ImageByteFormat.png}) async {
    return await toPicture(size).toImage(size.toInt(), size.toInt());
  }

  /// Returns the raw QR code image byte data.
  Future<ByteData> toImageData(double size,
      {ui.ImageByteFormat format = ui.ImageByteFormat.png}) async {
    final image = await toImage(size, format: format);
    return image.toByteData(format: format);
  }
}

class _PaintMetrics {
  _PaintMetrics({@required this.containerSize,
    @required this.gapSize,
    @required this.moduleCount}) {
    _calculateMetrics();
  }

  final int moduleCount;
  final double containerSize;
  final double gapSize;

  double _pixelSize;

  double get pixelSize => _pixelSize;

  double _innerContentSize;

  double get innerContentSize => _innerContentSize;

  double _inset;

  double get inset => _inset;

  void _calculateMetrics() {
    final gapTotal = (moduleCount - 1) * gapSize;
    var pixelSize = (containerSize - gapTotal) / moduleCount;
    _pixelSize = (pixelSize * 2).roundToDouble() / 2;
    _innerContentSize = (_pixelSize * moduleCount) + gapTotal;
    _inset = (containerSize - _innerContentSize) / 2;
  }
}


class PaintCache {
  final List<Paint> _pixelPaints = <Paint>[];
  final Map<String, Paint> _finderPaints = <String, Paint>{};

  String _cacheKey(QrCodeElement element, {FinderPatternPosition position}) {
    final posKey = position != null ? position.toString() : 'any';
    return '${element.toString()}:$posKey';
  }

  /// Save a [Paint] for the provided element and position into the cache.
  void cache(Paint paint, QrCodeElement element,
      {FinderPatternPosition position}) {
    if (element == QrCodeElement.codePixel) {
      _pixelPaints.add(paint);
    } else if (element == QrCodeElement.finderPatternOuter ||
        element == QrCodeElement.finderPatternInner) {
      _finderPaints[_cacheKey(element, position: position)] = paint;
    }
  }

  /// Retrieve the first [Paint] object from the paint cache for the provided
  /// element and position.
  Paint firstPaint(QrCodeElement element, {FinderPatternPosition position}) {
    if (element == QrCodeElement.codePixel) {
      return _pixelPaints.first;
    } else if (element == QrCodeElement.finderPatternOuter ||
        element == QrCodeElement.finderPatternInner) {
      return _finderPaints[_cacheKey(element, position: position)];
    }
    return null;
  }

  /// Retrieve all [Paint] objects from the paint cache for the provided
  /// element and position. Note: Finder pattern elements can only have a max
  /// one [Paint] object per position. As such they will always return a [List]
  /// with a fixed size of `1`.
  List<Paint> paints(QrCodeElement element, {FinderPatternPosition position}) {
    if (element == QrCodeElement.codePixel) {
      return _pixelPaints;
    } else if (element == QrCodeElement.finderPatternOuter ||
        element == QrCodeElement.finderPatternInner) {
      return <Paint>[_finderPaints[_cacheKey(element, position: position)]];
    }
    return null;
  }
}

