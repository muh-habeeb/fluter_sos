import 'package:flutter/material.dart';
import 'package:pingme/components/mydrawer.dart';
import 'package:pingme/features/recordings/audiorecordings/audio_recording.dart';
import 'package:pingme/utils/color_hexing.dart';
import 'package:pingme/features/alarm/alarm_manager.dart';
import 'package:pingme/services/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  bool isOn = false;
  bool permissionsGranted = false;
  bool isAlarmOn = true;
  final AlarmService _alarmService = AlarmService();
  final AudioRecording _audioRecording = AudioRecording();
  String recordingStatus = 'Not Recording';
  int countdown = 7;
  Timer? _statusResetTimer;
  Timer? _countdownTimer;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _checkPermissions();
    _loadAlarmState();
  }

  @override
  void dispose() {
    _statusResetTimer?.cancel();
    _countdownTimer?.cancel();
    super.dispose();
  }

  Future<void> _checkPermissions() async {
    permissionsGranted = await requestPermissions(context);
    setState(() {});
  }

  Future<void> _loadAlarmState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isAlarmOn = prefs.getBool('isAlarmOn') ?? true;
    });
  }

  Future<void> _toggleAlarmAndRecording() async {
    if (_isProcessing) {
      _handleQuickPress();
      return;
    }

    _isProcessing = true;

    if (!permissionsGranted) {
      permissionsGranted = await requestPermissions(context);
      if (!permissionsGranted) {
        _isProcessing = false;
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

    _isProcessing = false;
  }

  void _handleQuickPress() {
    _alarmService.stopAlarm();
    _countdownTimer?.cancel();
    setState(() {
      isOn = false;
      recordingStatus = 'Something went wrong';
    });
    _startStatusResetTimer();
  }

  Future<void> _startAlarmAndRecording() async {
    if (isAlarmOn) {
      _alarmService.playAlarm();

      _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (countdown > 0) {
          setState(() {
            recordingStatus = 'Recording will start in $countdown';
            countdown--;
          });
        } else {
          timer.cancel();
          _startRecording();
        }
      });
    } else {
      _startRecording();
    }
  }

  void _startRecording() {
    _alarmService.stopAlarm();
    _audioRecording.startRecording(context);
    setState(() {
      recordingStatus = 'Recording...';
    });
  }

  Future<void> _stopAlarmAndRecording() async {
    _alarmService.stopAlarm();
    _countdownTimer?.cancel();

    if (recordingStatus == 'Recording...') {
      String? filePath = await _audioRecording.stopRecording();
      setState(() {
        recordingStatus =
            filePath != null ? 'Record saved' : 'Recording failed to save';
      });
      if (filePath != null) {
      } else {}
    } else {
      setState(() {
        recordingStatus = 'Something went wrong';
      });
    }

    _startStatusResetTimer();
  }

  void _startStatusResetTimer() {
    _statusResetTimer?.cancel();
    _statusResetTimer = Timer(const Duration(seconds: 2), () {
      setState(() {
        recordingStatus = 'Not Recording';
        countdown = 7;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: "#4B39EF".toColor(),
        title: const Text(
          "SafeArms",
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
      endDrawer: SizedBox(
        width: 300,
        child: MyDrawer(
          onAlarmToggle: (bool value) {
            setState(() {
              isAlarmOn = value;
            });
          },
        ),
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
