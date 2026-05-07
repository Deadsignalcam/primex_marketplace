import 'package:audioplayers/audioplayers.dart';

final player = AudioPlayer();

Future<void> playAlert() async {
  await player.play(AssetSource('sounds/alert.wav'));
}
