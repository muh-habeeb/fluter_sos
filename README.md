# pingme

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

````shell
lib/
├── components/
│ └── mydrawer.dart # Custom drawer component
│
├── utils/
│ └── color_hexing.dart # Utility for hex color conversions
│
├── features/
│ ├── alarm/
│ │ └── alarm_manager.dart # Manages alarm functionalities
│ │
│ ├── recording/
│ ├── audiorecordings/
│ │ └── audiorecording.dart # Manages audio recording functionalities
│
├── pages/
│ ├── homepage.dart # Main home screen with alarm and recording features
│ └── updateinfo.dart # Update information screen
│
└── services/
└──
```text

    permisionhandler.dart # Handles app permissions (microphone, storage, etc.)
    This updated code does the following:
    When the user clicks the "Turn On" button:
    The alarm starts playing.
    Background recording begins.
    The button text changes to "Turn Off".
    The recording status is updated to indicate that recording is in progress.
    When the user clicks the "Turn Off" button:
    The alarm stops.
    The recording stops and is saved.
    The button text changes back to "Turn On".
    The recording status is updated to show the saved file path or an error message if saving failed.
    The recording is saved in the format and location you specified (emulated/0/music/PingMe/filename with the date-time format).
    Permissions are checked at the start and before each recording attempt.
    The existing design is maintained, with only functional changes made to implement the new features.
    This implementation should meet your requirements while maintaining the existing UI design. Make sure that the AudioRecording, AlarmService, and permission handling classes are properly implemented to support these features.
    "# fluter_sos"
````

in the update info i added 2 text filed 1 for name and 1 for phone number
now if a user enter information in that
