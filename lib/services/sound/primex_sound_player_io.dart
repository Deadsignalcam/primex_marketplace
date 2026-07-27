import 'package:audioplayers/audioplayers.dart';

class PrimeXSoundPlayer {
  static Future<void> play(String file) async {
    final player = AudioPlayer();
    await player.play(AssetSource('sounds/$file'));
  }
}
