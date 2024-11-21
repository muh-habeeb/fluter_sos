import 'dart:io';
import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/intl.dart';

class AudioRecording {
  final _audioRecorder = AudioRecorder();
  String? filePath;
  bool isRecording = false;

  Future<void> startRecording(BuildContext context) async {
    try {
      bool permissionGranted = await requestMicrophonePermission(context);
      if (!permissionGranted) {
        return;
      }

      Directory? externalDir = await getExternalStorageDirectory();
      if (externalDir == null) {
        return;
      }

      String rootPath = externalDir.path.split('Android')[0];
      Directory pingMeDir = Directory('$rootPath/SafeArms');

      if (!(await pingMeDir.exists())) {
        await pingMeDir.create(recursive: true);
      }

      String dateTime = DateFormat('dd-MM-yy-HH-mm-ss').format(DateTime.now());
      String fileName = 'recording_$dateTime.m4a';
      filePath = '${pingMeDir.path}/$fileName';

      if (await _audioRecorder.hasPermission()) {
        await _audioRecorder.start(
          const RecordConfig(
            encoder: AudioEncoder.aacLc,
            bitRate: 256000, // Increased bitrate for better quality
            sampleRate: 48000, // Increased sample rate
            numChannels: 2,
            // Use the default audio source, which should be the microphone
          ),
          path: filePath!,
        );
        isRecording = true;
      } else {}
    } catch (e) {
      isRecording = false;
    }
  }

  Future<String?> stopRecording() async {
    if (!isRecording) {
      return null;
    }

    try {
      String? path = await _audioRecorder.stop();

      isRecording = false;

      if (path != null && File(path).existsSync()) {
        return path;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<bool> requestMicrophonePermission(BuildContext context) async {
    final microphoneStatus = await Permission.microphone.request();
    final storageStatus = await Permission.storage.request();

    if (microphoneStatus.isGranted && storageStatus.isGranted) {
      return true;
    } else {
      await _showPermissionDeniedDialog(context);
      return false;
    }
  }

  Future<void> _showPermissionDeniedDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Permissions Denied'),
          content: const Text(
              'Please allow microphone and storage access in your device settings to record and save audio.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Open Settings'),
              onPressed: () {
                Navigator.of(context).pop();
                openAppSettings();
              },
            ),
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void showRecordingLocationDialog(BuildContext context) {
    if (filePath != null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Recording Location'),
            content: Text(filePath!),
            actions: <Widget>[
              TextButton(
                child: const Text('Close'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {}
  }
}
