import 'sound/primex_sound_player_stub.dart'
    if (dart.library.html) 'sound/primex_sound_player_web.dart'
    if (dart.library.io) 'sound/primex_sound_player_io.dart';

class PrimeXSoundService {
  static Future<void> bell() => PrimeXSoundPlayer.play('bell.mp3');
  static Future<void> message() =>
      PrimeXSoundPlayer.play('message_received.mp3');
  static Future<void> call() => PrimeXSoundPlayer.play('incoming_call.mp3');
}
