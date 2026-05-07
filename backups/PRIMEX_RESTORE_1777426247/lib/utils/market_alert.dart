import 'package:audioplayers/audioplayers.dart';

class MarketAlert {
  static final AudioPlayer _player = AudioPlayer();

  static Future<void> playBell() async {
    await _player.play(AssetSource('sounds/bell.mp3'));
  }
}
