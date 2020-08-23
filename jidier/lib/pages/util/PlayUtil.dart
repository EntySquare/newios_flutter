import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:audioplayers/audio_cache.dart';

class PlayUtil {
  static AudioCache _audioCache;

  static playStart(String fileName) async {
    if (_audioCache == null) {
      _audioCache = AudioCache();
    }

    _audioCache.play(fileName);
  }

  static playRealse() {
    if (_audioCache != null) {
      _audioCache.clearCache();
    }
  }
}
