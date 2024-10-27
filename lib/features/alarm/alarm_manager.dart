import 'package:just_audio/just_audio.dart' as just_audio;

class AlarmService {
  final just_audio.AudioPlayer _audioPlayer = just_audio.AudioPlayer();

  Future<void> playAlarm() async {
    await _audioPlayer.setAsset('assets/audios/alarm_sound.mp3');
    await _audioPlayer.setVolume(1.0);
    await _audioPlayer.setLoopMode(just_audio.LoopMode.one);
    await _audioPlayer.play();
  }

  void stopAlarm() {
    _audioPlayer.stop();
  }
}
