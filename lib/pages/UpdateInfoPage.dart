import 'package:flutter/material.dart';
import 'package:pingme/utils/color_hexing.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import shared_preferences

class UpdateInfoPage extends StatefulWidget {
  const UpdateInfoPage({super.key});

  @override
  _UpdateInfoPageState createState() => _UpdateInfoPageState();
}

class _UpdateInfoPageState extends State<UpdateInfoPage> {
  String name = ''; // Variable to hold the name
  String phoneNumber = ''; // Variable to hold the phone number
  bool isSaved = false; // Flag to check if details are saved

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadSavedData(); // Load saved data when the widget is initialized
  }

  Future<void> loadSavedData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('name') ?? ''; // Load name
      phoneNumber = prefs.getString('phoneNumber') ?? ''; // Load phone number
      isSaved =
          name.isNotEmpty && phoneNumber.isNotEmpty; // Check if data exists
      nameController.text = name; // Set controller text
      phoneController.text = phoneNumber; // Set controller text
    });
  }

  Future<void> saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', name); // Save name
    await prefs.setString('phoneNumber', phoneNumber); // Save phone number
  }

  void submitDetails() {
    String enteredName =
        nameController.text.toUpperCase(); // Convert name to uppercase
    String enteredPhone = phoneController.text;

    // Validate phone number length
    if (enteredPhone.length != 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Phone number must be 10 digits.')),
      );
      return;
    }

    // Validate name length
    if (enteredName.length < 3 || enteredName.length > 20) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Name must be between 3 and 20 characters.')),
      );
      return;
    }

    // Check if details are already saved
    setState(() {
      name = enteredName;
      phoneNumber = enteredPhone;
      isSaved = true; // Mark as saved
    });

    saveData(); // Save data to shared preferences

    // Optionally, clear the text fields after submission
    nameController.clear();
    phoneController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: const Text(
          'Update Info',
          style: TextStyle(fontSize: 25, color: Colors.white),
        ),
        backgroundColor: "#4B39EF".toColor(),
      ),
      body: SingleChildScrollView(
        child: ColoredBox(
          color: Colors.white,
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 100),
                const Text(
                  'Update your details!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF39D2C0),
                      width: 8,
                    ),
                  ),
                  child: const CircleAvatar(
                    radius: 100,
                    backgroundImage: NetworkImage(
                        'https://avatar.iran.liara.run/public/girl'),
                    backgroundColor: Colors.transparent,
                  ),
                ),
                const SizedBox(height: 20),
                // Display the saved details if they are saved
                if (isSaved) ...[
                  const SizedBox(height: 20), // Space before details
                  Text(
                    'Name: $name', // Display entered name
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 10), // Space between name and phone
                  Text(
                    'Receiver Phone: $phoneNumber', // Display entered phone number
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
                const SizedBox(height: 20),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    hintText: 'Enter your name',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: "#4B39EF".toColor()),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: "#4B39EF".toColor()),
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: phoneController,
                  decoration: InputDecoration(
                    hintText: 'Enter the receiver phone number',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: "#4B39EF".toColor()),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: "#4B39EF".toColor()),
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: "#4B39EF".toColor(),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    minimumSize: const Size(150, 50),
                  ),
                  onPressed: submitDetails,
                  child: const Text(
                    'Update',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
