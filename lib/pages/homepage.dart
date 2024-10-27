import 'package:flutter/material.dart';
import 'package:pingme/components/mydrawer.dart';
import 'package:pingme/features/recordings/audiorecordings/audio_recording.dart';
import 'package:pingme/utils/color_hexing.dart';
import 'package:pingme/features/alarm/alarm_manager.dart';
import 'package:pingme/services/permission_handler.dart';
import 'package:vibration/vibration.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  bool isOn = false;
  bool permissionsGranted = false;
  final AlarmService _alarmService = AlarmService();
  final AudioRecording _audioRecording = AudioRecording();
  String recordingStatus = 'Not Recording';

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    permissionsGranted = await requestPermissions(context);
    setState(() {});
  }

  Future<void> _toggleAlarmAndRecording() async {
    if (!permissionsGranted) {
      permissionsGranted = await requestPermissions(context);
      if (!permissionsGranted) {
        print("Permissions not granted");
        return;
      }
    }

    setState(() {
      isOn = !isOn;
    });

    if (isOn) {
      await _startAlarmAndRecording();
    } else {
      await _stopAlarmAndRecording();
    }
  }

  Future<void> _startAlarmAndRecording() async {
    print("Starting alarm and recording");
    // Use vibration instead of sound alarm
    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate(duration: 1000, amplitude: 128);
    }
    await _audioRecording.startRecording(context);
    setState(() {
      recordingStatus = 'Recording...';
    });
  }

  Future<void> _stopAlarmAndRecording() async {
    print("Stopping alarm and recording");
    Vibration.cancel(); // Stop vibration
    String? filePath = await _audioRecording.stopRecording();
    setState(() {
      recordingStatus =
          filePath != null ? 'Record saved' : 'Recording failed to save';
    });
    if (filePath != null) {
      print("Recording saved: $filePath");
    } else {
      print("Failed to save recording");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: "#4B39EF".toColor(),
        title: const Text(
          "PingMe",
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
          ),
        ),
        centerTitle: true,
        actions: [
          Builder(
            builder: (context) {
              return IconButton(
                icon: const Icon(Icons.menu, color: Colors.white),
                onPressed: () {
                  Scaffold.of(context).openEndDrawer();
                },
              );
            },
          ),
        ],
      ),
      endDrawer: const SizedBox(
        width: 300,
        child: MyDrawer(),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: "#4B39EF".toColor(),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              ),
              onPressed: _toggleAlarmAndRecording,
              child: Text(
                isOn ? "Turn Off" : "Turn On",
                style: const TextStyle(fontSize: 24, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                if (recordingStatus == 'Record saved') {
                  _audioRecording.showRecordingLocationDialog(context);
                }
              },
              child: Text(
                recordingStatus,
                style: const TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
