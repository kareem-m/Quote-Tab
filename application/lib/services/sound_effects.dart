import 'package:audioplayers/audioplayers.dart';

class SoundEffects {
  static Future<void> done() async {
    final player = AudioPlayer();

    await player.play(
      AssetSource('audio/done.mp3'),
      volume: 0.4,
      //عشان اخلي الصوت يشتعل حتى وفي اغنية شغالة مثلا
      ctx: AudioContext(
        android: AudioContextAndroid(
          contentType: AndroidContentType.sonification,
          audioFocus: AndroidAudioFocus.gainTransientMayDuck
        ),
      ),
    );
  }
}