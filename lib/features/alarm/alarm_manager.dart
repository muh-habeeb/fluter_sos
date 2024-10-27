// import 'package:audioplayers/audioplayers.dart';

// class AlarmManager {
//   static final AudioPlayer _audioPlayer = AudioPlayer();

//   static Future<void> startAlarm() async {
//     await _audioPlayer.setSource(AssetSource('assets/alarm_sound.mp3'));
//     await _audioPlayer.setVolume(1.0); // Ensure the volume is set to max
//     await _audioPlayer.setReleaseMode(ReleaseMode.loop); // Loop the alarm sound
//     await _audioPlayer.resume(); // Start playing the sound
//   }

//   static Future<void> stopAlarm() async {
//     await _audioPlayer.stop(); // Stop the sound
//   }
// }

import 'package:audioplayers/audioplayers.dart';

class AlarmService {
  final AudioPlayer _audioPlayer = AudioPlayer();

  Future<void> playAlarm() async {
    await _audioPlayer.setSource(AssetSource('audios/alarm_sound.mp3'));
    _audioPlayer.setVolume(1.0); // Set volume to maximum
    await _audioPlayer.resume(); // Start playing the audio
  }

  void stopAlarm() {
    _audioPlayer.stop(); // Stop the audio playback
  }
}
