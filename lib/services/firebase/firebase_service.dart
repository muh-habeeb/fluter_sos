// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class FirebaseService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   // Save user data to Firestore
//   Future<void> saveUserData(String name, String phoneNumber) async {
//     await _firestore.collection('users').doc(name).set({
//       'phoneNumber': phoneNumber,
//     });
//   }

//   // Load user data from Firestore
//   Future<Map<String, dynamic>?> loadUserData(String name) async {
//     DocumentSnapshot snapshot =
//         await _firestore.collection('users').doc(name).get();
//     if (snapshot.exists) {
//       return snapshot.data() as Map<String, dynamic>;
//     }
//     return null;
//   }

//   // Check if user is online and push data
//   Future<void> pushDataIfOnline(String name, String phoneNumber) async {
//     // Check if the user is online
//     // You can implement your own logic to check online status
//     bool isOnline = true; // Placeholder for online status check
//     if (isOnline) {
//       await saveUserData(name, phoneNumber);
//     } else {
//       // Store locally if offline
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       await prefs.setString('offline_name', name);
//       await prefs.setString('offline_phone', phoneNumber);
//     }
//   }

//   // Push offline data to Firestore when online
//   Future<void> pushOfflineData() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? name = prefs.getString('offline_name');
//     String? phoneNumber = prefs.getString('offline_phone');

//     if (name != null && phoneNumber != null) {
//       await saveUserData(name, phoneNumber);
//       // Clear the stored offline data
//       await prefs.remove('offline_name');
//       await prefs.remove('offline_phone');
//     }
//   }
// }
