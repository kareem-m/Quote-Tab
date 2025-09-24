import 'package:audioplayers/audioplayers.dart';

class SoundEffects {

  static Future<void> done () async {
    final player = AudioPlayer();
    await player.play(AssetSource('audio/done.mp3'), volume: 0.4);
  }
}