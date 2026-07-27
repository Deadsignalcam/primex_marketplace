import 'dart:html' as html;

class PrimeXSoundPlayer {
  static Future<void> play(String file) async {
    final audio = html.AudioElement('assets/assets/sounds/$file')
      ..preload = 'auto'
      ..volume = 1.0;
    audio.currentTime = 0;
    await audio.play();
  }
}
