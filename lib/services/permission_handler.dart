// import 'package:flutter/material.dart';
// import 'package:permission_handler/permission_handler.dart';

// Future<bool> requestMicrophonePermission(BuildContext context) async {
//   final status = await Permission.microphone.request();

//   if (status.isGranted) {
//     // Permission granted, proceed with recording
//     return true;
//   } else {
//     // Handle permission denial
//     await _showPermissionDeniedDialog(context);
//     return false;
//   }
// }

// Future<void> _showPermissionDeniedDialog(BuildContext context) async {
//   return showDialog<void>(
//     context: context,
//     barrierDismissible: false, // User must tap button to close
//     builder: (BuildContext context) {
//       return AlertDialog(
//         title: const Text('Microphone Permission Denied'),
//         content: const Text(
//           'Please allow microphone access in your device settings to store recordings.',
//         ),
//         actions: <Widget>[
//           TextButton(
//             child: const Text('Open Settings'),
//             onPressed: () {
//               Navigator.of(context).pop(); // Close the dialog
//               openAppSettings(); // Open app settings
//             },
//           ),
//           TextButton(
//             child: const Text('Cancel'),
//             onPressed: () {
//               Navigator.of(context).pop(); // Close the dialog
//             },
//           ),
//         ],
//       );
//     },
//   );
// }

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   _HomePageState createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   @override
//   void initState() {
//     super.initState();
//     requestPermissions(
//         context); // Request permissions on home page initialization
//   }

Future<bool> requestPermissions(BuildContext context) async {
  // Define the permissions you want to request
  final List<Permission> permissions = [
    Permission.microphone,
    Permission.storage,
    Permission.manageExternalStorage, // For Android 11+
  ];

  // Check and request each permission
  for (Permission permission in permissions) {
    final status = await permission.request();

    if (status.isDenied || status.isPermanentlyDenied) {
      // If permission is denied or permanently denied, show a dialog
      await _showPermissionDeniedDialog(context);
      return false; // Exit the function if any permission is denied
    }
  }
  return true; // Return true if all permissions are granted
}

Future<void> _showPermissionDeniedDialog(BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // User must tap a button to close
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Permissions Required'),
        content: const Text(
          'This app requires microphone and storage permissions to function correctly. '
          'Please allow these permissions in your device settings.',
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Open Settings'),
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
              openAppSettings(); // Open app settings for permission management
            },
          ),
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
              requestPermissions(context); // Re-ask for permissions
            },
          ),
        ],
      );
    },
  );
}
