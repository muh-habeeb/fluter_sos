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
        print("Microphone permission not granted");
        return;
      }

      Directory? externalDir = await getExternalStorageDirectory();
      if (externalDir == null) {
        print("Error: Unable to access external storage");
        return;
      }

      String rootPath = externalDir.path.split('Android')[0];
      Directory pingMeDir = Directory('$rootPath/PingMe');

      if (!(await pingMeDir.exists())) {
        await pingMeDir.create(recursive: true);
      }

      String dateTime = DateFormat('dd-MM-yy-HH-mm-ss').format(DateTime.now());
      String fileName = 'recording_$dateTime.m4a';
      filePath = '${pingMeDir.path}/$fileName';

      print("Attempting to create file: $filePath");

      if (await _audioRecorder.hasPermission()) {
        await _audioRecorder.start(
          const RecordConfig(
            encoder: AudioEncoder.aacLc,
            bitRate: 128000,
            sampleRate: 44100,
            numChannels: 2, // Stereo recording for better ambient sound capture
          ),
          path: filePath!,
        );
        isRecording = true;
        print("Recording started: $filePath");
      } else {
        print("Audio recording permission not granted");
      }
    } catch (e) {
      print("Error starting recording: $e");
      isRecording = false;
    }
  }

  Future<String?> stopRecording() async {
    if (!isRecording) {
      print("No active recording to stop");
      return null;
    }

    try {
      print("Attempting to stop recorder");
      String? path = await _audioRecorder.stop();
      print("Recording stopped. Path: $path");

      isRecording = false;

      if (path != null && File(path).existsSync()) {
        print("Recording file exists at: $path");
        return path;
      } else {
        print("Recording file does not exist or path is null");
        return null;
      }
    } catch (e) {
      print("Error stopping recording: $e");
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
    } else {
      print("No file path available to show");
    }
  }
}
